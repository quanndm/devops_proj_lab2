BUCKET_NAME=devops-project2-terraform-tfstate
BUCKET_REGION=us-east-1

check-env:
ifndef ENV
	$(error Please set ENV=[staging|production])
endif

######## 
run-local:
	docker compose up -d

# using aws cli v.2.x
# Set default region on config file of aws is same as bucket: example: us-east-1
create-tf-backend: 
	aws s3api create-bucket  --bucket ${BUCKET_NAME}  --region ${BUCKET_REGION}  --object-ownership BucketOwnerEnforced --acl bucket-owner-full-control && aws dynamodb create-table  --table-name terraform-state --attribute-definitions  AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

# Example: make terraform-create-workspace ENV=staging 
terraform-create-workspace: check-env
	cd terraform && terraform workspace new ${ENV}

# Example:  make terraform-init ENV=staging
terraform-init: check-env
	cd terraform &&  terraform workspace select ${ENV} && terraform init

# Example: make terraform-action ENV=staging TF_ACTION=plan 
terraform-action: check-env
	cd terraform &&  terraform workspace select ${ENV} && terraform ${TF_ACTION} --var-file "./environments/common.tfvars" --var-file "./environments/${ENV}/config.tfvars"

# Example: make terraform-output ENV=staging 
terraform-output:
	cd terraform &&  terraform workspace select ${ENV} && terraform output
########

GITHUB_SHA?=latest
LOCAL_TAG=storybooks-app:${GITHUB_SHA}
REMOTE_TAG=${DOCKERHUB_USERNAME}/${LOCAL_TAG}
CONTAINER_NAME=storybooks

# Example: make ssh-cmd CMD="" EC2InstanceId=""
ssh-cmd: 
	aws ssm send-command \
    --document-name "AWS-RunShellScript" \
    --parameters "commands=[\"${CMD}\"]" \
    --targets "Key=instanceids,Values=${EC2InstanceId}" \
	--region "${BUCKET_REGION}" \
	--output text

# Example: make build MONGODB_PRIVATE_IP="" GOOGLE_CLIENT_ID="" GOOGLE_CLIENT_SECRET=""
# MONGODB_PRIVATE_IP: can be name of service mongodb or private IP of instance mongodb
build: 
	docker build \
	--build-arg PORT=3000 \
	--build-arg MONGO_URI="mongodb://${MONGODB_PRIVATE_IP}:27017/storybooks" \
	--build-arg GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID} \
	--build-arg GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET} \
	-t  ${LOCAL_TAG}  \
	.

# login to docker hub before push image
# Example: make push ENV="" DOCKERHUB_USERNAME=""
push: check-env
	docker tag ${LOCAL_TAG} ${REMOTE_TAG}
	docker push ${REMOTE_TAG}
	docker rmi ${LOCAL_TAG}
	docker rmi ${REMOTE_TAG}

# make deploy ENV="" EC2InstanceId="" DOCKERHUB_USERNAME=""
deploy: check-env
	${MAKE} ssh-cmd CMD="sudo docker rmi ${REMOTE_TAG} || echo not found image"
	${MAKE} ssh-cmd CMD="sudo docker pull ${REMOTE_TAG} "
	-${MAKE} ssh-cmd CMD="docker container stop ${CONTAINER_NAME} ||  echo not found container"
	-${MAKE} ssh-cmd CMD="docker container rm ${CONTAINER_NAME} ||  echo not found container"
	${MAKE} ssh-cmd CMD="\
		docker run -d --name ${CONTAINER_NAME} \
		--restart=unless-stopped -p 80:3000 \
		${REMOTE_TAG} \
	"

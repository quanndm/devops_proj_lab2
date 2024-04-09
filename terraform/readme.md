- Init terraform in the first time
```sh
terraform init
```

- Back to main folder of project, run this comannd to create s3 backend for terraform project
```sh
make create-tf-backend
```

-  If s3 backend is exists, run this command to create workspace for terraform project, ENV can be staging, production
```sh
make terraform-create-workspace ENV=staging 
```

- run this command again if workspace exists, ENV can be staging, production
```sh
make terraform-init ENV=staging
```

- To run any action of terraform run this command:, TF_ACTION can be: plan, apply, destroy, ENV can be: staging, production
```sh
make terraform-action ENV=staging TF_ACTION=plan 
```
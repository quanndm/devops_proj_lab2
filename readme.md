# StoryBooks (Dockerize and build pipeline)

Description: This app uses Node.js/Express/MongoDB with Google OAuth for authentication, using Docker, Terraform to build CI/CD pipeline

Source: clone from https://github.com/bradtraversy/storybooks

## Usage
- create .env file
    ```sh
    cp ./config/config.env.example ./config/config.env
    ```
- create google secret key
    - New project
        ![new project](./static/image1.png)
    - OAuth
        ![OAuth](./static/image2.png)
    - App name, email
        ![OAuth](./static/image3.png)
    - Add authorize domail, Save and continue
        ![OAuth](./static/image4.png)
    - Save and continue
        ![OAuth](./static/image5.png)
    - Save and continue
        ![OAuth](./static/image6.png)
    - Back to dashboard
        ![OAuth](./static/image7.png)
    - Click Create Credentials ->  OAuth client ID
        ![OAuth](./static/image8.png)
    - Add URI authorize Javascript origins, include: local, staging, production
        ![OAuth](./static/image9.png)
    - Add URI authorize redirect uris, then click create
        ![OAuth](./static/image10.png)
    - click copy id - secret, or download json, then click ok
        ![OAuth](./static/image11.png)

- Add your mongoDB URI and Google OAuth credentials to the config.env file
    ```
    PORT = 3000
    MONGO_URI = mongodb://db:27017/storybooks
    GOOGLE_CLIENT_ID = <client id>
    GOOGLE_CLIENT_SECRET = <secret>
    ```

- build image if not exit
    ```sh
    docker build \
    --build-arg PORT=3000 \
	--build-arg MONGO_URI="mongodb://db:27017/storybooks" \
	--build-arg GOOGLE_CLIENT_ID="" \
	--build-arg GOOGLE_CLIENT_SECRET="" \
    -t storybooks-app:latest \  
    .
    ```

- run docker compose
    ```sh
    docker compose up -d
    ```

- result
    ![result](./static/image12.png)
    ![result](./static/image13.png)

- Create makefile with content below:
    ```
    run-local:
        docker compose up -d
    ```
- exec command with make:
    ![make](./static/image14.png)
    ```
    make run-local
    ```
## Terraform:
- Description: Using terraform to build infrastructure
- Docs in folder terraform: [here](./terraform/readme.md)

## Manual deploy
- From local machine, run this command to build docker image, ENV=[staging|production]
    ```sh
    make build MONGODB_PRIVATE_IP="" GOOGLE_CLIENT_ID="" GOOGLE_CLIENT_SECRET=""
    ```

- After build successfully, push image to docker hub, ENV=[staging|production]
    ```sh
    make push ENV="" DOCKERHUB_USERNAME=""
    ```

- deploy to AWS EC2 instance
    ```sh
    make deploy ENV="" EC2InstanceId="" DOCKERHUB_USERNAME="" 
    ```

- then go to domain management, point domain name to public ip of application instance
- result:
    ![result manual deploy staging](./static/image15.png)
    ![result manual deploy staging](./static/image16.png)

## Deploy with CI/CD github action
- result
    ![CI/CD pipeline](./static/image17.png)
    ![CI/CD pipeline](./static/image18.png)
    ![CI/CD pipeline](./static/image19.png)

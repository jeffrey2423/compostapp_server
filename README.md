### REST API DOCKER DEVELOPMENT ENVIRONMENT
Follow this tutorial for Docker instalation..
```sh
https://www.youtube.com/watch?v=BK-C2RofmTE
```
Once done, run de Docker image..
### Launch the container with Docker-compose

Once installed, run the Docker image, you will need to execute this command: 

```sh
cd compostapp_server
docker-compose build
docker-compose up
```
You will see how it creates the container according to Dockerfile and runs it with the definition of docker-compose.yml

### Run as a process if necessary.
You can run `docker-compose up` with the `-d` flag to run it in the background, in that case to stop it you must run the command `docker-compose down`

```sh
cd compostapp_server
docker-compose build
docker-compose -d up
"Only if you want to stop it"
docker-compose down
```

Verify the development environment by navigating to your server address in your preferred browser.

```sh
127.0.0.1:4000
```
### NEW DEPENDENCES

IF NEW DEPENDENCES ARE ADDED, THESE COMMANDS SHOULD BE THROWN IN THIS SAME ORDER:

```sh
cd compostapp_server
docker-compose down -v 
docker-compose build   
docker-compose up
```

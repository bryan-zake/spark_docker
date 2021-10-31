# Refer to gitlab: https://gitlab.com/bryanzake/spark_docker

# Spark 3.0.0 on Docker 
This is a container to run Spark on Docker with a Jupyter Notebook for development. 

## Build  
`docker build -t spark_docker .`
## Run  
`docker-compose up -d`
## Accessing your Notebooks
`docker container exec sparkdocker_jupyter_1 jupyter notebook list`

## Retrieving your Notebooks
If you want to retrieve your notebooks more readily, it might make more sense to use a [bind-mount](https://docs.docker.com/storage/bind-mounts/). Oherwise you will have to go into /var/lib/docker/volumes/ to retrieve your notebooks.

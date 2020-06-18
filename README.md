## Build
docker build -t andreacasini/ansible .  

## Run the container
docker run --name ansible -it -v /Users/User01/ansible:/root/ansible andreacasini/ansible:latest  

## Start the container
docker start ansible

## Enter the container
docker attach ansible

## Stop the container
docker stop ansible

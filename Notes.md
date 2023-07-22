# My tinycoin implementation notes

# Docker setup

## Dockerfile

-   Create a Dockerfile based on base Python 3.11 image [Which Python image to use](https://pythonspeed.com/articles/base-image-python-docker-images/). Use `python:3.11-slim-bookworm`
-   Build a Python Dockerfile [Docker documentation: build Python image](https://docs.docker.com/language/python/build-images/)
-   [How to generate a UUID in Docker](https://stackoverflow.com/questions/50041750/how-to-make-a-docker-environment-variable-value-to-get-a-random-id)

```shell
docker run --env SERVICE_TAG=$(uuidgen) yourimage
```

-   Use docker-compose [Build a docker application with python](https://www.programonaut.com/build-a-docker-application-with-python-example/)

## Run using Dockerfile

Build the docker image:

```shell
docker build -t bjoern/tinycoin .
```

Run a single image with a unique miner address:

```shell
docker run --name tinycoin --env MINER_ADDRESS="$(uuidgen)" --rm --detach bjoern/tinycoin
```

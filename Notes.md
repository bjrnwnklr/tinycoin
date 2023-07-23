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
docker build -t tinycoin .
```

Run a single image with a unique miner address:

```shell
docker run --name tinycoin --env MINER_ADDRESS="$(uuidgen)" --rm --detach tinycoin
```

**IMPORTANT**

-   The `HOST` variable needs to be set to `0.0.0.0` in Flask (via an env variable or by setting it in the `start.sh` script).
-   This enables Flask listening on all network interfaces (127.0.0.1 and the dynamically generated docker IP address, e.g. 172.17.0.2).
-   If not set to `0.0.0.0`, Flask will not work correctly when run via Docker.

## Manually stop docker containers started with docker run

Use a combination of `docker ps` with `--filter` and `--format` options and then `xargs` to run `docker stop`.

```shell
docker ps --filter "ancestor=tinycoin" --format "{{.ID}}" | xargs -n1 docker stop
```

## docker-compose

Build or rebuild the images if the definition incl the Dockerfile has changed:

```shell
docker compose build
```

Run the docker images:

```shell
docker compose up # -d to run in detached mode, --build to rebuild images
```

Inspect env variables on a running container:

```shell
docker compose run tinycoin env
```

Stop and remove containers:

```shell
docker compose down
```

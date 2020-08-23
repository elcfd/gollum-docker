# Gollum Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/elcfd/gollum)](https://hub.docker.com/r/elcfd/gollum)

This project creates a [Gollum](https://github.com/gollum/gollum) docker image - "Gollum is a simple wiki system based on top of Git".

## Features
* Gollum wiki which can be used as a web browser front end for [VimWiki](https://github.com/vimwiki/vimwiki)
* [Python Pygments](https://pygments.org) for better syntax highlighting capability

## Running in docker

Pull the image from docker hub:

```
docker image pull elcfd/gollum:latest
```

To run the container:

```
docker container run -d --restart=unless-stopped -v /path/to/wiki/folder/:/wiki -p 8000:80 elcfd/gollum:latest
```

**NB.** The Dockerfile specifies the port that gollum runs on is 80.

## Development

The following dependencies are required for development:
* docker
* [task](https://taskfile.dev/#/installation?id=install-script)

### Building the Images

The Dockerhub image parameters are specified at the top of the [image creator](image_creator.sh) so if required edit this.

The command to build is:

```
task VERSION=<version> build
```

### Pushing the Built Images to Docker Hub

The command to push the built images is:

```
task VERSION=<version> release
```

**NB.** Successful authentication with Dockerhub must have been completed before running this command.

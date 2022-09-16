#!/bin/bash -e

DOCKERHUB_USERNAME="elcfd"
REPOSITORY="gollum"

function usage {
    echo "Incorrect args - must specify build, query, check or release with image version"
    echo -e "\n   ./image_creator.sh <action> <image version>"
    exit 1
}

[[ $# -eq 2 ]] || usage

action=$1
shift
version=$1
[[ "$version" == *custom* ]] && custom=true || custom=false

# args: 
    # image tag
function build {
    if [ "$custom" = true ]
    then 
        VERSION="$(echo "$version" | cut -d "-" -f 1)"
        SRC_REV="$(echo "$version" | cut -d "-" -f 2)"
        docker build -f custom/Dockerfile.custom --build-arg GOLLUM_VERSION="$VERSION" --build-arg SRC_REV="$SRC_REV" -t "$1:$version-buster" .
    else
        docker build -t "$1:$version-buster" .
    fi
}

# args: 
    # image tag
function release {
    docker image push "$1:$version-buster"
    if [ "$custom" = true ]
    then 
        docker tag "$1:$version-buster" "$1:custom-latest"
        docker image push "$1:custom-latest"
    else
        docker tag "$1:$version-buster" "$1:latest"
        docker image push "$1:latest"
    fi
}

# args: 
    # image tag
function query {
    tmp=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 16 | head -n 1)
    docker container run -d --name "$tmp" "$1:$version-buster" > /dev/null 2>&1
    gemversion=$(docker container exec "$tmp" gem list | grep "^gollum " | cut -d "(" -f2 | cut -d ")" -f1)
    docker container kill "$tmp" > /dev/null 2>&1
    docker container rm "$tmp" > /dev/null 2>&1
}

function check {
    if [[ "$version" == "$gemversion" ]]
    then
        echo "** Gollum version match - version $version"
    else
        echo "** Gollum version mismatch - user version: $version gem version: $gemversion"
        exit 1
    fi
}

if [[ "$action" == "build" ]]
then
    build "$DOCKERHUB_USERNAME/$REPOSITORY"
elif [[ "$action" == "release" ]]
then
    release "$DOCKERHUB_USERNAME/$REPOSITORY"
elif [[ "$action" == "query" ]]
then
    if [ "$custom" = true ]
    then 
        echo "** Using custom version - skipping version query"
    else
        query "$DOCKERHUB_USERNAME/$REPOSITORY"
        echo "** Gollum version is: $gemversion"
    fi
elif [[ "$action" == "check" ]]
then
    if [ "$custom" = true ]
    then 
        echo "** Using custom version - skipping version check"
    else
        query "$DOCKERHUB_USERNAME/$REPOSITORY"
        check
    fi
else
    usage
fi

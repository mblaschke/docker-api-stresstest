#!/bin/bash
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable

ID=$1
CONTAINER_ID=$(docker run --rm -d alpine tail -f /dev/null)

_term() {
	docker kill "$CONTAINER_ID" &> /dev/null
    exit 0
}

trap _term SIGTERM
trap _term SIGINT
trap _term SIGPIPE
trap _term PIPE
trap _term ERR
trap _term SIGHUP

case "$TEST" in
    exec)
        while true; do
            docker exec "$CONTAINER_ID" date &> /dev/null
            echo "$ID"
            sleep 0.5
        done
        ;;

    version)
        while true; do
            docker version &> /dev/null
            echo "$ID"
            sleep 0.5
        done
        ;;

    info)
        while true; do
            docker info &> /dev/null
            echo "$ID"
            sleep 0.5
        done
        ;;
esac
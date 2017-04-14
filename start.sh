#!/bin/bash

if [[ -z "$TEST" ]]; then
    export TEST=exec
fi

set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable

if [[ "$#" -ne 1 ]]; then
	echo "Usage: $0 <parallel count>"
	exit 1
fi

_term() {
	for job in $(jobs -p); do
		kill "$job"
	done
}

trap _term SIGTERM
trap _term SIGINT
trap _term SIGPIPE
trap _term PIPE
trap _term ERR
trap _term SIGHUP

for RUN_ID in $(seq 1 "$1"); do
	bash ./run-container.sh "$RUN_ID" &
done

wait

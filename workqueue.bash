#!/bin/bash
# 
# Two batch queues are generated:
#   A: queues user tasks (n jobs)
#   Z: queues the queue-handler (queues respawn: 1 job)
# Queues with higher letters run with increased niceness
# A is higher than Z, so A will run before Z


#
# Config:
#

JOBS_FILE='/path/to/your/workqueue.jobs'
# load_avg maybe be something like: number of cores - 1
LOAD_AVG=3
# minimum interval in seconds between the start of two batch jobs
TIME_WINDOW=30

#
# Config end 
#

pushd $(dirname $0) > /dev/null
SCRIPT_PATH=$(pwd -P)
popd > /dev/null
SCRIPT=$(basename $0)
SCRIPT_FULLPATH=$SCRIPT_PATH/$SCRIPT

if [ $# -lt 1 ]
then
    echo "Usage : $SCRIPT_FULLPATH [start|stop|status|dump TASK_ID]"
    exit
fi

case "$1" in

    "stop")

        for i in $(atq -q A | cut -f 1); do
            atrm $i;
        done
        for i in $(atq -q Z | cut -f 1); do
            atrm $i;
        done
        ;;

    "status")

        if [ $(atq |wc -l) -gt 0 ]; then

            echo 'Running, at queued jobs:'
            for i in $(atq | cut -f 1); do
                echo "$i";
            done
        fi
        ;;

    "dump")

        if [ $# -lt 2 ]; then
            echo "Usage : $SCRIPT_FULLPATH dump TASK_ID"
            exit
        fi
        at -c $2
        ;;

    "start")

        # rerun at-daemon with the specified parameters
        service atd stop > /dev/null 2>&1
        atd -l $LOAD_AVG -b $TIME_WINDOW > /dev/null 2>&1

        if [ ! $(atq -q A|wc -l) -gt 1 ]; then
        
            IFS=$'\r\n' TASKS=($(cat $JOBS_FILE))
            for t in "${TASKS[@]}"; do
                echo "$t" | at -M -q A now > /dev/nul 2>&1
            done

        fi

        [ ! $(atq -q Z|wc -l) -gt 0 ] && echo "$SCRIPT_FULLPATH start" | at -q Z now > /dev/nul 2>&1
        ;;
esac

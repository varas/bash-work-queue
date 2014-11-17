bash-work-queue
===============

Simple job queue in bash using **atd** for Linux.

> Because cron is not a job queue.

**bash-work-queue** will run a set of scripts defined on a *jobs file*:

- one by line
- in batch mode
- on a predefinied interval
- when the cpu usage lowers a predefinied threeshold


## Install

*Optional*. You can place workqueue.bash in `/etd/init.d/` and get it started at boot time.

Download and install as a service:

    wget -O https://raw.githubusercontent.com/varas/bash-work-queue/master/workqueue.bash /etc/init.d/
    chmod +x /etc/init.d/workqueue.bash

Configure and launch:

    service workqueue.bash start

## Configuration

Set up your jobs on a plain text file, one task by line. Example:

    /path/to/script1.sh
    sudo -u otheruser nice -n 15 /path/to/script2.sh

Tune up the config variables on the file:

    JOBS_FILE='/path/to/your/workqueue.jobs'
    # load_avg maybe be something like: number of cores - 1
    LOAD_AVG=3
    # minimum interval in seconds between the start of two batch jobs
    TIME_WINDOW=30

## Usage

You can run it manually:

    /path/to/workqueue.bash [start|stop|status|dump TASK_ID]

Or in case you have placed it at `/etd/init.d/` you can run it as a service:

    service workqueue.bash [start|stop|status|dump TASK_ID]

### Note

`bash-work-queue` gets queued itself in order to respawn the workqueue and is treated as a last job item.

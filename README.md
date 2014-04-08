bash-work-queue
===============

Simple job queue in bash using **atd**.

> Because cron is not a job queue.

**bash-work-queue** will run a set of scripts defined on a *jobs file*:

- one by line
- in batch mode
- on a predefinied interval
- when the cpu usage lowers a predefinied threeshold


## Install

*Optional*. You can place workqueue.bash in /etd/init.d/ and get it started at boot time.

## Configuration

Tune up the config variables on the file:


    JOBS_FILE='/path/to/your/jobs.file'
    # load_avg maybe be something like: number of cores - 1
    LOAD_AVG=3
    # minimum interval in seconds between the start of two batch jobs
    TIME_WINDOW=30

## Usage

You can run it manually:

    /path/to/workqueue.bash [start|stop|status]

Or in case you have placed it at /etd/init.d/ you can run it as a service:

    service workqueue.bash [start|stop|status]

### Note

**bash-work-queue** gets queued it self in order to respawn the job queue and is treated as a last job item.

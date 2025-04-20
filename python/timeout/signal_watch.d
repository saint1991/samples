proc::signal-send

/args[1]->pr_pid == TARGET_PID/
{
    printf("Signal %d sent to process %d\n", args[2], args[1]->pr_pid, pid);
}
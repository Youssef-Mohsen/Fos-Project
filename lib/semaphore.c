// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

//    cprintf("12\n");
    void* ret = smalloc(semaphoreName,(uint32) sizeof(struct __semdata), 1);
    if (ret == NULL ) panic("no memory in creat_semaphore");

    struct __semdata* sem_ptr = (struct __semdata*)ret;

    sem_ptr->count = value;

    sys_init_queue(&(sem_ptr->queue));

    sem_ptr->lock = 0;

    struct semaphore sem;
    sem.semdata = sem_ptr;
    return sem;
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
		if (ret == NULL ) panic("no semaphore in get_semaphore");
	    struct __semdata* sem_ptr = (struct __semdata*)ret;
	    struct semaphore sem;
	       sem.semdata = sem_ptr;
	       return sem;
}

void wait_semaphore(struct semaphore sem)
{
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
		cprintf("48\n");
		  while (xchg(&(sem.semdata->lock),1) != 0);


		    cprintf("50\n");
		    sem.semdata->count--;
		    cprintf("52\n");
	    if (sem.semdata->count < 0) {

	    	sys_acquire();
	    	cprintf("57\n");
	    	struct Env* cur_env = sys_get_cpu_process();
	    	cprintf("59\n");
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
	        cprintf("61\n");
	        sem.semdata->lock = 0;
	        cprintf("66\n");
	        cur_env->env_status= ENV_BLOCKED;
	        cprintf("68\n");
	        sys_sched();
	        cprintf("70\n");
	        sys_release();
	        cprintf("72\n");

	    } else{
	    	cprintf("75\n");
	    	sem.semdata->lock = 0;
	    }

}

void signal_semaphore(struct semaphore sem)
{
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);

	    sem.semdata->count++;
	    if (sem.semdata->count <= 0) {
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
	        sys_sched_insert_ready(env);
	    }
	    sem.semdata->lock = 0;//release
}

int semaphore_count(struct semaphore sem)
{
	return sem.semdata->count;
}

// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		cprintf("12\n");
		void* ret = smalloc(semaphoreName,(uint32) sizeof(struct semaphore), 1);
	    if (ret == NULL ) panic("no memory in creat_semaphore");
	    cprintf("15\n");
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
	    cprintf("17\n");
	    sem_ptr->semdata->count = 0;
	    cprintf("19\n");
	    sys_init_queue(&(sem_ptr->semdata->queue));
	    cprintf("21\n");
	    sem_ptr->semdata->lock = 0;
	    cprintf("23\n");
	    return *sem_ptr;
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
		if (ret == NULL ) panic("no semaphore in get_semaphore");
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
	    return *sem_ptr;
}

void wait_semaphore(struct semaphore sem)
{
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);

		    sem.semdata->count--;
	    if (sem.semdata->count < 0) {

	    	struct Env* cur_env = sys_get_cpu_process();

	    	sys_acquire();
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
	        sys_release();

	    } else
	    	sem.semdata->lock = 0;

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

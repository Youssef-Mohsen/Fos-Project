// Sleeping locks

#include "inc/types.h"
#include "inc/x86.h"
#include "inc/memlayout.h"
#include "inc/mmu.h"
#include "inc/environment_definitions.h"
#include "inc/assert.h"
#include "inc/string.h"
#include "sleeplock.h"
#include "channel.h"
#include "../cpu/cpu.h"
#include "../proc/user_environment.h"

void init_sleeplock(struct sleeplock *lk, char *name)
{
	init_channel(&(lk->chan), "sleep lock channel");
	init_spinlock(&(lk->lk), "lock of sleep lock");
	strcpy(lk->name, name);
	lk->locked = 0;
	lk->pid = 0;
}
int holding_sleeplock(struct sleeplock *lk) // is the sleeplock holded by this process or not
{
	int r;
	acquire_spinlock(&(lk->lk));
	r = lk->locked && (lk->pid == get_cpu_proc()->env_id);
	release_spinlock(&(lk->lk));
	return r;
}
//==========================================================================

void acquire_sleeplock(struct sleeplock *lk)
{
	//TODO: [PROJECT'24.MS1 - #13] [4] LOCKS - acquire_sleeplock
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("acquire_sleeplock is not implemented yet");
	 acquire_spinlock(&(lk->lk));
	    //while (lk->locked == 1) {
	 	 while(holding_sleeplock(lk)){
	    	enqueue(&(lk->chan.queue),get_cpu_proc());
	        sleep(&lk->chan, &(lk->lk));
	        //acquire_spinlock(&(lk->lk));
	    }

	    lk->locked = 1;
	    //lk->pid = get_cpu_proc()->env_id;
	  release_spinlock(&(lk->lk));

}

void release_sleeplock(struct sleeplock *lk)
{
	//TODO: [PROJECT'24.MS1 - #14] [4] LOCKS - release_sleeplock
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("release_sleeplock is not implemented yet");
	//cprintf("sleep_lock 57");
	 acquire_spinlock(&(lk->lk));
	//cprintf("sleep_lock 59");
	 wakeup_all(&(lk->chan));
	 //cprintf("sleep_lock 61");
	 lk->locked = 0;
	    //lk->pid = get_cpu_proc()->env_id;
	 release_spinlock(&(lk->lk));
}






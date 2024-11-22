
obj/user/tst_air_customer:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 64 04 00 00       	call   80049a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 d8 1b 00 00       	call   801c21 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 09 3f 80 00       	mov    $0x803f09,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 13 3f 80 00       	mov    $0x803f13,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 1f 3f 80 00       	mov    $0x803f1f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 2e 3f 80 00       	mov    $0x803f2e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 3d 3f 80 00       	mov    $0x803f3d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 52 3f 80 00       	mov    $0x803f52,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 67 3f 80 00       	mov    $0x803f67,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 78 3f 80 00       	mov    $0x803f78,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 89 3f 80 00       	mov    $0x803f89,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 9a 3f 80 00       	mov    $0x803f9a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb a3 3f 80 00       	mov    $0x803fa3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb ad 3f 80 00       	mov    $0x803fad,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb b8 3f 80 00       	mov    $0x803fb8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb c4 3f 80 00       	mov    $0x803fc4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ce 3f 80 00       	mov    $0x803fce,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb d8 3f 80 00       	mov    $0x803fd8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb e6 3f 80 00       	mov    $0x803fe6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb f5 3f 80 00       	mov    $0x803ff5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb fc 3f 80 00       	mov    $0x803ffc,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 e2 15 00 00       	call   801809 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 cd 15 00 00       	call   801809 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 b5 15 00 00       	call   801809 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 9d 15 00 00       	call   801809 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800272:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  800281:	52                   	push   %edx
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	50                   	push   %eax
  800286:	e8 70 37 00 00       	call   8039fb <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 54 37 00 00       	call   8039fb <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 38 37 00 00       	call   8039fb <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 1c 37 00 00       	call   8039fb <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 00 37 00 00       	call   8039fb <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 09 37 00 00       	call   803a15 <wait_semaphore>
  80030c:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  800317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80031a:	8b 00                	mov    (%eax),%eax
  80031c:	8d 50 01             	lea    0x1(%eax),%edx
  80031f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800322:	89 10                	mov    %edx,(%eax)
	}
	signal_semaphore(custCounterCS);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  80032d:	e8 fd 36 00 00       	call   803a2f <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 d2 36 00 00       	call   803a15 <wait_semaphore>
  800343:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  800346:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800349:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	8b 00                	mov    (%eax),%eax
  800357:	89 45 cc             	mov    %eax,-0x34(%ebp)
	wait_semaphore(custQueueCS);
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
  800363:	e8 ad 36 00 00       	call   803a15 <wait_semaphore>
  800368:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  80036b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800377:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037a:	01 c2                	add    %eax,%edx
  80037c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037f:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800381:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 50 01             	lea    0x1(%eax),%edx
  800389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038c:	89 10                	mov    %edx,(%eax)
	}
	signal_semaphore(custQueueCS);
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	ff b5 c0 fe ff ff    	pushl  -0x140(%ebp)
  800397:	e8 93 36 00 00       	call   803a2f <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 82 36 00 00       	call   803a2f <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 03 40 80 00       	mov    $0x804003,%ebx
  8003bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003c0:	89 c7                	mov    %eax,%edi
  8003c2:	89 de                	mov    %ebx,%esi
  8003c4:	89 d1                	mov    %edx,%ecx
  8003c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003c8:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8003ce:	b9 04 00 00 00       	mov    $0x4,%ecx
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d8:	89 d7                	mov    %edx,%edi
  8003da:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  8003dc:	83 ec 08             	sub    $0x8,%esp
  8003df:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8003e5:	50                   	push   %eax
  8003e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e9:	e8 f9 0d 00 00       	call   8011e7 <ltostr>
  8003ee:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	e8 b2 0e 00 00       	call   8012c0 <strcconcat>
  80040e:	83 c4 10             	add    $0x10,%esp
	//sys_waitSemaphore(parentenvID, sname);
	struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  800411:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	8d 95 63 fe ff ff    	lea    -0x19d(%ebp),%edx
  800420:	52                   	push   %edx
  800421:	ff 75 e4             	pushl  -0x1c(%ebp)
  800424:	50                   	push   %eax
  800425:	e8 d1 35 00 00       	call   8039fb <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 da 35 00 00       	call   803a15 <wait_semaphore>
  80043b:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  80043e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800441:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 40 04             	mov    0x4(%eax),%eax
  800450:	83 f8 01             	cmp    $0x1,%eax
  800453:	75 18                	jne    80046d <_main+0x435>
	{
		atomic_cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	ff 75 cc             	pushl  -0x34(%ebp)
  80045b:	ff 75 d0             	pushl  -0x30(%ebp)
  80045e:	68 c0 3e 80 00       	push   $0x803ec0
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 e8 3e 80 00       	push   $0x803ee8
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 a1 35 00 00       	call   803a2f <signal_semaphore>
  80048e:	83 c4 10             	add    $0x10,%esp

	return;
  800491:	90                   	nop
}
  800492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800495:	5b                   	pop    %ebx
  800496:	5e                   	pop    %esi
  800497:	5f                   	pop    %edi
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    

0080049a <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8004a0:	e8 63 17 00 00       	call   801c08 <sys_getenvindex>
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8004a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	c1 e0 03             	shl    $0x3,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004b9:	01 c8                	add    %ecx,%eax
  8004bb:	01 c0                	add    %eax,%eax
  8004bd:	01 d0                	add    %edx,%eax
  8004bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004c6:	01 c8                	add    %ecx,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004cf:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d9:	8a 40 20             	mov    0x20(%eax),%al
  8004dc:	84 c0                	test   %al,%al
  8004de:	74 0d                	je     8004ed <libmain+0x53>
		binaryname = myEnv->prog_name;
  8004e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e5:	83 c0 20             	add    $0x20,%eax
  8004e8:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004f1:	7e 0a                	jle    8004fd <libmain+0x63>
		binaryname = argv[0];
  8004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 0c             	pushl  0xc(%ebp)
  800503:	ff 75 08             	pushl  0x8(%ebp)
  800506:	e8 2d fb ff ff       	call   800038 <_main>
  80050b:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80050e:	e8 79 14 00 00       	call   80198c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 3c 40 80 00       	push   $0x80403c
  80051b:	e8 8d 01 00 00       	call   8006ad <cprintf>
  800520:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800523:	a1 20 50 80 00       	mov    0x805020,%eax
  800528:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80052e:	a1 20 50 80 00       	mov    0x805020,%eax
  800533:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800539:	83 ec 04             	sub    $0x4,%esp
  80053c:	52                   	push   %edx
  80053d:	50                   	push   %eax
  80053e:	68 64 40 80 00       	push   $0x804064
  800543:	e8 65 01 00 00       	call   8006ad <cprintf>
  800548:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80054b:	a1 20 50 80 00       	mov    0x805020,%eax
  800550:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800561:	a1 20 50 80 00       	mov    0x805020,%eax
  800566:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80056c:	51                   	push   %ecx
  80056d:	52                   	push   %edx
  80056e:	50                   	push   %eax
  80056f:	68 8c 40 80 00       	push   $0x80408c
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 e4 40 80 00       	push   $0x8040e4
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 3c 40 80 00       	push   $0x80403c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 f9 13 00 00       	call   8019a6 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8005ad:	e8 19 00 00 00       	call   8005cb <exit>
}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005bb:	83 ec 0c             	sub    $0xc,%esp
  8005be:	6a 00                	push   $0x0
  8005c0:	e8 0f 16 00 00       	call   801bd4 <sys_destroy_env>
  8005c5:	83 c4 10             	add    $0x10,%esp
}
  8005c8:	90                   	nop
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <exit>:

void
exit(void)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005d1:	e8 64 16 00 00       	call   801c3a <sys_exit_env>
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ea:	89 0a                	mov    %ecx,(%edx)
  8005ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ef:	88 d1                	mov    %dl,%cl
  8005f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	3d ff 00 00 00       	cmp    $0xff,%eax
  800602:	75 2c                	jne    800630 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800604:	a0 28 50 80 00       	mov    0x805028,%al
  800609:	0f b6 c0             	movzbl %al,%eax
  80060c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060f:	8b 12                	mov    (%edx),%edx
  800611:	89 d1                	mov    %edx,%ecx
  800613:	8b 55 0c             	mov    0xc(%ebp),%edx
  800616:	83 c2 08             	add    $0x8,%edx
  800619:	83 ec 04             	sub    $0x4,%esp
  80061c:	50                   	push   %eax
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	e8 26 13 00 00       	call   80194a <sys_cputs>
  800624:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	8b 40 04             	mov    0x4(%eax),%eax
  800636:	8d 50 01             	lea    0x1(%eax),%edx
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063f:	90                   	nop
  800640:	c9                   	leave  
  800641:	c3                   	ret    

00800642 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800642:	55                   	push   %ebp
  800643:	89 e5                	mov    %esp,%ebp
  800645:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800652:	00 00 00 
	b.cnt = 0;
  800655:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065f:	ff 75 0c             	pushl  0xc(%ebp)
  800662:	ff 75 08             	pushl  0x8(%ebp)
  800665:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066b:	50                   	push   %eax
  80066c:	68 d9 05 80 00       	push   $0x8005d9
  800671:	e8 11 02 00 00       	call   800887 <vprintfmt>
  800676:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800679:	a0 28 50 80 00       	mov    0x805028,%al
  80067e:	0f b6 c0             	movzbl %al,%eax
  800681:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800687:	83 ec 04             	sub    $0x4,%esp
  80068a:	50                   	push   %eax
  80068b:	52                   	push   %edx
  80068c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800692:	83 c0 08             	add    $0x8,%eax
  800695:	50                   	push   %eax
  800696:	e8 af 12 00 00       	call   80194a <sys_cputs>
  80069b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80069e:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8006a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    

008006ad <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b3:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8006ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	e8 73 ff ff ff       	call   800642 <vcprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d8:	c9                   	leave  
  8006d9:	c3                   	ret    

008006da <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e0:	e8 a7 12 00 00       	call   80198c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006e5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f4:	50                   	push   %eax
  8006f5:	e8 48 ff ff ff       	call   800642 <vcprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800700:	e8 a1 12 00 00       	call   8019a6 <sys_unlock_cons>
	return cnt;
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800708:	c9                   	leave  
  800709:	c3                   	ret    

0080070a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
  80070d:	53                   	push   %ebx
  80070e:	83 ec 14             	sub    $0x14,%esp
  800711:	8b 45 10             	mov    0x10(%ebp),%eax
  800714:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071d:	8b 45 18             	mov    0x18(%ebp),%eax
  800720:	ba 00 00 00 00       	mov    $0x0,%edx
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	77 55                	ja     80077f <printnum+0x75>
  80072a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072d:	72 05                	jb     800734 <printnum+0x2a>
  80072f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800732:	77 4b                	ja     80077f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800734:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800737:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073a:	8b 45 18             	mov    0x18(%ebp),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	52                   	push   %edx
  800743:	50                   	push   %eax
  800744:	ff 75 f4             	pushl  -0xc(%ebp)
  800747:	ff 75 f0             	pushl  -0x10(%ebp)
  80074a:	e8 f1 34 00 00       	call   803c40 <__udivdi3>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	83 ec 04             	sub    $0x4,%esp
  800755:	ff 75 20             	pushl  0x20(%ebp)
  800758:	53                   	push   %ebx
  800759:	ff 75 18             	pushl  0x18(%ebp)
  80075c:	52                   	push   %edx
  80075d:	50                   	push   %eax
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	ff 75 08             	pushl  0x8(%ebp)
  800764:	e8 a1 ff ff ff       	call   80070a <printnum>
  800769:	83 c4 20             	add    $0x20,%esp
  80076c:	eb 1a                	jmp    800788 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	ff 75 20             	pushl  0x20(%ebp)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	ff d0                	call   *%eax
  80077c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077f:	ff 4d 1c             	decl   0x1c(%ebp)
  800782:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800786:	7f e6                	jg     80076e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800788:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	53                   	push   %ebx
  800797:	51                   	push   %ecx
  800798:	52                   	push   %edx
  800799:	50                   	push   %eax
  80079a:	e8 b1 35 00 00       	call   803d50 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 14 43 80 00       	add    $0x804314,%eax
  8007a7:	8a 00                	mov    (%eax),%al
  8007a9:	0f be c0             	movsbl %al,%eax
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	50                   	push   %eax
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
}
  8007bb:	90                   	nop
  8007bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c8:	7e 1c                	jle    8007e6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	8d 50 08             	lea    0x8(%eax),%edx
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	89 10                	mov    %edx,(%eax)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	83 e8 08             	sub    $0x8,%eax
  8007df:	8b 50 04             	mov    0x4(%eax),%edx
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	eb 40                	jmp    800826 <getuint+0x65>
	else if (lflag)
  8007e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ea:	74 1e                	je     80080a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	8d 50 04             	lea    0x4(%eax),%edx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	89 10                	mov    %edx,(%eax)
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	83 e8 04             	sub    $0x4,%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	ba 00 00 00 00       	mov    $0x0,%edx
  800808:	eb 1c                	jmp    800826 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	8d 50 04             	lea    0x4(%eax),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	89 10                	mov    %edx,(%eax)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 e8 04             	sub    $0x4,%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082f:	7e 1c                	jle    80084d <getint+0x25>
		return va_arg(*ap, long long);
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	8d 50 08             	lea    0x8(%eax),%edx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	89 10                	mov    %edx,(%eax)
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	83 e8 08             	sub    $0x8,%eax
  800846:	8b 50 04             	mov    0x4(%eax),%edx
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	eb 38                	jmp    800885 <getint+0x5d>
	else if (lflag)
  80084d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800851:	74 1a                	je     80086d <getint+0x45>
		return va_arg(*ap, long);
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	8d 50 04             	lea    0x4(%eax),%edx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 10                	mov    %edx,(%eax)
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	99                   	cltd   
  80086b:	eb 18                	jmp    800885 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	8d 50 04             	lea    0x4(%eax),%edx
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 10                	mov    %edx,(%eax)
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	99                   	cltd   
}
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	56                   	push   %esi
  80088b:	53                   	push   %ebx
  80088c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088f:	eb 17                	jmp    8008a8 <vprintfmt+0x21>
			if (ch == '\0')
  800891:	85 db                	test   %ebx,%ebx
  800893:	0f 84 c1 03 00 00    	je     800c5a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	53                   	push   %ebx
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ab:	8d 50 01             	lea    0x1(%eax),%edx
  8008ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b1:	8a 00                	mov    (%eax),%al
  8008b3:	0f b6 d8             	movzbl %al,%ebx
  8008b6:	83 fb 25             	cmp    $0x25,%ebx
  8008b9:	75 d6                	jne    800891 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008bb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008db:	8b 45 10             	mov    0x10(%ebp),%eax
  8008de:	8d 50 01             	lea    0x1(%eax),%edx
  8008e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e4:	8a 00                	mov    (%eax),%al
  8008e6:	0f b6 d8             	movzbl %al,%ebx
  8008e9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ec:	83 f8 5b             	cmp    $0x5b,%eax
  8008ef:	0f 87 3d 03 00 00    	ja     800c32 <vprintfmt+0x3ab>
  8008f5:	8b 04 85 38 43 80 00 	mov    0x804338(,%eax,4),%eax
  8008fc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008fe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800902:	eb d7                	jmp    8008db <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800904:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800908:	eb d1                	jmp    8008db <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800911:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800914:	89 d0                	mov    %edx,%eax
  800916:	c1 e0 02             	shl    $0x2,%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	01 c0                	add    %eax,%eax
  80091d:	01 d8                	add    %ebx,%eax
  80091f:	83 e8 30             	sub    $0x30,%eax
  800922:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800925:	8b 45 10             	mov    0x10(%ebp),%eax
  800928:	8a 00                	mov    (%eax),%al
  80092a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80092d:	83 fb 2f             	cmp    $0x2f,%ebx
  800930:	7e 3e                	jle    800970 <vprintfmt+0xe9>
  800932:	83 fb 39             	cmp    $0x39,%ebx
  800935:	7f 39                	jg     800970 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800937:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093a:	eb d5                	jmp    800911 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093c:	8b 45 14             	mov    0x14(%ebp),%eax
  80093f:	83 c0 04             	add    $0x4,%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	83 e8 04             	sub    $0x4,%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800950:	eb 1f                	jmp    800971 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800952:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800956:	79 83                	jns    8008db <vprintfmt+0x54>
				width = 0;
  800958:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095f:	e9 77 ff ff ff       	jmp    8008db <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800964:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096b:	e9 6b ff ff ff       	jmp    8008db <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800970:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800975:	0f 89 60 ff ff ff    	jns    8008db <vprintfmt+0x54>
				width = precision, precision = -1;
  80097b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800981:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800988:	e9 4e ff ff ff       	jmp    8008db <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80098d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800990:	e9 46 ff ff ff       	jmp    8008db <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	83 c0 04             	add    $0x4,%eax
  80099b:	89 45 14             	mov    %eax,0x14(%ebp)
  80099e:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a1:	83 e8 04             	sub    $0x4,%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	50                   	push   %eax
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
			break;
  8009b5:	e9 9b 02 00 00       	jmp    800c55 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	83 c0 04             	add    $0x4,%eax
  8009c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c6:	83 e8 04             	sub    $0x4,%eax
  8009c9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009cb:	85 db                	test   %ebx,%ebx
  8009cd:	79 02                	jns    8009d1 <vprintfmt+0x14a>
				err = -err;
  8009cf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d1:	83 fb 64             	cmp    $0x64,%ebx
  8009d4:	7f 0b                	jg     8009e1 <vprintfmt+0x15a>
  8009d6:	8b 34 9d 80 41 80 00 	mov    0x804180(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 25 43 80 00       	push   $0x804325
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 70 02 00 00       	call   800c62 <printfmt>
  8009f2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f5:	e9 5b 02 00 00       	jmp    800c55 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fa:	56                   	push   %esi
  8009fb:	68 2e 43 80 00       	push   $0x80432e
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 08             	pushl  0x8(%ebp)
  800a06:	e8 57 02 00 00       	call   800c62 <printfmt>
  800a0b:	83 c4 10             	add    $0x10,%esp
			break;
  800a0e:	e9 42 02 00 00       	jmp    800c55 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	83 c0 04             	add    $0x4,%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 e8 04             	sub    $0x4,%eax
  800a22:	8b 30                	mov    (%eax),%esi
  800a24:	85 f6                	test   %esi,%esi
  800a26:	75 05                	jne    800a2d <vprintfmt+0x1a6>
				p = "(null)";
  800a28:	be 31 43 80 00       	mov    $0x804331,%esi
			if (width > 0 && padc != '-')
  800a2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a31:	7e 6d                	jle    800aa0 <vprintfmt+0x219>
  800a33:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a37:	74 67                	je     800aa0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3c:	83 ec 08             	sub    $0x8,%esp
  800a3f:	50                   	push   %eax
  800a40:	56                   	push   %esi
  800a41:	e8 1e 03 00 00       	call   800d64 <strnlen>
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4c:	eb 16                	jmp    800a64 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a4e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	50                   	push   %eax
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a61:	ff 4d e4             	decl   -0x1c(%ebp)
  800a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a68:	7f e4                	jg     800a4e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6a:	eb 34                	jmp    800aa0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a70:	74 1c                	je     800a8e <vprintfmt+0x207>
  800a72:	83 fb 1f             	cmp    $0x1f,%ebx
  800a75:	7e 05                	jle    800a7c <vprintfmt+0x1f5>
  800a77:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7a:	7e 12                	jle    800a8e <vprintfmt+0x207>
					putch('?', putdat);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 0c             	pushl  0xc(%ebp)
  800a82:	6a 3f                	push   $0x3f
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	ff d0                	call   *%eax
  800a89:	83 c4 10             	add    $0x10,%esp
  800a8c:	eb 0f                	jmp    800a9d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	53                   	push   %ebx
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa0:	89 f0                	mov    %esi,%eax
  800aa2:	8d 70 01             	lea    0x1(%eax),%esi
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	0f be d8             	movsbl %al,%ebx
  800aaa:	85 db                	test   %ebx,%ebx
  800aac:	74 24                	je     800ad2 <vprintfmt+0x24b>
  800aae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab2:	78 b8                	js     800a6c <vprintfmt+0x1e5>
  800ab4:	ff 4d e0             	decl   -0x20(%ebp)
  800ab7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abb:	79 af                	jns    800a6c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800abd:	eb 13                	jmp    800ad2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 20                	push   $0x20
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad6:	7f e7                	jg     800abf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad8:	e9 78 01 00 00       	jmp    800c55 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae6:	50                   	push   %eax
  800ae7:	e8 3c fd ff ff       	call   800828 <getint>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afb:	85 d2                	test   %edx,%edx
  800afd:	79 23                	jns    800b22 <vprintfmt+0x29b>
				putch('-', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 2d                	push   $0x2d
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b15:	f7 d8                	neg    %eax
  800b17:	83 d2 00             	adc    $0x0,%edx
  800b1a:	f7 da                	neg    %edx
  800b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b29:	e9 bc 00 00 00       	jmp    800bea <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 e8             	pushl  -0x18(%ebp)
  800b34:	8d 45 14             	lea    0x14(%ebp),%eax
  800b37:	50                   	push   %eax
  800b38:	e8 84 fc ff ff       	call   8007c1 <getuint>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b46:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b4d:	e9 98 00 00 00       	jmp    800bea <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	6a 58                	push   $0x58
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	6a 58                	push   $0x58
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	6a 58                	push   $0x58
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
			break;
  800b82:	e9 ce 00 00 00       	jmp    800c55 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 30                	push   $0x30
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	6a 78                	push   $0x78
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	ff d0                	call   *%eax
  800ba4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  800baa:	83 c0 04             	add    $0x4,%eax
  800bad:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb3:	83 e8 04             	sub    $0x4,%eax
  800bb6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc9:	eb 1f                	jmp    800bea <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd1:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd4:	50                   	push   %eax
  800bd5:	e8 e7 fb ff ff       	call   8007c1 <getuint>
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bea:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	52                   	push   %edx
  800bf5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf8:	50                   	push   %eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	ff 75 f0             	pushl  -0x10(%ebp)
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	ff 75 08             	pushl  0x8(%ebp)
  800c05:	e8 00 fb ff ff       	call   80070a <printnum>
  800c0a:	83 c4 20             	add    $0x20,%esp
			break;
  800c0d:	eb 46                	jmp    800c55 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	53                   	push   %ebx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			break;
  800c1e:	eb 35                	jmp    800c55 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c20:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c27:	eb 2c                	jmp    800c55 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c29:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800c30:	eb 23                	jmp    800c55 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 25                	push   $0x25
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c42:	ff 4d 10             	decl   0x10(%ebp)
  800c45:	eb 03                	jmp    800c4a <vprintfmt+0x3c3>
  800c47:	ff 4d 10             	decl   0x10(%ebp)
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	48                   	dec    %eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	3c 25                	cmp    $0x25,%al
  800c52:	75 f3                	jne    800c47 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c54:	90                   	nop
		}
	}
  800c55:	e9 35 fc ff ff       	jmp    80088f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c5a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c68:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6b:	83 c0 04             	add    $0x4,%eax
  800c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c71:	8b 45 10             	mov    0x10(%ebp),%eax
  800c74:	ff 75 f4             	pushl  -0xc(%ebp)
  800c77:	50                   	push   %eax
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	ff 75 08             	pushl  0x8(%ebp)
  800c7e:	e8 04 fc ff ff       	call   800887 <vprintfmt>
  800c83:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c86:	90                   	nop
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 40 08             	mov    0x8(%eax),%eax
  800c92:	8d 50 01             	lea    0x1(%eax),%edx
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 10                	mov    (%eax),%edx
  800ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca3:	8b 40 04             	mov    0x4(%eax),%eax
  800ca6:	39 c2                	cmp    %eax,%edx
  800ca8:	73 12                	jae    800cbc <sprintputch+0x33>
		*b->buf++ = ch;
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	89 0a                	mov    %ecx,(%edx)
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	88 10                	mov    %dl,(%eax)
}
  800cbc:	90                   	nop
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cce:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	01 d0                	add    %edx,%eax
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce4:	74 06                	je     800cec <vsnprintf+0x2d>
  800ce6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cea:	7f 07                	jg     800cf3 <vsnprintf+0x34>
		return -E_INVAL;
  800cec:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf1:	eb 20                	jmp    800d13 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf3:	ff 75 14             	pushl  0x14(%ebp)
  800cf6:	ff 75 10             	pushl  0x10(%ebp)
  800cf9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cfc:	50                   	push   %eax
  800cfd:	68 89 0c 80 00       	push   $0x800c89
  800d02:	e8 80 fb ff ff       	call   800887 <vprintfmt>
  800d07:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1e:	83 c0 04             	add    $0x4,%eax
  800d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2a:	50                   	push   %eax
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	ff 75 08             	pushl  0x8(%ebp)
  800d31:	e8 89 ff ff ff       	call   800cbf <vsnprintf>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d3f:	c9                   	leave  
  800d40:	c3                   	ret    

00800d41 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4e:	eb 06                	jmp    800d56 <strlen+0x15>
		n++;
  800d50:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	75 f1                	jne    800d50 <strlen+0xf>
		n++;
	return n;
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d71:	eb 09                	jmp    800d7c <strnlen+0x18>
		n++;
  800d73:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	ff 4d 0c             	decl   0xc(%ebp)
  800d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d80:	74 09                	je     800d8b <strnlen+0x27>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	75 e8                	jne    800d73 <strnlen+0xf>
		n++;
	return n;
  800d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d9c:	90                   	nop
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 08             	mov    %edx,0x8(%ebp)
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daf:	8a 12                	mov    (%edx),%dl
  800db1:	88 10                	mov    %dl,(%eax)
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	84 c0                	test   %al,%al
  800db7:	75 e4                	jne    800d9d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd1:	eb 1f                	jmp    800df2 <strncpy+0x34>
		*dst++ = *src;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8d 50 01             	lea    0x1(%eax),%edx
  800dd9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddf:	8a 12                	mov    (%edx),%dl
  800de1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	84 c0                	test   %al,%al
  800dea:	74 03                	je     800def <strncpy+0x31>
			src++;
  800dec:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800def:	ff 45 fc             	incl   -0x4(%ebp)
  800df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df8:	72 d9                	jb     800dd3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	74 30                	je     800e41 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e11:	eb 16                	jmp    800e29 <strlcpy+0x2a>
			*dst++ = *src++;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e22:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e25:	8a 12                	mov    (%edx),%dl
  800e27:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e29:	ff 4d 10             	decl   0x10(%ebp)
  800e2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e30:	74 09                	je     800e3b <strlcpy+0x3c>
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 d8                	jne    800e13 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e47:	29 c2                	sub    %eax,%edx
  800e49:	89 d0                	mov    %edx,%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e50:	eb 06                	jmp    800e58 <strcmp+0xb>
		p++, q++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	74 0e                	je     800e6f <strcmp+0x22>
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 10                	mov    (%eax),%dl
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	38 c2                	cmp    %al,%dl
  800e6d:	74 e3                	je     800e52 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	0f b6 d0             	movzbl %al,%edx
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	0f b6 c0             	movzbl %al,%eax
  800e7f:	29 c2                	sub    %eax,%edx
  800e81:	89 d0                	mov    %edx,%eax
}
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e88:	eb 09                	jmp    800e93 <strncmp+0xe>
		n--, p++, q++;
  800e8a:	ff 4d 10             	decl   0x10(%ebp)
  800e8d:	ff 45 08             	incl   0x8(%ebp)
  800e90:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e97:	74 17                	je     800eb0 <strncmp+0x2b>
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 0e                	je     800eb0 <strncmp+0x2b>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 da                	je     800e8a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb4:	75 07                	jne    800ebd <strncmp+0x38>
		return 0;
  800eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebb:	eb 14                	jmp    800ed1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 c0             	movzbl %al,%eax
  800ecd:	29 c2                	sub    %eax,%edx
  800ecf:	89 d0                	mov    %edx,%eax
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edf:	eb 12                	jmp    800ef3 <strchr+0x20>
		if (*s == c)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee9:	75 05                	jne    800ef0 <strchr+0x1d>
			return (char *) s;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	eb 11                	jmp    800f01 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	84 c0                	test   %al,%al
  800efa:	75 e5                	jne    800ee1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 04             	sub    $0x4,%esp
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f0f:	eb 0d                	jmp    800f1e <strfind+0x1b>
		if (*s == c)
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f19:	74 0e                	je     800f29 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	84 c0                	test   %al,%al
  800f25:	75 ea                	jne    800f11 <strfind+0xe>
  800f27:	eb 01                	jmp    800f2a <strfind+0x27>
		if (*s == c)
			break;
  800f29:	90                   	nop
	return (char *) s;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f41:	eb 0e                	jmp    800f51 <memset+0x22>
		*p++ = c;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8d 50 01             	lea    0x1(%eax),%edx
  800f49:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f51:	ff 4d f8             	decl   -0x8(%ebp)
  800f54:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f58:	79 e9                	jns    800f43 <memset+0x14>
		*p++ = c;

	return v;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f71:	eb 16                	jmp    800f89 <memcpy+0x2a>
		*d++ = *s++;
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f76:	8d 50 01             	lea    0x1(%eax),%edx
  800f79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f85:	8a 12                	mov    (%edx),%dl
  800f87:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	75 dd                	jne    800f73 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb3:	73 50                	jae    801005 <memmove+0x6a>
  800fb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	01 d0                	add    %edx,%eax
  800fbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc0:	76 43                	jbe    801005 <memmove+0x6a>
		s += n;
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fce:	eb 10                	jmp    800fe0 <memmove+0x45>
			*--d = *--s;
  800fd0:	ff 4d f8             	decl   -0x8(%ebp)
  800fd3:	ff 4d fc             	decl   -0x4(%ebp)
  800fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd9:	8a 10                	mov    (%eax),%dl
  800fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fde:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	75 e3                	jne    800fd0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fed:	eb 23                	jmp    801012 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff2:	8d 50 01             	lea    0x1(%eax),%edx
  800ff5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801001:	8a 12                	mov    (%edx),%dl
  801003:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100b:	89 55 10             	mov    %edx,0x10(%ebp)
  80100e:	85 c0                	test   %eax,%eax
  801010:	75 dd                	jne    800fef <memmove+0x54>
			*d++ = *s++;

	return dst;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801029:	eb 2a                	jmp    801055 <memcmp+0x3e>
		if (*s1 != *s2)
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	8a 10                	mov    (%eax),%dl
  801030:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	38 c2                	cmp    %al,%dl
  801037:	74 16                	je     80104f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f b6 d0             	movzbl %al,%edx
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f b6 c0             	movzbl %al,%eax
  801049:	29 c2                	sub    %eax,%edx
  80104b:	89 d0                	mov    %edx,%eax
  80104d:	eb 18                	jmp    801067 <memcmp+0x50>
		s1++, s2++;
  80104f:	ff 45 fc             	incl   -0x4(%ebp)
  801052:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801055:	8b 45 10             	mov    0x10(%ebp),%eax
  801058:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105b:	89 55 10             	mov    %edx,0x10(%ebp)
  80105e:	85 c0                	test   %eax,%eax
  801060:	75 c9                	jne    80102b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80107a:	eb 15                	jmp    801091 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f b6 d0             	movzbl %al,%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	0f b6 c0             	movzbl %al,%eax
  80108a:	39 c2                	cmp    %eax,%edx
  80108c:	74 0d                	je     80109b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108e:	ff 45 08             	incl   0x8(%ebp)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801097:	72 e3                	jb     80107c <memfind+0x13>
  801099:	eb 01                	jmp    80109c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109b:	90                   	nop
	return (void *) s;
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b5:	eb 03                	jmp    8010ba <strtol+0x19>
		s++;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 20                	cmp    $0x20,%al
  8010c1:	74 f4                	je     8010b7 <strtol+0x16>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 09                	cmp    $0x9,%al
  8010ca:	74 eb                	je     8010b7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 2b                	cmp    $0x2b,%al
  8010d3:	75 05                	jne    8010da <strtol+0x39>
		s++;
  8010d5:	ff 45 08             	incl   0x8(%ebp)
  8010d8:	eb 13                	jmp    8010ed <strtol+0x4c>
	else if (*s == '-')
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 2d                	cmp    $0x2d,%al
  8010e1:	75 0a                	jne    8010ed <strtol+0x4c>
		s++, neg = 1;
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f1:	74 06                	je     8010f9 <strtol+0x58>
  8010f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f7:	75 20                	jne    801119 <strtol+0x78>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	3c 30                	cmp    $0x30,%al
  801100:	75 17                	jne    801119 <strtol+0x78>
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	40                   	inc    %eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3c 78                	cmp    $0x78,%al
  80110a:	75 0d                	jne    801119 <strtol+0x78>
		s += 2, base = 16;
  80110c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801110:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801117:	eb 28                	jmp    801141 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801119:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111d:	75 15                	jne    801134 <strtol+0x93>
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	3c 30                	cmp    $0x30,%al
  801126:	75 0c                	jne    801134 <strtol+0x93>
		s++, base = 8;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801132:	eb 0d                	jmp    801141 <strtol+0xa0>
	else if (base == 0)
  801134:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801138:	75 07                	jne    801141 <strtol+0xa0>
		base = 10;
  80113a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 2f                	cmp    $0x2f,%al
  801148:	7e 19                	jle    801163 <strtol+0xc2>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 39                	cmp    $0x39,%al
  801151:	7f 10                	jg     801163 <strtol+0xc2>
			dig = *s - '0';
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f be c0             	movsbl %al,%eax
  80115b:	83 e8 30             	sub    $0x30,%eax
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801161:	eb 42                	jmp    8011a5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	3c 60                	cmp    $0x60,%al
  80116a:	7e 19                	jle    801185 <strtol+0xe4>
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 7a                	cmp    $0x7a,%al
  801173:	7f 10                	jg     801185 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	0f be c0             	movsbl %al,%eax
  80117d:	83 e8 57             	sub    $0x57,%eax
  801180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801183:	eb 20                	jmp    8011a5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 40                	cmp    $0x40,%al
  80118c:	7e 39                	jle    8011c7 <strtol+0x126>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 5a                	cmp    $0x5a,%al
  801195:	7f 30                	jg     8011c7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	0f be c0             	movsbl %al,%eax
  80119f:	83 e8 37             	sub    $0x37,%eax
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ab:	7d 19                	jge    8011c6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ad:	ff 45 08             	incl   0x8(%ebp)
  8011b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c1:	e9 7b ff ff ff       	jmp    801141 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011cb:	74 08                	je     8011d5 <strtol+0x134>
		*endptr = (char *) s;
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d9:	74 07                	je     8011e2 <strtol+0x141>
  8011db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011de:	f7 d8                	neg    %eax
  8011e0:	eb 03                	jmp    8011e5 <strtol+0x144>
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ff:	79 13                	jns    801214 <ltostr+0x2d>
	{
		neg = 1;
  801201:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801211:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121c:	99                   	cltd   
  80121d:	f7 f9                	idiv   %ecx
  80121f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	8d 50 01             	lea    0x1(%eax),%edx
  801228:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122b:	89 c2                	mov    %eax,%edx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801235:	83 c2 30             	add    $0x30,%edx
  801238:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80123a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801242:	f7 e9                	imul   %ecx
  801244:	c1 fa 02             	sar    $0x2,%edx
  801247:	89 c8                	mov    %ecx,%eax
  801249:	c1 f8 1f             	sar    $0x1f,%eax
  80124c:	29 c2                	sub    %eax,%edx
  80124e:	89 d0                	mov    %edx,%eax
  801250:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801257:	75 bb                	jne    801214 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	48                   	dec    %eax
  801264:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801267:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126b:	74 3d                	je     8012aa <ltostr+0xc3>
		start = 1 ;
  80126d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801274:	eb 34                	jmp    8012aa <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c2                	add    %eax,%edx
  80128b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c8                	add    %ecx,%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	01 c2                	add    %eax,%edx
  80129f:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c c4                	jl     801276 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c6:	ff 75 08             	pushl  0x8(%ebp)
  8012c9:	e8 73 fa ff ff       	call   800d41 <strlen>
  8012ce:	83 c4 04             	add    $0x4,%esp
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	e8 65 fa ff ff       	call   800d41 <strlen>
  8012dc:	83 c4 04             	add    $0x4,%esp
  8012df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f0:	eb 17                	jmp    801309 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	01 c2                	add    %eax,%edx
  8012fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	01 c8                	add    %ecx,%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801306:	ff 45 fc             	incl   -0x4(%ebp)
  801309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130f:	7c e1                	jl     8012f2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801311:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131f:	eb 1f                	jmp    801340 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801324:	8d 50 01             	lea    0x1(%eax),%edx
  801327:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 c8                	add    %ecx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133d:	ff 45 f8             	incl   -0x8(%ebp)
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801346:	7c d9                	jl     801321 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	c6 00 00             	movb   $0x0,(%eax)
}
  801353:	90                   	nop
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801359:	8b 45 14             	mov    0x14(%ebp),%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136e:	8b 45 10             	mov    0x10(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801379:	eb 0c                	jmp    801387 <strsplit+0x31>
			*string++ = 0;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8d 50 01             	lea    0x1(%eax),%edx
  801381:	89 55 08             	mov    %edx,0x8(%ebp)
  801384:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	84 c0                	test   %al,%al
  80138e:	74 18                	je     8013a8 <strsplit+0x52>
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f be c0             	movsbl %al,%eax
  801398:	50                   	push   %eax
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	e8 32 fb ff ff       	call   800ed3 <strchr>
  8013a1:	83 c4 08             	add    $0x8,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	75 d3                	jne    80137b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	84 c0                	test   %al,%al
  8013af:	74 5a                	je     80140b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	83 f8 0f             	cmp    $0xf,%eax
  8013b9:	75 07                	jne    8013c2 <strsplit+0x6c>
		{
			return 0;
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	eb 66                	jmp    801428 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ca:	8b 55 14             	mov    0x14(%ebp),%edx
  8013cd:	89 0a                	mov    %ecx,(%edx)
  8013cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	01 c2                	add    %eax,%edx
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e0:	eb 03                	jmp    8013e5 <strsplit+0x8f>
			string++;
  8013e2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	84 c0                	test   %al,%al
  8013ec:	74 8b                	je     801379 <strsplit+0x23>
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be c0             	movsbl %al,%eax
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 0c             	pushl  0xc(%ebp)
  8013fa:	e8 d4 fa ff ff       	call   800ed3 <strchr>
  8013ff:	83 c4 08             	add    $0x8,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	74 dc                	je     8013e2 <strsplit+0x8c>
			string++;
	}
  801406:	e9 6e ff ff ff       	jmp    801379 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80140b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801418:	8b 45 10             	mov    0x10(%ebp),%eax
  80141b:	01 d0                	add    %edx,%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801423:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 a8 44 80 00       	push   $0x8044a8
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 ca 44 80 00       	push   $0x8044ca
  801442:	e8 0d 26 00 00       	call   803a54 <_panic>

00801447 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80144d:	83 ec 0c             	sub    $0xc,%esp
  801450:	ff 75 08             	pushl  0x8(%ebp)
  801453:	e8 9d 0a 00 00       	call   801ef5 <sys_sbrk>
  801458:	83 c4 10             	add    $0x10,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801467:	75 0a                	jne    801473 <malloc+0x16>
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
  80146e:	e9 07 02 00 00       	jmp    80167a <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801473:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80147a:	8b 55 08             	mov    0x8(%ebp),%edx
  80147d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	48                   	dec    %eax
  801483:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801489:	ba 00 00 00 00       	mov    $0x0,%edx
  80148e:	f7 75 dc             	divl   -0x24(%ebp)
  801491:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801494:	29 d0                	sub    %edx,%eax
  801496:	c1 e8 0c             	shr    $0xc,%eax
  801499:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80149c:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a1:	8b 40 78             	mov    0x78(%eax),%eax
  8014a4:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8014a9:	29 c2                	sub    %eax,%edx
  8014ab:	89 d0                	mov    %edx,%eax
  8014ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b8:	c1 e8 0c             	shr    $0xc,%eax
  8014bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8014be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8014c5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014cc:	77 42                	ja     801510 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ce:	e8 a6 08 00 00       	call   801d79 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 e6 0d 00 00       	call   8022c8 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 b8 08 00 00       	call   801daa <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 7f 12 00 00       	call   802784 <alloc_block_BF>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150b:	e9 67 01 00 00       	jmp    801677 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801510:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801513:	48                   	dec    %eax
  801514:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801517:	0f 86 53 01 00 00    	jbe    801670 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80151d:	a1 20 50 80 00       	mov    0x805020,%eax
  801522:	8b 40 78             	mov    0x78(%eax),%eax
  801525:	05 00 10 00 00       	add    $0x1000,%eax
  80152a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80152d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801534:	e9 de 00 00 00       	jmp    801617 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801539:	a1 20 50 80 00       	mov    0x805020,%eax
  80153e:	8b 40 78             	mov    0x78(%eax),%eax
  801541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801544:	29 c2                	sub    %eax,%edx
  801546:	89 d0                	mov    %edx,%eax
  801548:	2d 00 10 00 00       	sub    $0x1000,%eax
  80154d:	c1 e8 0c             	shr    $0xc,%eax
  801550:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801557:	85 c0                	test   %eax,%eax
  801559:	0f 85 ab 00 00 00    	jne    80160a <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	05 00 10 00 00       	add    $0x1000,%eax
  801567:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80156a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801571:	eb 47                	jmp    8015ba <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801573:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80157a:	76 0a                	jbe    801586 <malloc+0x129>
  80157c:	b8 00 00 00 00       	mov    $0x0,%eax
  801581:	e9 f4 00 00 00       	jmp    80167a <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801586:	a1 20 50 80 00       	mov    0x805020,%eax
  80158b:	8b 40 78             	mov    0x78(%eax),%eax
  80158e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801591:	29 c2                	sub    %eax,%edx
  801593:	89 d0                	mov    %edx,%eax
  801595:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159a:	c1 e8 0c             	shr    $0xc,%eax
  80159d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	74 08                	je     8015b0 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8015a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8015ae:	eb 5a                	jmp    80160a <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8015b0:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8015b7:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8015ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015bd:	48                   	dec    %eax
  8015be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015c1:	77 b0                	ja     801573 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8015c3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8015ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015d1:	eb 2f                	jmp    801602 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8015d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d6:	c1 e0 0c             	shl    $0xc,%eax
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	01 c2                	add    %eax,%edx
  8015e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e5:	8b 40 78             	mov    0x78(%eax),%eax
  8015e8:	29 c2                	sub    %eax,%edx
  8015ea:	89 d0                	mov    %edx,%eax
  8015ec:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f1:	c1 e8 0c             	shr    $0xc,%eax
  8015f4:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8015fb:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8015ff:	ff 45 e0             	incl   -0x20(%ebp)
  801602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801605:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801608:	72 c9                	jb     8015d3 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80160a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160e:	75 16                	jne    801626 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801610:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801617:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80161e:	0f 86 15 ff ff ff    	jbe    801539 <malloc+0xdc>
  801624:	eb 01                	jmp    801627 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801626:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80162b:	75 07                	jne    801634 <malloc+0x1d7>
  80162d:	b8 00 00 00 00       	mov    $0x0,%eax
  801632:	eb 46                	jmp    80167a <malloc+0x21d>
		ptr = (void*)i;
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80163a:	a1 20 50 80 00       	mov    0x805020,%eax
  80163f:	8b 40 78             	mov    0x78(%eax),%eax
  801642:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801645:	29 c2                	sub    %eax,%edx
  801647:	89 d0                	mov    %edx,%eax
  801649:	2d 00 10 00 00       	sub    $0x1000,%eax
  80164e:	c1 e8 0c             	shr    $0xc,%eax
  801651:	89 c2                	mov    %eax,%edx
  801653:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801656:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	ff 75 f0             	pushl  -0x10(%ebp)
  801666:	e8 c1 08 00 00       	call   801f2c <sys_allocate_user_mem>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	eb 07                	jmp    801677 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	eb 03                	jmp    80167a <malloc+0x21d>
	}
	return ptr;
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801682:	a1 20 50 80 00       	mov    0x805020,%eax
  801687:	8b 40 78             	mov    0x78(%eax),%eax
  80168a:	05 00 10 00 00       	add    $0x1000,%eax
  80168f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801692:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801699:	a1 20 50 80 00       	mov    0x805020,%eax
  80169e:	8b 50 78             	mov    0x78(%eax),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	39 c2                	cmp    %eax,%edx
  8016a6:	76 24                	jbe    8016cc <free+0x50>
		size = get_block_size(va);
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	e8 95 08 00 00       	call   801f48 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 c8 1a 00 00       	call   80318c <free_block>
  8016c4:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8016c7:	e9 ac 00 00 00       	jmp    801778 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016d2:	0f 82 89 00 00 00    	jb     801761 <free+0xe5>
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016e0:	77 7f                	ja     801761 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8016e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ea:	8b 40 78             	mov    0x78(%eax),%eax
  8016ed:	29 c2                	sub    %eax,%edx
  8016ef:	89 d0                	mov    %edx,%eax
  8016f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016f6:	c1 e8 0c             	shr    $0xc,%eax
  8016f9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801700:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801706:	c1 e0 0c             	shl    $0xc,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80170c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801713:	eb 2f                	jmp    801744 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	c1 e0 0c             	shl    $0xc,%eax
  80171b:	89 c2                	mov    %eax,%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	01 c2                	add    %eax,%edx
  801722:	a1 20 50 80 00       	mov    0x805020,%eax
  801727:	8b 40 78             	mov    0x78(%eax),%eax
  80172a:	29 c2                	sub    %eax,%edx
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801733:	c1 e8 0c             	shr    $0xc,%eax
  801736:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  80173d:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801741:	ff 45 f4             	incl   -0xc(%ebp)
  801744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801747:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80174a:	72 c9                	jb     801715 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	ff 75 ec             	pushl  -0x14(%ebp)
  801755:	50                   	push   %eax
  801756:	e8 b5 07 00 00       	call   801f10 <sys_free_user_mem>
  80175b:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80175e:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80175f:	eb 17                	jmp    801778 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 d8 44 80 00       	push   $0x8044d8
  801769:	68 84 00 00 00       	push   $0x84
  80176e:	68 02 45 80 00       	push   $0x804502
  801773:	e8 dc 22 00 00       	call   803a54 <_panic>
	}
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 28             	sub    $0x28,%esp
  801780:	8b 45 10             	mov    0x10(%ebp),%eax
  801783:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801786:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178a:	75 07                	jne    801793 <smalloc+0x19>
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 74                	jmp    801807 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801793:	8b 45 0c             	mov    0xc(%ebp),%eax
  801796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801799:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	39 d0                	cmp    %edx,%eax
  8017a8:	73 02                	jae    8017ac <smalloc+0x32>
  8017aa:	89 d0                	mov    %edx,%eax
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	50                   	push   %eax
  8017b0:	e8 a8 fc ff ff       	call   80145d <malloc>
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017bf:	75 07                	jne    8017c8 <smalloc+0x4e>
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 3f                	jmp    801807 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017c8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8017cf:	50                   	push   %eax
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 3c 03 00 00       	call   801b17 <sys_createSharedObject>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e5:	74 06                	je     8017ed <smalloc+0x73>
  8017e7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017eb:	75 07                	jne    8017f4 <smalloc+0x7a>
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb 13                	jmp    801807 <smalloc+0x8d>
	 cprintf("153\n");
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	68 0e 45 80 00       	push   $0x80450e
  8017fc:	e8 ac ee ff ff       	call   8006ad <cprintf>
  801801:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801804:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	e8 24 03 00 00       	call   801b41 <sys_getSizeOfSharedObject>
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801823:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801827:	75 07                	jne    801830 <sget+0x27>
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	eb 5c                	jmp    80188c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80183d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801843:	39 d0                	cmp    %edx,%eax
  801845:	7d 02                	jge    801849 <sget+0x40>
  801847:	89 d0                	mov    %edx,%eax
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	50                   	push   %eax
  80184d:	e8 0b fc ff ff       	call   80145d <malloc>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801858:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80185c:	75 07                	jne    801865 <sget+0x5c>
  80185e:	b8 00 00 00 00       	mov    $0x0,%eax
  801863:	eb 27                	jmp    80188c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	ff 75 e8             	pushl  -0x18(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 e8 02 00 00       	call   801b5e <sys_getSharedObject>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80187c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801880:	75 07                	jne    801889 <sget+0x80>
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	eb 03                	jmp    80188c <sget+0x83>
	return ptr;
  801889:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 14 45 80 00       	push   $0x804514
  80189c:	68 c2 00 00 00       	push   $0xc2
  8018a1:	68 02 45 80 00       	push   $0x804502
  8018a6:	e8 a9 21 00 00       	call   803a54 <_panic>

008018ab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 38 45 80 00       	push   $0x804538
  8018b9:	68 d9 00 00 00       	push   $0xd9
  8018be:	68 02 45 80 00       	push   $0x804502
  8018c3:	e8 8c 21 00 00       	call   803a54 <_panic>

008018c8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 5e 45 80 00       	push   $0x80455e
  8018d6:	68 e5 00 00 00       	push   $0xe5
  8018db:	68 02 45 80 00       	push   $0x804502
  8018e0:	e8 6f 21 00 00       	call   803a54 <_panic>

008018e5 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	68 5e 45 80 00       	push   $0x80455e
  8018f3:	68 ea 00 00 00       	push   $0xea
  8018f8:	68 02 45 80 00       	push   $0x804502
  8018fd:	e8 52 21 00 00       	call   803a54 <_panic>

00801902 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 5e 45 80 00       	push   $0x80455e
  801910:	68 ef 00 00 00       	push   $0xef
  801915:	68 02 45 80 00       	push   $0x804502
  80191a:	e8 35 21 00 00       	call   803a54 <_panic>

0080191f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	57                   	push   %edi
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801934:	8b 7d 18             	mov    0x18(%ebp),%edi
  801937:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193a:	cd 30                	int    $0x30
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5f                   	pop    %edi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 10             	mov    0x10(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801956:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	52                   	push   %edx
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	6a 00                	push   $0x0
  801968:	e8 b2 ff ff ff       	call   80191f <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_cgetc>:

int
sys_cgetc(void)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 02                	push   $0x2
  801982:	e8 98 ff ff ff       	call   80191f <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 03                	push   $0x3
  80199b:	e8 7f ff ff ff       	call   80191f <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	90                   	nop
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 04                	push   $0x4
  8019b5:	e8 65 ff ff ff       	call   80191f <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	6a 08                	push   $0x8
  8019d3:	e8 47 ff ff ff       	call   80191f <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e2:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
  8019f3:	51                   	push   %ecx
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 09                	push   $0x9
  8019f8:	e8 22 ff ff ff       	call   80191f <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5d                   	pop    %ebp
  801a06:	c3                   	ret    

00801a07 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 0a                	push   $0xa
  801a1a:	e8 00 ff ff ff       	call   80191f <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	ff 75 08             	pushl  0x8(%ebp)
  801a33:	6a 0b                	push   $0xb
  801a35:	e8 e5 fe ff ff       	call   80191f <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 0c                	push   $0xc
  801a4e:	e8 cc fe ff ff       	call   80191f <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 0d                	push   $0xd
  801a67:	e8 b3 fe ff ff       	call   80191f <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 0e                	push   $0xe
  801a80:	e8 9a fe ff ff       	call   80191f <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 0f                	push   $0xf
  801a99:	e8 81 fe ff ff       	call   80191f <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	6a 10                	push   $0x10
  801ab3:	e8 67 fe ff ff       	call   80191f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 11                	push   $0x11
  801acc:	e8 4e fe ff ff       	call   80191f <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	50                   	push   %eax
  801af0:	6a 01                	push   $0x1
  801af2:	e8 28 fe ff ff       	call   80191f <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 14                	push   $0x14
  801b0c:	e8 0e fe ff ff       	call   80191f <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b20:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b23:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	51                   	push   %ecx
  801b30:	52                   	push   %edx
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	50                   	push   %eax
  801b35:	6a 15                	push   $0x15
  801b37:	e8 e3 fd ff ff       	call   80191f <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 16                	push   $0x16
  801b54:	e8 c6 fd ff ff       	call   80191f <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	51                   	push   %ecx
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 17                	push   $0x17
  801b73:	e8 a7 fd ff ff       	call   80191f <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 18                	push   $0x18
  801b90:	e8 8a fd ff ff       	call   80191f <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 14             	pushl  0x14(%ebp)
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	50                   	push   %eax
  801bac:	6a 19                	push   $0x19
  801bae:	e8 6c fd ff ff       	call   80191f <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	50                   	push   %eax
  801bc7:	6a 1a                	push   $0x1a
  801bc9:	e8 51 fd ff ff       	call   80191f <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	90                   	nop
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	50                   	push   %eax
  801be3:	6a 1b                	push   $0x1b
  801be5:	e8 35 fd ff ff       	call   80191f <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 05                	push   $0x5
  801bfe:	e8 1c fd ff ff       	call   80191f <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 06                	push   $0x6
  801c17:	e8 03 fd ff ff       	call   80191f <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 07                	push   $0x7
  801c30:	e8 ea fc ff ff       	call   80191f <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_exit_env>:


void sys_exit_env(void)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 1c                	push   $0x1c
  801c49:	e8 d1 fc ff ff       	call   80191f <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	90                   	nop
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5d:	8d 50 04             	lea    0x4(%eax),%edx
  801c60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 1d                	push   $0x1d
  801c6d:	e8 ad fc ff ff       	call   80191f <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
	return result;
  801c75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7e:	89 01                	mov    %eax,(%ecx)
  801c80:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	c9                   	leave  
  801c87:	c2 04 00             	ret    $0x4

00801c8a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	ff 75 10             	pushl  0x10(%ebp)
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	ff 75 08             	pushl  0x8(%ebp)
  801c9a:	6a 13                	push   $0x13
  801c9c:	e8 7e fc ff ff       	call   80191f <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 1e                	push   $0x1e
  801cb6:	e8 64 fc ff ff       	call   80191f <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ccc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	50                   	push   %eax
  801cd9:	6a 1f                	push   $0x1f
  801cdb:	e8 3f fc ff ff       	call   80191f <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce3:	90                   	nop
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <rsttst>:
void rsttst()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 21                	push   $0x21
  801cf5:	e8 25 fc ff ff       	call   80191f <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	8b 45 14             	mov    0x14(%ebp),%eax
  801d09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d0f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	ff 75 10             	pushl  0x10(%ebp)
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 20                	push   $0x20
  801d20:	e8 fa fb ff ff       	call   80191f <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <chktst>:
void chktst(uint32 n)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 22                	push   $0x22
  801d3b:	e8 df fb ff ff       	call   80191f <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <inctst>:

void inctst()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 23                	push   $0x23
  801d55:	e8 c5 fb ff ff       	call   80191f <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5d:	90                   	nop
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <gettst>:
uint32 gettst()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 24                	push   $0x24
  801d6f:	e8 ab fb ff ff       	call   80191f <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 25                	push   $0x25
  801d8b:	e8 8f fb ff ff       	call   80191f <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
  801d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d96:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9a:	75 07                	jne    801da3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801da1:	eb 05                	jmp    801da8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 25                	push   $0x25
  801dbc:	e8 5e fb ff ff       	call   80191f <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
  801dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dcb:	75 07                	jne    801dd4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd2:	eb 05                	jmp    801dd9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 25                	push   $0x25
  801ded:	e8 2d fb ff ff       	call   80191f <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
  801df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dfc:	75 07                	jne    801e05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	eb 05                	jmp    801e0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 25                	push   $0x25
  801e1e:	e8 fc fa ff ff       	call   80191f <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e29:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2d:	75 07                	jne    801e36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e34:	eb 05                	jmp    801e3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	6a 26                	push   $0x26
  801e4d:	e8 cd fa ff ff       	call   80191f <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
	return ;
  801e55:	90                   	nop
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	53                   	push   %ebx
  801e6b:	51                   	push   %ecx
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	6a 27                	push   $0x27
  801e70:	e8 aa fa ff ff       	call   80191f <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	52                   	push   %edx
  801e8d:	50                   	push   %eax
  801e8e:	6a 28                	push   $0x28
  801e90:	e8 8a fa ff ff       	call   80191f <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e9d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	6a 00                	push   $0x0
  801ea8:	51                   	push   %ecx
  801ea9:	ff 75 10             	pushl  0x10(%ebp)
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	6a 29                	push   $0x29
  801eb0:	e8 6a fa ff ff       	call   80191f <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	ff 75 10             	pushl  0x10(%ebp)
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	ff 75 08             	pushl  0x8(%ebp)
  801eca:	6a 12                	push   $0x12
  801ecc:	e8 4e fa ff ff       	call   80191f <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed4:	90                   	nop
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	6a 2a                	push   $0x2a
  801eea:	e8 30 fa ff ff       	call   80191f <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
	return;
  801ef2:	90                   	nop
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	50                   	push   %eax
  801f04:	6a 2b                	push   $0x2b
  801f06:	e8 14 fa ff ff       	call   80191f <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	ff 75 0c             	pushl  0xc(%ebp)
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	6a 2c                	push   $0x2c
  801f21:	e8 f9 f9 ff ff       	call   80191f <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
	return;
  801f29:	90                   	nop
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	6a 2d                	push   $0x2d
  801f3d:	e8 dd f9 ff ff       	call   80191f <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
	return;
  801f45:	90                   	nop
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	83 e8 04             	sub    $0x4,%eax
  801f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5a:	8b 00                	mov    (%eax),%eax
  801f5c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	83 e8 04             	sub    $0x4,%eax
  801f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f73:	8b 00                	mov    (%eax),%eax
  801f75:	83 e0 01             	and    $0x1,%eax
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	0f 94 c0             	sete   %al
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8f:	83 f8 02             	cmp    $0x2,%eax
  801f92:	74 2b                	je     801fbf <alloc_block+0x40>
  801f94:	83 f8 02             	cmp    $0x2,%eax
  801f97:	7f 07                	jg     801fa0 <alloc_block+0x21>
  801f99:	83 f8 01             	cmp    $0x1,%eax
  801f9c:	74 0e                	je     801fac <alloc_block+0x2d>
  801f9e:	eb 58                	jmp    801ff8 <alloc_block+0x79>
  801fa0:	83 f8 03             	cmp    $0x3,%eax
  801fa3:	74 2d                	je     801fd2 <alloc_block+0x53>
  801fa5:	83 f8 04             	cmp    $0x4,%eax
  801fa8:	74 3b                	je     801fe5 <alloc_block+0x66>
  801faa:	eb 4c                	jmp    801ff8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	e8 11 03 00 00       	call   8022c8 <alloc_block_FF>
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fbd:	eb 4a                	jmp    802009 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	e8 fa 19 00 00       	call   8039c4 <alloc_block_NF>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd0:	eb 37                	jmp    802009 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	e8 a7 07 00 00       	call   802784 <alloc_block_BF>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe3:	eb 24                	jmp    802009 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	e8 b7 19 00 00       	call   8039a7 <alloc_block_WF>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff6:	eb 11                	jmp    802009 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	68 70 45 80 00       	push   $0x804570
  802000:	e8 a8 e6 ff ff       	call   8006ad <cprintf>
  802005:	83 c4 10             	add    $0x10,%esp
		break;
  802008:	90                   	nop
	}
	return va;
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	53                   	push   %ebx
  802012:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	68 90 45 80 00       	push   $0x804590
  80201d:	e8 8b e6 ff ff       	call   8006ad <cprintf>
  802022:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	68 bb 45 80 00       	push   $0x8045bb
  80202d:	e8 7b e6 ff ff       	call   8006ad <cprintf>
  802032:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203b:	eb 37                	jmp    802074 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	ff 75 f4             	pushl  -0xc(%ebp)
  802043:	e8 19 ff ff ff       	call   801f61 <is_free_block>
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	0f be d8             	movsbl %al,%ebx
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	ff 75 f4             	pushl  -0xc(%ebp)
  802054:	e8 ef fe ff ff       	call   801f48 <get_block_size>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	53                   	push   %ebx
  802060:	50                   	push   %eax
  802061:	68 d3 45 80 00       	push   $0x8045d3
  802066:	e8 42 e6 ff ff       	call   8006ad <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80206e:	8b 45 10             	mov    0x10(%ebp),%eax
  802071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802078:	74 07                	je     802081 <print_blocks_list+0x73>
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	eb 05                	jmp    802086 <print_blocks_list+0x78>
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	89 45 10             	mov    %eax,0x10(%ebp)
  802089:	8b 45 10             	mov    0x10(%ebp),%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	75 ad                	jne    80203d <print_blocks_list+0x2f>
  802090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802094:	75 a7                	jne    80203d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802096:	83 ec 0c             	sub    $0xc,%esp
  802099:	68 90 45 80 00       	push   $0x804590
  80209e:	e8 0a e6 ff ff       	call   8006ad <cprintf>
  8020a3:	83 c4 10             	add    $0x10,%esp

}
  8020a6:	90                   	nop
  8020a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	83 e0 01             	and    $0x1,%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	74 03                	je     8020bf <initialize_dynamic_allocator+0x13>
  8020bc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020c3:	0f 84 c7 01 00 00    	je     802290 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020c9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020d0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020e0:	0f 87 ad 01 00 00    	ja     802293 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	0f 89 a5 01 00 00    	jns    802296 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f7:	01 d0                	add    %edx,%eax
  8020f9:	83 e8 04             	sub    $0x4,%eax
  8020fc:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802108:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80210d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802110:	e9 87 00 00 00       	jmp    80219c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802119:	75 14                	jne    80212f <initialize_dynamic_allocator+0x83>
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 eb 45 80 00       	push   $0x8045eb
  802123:	6a 79                	push   $0x79
  802125:	68 09 46 80 00       	push   $0x804609
  80212a:	e8 25 19 00 00       	call   803a54 <_panic>
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 10                	je     802148 <initialize_dynamic_allocator+0x9c>
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	8b 52 04             	mov    0x4(%edx),%edx
  802143:	89 50 04             	mov    %edx,0x4(%eax)
  802146:	eb 0b                	jmp    802153 <initialize_dynamic_allocator+0xa7>
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 40 04             	mov    0x4(%eax),%eax
  80214e:	a3 30 50 80 00       	mov    %eax,0x805030
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8b 40 04             	mov    0x4(%eax),%eax
  802159:	85 c0                	test   %eax,%eax
  80215b:	74 0f                	je     80216c <initialize_dynamic_allocator+0xc0>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 40 04             	mov    0x4(%eax),%eax
  802163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802166:	8b 12                	mov    (%edx),%edx
  802168:	89 10                	mov    %edx,(%eax)
  80216a:	eb 0a                	jmp    802176 <initialize_dynamic_allocator+0xca>
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802189:	a1 38 50 80 00       	mov    0x805038,%eax
  80218e:	48                   	dec    %eax
  80218f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802194:	a1 34 50 80 00       	mov    0x805034,%eax
  802199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	74 07                	je     8021a9 <initialize_dynamic_allocator+0xfd>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	eb 05                	jmp    8021ae <initialize_dynamic_allocator+0x102>
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8021b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	0f 85 55 ff ff ff    	jne    802115 <initialize_dynamic_allocator+0x69>
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c4:	0f 85 4b ff ff ff    	jne    802115 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021d9:	a1 44 50 80 00       	mov    0x805044,%eax
  8021de:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	83 c0 08             	add    $0x8,%eax
  8021f4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	83 c0 04             	add    $0x4,%eax
  8021fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802200:	83 ea 08             	sub    $0x8,%edx
  802203:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802205:	8b 55 0c             	mov    0xc(%ebp),%edx
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	01 d0                	add    %edx,%eax
  80220d:	83 e8 08             	sub    $0x8,%eax
  802210:	8b 55 0c             	mov    0xc(%ebp),%edx
  802213:	83 ea 08             	sub    $0x8,%edx
  802216:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80222b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222f:	75 17                	jne    802248 <initialize_dynamic_allocator+0x19c>
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 24 46 80 00       	push   $0x804624
  802239:	68 90 00 00 00       	push   $0x90
  80223e:	68 09 46 80 00       	push   $0x804609
  802243:	e8 0c 18 00 00       	call   803a54 <_panic>
  802248:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80224e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802251:	89 10                	mov    %edx,(%eax)
  802253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 0d                	je     802269 <initialize_dynamic_allocator+0x1bd>
  80225c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802261:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802264:	89 50 04             	mov    %edx,0x4(%eax)
  802267:	eb 08                	jmp    802271 <initialize_dynamic_allocator+0x1c5>
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	a3 30 50 80 00       	mov    %eax,0x805030
  802271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802274:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802283:	a1 38 50 80 00       	mov    0x805038,%eax
  802288:	40                   	inc    %eax
  802289:	a3 38 50 80 00       	mov    %eax,0x805038
  80228e:	eb 07                	jmp    802297 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802290:	90                   	nop
  802291:	eb 04                	jmp    802297 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802293:	90                   	nop
  802294:	eb 01                	jmp    802297 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802296:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80229c:	8b 45 10             	mov    0x10(%ebp),%eax
  80229f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ab:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	83 e8 04             	sub    $0x4,%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8022b8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	01 c2                	add    %eax,%edx
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	89 02                	mov    %eax,(%edx)
}
  8022c5:	90                   	nop
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    

008022c8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	83 e0 01             	and    $0x1,%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 03                	je     8022db <alloc_block_FF+0x13>
  8022d8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022db:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022df:	77 07                	ja     8022e8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022e1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022e8:	a1 24 50 80 00       	mov    0x805024,%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 73                	jne    802364 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	83 c0 10             	add    $0x10,%eax
  8022f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022fa:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802301:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802307:	01 d0                	add    %edx,%eax
  802309:	48                   	dec    %eax
  80230a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80230d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802310:	ba 00 00 00 00       	mov    $0x0,%edx
  802315:	f7 75 ec             	divl   -0x14(%ebp)
  802318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231b:	29 d0                	sub    %edx,%eax
  80231d:	c1 e8 0c             	shr    $0xc,%eax
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	50                   	push   %eax
  802324:	e8 1e f1 ff ff       	call   801447 <sbrk>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	6a 00                	push   $0x0
  802334:	e8 0e f1 ff ff       	call   801447 <sbrk>
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80233f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802342:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802345:	83 ec 08             	sub    $0x8,%esp
  802348:	50                   	push   %eax
  802349:	ff 75 e4             	pushl  -0x1c(%ebp)
  80234c:	e8 5b fd ff ff       	call   8020ac <initialize_dynamic_allocator>
  802351:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	68 47 46 80 00       	push   $0x804647
  80235c:	e8 4c e3 ff ff       	call   8006ad <cprintf>
  802361:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802368:	75 0a                	jne    802374 <alloc_block_FF+0xac>
	        return NULL;
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
  80236f:	e9 0e 04 00 00       	jmp    802782 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80237b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802383:	e9 f3 02 00 00       	jmp    80267b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80238e:	83 ec 0c             	sub    $0xc,%esp
  802391:	ff 75 bc             	pushl  -0x44(%ebp)
  802394:	e8 af fb ff ff       	call   801f48 <get_block_size>
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	83 c0 08             	add    $0x8,%eax
  8023a5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a8:	0f 87 c5 02 00 00    	ja     802673 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	83 c0 18             	add    $0x18,%eax
  8023b4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023b7:	0f 87 19 02 00 00    	ja     8025d6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c3:	83 e8 08             	sub    $0x8,%eax
  8023c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8d 50 08             	lea    0x8(%eax),%edx
  8023cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023d2:	01 d0                	add    %edx,%eax
  8023d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	83 c0 08             	add    $0x8,%eax
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	6a 01                	push   $0x1
  8023e2:	50                   	push   %eax
  8023e3:	ff 75 bc             	pushl  -0x44(%ebp)
  8023e6:	e8 ae fe ff ff       	call   802299 <set_block_data>
  8023eb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	75 68                	jne    802460 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023f8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023fc:	75 17                	jne    802415 <alloc_block_FF+0x14d>
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 24 46 80 00       	push   $0x804624
  802406:	68 d7 00 00 00       	push   $0xd7
  80240b:	68 09 46 80 00       	push   $0x804609
  802410:	e8 3f 16 00 00       	call   803a54 <_panic>
  802415:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80241b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 0d                	je     802436 <alloc_block_FF+0x16e>
  802429:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80242e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802431:	89 50 04             	mov    %edx,0x4(%eax)
  802434:	eb 08                	jmp    80243e <alloc_block_FF+0x176>
  802436:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802439:	a3 30 50 80 00       	mov    %eax,0x805030
  80243e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802441:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802446:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802450:	a1 38 50 80 00       	mov    0x805038,%eax
  802455:	40                   	inc    %eax
  802456:	a3 38 50 80 00       	mov    %eax,0x805038
  80245b:	e9 dc 00 00 00       	jmp    80253c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	75 65                	jne    8024ce <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802469:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80246d:	75 17                	jne    802486 <alloc_block_FF+0x1be>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 58 46 80 00       	push   $0x804658
  802477:	68 db 00 00 00       	push   $0xdb
  80247c:	68 09 46 80 00       	push   $0x804609
  802481:	e8 ce 15 00 00       	call   803a54 <_panic>
  802486:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80248c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248f:	89 50 04             	mov    %edx,0x4(%eax)
  802492:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802495:	8b 40 04             	mov    0x4(%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 0c                	je     8024a8 <alloc_block_FF+0x1e0>
  80249c:	a1 30 50 80 00       	mov    0x805030,%eax
  8024a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	eb 08                	jmp    8024b0 <alloc_block_FF+0x1e8>
  8024a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8024b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c6:	40                   	inc    %eax
  8024c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8024cc:	eb 6e                	jmp    80253c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	74 06                	je     8024da <alloc_block_FF+0x212>
  8024d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024d8:	75 17                	jne    8024f1 <alloc_block_FF+0x229>
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	68 7c 46 80 00       	push   $0x80467c
  8024e2:	68 df 00 00 00       	push   $0xdf
  8024e7:	68 09 46 80 00       	push   $0x804609
  8024ec:	e8 63 15 00 00       	call   803a54 <_panic>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 10                	mov    (%eax),%edx
  8024f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f9:	89 10                	mov    %edx,(%eax)
  8024fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	85 c0                	test   %eax,%eax
  802502:	74 0b                	je     80250f <alloc_block_FF+0x247>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250c:	89 50 04             	mov    %edx,0x4(%eax)
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	89 50 04             	mov    %edx,0x4(%eax)
  802520:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	75 08                	jne    802531 <alloc_block_FF+0x269>
  802529:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252c:	a3 30 50 80 00       	mov    %eax,0x805030
  802531:	a1 38 50 80 00       	mov    0x805038,%eax
  802536:	40                   	inc    %eax
  802537:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	75 17                	jne    802559 <alloc_block_FF+0x291>
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 eb 45 80 00       	push   $0x8045eb
  80254a:	68 e1 00 00 00       	push   $0xe1
  80254f:	68 09 46 80 00       	push   $0x804609
  802554:	e8 fb 14 00 00       	call   803a54 <_panic>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 10                	je     802572 <alloc_block_FF+0x2aa>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 52 04             	mov    0x4(%edx),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	eb 0b                	jmp    80257d <alloc_block_FF+0x2b5>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	a3 30 50 80 00       	mov    %eax,0x805030
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 0f                	je     802596 <alloc_block_FF+0x2ce>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802590:	8b 12                	mov    (%edx),%edx
  802592:	89 10                	mov    %edx,(%eax)
  802594:	eb 0a                	jmp    8025a0 <alloc_block_FF+0x2d8>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b8:	48                   	dec    %eax
  8025b9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	6a 00                	push   $0x0
  8025c3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025c6:	ff 75 b0             	pushl  -0x50(%ebp)
  8025c9:	e8 cb fc ff ff       	call   802299 <set_block_data>
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	e9 95 00 00 00       	jmp    80266b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	6a 01                	push   $0x1
  8025db:	ff 75 b8             	pushl  -0x48(%ebp)
  8025de:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e1:	e8 b3 fc ff ff       	call   802299 <set_block_data>
  8025e6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	75 17                	jne    802606 <alloc_block_FF+0x33e>
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	68 eb 45 80 00       	push   $0x8045eb
  8025f7:	68 e8 00 00 00       	push   $0xe8
  8025fc:	68 09 46 80 00       	push   $0x804609
  802601:	e8 4e 14 00 00       	call   803a54 <_panic>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 10                	je     80261f <alloc_block_FF+0x357>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802617:	8b 52 04             	mov    0x4(%edx),%edx
  80261a:	89 50 04             	mov    %edx,0x4(%eax)
  80261d:	eb 0b                	jmp    80262a <alloc_block_FF+0x362>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	a3 30 50 80 00       	mov    %eax,0x805030
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	74 0f                	je     802643 <alloc_block_FF+0x37b>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 04             	mov    0x4(%eax),%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	8b 12                	mov    (%edx),%edx
  80263f:	89 10                	mov    %edx,(%eax)
  802641:	eb 0a                	jmp    80264d <alloc_block_FF+0x385>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802660:	a1 38 50 80 00       	mov    0x805038,%eax
  802665:	48                   	dec    %eax
  802666:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80266b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80266e:	e9 0f 01 00 00       	jmp    802782 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802673:	a1 34 50 80 00       	mov    0x805034,%eax
  802678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267f:	74 07                	je     802688 <alloc_block_FF+0x3c0>
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	eb 05                	jmp    80268d <alloc_block_FF+0x3c5>
  802688:	b8 00 00 00 00       	mov    $0x0,%eax
  80268d:	a3 34 50 80 00       	mov    %eax,0x805034
  802692:	a1 34 50 80 00       	mov    0x805034,%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	0f 85 e9 fc ff ff    	jne    802388 <alloc_block_FF+0xc0>
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	0f 85 df fc ff ff    	jne    802388 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	83 c0 08             	add    $0x8,%eax
  8026af:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026b2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	48                   	dec    %eax
  8026c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cd:	f7 75 d8             	divl   -0x28(%ebp)
  8026d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d3:	29 d0                	sub    %edx,%eax
  8026d5:	c1 e8 0c             	shr    $0xc,%eax
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	50                   	push   %eax
  8026dc:	e8 66 ed ff ff       	call   801447 <sbrk>
  8026e1:	83 c4 10             	add    $0x10,%esp
  8026e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026e7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026eb:	75 0a                	jne    8026f7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f2:	e9 8b 00 00 00       	jmp    802782 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026f7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802701:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802704:	01 d0                	add    %edx,%eax
  802706:	48                   	dec    %eax
  802707:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80270a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80270d:	ba 00 00 00 00       	mov    $0x0,%edx
  802712:	f7 75 cc             	divl   -0x34(%ebp)
  802715:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802718:	29 d0                	sub    %edx,%eax
  80271a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80271d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802720:	01 d0                	add    %edx,%eax
  802722:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802727:	a1 40 50 80 00       	mov    0x805040,%eax
  80272c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802732:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802739:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80273c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80273f:	01 d0                	add    %edx,%eax
  802741:	48                   	dec    %eax
  802742:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802745:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802748:	ba 00 00 00 00       	mov    $0x0,%edx
  80274d:	f7 75 c4             	divl   -0x3c(%ebp)
  802750:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802753:	29 d0                	sub    %edx,%eax
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	6a 01                	push   $0x1
  80275a:	50                   	push   %eax
  80275b:	ff 75 d0             	pushl  -0x30(%ebp)
  80275e:	e8 36 fb ff ff       	call   802299 <set_block_data>
  802763:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	ff 75 d0             	pushl  -0x30(%ebp)
  80276c:	e8 1b 0a 00 00       	call   80318c <free_block>
  802771:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	ff 75 08             	pushl  0x8(%ebp)
  80277a:	e8 49 fb ff ff       	call   8022c8 <alloc_block_FF>
  80277f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	83 e0 01             	and    $0x1,%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 03                	je     802797 <alloc_block_BF+0x13>
  802794:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802797:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80279b:	77 07                	ja     8027a4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80279d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 73                	jne    802820 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	83 c0 10             	add    $0x10,%eax
  8027b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027b6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	48                   	dec    %eax
  8027c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d1:	f7 75 e0             	divl   -0x20(%ebp)
  8027d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d7:	29 d0                	sub    %edx,%eax
  8027d9:	c1 e8 0c             	shr    $0xc,%eax
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	50                   	push   %eax
  8027e0:	e8 62 ec ff ff       	call   801447 <sbrk>
  8027e5:	83 c4 10             	add    $0x10,%esp
  8027e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	6a 00                	push   $0x0
  8027f0:	e8 52 ec ff ff       	call   801447 <sbrk>
  8027f5:	83 c4 10             	add    $0x10,%esp
  8027f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fe:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802801:	83 ec 08             	sub    $0x8,%esp
  802804:	50                   	push   %eax
  802805:	ff 75 d8             	pushl  -0x28(%ebp)
  802808:	e8 9f f8 ff ff       	call   8020ac <initialize_dynamic_allocator>
  80280d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	68 47 46 80 00       	push   $0x804647
  802818:	e8 90 de ff ff       	call   8006ad <cprintf>
  80281d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802820:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802827:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80282e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802835:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80283c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802844:	e9 1d 01 00 00       	jmp    802966 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	ff 75 a8             	pushl  -0x58(%ebp)
  802855:	e8 ee f6 ff ff       	call   801f48 <get_block_size>
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	83 c0 08             	add    $0x8,%eax
  802866:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802869:	0f 87 ef 00 00 00    	ja     80295e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	83 c0 18             	add    $0x18,%eax
  802875:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802878:	77 1d                	ja     802897 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802880:	0f 86 d8 00 00 00    	jbe    80295e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802886:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802889:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80288c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80288f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802892:	e9 c7 00 00 00       	jmp    80295e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	83 c0 08             	add    $0x8,%eax
  80289d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a0:	0f 85 9d 00 00 00    	jne    802943 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028a6:	83 ec 04             	sub    $0x4,%esp
  8028a9:	6a 01                	push   $0x1
  8028ab:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028ae:	ff 75 a8             	pushl  -0x58(%ebp)
  8028b1:	e8 e3 f9 ff ff       	call   802299 <set_block_data>
  8028b6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	75 17                	jne    8028d6 <alloc_block_BF+0x152>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 eb 45 80 00       	push   $0x8045eb
  8028c7:	68 2c 01 00 00       	push   $0x12c
  8028cc:	68 09 46 80 00       	push   $0x804609
  8028d1:	e8 7e 11 00 00       	call   803a54 <_panic>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 10                	je     8028ef <alloc_block_BF+0x16b>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 0b                	jmp    8028fa <alloc_block_BF+0x176>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <alloc_block_BF+0x18f>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290d:	8b 12                	mov    (%edx),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	eb 0a                	jmp    80291d <alloc_block_BF+0x199>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802930:	a1 38 50 80 00       	mov    0x805038,%eax
  802935:	48                   	dec    %eax
  802936:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80293b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80293e:	e9 24 04 00 00       	jmp    802d67 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802949:	76 13                	jbe    80295e <alloc_block_BF+0x1da>
					{
						internal = 1;
  80294b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802952:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802955:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802958:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80295b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80295e:	a1 34 50 80 00       	mov    0x805034,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	74 07                	je     802973 <alloc_block_BF+0x1ef>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	eb 05                	jmp    802978 <alloc_block_BF+0x1f4>
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	a3 34 50 80 00       	mov    %eax,0x805034
  80297d:	a1 34 50 80 00       	mov    0x805034,%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	0f 85 bf fe ff ff    	jne    802849 <alloc_block_BF+0xc5>
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	0f 85 b5 fe ff ff    	jne    802849 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802994:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802998:	0f 84 26 02 00 00    	je     802bc4 <alloc_block_BF+0x440>
  80299e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a2:	0f 85 1c 02 00 00    	jne    802bc4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ae:	83 e8 08             	sub    $0x8,%eax
  8029b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	8d 50 08             	lea    0x8(%eax),%edx
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	01 d0                	add    %edx,%eax
  8029bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	83 c0 08             	add    $0x8,%eax
  8029c8:	83 ec 04             	sub    $0x4,%esp
  8029cb:	6a 01                	push   $0x1
  8029cd:	50                   	push   %eax
  8029ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8029d1:	e8 c3 f8 ff ff       	call   802299 <set_block_data>
  8029d6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	75 68                	jne    802a4b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029e7:	75 17                	jne    802a00 <alloc_block_BF+0x27c>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 24 46 80 00       	push   $0x804624
  8029f1:	68 45 01 00 00       	push   $0x145
  8029f6:	68 09 46 80 00       	push   $0x804609
  8029fb:	e8 54 10 00 00       	call   803a54 <_panic>
  802a00:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0d                	je     802a21 <alloc_block_BF+0x29d>
  802a14:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a19:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a1c:	89 50 04             	mov    %edx,0x4(%eax)
  802a1f:	eb 08                	jmp    802a29 <alloc_block_BF+0x2a5>
  802a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a24:	a3 30 50 80 00       	mov    %eax,0x805030
  802a29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a40:	40                   	inc    %eax
  802a41:	a3 38 50 80 00       	mov    %eax,0x805038
  802a46:	e9 dc 00 00 00       	jmp    802b27 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	75 65                	jne    802ab9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a54:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a58:	75 17                	jne    802a71 <alloc_block_BF+0x2ed>
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 58 46 80 00       	push   $0x804658
  802a62:	68 4a 01 00 00       	push   $0x14a
  802a67:	68 09 46 80 00       	push   $0x804609
  802a6c:	e8 e3 0f 00 00       	call   803a54 <_panic>
  802a71:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7a:	89 50 04             	mov    %edx,0x4(%eax)
  802a7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0c                	je     802a93 <alloc_block_BF+0x30f>
  802a87:	a1 30 50 80 00       	mov    0x805030,%eax
  802a8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	eb 08                	jmp    802a9b <alloc_block_BF+0x317>
  802a93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a96:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9e:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aac:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab1:	40                   	inc    %eax
  802ab2:	a3 38 50 80 00       	mov    %eax,0x805038
  802ab7:	eb 6e                	jmp    802b27 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abd:	74 06                	je     802ac5 <alloc_block_BF+0x341>
  802abf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_BF+0x358>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 7c 46 80 00       	push   $0x80467c
  802acd:	68 4f 01 00 00       	push   $0x14f
  802ad2:	68 09 46 80 00       	push   $0x804609
  802ad7:	e8 78 0f 00 00       	call   803a54 <_panic>
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 10                	mov    (%eax),%edx
  802ae1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0b                	je     802afa <alloc_block_BF+0x376>
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	75 08                	jne    802b1c <alloc_block_BF+0x398>
  802b14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b17:	a3 30 50 80 00       	mov    %eax,0x805030
  802b1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b21:	40                   	inc    %eax
  802b22:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2b:	75 17                	jne    802b44 <alloc_block_BF+0x3c0>
  802b2d:	83 ec 04             	sub    $0x4,%esp
  802b30:	68 eb 45 80 00       	push   $0x8045eb
  802b35:	68 51 01 00 00       	push   $0x151
  802b3a:	68 09 46 80 00       	push   $0x804609
  802b3f:	e8 10 0f 00 00       	call   803a54 <_panic>
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	74 10                	je     802b5d <alloc_block_BF+0x3d9>
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b55:	8b 52 04             	mov    0x4(%edx),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	eb 0b                	jmp    802b68 <alloc_block_BF+0x3e4>
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 40 04             	mov    0x4(%eax),%eax
  802b63:	a3 30 50 80 00       	mov    %eax,0x805030
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 0f                	je     802b81 <alloc_block_BF+0x3fd>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7b:	8b 12                	mov    (%edx),%edx
  802b7d:	89 10                	mov    %edx,(%eax)
  802b7f:	eb 0a                	jmp    802b8b <alloc_block_BF+0x407>
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba3:	48                   	dec    %eax
  802ba4:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	6a 00                	push   $0x0
  802bae:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb1:	ff 75 cc             	pushl  -0x34(%ebp)
  802bb4:	e8 e0 f6 ff ff       	call   802299 <set_block_data>
  802bb9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	e9 a3 01 00 00       	jmp    802d67 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bc4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bc8:	0f 85 9d 00 00 00    	jne    802c6b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	6a 01                	push   $0x1
  802bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd6:	ff 75 f0             	pushl  -0x10(%ebp)
  802bd9:	e8 bb f6 ff ff       	call   802299 <set_block_data>
  802bde:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802be1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be5:	75 17                	jne    802bfe <alloc_block_BF+0x47a>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 eb 45 80 00       	push   $0x8045eb
  802bef:	68 58 01 00 00       	push   $0x158
  802bf4:	68 09 46 80 00       	push   $0x804609
  802bf9:	e8 56 0e 00 00       	call   803a54 <_panic>
  802bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 10                	je     802c17 <alloc_block_BF+0x493>
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0f:	8b 52 04             	mov    0x4(%edx),%edx
  802c12:	89 50 04             	mov    %edx,0x4(%eax)
  802c15:	eb 0b                	jmp    802c22 <alloc_block_BF+0x49e>
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 0f                	je     802c3b <alloc_block_BF+0x4b7>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c35:	8b 12                	mov    (%edx),%edx
  802c37:	89 10                	mov    %edx,(%eax)
  802c39:	eb 0a                	jmp    802c45 <alloc_block_BF+0x4c1>
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c58:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5d:	48                   	dec    %eax
  802c5e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c66:	e9 fc 00 00 00       	jmp    802d67 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	83 c0 08             	add    $0x8,%eax
  802c71:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c74:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c81:	01 d0                	add    %edx,%eax
  802c83:	48                   	dec    %eax
  802c84:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c87:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8f:	f7 75 c4             	divl   -0x3c(%ebp)
  802c92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c95:	29 d0                	sub    %edx,%eax
  802c97:	c1 e8 0c             	shr    $0xc,%eax
  802c9a:	83 ec 0c             	sub    $0xc,%esp
  802c9d:	50                   	push   %eax
  802c9e:	e8 a4 e7 ff ff       	call   801447 <sbrk>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ca9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cad:	75 0a                	jne    802cb9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	e9 ae 00 00 00       	jmp    802d67 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cb9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cc0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cc6:	01 d0                	add    %edx,%eax
  802cc8:	48                   	dec    %eax
  802cc9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ccc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd4:	f7 75 b8             	divl   -0x48(%ebp)
  802cd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cda:	29 d0                	sub    %edx,%eax
  802cdc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cdf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ce9:	a1 40 50 80 00       	mov    0x805040,%eax
  802cee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cf4:	83 ec 0c             	sub    $0xc,%esp
  802cf7:	68 b0 46 80 00       	push   $0x8046b0
  802cfc:	e8 ac d9 ff ff       	call   8006ad <cprintf>
  802d01:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d04:	83 ec 08             	sub    $0x8,%esp
  802d07:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0a:	68 b5 46 80 00       	push   $0x8046b5
  802d0f:	e8 99 d9 ff ff       	call   8006ad <cprintf>
  802d14:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d17:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d1e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d24:	01 d0                	add    %edx,%eax
  802d26:	48                   	dec    %eax
  802d27:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d2a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d32:	f7 75 b0             	divl   -0x50(%ebp)
  802d35:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d38:	29 d0                	sub    %edx,%eax
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	6a 01                	push   $0x1
  802d3f:	50                   	push   %eax
  802d40:	ff 75 bc             	pushl  -0x44(%ebp)
  802d43:	e8 51 f5 ff ff       	call   802299 <set_block_data>
  802d48:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d4b:	83 ec 0c             	sub    $0xc,%esp
  802d4e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d51:	e8 36 04 00 00       	call   80318c <free_block>
  802d56:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d59:	83 ec 0c             	sub    $0xc,%esp
  802d5c:	ff 75 08             	pushl  0x8(%ebp)
  802d5f:	e8 20 fa ff ff       	call   802784 <alloc_block_BF>
  802d64:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d67:	c9                   	leave  
  802d68:	c3                   	ret    

00802d69 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d69:	55                   	push   %ebp
  802d6a:	89 e5                	mov    %esp,%ebp
  802d6c:	53                   	push   %ebx
  802d6d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d82:	74 1e                	je     802da2 <merging+0x39>
  802d84:	ff 75 08             	pushl  0x8(%ebp)
  802d87:	e8 bc f1 ff ff       	call   801f48 <get_block_size>
  802d8c:	83 c4 04             	add    $0x4,%esp
  802d8f:	89 c2                	mov    %eax,%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	01 d0                	add    %edx,%eax
  802d96:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d99:	75 07                	jne    802da2 <merging+0x39>
		prev_is_free = 1;
  802d9b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802da2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da6:	74 1e                	je     802dc6 <merging+0x5d>
  802da8:	ff 75 10             	pushl  0x10(%ebp)
  802dab:	e8 98 f1 ff ff       	call   801f48 <get_block_size>
  802db0:	83 c4 04             	add    $0x4,%esp
  802db3:	89 c2                	mov    %eax,%edx
  802db5:	8b 45 10             	mov    0x10(%ebp),%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dbd:	75 07                	jne    802dc6 <merging+0x5d>
		next_is_free = 1;
  802dbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dca:	0f 84 cc 00 00 00    	je     802e9c <merging+0x133>
  802dd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd4:	0f 84 c2 00 00 00    	je     802e9c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dda:	ff 75 08             	pushl  0x8(%ebp)
  802ddd:	e8 66 f1 ff ff       	call   801f48 <get_block_size>
  802de2:	83 c4 04             	add    $0x4,%esp
  802de5:	89 c3                	mov    %eax,%ebx
  802de7:	ff 75 10             	pushl  0x10(%ebp)
  802dea:	e8 59 f1 ff ff       	call   801f48 <get_block_size>
  802def:	83 c4 04             	add    $0x4,%esp
  802df2:	01 c3                	add    %eax,%ebx
  802df4:	ff 75 0c             	pushl  0xc(%ebp)
  802df7:	e8 4c f1 ff ff       	call   801f48 <get_block_size>
  802dfc:	83 c4 04             	add    $0x4,%esp
  802dff:	01 d8                	add    %ebx,%eax
  802e01:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e04:	6a 00                	push   $0x0
  802e06:	ff 75 ec             	pushl  -0x14(%ebp)
  802e09:	ff 75 08             	pushl  0x8(%ebp)
  802e0c:	e8 88 f4 ff ff       	call   802299 <set_block_data>
  802e11:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e18:	75 17                	jne    802e31 <merging+0xc8>
  802e1a:	83 ec 04             	sub    $0x4,%esp
  802e1d:	68 eb 45 80 00       	push   $0x8045eb
  802e22:	68 7d 01 00 00       	push   $0x17d
  802e27:	68 09 46 80 00       	push   $0x804609
  802e2c:	e8 23 0c 00 00       	call   803a54 <_panic>
  802e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e34:	8b 00                	mov    (%eax),%eax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 10                	je     802e4a <merging+0xe1>
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e42:	8b 52 04             	mov    0x4(%edx),%edx
  802e45:	89 50 04             	mov    %edx,0x4(%eax)
  802e48:	eb 0b                	jmp    802e55 <merging+0xec>
  802e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4d:	8b 40 04             	mov    0x4(%eax),%eax
  802e50:	a3 30 50 80 00       	mov    %eax,0x805030
  802e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	74 0f                	je     802e6e <merging+0x105>
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	8b 40 04             	mov    0x4(%eax),%eax
  802e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e68:	8b 12                	mov    (%edx),%edx
  802e6a:	89 10                	mov    %edx,(%eax)
  802e6c:	eb 0a                	jmp    802e78 <merging+0x10f>
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e90:	48                   	dec    %eax
  802e91:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e96:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e97:	e9 ea 02 00 00       	jmp    803186 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea0:	74 3b                	je     802edd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ea2:	83 ec 0c             	sub    $0xc,%esp
  802ea5:	ff 75 08             	pushl  0x8(%ebp)
  802ea8:	e8 9b f0 ff ff       	call   801f48 <get_block_size>
  802ead:	83 c4 10             	add    $0x10,%esp
  802eb0:	89 c3                	mov    %eax,%ebx
  802eb2:	83 ec 0c             	sub    $0xc,%esp
  802eb5:	ff 75 10             	pushl  0x10(%ebp)
  802eb8:	e8 8b f0 ff ff       	call   801f48 <get_block_size>
  802ebd:	83 c4 10             	add    $0x10,%esp
  802ec0:	01 d8                	add    %ebx,%eax
  802ec2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	6a 00                	push   $0x0
  802eca:	ff 75 e8             	pushl  -0x18(%ebp)
  802ecd:	ff 75 08             	pushl  0x8(%ebp)
  802ed0:	e8 c4 f3 ff ff       	call   802299 <set_block_data>
  802ed5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ed8:	e9 a9 02 00 00       	jmp    803186 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee1:	0f 84 2d 01 00 00    	je     803014 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ee7:	83 ec 0c             	sub    $0xc,%esp
  802eea:	ff 75 10             	pushl  0x10(%ebp)
  802eed:	e8 56 f0 ff ff       	call   801f48 <get_block_size>
  802ef2:	83 c4 10             	add    $0x10,%esp
  802ef5:	89 c3                	mov    %eax,%ebx
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	ff 75 0c             	pushl  0xc(%ebp)
  802efd:	e8 46 f0 ff ff       	call   801f48 <get_block_size>
  802f02:	83 c4 10             	add    $0x10,%esp
  802f05:	01 d8                	add    %ebx,%eax
  802f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	6a 00                	push   $0x0
  802f0f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f12:	ff 75 10             	pushl  0x10(%ebp)
  802f15:	e8 7f f3 ff ff       	call   802299 <set_block_data>
  802f1a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f27:	74 06                	je     802f2f <merging+0x1c6>
  802f29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f2d:	75 17                	jne    802f46 <merging+0x1dd>
  802f2f:	83 ec 04             	sub    $0x4,%esp
  802f32:	68 c4 46 80 00       	push   $0x8046c4
  802f37:	68 8d 01 00 00       	push   $0x18d
  802f3c:	68 09 46 80 00       	push   $0x804609
  802f41:	e8 0e 0b 00 00       	call   803a54 <_panic>
  802f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f49:	8b 50 04             	mov    0x4(%eax),%edx
  802f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f58:	89 10                	mov    %edx,(%eax)
  802f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5d:	8b 40 04             	mov    0x4(%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0d                	je     802f71 <merging+0x208>
  802f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6d:	89 10                	mov    %edx,(%eax)
  802f6f:	eb 08                	jmp    802f79 <merging+0x210>
  802f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f74:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f7f:	89 50 04             	mov    %edx,0x4(%eax)
  802f82:	a1 38 50 80 00       	mov    0x805038,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f91:	75 17                	jne    802faa <merging+0x241>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 eb 45 80 00       	push   $0x8045eb
  802f9b:	68 8e 01 00 00       	push   $0x18e
  802fa0:	68 09 46 80 00       	push   $0x804609
  802fa5:	e8 aa 0a 00 00       	call   803a54 <_panic>
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 10                	je     802fc3 <merging+0x25a>
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbb:	8b 52 04             	mov    0x4(%edx),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 0b                	jmp    802fce <merging+0x265>
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0f                	je     802fe7 <merging+0x27e>
  802fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe1:	8b 12                	mov    (%edx),%edx
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	eb 0a                	jmp    802ff1 <merging+0x288>
  802fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803004:	a1 38 50 80 00       	mov    0x805038,%eax
  803009:	48                   	dec    %eax
  80300a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80300f:	e9 72 01 00 00       	jmp    803186 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803014:	8b 45 10             	mov    0x10(%ebp),%eax
  803017:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80301a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301e:	74 79                	je     803099 <merging+0x330>
  803020:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803024:	74 73                	je     803099 <merging+0x330>
  803026:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302a:	74 06                	je     803032 <merging+0x2c9>
  80302c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803030:	75 17                	jne    803049 <merging+0x2e0>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 7c 46 80 00       	push   $0x80467c
  80303a:	68 94 01 00 00       	push   $0x194
  80303f:	68 09 46 80 00       	push   $0x804609
  803044:	e8 0b 0a 00 00       	call   803a54 <_panic>
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 10                	mov    (%eax),%edx
  80304e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
  803053:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0b                	je     803067 <merging+0x2fe>
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803072:	8b 55 08             	mov    0x8(%ebp),%edx
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	75 08                	jne    803089 <merging+0x320>
  803081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803084:	a3 30 50 80 00       	mov    %eax,0x805030
  803089:	a1 38 50 80 00       	mov    0x805038,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 38 50 80 00       	mov    %eax,0x805038
  803094:	e9 ce 00 00 00       	jmp    803167 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803099:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309d:	74 65                	je     803104 <merging+0x39b>
  80309f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a3:	75 17                	jne    8030bc <merging+0x353>
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	68 58 46 80 00       	push   $0x804658
  8030ad:	68 95 01 00 00       	push   $0x195
  8030b2:	68 09 46 80 00       	push   $0x804609
  8030b7:	e8 98 09 00 00       	call   803a54 <_panic>
  8030bc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	89 50 04             	mov    %edx,0x4(%eax)
  8030c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	74 0c                	je     8030de <merging+0x375>
  8030d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	eb 08                	jmp    8030e6 <merging+0x37d>
  8030de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803102:	eb 63                	jmp    803167 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803104:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803108:	75 17                	jne    803121 <merging+0x3b8>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 24 46 80 00       	push   $0x804624
  803112:	68 98 01 00 00       	push   $0x198
  803117:	68 09 46 80 00       	push   $0x804609
  80311c:	e8 33 09 00 00       	call   803a54 <_panic>
  803121:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803127:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 0d                	je     803142 <merging+0x3d9>
  803135:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	eb 08                	jmp    80314a <merging+0x3e1>
  803142:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803145:	a3 30 50 80 00       	mov    %eax,0x805030
  80314a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803152:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315c:	a1 38 50 80 00       	mov    0x805038,%eax
  803161:	40                   	inc    %eax
  803162:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803167:	83 ec 0c             	sub    $0xc,%esp
  80316a:	ff 75 10             	pushl  0x10(%ebp)
  80316d:	e8 d6 ed ff ff       	call   801f48 <get_block_size>
  803172:	83 c4 10             	add    $0x10,%esp
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	6a 00                	push   $0x0
  80317a:	50                   	push   %eax
  80317b:	ff 75 10             	pushl  0x10(%ebp)
  80317e:	e8 16 f1 ff ff       	call   802299 <set_block_data>
  803183:	83 c4 10             	add    $0x10,%esp
	}
}
  803186:	90                   	nop
  803187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80318a:	c9                   	leave  
  80318b:	c3                   	ret    

0080318c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803192:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803197:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80319a:	a1 30 50 80 00       	mov    0x805030,%eax
  80319f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a2:	73 1b                	jae    8031bf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	ff 75 08             	pushl  0x8(%ebp)
  8031af:	6a 00                	push   $0x0
  8031b1:	50                   	push   %eax
  8031b2:	e8 b2 fb ff ff       	call   802d69 <merging>
  8031b7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ba:	e9 8b 00 00 00       	jmp    80324a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031bf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c7:	76 18                	jbe    8031e1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031ce:	83 ec 04             	sub    $0x4,%esp
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	50                   	push   %eax
  8031d5:	6a 00                	push   $0x0
  8031d7:	e8 8d fb ff ff       	call   802d69 <merging>
  8031dc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031df:	eb 69                	jmp    80324a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e9:	eb 39                	jmp    803224 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f1:	73 29                	jae    80321c <free_block+0x90>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fb:	76 1f                	jbe    80321c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	ff 75 08             	pushl  0x8(%ebp)
  80320b:	ff 75 f0             	pushl  -0x10(%ebp)
  80320e:	ff 75 f4             	pushl  -0xc(%ebp)
  803211:	e8 53 fb ff ff       	call   802d69 <merging>
  803216:	83 c4 10             	add    $0x10,%esp
			break;
  803219:	90                   	nop
		}
	}
}
  80321a:	eb 2e                	jmp    80324a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80321c:	a1 34 50 80 00       	mov    0x805034,%eax
  803221:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803228:	74 07                	je     803231 <free_block+0xa5>
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	eb 05                	jmp    803236 <free_block+0xaa>
  803231:	b8 00 00 00 00       	mov    $0x0,%eax
  803236:	a3 34 50 80 00       	mov    %eax,0x805034
  80323b:	a1 34 50 80 00       	mov    0x805034,%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	75 a7                	jne    8031eb <free_block+0x5f>
  803244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803248:	75 a1                	jne    8031eb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324a:	90                   	nop
  80324b:	c9                   	leave  
  80324c:	c3                   	ret    

0080324d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80324d:	55                   	push   %ebp
  80324e:	89 e5                	mov    %esp,%ebp
  803250:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803253:	ff 75 08             	pushl  0x8(%ebp)
  803256:	e8 ed ec ff ff       	call   801f48 <get_block_size>
  80325b:	83 c4 04             	add    $0x4,%esp
  80325e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803268:	eb 17                	jmp    803281 <copy_data+0x34>
  80326a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803270:	01 c2                	add    %eax,%edx
  803272:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	01 c8                	add    %ecx,%eax
  80327a:	8a 00                	mov    (%eax),%al
  80327c:	88 02                	mov    %al,(%edx)
  80327e:	ff 45 fc             	incl   -0x4(%ebp)
  803281:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803284:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803287:	72 e1                	jb     80326a <copy_data+0x1d>
}
  803289:	90                   	nop
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803296:	75 23                	jne    8032bb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803298:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329c:	74 13                	je     8032b1 <realloc_block_FF+0x25>
  80329e:	83 ec 0c             	sub    $0xc,%esp
  8032a1:	ff 75 0c             	pushl  0xc(%ebp)
  8032a4:	e8 1f f0 ff ff       	call   8022c8 <alloc_block_FF>
  8032a9:	83 c4 10             	add    $0x10,%esp
  8032ac:	e9 f4 06 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
		return NULL;
  8032b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b6:	e9 ea 06 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032bf:	75 18                	jne    8032d9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	ff 75 08             	pushl  0x8(%ebp)
  8032c7:	e8 c0 fe ff ff       	call   80318c <free_block>
  8032cc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d4:	e9 cc 06 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032d9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032dd:	77 07                	ja     8032e6 <realloc_block_FF+0x5a>
  8032df:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e9:	83 e0 01             	and    $0x1,%eax
  8032ec:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f2:	83 c0 08             	add    $0x8,%eax
  8032f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 08             	pushl  0x8(%ebp)
  8032fe:	e8 45 ec ff ff       	call   801f48 <get_block_size>
  803303:	83 c4 10             	add    $0x10,%esp
  803306:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330c:	83 e8 08             	sub    $0x8,%eax
  80330f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	83 e8 04             	sub    $0x4,%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	83 e0 fe             	and    $0xfffffffe,%eax
  80331d:	89 c2                	mov    %eax,%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	01 d0                	add    %edx,%eax
  803324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803327:	83 ec 0c             	sub    $0xc,%esp
  80332a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80332d:	e8 16 ec ff ff       	call   801f48 <get_block_size>
  803332:	83 c4 10             	add    $0x10,%esp
  803335:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333b:	83 e8 08             	sub    $0x8,%eax
  80333e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803341:	8b 45 0c             	mov    0xc(%ebp),%eax
  803344:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803347:	75 08                	jne    803351 <realloc_block_FF+0xc5>
	{
		 return va;
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	e9 54 06 00 00       	jmp    8039a5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803351:	8b 45 0c             	mov    0xc(%ebp),%eax
  803354:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803357:	0f 83 e5 03 00 00    	jae    803742 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	2b 45 0c             	sub    0xc(%ebp),%eax
  803363:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	ff 75 e4             	pushl  -0x1c(%ebp)
  80336c:	e8 f0 eb ff ff       	call   801f61 <is_free_block>
  803371:	83 c4 10             	add    $0x10,%esp
  803374:	84 c0                	test   %al,%al
  803376:	0f 84 3b 01 00 00    	je     8034b7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80337c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80337f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803382:	01 d0                	add    %edx,%eax
  803384:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	6a 01                	push   $0x1
  80338c:	ff 75 f0             	pushl  -0x10(%ebp)
  80338f:	ff 75 08             	pushl  0x8(%ebp)
  803392:	e8 02 ef ff ff       	call   802299 <set_block_data>
  803397:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	83 e8 04             	sub    $0x4,%eax
  8033a0:	8b 00                	mov    (%eax),%eax
  8033a2:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a5:	89 c2                	mov    %eax,%edx
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	01 d0                	add    %edx,%eax
  8033ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033af:	83 ec 04             	sub    $0x4,%esp
  8033b2:	6a 00                	push   $0x0
  8033b4:	ff 75 cc             	pushl  -0x34(%ebp)
  8033b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8033ba:	e8 da ee ff ff       	call   802299 <set_block_data>
  8033bf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033c6:	74 06                	je     8033ce <realloc_block_FF+0x142>
  8033c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033cc:	75 17                	jne    8033e5 <realloc_block_FF+0x159>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 7c 46 80 00       	push   $0x80467c
  8033d6:	68 f6 01 00 00       	push   $0x1f6
  8033db:	68 09 46 80 00       	push   $0x804609
  8033e0:	e8 6f 06 00 00       	call   803a54 <_panic>
  8033e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e8:	8b 10                	mov    (%eax),%edx
  8033ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ed:	89 10                	mov    %edx,(%eax)
  8033ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 0b                	je     803403 <realloc_block_FF+0x177>
  8033f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803400:	89 50 04             	mov    %edx,0x4(%eax)
  803403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803406:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803409:	89 10                	mov    %edx,(%eax)
  80340b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80340e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	75 08                	jne    803425 <realloc_block_FF+0x199>
  80341d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803420:	a3 30 50 80 00       	mov    %eax,0x805030
  803425:	a1 38 50 80 00       	mov    0x805038,%eax
  80342a:	40                   	inc    %eax
  80342b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803430:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803434:	75 17                	jne    80344d <realloc_block_FF+0x1c1>
  803436:	83 ec 04             	sub    $0x4,%esp
  803439:	68 eb 45 80 00       	push   $0x8045eb
  80343e:	68 f7 01 00 00       	push   $0x1f7
  803443:	68 09 46 80 00       	push   $0x804609
  803448:	e8 07 06 00 00       	call   803a54 <_panic>
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	74 10                	je     803466 <realloc_block_FF+0x1da>
  803456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345e:	8b 52 04             	mov    0x4(%edx),%edx
  803461:	89 50 04             	mov    %edx,0x4(%eax)
  803464:	eb 0b                	jmp    803471 <realloc_block_FF+0x1e5>
  803466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	a3 30 50 80 00       	mov    %eax,0x805030
  803471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	85 c0                	test   %eax,%eax
  803479:	74 0f                	je     80348a <realloc_block_FF+0x1fe>
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803484:	8b 12                	mov    (%edx),%edx
  803486:	89 10                	mov    %edx,(%eax)
  803488:	eb 0a                	jmp    803494 <realloc_block_FF+0x208>
  80348a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ac:	48                   	dec    %eax
  8034ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b2:	e9 83 02 00 00       	jmp    80373a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034b7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034bb:	0f 86 69 02 00 00    	jbe    80372a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	6a 01                	push   $0x1
  8034c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c9:	ff 75 08             	pushl  0x8(%ebp)
  8034cc:	e8 c8 ed ff ff       	call   802299 <set_block_data>
  8034d1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	83 e8 04             	sub    $0x4,%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034df:	89 c2                	mov    %eax,%edx
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	01 d0                	add    %edx,%eax
  8034e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034f1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034f5:	75 68                	jne    80355f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fb:	75 17                	jne    803514 <realloc_block_FF+0x288>
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 24 46 80 00       	push   $0x804624
  803505:	68 06 02 00 00       	push   $0x206
  80350a:	68 09 46 80 00       	push   $0x804609
  80350f:	e8 40 05 00 00       	call   803a54 <_panic>
  803514:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80351a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351d:	89 10                	mov    %edx,(%eax)
  80351f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	85 c0                	test   %eax,%eax
  803526:	74 0d                	je     803535 <realloc_block_FF+0x2a9>
  803528:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803530:	89 50 04             	mov    %edx,0x4(%eax)
  803533:	eb 08                	jmp    80353d <realloc_block_FF+0x2b1>
  803535:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803538:	a3 30 50 80 00       	mov    %eax,0x805030
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354f:	a1 38 50 80 00       	mov    0x805038,%eax
  803554:	40                   	inc    %eax
  803555:	a3 38 50 80 00       	mov    %eax,0x805038
  80355a:	e9 b0 01 00 00       	jmp    80370f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80355f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803564:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803567:	76 68                	jbe    8035d1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803569:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80356d:	75 17                	jne    803586 <realloc_block_FF+0x2fa>
  80356f:	83 ec 04             	sub    $0x4,%esp
  803572:	68 24 46 80 00       	push   $0x804624
  803577:	68 0b 02 00 00       	push   $0x20b
  80357c:	68 09 46 80 00       	push   $0x804609
  803581:	e8 ce 04 00 00       	call   803a54 <_panic>
  803586:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80358c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358f:	89 10                	mov    %edx,(%eax)
  803591:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803594:	8b 00                	mov    (%eax),%eax
  803596:	85 c0                	test   %eax,%eax
  803598:	74 0d                	je     8035a7 <realloc_block_FF+0x31b>
  80359a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a2:	89 50 04             	mov    %edx,0x4(%eax)
  8035a5:	eb 08                	jmp    8035af <realloc_block_FF+0x323>
  8035a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8035af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c6:	40                   	inc    %eax
  8035c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8035cc:	e9 3e 01 00 00       	jmp    80370f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d9:	73 68                	jae    803643 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035df:	75 17                	jne    8035f8 <realloc_block_FF+0x36c>
  8035e1:	83 ec 04             	sub    $0x4,%esp
  8035e4:	68 58 46 80 00       	push   $0x804658
  8035e9:	68 10 02 00 00       	push   $0x210
  8035ee:	68 09 46 80 00       	push   $0x804609
  8035f3:	e8 5c 04 00 00       	call   803a54 <_panic>
  8035f8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803601:	89 50 04             	mov    %edx,0x4(%eax)
  803604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803607:	8b 40 04             	mov    0x4(%eax),%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	74 0c                	je     80361a <realloc_block_FF+0x38e>
  80360e:	a1 30 50 80 00       	mov    0x805030,%eax
  803613:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803616:	89 10                	mov    %edx,(%eax)
  803618:	eb 08                	jmp    803622 <realloc_block_FF+0x396>
  80361a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803625:	a3 30 50 80 00       	mov    %eax,0x805030
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803633:	a1 38 50 80 00       	mov    0x805038,%eax
  803638:	40                   	inc    %eax
  803639:	a3 38 50 80 00       	mov    %eax,0x805038
  80363e:	e9 cc 00 00 00       	jmp    80370f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80364a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80364f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803652:	e9 8a 00 00 00       	jmp    8036e1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80365d:	73 7a                	jae    8036d9 <realloc_block_FF+0x44d>
  80365f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803667:	73 70                	jae    8036d9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366d:	74 06                	je     803675 <realloc_block_FF+0x3e9>
  80366f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803673:	75 17                	jne    80368c <realloc_block_FF+0x400>
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 7c 46 80 00       	push   $0x80467c
  80367d:	68 1a 02 00 00       	push   $0x21a
  803682:	68 09 46 80 00       	push   $0x804609
  803687:	e8 c8 03 00 00       	call   803a54 <_panic>
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	8b 10                	mov    (%eax),%edx
  803691:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803694:	89 10                	mov    %edx,(%eax)
  803696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	85 c0                	test   %eax,%eax
  80369d:	74 0b                	je     8036aa <realloc_block_FF+0x41e>
  80369f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a2:	8b 00                	mov    (%eax),%eax
  8036a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a7:	89 50 04             	mov    %edx,0x4(%eax)
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b8:	89 50 04             	mov    %edx,0x4(%eax)
  8036bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036be:	8b 00                	mov    (%eax),%eax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	75 08                	jne    8036cc <realloc_block_FF+0x440>
  8036c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d1:	40                   	inc    %eax
  8036d2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036d7:	eb 36                	jmp    80370f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e5:	74 07                	je     8036ee <realloc_block_FF+0x462>
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	eb 05                	jmp    8036f3 <realloc_block_FF+0x467>
  8036ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f8:	a1 34 50 80 00       	mov    0x805034,%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	0f 85 52 ff ff ff    	jne    803657 <realloc_block_FF+0x3cb>
  803705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803709:	0f 85 48 ff ff ff    	jne    803657 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	6a 00                	push   $0x0
  803714:	ff 75 d8             	pushl  -0x28(%ebp)
  803717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80371a:	e8 7a eb ff ff       	call   802299 <set_block_data>
  80371f:	83 c4 10             	add    $0x10,%esp
				return va;
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	e9 7b 02 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80372a:	83 ec 0c             	sub    $0xc,%esp
  80372d:	68 f9 46 80 00       	push   $0x8046f9
  803732:	e8 76 cf ff ff       	call   8006ad <cprintf>
  803737:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	e9 63 02 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803742:	8b 45 0c             	mov    0xc(%ebp),%eax
  803745:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803748:	0f 86 4d 02 00 00    	jbe    80399b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80374e:	83 ec 0c             	sub    $0xc,%esp
  803751:	ff 75 e4             	pushl  -0x1c(%ebp)
  803754:	e8 08 e8 ff ff       	call   801f61 <is_free_block>
  803759:	83 c4 10             	add    $0x10,%esp
  80375c:	84 c0                	test   %al,%al
  80375e:	0f 84 37 02 00 00    	je     80399b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803764:	8b 45 0c             	mov    0xc(%ebp),%eax
  803767:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80376a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80376d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803770:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803773:	76 38                	jbe    8037ad <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803775:	83 ec 0c             	sub    $0xc,%esp
  803778:	ff 75 08             	pushl  0x8(%ebp)
  80377b:	e8 0c fa ff ff       	call   80318c <free_block>
  803780:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803783:	83 ec 0c             	sub    $0xc,%esp
  803786:	ff 75 0c             	pushl  0xc(%ebp)
  803789:	e8 3a eb ff ff       	call   8022c8 <alloc_block_FF>
  80378e:	83 c4 10             	add    $0x10,%esp
  803791:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803794:	83 ec 08             	sub    $0x8,%esp
  803797:	ff 75 c0             	pushl  -0x40(%ebp)
  80379a:	ff 75 08             	pushl  0x8(%ebp)
  80379d:	e8 ab fa ff ff       	call   80324d <copy_data>
  8037a2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037a8:	e9 f8 01 00 00       	jmp    8039a5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037b6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ba:	0f 87 a0 00 00 00    	ja     803860 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c4:	75 17                	jne    8037dd <realloc_block_FF+0x551>
  8037c6:	83 ec 04             	sub    $0x4,%esp
  8037c9:	68 eb 45 80 00       	push   $0x8045eb
  8037ce:	68 38 02 00 00       	push   $0x238
  8037d3:	68 09 46 80 00       	push   $0x804609
  8037d8:	e8 77 02 00 00       	call   803a54 <_panic>
  8037dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 10                	je     8037f6 <realloc_block_FF+0x56a>
  8037e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ee:	8b 52 04             	mov    0x4(%edx),%edx
  8037f1:	89 50 04             	mov    %edx,0x4(%eax)
  8037f4:	eb 0b                	jmp    803801 <realloc_block_FF+0x575>
  8037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f9:	8b 40 04             	mov    0x4(%eax),%eax
  8037fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	8b 40 04             	mov    0x4(%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 0f                	je     80381a <realloc_block_FF+0x58e>
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	8b 40 04             	mov    0x4(%eax),%eax
  803811:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803814:	8b 12                	mov    (%edx),%edx
  803816:	89 10                	mov    %edx,(%eax)
  803818:	eb 0a                	jmp    803824 <realloc_block_FF+0x598>
  80381a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803827:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803837:	a1 38 50 80 00       	mov    0x805038,%eax
  80383c:	48                   	dec    %eax
  80383d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803842:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803848:	01 d0                	add    %edx,%eax
  80384a:	83 ec 04             	sub    $0x4,%esp
  80384d:	6a 01                	push   $0x1
  80384f:	50                   	push   %eax
  803850:	ff 75 08             	pushl  0x8(%ebp)
  803853:	e8 41 ea ff ff       	call   802299 <set_block_data>
  803858:	83 c4 10             	add    $0x10,%esp
  80385b:	e9 36 01 00 00       	jmp    803996 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803860:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803863:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803866:	01 d0                	add    %edx,%eax
  803868:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	6a 01                	push   $0x1
  803870:	ff 75 f0             	pushl  -0x10(%ebp)
  803873:	ff 75 08             	pushl  0x8(%ebp)
  803876:	e8 1e ea ff ff       	call   802299 <set_block_data>
  80387b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	83 e8 04             	sub    $0x4,%eax
  803884:	8b 00                	mov    (%eax),%eax
  803886:	83 e0 fe             	and    $0xfffffffe,%eax
  803889:	89 c2                	mov    %eax,%edx
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	01 d0                	add    %edx,%eax
  803890:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803893:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803897:	74 06                	je     80389f <realloc_block_FF+0x613>
  803899:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80389d:	75 17                	jne    8038b6 <realloc_block_FF+0x62a>
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 7c 46 80 00       	push   $0x80467c
  8038a7:	68 44 02 00 00       	push   $0x244
  8038ac:	68 09 46 80 00       	push   $0x804609
  8038b1:	e8 9e 01 00 00       	call   803a54 <_panic>
  8038b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b9:	8b 10                	mov    (%eax),%edx
  8038bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038be:	89 10                	mov    %edx,(%eax)
  8038c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	85 c0                	test   %eax,%eax
  8038c7:	74 0b                	je     8038d4 <realloc_block_FF+0x648>
  8038c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038d1:	89 50 04             	mov    %edx,0x4(%eax)
  8038d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038da:	89 10                	mov    %edx,(%eax)
  8038dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e2:	89 50 04             	mov    %edx,0x4(%eax)
  8038e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	75 08                	jne    8038f6 <realloc_block_FF+0x66a>
  8038ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8038fb:	40                   	inc    %eax
  8038fc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803905:	75 17                	jne    80391e <realloc_block_FF+0x692>
  803907:	83 ec 04             	sub    $0x4,%esp
  80390a:	68 eb 45 80 00       	push   $0x8045eb
  80390f:	68 45 02 00 00       	push   $0x245
  803914:	68 09 46 80 00       	push   $0x804609
  803919:	e8 36 01 00 00       	call   803a54 <_panic>
  80391e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803921:	8b 00                	mov    (%eax),%eax
  803923:	85 c0                	test   %eax,%eax
  803925:	74 10                	je     803937 <realloc_block_FF+0x6ab>
  803927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392a:	8b 00                	mov    (%eax),%eax
  80392c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392f:	8b 52 04             	mov    0x4(%edx),%edx
  803932:	89 50 04             	mov    %edx,0x4(%eax)
  803935:	eb 0b                	jmp    803942 <realloc_block_FF+0x6b6>
  803937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393a:	8b 40 04             	mov    0x4(%eax),%eax
  80393d:	a3 30 50 80 00       	mov    %eax,0x805030
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	8b 40 04             	mov    0x4(%eax),%eax
  803948:	85 c0                	test   %eax,%eax
  80394a:	74 0f                	je     80395b <realloc_block_FF+0x6cf>
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	8b 40 04             	mov    0x4(%eax),%eax
  803952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803955:	8b 12                	mov    (%edx),%edx
  803957:	89 10                	mov    %edx,(%eax)
  803959:	eb 0a                	jmp    803965 <realloc_block_FF+0x6d9>
  80395b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395e:	8b 00                	mov    (%eax),%eax
  803960:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803978:	a1 38 50 80 00       	mov    0x805038,%eax
  80397d:	48                   	dec    %eax
  80397e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803983:	83 ec 04             	sub    $0x4,%esp
  803986:	6a 00                	push   $0x0
  803988:	ff 75 bc             	pushl  -0x44(%ebp)
  80398b:	ff 75 b8             	pushl  -0x48(%ebp)
  80398e:	e8 06 e9 ff ff       	call   802299 <set_block_data>
  803993:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	eb 0a                	jmp    8039a5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80399b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039a5:	c9                   	leave  
  8039a6:	c3                   	ret    

008039a7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039a7:	55                   	push   %ebp
  8039a8:	89 e5                	mov    %esp,%ebp
  8039aa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	68 00 47 80 00       	push   $0x804700
  8039b5:	68 58 02 00 00       	push   $0x258
  8039ba:	68 09 46 80 00       	push   $0x804609
  8039bf:	e8 90 00 00 00       	call   803a54 <_panic>

008039c4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039c4:	55                   	push   %ebp
  8039c5:	89 e5                	mov    %esp,%ebp
  8039c7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039ca:	83 ec 04             	sub    $0x4,%esp
  8039cd:	68 28 47 80 00       	push   $0x804728
  8039d2:	68 61 02 00 00       	push   $0x261
  8039d7:	68 09 46 80 00       	push   $0x804609
  8039dc:	e8 73 00 00 00       	call   803a54 <_panic>

008039e1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8039e1:	55                   	push   %ebp
  8039e2:	89 e5                	mov    %esp,%ebp
  8039e4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8039e7:	83 ec 04             	sub    $0x4,%esp
  8039ea:	68 50 47 80 00       	push   $0x804750
  8039ef:	6a 09                	push   $0x9
  8039f1:	68 78 47 80 00       	push   $0x804778
  8039f6:	e8 59 00 00 00       	call   803a54 <_panic>

008039fb <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8039fb:	55                   	push   %ebp
  8039fc:	89 e5                	mov    %esp,%ebp
  8039fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 88 47 80 00       	push   $0x804788
  803a09:	6a 10                	push   $0x10
  803a0b:	68 78 47 80 00       	push   $0x804778
  803a10:	e8 3f 00 00 00       	call   803a54 <_panic>

00803a15 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a15:	55                   	push   %ebp
  803a16:	89 e5                	mov    %esp,%ebp
  803a18:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 b0 47 80 00       	push   $0x8047b0
  803a23:	6a 18                	push   $0x18
  803a25:	68 78 47 80 00       	push   $0x804778
  803a2a:	e8 25 00 00 00       	call   803a54 <_panic>

00803a2f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
  803a32:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803a35:	83 ec 04             	sub    $0x4,%esp
  803a38:	68 d8 47 80 00       	push   $0x8047d8
  803a3d:	6a 20                	push   $0x20
  803a3f:	68 78 47 80 00       	push   $0x804778
  803a44:	e8 0b 00 00 00       	call   803a54 <_panic>

00803a49 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803a49:	55                   	push   %ebp
  803a4a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	8b 40 10             	mov    0x10(%eax),%eax
}
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    

00803a54 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a54:	55                   	push   %ebp
  803a55:	89 e5                	mov    %esp,%ebp
  803a57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a5a:	8d 45 10             	lea    0x10(%ebp),%eax
  803a5d:	83 c0 04             	add    $0x4,%eax
  803a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a63:	a1 60 50 90 00       	mov    0x905060,%eax
  803a68:	85 c0                	test   %eax,%eax
  803a6a:	74 16                	je     803a82 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a6c:	a1 60 50 90 00       	mov    0x905060,%eax
  803a71:	83 ec 08             	sub    $0x8,%esp
  803a74:	50                   	push   %eax
  803a75:	68 00 48 80 00       	push   $0x804800
  803a7a:	e8 2e cc ff ff       	call   8006ad <cprintf>
  803a7f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a82:	a1 00 50 80 00       	mov    0x805000,%eax
  803a87:	ff 75 0c             	pushl  0xc(%ebp)
  803a8a:	ff 75 08             	pushl  0x8(%ebp)
  803a8d:	50                   	push   %eax
  803a8e:	68 05 48 80 00       	push   $0x804805
  803a93:	e8 15 cc ff ff       	call   8006ad <cprintf>
  803a98:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  803a9e:	83 ec 08             	sub    $0x8,%esp
  803aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  803aa4:	50                   	push   %eax
  803aa5:	e8 98 cb ff ff       	call   800642 <vcprintf>
  803aaa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803aad:	83 ec 08             	sub    $0x8,%esp
  803ab0:	6a 00                	push   $0x0
  803ab2:	68 21 48 80 00       	push   $0x804821
  803ab7:	e8 86 cb ff ff       	call   800642 <vcprintf>
  803abc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803abf:	e8 07 cb ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803ac4:	eb fe                	jmp    803ac4 <_panic+0x70>

00803ac6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ac6:	55                   	push   %ebp
  803ac7:	89 e5                	mov    %esp,%ebp
  803ac9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803acc:	a1 20 50 80 00       	mov    0x805020,%eax
  803ad1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ada:	39 c2                	cmp    %eax,%edx
  803adc:	74 14                	je     803af2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ade:	83 ec 04             	sub    $0x4,%esp
  803ae1:	68 24 48 80 00       	push   $0x804824
  803ae6:	6a 26                	push   $0x26
  803ae8:	68 70 48 80 00       	push   $0x804870
  803aed:	e8 62 ff ff ff       	call   803a54 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803af9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b00:	e9 c5 00 00 00       	jmp    803bca <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b12:	01 d0                	add    %edx,%eax
  803b14:	8b 00                	mov    (%eax),%eax
  803b16:	85 c0                	test   %eax,%eax
  803b18:	75 08                	jne    803b22 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b1a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b1d:	e9 a5 00 00 00       	jmp    803bc7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b30:	eb 69                	jmp    803b9b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b32:	a1 20 50 80 00       	mov    0x805020,%eax
  803b37:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b40:	89 d0                	mov    %edx,%eax
  803b42:	01 c0                	add    %eax,%eax
  803b44:	01 d0                	add    %edx,%eax
  803b46:	c1 e0 03             	shl    $0x3,%eax
  803b49:	01 c8                	add    %ecx,%eax
  803b4b:	8a 40 04             	mov    0x4(%eax),%al
  803b4e:	84 c0                	test   %al,%al
  803b50:	75 46                	jne    803b98 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b52:	a1 20 50 80 00       	mov    0x805020,%eax
  803b57:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b60:	89 d0                	mov    %edx,%eax
  803b62:	01 c0                	add    %eax,%eax
  803b64:	01 d0                	add    %edx,%eax
  803b66:	c1 e0 03             	shl    $0x3,%eax
  803b69:	01 c8                	add    %ecx,%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b78:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b84:	8b 45 08             	mov    0x8(%ebp),%eax
  803b87:	01 c8                	add    %ecx,%eax
  803b89:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b8b:	39 c2                	cmp    %eax,%edx
  803b8d:	75 09                	jne    803b98 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b8f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b96:	eb 15                	jmp    803bad <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b98:	ff 45 e8             	incl   -0x18(%ebp)
  803b9b:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba9:	39 c2                	cmp    %eax,%edx
  803bab:	77 85                	ja     803b32 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bb1:	75 14                	jne    803bc7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803bb3:	83 ec 04             	sub    $0x4,%esp
  803bb6:	68 7c 48 80 00       	push   $0x80487c
  803bbb:	6a 3a                	push   $0x3a
  803bbd:	68 70 48 80 00       	push   $0x804870
  803bc2:	e8 8d fe ff ff       	call   803a54 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803bc7:	ff 45 f0             	incl   -0x10(%ebp)
  803bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bd0:	0f 8c 2f ff ff ff    	jl     803b05 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bdd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803be4:	eb 26                	jmp    803c0c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803be6:	a1 20 50 80 00       	mov    0x805020,%eax
  803beb:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bf4:	89 d0                	mov    %edx,%eax
  803bf6:	01 c0                	add    %eax,%eax
  803bf8:	01 d0                	add    %edx,%eax
  803bfa:	c1 e0 03             	shl    $0x3,%eax
  803bfd:	01 c8                	add    %ecx,%eax
  803bff:	8a 40 04             	mov    0x4(%eax),%al
  803c02:	3c 01                	cmp    $0x1,%al
  803c04:	75 03                	jne    803c09 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c06:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c09:	ff 45 e0             	incl   -0x20(%ebp)
  803c0c:	a1 20 50 80 00       	mov    0x805020,%eax
  803c11:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1a:	39 c2                	cmp    %eax,%edx
  803c1c:	77 c8                	ja     803be6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c21:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c24:	74 14                	je     803c3a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c26:	83 ec 04             	sub    $0x4,%esp
  803c29:	68 d0 48 80 00       	push   $0x8048d0
  803c2e:	6a 44                	push   $0x44
  803c30:	68 70 48 80 00       	push   $0x804870
  803c35:	e8 1a fe ff ff       	call   803a54 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c3a:	90                   	nop
  803c3b:	c9                   	leave  
  803c3c:	c3                   	ret    
  803c3d:	66 90                	xchg   %ax,%ax
  803c3f:	90                   	nop

00803c40 <__udivdi3>:
  803c40:	55                   	push   %ebp
  803c41:	57                   	push   %edi
  803c42:	56                   	push   %esi
  803c43:	53                   	push   %ebx
  803c44:	83 ec 1c             	sub    $0x1c,%esp
  803c47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c57:	89 ca                	mov    %ecx,%edx
  803c59:	89 f8                	mov    %edi,%eax
  803c5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c5f:	85 f6                	test   %esi,%esi
  803c61:	75 2d                	jne    803c90 <__udivdi3+0x50>
  803c63:	39 cf                	cmp    %ecx,%edi
  803c65:	77 65                	ja     803ccc <__udivdi3+0x8c>
  803c67:	89 fd                	mov    %edi,%ebp
  803c69:	85 ff                	test   %edi,%edi
  803c6b:	75 0b                	jne    803c78 <__udivdi3+0x38>
  803c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c72:	31 d2                	xor    %edx,%edx
  803c74:	f7 f7                	div    %edi
  803c76:	89 c5                	mov    %eax,%ebp
  803c78:	31 d2                	xor    %edx,%edx
  803c7a:	89 c8                	mov    %ecx,%eax
  803c7c:	f7 f5                	div    %ebp
  803c7e:	89 c1                	mov    %eax,%ecx
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	f7 f5                	div    %ebp
  803c84:	89 cf                	mov    %ecx,%edi
  803c86:	89 fa                	mov    %edi,%edx
  803c88:	83 c4 1c             	add    $0x1c,%esp
  803c8b:	5b                   	pop    %ebx
  803c8c:	5e                   	pop    %esi
  803c8d:	5f                   	pop    %edi
  803c8e:	5d                   	pop    %ebp
  803c8f:	c3                   	ret    
  803c90:	39 ce                	cmp    %ecx,%esi
  803c92:	77 28                	ja     803cbc <__udivdi3+0x7c>
  803c94:	0f bd fe             	bsr    %esi,%edi
  803c97:	83 f7 1f             	xor    $0x1f,%edi
  803c9a:	75 40                	jne    803cdc <__udivdi3+0x9c>
  803c9c:	39 ce                	cmp    %ecx,%esi
  803c9e:	72 0a                	jb     803caa <__udivdi3+0x6a>
  803ca0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ca4:	0f 87 9e 00 00 00    	ja     803d48 <__udivdi3+0x108>
  803caa:	b8 01 00 00 00       	mov    $0x1,%eax
  803caf:	89 fa                	mov    %edi,%edx
  803cb1:	83 c4 1c             	add    $0x1c,%esp
  803cb4:	5b                   	pop    %ebx
  803cb5:	5e                   	pop    %esi
  803cb6:	5f                   	pop    %edi
  803cb7:	5d                   	pop    %ebp
  803cb8:	c3                   	ret    
  803cb9:	8d 76 00             	lea    0x0(%esi),%esi
  803cbc:	31 ff                	xor    %edi,%edi
  803cbe:	31 c0                	xor    %eax,%eax
  803cc0:	89 fa                	mov    %edi,%edx
  803cc2:	83 c4 1c             	add    $0x1c,%esp
  803cc5:	5b                   	pop    %ebx
  803cc6:	5e                   	pop    %esi
  803cc7:	5f                   	pop    %edi
  803cc8:	5d                   	pop    %ebp
  803cc9:	c3                   	ret    
  803cca:	66 90                	xchg   %ax,%ax
  803ccc:	89 d8                	mov    %ebx,%eax
  803cce:	f7 f7                	div    %edi
  803cd0:	31 ff                	xor    %edi,%edi
  803cd2:	89 fa                	mov    %edi,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ce1:	89 eb                	mov    %ebp,%ebx
  803ce3:	29 fb                	sub    %edi,%ebx
  803ce5:	89 f9                	mov    %edi,%ecx
  803ce7:	d3 e6                	shl    %cl,%esi
  803ce9:	89 c5                	mov    %eax,%ebp
  803ceb:	88 d9                	mov    %bl,%cl
  803ced:	d3 ed                	shr    %cl,%ebp
  803cef:	89 e9                	mov    %ebp,%ecx
  803cf1:	09 f1                	or     %esi,%ecx
  803cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cf7:	89 f9                	mov    %edi,%ecx
  803cf9:	d3 e0                	shl    %cl,%eax
  803cfb:	89 c5                	mov    %eax,%ebp
  803cfd:	89 d6                	mov    %edx,%esi
  803cff:	88 d9                	mov    %bl,%cl
  803d01:	d3 ee                	shr    %cl,%esi
  803d03:	89 f9                	mov    %edi,%ecx
  803d05:	d3 e2                	shl    %cl,%edx
  803d07:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0b:	88 d9                	mov    %bl,%cl
  803d0d:	d3 e8                	shr    %cl,%eax
  803d0f:	09 c2                	or     %eax,%edx
  803d11:	89 d0                	mov    %edx,%eax
  803d13:	89 f2                	mov    %esi,%edx
  803d15:	f7 74 24 0c          	divl   0xc(%esp)
  803d19:	89 d6                	mov    %edx,%esi
  803d1b:	89 c3                	mov    %eax,%ebx
  803d1d:	f7 e5                	mul    %ebp
  803d1f:	39 d6                	cmp    %edx,%esi
  803d21:	72 19                	jb     803d3c <__udivdi3+0xfc>
  803d23:	74 0b                	je     803d30 <__udivdi3+0xf0>
  803d25:	89 d8                	mov    %ebx,%eax
  803d27:	31 ff                	xor    %edi,%edi
  803d29:	e9 58 ff ff ff       	jmp    803c86 <__udivdi3+0x46>
  803d2e:	66 90                	xchg   %ax,%ax
  803d30:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d34:	89 f9                	mov    %edi,%ecx
  803d36:	d3 e2                	shl    %cl,%edx
  803d38:	39 c2                	cmp    %eax,%edx
  803d3a:	73 e9                	jae    803d25 <__udivdi3+0xe5>
  803d3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d3f:	31 ff                	xor    %edi,%edi
  803d41:	e9 40 ff ff ff       	jmp    803c86 <__udivdi3+0x46>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	31 c0                	xor    %eax,%eax
  803d4a:	e9 37 ff ff ff       	jmp    803c86 <__udivdi3+0x46>
  803d4f:	90                   	nop

00803d50 <__umoddi3>:
  803d50:	55                   	push   %ebp
  803d51:	57                   	push   %edi
  803d52:	56                   	push   %esi
  803d53:	53                   	push   %ebx
  803d54:	83 ec 1c             	sub    $0x1c,%esp
  803d57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d6f:	89 f3                	mov    %esi,%ebx
  803d71:	89 fa                	mov    %edi,%edx
  803d73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d77:	89 34 24             	mov    %esi,(%esp)
  803d7a:	85 c0                	test   %eax,%eax
  803d7c:	75 1a                	jne    803d98 <__umoddi3+0x48>
  803d7e:	39 f7                	cmp    %esi,%edi
  803d80:	0f 86 a2 00 00 00    	jbe    803e28 <__umoddi3+0xd8>
  803d86:	89 c8                	mov    %ecx,%eax
  803d88:	89 f2                	mov    %esi,%edx
  803d8a:	f7 f7                	div    %edi
  803d8c:	89 d0                	mov    %edx,%eax
  803d8e:	31 d2                	xor    %edx,%edx
  803d90:	83 c4 1c             	add    $0x1c,%esp
  803d93:	5b                   	pop    %ebx
  803d94:	5e                   	pop    %esi
  803d95:	5f                   	pop    %edi
  803d96:	5d                   	pop    %ebp
  803d97:	c3                   	ret    
  803d98:	39 f0                	cmp    %esi,%eax
  803d9a:	0f 87 ac 00 00 00    	ja     803e4c <__umoddi3+0xfc>
  803da0:	0f bd e8             	bsr    %eax,%ebp
  803da3:	83 f5 1f             	xor    $0x1f,%ebp
  803da6:	0f 84 ac 00 00 00    	je     803e58 <__umoddi3+0x108>
  803dac:	bf 20 00 00 00       	mov    $0x20,%edi
  803db1:	29 ef                	sub    %ebp,%edi
  803db3:	89 fe                	mov    %edi,%esi
  803db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803db9:	89 e9                	mov    %ebp,%ecx
  803dbb:	d3 e0                	shl    %cl,%eax
  803dbd:	89 d7                	mov    %edx,%edi
  803dbf:	89 f1                	mov    %esi,%ecx
  803dc1:	d3 ef                	shr    %cl,%edi
  803dc3:	09 c7                	or     %eax,%edi
  803dc5:	89 e9                	mov    %ebp,%ecx
  803dc7:	d3 e2                	shl    %cl,%edx
  803dc9:	89 14 24             	mov    %edx,(%esp)
  803dcc:	89 d8                	mov    %ebx,%eax
  803dce:	d3 e0                	shl    %cl,%eax
  803dd0:	89 c2                	mov    %eax,%edx
  803dd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dd6:	d3 e0                	shl    %cl,%eax
  803dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ddc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de0:	89 f1                	mov    %esi,%ecx
  803de2:	d3 e8                	shr    %cl,%eax
  803de4:	09 d0                	or     %edx,%eax
  803de6:	d3 eb                	shr    %cl,%ebx
  803de8:	89 da                	mov    %ebx,%edx
  803dea:	f7 f7                	div    %edi
  803dec:	89 d3                	mov    %edx,%ebx
  803dee:	f7 24 24             	mull   (%esp)
  803df1:	89 c6                	mov    %eax,%esi
  803df3:	89 d1                	mov    %edx,%ecx
  803df5:	39 d3                	cmp    %edx,%ebx
  803df7:	0f 82 87 00 00 00    	jb     803e84 <__umoddi3+0x134>
  803dfd:	0f 84 91 00 00 00    	je     803e94 <__umoddi3+0x144>
  803e03:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e07:	29 f2                	sub    %esi,%edx
  803e09:	19 cb                	sbb    %ecx,%ebx
  803e0b:	89 d8                	mov    %ebx,%eax
  803e0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e11:	d3 e0                	shl    %cl,%eax
  803e13:	89 e9                	mov    %ebp,%ecx
  803e15:	d3 ea                	shr    %cl,%edx
  803e17:	09 d0                	or     %edx,%eax
  803e19:	89 e9                	mov    %ebp,%ecx
  803e1b:	d3 eb                	shr    %cl,%ebx
  803e1d:	89 da                	mov    %ebx,%edx
  803e1f:	83 c4 1c             	add    $0x1c,%esp
  803e22:	5b                   	pop    %ebx
  803e23:	5e                   	pop    %esi
  803e24:	5f                   	pop    %edi
  803e25:	5d                   	pop    %ebp
  803e26:	c3                   	ret    
  803e27:	90                   	nop
  803e28:	89 fd                	mov    %edi,%ebp
  803e2a:	85 ff                	test   %edi,%edi
  803e2c:	75 0b                	jne    803e39 <__umoddi3+0xe9>
  803e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e33:	31 d2                	xor    %edx,%edx
  803e35:	f7 f7                	div    %edi
  803e37:	89 c5                	mov    %eax,%ebp
  803e39:	89 f0                	mov    %esi,%eax
  803e3b:	31 d2                	xor    %edx,%edx
  803e3d:	f7 f5                	div    %ebp
  803e3f:	89 c8                	mov    %ecx,%eax
  803e41:	f7 f5                	div    %ebp
  803e43:	89 d0                	mov    %edx,%eax
  803e45:	e9 44 ff ff ff       	jmp    803d8e <__umoddi3+0x3e>
  803e4a:	66 90                	xchg   %ax,%ax
  803e4c:	89 c8                	mov    %ecx,%eax
  803e4e:	89 f2                	mov    %esi,%edx
  803e50:	83 c4 1c             	add    $0x1c,%esp
  803e53:	5b                   	pop    %ebx
  803e54:	5e                   	pop    %esi
  803e55:	5f                   	pop    %edi
  803e56:	5d                   	pop    %ebp
  803e57:	c3                   	ret    
  803e58:	3b 04 24             	cmp    (%esp),%eax
  803e5b:	72 06                	jb     803e63 <__umoddi3+0x113>
  803e5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e61:	77 0f                	ja     803e72 <__umoddi3+0x122>
  803e63:	89 f2                	mov    %esi,%edx
  803e65:	29 f9                	sub    %edi,%ecx
  803e67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e6b:	89 14 24             	mov    %edx,(%esp)
  803e6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e72:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e76:	8b 14 24             	mov    (%esp),%edx
  803e79:	83 c4 1c             	add    $0x1c,%esp
  803e7c:	5b                   	pop    %ebx
  803e7d:	5e                   	pop    %esi
  803e7e:	5f                   	pop    %edi
  803e7f:	5d                   	pop    %ebp
  803e80:	c3                   	ret    
  803e81:	8d 76 00             	lea    0x0(%esi),%esi
  803e84:	2b 04 24             	sub    (%esp),%eax
  803e87:	19 fa                	sbb    %edi,%edx
  803e89:	89 d1                	mov    %edx,%ecx
  803e8b:	89 c6                	mov    %eax,%esi
  803e8d:	e9 71 ff ff ff       	jmp    803e03 <__umoddi3+0xb3>
  803e92:	66 90                	xchg   %ax,%ax
  803e94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e98:	72 ea                	jb     803e84 <__umoddi3+0x134>
  803e9a:	89 d9                	mov    %ebx,%ecx
  803e9c:	e9 62 ff ff ff       	jmp    803e03 <__umoddi3+0xb3>

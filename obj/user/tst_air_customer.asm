
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
  800044:	e8 38 18 00 00       	call   801881 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb c9 20 80 00       	mov    $0x8020c9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb d3 20 80 00       	mov    $0x8020d3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb df 20 80 00       	mov    $0x8020df,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ee 20 80 00       	mov    $0x8020ee,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb fd 20 80 00       	mov    $0x8020fd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 12 21 80 00       	mov    $0x802112,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 27 21 80 00       	mov    $0x802127,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 38 21 80 00       	mov    $0x802138,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 49 21 80 00       	mov    $0x802149,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 5a 21 80 00       	mov    $0x80215a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 63 21 80 00       	mov    $0x802163,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 6d 21 80 00       	mov    $0x80216d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 78 21 80 00       	mov    $0x802178,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 84 21 80 00       	mov    $0x802184,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 8e 21 80 00       	mov    $0x80218e,%ebx
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
  8001be:	bb 98 21 80 00       	mov    $0x802198,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb a6 21 80 00       	mov    $0x8021a6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb b5 21 80 00       	mov    $0x8021b5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb bc 21 80 00       	mov    $0x8021bc,%ebx
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
  800222:	e8 b6 12 00 00       	call   8014dd <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 a1 12 00 00       	call   8014dd <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 89 12 00 00       	call   8014dd <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 71 12 00 00       	call   8014dd <sget>
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
  800286:	e8 3b 19 00 00       	call   801bc6 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 1f 19 00 00       	call   801bc6 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 03 19 00 00       	call   801bc6 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 e7 18 00 00       	call   801bc6 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 cb 18 00 00       	call   801bc6 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 d4 18 00 00       	call   801be0 <wait_semaphore>
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
  80032d:	e8 c8 18 00 00       	call   801bfa <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 9d 18 00 00       	call   801be0 <wait_semaphore>
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
  800363:	e8 78 18 00 00       	call   801be0 <wait_semaphore>
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
  800397:	e8 5e 18 00 00       	call   801bfa <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 4d 18 00 00       	call   801bfa <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb c3 21 80 00       	mov    $0x8021c3,%ebx
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
  8003e9:	e8 07 0e 00 00       	call   8011f5 <ltostr>
  8003ee:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	e8 c0 0e 00 00       	call   8012ce <strcconcat>
  80040e:	83 c4 10             	add    $0x10,%esp
	//sys_waitSemaphore(parentenvID, sname);
	struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  800411:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	8d 95 63 fe ff ff    	lea    -0x19d(%ebp),%edx
  800420:	52                   	push   %edx
  800421:	ff 75 e4             	pushl  -0x1c(%ebp)
  800424:	50                   	push   %eax
  800425:	e8 9c 17 00 00       	call   801bc6 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 a5 17 00 00       	call   801be0 <wait_semaphore>
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
  80045e:	68 80 20 80 00       	push   $0x802080
  800463:	e8 80 02 00 00       	call   8006e8 <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 a8 20 80 00       	push   $0x8020a8
  800478:	e8 6b 02 00 00       	call   8006e8 <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 6c 17 00 00       	call   801bfa <signal_semaphore>
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
  8004a0:	e8 c3 13 00 00       	call   801868 <sys_getenvindex>
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8004a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	c1 e0 06             	shl    $0x6,%eax
  8004b0:	29 d0                	sub    %edx,%eax
  8004b2:	c1 e0 02             	shl    $0x2,%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004be:	01 c8                	add    %ecx,%eax
  8004c0:	c1 e0 03             	shl    $0x3,%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cc:	29 c2                	sub    %eax,%edx
  8004ce:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8004d5:	89 c2                	mov    %eax,%edx
  8004d7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8004dd:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e7:	8a 40 20             	mov    0x20(%eax),%al
  8004ea:	84 c0                	test   %al,%al
  8004ec:	74 0d                	je     8004fb <libmain+0x61>
		binaryname = myEnv->prog_name;
  8004ee:	a1 04 30 80 00       	mov    0x803004,%eax
  8004f3:	83 c0 20             	add    $0x20,%eax
  8004f6:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004ff:	7e 0a                	jle    80050b <libmain+0x71>
		binaryname = argv[0];
  800501:	8b 45 0c             	mov    0xc(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 0c             	pushl  0xc(%ebp)
  800511:	ff 75 08             	pushl  0x8(%ebp)
  800514:	e8 1f fb ff ff       	call   800038 <_main>
  800519:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80051c:	e8 cb 10 00 00       	call   8015ec <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	68 fc 21 80 00       	push   $0x8021fc
  800529:	e8 8d 01 00 00       	call   8006bb <cprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800531:	a1 04 30 80 00       	mov    0x803004,%eax
  800536:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80053c:	a1 04 30 80 00       	mov    0x803004,%eax
  800541:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	52                   	push   %edx
  80054b:	50                   	push   %eax
  80054c:	68 24 22 80 00       	push   $0x802224
  800551:	e8 65 01 00 00       	call   8006bb <cprintf>
  800556:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800559:	a1 04 30 80 00       	mov    0x803004,%eax
  80055e:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800564:	a1 04 30 80 00       	mov    0x803004,%eax
  800569:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80056f:	a1 04 30 80 00       	mov    0x803004,%eax
  800574:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80057a:	51                   	push   %ecx
  80057b:	52                   	push   %edx
  80057c:	50                   	push   %eax
  80057d:	68 4c 22 80 00       	push   $0x80224c
  800582:	e8 34 01 00 00       	call   8006bb <cprintf>
  800587:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80058a:	a1 04 30 80 00       	mov    0x803004,%eax
  80058f:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	50                   	push   %eax
  800599:	68 a4 22 80 00       	push   $0x8022a4
  80059e:	e8 18 01 00 00       	call   8006bb <cprintf>
  8005a3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	68 fc 21 80 00       	push   $0x8021fc
  8005ae:	e8 08 01 00 00       	call   8006bb <cprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005b6:	e8 4b 10 00 00       	call   801606 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8005bb:	e8 19 00 00 00       	call   8005d9 <exit>
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005c9:	83 ec 0c             	sub    $0xc,%esp
  8005cc:	6a 00                	push   $0x0
  8005ce:	e8 61 12 00 00       	call   801834 <sys_destroy_env>
  8005d3:	83 c4 10             	add    $0x10,%esp
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <exit>:

void
exit(void)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005df:	e8 b6 12 00 00       	call   80189a <sys_exit_env>
}
  8005e4:	90                   	nop
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f8:	89 0a                	mov    %ecx,(%edx)
  8005fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fd:	88 d1                	mov    %dl,%cl
  8005ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800602:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800610:	75 2c                	jne    80063e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800612:	a0 08 30 80 00       	mov    0x803008,%al
  800617:	0f b6 c0             	movzbl %al,%eax
  80061a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061d:	8b 12                	mov    (%edx),%edx
  80061f:	89 d1                	mov    %edx,%ecx
  800621:	8b 55 0c             	mov    0xc(%ebp),%edx
  800624:	83 c2 08             	add    $0x8,%edx
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	50                   	push   %eax
  80062b:	51                   	push   %ecx
  80062c:	52                   	push   %edx
  80062d:	e8 78 0f 00 00       	call   8015aa <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80063e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800641:	8b 40 04             	mov    0x4(%eax),%eax
  800644:	8d 50 01             	lea    0x1(%eax),%edx
  800647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80064d:	90                   	nop
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800659:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800660:	00 00 00 
	b.cnt = 0;
  800663:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800679:	50                   	push   %eax
  80067a:	68 e7 05 80 00       	push   $0x8005e7
  80067f:	e8 11 02 00 00       	call   800895 <vprintfmt>
  800684:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800687:	a0 08 30 80 00       	mov    0x803008,%al
  80068c:	0f b6 c0             	movzbl %al,%eax
  80068f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	50                   	push   %eax
  800699:	52                   	push   %edx
  80069a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a0:	83 c0 08             	add    $0x8,%eax
  8006a3:	50                   	push   %eax
  8006a4:	e8 01 0f 00 00       	call   8015aa <sys_cputs>
  8006a9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ac:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8006b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d7:	50                   	push   %eax
  8006d8:	e8 73 ff ff ff       	call   800650 <vcprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ee:	e8 f9 0e 00 00       	call   8015ec <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800702:	50                   	push   %eax
  800703:	e8 48 ff ff ff       	call   800650 <vcprintf>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80070e:	e8 f3 0e 00 00       	call   801606 <sys_unlock_cons>
	return cnt;
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	53                   	push   %ebx
  80071c:	83 ec 14             	sub    $0x14,%esp
  80071f:	8b 45 10             	mov    0x10(%ebp),%eax
  800722:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072b:	8b 45 18             	mov    0x18(%ebp),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800736:	77 55                	ja     80078d <printnum+0x75>
  800738:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073b:	72 05                	jb     800742 <printnum+0x2a>
  80073d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800740:	77 4b                	ja     80078d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800742:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800745:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800748:	8b 45 18             	mov    0x18(%ebp),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	ff 75 f4             	pushl  -0xc(%ebp)
  800755:	ff 75 f0             	pushl  -0x10(%ebp)
  800758:	e8 ab 16 00 00       	call   801e08 <__udivdi3>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	ff 75 20             	pushl  0x20(%ebp)
  800766:	53                   	push   %ebx
  800767:	ff 75 18             	pushl  0x18(%ebp)
  80076a:	52                   	push   %edx
  80076b:	50                   	push   %eax
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	e8 a1 ff ff ff       	call   800718 <printnum>
  800777:	83 c4 20             	add    $0x20,%esp
  80077a:	eb 1a                	jmp    800796 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	ff 75 20             	pushl  0x20(%ebp)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	ff d0                	call   *%eax
  80078a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078d:	ff 4d 1c             	decl   0x1c(%ebp)
  800790:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800794:	7f e6                	jg     80077c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800796:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800799:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a4:	53                   	push   %ebx
  8007a5:	51                   	push   %ecx
  8007a6:	52                   	push   %edx
  8007a7:	50                   	push   %eax
  8007a8:	e8 6b 17 00 00       	call   801f18 <__umoddi3>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	05 d4 24 80 00       	add    $0x8024d4,%eax
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f be c0             	movsbl %al,%eax
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	50                   	push   %eax
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
}
  8007c9:	90                   	nop
  8007ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d6:	7e 1c                	jle    8007f4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 08             	lea    0x8(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 08             	sub    $0x8,%eax
  8007ed:	8b 50 04             	mov    0x4(%eax),%edx
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	eb 40                	jmp    800834 <getuint+0x65>
	else if (lflag)
  8007f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f8:	74 1e                	je     800818 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	8d 50 04             	lea    0x4(%eax),%edx
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	89 10                	mov    %edx,(%eax)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	eb 1c                	jmp    800834 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	8d 50 04             	lea    0x4(%eax),%edx
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	89 10                	mov    %edx,(%eax)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800839:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083d:	7e 1c                	jle    80085b <getint+0x25>
		return va_arg(*ap, long long);
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	8d 50 08             	lea    0x8(%eax),%edx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	89 10                	mov    %edx,(%eax)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	83 e8 08             	sub    $0x8,%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	eb 38                	jmp    800893 <getint+0x5d>
	else if (lflag)
  80085b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085f:	74 1a                	je     80087b <getint+0x45>
		return va_arg(*ap, long);
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	8d 50 04             	lea    0x4(%eax),%edx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	89 10                	mov    %edx,(%eax)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	83 e8 04             	sub    $0x4,%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	99                   	cltd   
  800879:	eb 18                	jmp    800893 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	8d 50 04             	lea    0x4(%eax),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	89 10                	mov    %edx,(%eax)
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	83 e8 04             	sub    $0x4,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	99                   	cltd   
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089d:	eb 17                	jmp    8008b6 <vprintfmt+0x21>
			if (ch == '\0')
  80089f:	85 db                	test   %ebx,%ebx
  8008a1:	0f 84 c1 03 00 00    	je     800c68 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	53                   	push   %ebx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	8d 50 01             	lea    0x1(%eax),%edx
  8008bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f b6 d8             	movzbl %al,%ebx
  8008c4:	83 fb 25             	cmp    $0x25,%ebx
  8008c7:	75 d6                	jne    80089f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008cd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ec:	8d 50 01             	lea    0x1(%eax),%edx
  8008ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	0f b6 d8             	movzbl %al,%ebx
  8008f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fa:	83 f8 5b             	cmp    $0x5b,%eax
  8008fd:	0f 87 3d 03 00 00    	ja     800c40 <vprintfmt+0x3ab>
  800903:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  80090a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800910:	eb d7                	jmp    8008e9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800912:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800916:	eb d1                	jmp    8008e9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80091f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800922:	89 d0                	mov    %edx,%eax
  800924:	c1 e0 02             	shl    $0x2,%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	01 c0                	add    %eax,%eax
  80092b:	01 d8                	add    %ebx,%eax
  80092d:	83 e8 30             	sub    $0x30,%eax
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	8a 00                	mov    (%eax),%al
  800938:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093b:	83 fb 2f             	cmp    $0x2f,%ebx
  80093e:	7e 3e                	jle    80097e <vprintfmt+0xe9>
  800940:	83 fb 39             	cmp    $0x39,%ebx
  800943:	7f 39                	jg     80097e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800945:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800948:	eb d5                	jmp    80091f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 c0 04             	add    $0x4,%eax
  800950:	89 45 14             	mov    %eax,0x14(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095e:	eb 1f                	jmp    80097f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800960:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800964:	79 83                	jns    8008e9 <vprintfmt+0x54>
				width = 0;
  800966:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096d:	e9 77 ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800972:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800979:	e9 6b ff ff ff       	jmp    8008e9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80097f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800983:	0f 89 60 ff ff ff    	jns    8008e9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800996:	e9 4e ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099e:	e9 46 ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	83 e8 04             	sub    $0x4,%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	50                   	push   %eax
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	ff d0                	call   *%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
			break;
  8009c3:	e9 9b 02 00 00       	jmp    800c63 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	83 e8 04             	sub    $0x4,%eax
  8009d7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d9:	85 db                	test   %ebx,%ebx
  8009db:	79 02                	jns    8009df <vprintfmt+0x14a>
				err = -err;
  8009dd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009df:	83 fb 64             	cmp    $0x64,%ebx
  8009e2:	7f 0b                	jg     8009ef <vprintfmt+0x15a>
  8009e4:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  8009eb:	85 f6                	test   %esi,%esi
  8009ed:	75 19                	jne    800a08 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ef:	53                   	push   %ebx
  8009f0:	68 e5 24 80 00       	push   $0x8024e5
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	ff 75 08             	pushl  0x8(%ebp)
  8009fb:	e8 70 02 00 00       	call   800c70 <printfmt>
  800a00:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a03:	e9 5b 02 00 00       	jmp    800c63 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a08:	56                   	push   %esi
  800a09:	68 ee 24 80 00       	push   $0x8024ee
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 57 02 00 00       	call   800c70 <printfmt>
  800a19:	83 c4 10             	add    $0x10,%esp
			break;
  800a1c:	e9 42 02 00 00       	jmp    800c63 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 c0 04             	add    $0x4,%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	83 e8 04             	sub    $0x4,%eax
  800a30:	8b 30                	mov    (%eax),%esi
  800a32:	85 f6                	test   %esi,%esi
  800a34:	75 05                	jne    800a3b <vprintfmt+0x1a6>
				p = "(null)";
  800a36:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  800a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3f:	7e 6d                	jle    800aae <vprintfmt+0x219>
  800a41:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a45:	74 67                	je     800aae <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	50                   	push   %eax
  800a4e:	56                   	push   %esi
  800a4f:	e8 1e 03 00 00       	call   800d72 <strnlen>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5a:	eb 16                	jmp    800a72 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	50                   	push   %eax
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a76:	7f e4                	jg     800a5c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a78:	eb 34                	jmp    800aae <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7e:	74 1c                	je     800a9c <vprintfmt+0x207>
  800a80:	83 fb 1f             	cmp    $0x1f,%ebx
  800a83:	7e 05                	jle    800a8a <vprintfmt+0x1f5>
  800a85:	83 fb 7e             	cmp    $0x7e,%ebx
  800a88:	7e 12                	jle    800a9c <vprintfmt+0x207>
					putch('?', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 3f                	push   $0x3f
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	eb 0f                	jmp    800aab <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aab:	ff 4d e4             	decl   -0x1c(%ebp)
  800aae:	89 f0                	mov    %esi,%eax
  800ab0:	8d 70 01             	lea    0x1(%eax),%esi
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	0f be d8             	movsbl %al,%ebx
  800ab8:	85 db                	test   %ebx,%ebx
  800aba:	74 24                	je     800ae0 <vprintfmt+0x24b>
  800abc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac0:	78 b8                	js     800a7a <vprintfmt+0x1e5>
  800ac2:	ff 4d e0             	decl   -0x20(%ebp)
  800ac5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac9:	79 af                	jns    800a7a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acb:	eb 13                	jmp    800ae0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	6a 20                	push   $0x20
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800add:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae4:	7f e7                	jg     800acd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae6:	e9 78 01 00 00       	jmp    800c63 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 e8             	pushl  -0x18(%ebp)
  800af1:	8d 45 14             	lea    0x14(%ebp),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 3c fd ff ff       	call   800836 <getint>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b09:	85 d2                	test   %edx,%edx
  800b0b:	79 23                	jns    800b30 <vprintfmt+0x29b>
				putch('-', putdat);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	6a 2d                	push   $0x2d
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b23:	f7 d8                	neg    %eax
  800b25:	83 d2 00             	adc    $0x0,%edx
  800b28:	f7 da                	neg    %edx
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b30:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b37:	e9 bc 00 00 00       	jmp    800bf8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 84 fc ff ff       	call   8007cf <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5b:	e9 98 00 00 00       	jmp    800bf8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 58                	push   $0x58
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	6a 58                	push   $0x58
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 58                	push   $0x58
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			break;
  800b90:	e9 ce 00 00 00       	jmp    800c63 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 30                	push   $0x30
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 78                	push   $0x78
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb8:	83 c0 04             	add    $0x4,%eax
  800bbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd7:	eb 1f                	jmp    800bf8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdf:	8d 45 14             	lea    0x14(%ebp),%eax
  800be2:	50                   	push   %eax
  800be3:	e8 e7 fb ff ff       	call   8007cf <getuint>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bff:	83 ec 04             	sub    $0x4,%esp
  800c02:	52                   	push   %edx
  800c03:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c06:	50                   	push   %eax
  800c07:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 08             	pushl  0x8(%ebp)
  800c13:	e8 00 fb ff ff       	call   800718 <printnum>
  800c18:	83 c4 20             	add    $0x20,%esp
			break;
  800c1b:	eb 46                	jmp    800c63 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	53                   	push   %ebx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	ff d0                	call   *%eax
  800c29:	83 c4 10             	add    $0x10,%esp
			break;
  800c2c:	eb 35                	jmp    800c63 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c2e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c35:	eb 2c                	jmp    800c63 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c37:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c3e:	eb 23                	jmp    800c63 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	6a 25                	push   $0x25
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c50:	ff 4d 10             	decl   0x10(%ebp)
  800c53:	eb 03                	jmp    800c58 <vprintfmt+0x3c3>
  800c55:	ff 4d 10             	decl   0x10(%ebp)
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	48                   	dec    %eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	3c 25                	cmp    $0x25,%al
  800c60:	75 f3                	jne    800c55 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c62:	90                   	nop
		}
	}
  800c63:	e9 35 fc ff ff       	jmp    80089d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c68:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c76:	8d 45 10             	lea    0x10(%ebp),%eax
  800c79:	83 c0 04             	add    $0x4,%eax
  800c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	ff 75 f4             	pushl  -0xc(%ebp)
  800c85:	50                   	push   %eax
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	ff 75 08             	pushl  0x8(%ebp)
  800c8c:	e8 04 fc ff ff       	call   800895 <vprintfmt>
  800c91:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c94:	90                   	nop
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8b 40 08             	mov    0x8(%eax),%eax
  800ca0:	8d 50 01             	lea    0x1(%eax),%edx
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8b 10                	mov    (%eax),%edx
  800cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb1:	8b 40 04             	mov    0x4(%eax),%eax
  800cb4:	39 c2                	cmp    %eax,%edx
  800cb6:	73 12                	jae    800cca <sprintputch+0x33>
		*b->buf++ = ch;
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8b 00                	mov    (%eax),%eax
  800cbd:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc3:	89 0a                	mov    %ecx,(%edx)
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	88 10                	mov    %dl,(%eax)
}
  800cca:	90                   	nop
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	01 d0                	add    %edx,%eax
  800ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf2:	74 06                	je     800cfa <vsnprintf+0x2d>
  800cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf8:	7f 07                	jg     800d01 <vsnprintf+0x34>
		return -E_INVAL;
  800cfa:	b8 03 00 00 00       	mov    $0x3,%eax
  800cff:	eb 20                	jmp    800d21 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d01:	ff 75 14             	pushl  0x14(%ebp)
  800d04:	ff 75 10             	pushl  0x10(%ebp)
  800d07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0a:	50                   	push   %eax
  800d0b:	68 97 0c 80 00       	push   $0x800c97
  800d10:	e8 80 fb ff ff       	call   800895 <vprintfmt>
  800d15:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d29:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2c:	83 c0 04             	add    $0x4,%eax
  800d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d32:	8b 45 10             	mov    0x10(%ebp),%eax
  800d35:	ff 75 f4             	pushl  -0xc(%ebp)
  800d38:	50                   	push   %eax
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	ff 75 08             	pushl  0x8(%ebp)
  800d3f:	e8 89 ff ff ff       	call   800ccd <vsnprintf>
  800d44:	83 c4 10             	add    $0x10,%esp
  800d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5c:	eb 06                	jmp    800d64 <strlen+0x15>
		n++;
  800d5e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d61:	ff 45 08             	incl   0x8(%ebp)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	84 c0                	test   %al,%al
  800d6b:	75 f1                	jne    800d5e <strlen+0xf>
		n++;
	return n;
  800d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7f:	eb 09                	jmp    800d8a <strnlen+0x18>
		n++;
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d84:	ff 45 08             	incl   0x8(%ebp)
  800d87:	ff 4d 0c             	decl   0xc(%ebp)
  800d8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8e:	74 09                	je     800d99 <strnlen+0x27>
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	84 c0                	test   %al,%al
  800d97:	75 e8                	jne    800d81 <strnlen+0xf>
		n++;
	return n;
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800daa:	90                   	nop
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 08             	mov    %edx,0x8(%ebp)
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dbd:	8a 12                	mov    (%edx),%dl
  800dbf:	88 10                	mov    %dl,(%eax)
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	75 e4                	jne    800dab <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddf:	eb 1f                	jmp    800e00 <strncpy+0x34>
		*dst++ = *src;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8d 50 01             	lea    0x1(%eax),%edx
  800de7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ded:	8a 12                	mov    (%edx),%dl
  800def:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	84 c0                	test   %al,%al
  800df8:	74 03                	je     800dfd <strncpy+0x31>
			src++;
  800dfa:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dfd:	ff 45 fc             	incl   -0x4(%ebp)
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e06:	72 d9                	jb     800de1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1d:	74 30                	je     800e4f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e1f:	eb 16                	jmp    800e37 <strlcpy+0x2a>
			*dst++ = *src++;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e33:	8a 12                	mov    (%edx),%dl
  800e35:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e37:	ff 4d 10             	decl   0x10(%ebp)
  800e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3e:	74 09                	je     800e49 <strlcpy+0x3c>
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	75 d8                	jne    800e21 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e55:	29 c2                	sub    %eax,%edx
  800e57:	89 d0                	mov    %edx,%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e5e:	eb 06                	jmp    800e66 <strcmp+0xb>
		p++, q++;
  800e60:	ff 45 08             	incl   0x8(%ebp)
  800e63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	74 0e                	je     800e7d <strcmp+0x22>
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 10                	mov    (%eax),%dl
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	38 c2                	cmp    %al,%dl
  800e7b:	74 e3                	je     800e60 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	0f b6 d0             	movzbl %al,%edx
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	0f b6 c0             	movzbl %al,%eax
  800e8d:	29 c2                	sub    %eax,%edx
  800e8f:	89 d0                	mov    %edx,%eax
}
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e96:	eb 09                	jmp    800ea1 <strncmp+0xe>
		n--, p++, q++;
  800e98:	ff 4d 10             	decl   0x10(%ebp)
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	74 17                	je     800ebe <strncmp+0x2b>
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	84 c0                	test   %al,%al
  800eae:	74 0e                	je     800ebe <strncmp+0x2b>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 da                	je     800e98 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec2:	75 07                	jne    800ecb <strncmp+0x38>
		return 0;
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec9:	eb 14                	jmp    800edf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 d0             	movzbl %al,%edx
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	0f b6 c0             	movzbl %al,%eax
  800edb:	29 c2                	sub    %eax,%edx
  800edd:	89 d0                	mov    %edx,%eax
}
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eed:	eb 12                	jmp    800f01 <strchr+0x20>
		if (*s == c)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef7:	75 05                	jne    800efe <strchr+0x1d>
			return (char *) s;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	eb 11                	jmp    800f0f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800efe:	ff 45 08             	incl   0x8(%ebp)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	84 c0                	test   %al,%al
  800f08:	75 e5                	jne    800eef <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 04             	sub    $0x4,%esp
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1d:	eb 0d                	jmp    800f2c <strfind+0x1b>
		if (*s == c)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f27:	74 0e                	je     800f37 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	75 ea                	jne    800f1f <strfind+0xe>
  800f35:	eb 01                	jmp    800f38 <strfind+0x27>
		if (*s == c)
			break;
  800f37:	90                   	nop
	return (char *) s;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f49:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f4f:	eb 0e                	jmp    800f5f <memset+0x22>
		*p++ = c;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	8d 50 01             	lea    0x1(%eax),%edx
  800f57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f5f:	ff 4d f8             	decl   -0x8(%ebp)
  800f62:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f66:	79 e9                	jns    800f51 <memset+0x14>
		*p++ = c;

	return v;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f7f:	eb 16                	jmp    800f97 <memcpy+0x2a>
		*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc1:	73 50                	jae    801013 <memmove+0x6a>
  800fc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc9:	01 d0                	add    %edx,%eax
  800fcb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fce:	76 43                	jbe    801013 <memmove+0x6a>
		s += n;
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fdc:	eb 10                	jmp    800fee <memmove+0x45>
			*--d = *--s;
  800fde:	ff 4d f8             	decl   -0x8(%ebp)
  800fe1:	ff 4d fc             	decl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	8a 10                	mov    (%eax),%dl
  800fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fec:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 e3                	jne    800fde <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ffb:	eb 23                	jmp    801020 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801006:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801009:	8d 4a 01             	lea    0x1(%edx),%ecx
  80100c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80100f:	8a 12                	mov    (%edx),%dl
  801011:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	8d 50 ff             	lea    -0x1(%eax),%edx
  801019:	89 55 10             	mov    %edx,0x10(%ebp)
  80101c:	85 c0                	test   %eax,%eax
  80101e:	75 dd                	jne    800ffd <memmove+0x54>
			*d++ = *s++;

	return dst;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801037:	eb 2a                	jmp    801063 <memcmp+0x3e>
		if (*s1 != *s2)
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103c:	8a 10                	mov    (%eax),%dl
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	38 c2                	cmp    %al,%dl
  801045:	74 16                	je     80105d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	0f b6 d0             	movzbl %al,%edx
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	0f b6 c0             	movzbl %al,%eax
  801057:	29 c2                	sub    %eax,%edx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	eb 18                	jmp    801075 <memcmp+0x50>
		s1++, s2++;
  80105d:	ff 45 fc             	incl   -0x4(%ebp)
  801060:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	8d 50 ff             	lea    -0x1(%eax),%edx
  801069:	89 55 10             	mov    %edx,0x10(%ebp)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	75 c9                	jne    801039 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	01 d0                	add    %edx,%eax
  801085:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801088:	eb 15                	jmp    80109f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	0f b6 d0             	movzbl %al,%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	0f b6 c0             	movzbl %al,%eax
  801098:	39 c2                	cmp    %eax,%edx
  80109a:	74 0d                	je     8010a9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80109c:	ff 45 08             	incl   0x8(%ebp)
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a5:	72 e3                	jb     80108a <memfind+0x13>
  8010a7:	eb 01                	jmp    8010aa <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a9:	90                   	nop
	return (void *) s;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c3:	eb 03                	jmp    8010c8 <strtol+0x19>
		s++;
  8010c5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	3c 20                	cmp    $0x20,%al
  8010cf:	74 f4                	je     8010c5 <strtol+0x16>
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	3c 09                	cmp    $0x9,%al
  8010d8:	74 eb                	je     8010c5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 2b                	cmp    $0x2b,%al
  8010e1:	75 05                	jne    8010e8 <strtol+0x39>
		s++;
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	eb 13                	jmp    8010fb <strtol+0x4c>
	else if (*s == '-')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 2d                	cmp    $0x2d,%al
  8010ef:	75 0a                	jne    8010fb <strtol+0x4c>
		s++, neg = 1;
  8010f1:	ff 45 08             	incl   0x8(%ebp)
  8010f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ff:	74 06                	je     801107 <strtol+0x58>
  801101:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801105:	75 20                	jne    801127 <strtol+0x78>
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	3c 30                	cmp    $0x30,%al
  80110e:	75 17                	jne    801127 <strtol+0x78>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 78                	cmp    $0x78,%al
  801118:	75 0d                	jne    801127 <strtol+0x78>
		s += 2, base = 16;
  80111a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80111e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801125:	eb 28                	jmp    80114f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801127:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112b:	75 15                	jne    801142 <strtol+0x93>
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 30                	cmp    $0x30,%al
  801134:	75 0c                	jne    801142 <strtol+0x93>
		s++, base = 8;
  801136:	ff 45 08             	incl   0x8(%ebp)
  801139:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801140:	eb 0d                	jmp    80114f <strtol+0xa0>
	else if (base == 0)
  801142:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801146:	75 07                	jne    80114f <strtol+0xa0>
		base = 10;
  801148:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	3c 2f                	cmp    $0x2f,%al
  801156:	7e 19                	jle    801171 <strtol+0xc2>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 39                	cmp    $0x39,%al
  80115f:	7f 10                	jg     801171 <strtol+0xc2>
			dig = *s - '0';
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	0f be c0             	movsbl %al,%eax
  801169:	83 e8 30             	sub    $0x30,%eax
  80116c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116f:	eb 42                	jmp    8011b3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	3c 60                	cmp    $0x60,%al
  801178:	7e 19                	jle    801193 <strtol+0xe4>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3c 7a                	cmp    $0x7a,%al
  801181:	7f 10                	jg     801193 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	0f be c0             	movsbl %al,%eax
  80118b:	83 e8 57             	sub    $0x57,%eax
  80118e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801191:	eb 20                	jmp    8011b3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	3c 40                	cmp    $0x40,%al
  80119a:	7e 39                	jle    8011d5 <strtol+0x126>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 5a                	cmp    $0x5a,%al
  8011a3:	7f 30                	jg     8011d5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	0f be c0             	movsbl %al,%eax
  8011ad:	83 e8 37             	sub    $0x37,%eax
  8011b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b9:	7d 19                	jge    8011d4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
  8011be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011cf:	e9 7b ff ff ff       	jmp    80114f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d9:	74 08                	je     8011e3 <strtol+0x134>
		*endptr = (char *) s;
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e7:	74 07                	je     8011f0 <strtol+0x141>
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ec:	f7 d8                	neg    %eax
  8011ee:	eb 03                	jmp    8011f3 <strtol+0x144>
  8011f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801202:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120d:	79 13                	jns    801222 <ltostr+0x2d>
	{
		neg = 1;
  80120f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80121c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80122a:	99                   	cltd   
  80122b:	f7 f9                	idiv   %ecx
  80122d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801230:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801233:	8d 50 01             	lea    0x1(%eax),%edx
  801236:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801239:	89 c2                	mov    %eax,%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801243:	83 c2 30             	add    $0x30,%edx
  801246:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801248:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801250:	f7 e9                	imul   %ecx
  801252:	c1 fa 02             	sar    $0x2,%edx
  801255:	89 c8                	mov    %ecx,%eax
  801257:	c1 f8 1f             	sar    $0x1f,%eax
  80125a:	29 c2                	sub    %eax,%edx
  80125c:	89 d0                	mov    %edx,%eax
  80125e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801261:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801265:	75 bb                	jne    801222 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	48                   	dec    %eax
  801272:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801275:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801279:	74 3d                	je     8012b8 <ltostr+0xc3>
		start = 1 ;
  80127b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801282:	eb 34                	jmp    8012b8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 c2                	add    %eax,%edx
  801299:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	01 c8                	add    %ecx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	01 c2                	add    %eax,%edx
  8012ad:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012be:	7c c4                	jl     801284 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	01 d0                	add    %edx,%eax
  8012c8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cb:	90                   	nop
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 73 fa ff ff       	call   800d4f <strlen>
  8012dc:	83 c4 04             	add    $0x4,%esp
  8012df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 65 fa ff ff       	call   800d4f <strlen>
  8012ea:	83 c4 04             	add    $0x4,%esp
  8012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fe:	eb 17                	jmp    801317 <strcconcat+0x49>
		final[s] = str1[s] ;
  801300:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	01 c8                	add    %ecx,%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801314:	ff 45 fc             	incl   -0x4(%ebp)
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131d:	7c e1                	jl     801300 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801326:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132d:	eb 1f                	jmp    80134e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	01 c2                	add    %eax,%edx
  80133f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801342:	8b 45 0c             	mov    0xc(%ebp),%eax
  801345:	01 c8                	add    %ecx,%eax
  801347:	8a 00                	mov    (%eax),%al
  801349:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134b:	ff 45 f8             	incl   -0x8(%ebp)
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801354:	7c d9                	jl     80132f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801356:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801359:	8b 45 10             	mov    0x10(%ebp),%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	c6 00 00             	movb   $0x0,(%eax)
}
  801361:	90                   	nop
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801367:	8b 45 14             	mov    0x14(%ebp),%eax
  80136a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801370:	8b 45 14             	mov    0x14(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137c:	8b 45 10             	mov    0x10(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801387:	eb 0c                	jmp    801395 <strsplit+0x31>
			*string++ = 0;
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8d 50 01             	lea    0x1(%eax),%edx
  80138f:	89 55 08             	mov    %edx,0x8(%ebp)
  801392:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	84 c0                	test   %al,%al
  80139c:	74 18                	je     8013b6 <strsplit+0x52>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	0f be c0             	movsbl %al,%eax
  8013a6:	50                   	push   %eax
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	e8 32 fb ff ff       	call   800ee1 <strchr>
  8013af:	83 c4 08             	add    $0x8,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	75 d3                	jne    801389 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	84 c0                	test   %al,%al
  8013bd:	74 5a                	je     801419 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	83 f8 0f             	cmp    $0xf,%eax
  8013c7:	75 07                	jne    8013d0 <strsplit+0x6c>
		{
			return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	eb 66                	jmp    801436 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013db:	89 0a                	mov    %ecx,(%edx)
  8013dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ee:	eb 03                	jmp    8013f3 <strsplit+0x8f>
			string++;
  8013f0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	84 c0                	test   %al,%al
  8013fa:	74 8b                	je     801387 <strsplit+0x23>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	0f be c0             	movsbl %al,%eax
  801404:	50                   	push   %eax
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	e8 d4 fa ff ff       	call   800ee1 <strchr>
  80140d:	83 c4 08             	add    $0x8,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	74 dc                	je     8013f0 <strsplit+0x8c>
			string++;
	}
  801414:	e9 6e ff ff ff       	jmp    801387 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801419:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	8b 00                	mov    (%eax),%eax
  80141f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801431:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	68 68 26 80 00       	push   $0x802668
  801446:	68 3f 01 00 00       	push   $0x13f
  80144b:	68 8a 26 80 00       	push   $0x80268a
  801450:	e8 ca 07 00 00       	call   801c1f <_panic>

00801455 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	e8 ef 06 00 00       	call   801b55 <sys_sbrk>
  801466:	83 c4 10             	add    $0x10,%esp
}
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801471:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801475:	75 07                	jne    80147e <malloc+0x13>
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
  80147c:	eb 14                	jmp    801492 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	68 98 26 80 00       	push   $0x802698
  801486:	6a 1b                	push   $0x1b
  801488:	68 bd 26 80 00       	push   $0x8026bd
  80148d:	e8 8d 07 00 00       	call   801c1f <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	68 cc 26 80 00       	push   $0x8026cc
  8014a2:	6a 29                	push   $0x29
  8014a4:	68 bd 26 80 00       	push   $0x8026bd
  8014a9:	e8 71 07 00 00       	call   801c1f <_panic>

008014ae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 18             	sub    $0x18,%esp
  8014b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014be:	75 07                	jne    8014c7 <smalloc+0x19>
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	eb 14                	jmp    8014db <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	68 f0 26 80 00       	push   $0x8026f0
  8014cf:	6a 38                	push   $0x38
  8014d1:	68 bd 26 80 00       	push   $0x8026bd
  8014d6:	e8 44 07 00 00       	call   801c1f <_panic>
	return NULL;
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 18 27 80 00       	push   $0x802718
  8014eb:	6a 43                	push   $0x43
  8014ed:	68 bd 26 80 00       	push   $0x8026bd
  8014f2:	e8 28 07 00 00       	call   801c1f <_panic>

008014f7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	68 3c 27 80 00       	push   $0x80273c
  801505:	6a 5b                	push   $0x5b
  801507:	68 bd 26 80 00       	push   $0x8026bd
  80150c:	e8 0e 07 00 00       	call   801c1f <_panic>

00801511 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 60 27 80 00       	push   $0x802760
  80151f:	6a 72                	push   $0x72
  801521:	68 bd 26 80 00       	push   $0x8026bd
  801526:	e8 f4 06 00 00       	call   801c1f <_panic>

0080152b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	68 86 27 80 00       	push   $0x802786
  801539:	6a 7e                	push   $0x7e
  80153b:	68 bd 26 80 00       	push   $0x8026bd
  801540:	e8 da 06 00 00       	call   801c1f <_panic>

00801545 <shrink>:

}
void shrink(uint32 newSize)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	68 86 27 80 00       	push   $0x802786
  801553:	68 83 00 00 00       	push   $0x83
  801558:	68 bd 26 80 00       	push   $0x8026bd
  80155d:	e8 bd 06 00 00       	call   801c1f <_panic>

00801562 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	68 86 27 80 00       	push   $0x802786
  801570:	68 88 00 00 00       	push   $0x88
  801575:	68 bd 26 80 00       	push   $0x8026bd
  80157a:	e8 a0 06 00 00       	call   801c1f <_panic>

0080157f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	57                   	push   %edi
  801583:	56                   	push   %esi
  801584:	53                   	push   %ebx
  801585:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801594:	8b 7d 18             	mov    0x18(%ebp),%edi
  801597:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159a:	cd 30                	int    $0x30
  80159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	52                   	push   %edx
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	e8 b2 ff ff ff       	call   80157f <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 02                	push   $0x2
  8015e2:	e8 98 ff ff ff       	call   80157f <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 03                	push   $0x3
  8015fb:	e8 7f ff ff ff       	call   80157f <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	90                   	nop
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 04                	push   $0x4
  801615:	e8 65 ff ff ff       	call   80157f <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	6a 08                	push   $0x8
  801633:	e8 47 ff ff ff       	call   80157f <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801642:	8b 75 18             	mov    0x18(%ebp),%esi
  801645:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801648:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	51                   	push   %ecx
  801654:	52                   	push   %edx
  801655:	50                   	push   %eax
  801656:	6a 09                	push   $0x9
  801658:	e8 22 ff ff ff       	call   80157f <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801663:	5b                   	pop    %ebx
  801664:	5e                   	pop    %esi
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    

00801667 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	52                   	push   %edx
  801677:	50                   	push   %eax
  801678:	6a 0a                	push   $0xa
  80167a:	e8 00 ff ff ff       	call   80157f <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	ff 75 0c             	pushl  0xc(%ebp)
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	6a 0b                	push   $0xb
  801695:	e8 e5 fe ff ff       	call   80157f <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 0c                	push   $0xc
  8016ae:	e8 cc fe ff ff       	call   80157f <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 0d                	push   $0xd
  8016c7:	e8 b3 fe ff ff       	call   80157f <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 0e                	push   $0xe
  8016e0:	e8 9a fe ff ff       	call   80157f <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 0f                	push   $0xf
  8016f9:	e8 81 fe ff ff       	call   80157f <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	6a 10                	push   $0x10
  801713:	e8 67 fe ff ff       	call   80157f <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 11                	push   $0x11
  80172c:	e8 4e fe ff ff       	call   80157f <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	90                   	nop
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_cputc>:

void
sys_cputc(const char c)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801743:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	50                   	push   %eax
  801750:	6a 01                	push   $0x1
  801752:	e8 28 fe ff ff       	call   80157f <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	90                   	nop
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 14                	push   $0x14
  80176c:	e8 0e fe ff ff       	call   80157f <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801783:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801786:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	51                   	push   %ecx
  801790:	52                   	push   %edx
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	50                   	push   %eax
  801795:	6a 15                	push   $0x15
  801797:	e8 e3 fd ff ff       	call   80157f <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 16                	push   $0x16
  8017b4:	e8 c6 fd ff ff       	call   80157f <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	51                   	push   %ecx
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 17                	push   $0x17
  8017d3:	e8 a7 fd ff ff       	call   80157f <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 18                	push   $0x18
  8017f0:	e8 8a fd ff ff       	call   80157f <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	ff 75 14             	pushl  0x14(%ebp)
  801805:	ff 75 10             	pushl  0x10(%ebp)
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	50                   	push   %eax
  80180c:	6a 19                	push   $0x19
  80180e:	e8 6c fd ff ff       	call   80157f <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	50                   	push   %eax
  801827:	6a 1a                	push   $0x1a
  801829:	e8 51 fd ff ff       	call   80157f <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	90                   	nop
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	50                   	push   %eax
  801843:	6a 1b                	push   $0x1b
  801845:	e8 35 fd ff ff       	call   80157f <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 05                	push   $0x5
  80185e:	e8 1c fd ff ff       	call   80157f <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 06                	push   $0x6
  801877:	e8 03 fd ff ff       	call   80157f <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 07                	push   $0x7
  801890:	e8 ea fc ff ff       	call   80157f <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_exit_env>:


void sys_exit_env(void)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 1c                	push   $0x1c
  8018a9:	e8 d1 fc ff ff       	call   80157f <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018bd:	8d 50 04             	lea    0x4(%eax),%edx
  8018c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 1d                	push   $0x1d
  8018cd:	e8 ad fc ff ff       	call   80157f <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return result;
  8018d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018de:	89 01                	mov    %eax,(%ecx)
  8018e0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	c9                   	leave  
  8018e7:	c2 04 00             	ret    $0x4

008018ea <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 10             	pushl  0x10(%ebp)
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 13                	push   $0x13
  8018fc:	e8 7e fc ff ff       	call   80157f <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
	return ;
  801904:	90                   	nop
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_rcr2>:
uint32 sys_rcr2()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 1e                	push   $0x1e
  801916:	e8 64 fc ff ff       	call   80157f <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80192c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	50                   	push   %eax
  801939:	6a 1f                	push   $0x1f
  80193b:	e8 3f fc ff ff       	call   80157f <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return ;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <rsttst>:
void rsttst()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 21                	push   $0x21
  801955:	e8 25 fc ff ff       	call   80157f <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	8b 45 14             	mov    0x14(%ebp),%eax
  801969:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80196c:	8b 55 18             	mov    0x18(%ebp),%edx
  80196f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801973:	52                   	push   %edx
  801974:	50                   	push   %eax
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 20                	push   $0x20
  801980:	e8 fa fb ff ff       	call   80157f <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <chktst>:
void chktst(uint32 n)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 22                	push   $0x22
  80199b:	e8 df fb ff ff       	call   80157f <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <inctst>:

void inctst()
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 23                	push   $0x23
  8019b5:	e8 c5 fb ff ff       	call   80157f <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <gettst>:
uint32 gettst()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 24                	push   $0x24
  8019cf:	e8 ab fb ff ff       	call   80157f <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 25                	push   $0x25
  8019eb:	e8 8f fb ff ff       	call   80157f <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
  8019f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019f6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019fa:	75 07                	jne    801a03 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801a01:	eb 05                	jmp    801a08 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 25                	push   $0x25
  801a1c:	e8 5e fb ff ff       	call   80157f <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
  801a24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a27:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a2b:	75 07                	jne    801a34 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a32:	eb 05                	jmp    801a39 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 25                	push   $0x25
  801a4d:	e8 2d fb ff ff       	call   80157f <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
  801a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a58:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a5c:	75 07                	jne    801a65 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a63:	eb 05                	jmp    801a6a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 25                	push   $0x25
  801a7e:	e8 fc fa ff ff       	call   80157f <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
  801a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a89:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a8d:	75 07                	jne    801a96 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a94:	eb 05                	jmp    801a9b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	6a 26                	push   $0x26
  801aad:	e8 cd fa ff ff       	call   80157f <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab5:	90                   	nop
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801abc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	53                   	push   %ebx
  801acb:	51                   	push   %ecx
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 27                	push   $0x27
  801ad0:	e8 aa fa ff ff       	call   80157f <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 28                	push   $0x28
  801af0:	e8 8a fa ff ff       	call   80157f <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801afd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	51                   	push   %ecx
  801b09:	ff 75 10             	pushl  0x10(%ebp)
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	6a 29                	push   $0x29
  801b10:	e8 6a fa ff ff       	call   80157f <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	ff 75 10             	pushl  0x10(%ebp)
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 12                	push   $0x12
  801b2c:	e8 4e fa ff ff       	call   80157f <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 2a                	push   $0x2a
  801b4a:	e8 30 fa ff ff       	call   80157f <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return;
  801b52:	90                   	nop
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	68 96 27 80 00       	push   $0x802796
  801b63:	68 2e 01 00 00       	push   $0x12e
  801b68:	68 aa 27 80 00       	push   $0x8027aa
  801b6d:	e8 ad 00 00 00       	call   801c1f <_panic>

00801b72 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	68 96 27 80 00       	push   $0x802796
  801b80:	68 35 01 00 00       	push   $0x135
  801b85:	68 aa 27 80 00       	push   $0x8027aa
  801b8a:	e8 90 00 00 00       	call   801c1f <_panic>

00801b8f <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 96 27 80 00       	push   $0x802796
  801b9d:	68 3b 01 00 00       	push   $0x13b
  801ba2:	68 aa 27 80 00       	push   $0x8027aa
  801ba7:	e8 73 00 00 00       	call   801c1f <_panic>

00801bac <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 b8 27 80 00       	push   $0x8027b8
  801bba:	6a 09                	push   $0x9
  801bbc:	68 e0 27 80 00       	push   $0x8027e0
  801bc1:	e8 59 00 00 00       	call   801c1f <_panic>

00801bc6 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	68 f0 27 80 00       	push   $0x8027f0
  801bd4:	6a 10                	push   $0x10
  801bd6:	68 e0 27 80 00       	push   $0x8027e0
  801bdb:	e8 3f 00 00 00       	call   801c1f <_panic>

00801be0 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 18 28 80 00       	push   $0x802818
  801bee:	6a 18                	push   $0x18
  801bf0:	68 e0 27 80 00       	push   $0x8027e0
  801bf5:	e8 25 00 00 00       	call   801c1f <_panic>

00801bfa <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 40 28 80 00       	push   $0x802840
  801c08:	6a 20                	push   $0x20
  801c0a:	68 e0 27 80 00       	push   $0x8027e0
  801c0f:	e8 0b 00 00 00       	call   801c1f <_panic>

00801c14 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8b 40 10             	mov    0x10(%eax),%eax
}
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    

00801c1f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c25:	8d 45 10             	lea    0x10(%ebp),%eax
  801c28:	83 c0 04             	add    $0x4,%eax
  801c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c2e:	a1 24 30 80 00       	mov    0x803024,%eax
  801c33:	85 c0                	test   %eax,%eax
  801c35:	74 16                	je     801c4d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c37:	a1 24 30 80 00       	mov    0x803024,%eax
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	50                   	push   %eax
  801c40:	68 68 28 80 00       	push   $0x802868
  801c45:	e8 71 ea ff ff       	call   8006bb <cprintf>
  801c4a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801c4d:	a1 00 30 80 00       	mov    0x803000,%eax
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	ff 75 08             	pushl  0x8(%ebp)
  801c58:	50                   	push   %eax
  801c59:	68 6d 28 80 00       	push   $0x80286d
  801c5e:	e8 58 ea ff ff       	call   8006bb <cprintf>
  801c63:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801c66:	8b 45 10             	mov    0x10(%ebp),%eax
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6f:	50                   	push   %eax
  801c70:	e8 db e9 ff ff       	call   800650 <vcprintf>
  801c75:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	6a 00                	push   $0x0
  801c7d:	68 89 28 80 00       	push   $0x802889
  801c82:	e8 c9 e9 ff ff       	call   800650 <vcprintf>
  801c87:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801c8a:	e8 4a e9 ff ff       	call   8005d9 <exit>

	// should not return here
	while (1) ;
  801c8f:	eb fe                	jmp    801c8f <_panic+0x70>

00801c91 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801c97:	a1 04 30 80 00       	mov    0x803004,%eax
  801c9c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	39 c2                	cmp    %eax,%edx
  801ca7:	74 14                	je     801cbd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	68 8c 28 80 00       	push   $0x80288c
  801cb1:	6a 26                	push   $0x26
  801cb3:	68 d8 28 80 00       	push   $0x8028d8
  801cb8:	e8 62 ff ff ff       	call   801c1f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801cc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801ccb:	e9 c5 00 00 00       	jmp    801d95 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	01 d0                	add    %edx,%eax
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	75 08                	jne    801ced <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ce5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ce8:	e9 a5 00 00 00       	jmp    801d92 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801ced:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cf4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801cfb:	eb 69                	jmp    801d66 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801cfd:	a1 04 30 80 00       	mov    0x803004,%eax
  801d02:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801d08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	01 c0                	add    %eax,%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	c1 e0 03             	shl    $0x3,%eax
  801d14:	01 c8                	add    %ecx,%eax
  801d16:	8a 40 04             	mov    0x4(%eax),%al
  801d19:	84 c0                	test   %al,%al
  801d1b:	75 46                	jne    801d63 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d1d:	a1 04 30 80 00       	mov    0x803004,%eax
  801d22:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801d28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d2b:	89 d0                	mov    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	c1 e0 03             	shl    $0x3,%eax
  801d34:	01 c8                	add    %ecx,%eax
  801d36:	8b 00                	mov    (%eax),%eax
  801d38:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d43:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d48:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	01 c8                	add    %ecx,%eax
  801d54:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d56:	39 c2                	cmp    %eax,%edx
  801d58:	75 09                	jne    801d63 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801d5a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d61:	eb 15                	jmp    801d78 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d63:	ff 45 e8             	incl   -0x18(%ebp)
  801d66:	a1 04 30 80 00       	mov    0x803004,%eax
  801d6b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d74:	39 c2                	cmp    %eax,%edx
  801d76:	77 85                	ja     801cfd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d7c:	75 14                	jne    801d92 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	68 e4 28 80 00       	push   $0x8028e4
  801d86:	6a 3a                	push   $0x3a
  801d88:	68 d8 28 80 00       	push   $0x8028d8
  801d8d:	e8 8d fe ff ff       	call   801c1f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801d92:	ff 45 f0             	incl   -0x10(%ebp)
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d9b:	0f 8c 2f ff ff ff    	jl     801cd0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801da1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801da8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801daf:	eb 26                	jmp    801dd7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801db1:	a1 04 30 80 00       	mov    0x803004,%eax
  801db6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801dbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbf:	89 d0                	mov    %edx,%eax
  801dc1:	01 c0                	add    %eax,%eax
  801dc3:	01 d0                	add    %edx,%eax
  801dc5:	c1 e0 03             	shl    $0x3,%eax
  801dc8:	01 c8                	add    %ecx,%eax
  801dca:	8a 40 04             	mov    0x4(%eax),%al
  801dcd:	3c 01                	cmp    $0x1,%al
  801dcf:	75 03                	jne    801dd4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801dd1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dd4:	ff 45 e0             	incl   -0x20(%ebp)
  801dd7:	a1 04 30 80 00       	mov    0x803004,%eax
  801ddc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de5:	39 c2                	cmp    %eax,%edx
  801de7:	77 c8                	ja     801db1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801def:	74 14                	je     801e05 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 38 29 80 00       	push   $0x802938
  801df9:	6a 44                	push   $0x44
  801dfb:	68 d8 28 80 00       	push   $0x8028d8
  801e00:	e8 1a fe ff ff       	call   801c1f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <__udivdi3>:
  801e08:	55                   	push   %ebp
  801e09:	57                   	push   %edi
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	83 ec 1c             	sub    $0x1c,%esp
  801e0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1f:	89 ca                	mov    %ecx,%edx
  801e21:	89 f8                	mov    %edi,%eax
  801e23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e27:	85 f6                	test   %esi,%esi
  801e29:	75 2d                	jne    801e58 <__udivdi3+0x50>
  801e2b:	39 cf                	cmp    %ecx,%edi
  801e2d:	77 65                	ja     801e94 <__udivdi3+0x8c>
  801e2f:	89 fd                	mov    %edi,%ebp
  801e31:	85 ff                	test   %edi,%edi
  801e33:	75 0b                	jne    801e40 <__udivdi3+0x38>
  801e35:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3a:	31 d2                	xor    %edx,%edx
  801e3c:	f7 f7                	div    %edi
  801e3e:	89 c5                	mov    %eax,%ebp
  801e40:	31 d2                	xor    %edx,%edx
  801e42:	89 c8                	mov    %ecx,%eax
  801e44:	f7 f5                	div    %ebp
  801e46:	89 c1                	mov    %eax,%ecx
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	f7 f5                	div    %ebp
  801e4c:	89 cf                	mov    %ecx,%edi
  801e4e:	89 fa                	mov    %edi,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	39 ce                	cmp    %ecx,%esi
  801e5a:	77 28                	ja     801e84 <__udivdi3+0x7c>
  801e5c:	0f bd fe             	bsr    %esi,%edi
  801e5f:	83 f7 1f             	xor    $0x1f,%edi
  801e62:	75 40                	jne    801ea4 <__udivdi3+0x9c>
  801e64:	39 ce                	cmp    %ecx,%esi
  801e66:	72 0a                	jb     801e72 <__udivdi3+0x6a>
  801e68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e6c:	0f 87 9e 00 00 00    	ja     801f10 <__udivdi3+0x108>
  801e72:	b8 01 00 00 00       	mov    $0x1,%eax
  801e77:	89 fa                	mov    %edi,%edx
  801e79:	83 c4 1c             	add    $0x1c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
  801e81:	8d 76 00             	lea    0x0(%esi),%esi
  801e84:	31 ff                	xor    %edi,%edi
  801e86:	31 c0                	xor    %eax,%eax
  801e88:	89 fa                	mov    %edi,%edx
  801e8a:	83 c4 1c             	add    $0x1c,%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5e                   	pop    %esi
  801e8f:	5f                   	pop    %edi
  801e90:	5d                   	pop    %ebp
  801e91:	c3                   	ret    
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	89 d8                	mov    %ebx,%eax
  801e96:	f7 f7                	div    %edi
  801e98:	31 ff                	xor    %edi,%edi
  801e9a:	89 fa                	mov    %edi,%edx
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
  801ea4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ea9:	89 eb                	mov    %ebp,%ebx
  801eab:	29 fb                	sub    %edi,%ebx
  801ead:	89 f9                	mov    %edi,%ecx
  801eaf:	d3 e6                	shl    %cl,%esi
  801eb1:	89 c5                	mov    %eax,%ebp
  801eb3:	88 d9                	mov    %bl,%cl
  801eb5:	d3 ed                	shr    %cl,%ebp
  801eb7:	89 e9                	mov    %ebp,%ecx
  801eb9:	09 f1                	or     %esi,%ecx
  801ebb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ebf:	89 f9                	mov    %edi,%ecx
  801ec1:	d3 e0                	shl    %cl,%eax
  801ec3:	89 c5                	mov    %eax,%ebp
  801ec5:	89 d6                	mov    %edx,%esi
  801ec7:	88 d9                	mov    %bl,%cl
  801ec9:	d3 ee                	shr    %cl,%esi
  801ecb:	89 f9                	mov    %edi,%ecx
  801ecd:	d3 e2                	shl    %cl,%edx
  801ecf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed3:	88 d9                	mov    %bl,%cl
  801ed5:	d3 e8                	shr    %cl,%eax
  801ed7:	09 c2                	or     %eax,%edx
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	89 f2                	mov    %esi,%edx
  801edd:	f7 74 24 0c          	divl   0xc(%esp)
  801ee1:	89 d6                	mov    %edx,%esi
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	f7 e5                	mul    %ebp
  801ee7:	39 d6                	cmp    %edx,%esi
  801ee9:	72 19                	jb     801f04 <__udivdi3+0xfc>
  801eeb:	74 0b                	je     801ef8 <__udivdi3+0xf0>
  801eed:	89 d8                	mov    %ebx,%eax
  801eef:	31 ff                	xor    %edi,%edi
  801ef1:	e9 58 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801efc:	89 f9                	mov    %edi,%ecx
  801efe:	d3 e2                	shl    %cl,%edx
  801f00:	39 c2                	cmp    %eax,%edx
  801f02:	73 e9                	jae    801eed <__udivdi3+0xe5>
  801f04:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f07:	31 ff                	xor    %edi,%edi
  801f09:	e9 40 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801f0e:	66 90                	xchg   %ax,%ax
  801f10:	31 c0                	xor    %eax,%eax
  801f12:	e9 37 ff ff ff       	jmp    801e4e <__udivdi3+0x46>
  801f17:	90                   	nop

00801f18 <__umoddi3>:
  801f18:	55                   	push   %ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 1c             	sub    $0x1c,%esp
  801f1f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f23:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f27:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f37:	89 f3                	mov    %esi,%ebx
  801f39:	89 fa                	mov    %edi,%edx
  801f3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f3f:	89 34 24             	mov    %esi,(%esp)
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 1a                	jne    801f60 <__umoddi3+0x48>
  801f46:	39 f7                	cmp    %esi,%edi
  801f48:	0f 86 a2 00 00 00    	jbe    801ff0 <__umoddi3+0xd8>
  801f4e:	89 c8                	mov    %ecx,%eax
  801f50:	89 f2                	mov    %esi,%edx
  801f52:	f7 f7                	div    %edi
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	31 d2                	xor    %edx,%edx
  801f58:	83 c4 1c             	add    $0x1c,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5f                   	pop    %edi
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    
  801f60:	39 f0                	cmp    %esi,%eax
  801f62:	0f 87 ac 00 00 00    	ja     802014 <__umoddi3+0xfc>
  801f68:	0f bd e8             	bsr    %eax,%ebp
  801f6b:	83 f5 1f             	xor    $0x1f,%ebp
  801f6e:	0f 84 ac 00 00 00    	je     802020 <__umoddi3+0x108>
  801f74:	bf 20 00 00 00       	mov    $0x20,%edi
  801f79:	29 ef                	sub    %ebp,%edi
  801f7b:	89 fe                	mov    %edi,%esi
  801f7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f81:	89 e9                	mov    %ebp,%ecx
  801f83:	d3 e0                	shl    %cl,%eax
  801f85:	89 d7                	mov    %edx,%edi
  801f87:	89 f1                	mov    %esi,%ecx
  801f89:	d3 ef                	shr    %cl,%edi
  801f8b:	09 c7                	or     %eax,%edi
  801f8d:	89 e9                	mov    %ebp,%ecx
  801f8f:	d3 e2                	shl    %cl,%edx
  801f91:	89 14 24             	mov    %edx,(%esp)
  801f94:	89 d8                	mov    %ebx,%eax
  801f96:	d3 e0                	shl    %cl,%eax
  801f98:	89 c2                	mov    %eax,%edx
  801f9a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f9e:	d3 e0                	shl    %cl,%eax
  801fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fa8:	89 f1                	mov    %esi,%ecx
  801faa:	d3 e8                	shr    %cl,%eax
  801fac:	09 d0                	or     %edx,%eax
  801fae:	d3 eb                	shr    %cl,%ebx
  801fb0:	89 da                	mov    %ebx,%edx
  801fb2:	f7 f7                	div    %edi
  801fb4:	89 d3                	mov    %edx,%ebx
  801fb6:	f7 24 24             	mull   (%esp)
  801fb9:	89 c6                	mov    %eax,%esi
  801fbb:	89 d1                	mov    %edx,%ecx
  801fbd:	39 d3                	cmp    %edx,%ebx
  801fbf:	0f 82 87 00 00 00    	jb     80204c <__umoddi3+0x134>
  801fc5:	0f 84 91 00 00 00    	je     80205c <__umoddi3+0x144>
  801fcb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fcf:	29 f2                	sub    %esi,%edx
  801fd1:	19 cb                	sbb    %ecx,%ebx
  801fd3:	89 d8                	mov    %ebx,%eax
  801fd5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fd9:	d3 e0                	shl    %cl,%eax
  801fdb:	89 e9                	mov    %ebp,%ecx
  801fdd:	d3 ea                	shr    %cl,%edx
  801fdf:	09 d0                	or     %edx,%eax
  801fe1:	89 e9                	mov    %ebp,%ecx
  801fe3:	d3 eb                	shr    %cl,%ebx
  801fe5:	89 da                	mov    %ebx,%edx
  801fe7:	83 c4 1c             	add    $0x1c,%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5f                   	pop    %edi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    
  801fef:	90                   	nop
  801ff0:	89 fd                	mov    %edi,%ebp
  801ff2:	85 ff                	test   %edi,%edi
  801ff4:	75 0b                	jne    802001 <__umoddi3+0xe9>
  801ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	f7 f7                	div    %edi
  801fff:	89 c5                	mov    %eax,%ebp
  802001:	89 f0                	mov    %esi,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	f7 f5                	div    %ebp
  802007:	89 c8                	mov    %ecx,%eax
  802009:	f7 f5                	div    %ebp
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	e9 44 ff ff ff       	jmp    801f56 <__umoddi3+0x3e>
  802012:	66 90                	xchg   %ax,%ax
  802014:	89 c8                	mov    %ecx,%eax
  802016:	89 f2                	mov    %esi,%edx
  802018:	83 c4 1c             	add    $0x1c,%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5f                   	pop    %edi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    
  802020:	3b 04 24             	cmp    (%esp),%eax
  802023:	72 06                	jb     80202b <__umoddi3+0x113>
  802025:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802029:	77 0f                	ja     80203a <__umoddi3+0x122>
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	29 f9                	sub    %edi,%ecx
  80202f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802033:	89 14 24             	mov    %edx,(%esp)
  802036:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80203a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80203e:	8b 14 24             	mov    (%esp),%edx
  802041:	83 c4 1c             	add    $0x1c,%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    
  802049:	8d 76 00             	lea    0x0(%esi),%esi
  80204c:	2b 04 24             	sub    (%esp),%eax
  80204f:	19 fa                	sbb    %edi,%edx
  802051:	89 d1                	mov    %edx,%ecx
  802053:	89 c6                	mov    %eax,%esi
  802055:	e9 71 ff ff ff       	jmp    801fcb <__umoddi3+0xb3>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802060:	72 ea                	jb     80204c <__umoddi3+0x134>
  802062:	89 d9                	mov    %ebx,%ecx
  802064:	e9 62 ff ff ff       	jmp    801fcb <__umoddi3+0xb3>

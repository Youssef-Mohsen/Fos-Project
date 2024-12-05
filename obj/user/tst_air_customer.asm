
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
  800044:	e8 33 1c 00 00       	call   801c7c <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 29 3f 80 00       	mov    $0x803f29,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 33 3f 80 00       	mov    $0x803f33,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 3f 3f 80 00       	mov    $0x803f3f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 4e 3f 80 00       	mov    $0x803f4e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 5d 3f 80 00       	mov    $0x803f5d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 72 3f 80 00       	mov    $0x803f72,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 87 3f 80 00       	mov    $0x803f87,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 98 3f 80 00       	mov    $0x803f98,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb a9 3f 80 00       	mov    $0x803fa9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb ba 3f 80 00       	mov    $0x803fba,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb c3 3f 80 00       	mov    $0x803fc3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb cd 3f 80 00       	mov    $0x803fcd,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb d8 3f 80 00       	mov    $0x803fd8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb e4 3f 80 00       	mov    $0x803fe4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ee 3f 80 00       	mov    $0x803fee,%ebx
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
  8001be:	bb f8 3f 80 00       	mov    $0x803ff8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 06 40 80 00       	mov    $0x804006,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 15 40 80 00       	mov    $0x804015,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 1c 40 80 00       	mov    $0x80401c,%ebx
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
  800222:	e8 f9 15 00 00       	call   801820 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 e4 15 00 00       	call   801820 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 cc 15 00 00       	call   801820 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 b4 15 00 00       	call   801820 <sget>
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
  800286:	e8 98 37 00 00       	call   803a23 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 7c 37 00 00       	call   803a23 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 60 37 00 00       	call   803a23 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 44 37 00 00       	call   803a23 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 28 37 00 00       	call   803a23 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 31 37 00 00       	call   803a3d <wait_semaphore>
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
  80032d:	e8 25 37 00 00       	call   803a57 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 fa 36 00 00       	call   803a3d <wait_semaphore>
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
  800363:	e8 d5 36 00 00       	call   803a3d <wait_semaphore>
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
  800397:	e8 bb 36 00 00       	call   803a57 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 aa 36 00 00       	call   803a57 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 23 40 80 00       	mov    $0x804023,%ebx
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
  800425:	e8 f9 35 00 00       	call   803a23 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 02 36 00 00       	call   803a3d <wait_semaphore>
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
  80045e:	68 e0 3e 80 00       	push   $0x803ee0
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 08 3f 80 00       	push   $0x803f08
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 c9 35 00 00       	call   803a57 <signal_semaphore>
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
  8004a0:	e8 be 17 00 00       	call   801c63 <sys_getenvindex>
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
  80050e:	e8 d4 14 00 00       	call   8019e7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 5c 40 80 00       	push   $0x80405c
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
  80053e:	68 84 40 80 00       	push   $0x804084
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
  80056f:	68 ac 40 80 00       	push   $0x8040ac
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 04 41 80 00       	push   $0x804104
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 5c 40 80 00       	push   $0x80405c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 54 14 00 00       	call   801a01 <sys_unlock_cons>
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
  8005c0:	e8 6a 16 00 00       	call   801c2f <sys_destroy_env>
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
  8005d1:	e8 bf 16 00 00       	call   801c95 <sys_exit_env>
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
  80061f:	e8 81 13 00 00       	call   8019a5 <sys_cputs>
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
  800696:	e8 0a 13 00 00       	call   8019a5 <sys_cputs>
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
  8006e0:	e8 02 13 00 00       	call   8019e7 <sys_lock_cons>
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
  800700:	e8 fc 12 00 00       	call   801a01 <sys_unlock_cons>
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
  80074a:	e8 19 35 00 00       	call   803c68 <__udivdi3>
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
  80079a:	e8 d9 35 00 00       	call   803d78 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 34 43 80 00       	add    $0x804334,%eax
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
  8008f5:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
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
  8009d6:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 45 43 80 00       	push   $0x804345
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
  8009fb:	68 4e 43 80 00       	push   $0x80434e
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
  800a28:	be 51 43 80 00       	mov    $0x804351,%esi
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
  801433:	68 c8 44 80 00       	push   $0x8044c8
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 ea 44 80 00       	push   $0x8044ea
  801442:	e8 35 26 00 00       	call   803a7c <_panic>

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
  801453:	e8 f8 0a 00 00       	call   801f50 <sys_sbrk>
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
  8014ce:	e8 01 09 00 00       	call   801dd4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 41 0e 00 00       	call   802323 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 13 09 00 00       	call   801e05 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 da 12 00 00       	call   8027df <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801539:	a1 20 50 80 00       	mov    0x805020,%eax
  80153e:	8b 40 78             	mov    0x78(%eax),%eax
  801541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801544:	29 c2                	sub    %eax,%edx
  801546:	89 d0                	mov    %edx,%eax
  801548:	2d 00 10 00 00       	sub    $0x1000,%eax
  80154d:	c1 e8 0c             	shr    $0xc,%eax
  801550:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801557:	85 c0                	test   %eax,%eax
  801559:	0f 85 ab 00 00 00    	jne    80160a <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	05 00 10 00 00       	add    $0x1000,%eax
  801567:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80156a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  80159d:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	74 08                	je     8015b0 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  8015f4:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  80160a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160e:	75 16                	jne    801626 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801610:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801617:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80161e:	0f 86 15 ff ff ff    	jbe    801539 <malloc+0xdc>
  801624:	eb 01                	jmp    801627 <malloc+0x1ca>
				}
				

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
  801656:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	ff 75 f0             	pushl  -0x10(%ebp)
  801666:	e8 1c 09 00 00       	call   801f87 <sys_allocate_user_mem>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	eb 07                	jmp    801677 <malloc+0x21a>
		
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
  8016ae:	e8 f0 08 00 00       	call   801fa3 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 00 1b 00 00       	call   8031c4 <free_block>
  8016c4:	83 c4 10             	add    $0x10,%esp
		}

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
  8016f9:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801700:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801706:	c1 e0 0c             	shl    $0xc,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80170c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801713:	eb 42                	jmp    801757 <free+0xdb>
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
  801736:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  80173d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	e8 1a 08 00 00       	call   801f6b <sys_free_user_mem>
  801751:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801754:	ff 45 f4             	incl   -0xc(%ebp)
  801757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80175d:	72 b6                	jb     801715 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80175f:	eb 17                	jmp    801778 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 f8 44 80 00       	push   $0x8044f8
  801769:	68 87 00 00 00       	push   $0x87
  80176e:	68 22 45 80 00       	push   $0x804522
  801773:	e8 04 23 00 00       	call   803a7c <_panic>
	}
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 28             	sub    $0x28,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 0a                	jne    801797 <smalloc+0x1c>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	e9 87 00 00 00       	jmp    80181e <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	39 d0                	cmp    %edx,%eax
  8017ac:	73 02                	jae    8017b0 <smalloc+0x35>
  8017ae:	89 d0                	mov    %edx,%eax
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	50                   	push   %eax
  8017b4:	e8 a4 fc ff ff       	call   80145d <malloc>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c3:	75 07                	jne    8017cc <smalloc+0x51>
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 52                	jmp    80181e <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017cc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	e8 93 03 00 00       	call   801b72 <sys_createSharedObject>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e9:	74 06                	je     8017f1 <smalloc+0x76>
  8017eb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ef:	75 07                	jne    8017f8 <smalloc+0x7d>
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	eb 26                	jmp    80181e <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8017f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fb:	a1 20 50 80 00       	mov    0x805020,%eax
  801800:	8b 40 78             	mov    0x78(%eax),%eax
  801803:	29 c2                	sub    %eax,%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	2d 00 10 00 00       	sub    $0x1000,%eax
  80180c:	c1 e8 0c             	shr    $0xc,%eax
  80180f:	89 c2                	mov    %eax,%edx
  801811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801814:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80181b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 68 03 00 00       	call   801b9c <sys_getSizeOfSharedObject>
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80183a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80183e:	75 07                	jne    801847 <sget+0x27>
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 7f                	jmp    8018c6 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80184d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801854:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185a:	39 d0                	cmp    %edx,%eax
  80185c:	73 02                	jae    801860 <sget+0x40>
  80185e:	89 d0                	mov    %edx,%eax
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	50                   	push   %eax
  801864:	e8 f4 fb ff ff       	call   80145d <malloc>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80186f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801873:	75 07                	jne    80187c <sget+0x5c>
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 4a                	jmp    8018c6 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	ff 75 e8             	pushl  -0x18(%ebp)
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	ff 75 08             	pushl  0x8(%ebp)
  801888:	e8 2c 03 00 00       	call   801bb9 <sys_getSharedObject>
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801893:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801896:	a1 20 50 80 00       	mov    0x805020,%eax
  80189b:	8b 40 78             	mov    0x78(%eax),%eax
  80189e:	29 c2                	sub    %eax,%edx
  8018a0:	89 d0                	mov    %edx,%eax
  8018a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018a7:	c1 e8 0c             	shr    $0xc,%eax
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018af:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018b6:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018ba:	75 07                	jne    8018c3 <sget+0xa3>
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c1:	eb 03                	jmp    8018c6 <sget+0xa6>
	return ptr;
  8018c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d6:	8b 40 78             	mov    0x78(%eax),%eax
  8018d9:	29 c2                	sub    %eax,%edx
  8018db:	89 d0                	mov    %edx,%eax
  8018dd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018e2:	c1 e8 0c             	shr    $0xc,%eax
  8018e5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018ef:	83 ec 08             	sub    $0x8,%esp
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f8:	e8 db 02 00 00       	call   801bd8 <sys_freeSharedObject>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	68 30 45 80 00       	push   $0x804530
  801914:	68 e4 00 00 00       	push   $0xe4
  801919:	68 22 45 80 00       	push   $0x804522
  80191e:	e8 59 21 00 00       	call   803a7c <_panic>

00801923 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 56 45 80 00       	push   $0x804556
  801931:	68 f0 00 00 00       	push   $0xf0
  801936:	68 22 45 80 00       	push   $0x804522
  80193b:	e8 3c 21 00 00       	call   803a7c <_panic>

00801940 <shrink>:

}
void shrink(uint32 newSize)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	68 56 45 80 00       	push   $0x804556
  80194e:	68 f5 00 00 00       	push   $0xf5
  801953:	68 22 45 80 00       	push   $0x804522
  801958:	e8 1f 21 00 00       	call   803a7c <_panic>

0080195d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	68 56 45 80 00       	push   $0x804556
  80196b:	68 fa 00 00 00       	push   $0xfa
  801970:	68 22 45 80 00       	push   $0x804522
  801975:	e8 02 21 00 00       	call   803a7c <_panic>

0080197a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	57                   	push   %edi
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
  801980:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801992:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801995:	cd 30                	int    $0x30
  801997:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5f                   	pop    %edi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	52                   	push   %edx
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	e8 b2 ff ff ff       	call   80197a <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 02                	push   $0x2
  8019dd:	e8 98 ff ff ff       	call   80197a <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 03                	push   $0x3
  8019f6:	e8 7f ff ff ff       	call   80197a <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 04                	push   $0x4
  801a10:	e8 65 ff ff ff       	call   80197a <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	90                   	nop
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 08                	push   $0x8
  801a2e:	e8 47 ff ff ff       	call   80197a <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a3d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	51                   	push   %ecx
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 09                	push   $0x9
  801a53:	e8 22 ff ff ff       	call   80197a <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    

00801a62 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 0a                	push   $0xa
  801a75:	e8 00 ff ff ff       	call   80197a <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 0c             	pushl  0xc(%ebp)
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	6a 0b                	push   $0xb
  801a90:	e8 e5 fe ff ff       	call   80197a <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 0c                	push   $0xc
  801aa9:	e8 cc fe ff ff       	call   80197a <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 0d                	push   $0xd
  801ac2:	e8 b3 fe ff ff       	call   80197a <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 0e                	push   $0xe
  801adb:	e8 9a fe ff ff       	call   80197a <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 0f                	push   $0xf
  801af4:	e8 81 fe ff ff       	call   80197a <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	6a 10                	push   $0x10
  801b0e:	e8 67 fe ff ff       	call   80197a <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 11                	push   $0x11
  801b27:	e8 4e fe ff ff       	call   80197a <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	90                   	nop
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	50                   	push   %eax
  801b4b:	6a 01                	push   $0x1
  801b4d:	e8 28 fe ff ff       	call   80197a <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	90                   	nop
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 14                	push   $0x14
  801b67:	e8 0e fe ff ff       	call   80197a <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b81:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	51                   	push   %ecx
  801b8b:	52                   	push   %edx
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	50                   	push   %eax
  801b90:	6a 15                	push   $0x15
  801b92:	e8 e3 fd ff ff       	call   80197a <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 16                	push   $0x16
  801baf:	e8 c6 fd ff ff       	call   80197a <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	51                   	push   %ecx
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 17                	push   $0x17
  801bce:	e8 a7 fd ff ff       	call   80197a <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	6a 18                	push   $0x18
  801beb:	e8 8a fd ff ff       	call   80197a <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	ff 75 14             	pushl  0x14(%ebp)
  801c00:	ff 75 10             	pushl  0x10(%ebp)
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	50                   	push   %eax
  801c07:	6a 19                	push   $0x19
  801c09:	e8 6c fd ff ff       	call   80197a <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	50                   	push   %eax
  801c22:	6a 1a                	push   $0x1a
  801c24:	e8 51 fd ff ff       	call   80197a <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	90                   	nop
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 1b                	push   $0x1b
  801c40:	e8 35 fd ff ff       	call   80197a <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 05                	push   $0x5
  801c59:	e8 1c fd ff ff       	call   80197a <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 06                	push   $0x6
  801c72:	e8 03 fd ff ff       	call   80197a <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 07                	push   $0x7
  801c8b:	e8 ea fc ff ff       	call   80197a <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_exit_env>:


void sys_exit_env(void)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 1c                	push   $0x1c
  801ca4:	e8 d1 fc ff ff       	call   80197a <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb8:	8d 50 04             	lea    0x4(%eax),%edx
  801cbb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	6a 1d                	push   $0x1d
  801cc8:	e8 ad fc ff ff       	call   80197a <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return result;
  801cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd9:	89 01                	mov    %eax,(%ecx)
  801cdb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	c9                   	leave  
  801ce2:	c2 04 00             	ret    $0x4

00801ce5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	6a 13                	push   $0x13
  801cf7:	e8 7e fc ff ff       	call   80197a <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 1e                	push   $0x1e
  801d11:	e8 64 fc ff ff       	call   80197a <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d27:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	50                   	push   %eax
  801d34:	6a 1f                	push   $0x1f
  801d36:	e8 3f fc ff ff       	call   80197a <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3e:	90                   	nop
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <rsttst>:
void rsttst()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 21                	push   $0x21
  801d50:	e8 25 fc ff ff       	call   80197a <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	8b 45 14             	mov    0x14(%ebp),%eax
  801d64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d67:	8b 55 18             	mov    0x18(%ebp),%edx
  801d6a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6e:	52                   	push   %edx
  801d6f:	50                   	push   %eax
  801d70:	ff 75 10             	pushl  0x10(%ebp)
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 20                	push   $0x20
  801d7b:	e8 fa fb ff ff       	call   80197a <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <chktst>:
void chktst(uint32 n)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 22                	push   $0x22
  801d96:	e8 df fb ff ff       	call   80197a <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <inctst>:

void inctst()
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 23                	push   $0x23
  801db0:	e8 c5 fb ff ff       	call   80197a <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <gettst>:
uint32 gettst()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 24                	push   $0x24
  801dca:	e8 ab fb ff ff       	call   80197a <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 25                	push   $0x25
  801de6:	e8 8f fb ff ff       	call   80197a <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801df1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df5:	75 07                	jne    801dfe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfc:	eb 05                	jmp    801e03 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 25                	push   $0x25
  801e17:	e8 5e fb ff ff       	call   80197a <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
  801e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e22:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e26:	75 07                	jne    801e2f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb 05                	jmp    801e34 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 25                	push   $0x25
  801e48:	e8 2d fb ff ff       	call   80197a <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
  801e50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e53:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e57:	75 07                	jne    801e60 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5e:	eb 05                	jmp    801e65 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 25                	push   $0x25
  801e79:	e8 fc fa ff ff       	call   80197a <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
  801e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e84:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e88:	75 07                	jne    801e91 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8f:	eb 05                	jmp    801e96 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	6a 26                	push   $0x26
  801ea8:	e8 cd fa ff ff       	call   80197a <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	53                   	push   %ebx
  801ec6:	51                   	push   %ecx
  801ec7:	52                   	push   %edx
  801ec8:	50                   	push   %eax
  801ec9:	6a 27                	push   $0x27
  801ecb:	e8 aa fa ff ff       	call   80197a <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
}
  801ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 28                	push   $0x28
  801eeb:	e8 8a fa ff ff       	call   80197a <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ef8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	6a 00                	push   $0x0
  801f03:	51                   	push   %ecx
  801f04:	ff 75 10             	pushl  0x10(%ebp)
  801f07:	52                   	push   %edx
  801f08:	50                   	push   %eax
  801f09:	6a 29                	push   $0x29
  801f0b:	e8 6a fa ff ff       	call   80197a <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	ff 75 10             	pushl  0x10(%ebp)
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 12                	push   $0x12
  801f27:	e8 4e fa ff ff       	call   80197a <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 2a                	push   $0x2a
  801f45:	e8 30 fa ff ff       	call   80197a <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
	return;
  801f4d:	90                   	nop
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	50                   	push   %eax
  801f5f:	6a 2b                	push   $0x2b
  801f61:	e8 14 fa ff ff       	call   80197a <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	ff 75 08             	pushl  0x8(%ebp)
  801f7a:	6a 2c                	push   $0x2c
  801f7c:	e8 f9 f9 ff ff       	call   80197a <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
	return;
  801f84:	90                   	nop
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	6a 2d                	push   $0x2d
  801f98:	e8 dd f9 ff ff       	call   80197a <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
	return;
  801fa0:	90                   	nop
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	83 e8 04             	sub    $0x4,%eax
  801faf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb5:	8b 00                	mov    (%eax),%eax
  801fb7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	83 e8 04             	sub    $0x4,%eax
  801fc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	83 e0 01             	and    $0x1,%eax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	0f 94 c0             	sete   %al
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fe0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	83 f8 02             	cmp    $0x2,%eax
  801fed:	74 2b                	je     80201a <alloc_block+0x40>
  801fef:	83 f8 02             	cmp    $0x2,%eax
  801ff2:	7f 07                	jg     801ffb <alloc_block+0x21>
  801ff4:	83 f8 01             	cmp    $0x1,%eax
  801ff7:	74 0e                	je     802007 <alloc_block+0x2d>
  801ff9:	eb 58                	jmp    802053 <alloc_block+0x79>
  801ffb:	83 f8 03             	cmp    $0x3,%eax
  801ffe:	74 2d                	je     80202d <alloc_block+0x53>
  802000:	83 f8 04             	cmp    $0x4,%eax
  802003:	74 3b                	je     802040 <alloc_block+0x66>
  802005:	eb 4c                	jmp    802053 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	e8 11 03 00 00       	call   802323 <alloc_block_FF>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802018:	eb 4a                	jmp    802064 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	e8 c7 19 00 00       	call   8039ec <alloc_block_NF>
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202b:	eb 37                	jmp    802064 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	e8 a7 07 00 00       	call   8027df <alloc_block_BF>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80203e:	eb 24                	jmp    802064 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	e8 84 19 00 00       	call   8039cf <alloc_block_WF>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802051:	eb 11                	jmp    802064 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	68 68 45 80 00       	push   $0x804568
  80205b:	e8 4d e6 ff ff       	call   8006ad <cprintf>
  802060:	83 c4 10             	add    $0x10,%esp
		break;
  802063:	90                   	nop
	}
	return va;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	53                   	push   %ebx
  80206d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802070:	83 ec 0c             	sub    $0xc,%esp
  802073:	68 88 45 80 00       	push   $0x804588
  802078:	e8 30 e6 ff ff       	call   8006ad <cprintf>
  80207d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	68 b3 45 80 00       	push   $0x8045b3
  802088:	e8 20 e6 ff ff       	call   8006ad <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802096:	eb 37                	jmp    8020cf <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	ff 75 f4             	pushl  -0xc(%ebp)
  80209e:	e8 19 ff ff ff       	call   801fbc <is_free_block>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	0f be d8             	movsbl %al,%ebx
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8020af:	e8 ef fe ff ff       	call   801fa3 <get_block_size>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	53                   	push   %ebx
  8020bb:	50                   	push   %eax
  8020bc:	68 cb 45 80 00       	push   $0x8045cb
  8020c1:	e8 e7 e5 ff ff       	call   8006ad <cprintf>
  8020c6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d3:	74 07                	je     8020dc <print_blocks_list+0x73>
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	eb 05                	jmp    8020e1 <print_blocks_list+0x78>
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e1:	89 45 10             	mov    %eax,0x10(%ebp)
  8020e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	75 ad                	jne    802098 <print_blocks_list+0x2f>
  8020eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ef:	75 a7                	jne    802098 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020f1:	83 ec 0c             	sub    $0xc,%esp
  8020f4:	68 88 45 80 00       	push   $0x804588
  8020f9:	e8 af e5 ff ff       	call   8006ad <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp

}
  802101:	90                   	nop
  802102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	83 e0 01             	and    $0x1,%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 03                	je     80211a <initialize_dynamic_allocator+0x13>
  802117:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80211a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80211e:	0f 84 c7 01 00 00    	je     8022eb <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802124:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80212b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	8b 45 0c             	mov    0xc(%ebp),%eax
  802134:	01 d0                	add    %edx,%eax
  802136:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80213b:	0f 87 ad 01 00 00    	ja     8022ee <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	0f 89 a5 01 00 00    	jns    8022f1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80214c:	8b 55 08             	mov    0x8(%ebp),%edx
  80214f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802152:	01 d0                	add    %edx,%eax
  802154:	83 e8 04             	sub    $0x4,%eax
  802157:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80215c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802163:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216b:	e9 87 00 00 00       	jmp    8021f7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802170:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802174:	75 14                	jne    80218a <initialize_dynamic_allocator+0x83>
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	68 e3 45 80 00       	push   $0x8045e3
  80217e:	6a 79                	push   $0x79
  802180:	68 01 46 80 00       	push   $0x804601
  802185:	e8 f2 18 00 00       	call   803a7c <_panic>
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 10                	je     8021a3 <initialize_dynamic_allocator+0x9c>
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219b:	8b 52 04             	mov    0x4(%edx),%edx
  80219e:	89 50 04             	mov    %edx,0x4(%eax)
  8021a1:	eb 0b                	jmp    8021ae <initialize_dynamic_allocator+0xa7>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 40 04             	mov    0x4(%eax),%eax
  8021a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 04             	mov    0x4(%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	74 0f                	je     8021c7 <initialize_dynamic_allocator+0xc0>
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 40 04             	mov    0x4(%eax),%eax
  8021be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c1:	8b 12                	mov    (%edx),%edx
  8021c3:	89 10                	mov    %edx,(%eax)
  8021c5:	eb 0a                	jmp    8021d1 <initialize_dynamic_allocator+0xca>
  8021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8021e9:	48                   	dec    %eax
  8021ea:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	74 07                	je     802204 <initialize_dynamic_allocator+0xfd>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	eb 05                	jmp    802209 <initialize_dynamic_allocator+0x102>
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
  802209:	a3 34 50 80 00       	mov    %eax,0x805034
  80220e:	a1 34 50 80 00       	mov    0x805034,%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 85 55 ff ff ff    	jne    802170 <initialize_dynamic_allocator+0x69>
  80221b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221f:	0f 85 4b ff ff ff    	jne    802170 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802234:	a1 44 50 80 00       	mov    0x805044,%eax
  802239:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80223e:	a1 40 50 80 00       	mov    0x805040,%eax
  802243:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	83 c0 08             	add    $0x8,%eax
  80224f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	83 c0 04             	add    $0x4,%eax
  802258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225b:	83 ea 08             	sub    $0x8,%edx
  80225e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802260:	8b 55 0c             	mov    0xc(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	83 e8 08             	sub    $0x8,%eax
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	83 ea 08             	sub    $0x8,%edx
  802271:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802273:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80227c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802286:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80228a:	75 17                	jne    8022a3 <initialize_dynamic_allocator+0x19c>
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 1c 46 80 00       	push   $0x80461c
  802294:	68 90 00 00 00       	push   $0x90
  802299:	68 01 46 80 00       	push   $0x804601
  80229e:	e8 d9 17 00 00       	call   803a7c <_panic>
  8022a3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 0d                	je     8022c4 <initialize_dynamic_allocator+0x1bd>
  8022b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	eb 08                	jmp    8022cc <initialize_dynamic_allocator+0x1c5>
  8022c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8022cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022de:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e3:	40                   	inc    %eax
  8022e4:	a3 38 50 80 00       	mov    %eax,0x805038
  8022e9:	eb 07                	jmp    8022f2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022eb:	90                   	nop
  8022ec:	eb 04                	jmp    8022f2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022ee:	90                   	nop
  8022ef:	eb 01                	jmp    8022f2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022f1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8d 50 fc             	lea    -0x4(%eax),%edx
  802303:	8b 45 0c             	mov    0xc(%ebp),%eax
  802306:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	83 e8 04             	sub    $0x4,%eax
  80230e:	8b 00                	mov    (%eax),%eax
  802310:	83 e0 fe             	and    $0xfffffffe,%eax
  802313:	8d 50 f8             	lea    -0x8(%eax),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	01 c2                	add    %eax,%edx
  80231b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231e:	89 02                	mov    %eax,(%edx)
}
  802320:	90                   	nop
  802321:	5d                   	pop    %ebp
  802322:	c3                   	ret    

00802323 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	83 e0 01             	and    $0x1,%eax
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 03                	je     802336 <alloc_block_FF+0x13>
  802333:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802336:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80233a:	77 07                	ja     802343 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80233c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802343:	a1 24 50 80 00       	mov    0x805024,%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	75 73                	jne    8023bf <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	83 c0 10             	add    $0x10,%eax
  802352:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802355:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80235c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	48                   	dec    %eax
  802365:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80236b:	ba 00 00 00 00       	mov    $0x0,%edx
  802370:	f7 75 ec             	divl   -0x14(%ebp)
  802373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802376:	29 d0                	sub    %edx,%eax
  802378:	c1 e8 0c             	shr    $0xc,%eax
  80237b:	83 ec 0c             	sub    $0xc,%esp
  80237e:	50                   	push   %eax
  80237f:	e8 c3 f0 ff ff       	call   801447 <sbrk>
  802384:	83 c4 10             	add    $0x10,%esp
  802387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80238a:	83 ec 0c             	sub    $0xc,%esp
  80238d:	6a 00                	push   $0x0
  80238f:	e8 b3 f0 ff ff       	call   801447 <sbrk>
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80239a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023a0:	83 ec 08             	sub    $0x8,%esp
  8023a3:	50                   	push   %eax
  8023a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023a7:	e8 5b fd ff ff       	call   802107 <initialize_dynamic_allocator>
  8023ac:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023af:	83 ec 0c             	sub    $0xc,%esp
  8023b2:	68 3f 46 80 00       	push   $0x80463f
  8023b7:	e8 f1 e2 ff ff       	call   8006ad <cprintf>
  8023bc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c3:	75 0a                	jne    8023cf <alloc_block_FF+0xac>
	        return NULL;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	e9 0e 04 00 00       	jmp    8027dd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023de:	e9 f3 02 00 00       	jmp    8026d6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8023ef:	e8 af fb ff ff       	call   801fa3 <get_block_size>
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	83 c0 08             	add    $0x8,%eax
  802400:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802403:	0f 87 c5 02 00 00    	ja     8026ce <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	83 c0 18             	add    $0x18,%eax
  80240f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802412:	0f 87 19 02 00 00    	ja     802631 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80241b:	2b 45 08             	sub    0x8(%ebp),%eax
  80241e:	83 e8 08             	sub    $0x8,%eax
  802421:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8d 50 08             	lea    0x8(%eax),%edx
  80242a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80242d:	01 d0                	add    %edx,%eax
  80242f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	83 c0 08             	add    $0x8,%eax
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	6a 01                	push   $0x1
  80243d:	50                   	push   %eax
  80243e:	ff 75 bc             	pushl  -0x44(%ebp)
  802441:	e8 ae fe ff ff       	call   8022f4 <set_block_data>
  802446:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	75 68                	jne    8024bb <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802453:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802457:	75 17                	jne    802470 <alloc_block_FF+0x14d>
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 1c 46 80 00       	push   $0x80461c
  802461:	68 d7 00 00 00       	push   $0xd7
  802466:	68 01 46 80 00       	push   $0x804601
  80246b:	e8 0c 16 00 00       	call   803a7c <_panic>
  802470:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802476:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802479:	89 10                	mov    %edx,(%eax)
  80247b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	74 0d                	je     802491 <alloc_block_FF+0x16e>
  802484:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802489:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80248c:	89 50 04             	mov    %edx,0x4(%eax)
  80248f:	eb 08                	jmp    802499 <alloc_block_FF+0x176>
  802491:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802494:	a3 30 50 80 00       	mov    %eax,0x805030
  802499:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b0:	40                   	inc    %eax
  8024b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8024b6:	e9 dc 00 00 00       	jmp    802597 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	75 65                	jne    802529 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024c4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024c8:	75 17                	jne    8024e1 <alloc_block_FF+0x1be>
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	68 50 46 80 00       	push   $0x804650
  8024d2:	68 db 00 00 00       	push   $0xdb
  8024d7:	68 01 46 80 00       	push   $0x804601
  8024dc:	e8 9b 15 00 00       	call   803a7c <_panic>
  8024e1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ea:	89 50 04             	mov    %edx,0x4(%eax)
  8024ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	74 0c                	je     802503 <alloc_block_FF+0x1e0>
  8024f7:	a1 30 50 80 00       	mov    0x805030,%eax
  8024fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ff:	89 10                	mov    %edx,(%eax)
  802501:	eb 08                	jmp    80250b <alloc_block_FF+0x1e8>
  802503:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802506:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80250b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250e:	a3 30 50 80 00       	mov    %eax,0x805030
  802513:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	a1 38 50 80 00       	mov    0x805038,%eax
  802521:	40                   	inc    %eax
  802522:	a3 38 50 80 00       	mov    %eax,0x805038
  802527:	eb 6e                	jmp    802597 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	74 06                	je     802535 <alloc_block_FF+0x212>
  80252f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802533:	75 17                	jne    80254c <alloc_block_FF+0x229>
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 74 46 80 00       	push   $0x804674
  80253d:	68 df 00 00 00       	push   $0xdf
  802542:	68 01 46 80 00       	push   $0x804601
  802547:	e8 30 15 00 00       	call   803a7c <_panic>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 10                	mov    (%eax),%edx
  802551:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802554:	89 10                	mov    %edx,(%eax)
  802556:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	74 0b                	je     80256a <alloc_block_FF+0x247>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802567:	89 50 04             	mov    %edx,0x4(%eax)
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802570:	89 10                	mov    %edx,(%eax)
  802572:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802578:	89 50 04             	mov    %edx,0x4(%eax)
  80257b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	75 08                	jne    80258c <alloc_block_FF+0x269>
  802584:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802587:	a3 30 50 80 00       	mov    %eax,0x805030
  80258c:	a1 38 50 80 00       	mov    0x805038,%eax
  802591:	40                   	inc    %eax
  802592:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	75 17                	jne    8025b4 <alloc_block_FF+0x291>
  80259d:	83 ec 04             	sub    $0x4,%esp
  8025a0:	68 e3 45 80 00       	push   $0x8045e3
  8025a5:	68 e1 00 00 00       	push   $0xe1
  8025aa:	68 01 46 80 00       	push   $0x804601
  8025af:	e8 c8 14 00 00       	call   803a7c <_panic>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	74 10                	je     8025cd <alloc_block_FF+0x2aa>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	8b 52 04             	mov    0x4(%edx),%edx
  8025c8:	89 50 04             	mov    %edx,0x4(%eax)
  8025cb:	eb 0b                	jmp    8025d8 <alloc_block_FF+0x2b5>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 0f                	je     8025f1 <alloc_block_FF+0x2ce>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 04             	mov    0x4(%eax),%eax
  8025e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025eb:	8b 12                	mov    (%edx),%edx
  8025ed:	89 10                	mov    %edx,(%eax)
  8025ef:	eb 0a                	jmp    8025fb <alloc_block_FF+0x2d8>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260e:	a1 38 50 80 00       	mov    0x805038,%eax
  802613:	48                   	dec    %eax
  802614:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	6a 00                	push   $0x0
  80261e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802621:	ff 75 b0             	pushl  -0x50(%ebp)
  802624:	e8 cb fc ff ff       	call   8022f4 <set_block_data>
  802629:	83 c4 10             	add    $0x10,%esp
  80262c:	e9 95 00 00 00       	jmp    8026c6 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	6a 01                	push   $0x1
  802636:	ff 75 b8             	pushl  -0x48(%ebp)
  802639:	ff 75 bc             	pushl  -0x44(%ebp)
  80263c:	e8 b3 fc ff ff       	call   8022f4 <set_block_data>
  802641:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802648:	75 17                	jne    802661 <alloc_block_FF+0x33e>
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 e3 45 80 00       	push   $0x8045e3
  802652:	68 e8 00 00 00       	push   $0xe8
  802657:	68 01 46 80 00       	push   $0x804601
  80265c:	e8 1b 14 00 00       	call   803a7c <_panic>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	74 10                	je     80267a <alloc_block_FF+0x357>
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802672:	8b 52 04             	mov    0x4(%edx),%edx
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	eb 0b                	jmp    802685 <alloc_block_FF+0x362>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	a3 30 50 80 00       	mov    %eax,0x805030
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0f                	je     80269e <alloc_block_FF+0x37b>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802698:	8b 12                	mov    (%edx),%edx
  80269a:	89 10                	mov    %edx,(%eax)
  80269c:	eb 0a                	jmp    8026a8 <alloc_block_FF+0x385>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c0:	48                   	dec    %eax
  8026c1:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026c6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026c9:	e9 0f 01 00 00       	jmp    8027dd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026da:	74 07                	je     8026e3 <alloc_block_FF+0x3c0>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	eb 05                	jmp    8026e8 <alloc_block_FF+0x3c5>
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	0f 85 e9 fc ff ff    	jne    8023e3 <alloc_block_FF+0xc0>
  8026fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fe:	0f 85 df fc ff ff    	jne    8023e3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	83 c0 08             	add    $0x8,%eax
  80270a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80270d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802714:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802717:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80271a:	01 d0                	add    %edx,%eax
  80271c:	48                   	dec    %eax
  80271d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802723:	ba 00 00 00 00       	mov    $0x0,%edx
  802728:	f7 75 d8             	divl   -0x28(%ebp)
  80272b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272e:	29 d0                	sub    %edx,%eax
  802730:	c1 e8 0c             	shr    $0xc,%eax
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	50                   	push   %eax
  802737:	e8 0b ed ff ff       	call   801447 <sbrk>
  80273c:	83 c4 10             	add    $0x10,%esp
  80273f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802742:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802746:	75 0a                	jne    802752 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	e9 8b 00 00 00       	jmp    8027dd <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802752:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802759:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80275c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275f:	01 d0                	add    %edx,%eax
  802761:	48                   	dec    %eax
  802762:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802765:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802768:	ba 00 00 00 00       	mov    $0x0,%edx
  80276d:	f7 75 cc             	divl   -0x34(%ebp)
  802770:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802773:	29 d0                	sub    %edx,%eax
  802775:	8d 50 fc             	lea    -0x4(%eax),%edx
  802778:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80277b:	01 d0                	add    %edx,%eax
  80277d:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802782:	a1 40 50 80 00       	mov    0x805040,%eax
  802787:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80278d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802794:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802797:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80279a:	01 d0                	add    %edx,%eax
  80279c:	48                   	dec    %eax
  80279d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a8:	f7 75 c4             	divl   -0x3c(%ebp)
  8027ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027ae:	29 d0                	sub    %edx,%eax
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	6a 01                	push   $0x1
  8027b5:	50                   	push   %eax
  8027b6:	ff 75 d0             	pushl  -0x30(%ebp)
  8027b9:	e8 36 fb ff ff       	call   8022f4 <set_block_data>
  8027be:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027c1:	83 ec 0c             	sub    $0xc,%esp
  8027c4:	ff 75 d0             	pushl  -0x30(%ebp)
  8027c7:	e8 f8 09 00 00       	call   8031c4 <free_block>
  8027cc:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	ff 75 08             	pushl  0x8(%ebp)
  8027d5:	e8 49 fb ff ff       	call   802323 <alloc_block_FF>
  8027da:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	83 e0 01             	and    $0x1,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 03                	je     8027f2 <alloc_block_BF+0x13>
  8027ef:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027f2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027f6:	77 07                	ja     8027ff <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027f8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027ff:	a1 24 50 80 00       	mov    0x805024,%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	75 73                	jne    80287b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 10             	add    $0x10,%eax
  80280e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802811:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802818:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281e:	01 d0                	add    %edx,%eax
  802820:	48                   	dec    %eax
  802821:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802824:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802827:	ba 00 00 00 00       	mov    $0x0,%edx
  80282c:	f7 75 e0             	divl   -0x20(%ebp)
  80282f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802832:	29 d0                	sub    %edx,%eax
  802834:	c1 e8 0c             	shr    $0xc,%eax
  802837:	83 ec 0c             	sub    $0xc,%esp
  80283a:	50                   	push   %eax
  80283b:	e8 07 ec ff ff       	call   801447 <sbrk>
  802840:	83 c4 10             	add    $0x10,%esp
  802843:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802846:	83 ec 0c             	sub    $0xc,%esp
  802849:	6a 00                	push   $0x0
  80284b:	e8 f7 eb ff ff       	call   801447 <sbrk>
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802859:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80285c:	83 ec 08             	sub    $0x8,%esp
  80285f:	50                   	push   %eax
  802860:	ff 75 d8             	pushl  -0x28(%ebp)
  802863:	e8 9f f8 ff ff       	call   802107 <initialize_dynamic_allocator>
  802868:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	68 3f 46 80 00       	push   $0x80463f
  802873:	e8 35 de ff ff       	call   8006ad <cprintf>
  802878:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80287b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802889:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802890:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802897:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80289c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289f:	e9 1d 01 00 00       	jmp    8029c1 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028aa:	83 ec 0c             	sub    $0xc,%esp
  8028ad:	ff 75 a8             	pushl  -0x58(%ebp)
  8028b0:	e8 ee f6 ff ff       	call   801fa3 <get_block_size>
  8028b5:	83 c4 10             	add    $0x10,%esp
  8028b8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	83 c0 08             	add    $0x8,%eax
  8028c1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c4:	0f 87 ef 00 00 00    	ja     8029b9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	83 c0 18             	add    $0x18,%eax
  8028d0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d3:	77 1d                	ja     8028f2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028db:	0f 86 d8 00 00 00    	jbe    8029b9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028e1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028e7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028ed:	e9 c7 00 00 00       	jmp    8029b9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	83 c0 08             	add    $0x8,%eax
  8028f8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028fb:	0f 85 9d 00 00 00    	jne    80299e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	6a 01                	push   $0x1
  802906:	ff 75 a4             	pushl  -0x5c(%ebp)
  802909:	ff 75 a8             	pushl  -0x58(%ebp)
  80290c:	e8 e3 f9 ff ff       	call   8022f4 <set_block_data>
  802911:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802918:	75 17                	jne    802931 <alloc_block_BF+0x152>
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 e3 45 80 00       	push   $0x8045e3
  802922:	68 2c 01 00 00       	push   $0x12c
  802927:	68 01 46 80 00       	push   $0x804601
  80292c:	e8 4b 11 00 00       	call   803a7c <_panic>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	74 10                	je     80294a <alloc_block_BF+0x16b>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802942:	8b 52 04             	mov    0x4(%edx),%edx
  802945:	89 50 04             	mov    %edx,0x4(%eax)
  802948:	eb 0b                	jmp    802955 <alloc_block_BF+0x176>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	a3 30 50 80 00       	mov    %eax,0x805030
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 04             	mov    0x4(%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 0f                	je     80296e <alloc_block_BF+0x18f>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802968:	8b 12                	mov    (%edx),%edx
  80296a:	89 10                	mov    %edx,(%eax)
  80296c:	eb 0a                	jmp    802978 <alloc_block_BF+0x199>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298b:	a1 38 50 80 00       	mov    0x805038,%eax
  802990:	48                   	dec    %eax
  802991:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802996:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802999:	e9 01 04 00 00       	jmp    802d9f <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029a4:	76 13                	jbe    8029b9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029a6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029ad:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029b6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	74 07                	je     8029ce <alloc_block_BF+0x1ef>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	eb 05                	jmp    8029d3 <alloc_block_BF+0x1f4>
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8029d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	0f 85 bf fe ff ff    	jne    8028a4 <alloc_block_BF+0xc5>
  8029e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e9:	0f 85 b5 fe ff ff    	jne    8028a4 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f3:	0f 84 26 02 00 00    	je     802c1f <alloc_block_BF+0x440>
  8029f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029fd:	0f 85 1c 02 00 00    	jne    802c1f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	2b 45 08             	sub    0x8(%ebp),%eax
  802a09:	83 e8 08             	sub    $0x8,%eax
  802a0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8d 50 08             	lea    0x8(%eax),%edx
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	83 c0 08             	add    $0x8,%eax
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	6a 01                	push   $0x1
  802a28:	50                   	push   %eax
  802a29:	ff 75 f0             	pushl  -0x10(%ebp)
  802a2c:	e8 c3 f8 ff ff       	call   8022f4 <set_block_data>
  802a31:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	8b 40 04             	mov    0x4(%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	75 68                	jne    802aa6 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a3e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a42:	75 17                	jne    802a5b <alloc_block_BF+0x27c>
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 1c 46 80 00       	push   $0x80461c
  802a4c:	68 45 01 00 00       	push   $0x145
  802a51:	68 01 46 80 00       	push   $0x804601
  802a56:	e8 21 10 00 00       	call   803a7c <_panic>
  802a5b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0d                	je     802a7c <alloc_block_BF+0x29d>
  802a6f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	eb 08                	jmp    802a84 <alloc_block_BF+0x2a5>
  802a7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a96:	a1 38 50 80 00       	mov    0x805038,%eax
  802a9b:	40                   	inc    %eax
  802a9c:	a3 38 50 80 00       	mov    %eax,0x805038
  802aa1:	e9 dc 00 00 00       	jmp    802b82 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	75 65                	jne    802b14 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802aaf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ab3:	75 17                	jne    802acc <alloc_block_BF+0x2ed>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 50 46 80 00       	push   $0x804650
  802abd:	68 4a 01 00 00       	push   $0x14a
  802ac2:	68 01 46 80 00       	push   $0x804601
  802ac7:	e8 b0 0f 00 00       	call   803a7c <_panic>
  802acc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ad2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0c                	je     802aee <alloc_block_BF+0x30f>
  802ae2:	a1 30 50 80 00       	mov    0x805030,%eax
  802ae7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aea:	89 10                	mov    %edx,(%eax)
  802aec:	eb 08                	jmp    802af6 <alloc_block_BF+0x317>
  802aee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af9:	a3 30 50 80 00       	mov    %eax,0x805030
  802afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	a1 38 50 80 00       	mov    0x805038,%eax
  802b0c:	40                   	inc    %eax
  802b0d:	a3 38 50 80 00       	mov    %eax,0x805038
  802b12:	eb 6e                	jmp    802b82 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b18:	74 06                	je     802b20 <alloc_block_BF+0x341>
  802b1a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b1e:	75 17                	jne    802b37 <alloc_block_BF+0x358>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 74 46 80 00       	push   $0x804674
  802b28:	68 4f 01 00 00       	push   $0x14f
  802b2d:	68 01 46 80 00       	push   $0x804601
  802b32:	e8 45 0f 00 00       	call   803a7c <_panic>
  802b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3a:	8b 10                	mov    (%eax),%edx
  802b3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3f:	89 10                	mov    %edx,(%eax)
  802b41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0b                	je     802b55 <alloc_block_BF+0x376>
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	75 08                	jne    802b77 <alloc_block_BF+0x398>
  802b6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b72:	a3 30 50 80 00       	mov    %eax,0x805030
  802b77:	a1 38 50 80 00       	mov    0x805038,%eax
  802b7c:	40                   	inc    %eax
  802b7d:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b86:	75 17                	jne    802b9f <alloc_block_BF+0x3c0>
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	68 e3 45 80 00       	push   $0x8045e3
  802b90:	68 51 01 00 00       	push   $0x151
  802b95:	68 01 46 80 00       	push   $0x804601
  802b9a:	e8 dd 0e 00 00       	call   803a7c <_panic>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 10                	je     802bb8 <alloc_block_BF+0x3d9>
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb0:	8b 52 04             	mov    0x4(%edx),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 0b                	jmp    802bc3 <alloc_block_BF+0x3e4>
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 0f                	je     802bdc <alloc_block_BF+0x3fd>
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	8b 40 04             	mov    0x4(%eax),%eax
  802bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd6:	8b 12                	mov    (%edx),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	eb 0a                	jmp    802be6 <alloc_block_BF+0x407>
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bfe:	48                   	dec    %eax
  802bff:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	6a 00                	push   $0x0
  802c09:	ff 75 d0             	pushl  -0x30(%ebp)
  802c0c:	ff 75 cc             	pushl  -0x34(%ebp)
  802c0f:	e8 e0 f6 ff ff       	call   8022f4 <set_block_data>
  802c14:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	e9 80 01 00 00       	jmp    802d9f <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802c1f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c23:	0f 85 9d 00 00 00    	jne    802cc6 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c29:	83 ec 04             	sub    $0x4,%esp
  802c2c:	6a 01                	push   $0x1
  802c2e:	ff 75 ec             	pushl  -0x14(%ebp)
  802c31:	ff 75 f0             	pushl  -0x10(%ebp)
  802c34:	e8 bb f6 ff ff       	call   8022f4 <set_block_data>
  802c39:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c40:	75 17                	jne    802c59 <alloc_block_BF+0x47a>
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	68 e3 45 80 00       	push   $0x8045e3
  802c4a:	68 58 01 00 00       	push   $0x158
  802c4f:	68 01 46 80 00       	push   $0x804601
  802c54:	e8 23 0e 00 00       	call   803a7c <_panic>
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 10                	je     802c72 <alloc_block_BF+0x493>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6a:	8b 52 04             	mov    0x4(%edx),%edx
  802c6d:	89 50 04             	mov    %edx,0x4(%eax)
  802c70:	eb 0b                	jmp    802c7d <alloc_block_BF+0x49e>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 0f                	je     802c96 <alloc_block_BF+0x4b7>
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	8b 40 04             	mov    0x4(%eax),%eax
  802c8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c90:	8b 12                	mov    (%edx),%edx
  802c92:	89 10                	mov    %edx,(%eax)
  802c94:	eb 0a                	jmp    802ca0 <alloc_block_BF+0x4c1>
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb8:	48                   	dec    %eax
  802cb9:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	e9 d9 00 00 00       	jmp    802d9f <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	83 c0 08             	add    $0x8,%eax
  802ccc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ccf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cd6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cdc:	01 d0                	add    %edx,%eax
  802cde:	48                   	dec    %eax
  802cdf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ce2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cea:	f7 75 c4             	divl   -0x3c(%ebp)
  802ced:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf0:	29 d0                	sub    %edx,%eax
  802cf2:	c1 e8 0c             	shr    $0xc,%eax
  802cf5:	83 ec 0c             	sub    $0xc,%esp
  802cf8:	50                   	push   %eax
  802cf9:	e8 49 e7 ff ff       	call   801447 <sbrk>
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d04:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d08:	75 0a                	jne    802d14 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0f:	e9 8b 00 00 00       	jmp    802d9f <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d14:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d1b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d1e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d21:	01 d0                	add    %edx,%eax
  802d23:	48                   	dec    %eax
  802d24:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d27:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2f:	f7 75 b8             	divl   -0x48(%ebp)
  802d32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d35:	29 d0                	sub    %edx,%eax
  802d37:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d3a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d3d:	01 d0                	add    %edx,%eax
  802d3f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d44:	a1 40 50 80 00       	mov    0x805040,%eax
  802d49:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d4f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d56:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d62:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d65:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6a:	f7 75 b0             	divl   -0x50(%ebp)
  802d6d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d70:	29 d0                	sub    %edx,%eax
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	6a 01                	push   $0x1
  802d77:	50                   	push   %eax
  802d78:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7b:	e8 74 f5 ff ff       	call   8022f4 <set_block_data>
  802d80:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d83:	83 ec 0c             	sub    $0xc,%esp
  802d86:	ff 75 bc             	pushl  -0x44(%ebp)
  802d89:	e8 36 04 00 00       	call   8031c4 <free_block>
  802d8e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d91:	83 ec 0c             	sub    $0xc,%esp
  802d94:	ff 75 08             	pushl  0x8(%ebp)
  802d97:	e8 43 fa ff ff       	call   8027df <alloc_block_BF>
  802d9c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d9f:	c9                   	leave  
  802da0:	c3                   	ret    

00802da1 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802da1:	55                   	push   %ebp
  802da2:	89 e5                	mov    %esp,%ebp
  802da4:	53                   	push   %ebx
  802da5:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802da8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802daf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802db6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dba:	74 1e                	je     802dda <merging+0x39>
  802dbc:	ff 75 08             	pushl  0x8(%ebp)
  802dbf:	e8 df f1 ff ff       	call   801fa3 <get_block_size>
  802dc4:	83 c4 04             	add    $0x4,%esp
  802dc7:	89 c2                	mov    %eax,%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	01 d0                	add    %edx,%eax
  802dce:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dd1:	75 07                	jne    802dda <merging+0x39>
		prev_is_free = 1;
  802dd3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dde:	74 1e                	je     802dfe <merging+0x5d>
  802de0:	ff 75 10             	pushl  0x10(%ebp)
  802de3:	e8 bb f1 ff ff       	call   801fa3 <get_block_size>
  802de8:	83 c4 04             	add    $0x4,%esp
  802deb:	89 c2                	mov    %eax,%edx
  802ded:	8b 45 10             	mov    0x10(%ebp),%eax
  802df0:	01 d0                	add    %edx,%eax
  802df2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802df5:	75 07                	jne    802dfe <merging+0x5d>
		next_is_free = 1;
  802df7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e02:	0f 84 cc 00 00 00    	je     802ed4 <merging+0x133>
  802e08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0c:	0f 84 c2 00 00 00    	je     802ed4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e12:	ff 75 08             	pushl  0x8(%ebp)
  802e15:	e8 89 f1 ff ff       	call   801fa3 <get_block_size>
  802e1a:	83 c4 04             	add    $0x4,%esp
  802e1d:	89 c3                	mov    %eax,%ebx
  802e1f:	ff 75 10             	pushl  0x10(%ebp)
  802e22:	e8 7c f1 ff ff       	call   801fa3 <get_block_size>
  802e27:	83 c4 04             	add    $0x4,%esp
  802e2a:	01 c3                	add    %eax,%ebx
  802e2c:	ff 75 0c             	pushl  0xc(%ebp)
  802e2f:	e8 6f f1 ff ff       	call   801fa3 <get_block_size>
  802e34:	83 c4 04             	add    $0x4,%esp
  802e37:	01 d8                	add    %ebx,%eax
  802e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e3c:	6a 00                	push   $0x0
  802e3e:	ff 75 ec             	pushl  -0x14(%ebp)
  802e41:	ff 75 08             	pushl  0x8(%ebp)
  802e44:	e8 ab f4 ff ff       	call   8022f4 <set_block_data>
  802e49:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e50:	75 17                	jne    802e69 <merging+0xc8>
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	68 e3 45 80 00       	push   $0x8045e3
  802e5a:	68 7d 01 00 00       	push   $0x17d
  802e5f:	68 01 46 80 00       	push   $0x804601
  802e64:	e8 13 0c 00 00       	call   803a7c <_panic>
  802e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 10                	je     802e82 <merging+0xe1>
  802e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7a:	8b 52 04             	mov    0x4(%edx),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	eb 0b                	jmp    802e8d <merging+0xec>
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0f                	je     802ea6 <merging+0x105>
  802e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9a:	8b 40 04             	mov    0x4(%eax),%eax
  802e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea0:	8b 12                	mov    (%edx),%edx
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	eb 0a                	jmp    802eb0 <merging+0x10f>
  802ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec8:	48                   	dec    %eax
  802ec9:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ece:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ecf:	e9 ea 02 00 00       	jmp    8031be <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	74 3b                	je     802f15 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802eda:	83 ec 0c             	sub    $0xc,%esp
  802edd:	ff 75 08             	pushl  0x8(%ebp)
  802ee0:	e8 be f0 ff ff       	call   801fa3 <get_block_size>
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	89 c3                	mov    %eax,%ebx
  802eea:	83 ec 0c             	sub    $0xc,%esp
  802eed:	ff 75 10             	pushl  0x10(%ebp)
  802ef0:	e8 ae f0 ff ff       	call   801fa3 <get_block_size>
  802ef5:	83 c4 10             	add    $0x10,%esp
  802ef8:	01 d8                	add    %ebx,%eax
  802efa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	6a 00                	push   $0x0
  802f02:	ff 75 e8             	pushl  -0x18(%ebp)
  802f05:	ff 75 08             	pushl  0x8(%ebp)
  802f08:	e8 e7 f3 ff ff       	call   8022f4 <set_block_data>
  802f0d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f10:	e9 a9 02 00 00       	jmp    8031be <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f19:	0f 84 2d 01 00 00    	je     80304c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 10             	pushl  0x10(%ebp)
  802f25:	e8 79 f0 ff ff       	call   801fa3 <get_block_size>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	89 c3                	mov    %eax,%ebx
  802f2f:	83 ec 0c             	sub    $0xc,%esp
  802f32:	ff 75 0c             	pushl  0xc(%ebp)
  802f35:	e8 69 f0 ff ff       	call   801fa3 <get_block_size>
  802f3a:	83 c4 10             	add    $0x10,%esp
  802f3d:	01 d8                	add    %ebx,%eax
  802f3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	6a 00                	push   $0x0
  802f47:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f4a:	ff 75 10             	pushl  0x10(%ebp)
  802f4d:	e8 a2 f3 ff ff       	call   8022f4 <set_block_data>
  802f52:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f55:	8b 45 10             	mov    0x10(%ebp),%eax
  802f58:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5f:	74 06                	je     802f67 <merging+0x1c6>
  802f61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f65:	75 17                	jne    802f7e <merging+0x1dd>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 a8 46 80 00       	push   $0x8046a8
  802f6f:	68 8d 01 00 00       	push   $0x18d
  802f74:	68 01 46 80 00       	push   $0x804601
  802f79:	e8 fe 0a 00 00       	call   803a7c <_panic>
  802f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f81:	8b 50 04             	mov    0x4(%eax),%edx
  802f84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0d                	je     802fa9 <merging+0x208>
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa5:	89 10                	mov    %edx,(%eax)
  802fa7:	eb 08                	jmp    802fb1 <merging+0x210>
  802fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb7:	89 50 04             	mov    %edx,0x4(%eax)
  802fba:	a1 38 50 80 00       	mov    0x805038,%eax
  802fbf:	40                   	inc    %eax
  802fc0:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc9:	75 17                	jne    802fe2 <merging+0x241>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 e3 45 80 00       	push   $0x8045e3
  802fd3:	68 8e 01 00 00       	push   $0x18e
  802fd8:	68 01 46 80 00       	push   $0x804601
  802fdd:	e8 9a 0a 00 00       	call   803a7c <_panic>
  802fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	74 10                	je     802ffb <merging+0x25a>
  802feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff3:	8b 52 04             	mov    0x4(%edx),%edx
  802ff6:	89 50 04             	mov    %edx,0x4(%eax)
  802ff9:	eb 0b                	jmp    803006 <merging+0x265>
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	a3 30 50 80 00       	mov    %eax,0x805030
  803006:	8b 45 0c             	mov    0xc(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	74 0f                	je     80301f <merging+0x27e>
  803010:	8b 45 0c             	mov    0xc(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	8b 55 0c             	mov    0xc(%ebp),%edx
  803019:	8b 12                	mov    (%edx),%edx
  80301b:	89 10                	mov    %edx,(%eax)
  80301d:	eb 0a                	jmp    803029 <merging+0x288>
  80301f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803032:	8b 45 0c             	mov    0xc(%ebp),%eax
  803035:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303c:	a1 38 50 80 00       	mov    0x805038,%eax
  803041:	48                   	dec    %eax
  803042:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803047:	e9 72 01 00 00       	jmp    8031be <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80304c:	8b 45 10             	mov    0x10(%ebp),%eax
  80304f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803056:	74 79                	je     8030d1 <merging+0x330>
  803058:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80305c:	74 73                	je     8030d1 <merging+0x330>
  80305e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803062:	74 06                	je     80306a <merging+0x2c9>
  803064:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803068:	75 17                	jne    803081 <merging+0x2e0>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 74 46 80 00       	push   $0x804674
  803072:	68 94 01 00 00       	push   $0x194
  803077:	68 01 46 80 00       	push   $0x804601
  80307c:	e8 fb 09 00 00       	call   803a7c <_panic>
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 10                	mov    (%eax),%edx
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0b                	je     80309f <merging+0x2fe>
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	75 08                	jne    8030c1 <merging+0x320>
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c6:	40                   	inc    %eax
  8030c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8030cc:	e9 ce 00 00 00       	jmp    80319f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d5:	74 65                	je     80313c <merging+0x39b>
  8030d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030db:	75 17                	jne    8030f4 <merging+0x353>
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	68 50 46 80 00       	push   $0x804650
  8030e5:	68 95 01 00 00       	push   $0x195
  8030ea:	68 01 46 80 00       	push   $0x804601
  8030ef:	e8 88 09 00 00       	call   803a7c <_panic>
  8030f4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803103:	8b 40 04             	mov    0x4(%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 0c                	je     803116 <merging+0x375>
  80310a:	a1 30 50 80 00       	mov    0x805030,%eax
  80310f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803112:	89 10                	mov    %edx,(%eax)
  803114:	eb 08                	jmp    80311e <merging+0x37d>
  803116:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803119:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803121:	a3 30 50 80 00       	mov    %eax,0x805030
  803126:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312f:	a1 38 50 80 00       	mov    0x805038,%eax
  803134:	40                   	inc    %eax
  803135:	a3 38 50 80 00       	mov    %eax,0x805038
  80313a:	eb 63                	jmp    80319f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80313c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803140:	75 17                	jne    803159 <merging+0x3b8>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 1c 46 80 00       	push   $0x80461c
  80314a:	68 98 01 00 00       	push   $0x198
  80314f:	68 01 46 80 00       	push   $0x804601
  803154:	e8 23 09 00 00       	call   803a7c <_panic>
  803159:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80315f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <merging+0x3d9>
  80316d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803172:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 08                	jmp    803182 <merging+0x3e1>
  80317a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317d:	a3 30 50 80 00       	mov    %eax,0x805030
  803182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803185:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80318a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803194:	a1 38 50 80 00       	mov    0x805038,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80319f:	83 ec 0c             	sub    $0xc,%esp
  8031a2:	ff 75 10             	pushl  0x10(%ebp)
  8031a5:	e8 f9 ed ff ff       	call   801fa3 <get_block_size>
  8031aa:	83 c4 10             	add    $0x10,%esp
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	6a 00                	push   $0x0
  8031b2:	50                   	push   %eax
  8031b3:	ff 75 10             	pushl  0x10(%ebp)
  8031b6:	e8 39 f1 ff ff       	call   8022f4 <set_block_data>
  8031bb:	83 c4 10             	add    $0x10,%esp
	}
}
  8031be:	90                   	nop
  8031bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c2:	c9                   	leave  
  8031c3:	c3                   	ret    

008031c4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031c4:	55                   	push   %ebp
  8031c5:	89 e5                	mov    %esp,%ebp
  8031c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031cf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8031d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031da:	73 1b                	jae    8031f7 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	ff 75 08             	pushl  0x8(%ebp)
  8031e7:	6a 00                	push   $0x0
  8031e9:	50                   	push   %eax
  8031ea:	e8 b2 fb ff ff       	call   802da1 <merging>
  8031ef:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031f2:	e9 8b 00 00 00       	jmp    803282 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ff:	76 18                	jbe    803219 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803201:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	ff 75 08             	pushl  0x8(%ebp)
  80320c:	50                   	push   %eax
  80320d:	6a 00                	push   $0x0
  80320f:	e8 8d fb ff ff       	call   802da1 <merging>
  803214:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803217:	eb 69                	jmp    803282 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803219:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803221:	eb 39                	jmp    80325c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	3b 45 08             	cmp    0x8(%ebp),%eax
  803229:	73 29                	jae    803254 <free_block+0x90>
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	3b 45 08             	cmp    0x8(%ebp),%eax
  803233:	76 1f                	jbe    803254 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80323d:	83 ec 04             	sub    $0x4,%esp
  803240:	ff 75 08             	pushl  0x8(%ebp)
  803243:	ff 75 f0             	pushl  -0x10(%ebp)
  803246:	ff 75 f4             	pushl  -0xc(%ebp)
  803249:	e8 53 fb ff ff       	call   802da1 <merging>
  80324e:	83 c4 10             	add    $0x10,%esp
			break;
  803251:	90                   	nop
		}
	}
}
  803252:	eb 2e                	jmp    803282 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803254:	a1 34 50 80 00       	mov    0x805034,%eax
  803259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803260:	74 07                	je     803269 <free_block+0xa5>
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	eb 05                	jmp    80326e <free_block+0xaa>
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
  80326e:	a3 34 50 80 00       	mov    %eax,0x805034
  803273:	a1 34 50 80 00       	mov    0x805034,%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	75 a7                	jne    803223 <free_block+0x5f>
  80327c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803280:	75 a1                	jne    803223 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803282:	90                   	nop
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
  803288:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80328b:	ff 75 08             	pushl  0x8(%ebp)
  80328e:	e8 10 ed ff ff       	call   801fa3 <get_block_size>
  803293:	83 c4 04             	add    $0x4,%esp
  803296:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803299:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032a0:	eb 17                	jmp    8032b9 <copy_data+0x34>
  8032a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a8:	01 c2                	add    %eax,%edx
  8032aa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	01 c8                	add    %ecx,%eax
  8032b2:	8a 00                	mov    (%eax),%al
  8032b4:	88 02                	mov    %al,(%edx)
  8032b6:	ff 45 fc             	incl   -0x4(%ebp)
  8032b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032bf:	72 e1                	jb     8032a2 <copy_data+0x1d>
}
  8032c1:	90                   	nop
  8032c2:	c9                   	leave  
  8032c3:	c3                   	ret    

008032c4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032c4:	55                   	push   %ebp
  8032c5:	89 e5                	mov    %esp,%ebp
  8032c7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ce:	75 23                	jne    8032f3 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d4:	74 13                	je     8032e9 <realloc_block_FF+0x25>
  8032d6:	83 ec 0c             	sub    $0xc,%esp
  8032d9:	ff 75 0c             	pushl  0xc(%ebp)
  8032dc:	e8 42 f0 ff ff       	call   802323 <alloc_block_FF>
  8032e1:	83 c4 10             	add    $0x10,%esp
  8032e4:	e9 e4 06 00 00       	jmp    8039cd <realloc_block_FF+0x709>
		return NULL;
  8032e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ee:	e9 da 06 00 00       	jmp    8039cd <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8032f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f7:	75 18                	jne    803311 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032f9:	83 ec 0c             	sub    $0xc,%esp
  8032fc:	ff 75 08             	pushl  0x8(%ebp)
  8032ff:	e8 c0 fe ff ff       	call   8031c4 <free_block>
  803304:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
  80330c:	e9 bc 06 00 00       	jmp    8039cd <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803311:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803315:	77 07                	ja     80331e <realloc_block_FF+0x5a>
  803317:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80331e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803321:	83 e0 01             	and    $0x1,%eax
  803324:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332a:	83 c0 08             	add    $0x8,%eax
  80332d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803330:	83 ec 0c             	sub    $0xc,%esp
  803333:	ff 75 08             	pushl  0x8(%ebp)
  803336:	e8 68 ec ff ff       	call   801fa3 <get_block_size>
  80333b:	83 c4 10             	add    $0x10,%esp
  80333e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	83 e8 08             	sub    $0x8,%eax
  803347:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	83 e8 04             	sub    $0x4,%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	83 e0 fe             	and    $0xfffffffe,%eax
  803355:	89 c2                	mov    %eax,%edx
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	01 d0                	add    %edx,%eax
  80335c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80335f:	83 ec 0c             	sub    $0xc,%esp
  803362:	ff 75 e4             	pushl  -0x1c(%ebp)
  803365:	e8 39 ec ff ff       	call   801fa3 <get_block_size>
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803370:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803373:	83 e8 08             	sub    $0x8,%eax
  803376:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80337f:	75 08                	jne    803389 <realloc_block_FF+0xc5>
	{
		 return va;
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	e9 44 06 00 00       	jmp    8039cd <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80338f:	0f 83 d5 03 00 00    	jae    80376a <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	2b 45 0c             	sub    0xc(%ebp),%eax
  80339b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80339e:	83 ec 0c             	sub    $0xc,%esp
  8033a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033a4:	e8 13 ec ff ff       	call   801fbc <is_free_block>
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	84 c0                	test   %al,%al
  8033ae:	0f 84 3b 01 00 00    	je     8034ef <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ba:	01 d0                	add    %edx,%eax
  8033bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	6a 01                	push   $0x1
  8033c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8033c7:	ff 75 08             	pushl  0x8(%ebp)
  8033ca:	e8 25 ef ff ff       	call   8022f4 <set_block_data>
  8033cf:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	83 e8 04             	sub    $0x4,%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	83 e0 fe             	and    $0xfffffffe,%eax
  8033dd:	89 c2                	mov    %eax,%edx
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	01 d0                	add    %edx,%eax
  8033e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	6a 00                	push   $0x0
  8033ec:	ff 75 cc             	pushl  -0x34(%ebp)
  8033ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8033f2:	e8 fd ee ff ff       	call   8022f4 <set_block_data>
  8033f7:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fe:	74 06                	je     803406 <realloc_block_FF+0x142>
  803400:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803404:	75 17                	jne    80341d <realloc_block_FF+0x159>
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 74 46 80 00       	push   $0x804674
  80340e:	68 f6 01 00 00       	push   $0x1f6
  803413:	68 01 46 80 00       	push   $0x804601
  803418:	e8 5f 06 00 00       	call   803a7c <_panic>
  80341d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803420:	8b 10                	mov    (%eax),%edx
  803422:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803425:	89 10                	mov    %edx,(%eax)
  803427:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	85 c0                	test   %eax,%eax
  80342e:	74 0b                	je     80343b <realloc_block_FF+0x177>
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803438:	89 50 04             	mov    %edx,0x4(%eax)
  80343b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803441:	89 10                	mov    %edx,(%eax)
  803443:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803449:	89 50 04             	mov    %edx,0x4(%eax)
  80344c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	85 c0                	test   %eax,%eax
  803453:	75 08                	jne    80345d <realloc_block_FF+0x199>
  803455:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803458:	a3 30 50 80 00       	mov    %eax,0x805030
  80345d:	a1 38 50 80 00       	mov    0x805038,%eax
  803462:	40                   	inc    %eax
  803463:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803468:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80346c:	75 17                	jne    803485 <realloc_block_FF+0x1c1>
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 e3 45 80 00       	push   $0x8045e3
  803476:	68 f7 01 00 00       	push   $0x1f7
  80347b:	68 01 46 80 00       	push   $0x804601
  803480:	e8 f7 05 00 00       	call   803a7c <_panic>
  803485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	74 10                	je     80349e <realloc_block_FF+0x1da>
  80348e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803491:	8b 00                	mov    (%eax),%eax
  803493:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803496:	8b 52 04             	mov    0x4(%edx),%edx
  803499:	89 50 04             	mov    %edx,0x4(%eax)
  80349c:	eb 0b                	jmp    8034a9 <realloc_block_FF+0x1e5>
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	8b 40 04             	mov    0x4(%eax),%eax
  8034a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ac:	8b 40 04             	mov    0x4(%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	74 0f                	je     8034c2 <realloc_block_FF+0x1fe>
  8034b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b6:	8b 40 04             	mov    0x4(%eax),%eax
  8034b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034bc:	8b 12                	mov    (%edx),%edx
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	eb 0a                	jmp    8034cc <realloc_block_FF+0x208>
  8034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034df:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e4:	48                   	dec    %eax
  8034e5:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ea:	e9 73 02 00 00       	jmp    803762 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8034ef:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034f3:	0f 86 69 02 00 00    	jbe    803762 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034f9:	83 ec 04             	sub    $0x4,%esp
  8034fc:	6a 01                	push   $0x1
  8034fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803501:	ff 75 08             	pushl  0x8(%ebp)
  803504:	e8 eb ed ff ff       	call   8022f4 <set_block_data>
  803509:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	83 e8 04             	sub    $0x4,%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	83 e0 fe             	and    $0xfffffffe,%eax
  803517:	89 c2                	mov    %eax,%edx
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	01 d0                	add    %edx,%eax
  80351e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803521:	a1 38 50 80 00       	mov    0x805038,%eax
  803526:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803529:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80352d:	75 68                	jne    803597 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80352f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803533:	75 17                	jne    80354c <realloc_block_FF+0x288>
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	68 1c 46 80 00       	push   $0x80461c
  80353d:	68 06 02 00 00       	push   $0x206
  803542:	68 01 46 80 00       	push   $0x804601
  803547:	e8 30 05 00 00       	call   803a7c <_panic>
  80354c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803555:	89 10                	mov    %edx,(%eax)
  803557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	74 0d                	je     80356d <realloc_block_FF+0x2a9>
  803560:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803565:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803568:	89 50 04             	mov    %edx,0x4(%eax)
  80356b:	eb 08                	jmp    803575 <realloc_block_FF+0x2b1>
  80356d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803570:	a3 30 50 80 00       	mov    %eax,0x805030
  803575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803578:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 38 50 80 00       	mov    0x805038,%eax
  80358c:	40                   	inc    %eax
  80358d:	a3 38 50 80 00       	mov    %eax,0x805038
  803592:	e9 b0 01 00 00       	jmp    803747 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803597:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80359f:	76 68                	jbe    803609 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a5:	75 17                	jne    8035be <realloc_block_FF+0x2fa>
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	68 1c 46 80 00       	push   $0x80461c
  8035af:	68 0b 02 00 00       	push   $0x20b
  8035b4:	68 01 46 80 00       	push   $0x804601
  8035b9:	e8 be 04 00 00       	call   803a7c <_panic>
  8035be:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c7:	89 10                	mov    %edx,(%eax)
  8035c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 0d                	je     8035df <realloc_block_FF+0x31b>
  8035d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035da:	89 50 04             	mov    %edx,0x4(%eax)
  8035dd:	eb 08                	jmp    8035e7 <realloc_block_FF+0x323>
  8035df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fe:	40                   	inc    %eax
  8035ff:	a3 38 50 80 00       	mov    %eax,0x805038
  803604:	e9 3e 01 00 00       	jmp    803747 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803609:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803611:	73 68                	jae    80367b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803613:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803617:	75 17                	jne    803630 <realloc_block_FF+0x36c>
  803619:	83 ec 04             	sub    $0x4,%esp
  80361c:	68 50 46 80 00       	push   $0x804650
  803621:	68 10 02 00 00       	push   $0x210
  803626:	68 01 46 80 00       	push   $0x804601
  80362b:	e8 4c 04 00 00       	call   803a7c <_panic>
  803630:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803639:	89 50 04             	mov    %edx,0x4(%eax)
  80363c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80363f:	8b 40 04             	mov    0x4(%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	74 0c                	je     803652 <realloc_block_FF+0x38e>
  803646:	a1 30 50 80 00       	mov    0x805030,%eax
  80364b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	eb 08                	jmp    80365a <realloc_block_FF+0x396>
  803652:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803655:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80365a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365d:	a3 30 50 80 00       	mov    %eax,0x805030
  803662:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366b:	a1 38 50 80 00       	mov    0x805038,%eax
  803670:	40                   	inc    %eax
  803671:	a3 38 50 80 00       	mov    %eax,0x805038
  803676:	e9 cc 00 00 00       	jmp    803747 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80367b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803682:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368a:	e9 8a 00 00 00       	jmp    803719 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803695:	73 7a                	jae    803711 <realloc_block_FF+0x44d>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80369f:	73 70                	jae    803711 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a5:	74 06                	je     8036ad <realloc_block_FF+0x3e9>
  8036a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ab:	75 17                	jne    8036c4 <realloc_block_FF+0x400>
  8036ad:	83 ec 04             	sub    $0x4,%esp
  8036b0:	68 74 46 80 00       	push   $0x804674
  8036b5:	68 1a 02 00 00       	push   $0x21a
  8036ba:	68 01 46 80 00       	push   $0x804601
  8036bf:	e8 b8 03 00 00       	call   803a7c <_panic>
  8036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c7:	8b 10                	mov    (%eax),%edx
  8036c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cc:	89 10                	mov    %edx,(%eax)
  8036ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d1:	8b 00                	mov    (%eax),%eax
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	74 0b                	je     8036e2 <realloc_block_FF+0x41e>
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 00                	mov    (%eax),%eax
  8036dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036df:	89 50 04             	mov    %edx,0x4(%eax)
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e8:	89 10                	mov    %edx,(%eax)
  8036ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	85 c0                	test   %eax,%eax
  8036fa:	75 08                	jne    803704 <realloc_block_FF+0x440>
  8036fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ff:	a3 30 50 80 00       	mov    %eax,0x805030
  803704:	a1 38 50 80 00       	mov    0x805038,%eax
  803709:	40                   	inc    %eax
  80370a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80370f:	eb 36                	jmp    803747 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803711:	a1 34 50 80 00       	mov    0x805034,%eax
  803716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803719:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371d:	74 07                	je     803726 <realloc_block_FF+0x462>
  80371f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	eb 05                	jmp    80372b <realloc_block_FF+0x467>
  803726:	b8 00 00 00 00       	mov    $0x0,%eax
  80372b:	a3 34 50 80 00       	mov    %eax,0x805034
  803730:	a1 34 50 80 00       	mov    0x805034,%eax
  803735:	85 c0                	test   %eax,%eax
  803737:	0f 85 52 ff ff ff    	jne    80368f <realloc_block_FF+0x3cb>
  80373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803741:	0f 85 48 ff ff ff    	jne    80368f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	6a 00                	push   $0x0
  80374c:	ff 75 d8             	pushl  -0x28(%ebp)
  80374f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803752:	e8 9d eb ff ff       	call   8022f4 <set_block_data>
  803757:	83 c4 10             	add    $0x10,%esp
				return va;
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	e9 6b 02 00 00       	jmp    8039cd <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	e9 63 02 00 00       	jmp    8039cd <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80376a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803770:	0f 86 4d 02 00 00    	jbe    8039c3 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803776:	83 ec 0c             	sub    $0xc,%esp
  803779:	ff 75 e4             	pushl  -0x1c(%ebp)
  80377c:	e8 3b e8 ff ff       	call   801fbc <is_free_block>
  803781:	83 c4 10             	add    $0x10,%esp
  803784:	84 c0                	test   %al,%al
  803786:	0f 84 37 02 00 00    	je     8039c3 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80378c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803792:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803795:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803798:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80379b:	76 38                	jbe    8037d5 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80379d:	83 ec 0c             	sub    $0xc,%esp
  8037a0:	ff 75 0c             	pushl  0xc(%ebp)
  8037a3:	e8 7b eb ff ff       	call   802323 <alloc_block_FF>
  8037a8:	83 c4 10             	add    $0x10,%esp
  8037ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037ae:	83 ec 08             	sub    $0x8,%esp
  8037b1:	ff 75 c0             	pushl  -0x40(%ebp)
  8037b4:	ff 75 08             	pushl  0x8(%ebp)
  8037b7:	e8 c9 fa ff ff       	call   803285 <copy_data>
  8037bc:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8037bf:	83 ec 0c             	sub    $0xc,%esp
  8037c2:	ff 75 08             	pushl  0x8(%ebp)
  8037c5:	e8 fa f9 ff ff       	call   8031c4 <free_block>
  8037ca:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037d0:	e9 f8 01 00 00       	jmp    8039cd <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037db:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037de:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037e2:	0f 87 a0 00 00 00    	ja     803888 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ec:	75 17                	jne    803805 <realloc_block_FF+0x541>
  8037ee:	83 ec 04             	sub    $0x4,%esp
  8037f1:	68 e3 45 80 00       	push   $0x8045e3
  8037f6:	68 38 02 00 00       	push   $0x238
  8037fb:	68 01 46 80 00       	push   $0x804601
  803800:	e8 77 02 00 00       	call   803a7c <_panic>
  803805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	85 c0                	test   %eax,%eax
  80380c:	74 10                	je     80381e <realloc_block_FF+0x55a>
  80380e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803816:	8b 52 04             	mov    0x4(%edx),%edx
  803819:	89 50 04             	mov    %edx,0x4(%eax)
  80381c:	eb 0b                	jmp    803829 <realloc_block_FF+0x565>
  80381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803821:	8b 40 04             	mov    0x4(%eax),%eax
  803824:	a3 30 50 80 00       	mov    %eax,0x805030
  803829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382c:	8b 40 04             	mov    0x4(%eax),%eax
  80382f:	85 c0                	test   %eax,%eax
  803831:	74 0f                	je     803842 <realloc_block_FF+0x57e>
  803833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383c:	8b 12                	mov    (%edx),%edx
  80383e:	89 10                	mov    %edx,(%eax)
  803840:	eb 0a                	jmp    80384c <realloc_block_FF+0x588>
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	8b 00                	mov    (%eax),%eax
  803847:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385f:	a1 38 50 80 00       	mov    0x805038,%eax
  803864:	48                   	dec    %eax
  803865:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80386a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80386d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803870:	01 d0                	add    %edx,%eax
  803872:	83 ec 04             	sub    $0x4,%esp
  803875:	6a 01                	push   $0x1
  803877:	50                   	push   %eax
  803878:	ff 75 08             	pushl  0x8(%ebp)
  80387b:	e8 74 ea ff ff       	call   8022f4 <set_block_data>
  803880:	83 c4 10             	add    $0x10,%esp
  803883:	e9 36 01 00 00       	jmp    8039be <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80388e:	01 d0                	add    %edx,%eax
  803890:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803893:	83 ec 04             	sub    $0x4,%esp
  803896:	6a 01                	push   $0x1
  803898:	ff 75 f0             	pushl  -0x10(%ebp)
  80389b:	ff 75 08             	pushl  0x8(%ebp)
  80389e:	e8 51 ea ff ff       	call   8022f4 <set_block_data>
  8038a3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	83 e8 04             	sub    $0x4,%eax
  8038ac:	8b 00                	mov    (%eax),%eax
  8038ae:	83 e0 fe             	and    $0xfffffffe,%eax
  8038b1:	89 c2                	mov    %eax,%edx
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	01 d0                	add    %edx,%eax
  8038b8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038bf:	74 06                	je     8038c7 <realloc_block_FF+0x603>
  8038c1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038c5:	75 17                	jne    8038de <realloc_block_FF+0x61a>
  8038c7:	83 ec 04             	sub    $0x4,%esp
  8038ca:	68 74 46 80 00       	push   $0x804674
  8038cf:	68 44 02 00 00       	push   $0x244
  8038d4:	68 01 46 80 00       	push   $0x804601
  8038d9:	e8 9e 01 00 00       	call   803a7c <_panic>
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	8b 10                	mov    (%eax),%edx
  8038e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e6:	89 10                	mov    %edx,(%eax)
  8038e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	74 0b                	je     8038fc <realloc_block_FF+0x638>
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 00                	mov    (%eax),%eax
  8038f6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ff:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803902:	89 10                	mov    %edx,(%eax)
  803904:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390a:	89 50 04             	mov    %edx,0x4(%eax)
  80390d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803910:	8b 00                	mov    (%eax),%eax
  803912:	85 c0                	test   %eax,%eax
  803914:	75 08                	jne    80391e <realloc_block_FF+0x65a>
  803916:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803919:	a3 30 50 80 00       	mov    %eax,0x805030
  80391e:	a1 38 50 80 00       	mov    0x805038,%eax
  803923:	40                   	inc    %eax
  803924:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803929:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392d:	75 17                	jne    803946 <realloc_block_FF+0x682>
  80392f:	83 ec 04             	sub    $0x4,%esp
  803932:	68 e3 45 80 00       	push   $0x8045e3
  803937:	68 45 02 00 00       	push   $0x245
  80393c:	68 01 46 80 00       	push   $0x804601
  803941:	e8 36 01 00 00       	call   803a7c <_panic>
  803946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	74 10                	je     80395f <realloc_block_FF+0x69b>
  80394f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803957:	8b 52 04             	mov    0x4(%edx),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	eb 0b                	jmp    80396a <realloc_block_FF+0x6a6>
  80395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803962:	8b 40 04             	mov    0x4(%eax),%eax
  803965:	a3 30 50 80 00       	mov    %eax,0x805030
  80396a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396d:	8b 40 04             	mov    0x4(%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0f                	je     803983 <realloc_block_FF+0x6bf>
  803974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803977:	8b 40 04             	mov    0x4(%eax),%eax
  80397a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80397d:	8b 12                	mov    (%edx),%edx
  80397f:	89 10                	mov    %edx,(%eax)
  803981:	eb 0a                	jmp    80398d <realloc_block_FF+0x6c9>
  803983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a5:	48                   	dec    %eax
  8039a6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ab:	83 ec 04             	sub    $0x4,%esp
  8039ae:	6a 00                	push   $0x0
  8039b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8039b3:	ff 75 b8             	pushl  -0x48(%ebp)
  8039b6:	e8 39 e9 ff ff       	call   8022f4 <set_block_data>
  8039bb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	eb 0a                	jmp    8039cd <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039c3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
  8039d2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 e0 46 80 00       	push   $0x8046e0
  8039dd:	68 58 02 00 00       	push   $0x258
  8039e2:	68 01 46 80 00       	push   $0x804601
  8039e7:	e8 90 00 00 00       	call   803a7c <_panic>

008039ec <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
  8039ef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039f2:	83 ec 04             	sub    $0x4,%esp
  8039f5:	68 08 47 80 00       	push   $0x804708
  8039fa:	68 61 02 00 00       	push   $0x261
  8039ff:	68 01 46 80 00       	push   $0x804601
  803a04:	e8 73 00 00 00       	call   803a7c <_panic>

00803a09 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
  803a0c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803a0f:	83 ec 04             	sub    $0x4,%esp
  803a12:	68 30 47 80 00       	push   $0x804730
  803a17:	6a 09                	push   $0x9
  803a19:	68 58 47 80 00       	push   $0x804758
  803a1e:	e8 59 00 00 00       	call   803a7c <_panic>

00803a23 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803a23:	55                   	push   %ebp
  803a24:	89 e5                	mov    %esp,%ebp
  803a26:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803a29:	83 ec 04             	sub    $0x4,%esp
  803a2c:	68 68 47 80 00       	push   $0x804768
  803a31:	6a 10                	push   $0x10
  803a33:	68 58 47 80 00       	push   $0x804758
  803a38:	e8 3f 00 00 00       	call   803a7c <_panic>

00803a3d <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a3d:	55                   	push   %ebp
  803a3e:	89 e5                	mov    %esp,%ebp
  803a40:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a43:	83 ec 04             	sub    $0x4,%esp
  803a46:	68 90 47 80 00       	push   $0x804790
  803a4b:	6a 18                	push   $0x18
  803a4d:	68 58 47 80 00       	push   $0x804758
  803a52:	e8 25 00 00 00       	call   803a7c <_panic>

00803a57 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a57:	55                   	push   %ebp
  803a58:	89 e5                	mov    %esp,%ebp
  803a5a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803a5d:	83 ec 04             	sub    $0x4,%esp
  803a60:	68 b8 47 80 00       	push   $0x8047b8
  803a65:	6a 20                	push   $0x20
  803a67:	68 58 47 80 00       	push   $0x804758
  803a6c:	e8 0b 00 00 00       	call   803a7c <_panic>

00803a71 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803a71:	55                   	push   %ebp
  803a72:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803a74:	8b 45 08             	mov    0x8(%ebp),%eax
  803a77:	8b 40 10             	mov    0x10(%eax),%eax
}
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    

00803a7c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a7c:	55                   	push   %ebp
  803a7d:	89 e5                	mov    %esp,%ebp
  803a7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a82:	8d 45 10             	lea    0x10(%ebp),%eax
  803a85:	83 c0 04             	add    $0x4,%eax
  803a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a8b:	a1 60 50 98 00       	mov    0x985060,%eax
  803a90:	85 c0                	test   %eax,%eax
  803a92:	74 16                	je     803aaa <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a94:	a1 60 50 98 00       	mov    0x985060,%eax
  803a99:	83 ec 08             	sub    $0x8,%esp
  803a9c:	50                   	push   %eax
  803a9d:	68 e0 47 80 00       	push   $0x8047e0
  803aa2:	e8 06 cc ff ff       	call   8006ad <cprintf>
  803aa7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803aaa:	a1 00 50 80 00       	mov    0x805000,%eax
  803aaf:	ff 75 0c             	pushl  0xc(%ebp)
  803ab2:	ff 75 08             	pushl  0x8(%ebp)
  803ab5:	50                   	push   %eax
  803ab6:	68 e5 47 80 00       	push   $0x8047e5
  803abb:	e8 ed cb ff ff       	call   8006ad <cprintf>
  803ac0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ac6:	83 ec 08             	sub    $0x8,%esp
  803ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  803acc:	50                   	push   %eax
  803acd:	e8 70 cb ff ff       	call   800642 <vcprintf>
  803ad2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803ad5:	83 ec 08             	sub    $0x8,%esp
  803ad8:	6a 00                	push   $0x0
  803ada:	68 01 48 80 00       	push   $0x804801
  803adf:	e8 5e cb ff ff       	call   800642 <vcprintf>
  803ae4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ae7:	e8 df ca ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803aec:	eb fe                	jmp    803aec <_panic+0x70>

00803aee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803aee:	55                   	push   %ebp
  803aef:	89 e5                	mov    %esp,%ebp
  803af1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803af4:	a1 20 50 80 00       	mov    0x805020,%eax
  803af9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b02:	39 c2                	cmp    %eax,%edx
  803b04:	74 14                	je     803b1a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b06:	83 ec 04             	sub    $0x4,%esp
  803b09:	68 04 48 80 00       	push   $0x804804
  803b0e:	6a 26                	push   $0x26
  803b10:	68 50 48 80 00       	push   $0x804850
  803b15:	e8 62 ff ff ff       	call   803a7c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b28:	e9 c5 00 00 00       	jmp    803bf2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	01 d0                	add    %edx,%eax
  803b3c:	8b 00                	mov    (%eax),%eax
  803b3e:	85 c0                	test   %eax,%eax
  803b40:	75 08                	jne    803b4a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b42:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b45:	e9 a5 00 00 00       	jmp    803bef <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b4a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b51:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b58:	eb 69                	jmp    803bc3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b5a:	a1 20 50 80 00       	mov    0x805020,%eax
  803b5f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b68:	89 d0                	mov    %edx,%eax
  803b6a:	01 c0                	add    %eax,%eax
  803b6c:	01 d0                	add    %edx,%eax
  803b6e:	c1 e0 03             	shl    $0x3,%eax
  803b71:	01 c8                	add    %ecx,%eax
  803b73:	8a 40 04             	mov    0x4(%eax),%al
  803b76:	84 c0                	test   %al,%al
  803b78:	75 46                	jne    803bc0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b7a:	a1 20 50 80 00       	mov    0x805020,%eax
  803b7f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b88:	89 d0                	mov    %edx,%eax
  803b8a:	01 c0                	add    %eax,%eax
  803b8c:	01 d0                	add    %edx,%eax
  803b8e:	c1 e0 03             	shl    $0x3,%eax
  803b91:	01 c8                	add    %ecx,%eax
  803b93:	8b 00                	mov    (%eax),%eax
  803b95:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ba0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803bac:	8b 45 08             	mov    0x8(%ebp),%eax
  803baf:	01 c8                	add    %ecx,%eax
  803bb1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bb3:	39 c2                	cmp    %eax,%edx
  803bb5:	75 09                	jne    803bc0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bb7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803bbe:	eb 15                	jmp    803bd5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bc0:	ff 45 e8             	incl   -0x18(%ebp)
  803bc3:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd1:	39 c2                	cmp    %eax,%edx
  803bd3:	77 85                	ja     803b5a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803bd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bd9:	75 14                	jne    803bef <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803bdb:	83 ec 04             	sub    $0x4,%esp
  803bde:	68 5c 48 80 00       	push   $0x80485c
  803be3:	6a 3a                	push   $0x3a
  803be5:	68 50 48 80 00       	push   $0x804850
  803bea:	e8 8d fe ff ff       	call   803a7c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803bef:	ff 45 f0             	incl   -0x10(%ebp)
  803bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bf8:	0f 8c 2f ff ff ff    	jl     803b2d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bfe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c0c:	eb 26                	jmp    803c34 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c0e:	a1 20 50 80 00       	mov    0x805020,%eax
  803c13:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c1c:	89 d0                	mov    %edx,%eax
  803c1e:	01 c0                	add    %eax,%eax
  803c20:	01 d0                	add    %edx,%eax
  803c22:	c1 e0 03             	shl    $0x3,%eax
  803c25:	01 c8                	add    %ecx,%eax
  803c27:	8a 40 04             	mov    0x4(%eax),%al
  803c2a:	3c 01                	cmp    $0x1,%al
  803c2c:	75 03                	jne    803c31 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c2e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c31:	ff 45 e0             	incl   -0x20(%ebp)
  803c34:	a1 20 50 80 00       	mov    0x805020,%eax
  803c39:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c42:	39 c2                	cmp    %eax,%edx
  803c44:	77 c8                	ja     803c0e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c49:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c4c:	74 14                	je     803c62 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c4e:	83 ec 04             	sub    $0x4,%esp
  803c51:	68 b0 48 80 00       	push   $0x8048b0
  803c56:	6a 44                	push   $0x44
  803c58:	68 50 48 80 00       	push   $0x804850
  803c5d:	e8 1a fe ff ff       	call   803a7c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c62:	90                   	nop
  803c63:	c9                   	leave  
  803c64:	c3                   	ret    
  803c65:	66 90                	xchg   %ax,%ax
  803c67:	90                   	nop

00803c68 <__udivdi3>:
  803c68:	55                   	push   %ebp
  803c69:	57                   	push   %edi
  803c6a:	56                   	push   %esi
  803c6b:	53                   	push   %ebx
  803c6c:	83 ec 1c             	sub    $0x1c,%esp
  803c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c7f:	89 ca                	mov    %ecx,%edx
  803c81:	89 f8                	mov    %edi,%eax
  803c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c87:	85 f6                	test   %esi,%esi
  803c89:	75 2d                	jne    803cb8 <__udivdi3+0x50>
  803c8b:	39 cf                	cmp    %ecx,%edi
  803c8d:	77 65                	ja     803cf4 <__udivdi3+0x8c>
  803c8f:	89 fd                	mov    %edi,%ebp
  803c91:	85 ff                	test   %edi,%edi
  803c93:	75 0b                	jne    803ca0 <__udivdi3+0x38>
  803c95:	b8 01 00 00 00       	mov    $0x1,%eax
  803c9a:	31 d2                	xor    %edx,%edx
  803c9c:	f7 f7                	div    %edi
  803c9e:	89 c5                	mov    %eax,%ebp
  803ca0:	31 d2                	xor    %edx,%edx
  803ca2:	89 c8                	mov    %ecx,%eax
  803ca4:	f7 f5                	div    %ebp
  803ca6:	89 c1                	mov    %eax,%ecx
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	f7 f5                	div    %ebp
  803cac:	89 cf                	mov    %ecx,%edi
  803cae:	89 fa                	mov    %edi,%edx
  803cb0:	83 c4 1c             	add    $0x1c,%esp
  803cb3:	5b                   	pop    %ebx
  803cb4:	5e                   	pop    %esi
  803cb5:	5f                   	pop    %edi
  803cb6:	5d                   	pop    %ebp
  803cb7:	c3                   	ret    
  803cb8:	39 ce                	cmp    %ecx,%esi
  803cba:	77 28                	ja     803ce4 <__udivdi3+0x7c>
  803cbc:	0f bd fe             	bsr    %esi,%edi
  803cbf:	83 f7 1f             	xor    $0x1f,%edi
  803cc2:	75 40                	jne    803d04 <__udivdi3+0x9c>
  803cc4:	39 ce                	cmp    %ecx,%esi
  803cc6:	72 0a                	jb     803cd2 <__udivdi3+0x6a>
  803cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ccc:	0f 87 9e 00 00 00    	ja     803d70 <__udivdi3+0x108>
  803cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cd7:	89 fa                	mov    %edi,%edx
  803cd9:	83 c4 1c             	add    $0x1c,%esp
  803cdc:	5b                   	pop    %ebx
  803cdd:	5e                   	pop    %esi
  803cde:	5f                   	pop    %edi
  803cdf:	5d                   	pop    %ebp
  803ce0:	c3                   	ret    
  803ce1:	8d 76 00             	lea    0x0(%esi),%esi
  803ce4:	31 ff                	xor    %edi,%edi
  803ce6:	31 c0                	xor    %eax,%eax
  803ce8:	89 fa                	mov    %edi,%edx
  803cea:	83 c4 1c             	add    $0x1c,%esp
  803ced:	5b                   	pop    %ebx
  803cee:	5e                   	pop    %esi
  803cef:	5f                   	pop    %edi
  803cf0:	5d                   	pop    %ebp
  803cf1:	c3                   	ret    
  803cf2:	66 90                	xchg   %ax,%ax
  803cf4:	89 d8                	mov    %ebx,%eax
  803cf6:	f7 f7                	div    %edi
  803cf8:	31 ff                	xor    %edi,%edi
  803cfa:	89 fa                	mov    %edi,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d09:	89 eb                	mov    %ebp,%ebx
  803d0b:	29 fb                	sub    %edi,%ebx
  803d0d:	89 f9                	mov    %edi,%ecx
  803d0f:	d3 e6                	shl    %cl,%esi
  803d11:	89 c5                	mov    %eax,%ebp
  803d13:	88 d9                	mov    %bl,%cl
  803d15:	d3 ed                	shr    %cl,%ebp
  803d17:	89 e9                	mov    %ebp,%ecx
  803d19:	09 f1                	or     %esi,%ecx
  803d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d1f:	89 f9                	mov    %edi,%ecx
  803d21:	d3 e0                	shl    %cl,%eax
  803d23:	89 c5                	mov    %eax,%ebp
  803d25:	89 d6                	mov    %edx,%esi
  803d27:	88 d9                	mov    %bl,%cl
  803d29:	d3 ee                	shr    %cl,%esi
  803d2b:	89 f9                	mov    %edi,%ecx
  803d2d:	d3 e2                	shl    %cl,%edx
  803d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d33:	88 d9                	mov    %bl,%cl
  803d35:	d3 e8                	shr    %cl,%eax
  803d37:	09 c2                	or     %eax,%edx
  803d39:	89 d0                	mov    %edx,%eax
  803d3b:	89 f2                	mov    %esi,%edx
  803d3d:	f7 74 24 0c          	divl   0xc(%esp)
  803d41:	89 d6                	mov    %edx,%esi
  803d43:	89 c3                	mov    %eax,%ebx
  803d45:	f7 e5                	mul    %ebp
  803d47:	39 d6                	cmp    %edx,%esi
  803d49:	72 19                	jb     803d64 <__udivdi3+0xfc>
  803d4b:	74 0b                	je     803d58 <__udivdi3+0xf0>
  803d4d:	89 d8                	mov    %ebx,%eax
  803d4f:	31 ff                	xor    %edi,%edi
  803d51:	e9 58 ff ff ff       	jmp    803cae <__udivdi3+0x46>
  803d56:	66 90                	xchg   %ax,%ax
  803d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d5c:	89 f9                	mov    %edi,%ecx
  803d5e:	d3 e2                	shl    %cl,%edx
  803d60:	39 c2                	cmp    %eax,%edx
  803d62:	73 e9                	jae    803d4d <__udivdi3+0xe5>
  803d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d67:	31 ff                	xor    %edi,%edi
  803d69:	e9 40 ff ff ff       	jmp    803cae <__udivdi3+0x46>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	31 c0                	xor    %eax,%eax
  803d72:	e9 37 ff ff ff       	jmp    803cae <__udivdi3+0x46>
  803d77:	90                   	nop

00803d78 <__umoddi3>:
  803d78:	55                   	push   %ebp
  803d79:	57                   	push   %edi
  803d7a:	56                   	push   %esi
  803d7b:	53                   	push   %ebx
  803d7c:	83 ec 1c             	sub    $0x1c,%esp
  803d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d97:	89 f3                	mov    %esi,%ebx
  803d99:	89 fa                	mov    %edi,%edx
  803d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d9f:	89 34 24             	mov    %esi,(%esp)
  803da2:	85 c0                	test   %eax,%eax
  803da4:	75 1a                	jne    803dc0 <__umoddi3+0x48>
  803da6:	39 f7                	cmp    %esi,%edi
  803da8:	0f 86 a2 00 00 00    	jbe    803e50 <__umoddi3+0xd8>
  803dae:	89 c8                	mov    %ecx,%eax
  803db0:	89 f2                	mov    %esi,%edx
  803db2:	f7 f7                	div    %edi
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	31 d2                	xor    %edx,%edx
  803db8:	83 c4 1c             	add    $0x1c,%esp
  803dbb:	5b                   	pop    %ebx
  803dbc:	5e                   	pop    %esi
  803dbd:	5f                   	pop    %edi
  803dbe:	5d                   	pop    %ebp
  803dbf:	c3                   	ret    
  803dc0:	39 f0                	cmp    %esi,%eax
  803dc2:	0f 87 ac 00 00 00    	ja     803e74 <__umoddi3+0xfc>
  803dc8:	0f bd e8             	bsr    %eax,%ebp
  803dcb:	83 f5 1f             	xor    $0x1f,%ebp
  803dce:	0f 84 ac 00 00 00    	je     803e80 <__umoddi3+0x108>
  803dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  803dd9:	29 ef                	sub    %ebp,%edi
  803ddb:	89 fe                	mov    %edi,%esi
  803ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803de1:	89 e9                	mov    %ebp,%ecx
  803de3:	d3 e0                	shl    %cl,%eax
  803de5:	89 d7                	mov    %edx,%edi
  803de7:	89 f1                	mov    %esi,%ecx
  803de9:	d3 ef                	shr    %cl,%edi
  803deb:	09 c7                	or     %eax,%edi
  803ded:	89 e9                	mov    %ebp,%ecx
  803def:	d3 e2                	shl    %cl,%edx
  803df1:	89 14 24             	mov    %edx,(%esp)
  803df4:	89 d8                	mov    %ebx,%eax
  803df6:	d3 e0                	shl    %cl,%eax
  803df8:	89 c2                	mov    %eax,%edx
  803dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dfe:	d3 e0                	shl    %cl,%eax
  803e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e08:	89 f1                	mov    %esi,%ecx
  803e0a:	d3 e8                	shr    %cl,%eax
  803e0c:	09 d0                	or     %edx,%eax
  803e0e:	d3 eb                	shr    %cl,%ebx
  803e10:	89 da                	mov    %ebx,%edx
  803e12:	f7 f7                	div    %edi
  803e14:	89 d3                	mov    %edx,%ebx
  803e16:	f7 24 24             	mull   (%esp)
  803e19:	89 c6                	mov    %eax,%esi
  803e1b:	89 d1                	mov    %edx,%ecx
  803e1d:	39 d3                	cmp    %edx,%ebx
  803e1f:	0f 82 87 00 00 00    	jb     803eac <__umoddi3+0x134>
  803e25:	0f 84 91 00 00 00    	je     803ebc <__umoddi3+0x144>
  803e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e2f:	29 f2                	sub    %esi,%edx
  803e31:	19 cb                	sbb    %ecx,%ebx
  803e33:	89 d8                	mov    %ebx,%eax
  803e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e39:	d3 e0                	shl    %cl,%eax
  803e3b:	89 e9                	mov    %ebp,%ecx
  803e3d:	d3 ea                	shr    %cl,%edx
  803e3f:	09 d0                	or     %edx,%eax
  803e41:	89 e9                	mov    %ebp,%ecx
  803e43:	d3 eb                	shr    %cl,%ebx
  803e45:	89 da                	mov    %ebx,%edx
  803e47:	83 c4 1c             	add    $0x1c,%esp
  803e4a:	5b                   	pop    %ebx
  803e4b:	5e                   	pop    %esi
  803e4c:	5f                   	pop    %edi
  803e4d:	5d                   	pop    %ebp
  803e4e:	c3                   	ret    
  803e4f:	90                   	nop
  803e50:	89 fd                	mov    %edi,%ebp
  803e52:	85 ff                	test   %edi,%edi
  803e54:	75 0b                	jne    803e61 <__umoddi3+0xe9>
  803e56:	b8 01 00 00 00       	mov    $0x1,%eax
  803e5b:	31 d2                	xor    %edx,%edx
  803e5d:	f7 f7                	div    %edi
  803e5f:	89 c5                	mov    %eax,%ebp
  803e61:	89 f0                	mov    %esi,%eax
  803e63:	31 d2                	xor    %edx,%edx
  803e65:	f7 f5                	div    %ebp
  803e67:	89 c8                	mov    %ecx,%eax
  803e69:	f7 f5                	div    %ebp
  803e6b:	89 d0                	mov    %edx,%eax
  803e6d:	e9 44 ff ff ff       	jmp    803db6 <__umoddi3+0x3e>
  803e72:	66 90                	xchg   %ax,%ax
  803e74:	89 c8                	mov    %ecx,%eax
  803e76:	89 f2                	mov    %esi,%edx
  803e78:	83 c4 1c             	add    $0x1c,%esp
  803e7b:	5b                   	pop    %ebx
  803e7c:	5e                   	pop    %esi
  803e7d:	5f                   	pop    %edi
  803e7e:	5d                   	pop    %ebp
  803e7f:	c3                   	ret    
  803e80:	3b 04 24             	cmp    (%esp),%eax
  803e83:	72 06                	jb     803e8b <__umoddi3+0x113>
  803e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e89:	77 0f                	ja     803e9a <__umoddi3+0x122>
  803e8b:	89 f2                	mov    %esi,%edx
  803e8d:	29 f9                	sub    %edi,%ecx
  803e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e93:	89 14 24             	mov    %edx,(%esp)
  803e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e9e:	8b 14 24             	mov    (%esp),%edx
  803ea1:	83 c4 1c             	add    $0x1c,%esp
  803ea4:	5b                   	pop    %ebx
  803ea5:	5e                   	pop    %esi
  803ea6:	5f                   	pop    %edi
  803ea7:	5d                   	pop    %ebp
  803ea8:	c3                   	ret    
  803ea9:	8d 76 00             	lea    0x0(%esi),%esi
  803eac:	2b 04 24             	sub    (%esp),%eax
  803eaf:	19 fa                	sbb    %edi,%edx
  803eb1:	89 d1                	mov    %edx,%ecx
  803eb3:	89 c6                	mov    %eax,%esi
  803eb5:	e9 71 ff ff ff       	jmp    803e2b <__umoddi3+0xb3>
  803eba:	66 90                	xchg   %ax,%ax
  803ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ec0:	72 ea                	jb     803eac <__umoddi3+0x134>
  803ec2:	89 d9                	mov    %ebx,%ecx
  803ec4:	e9 62 ff ff ff       	jmp    803e2b <__umoddi3+0xb3>

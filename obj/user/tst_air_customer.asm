
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
  800044:	e8 70 1b 00 00       	call   801bb9 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 89 3e 80 00       	mov    $0x803e89,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 93 3e 80 00       	mov    $0x803e93,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 9f 3e 80 00       	mov    $0x803e9f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ae 3e 80 00       	mov    $0x803eae,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb bd 3e 80 00       	mov    $0x803ebd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb d2 3e 80 00       	mov    $0x803ed2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb e7 3e 80 00       	mov    $0x803ee7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb f8 3e 80 00       	mov    $0x803ef8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 09 3f 80 00       	mov    $0x803f09,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 1a 3f 80 00       	mov    $0x803f1a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 23 3f 80 00       	mov    $0x803f23,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 2d 3f 80 00       	mov    $0x803f2d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 38 3f 80 00       	mov    $0x803f38,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 44 3f 80 00       	mov    $0x803f44,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 4e 3f 80 00       	mov    $0x803f4e,%ebx
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
  8001be:	bb 58 3f 80 00       	mov    $0x803f58,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 66 3f 80 00       	mov    $0x803f66,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 75 3f 80 00       	mov    $0x803f75,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 7c 3f 80 00       	mov    $0x803f7c,%ebx
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
  800286:	e8 08 37 00 00       	call   803993 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 ec 36 00 00       	call   803993 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 d0 36 00 00       	call   803993 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 b4 36 00 00       	call   803993 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 98 36 00 00       	call   803993 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 a1 36 00 00       	call   8039ad <wait_semaphore>
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
  80032d:	e8 95 36 00 00       	call   8039c7 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 6a 36 00 00       	call   8039ad <wait_semaphore>
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
  800363:	e8 45 36 00 00       	call   8039ad <wait_semaphore>
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
  800397:	e8 2b 36 00 00       	call   8039c7 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 1a 36 00 00       	call   8039c7 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 83 3f 80 00       	mov    $0x803f83,%ebx
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
  800425:	e8 69 35 00 00       	call   803993 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 72 35 00 00       	call   8039ad <wait_semaphore>
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
  80045e:	68 40 3e 80 00       	push   $0x803e40
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 68 3e 80 00       	push   $0x803e68
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 39 35 00 00       	call   8039c7 <signal_semaphore>
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
  8004a0:	e8 fb 16 00 00       	call   801ba0 <sys_getenvindex>
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
  80050e:	e8 11 14 00 00       	call   801924 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 bc 3f 80 00       	push   $0x803fbc
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
  80053e:	68 e4 3f 80 00       	push   $0x803fe4
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
  80056f:	68 0c 40 80 00       	push   $0x80400c
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 64 40 80 00       	push   $0x804064
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 bc 3f 80 00       	push   $0x803fbc
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 91 13 00 00       	call   80193e <sys_unlock_cons>
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
  8005c0:	e8 a7 15 00 00       	call   801b6c <sys_destroy_env>
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
  8005d1:	e8 fc 15 00 00       	call   801bd2 <sys_exit_env>
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
  80061f:	e8 be 12 00 00       	call   8018e2 <sys_cputs>
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
  800696:	e8 47 12 00 00       	call   8018e2 <sys_cputs>
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
  8006e0:	e8 3f 12 00 00       	call   801924 <sys_lock_cons>
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
  800700:	e8 39 12 00 00       	call   80193e <sys_unlock_cons>
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
  80074a:	e8 89 34 00 00       	call   803bd8 <__udivdi3>
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
  80079a:	e8 49 35 00 00       	call   803ce8 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 94 42 80 00       	add    $0x804294,%eax
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
  8008f5:	8b 04 85 b8 42 80 00 	mov    0x8042b8(,%eax,4),%eax
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
  8009d6:	8b 34 9d 00 41 80 00 	mov    0x804100(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 a5 42 80 00       	push   $0x8042a5
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
  8009fb:	68 ae 42 80 00       	push   $0x8042ae
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
  800a28:	be b1 42 80 00       	mov    $0x8042b1,%esi
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
  801433:	68 28 44 80 00       	push   $0x804428
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 4a 44 80 00       	push   $0x80444a
  801442:	e8 a5 25 00 00       	call   8039ec <_panic>

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
  801453:	e8 35 0a 00 00       	call   801e8d <sys_sbrk>
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
  8014ce:	e8 3e 08 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 7e 0d 00 00       	call   802260 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 50 08 00 00       	call   801d42 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 17 12 00 00       	call   80271c <alloc_block_BF>
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
  801666:	e8 59 08 00 00       	call   801ec4 <sys_allocate_user_mem>
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
  8016ae:	e8 2d 08 00 00       	call   801ee0 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 60 1a 00 00       	call   803124 <free_block>
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
  801756:	e8 4d 07 00 00       	call   801ea8 <sys_free_user_mem>
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
  801764:	68 58 44 80 00       	push   $0x804458
  801769:	68 84 00 00 00       	push   $0x84
  80176e:	68 82 44 80 00       	push   $0x804482
  801773:	e8 74 22 00 00       	call   8039ec <_panic>
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
  8017d6:	e8 d4 02 00 00       	call   801aaf <sys_createSharedObject>
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
  8017f7:	68 8e 44 80 00       	push   $0x80448e
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
  80180c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 94 44 80 00       	push   $0x804494
  801817:	68 a4 00 00 00       	push   $0xa4
  80181c:	68 82 44 80 00       	push   $0x804482
  801821:	e8 c6 21 00 00       	call   8039ec <_panic>

00801826 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	68 b8 44 80 00       	push   $0x8044b8
  801834:	68 bc 00 00 00       	push   $0xbc
  801839:	68 82 44 80 00       	push   $0x804482
  80183e:	e8 a9 21 00 00       	call   8039ec <_panic>

00801843 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 dc 44 80 00       	push   $0x8044dc
  801851:	68 d3 00 00 00       	push   $0xd3
  801856:	68 82 44 80 00       	push   $0x804482
  80185b:	e8 8c 21 00 00       	call   8039ec <_panic>

00801860 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 02 45 80 00       	push   $0x804502
  80186e:	68 df 00 00 00       	push   $0xdf
  801873:	68 82 44 80 00       	push   $0x804482
  801878:	e8 6f 21 00 00       	call   8039ec <_panic>

0080187d <shrink>:

}
void shrink(uint32 newSize)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 02 45 80 00       	push   $0x804502
  80188b:	68 e4 00 00 00       	push   $0xe4
  801890:	68 82 44 80 00       	push   $0x804482
  801895:	e8 52 21 00 00       	call   8039ec <_panic>

0080189a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 02 45 80 00       	push   $0x804502
  8018a8:	68 e9 00 00 00       	push   $0xe9
  8018ad:	68 82 44 80 00       	push   $0x804482
  8018b2:	e8 35 21 00 00       	call   8039ec <_panic>

008018b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	57                   	push   %edi
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d2:	cd 30                	int    $0x30
  8018d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	6a 00                	push   $0x0
  801900:	e8 b2 ff ff ff       	call   8018b7 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_cgetc>:

int
sys_cgetc(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 02                	push   $0x2
  80191a:	e8 98 ff ff ff       	call   8018b7 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 03                	push   $0x3
  801933:	e8 7f ff ff ff       	call   8018b7 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 04                	push   $0x4
  80194d:	e8 65 ff ff ff       	call   8018b7 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	6a 08                	push   $0x8
  80196b:	e8 47 ff ff ff       	call   8018b7 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197a:	8b 75 18             	mov    0x18(%ebp),%esi
  80197d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801980:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	51                   	push   %ecx
  80198c:	52                   	push   %edx
  80198d:	50                   	push   %eax
  80198e:	6a 09                	push   $0x9
  801990:	e8 22 ff ff ff       	call   8018b7 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5d                   	pop    %ebp
  80199e:	c3                   	ret    

0080199f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 0a                	push   $0xa
  8019b2:	e8 00 ff ff ff       	call   8018b7 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	6a 0b                	push   $0xb
  8019cd:	e8 e5 fe ff ff       	call   8018b7 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 0c                	push   $0xc
  8019e6:	e8 cc fe ff ff       	call   8018b7 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 0d                	push   $0xd
  8019ff:	e8 b3 fe ff ff       	call   8018b7 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 0e                	push   $0xe
  801a18:	e8 9a fe ff ff       	call   8018b7 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 0f                	push   $0xf
  801a31:	e8 81 fe ff ff       	call   8018b7 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	6a 10                	push   $0x10
  801a4b:	e8 67 fe ff ff       	call   8018b7 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 11                	push   $0x11
  801a64:	e8 4e fe ff ff       	call   8018b7 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_cputc>:

void
sys_cputc(const char c)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	50                   	push   %eax
  801a88:	6a 01                	push   $0x1
  801a8a:	e8 28 fe ff ff       	call   8018b7 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 14                	push   $0x14
  801aa4:	e8 0e fe ff ff       	call   8018b7 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	51                   	push   %ecx
  801ac8:	52                   	push   %edx
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	50                   	push   %eax
  801acd:	6a 15                	push   $0x15
  801acf:	e8 e3 fd ff ff       	call   8018b7 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 16                	push   $0x16
  801aec:	e8 c6 fd ff ff       	call   8018b7 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	51                   	push   %ecx
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 17                	push   $0x17
  801b0b:	e8 a7 fd ff ff       	call   8018b7 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 18                	push   $0x18
  801b28:	e8 8a fd ff ff       	call   8018b7 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 14             	pushl  0x14(%ebp)
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	6a 19                	push   $0x19
  801b46:	e8 6c fd ff ff       	call   8018b7 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	50                   	push   %eax
  801b5f:	6a 1a                	push   $0x1a
  801b61:	e8 51 fd ff ff       	call   8018b7 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 1b                	push   $0x1b
  801b7d:	e8 35 fd ff ff       	call   8018b7 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 05                	push   $0x5
  801b96:	e8 1c fd ff ff       	call   8018b7 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 06                	push   $0x6
  801baf:	e8 03 fd ff ff       	call   8018b7 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 07                	push   $0x7
  801bc8:	e8 ea fc ff ff       	call   8018b7 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 1c                	push   $0x1c
  801be1:	e8 d1 fc ff ff       	call   8018b7 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf5:	8d 50 04             	lea    0x4(%eax),%edx
  801bf8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 1d                	push   $0x1d
  801c05:	e8 ad fc ff ff       	call   8018b7 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c16:	89 01                	mov    %eax,(%ecx)
  801c18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	c9                   	leave  
  801c1f:	c2 04 00             	ret    $0x4

00801c22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 13                	push   $0x13
  801c34:	e8 7e fc ff ff       	call   8018b7 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 1e                	push   $0x1e
  801c4e:	e8 64 fc ff ff       	call   8018b7 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 1f                	push   $0x1f
  801c73:	e8 3f fc ff ff       	call   8018b7 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <rsttst>:
void rsttst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 21                	push   $0x21
  801c8d:	e8 25 fc ff ff       	call   8018b7 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 20                	push   $0x20
  801cb8:	e8 fa fb ff ff       	call   8018b7 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <chktst>:
void chktst(uint32 n)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 22                	push   $0x22
  801cd3:	e8 df fb ff ff       	call   8018b7 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <inctst>:

void inctst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 23                	push   $0x23
  801ced:	e8 c5 fb ff ff       	call   8018b7 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <gettst>:
uint32 gettst()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 24                	push   $0x24
  801d07:	e8 ab fb ff ff       	call   8018b7 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 25                	push   $0x25
  801d23:	e8 8f fb ff ff       	call   8018b7 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 25                	push   $0x25
  801d54:	e8 5e fb ff ff       	call   8018b7 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 25                	push   $0x25
  801d85:	e8 2d fb ff ff       	call   8018b7 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 25                	push   $0x25
  801db6:	e8 fc fa ff ff       	call   8018b7 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 26                	push   $0x26
  801de5:	e8 cd fa ff ff       	call   8018b7 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	53                   	push   %ebx
  801e03:	51                   	push   %ecx
  801e04:	52                   	push   %edx
  801e05:	50                   	push   %eax
  801e06:	6a 27                	push   $0x27
  801e08:	e8 aa fa ff ff       	call   8018b7 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 28                	push   $0x28
  801e28:	e8 8a fa ff ff       	call   8018b7 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	51                   	push   %ecx
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 29                	push   $0x29
  801e48:	e8 6a fa ff ff       	call   8018b7 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 10             	pushl  0x10(%ebp)
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	6a 12                	push   $0x12
  801e64:	e8 4e fa ff ff       	call   8018b7 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6c:	90                   	nop
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 2a                	push   $0x2a
  801e82:	e8 30 fa ff ff       	call   8018b7 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	50                   	push   %eax
  801e9c:	6a 2b                	push   $0x2b
  801e9e:	e8 14 fa ff ff       	call   8018b7 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	6a 2c                	push   $0x2c
  801eb9:	e8 f9 f9 ff ff       	call   8018b7 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
	return;
  801ec1:	90                   	nop
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	6a 2d                	push   $0x2d
  801ed5:	e8 dd f9 ff ff       	call   8018b7 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
	return;
  801edd:	90                   	nop
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	83 e8 04             	sub    $0x4,%eax
  801eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef2:	8b 00                	mov    (%eax),%eax
  801ef4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	83 e8 04             	sub    $0x4,%eax
  801f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0b:	8b 00                	mov    (%eax),%eax
  801f0d:	83 e0 01             	and    $0x1,%eax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	0f 94 c0             	sete   %al
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	83 f8 02             	cmp    $0x2,%eax
  801f2a:	74 2b                	je     801f57 <alloc_block+0x40>
  801f2c:	83 f8 02             	cmp    $0x2,%eax
  801f2f:	7f 07                	jg     801f38 <alloc_block+0x21>
  801f31:	83 f8 01             	cmp    $0x1,%eax
  801f34:	74 0e                	je     801f44 <alloc_block+0x2d>
  801f36:	eb 58                	jmp    801f90 <alloc_block+0x79>
  801f38:	83 f8 03             	cmp    $0x3,%eax
  801f3b:	74 2d                	je     801f6a <alloc_block+0x53>
  801f3d:	83 f8 04             	cmp    $0x4,%eax
  801f40:	74 3b                	je     801f7d <alloc_block+0x66>
  801f42:	eb 4c                	jmp    801f90 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	e8 11 03 00 00       	call   802260 <alloc_block_FF>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f55:	eb 4a                	jmp    801fa1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 fa 19 00 00       	call   80395c <alloc_block_NF>
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f68:	eb 37                	jmp    801fa1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 a7 07 00 00       	call   80271c <alloc_block_BF>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f7b:	eb 24                	jmp    801fa1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 b7 19 00 00       	call   80393f <alloc_block_WF>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8e:	eb 11                	jmp    801fa1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	68 14 45 80 00       	push   $0x804514
  801f98:	e8 10 e7 ff ff       	call   8006ad <cprintf>
  801f9d:	83 c4 10             	add    $0x10,%esp
		break;
  801fa0:	90                   	nop
	}
	return va;
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	68 34 45 80 00       	push   $0x804534
  801fb5:	e8 f3 e6 ff ff       	call   8006ad <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 5f 45 80 00       	push   $0x80455f
  801fc5:	e8 e3 e6 ff ff       	call   8006ad <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd3:	eb 37                	jmp    80200c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdb:	e8 19 ff ff ff       	call   801ef9 <is_free_block>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	0f be d8             	movsbl %al,%ebx
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fec:	e8 ef fe ff ff       	call   801ee0 <get_block_size>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	53                   	push   %ebx
  801ff8:	50                   	push   %eax
  801ff9:	68 77 45 80 00       	push   $0x804577
  801ffe:	e8 aa e6 ff ff       	call   8006ad <cprintf>
  802003:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802006:	8b 45 10             	mov    0x10(%ebp),%eax
  802009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802010:	74 07                	je     802019 <print_blocks_list+0x73>
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 00                	mov    (%eax),%eax
  802017:	eb 05                	jmp    80201e <print_blocks_list+0x78>
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	89 45 10             	mov    %eax,0x10(%ebp)
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	75 ad                	jne    801fd5 <print_blocks_list+0x2f>
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	75 a7                	jne    801fd5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	68 34 45 80 00       	push   $0x804534
  802036:	e8 72 e6 ff ff       	call   8006ad <cprintf>
  80203b:	83 c4 10             	add    $0x10,%esp

}
  80203e:	90                   	nop
  80203f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80204a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204d:	83 e0 01             	and    $0x1,%eax
  802050:	85 c0                	test   %eax,%eax
  802052:	74 03                	je     802057 <initialize_dynamic_allocator+0x13>
  802054:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802057:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80205b:	0f 84 c7 01 00 00    	je     802228 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802061:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802068:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80206b:	8b 55 08             	mov    0x8(%ebp),%edx
  80206e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802071:	01 d0                	add    %edx,%eax
  802073:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802078:	0f 87 ad 01 00 00    	ja     80222b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	0f 89 a5 01 00 00    	jns    80222e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802089:	8b 55 08             	mov    0x8(%ebp),%edx
  80208c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208f:	01 d0                	add    %edx,%eax
  802091:	83 e8 04             	sub    $0x4,%eax
  802094:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a8:	e9 87 00 00 00       	jmp    802134 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b1:	75 14                	jne    8020c7 <initialize_dynamic_allocator+0x83>
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 8f 45 80 00       	push   $0x80458f
  8020bb:	6a 79                	push   $0x79
  8020bd:	68 ad 45 80 00       	push   $0x8045ad
  8020c2:	e8 25 19 00 00       	call   8039ec <_panic>
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	74 10                	je     8020e0 <initialize_dynamic_allocator+0x9c>
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	8b 52 04             	mov    0x4(%edx),%edx
  8020db:	89 50 04             	mov    %edx,0x4(%eax)
  8020de:	eb 0b                	jmp    8020eb <initialize_dynamic_allocator+0xa7>
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 40 04             	mov    0x4(%eax),%eax
  8020e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 40 04             	mov    0x4(%eax),%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	74 0f                	je     802104 <initialize_dynamic_allocator+0xc0>
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 40 04             	mov    0x4(%eax),%eax
  8020fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fe:	8b 12                	mov    (%edx),%edx
  802100:	89 10                	mov    %edx,(%eax)
  802102:	eb 0a                	jmp    80210e <initialize_dynamic_allocator+0xca>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802121:	a1 38 50 80 00       	mov    0x805038,%eax
  802126:	48                   	dec    %eax
  802127:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80212c:	a1 34 50 80 00       	mov    0x805034,%eax
  802131:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802138:	74 07                	je     802141 <initialize_dynamic_allocator+0xfd>
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	eb 05                	jmp    802146 <initialize_dynamic_allocator+0x102>
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
  802146:	a3 34 50 80 00       	mov    %eax,0x805034
  80214b:	a1 34 50 80 00       	mov    0x805034,%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	0f 85 55 ff ff ff    	jne    8020ad <initialize_dynamic_allocator+0x69>
  802158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215c:	0f 85 4b ff ff ff    	jne    8020ad <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802171:	a1 44 50 80 00       	mov    0x805044,%eax
  802176:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80217b:	a1 40 50 80 00       	mov    0x805040,%eax
  802180:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	83 c0 08             	add    $0x8,%eax
  80218c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	83 c0 04             	add    $0x4,%eax
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	83 ea 08             	sub    $0x8,%edx
  80219b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	01 d0                	add    %edx,%eax
  8021a5:	83 e8 08             	sub    $0x8,%eax
  8021a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ab:	83 ea 08             	sub    $0x8,%edx
  8021ae:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c7:	75 17                	jne    8021e0 <initialize_dynamic_allocator+0x19c>
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 c8 45 80 00       	push   $0x8045c8
  8021d1:	68 90 00 00 00       	push   $0x90
  8021d6:	68 ad 45 80 00       	push   $0x8045ad
  8021db:	e8 0c 18 00 00       	call   8039ec <_panic>
  8021e0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0d                	je     802201 <initialize_dynamic_allocator+0x1bd>
  8021f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	eb 08                	jmp    802209 <initialize_dynamic_allocator+0x1c5>
  802201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802204:	a3 30 50 80 00       	mov    %eax,0x805030
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221b:	a1 38 50 80 00       	mov    0x805038,%eax
  802220:	40                   	inc    %eax
  802221:	a3 38 50 80 00       	mov    %eax,0x805038
  802226:	eb 07                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802228:	90                   	nop
  802229:	eb 04                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80222b:	90                   	nop
  80222c:	eb 01                	jmp    80222f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80222e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	83 e8 04             	sub    $0x4,%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	83 e0 fe             	and    $0xfffffffe,%eax
  802250:	8d 50 f8             	lea    -0x8(%eax),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	01 c2                	add    %eax,%edx
  802258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225b:	89 02                	mov    %eax,(%edx)
}
  80225d:	90                   	nop
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	83 e0 01             	and    $0x1,%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	74 03                	je     802273 <alloc_block_FF+0x13>
  802270:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802273:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802277:	77 07                	ja     802280 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802279:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802280:	a1 24 50 80 00       	mov    0x805024,%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	75 73                	jne    8022fc <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	83 c0 10             	add    $0x10,%eax
  80228f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802292:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802299:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229f:	01 d0                	add    %edx,%eax
  8022a1:	48                   	dec    %eax
  8022a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ad:	f7 75 ec             	divl   -0x14(%ebp)
  8022b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b3:	29 d0                	sub    %edx,%eax
  8022b5:	c1 e8 0c             	shr    $0xc,%eax
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	50                   	push   %eax
  8022bc:	e8 86 f1 ff ff       	call   801447 <sbrk>
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022c7:	83 ec 0c             	sub    $0xc,%esp
  8022ca:	6a 00                	push   $0x0
  8022cc:	e8 76 f1 ff ff       	call   801447 <sbrk>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022da:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022dd:	83 ec 08             	sub    $0x8,%esp
  8022e0:	50                   	push   %eax
  8022e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022e4:	e8 5b fd ff ff       	call   802044 <initialize_dynamic_allocator>
  8022e9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	68 eb 45 80 00       	push   $0x8045eb
  8022f4:	e8 b4 e3 ff ff       	call   8006ad <cprintf>
  8022f9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802300:	75 0a                	jne    80230c <alloc_block_FF+0xac>
	        return NULL;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	e9 0e 04 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80230c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802313:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 f3 02 00 00       	jmp    802613 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802326:	83 ec 0c             	sub    $0xc,%esp
  802329:	ff 75 bc             	pushl  -0x44(%ebp)
  80232c:	e8 af fb ff ff       	call   801ee0 <get_block_size>
  802331:	83 c4 10             	add    $0x10,%esp
  802334:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	83 c0 08             	add    $0x8,%eax
  80233d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802340:	0f 87 c5 02 00 00    	ja     80260b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	83 c0 18             	add    $0x18,%eax
  80234c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80234f:	0f 87 19 02 00 00    	ja     80256e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802355:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802358:	2b 45 08             	sub    0x8(%ebp),%eax
  80235b:	83 e8 08             	sub    $0x8,%eax
  80235e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	8d 50 08             	lea    0x8(%eax),%edx
  802367:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80236a:	01 d0                	add    %edx,%eax
  80236c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	83 c0 08             	add    $0x8,%eax
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	6a 01                	push   $0x1
  80237a:	50                   	push   %eax
  80237b:	ff 75 bc             	pushl  -0x44(%ebp)
  80237e:	e8 ae fe ff ff       	call   802231 <set_block_data>
  802383:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 68                	jne    8023f8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802390:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802394:	75 17                	jne    8023ad <alloc_block_FF+0x14d>
  802396:	83 ec 04             	sub    $0x4,%esp
  802399:	68 c8 45 80 00       	push   $0x8045c8
  80239e:	68 d7 00 00 00       	push   $0xd7
  8023a3:	68 ad 45 80 00       	push   $0x8045ad
  8023a8:	e8 3f 16 00 00       	call   8039ec <_panic>
  8023ad:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b6:	89 10                	mov    %edx,(%eax)
  8023b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	74 0d                	je     8023ce <alloc_block_FF+0x16e>
  8023c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023c6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c9:	89 50 04             	mov    %edx,0x4(%eax)
  8023cc:	eb 08                	jmp    8023d6 <alloc_block_FF+0x176>
  8023ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8023d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ed:	40                   	inc    %eax
  8023ee:	a3 38 50 80 00       	mov    %eax,0x805038
  8023f3:	e9 dc 00 00 00       	jmp    8024d4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	75 65                	jne    802466 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802401:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802405:	75 17                	jne    80241e <alloc_block_FF+0x1be>
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	68 fc 45 80 00       	push   $0x8045fc
  80240f:	68 db 00 00 00       	push   $0xdb
  802414:	68 ad 45 80 00       	push   $0x8045ad
  802419:	e8 ce 15 00 00       	call   8039ec <_panic>
  80241e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802427:	89 50 04             	mov    %edx,0x4(%eax)
  80242a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 0c                	je     802440 <alloc_block_FF+0x1e0>
  802434:	a1 30 50 80 00       	mov    0x805030,%eax
  802439:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	eb 08                	jmp    802448 <alloc_block_FF+0x1e8>
  802440:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802443:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802448:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244b:	a3 30 50 80 00       	mov    %eax,0x805030
  802450:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802453:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802459:	a1 38 50 80 00       	mov    0x805038,%eax
  80245e:	40                   	inc    %eax
  80245f:	a3 38 50 80 00       	mov    %eax,0x805038
  802464:	eb 6e                	jmp    8024d4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	74 06                	je     802472 <alloc_block_FF+0x212>
  80246c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802470:	75 17                	jne    802489 <alloc_block_FF+0x229>
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 20 46 80 00       	push   $0x804620
  80247a:	68 df 00 00 00       	push   $0xdf
  80247f:	68 ad 45 80 00       	push   $0x8045ad
  802484:	e8 63 15 00 00       	call   8039ec <_panic>
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 10                	mov    (%eax),%edx
  80248e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802491:	89 10                	mov    %edx,(%eax)
  802493:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 0b                	je     8024a7 <alloc_block_FF+0x247>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ad:	89 10                	mov    %edx,(%eax)
  8024af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	75 08                	jne    8024c9 <alloc_block_FF+0x269>
  8024c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8024ce:	40                   	inc    %eax
  8024cf:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	75 17                	jne    8024f1 <alloc_block_FF+0x291>
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	68 8f 45 80 00       	push   $0x80458f
  8024e2:	68 e1 00 00 00       	push   $0xe1
  8024e7:	68 ad 45 80 00       	push   $0x8045ad
  8024ec:	e8 fb 14 00 00       	call   8039ec <_panic>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 10                	je     80250a <alloc_block_FF+0x2aa>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802502:	8b 52 04             	mov    0x4(%edx),%edx
  802505:	89 50 04             	mov    %edx,0x4(%eax)
  802508:	eb 0b                	jmp    802515 <alloc_block_FF+0x2b5>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	a3 30 50 80 00       	mov    %eax,0x805030
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	85 c0                	test   %eax,%eax
  80251d:	74 0f                	je     80252e <alloc_block_FF+0x2ce>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 04             	mov    0x4(%eax),%eax
  802525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802528:	8b 12                	mov    (%edx),%edx
  80252a:	89 10                	mov    %edx,(%eax)
  80252c:	eb 0a                	jmp    802538 <alloc_block_FF+0x2d8>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254b:	a1 38 50 80 00       	mov    0x805038,%eax
  802550:	48                   	dec    %eax
  802551:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	6a 00                	push   $0x0
  80255b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80255e:	ff 75 b0             	pushl  -0x50(%ebp)
  802561:	e8 cb fc ff ff       	call   802231 <set_block_data>
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	e9 95 00 00 00       	jmp    802603 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	6a 01                	push   $0x1
  802573:	ff 75 b8             	pushl  -0x48(%ebp)
  802576:	ff 75 bc             	pushl  -0x44(%ebp)
  802579:	e8 b3 fc ff ff       	call   802231 <set_block_data>
  80257e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	75 17                	jne    80259e <alloc_block_FF+0x33e>
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	68 8f 45 80 00       	push   $0x80458f
  80258f:	68 e8 00 00 00       	push   $0xe8
  802594:	68 ad 45 80 00       	push   $0x8045ad
  802599:	e8 4e 14 00 00       	call   8039ec <_panic>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 10                	je     8025b7 <alloc_block_FF+0x357>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025af:	8b 52 04             	mov    0x4(%edx),%edx
  8025b2:	89 50 04             	mov    %edx,0x4(%eax)
  8025b5:	eb 0b                	jmp    8025c2 <alloc_block_FF+0x362>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 0f                	je     8025db <alloc_block_FF+0x37b>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	8b 12                	mov    (%edx),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 0a                	jmp    8025e5 <alloc_block_FF+0x385>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fd:	48                   	dec    %eax
  8025fe:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802603:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802606:	e9 0f 01 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80260b:	a1 34 50 80 00       	mov    0x805034,%eax
  802610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	74 07                	je     802620 <alloc_block_FF+0x3c0>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	eb 05                	jmp    802625 <alloc_block_FF+0x3c5>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	a3 34 50 80 00       	mov    %eax,0x805034
  80262a:	a1 34 50 80 00       	mov    0x805034,%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	0f 85 e9 fc ff ff    	jne    802320 <alloc_block_FF+0xc0>
  802637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263b:	0f 85 df fc ff ff    	jne    802320 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	83 c0 08             	add    $0x8,%eax
  802647:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80264a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802657:	01 d0                	add    %edx,%eax
  802659:	48                   	dec    %eax
  80265a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80265d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802660:	ba 00 00 00 00       	mov    $0x0,%edx
  802665:	f7 75 d8             	divl   -0x28(%ebp)
  802668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80266b:	29 d0                	sub    %edx,%eax
  80266d:	c1 e8 0c             	shr    $0xc,%eax
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	50                   	push   %eax
  802674:	e8 ce ed ff ff       	call   801447 <sbrk>
  802679:	83 c4 10             	add    $0x10,%esp
  80267c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80267f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802683:	75 0a                	jne    80268f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802685:	b8 00 00 00 00       	mov    $0x0,%eax
  80268a:	e9 8b 00 00 00       	jmp    80271a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80268f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802696:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802699:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269c:	01 d0                	add    %edx,%eax
  80269e:	48                   	dec    %eax
  80269f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026aa:	f7 75 cc             	divl   -0x34(%ebp)
  8026ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026b0:	29 d0                	sub    %edx,%eax
  8026b2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b8:	01 d0                	add    %edx,%eax
  8026ba:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026ca:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	48                   	dec    %eax
  8026da:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e5:	f7 75 c4             	divl   -0x3c(%ebp)
  8026e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026eb:	29 d0                	sub    %edx,%eax
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	6a 01                	push   $0x1
  8026f2:	50                   	push   %eax
  8026f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8026f6:	e8 36 fb ff ff       	call   802231 <set_block_data>
  8026fb:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	ff 75 d0             	pushl  -0x30(%ebp)
  802704:	e8 1b 0a 00 00       	call   803124 <free_block>
  802709:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80270c:	83 ec 0c             	sub    $0xc,%esp
  80270f:	ff 75 08             	pushl  0x8(%ebp)
  802712:	e8 49 fb ff ff       	call   802260 <alloc_block_FF>
  802717:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802722:	8b 45 08             	mov    0x8(%ebp),%eax
  802725:	83 e0 01             	and    $0x1,%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 03                	je     80272f <alloc_block_BF+0x13>
  80272c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80272f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802733:	77 07                	ja     80273c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802735:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80273c:	a1 24 50 80 00       	mov    0x805024,%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	75 73                	jne    8027b8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	83 c0 10             	add    $0x10,%eax
  80274b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80274e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275b:	01 d0                	add    %edx,%eax
  80275d:	48                   	dec    %eax
  80275e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802764:	ba 00 00 00 00       	mov    $0x0,%edx
  802769:	f7 75 e0             	divl   -0x20(%ebp)
  80276c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80276f:	29 d0                	sub    %edx,%eax
  802771:	c1 e8 0c             	shr    $0xc,%eax
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	50                   	push   %eax
  802778:	e8 ca ec ff ff       	call   801447 <sbrk>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	6a 00                	push   $0x0
  802788:	e8 ba ec ff ff       	call   801447 <sbrk>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802796:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802799:	83 ec 08             	sub    $0x8,%esp
  80279c:	50                   	push   %eax
  80279d:	ff 75 d8             	pushl  -0x28(%ebp)
  8027a0:	e8 9f f8 ff ff       	call   802044 <initialize_dynamic_allocator>
  8027a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	68 eb 45 80 00       	push   $0x8045eb
  8027b0:	e8 f8 de ff ff       	call   8006ad <cprintf>
  8027b5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027c6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dc:	e9 1d 01 00 00       	jmp    8028fe <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	ff 75 a8             	pushl  -0x58(%ebp)
  8027ed:	e8 ee f6 ff ff       	call   801ee0 <get_block_size>
  8027f2:	83 c4 10             	add    $0x10,%esp
  8027f5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	83 c0 08             	add    $0x8,%eax
  8027fe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802801:	0f 87 ef 00 00 00    	ja     8028f6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	83 c0 18             	add    $0x18,%eax
  80280d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802810:	77 1d                	ja     80282f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802818:	0f 86 d8 00 00 00    	jbe    8028f6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80281e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802824:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802827:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80282a:	e9 c7 00 00 00       	jmp    8028f6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	83 c0 08             	add    $0x8,%eax
  802835:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802838:	0f 85 9d 00 00 00    	jne    8028db <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	6a 01                	push   $0x1
  802843:	ff 75 a4             	pushl  -0x5c(%ebp)
  802846:	ff 75 a8             	pushl  -0x58(%ebp)
  802849:	e8 e3 f9 ff ff       	call   802231 <set_block_data>
  80284e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	75 17                	jne    80286e <alloc_block_BF+0x152>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 8f 45 80 00       	push   $0x80458f
  80285f:	68 2c 01 00 00       	push   $0x12c
  802864:	68 ad 45 80 00       	push   $0x8045ad
  802869:	e8 7e 11 00 00       	call   8039ec <_panic>
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 00                	mov    (%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 10                	je     802887 <alloc_block_BF+0x16b>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287f:	8b 52 04             	mov    0x4(%edx),%edx
  802882:	89 50 04             	mov    %edx,0x4(%eax)
  802885:	eb 0b                	jmp    802892 <alloc_block_BF+0x176>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	a3 30 50 80 00       	mov    %eax,0x805030
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 0f                	je     8028ab <alloc_block_BF+0x18f>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 12                	mov    (%edx),%edx
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	eb 0a                	jmp    8028b5 <alloc_block_BF+0x199>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8028cd:	48                   	dec    %eax
  8028ce:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d6:	e9 24 04 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e1:	76 13                	jbe    8028f6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028e3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8028fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	74 07                	je     80290b <alloc_block_BF+0x1ef>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	eb 05                	jmp    802910 <alloc_block_BF+0x1f4>
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
  802910:	a3 34 50 80 00       	mov    %eax,0x805034
  802915:	a1 34 50 80 00       	mov    0x805034,%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	0f 85 bf fe ff ff    	jne    8027e1 <alloc_block_BF+0xc5>
  802922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802926:	0f 85 b5 fe ff ff    	jne    8027e1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80292c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802930:	0f 84 26 02 00 00    	je     802b5c <alloc_block_BF+0x440>
  802936:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293a:	0f 85 1c 02 00 00    	jne    802b5c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802943:	2b 45 08             	sub    0x8(%ebp),%eax
  802946:	83 e8 08             	sub    $0x8,%eax
  802949:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8d 50 08             	lea    0x8(%eax),%edx
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	83 c0 08             	add    $0x8,%eax
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	6a 01                	push   $0x1
  802965:	50                   	push   %eax
  802966:	ff 75 f0             	pushl  -0x10(%ebp)
  802969:	e8 c3 f8 ff ff       	call   802231 <set_block_data>
  80296e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	75 68                	jne    8029e3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80297b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_BF+0x27c>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 c8 45 80 00       	push   $0x8045c8
  802989:	68 45 01 00 00       	push   $0x145
  80298e:	68 ad 45 80 00       	push   $0x8045ad
  802993:	e8 54 10 00 00       	call   8039ec <_panic>
  802998:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80299e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a1:	89 10                	mov    %edx,(%eax)
  8029a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 0d                	je     8029b9 <alloc_block_BF+0x29d>
  8029ac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029b1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	eb 08                	jmp    8029c1 <alloc_block_BF+0x2a5>
  8029b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d8:	40                   	inc    %eax
  8029d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8029de:	e9 dc 00 00 00       	jmp    802abf <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 65                	jne    802a51 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_BF+0x2ed>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 fc 45 80 00       	push   $0x8045fc
  8029fa:	68 4a 01 00 00       	push   $0x14a
  8029ff:	68 ad 45 80 00       	push   $0x8045ad
  802a04:	e8 e3 0f 00 00       	call   8039ec <_panic>
  802a09:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a12:	89 50 04             	mov    %edx,0x4(%eax)
  802a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0c                	je     802a2b <alloc_block_BF+0x30f>
  802a1f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	eb 08                	jmp    802a33 <alloc_block_BF+0x317>
  802a2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a36:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a44:	a1 38 50 80 00       	mov    0x805038,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 38 50 80 00       	mov    %eax,0x805038
  802a4f:	eb 6e                	jmp    802abf <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a55:	74 06                	je     802a5d <alloc_block_BF+0x341>
  802a57:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a5b:	75 17                	jne    802a74 <alloc_block_BF+0x358>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 20 46 80 00       	push   $0x804620
  802a65:	68 4f 01 00 00       	push   $0x14f
  802a6a:	68 ad 45 80 00       	push   $0x8045ad
  802a6f:	e8 78 0f 00 00       	call   8039ec <_panic>
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 10                	mov    (%eax),%edx
  802a79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7c:	89 10                	mov    %edx,(%eax)
  802a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0b                	je     802a92 <alloc_block_BF+0x376>
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	75 08                	jne    802ab4 <alloc_block_BF+0x398>
  802aac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aaf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802abf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_BF+0x3c0>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 8f 45 80 00       	push   $0x80458f
  802acd:	68 51 01 00 00       	push   $0x151
  802ad2:	68 ad 45 80 00       	push   $0x8045ad
  802ad7:	e8 10 0f 00 00       	call   8039ec <_panic>
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 10                	je     802af5 <alloc_block_BF+0x3d9>
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aed:	8b 52 04             	mov    0x4(%edx),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	eb 0b                	jmp    802b00 <alloc_block_BF+0x3e4>
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	a3 30 50 80 00       	mov    %eax,0x805030
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 0f                	je     802b19 <alloc_block_BF+0x3fd>
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b13:	8b 12                	mov    (%edx),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	eb 0a                	jmp    802b23 <alloc_block_BF+0x407>
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b36:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3b:	48                   	dec    %eax
  802b3c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	6a 00                	push   $0x0
  802b46:	ff 75 d0             	pushl  -0x30(%ebp)
  802b49:	ff 75 cc             	pushl  -0x34(%ebp)
  802b4c:	e8 e0 f6 ff ff       	call   802231 <set_block_data>
  802b51:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	e9 a3 01 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b5c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b60:	0f 85 9d 00 00 00    	jne    802c03 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	6a 01                	push   $0x1
  802b6b:	ff 75 ec             	pushl  -0x14(%ebp)
  802b6e:	ff 75 f0             	pushl  -0x10(%ebp)
  802b71:	e8 bb f6 ff ff       	call   802231 <set_block_data>
  802b76:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7d:	75 17                	jne    802b96 <alloc_block_BF+0x47a>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 8f 45 80 00       	push   $0x80458f
  802b87:	68 58 01 00 00       	push   $0x158
  802b8c:	68 ad 45 80 00       	push   $0x8045ad
  802b91:	e8 56 0e 00 00       	call   8039ec <_panic>
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 10                	je     802baf <alloc_block_BF+0x493>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba7:	8b 52 04             	mov    0x4(%edx),%edx
  802baa:	89 50 04             	mov    %edx,0x4(%eax)
  802bad:	eb 0b                	jmp    802bba <alloc_block_BF+0x49e>
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 0f                	je     802bd3 <alloc_block_BF+0x4b7>
  802bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcd:	8b 12                	mov    (%edx),%edx
  802bcf:	89 10                	mov    %edx,(%eax)
  802bd1:	eb 0a                	jmp    802bdd <alloc_block_BF+0x4c1>
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf0:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf5:	48                   	dec    %eax
  802bf6:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	e9 fc 00 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	83 c0 08             	add    $0x8,%eax
  802c09:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c0c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c13:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c19:	01 d0                	add    %edx,%eax
  802c1b:	48                   	dec    %eax
  802c1c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c1f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c22:	ba 00 00 00 00       	mov    $0x0,%edx
  802c27:	f7 75 c4             	divl   -0x3c(%ebp)
  802c2a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c2d:	29 d0                	sub    %edx,%eax
  802c2f:	c1 e8 0c             	shr    $0xc,%eax
  802c32:	83 ec 0c             	sub    $0xc,%esp
  802c35:	50                   	push   %eax
  802c36:	e8 0c e8 ff ff       	call   801447 <sbrk>
  802c3b:	83 c4 10             	add    $0x10,%esp
  802c3e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c41:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c45:	75 0a                	jne    802c51 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	e9 ae 00 00 00       	jmp    802cff <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c51:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c58:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c5e:	01 d0                	add    %edx,%eax
  802c60:	48                   	dec    %eax
  802c61:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c64:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c67:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6c:	f7 75 b8             	divl   -0x48(%ebp)
  802c6f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c72:	29 d0                	sub    %edx,%eax
  802c74:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c77:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c7a:	01 d0                	add    %edx,%eax
  802c7c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c81:	a1 40 50 80 00       	mov    0x805040,%eax
  802c86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c8c:	83 ec 0c             	sub    $0xc,%esp
  802c8f:	68 54 46 80 00       	push   $0x804654
  802c94:	e8 14 da ff ff       	call   8006ad <cprintf>
  802c99:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c9c:	83 ec 08             	sub    $0x8,%esp
  802c9f:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca2:	68 59 46 80 00       	push   $0x804659
  802ca7:	e8 01 da ff ff       	call   8006ad <cprintf>
  802cac:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802caf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cb6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	48                   	dec    %eax
  802cbf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cc2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cca:	f7 75 b0             	divl   -0x50(%ebp)
  802ccd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cd0:	29 d0                	sub    %edx,%eax
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	6a 01                	push   $0x1
  802cd7:	50                   	push   %eax
  802cd8:	ff 75 bc             	pushl  -0x44(%ebp)
  802cdb:	e8 51 f5 ff ff       	call   802231 <set_block_data>
  802ce0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ce3:	83 ec 0c             	sub    $0xc,%esp
  802ce6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce9:	e8 36 04 00 00       	call   803124 <free_block>
  802cee:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cf1:	83 ec 0c             	sub    $0xc,%esp
  802cf4:	ff 75 08             	pushl  0x8(%ebp)
  802cf7:	e8 20 fa ff ff       	call   80271c <alloc_block_BF>
  802cfc:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	53                   	push   %ebx
  802d05:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1a:	74 1e                	je     802d3a <merging+0x39>
  802d1c:	ff 75 08             	pushl  0x8(%ebp)
  802d1f:	e8 bc f1 ff ff       	call   801ee0 <get_block_size>
  802d24:	83 c4 04             	add    $0x4,%esp
  802d27:	89 c2                	mov    %eax,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	01 d0                	add    %edx,%eax
  802d2e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d31:	75 07                	jne    802d3a <merging+0x39>
		prev_is_free = 1;
  802d33:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d3e:	74 1e                	je     802d5e <merging+0x5d>
  802d40:	ff 75 10             	pushl  0x10(%ebp)
  802d43:	e8 98 f1 ff ff       	call   801ee0 <get_block_size>
  802d48:	83 c4 04             	add    $0x4,%esp
  802d4b:	89 c2                	mov    %eax,%edx
  802d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d55:	75 07                	jne    802d5e <merging+0x5d>
		next_is_free = 1;
  802d57:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d62:	0f 84 cc 00 00 00    	je     802e34 <merging+0x133>
  802d68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6c:	0f 84 c2 00 00 00    	je     802e34 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d72:	ff 75 08             	pushl  0x8(%ebp)
  802d75:	e8 66 f1 ff ff       	call   801ee0 <get_block_size>
  802d7a:	83 c4 04             	add    $0x4,%esp
  802d7d:	89 c3                	mov    %eax,%ebx
  802d7f:	ff 75 10             	pushl  0x10(%ebp)
  802d82:	e8 59 f1 ff ff       	call   801ee0 <get_block_size>
  802d87:	83 c4 04             	add    $0x4,%esp
  802d8a:	01 c3                	add    %eax,%ebx
  802d8c:	ff 75 0c             	pushl  0xc(%ebp)
  802d8f:	e8 4c f1 ff ff       	call   801ee0 <get_block_size>
  802d94:	83 c4 04             	add    $0x4,%esp
  802d97:	01 d8                	add    %ebx,%eax
  802d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d9c:	6a 00                	push   $0x0
  802d9e:	ff 75 ec             	pushl  -0x14(%ebp)
  802da1:	ff 75 08             	pushl  0x8(%ebp)
  802da4:	e8 88 f4 ff ff       	call   802231 <set_block_data>
  802da9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802db0:	75 17                	jne    802dc9 <merging+0xc8>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 8f 45 80 00       	push   $0x80458f
  802dba:	68 7d 01 00 00       	push   $0x17d
  802dbf:	68 ad 45 80 00       	push   $0x8045ad
  802dc4:	e8 23 0c 00 00       	call   8039ec <_panic>
  802dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 10                	je     802de2 <merging+0xe1>
  802dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dda:	8b 52 04             	mov    0x4(%edx),%edx
  802ddd:	89 50 04             	mov    %edx,0x4(%eax)
  802de0:	eb 0b                	jmp    802ded <merging+0xec>
  802de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0f                	je     802e06 <merging+0x105>
  802df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e00:	8b 12                	mov    (%edx),%edx
  802e02:	89 10                	mov    %edx,(%eax)
  802e04:	eb 0a                	jmp    802e10 <merging+0x10f>
  802e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e23:	a1 38 50 80 00       	mov    0x805038,%eax
  802e28:	48                   	dec    %eax
  802e29:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e2e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e2f:	e9 ea 02 00 00       	jmp    80311e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e38:	74 3b                	je     802e75 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 08             	pushl  0x8(%ebp)
  802e40:	e8 9b f0 ff ff       	call   801ee0 <get_block_size>
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	89 c3                	mov    %eax,%ebx
  802e4a:	83 ec 0c             	sub    $0xc,%esp
  802e4d:	ff 75 10             	pushl  0x10(%ebp)
  802e50:	e8 8b f0 ff ff       	call   801ee0 <get_block_size>
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	01 d8                	add    %ebx,%eax
  802e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	6a 00                	push   $0x0
  802e62:	ff 75 e8             	pushl  -0x18(%ebp)
  802e65:	ff 75 08             	pushl  0x8(%ebp)
  802e68:	e8 c4 f3 ff ff       	call   802231 <set_block_data>
  802e6d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e70:	e9 a9 02 00 00       	jmp    80311e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e79:	0f 84 2d 01 00 00    	je     802fac <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e7f:	83 ec 0c             	sub    $0xc,%esp
  802e82:	ff 75 10             	pushl  0x10(%ebp)
  802e85:	e8 56 f0 ff ff       	call   801ee0 <get_block_size>
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	89 c3                	mov    %eax,%ebx
  802e8f:	83 ec 0c             	sub    $0xc,%esp
  802e92:	ff 75 0c             	pushl  0xc(%ebp)
  802e95:	e8 46 f0 ff ff       	call   801ee0 <get_block_size>
  802e9a:	83 c4 10             	add    $0x10,%esp
  802e9d:	01 d8                	add    %ebx,%eax
  802e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	6a 00                	push   $0x0
  802ea7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eaa:	ff 75 10             	pushl  0x10(%ebp)
  802ead:	e8 7f f3 ff ff       	call   802231 <set_block_data>
  802eb2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ebf:	74 06                	je     802ec7 <merging+0x1c6>
  802ec1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec5:	75 17                	jne    802ede <merging+0x1dd>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 68 46 80 00       	push   $0x804668
  802ecf:	68 8d 01 00 00       	push   $0x18d
  802ed4:	68 ad 45 80 00       	push   $0x8045ad
  802ed9:	e8 0e 0b 00 00       	call   8039ec <_panic>
  802ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee1:	8b 50 04             	mov    0x4(%eax),%edx
  802ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee7:	89 50 04             	mov    %edx,0x4(%eax)
  802eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef0:	89 10                	mov    %edx,(%eax)
  802ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0d                	je     802f09 <merging+0x208>
  802efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	eb 08                	jmp    802f11 <merging+0x210>
  802f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f17:	89 50 04             	mov    %edx,0x4(%eax)
  802f1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f29:	75 17                	jne    802f42 <merging+0x241>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 8f 45 80 00       	push   $0x80458f
  802f33:	68 8e 01 00 00       	push   $0x18e
  802f38:	68 ad 45 80 00       	push   $0x8045ad
  802f3d:	e8 aa 0a 00 00       	call   8039ec <_panic>
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 10                	je     802f5b <merging+0x25a>
  802f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f53:	8b 52 04             	mov    0x4(%edx),%edx
  802f56:	89 50 04             	mov    %edx,0x4(%eax)
  802f59:	eb 0b                	jmp    802f66 <merging+0x265>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	a3 30 50 80 00       	mov    %eax,0x805030
  802f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0f                	je     802f7f <merging+0x27e>
  802f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f79:	8b 12                	mov    (%edx),%edx
  802f7b:	89 10                	mov    %edx,(%eax)
  802f7d:	eb 0a                	jmp    802f89 <merging+0x288>
  802f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa1:	48                   	dec    %eax
  802fa2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa7:	e9 72 01 00 00       	jmp    80311e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fac:	8b 45 10             	mov    0x10(%ebp),%eax
  802faf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb6:	74 79                	je     803031 <merging+0x330>
  802fb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbc:	74 73                	je     803031 <merging+0x330>
  802fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc2:	74 06                	je     802fca <merging+0x2c9>
  802fc4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc8:	75 17                	jne    802fe1 <merging+0x2e0>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 20 46 80 00       	push   $0x804620
  802fd2:	68 94 01 00 00       	push   $0x194
  802fd7:	68 ad 45 80 00       	push   $0x8045ad
  802fdc:	e8 0b 0a 00 00       	call   8039ec <_panic>
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 10                	mov    (%eax),%edx
  802fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0b                	je     802fff <merging+0x2fe>
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300a:	8b 55 08             	mov    0x8(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	75 08                	jne    803021 <merging+0x320>
  803019:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301c:	a3 30 50 80 00       	mov    %eax,0x805030
  803021:	a1 38 50 80 00       	mov    0x805038,%eax
  803026:	40                   	inc    %eax
  803027:	a3 38 50 80 00       	mov    %eax,0x805038
  80302c:	e9 ce 00 00 00       	jmp    8030ff <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803031:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803035:	74 65                	je     80309c <merging+0x39b>
  803037:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80303b:	75 17                	jne    803054 <merging+0x353>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 fc 45 80 00       	push   $0x8045fc
  803045:	68 95 01 00 00       	push   $0x195
  80304a:	68 ad 45 80 00       	push   $0x8045ad
  80304f:	e8 98 09 00 00       	call   8039ec <_panic>
  803054:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0c                	je     803076 <merging+0x375>
  80306a:	a1 30 50 80 00       	mov    0x805030,%eax
  80306f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803072:	89 10                	mov    %edx,(%eax)
  803074:	eb 08                	jmp    80307e <merging+0x37d>
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	a3 30 50 80 00       	mov    %eax,0x805030
  803086:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308f:	a1 38 50 80 00       	mov    0x805038,%eax
  803094:	40                   	inc    %eax
  803095:	a3 38 50 80 00       	mov    %eax,0x805038
  80309a:	eb 63                	jmp    8030ff <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80309c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a0:	75 17                	jne    8030b9 <merging+0x3b8>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 c8 45 80 00       	push   $0x8045c8
  8030aa:	68 98 01 00 00       	push   $0x198
  8030af:	68 ad 45 80 00       	push   $0x8045ad
  8030b4:	e8 33 09 00 00       	call   8039ec <_panic>
  8030b9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0d                	je     8030da <merging+0x3d9>
  8030cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 08                	jmp    8030e2 <merging+0x3e1>
  8030da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f9:	40                   	inc    %eax
  8030fa:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030ff:	83 ec 0c             	sub    $0xc,%esp
  803102:	ff 75 10             	pushl  0x10(%ebp)
  803105:	e8 d6 ed ff ff       	call   801ee0 <get_block_size>
  80310a:	83 c4 10             	add    $0x10,%esp
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	6a 00                	push   $0x0
  803112:	50                   	push   %eax
  803113:	ff 75 10             	pushl  0x10(%ebp)
  803116:	e8 16 f1 ff ff       	call   802231 <set_block_data>
  80311b:	83 c4 10             	add    $0x10,%esp
	}
}
  80311e:	90                   	nop
  80311f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803122:	c9                   	leave  
  803123:	c3                   	ret    

00803124 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80312a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803132:	a1 30 50 80 00       	mov    0x805030,%eax
  803137:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313a:	73 1b                	jae    803157 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80313c:	a1 30 50 80 00       	mov    0x805030,%eax
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	ff 75 08             	pushl  0x8(%ebp)
  803147:	6a 00                	push   $0x0
  803149:	50                   	push   %eax
  80314a:	e8 b2 fb ff ff       	call   802d01 <merging>
  80314f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803152:	e9 8b 00 00 00       	jmp    8031e2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803157:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315f:	76 18                	jbe    803179 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803161:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	ff 75 08             	pushl  0x8(%ebp)
  80316c:	50                   	push   %eax
  80316d:	6a 00                	push   $0x0
  80316f:	e8 8d fb ff ff       	call   802d01 <merging>
  803174:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803177:	eb 69                	jmp    8031e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803179:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803181:	eb 39                	jmp    8031bc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	3b 45 08             	cmp    0x8(%ebp),%eax
  803189:	73 29                	jae    8031b4 <free_block+0x90>
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	3b 45 08             	cmp    0x8(%ebp),%eax
  803193:	76 1f                	jbe    8031b4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80319d:	83 ec 04             	sub    $0x4,%esp
  8031a0:	ff 75 08             	pushl  0x8(%ebp)
  8031a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a9:	e8 53 fb ff ff       	call   802d01 <merging>
  8031ae:	83 c4 10             	add    $0x10,%esp
			break;
  8031b1:	90                   	nop
		}
	}
}
  8031b2:	eb 2e                	jmp    8031e2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c0:	74 07                	je     8031c9 <free_block+0xa5>
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	eb 05                	jmp    8031ce <free_block+0xaa>
  8031c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ce:	a3 34 50 80 00       	mov    %eax,0x805034
  8031d3:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	75 a7                	jne    803183 <free_block+0x5f>
  8031dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e0:	75 a1                	jne    803183 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e2:	90                   	nop
  8031e3:	c9                   	leave  
  8031e4:	c3                   	ret    

008031e5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031e5:	55                   	push   %ebp
  8031e6:	89 e5                	mov    %esp,%ebp
  8031e8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031eb:	ff 75 08             	pushl  0x8(%ebp)
  8031ee:	e8 ed ec ff ff       	call   801ee0 <get_block_size>
  8031f3:	83 c4 04             	add    $0x4,%esp
  8031f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803200:	eb 17                	jmp    803219 <copy_data+0x34>
  803202:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803205:	8b 45 0c             	mov    0xc(%ebp),%eax
  803208:	01 c2                	add    %eax,%edx
  80320a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	01 c8                	add    %ecx,%eax
  803212:	8a 00                	mov    (%eax),%al
  803214:	88 02                	mov    %al,(%edx)
  803216:	ff 45 fc             	incl   -0x4(%ebp)
  803219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80321c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80321f:	72 e1                	jb     803202 <copy_data+0x1d>
}
  803221:	90                   	nop
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
  803227:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80322a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322e:	75 23                	jne    803253 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803230:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803234:	74 13                	je     803249 <realloc_block_FF+0x25>
  803236:	83 ec 0c             	sub    $0xc,%esp
  803239:	ff 75 0c             	pushl  0xc(%ebp)
  80323c:	e8 1f f0 ff ff       	call   802260 <alloc_block_FF>
  803241:	83 c4 10             	add    $0x10,%esp
  803244:	e9 f4 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
		return NULL;
  803249:	b8 00 00 00 00       	mov    $0x0,%eax
  80324e:	e9 ea 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803253:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803257:	75 18                	jne    803271 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803259:	83 ec 0c             	sub    $0xc,%esp
  80325c:	ff 75 08             	pushl  0x8(%ebp)
  80325f:	e8 c0 fe ff ff       	call   803124 <free_block>
  803264:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	e9 cc 06 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803271:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803275:	77 07                	ja     80327e <realloc_block_FF+0x5a>
  803277:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803281:	83 e0 01             	and    $0x1,%eax
  803284:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328a:	83 c0 08             	add    $0x8,%eax
  80328d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803290:	83 ec 0c             	sub    $0xc,%esp
  803293:	ff 75 08             	pushl  0x8(%ebp)
  803296:	e8 45 ec ff ff       	call   801ee0 <get_block_size>
  80329b:	83 c4 10             	add    $0x10,%esp
  80329e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a4:	83 e8 08             	sub    $0x8,%eax
  8032a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	83 e8 04             	sub    $0x4,%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8032b5:	89 c2                	mov    %eax,%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	01 d0                	add    %edx,%eax
  8032bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032bf:	83 ec 0c             	sub    $0xc,%esp
  8032c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032c5:	e8 16 ec ff ff       	call   801ee0 <get_block_size>
  8032ca:	83 c4 10             	add    $0x10,%esp
  8032cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d3:	83 e8 08             	sub    $0x8,%eax
  8032d6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032dc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032df:	75 08                	jne    8032e9 <realloc_block_FF+0xc5>
	{
		 return va;
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	e9 54 06 00 00       	jmp    80393d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032ef:	0f 83 e5 03 00 00    	jae    8036da <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032fe:	83 ec 0c             	sub    $0xc,%esp
  803301:	ff 75 e4             	pushl  -0x1c(%ebp)
  803304:	e8 f0 eb ff ff       	call   801ef9 <is_free_block>
  803309:	83 c4 10             	add    $0x10,%esp
  80330c:	84 c0                	test   %al,%al
  80330e:	0f 84 3b 01 00 00    	je     80344f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803314:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803317:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331a:	01 d0                	add    %edx,%eax
  80331c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80331f:	83 ec 04             	sub    $0x4,%esp
  803322:	6a 01                	push   $0x1
  803324:	ff 75 f0             	pushl  -0x10(%ebp)
  803327:	ff 75 08             	pushl  0x8(%ebp)
  80332a:	e8 02 ef ff ff       	call   802231 <set_block_data>
  80332f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	83 e8 04             	sub    $0x4,%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	83 e0 fe             	and    $0xfffffffe,%eax
  80333d:	89 c2                	mov    %eax,%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	01 d0                	add    %edx,%eax
  803344:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	6a 00                	push   $0x0
  80334c:	ff 75 cc             	pushl  -0x34(%ebp)
  80334f:	ff 75 c8             	pushl  -0x38(%ebp)
  803352:	e8 da ee ff ff       	call   802231 <set_block_data>
  803357:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80335a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80335e:	74 06                	je     803366 <realloc_block_FF+0x142>
  803360:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803364:	75 17                	jne    80337d <realloc_block_FF+0x159>
  803366:	83 ec 04             	sub    $0x4,%esp
  803369:	68 20 46 80 00       	push   $0x804620
  80336e:	68 f6 01 00 00       	push   $0x1f6
  803373:	68 ad 45 80 00       	push   $0x8045ad
  803378:	e8 6f 06 00 00       	call   8039ec <_panic>
  80337d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803380:	8b 10                	mov    (%eax),%edx
  803382:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803385:	89 10                	mov    %edx,(%eax)
  803387:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	74 0b                	je     80339b <realloc_block_FF+0x177>
  803390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803398:	89 50 04             	mov    %edx,0x4(%eax)
  80339b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	75 08                	jne    8033bd <realloc_block_FF+0x199>
  8033b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c2:	40                   	inc    %eax
  8033c3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033cc:	75 17                	jne    8033e5 <realloc_block_FF+0x1c1>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 8f 45 80 00       	push   $0x80458f
  8033d6:	68 f7 01 00 00       	push   $0x1f7
  8033db:	68 ad 45 80 00       	push   $0x8045ad
  8033e0:	e8 07 06 00 00       	call   8039ec <_panic>
  8033e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 10                	je     8033fe <realloc_block_FF+0x1da>
  8033ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f6:	8b 52 04             	mov    0x4(%edx),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	eb 0b                	jmp    803409 <realloc_block_FF+0x1e5>
  8033fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	a3 30 50 80 00       	mov    %eax,0x805030
  803409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 0f                	je     803422 <realloc_block_FF+0x1fe>
  803413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80341c:	8b 12                	mov    (%edx),%edx
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	eb 0a                	jmp    80342c <realloc_block_FF+0x208>
  803422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343f:	a1 38 50 80 00       	mov    0x805038,%eax
  803444:	48                   	dec    %eax
  803445:	a3 38 50 80 00       	mov    %eax,0x805038
  80344a:	e9 83 02 00 00       	jmp    8036d2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80344f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803453:	0f 86 69 02 00 00    	jbe    8036c2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	6a 01                	push   $0x1
  80345e:	ff 75 f0             	pushl  -0x10(%ebp)
  803461:	ff 75 08             	pushl  0x8(%ebp)
  803464:	e8 c8 ed ff ff       	call   802231 <set_block_data>
  803469:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	83 e8 04             	sub    $0x4,%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	83 e0 fe             	and    $0xfffffffe,%eax
  803477:	89 c2                	mov    %eax,%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	01 d0                	add    %edx,%eax
  80347e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803481:	a1 38 50 80 00       	mov    0x805038,%eax
  803486:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803489:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80348d:	75 68                	jne    8034f7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80348f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803493:	75 17                	jne    8034ac <realloc_block_FF+0x288>
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 c8 45 80 00       	push   $0x8045c8
  80349d:	68 06 02 00 00       	push   $0x206
  8034a2:	68 ad 45 80 00       	push   $0x8045ad
  8034a7:	e8 40 05 00 00       	call   8039ec <_panic>
  8034ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 0d                	je     8034cd <realloc_block_FF+0x2a9>
  8034c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c8:	89 50 04             	mov    %edx,0x4(%eax)
  8034cb:	eb 08                	jmp    8034d5 <realloc_block_FF+0x2b1>
  8034cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ec:	40                   	inc    %eax
  8034ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f2:	e9 b0 01 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ff:	76 68                	jbe    803569 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803501:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803505:	75 17                	jne    80351e <realloc_block_FF+0x2fa>
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	68 c8 45 80 00       	push   $0x8045c8
  80350f:	68 0b 02 00 00       	push   $0x20b
  803514:	68 ad 45 80 00       	push   $0x8045ad
  803519:	e8 ce 04 00 00       	call   8039ec <_panic>
  80351e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803527:	89 10                	mov    %edx,(%eax)
  803529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 0d                	je     80353f <realloc_block_FF+0x31b>
  803532:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803537:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	eb 08                	jmp    803547 <realloc_block_FF+0x323>
  80353f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803542:	a3 30 50 80 00       	mov    %eax,0x805030
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80354f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803559:	a1 38 50 80 00       	mov    0x805038,%eax
  80355e:	40                   	inc    %eax
  80355f:	a3 38 50 80 00       	mov    %eax,0x805038
  803564:	e9 3e 01 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803569:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80356e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803571:	73 68                	jae    8035db <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803573:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803577:	75 17                	jne    803590 <realloc_block_FF+0x36c>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 fc 45 80 00       	push   $0x8045fc
  803581:	68 10 02 00 00       	push   $0x210
  803586:	68 ad 45 80 00       	push   $0x8045ad
  80358b:	e8 5c 04 00 00       	call   8039ec <_panic>
  803590:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803596:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803599:	89 50 04             	mov    %edx,0x4(%eax)
  80359c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359f:	8b 40 04             	mov    0x4(%eax),%eax
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	74 0c                	je     8035b2 <realloc_block_FF+0x38e>
  8035a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	eb 08                	jmp    8035ba <realloc_block_FF+0x396>
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035d6:	e9 cc 00 00 00       	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ea:	e9 8a 00 00 00       	jmp    803679 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035f5:	73 7a                	jae    803671 <realloc_block_FF+0x44d>
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ff:	73 70                	jae    803671 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803605:	74 06                	je     80360d <realloc_block_FF+0x3e9>
  803607:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360b:	75 17                	jne    803624 <realloc_block_FF+0x400>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 20 46 80 00       	push   $0x804620
  803615:	68 1a 02 00 00       	push   $0x21a
  80361a:	68 ad 45 80 00       	push   $0x8045ad
  80361f:	e8 c8 03 00 00       	call   8039ec <_panic>
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 10                	mov    (%eax),%edx
  803629:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362c:	89 10                	mov    %edx,(%eax)
  80362e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	74 0b                	je     803642 <realloc_block_FF+0x41e>
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 00                	mov    (%eax),%eax
  80363c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80363f:	89 50 04             	mov    %edx,0x4(%eax)
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803650:	89 50 04             	mov    %edx,0x4(%eax)
  803653:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	85 c0                	test   %eax,%eax
  80365a:	75 08                	jne    803664 <realloc_block_FF+0x440>
  80365c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365f:	a3 30 50 80 00       	mov    %eax,0x805030
  803664:	a1 38 50 80 00       	mov    0x805038,%eax
  803669:	40                   	inc    %eax
  80366a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80366f:	eb 36                	jmp    8036a7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803671:	a1 34 50 80 00       	mov    0x805034,%eax
  803676:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367d:	74 07                	je     803686 <realloc_block_FF+0x462>
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	eb 05                	jmp    80368b <realloc_block_FF+0x467>
  803686:	b8 00 00 00 00       	mov    $0x0,%eax
  80368b:	a3 34 50 80 00       	mov    %eax,0x805034
  803690:	a1 34 50 80 00       	mov    0x805034,%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	0f 85 52 ff ff ff    	jne    8035ef <realloc_block_FF+0x3cb>
  80369d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a1:	0f 85 48 ff ff ff    	jne    8035ef <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	6a 00                	push   $0x0
  8036ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8036af:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036b2:	e8 7a eb ff ff       	call   802231 <set_block_data>
  8036b7:	83 c4 10             	add    $0x10,%esp
				return va;
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	e9 7b 02 00 00       	jmp    80393d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036c2:	83 ec 0c             	sub    $0xc,%esp
  8036c5:	68 9d 46 80 00       	push   $0x80469d
  8036ca:	e8 de cf ff ff       	call   8006ad <cprintf>
  8036cf:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	e9 63 02 00 00       	jmp    80393d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036e0:	0f 86 4d 02 00 00    	jbe    803933 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036e6:	83 ec 0c             	sub    $0xc,%esp
  8036e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036ec:	e8 08 e8 ff ff       	call   801ef9 <is_free_block>
  8036f1:	83 c4 10             	add    $0x10,%esp
  8036f4:	84 c0                	test   %al,%al
  8036f6:	0f 84 37 02 00 00    	je     803933 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803702:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803705:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803708:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80370b:	76 38                	jbe    803745 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80370d:	83 ec 0c             	sub    $0xc,%esp
  803710:	ff 75 08             	pushl  0x8(%ebp)
  803713:	e8 0c fa ff ff       	call   803124 <free_block>
  803718:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80371b:	83 ec 0c             	sub    $0xc,%esp
  80371e:	ff 75 0c             	pushl  0xc(%ebp)
  803721:	e8 3a eb ff ff       	call   802260 <alloc_block_FF>
  803726:	83 c4 10             	add    $0x10,%esp
  803729:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80372c:	83 ec 08             	sub    $0x8,%esp
  80372f:	ff 75 c0             	pushl  -0x40(%ebp)
  803732:	ff 75 08             	pushl  0x8(%ebp)
  803735:	e8 ab fa ff ff       	call   8031e5 <copy_data>
  80373a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80373d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803740:	e9 f8 01 00 00       	jmp    80393d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803748:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80374b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80374e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803752:	0f 87 a0 00 00 00    	ja     8037f8 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80375c:	75 17                	jne    803775 <realloc_block_FF+0x551>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 8f 45 80 00       	push   $0x80458f
  803766:	68 38 02 00 00       	push   $0x238
  80376b:	68 ad 45 80 00       	push   $0x8045ad
  803770:	e8 77 02 00 00       	call   8039ec <_panic>
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	85 c0                	test   %eax,%eax
  80377c:	74 10                	je     80378e <realloc_block_FF+0x56a>
  80377e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803786:	8b 52 04             	mov    0x4(%edx),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	eb 0b                	jmp    803799 <realloc_block_FF+0x575>
  80378e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	a3 30 50 80 00       	mov    %eax,0x805030
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 40 04             	mov    0x4(%eax),%eax
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	74 0f                	je     8037b2 <realloc_block_FF+0x58e>
  8037a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a6:	8b 40 04             	mov    0x4(%eax),%eax
  8037a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ac:	8b 12                	mov    (%edx),%edx
  8037ae:	89 10                	mov    %edx,(%eax)
  8037b0:	eb 0a                	jmp    8037bc <realloc_block_FF+0x598>
  8037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d4:	48                   	dec    %eax
  8037d5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e0:	01 d0                	add    %edx,%eax
  8037e2:	83 ec 04             	sub    $0x4,%esp
  8037e5:	6a 01                	push   $0x1
  8037e7:	50                   	push   %eax
  8037e8:	ff 75 08             	pushl  0x8(%ebp)
  8037eb:	e8 41 ea ff ff       	call   802231 <set_block_data>
  8037f0:	83 c4 10             	add    $0x10,%esp
  8037f3:	e9 36 01 00 00       	jmp    80392e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037fe:	01 d0                	add    %edx,%eax
  803800:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	6a 01                	push   $0x1
  803808:	ff 75 f0             	pushl  -0x10(%ebp)
  80380b:	ff 75 08             	pushl  0x8(%ebp)
  80380e:	e8 1e ea ff ff       	call   802231 <set_block_data>
  803813:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	83 e8 04             	sub    $0x4,%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	83 e0 fe             	and    $0xfffffffe,%eax
  803821:	89 c2                	mov    %eax,%edx
  803823:	8b 45 08             	mov    0x8(%ebp),%eax
  803826:	01 d0                	add    %edx,%eax
  803828:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80382b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80382f:	74 06                	je     803837 <realloc_block_FF+0x613>
  803831:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803835:	75 17                	jne    80384e <realloc_block_FF+0x62a>
  803837:	83 ec 04             	sub    $0x4,%esp
  80383a:	68 20 46 80 00       	push   $0x804620
  80383f:	68 44 02 00 00       	push   $0x244
  803844:	68 ad 45 80 00       	push   $0x8045ad
  803849:	e8 9e 01 00 00       	call   8039ec <_panic>
  80384e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803851:	8b 10                	mov    (%eax),%edx
  803853:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	85 c0                	test   %eax,%eax
  80385f:	74 0b                	je     80386c <realloc_block_FF+0x648>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803869:	89 50 04             	mov    %edx,0x4(%eax)
  80386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803872:	89 10                	mov    %edx,(%eax)
  803874:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387a:	89 50 04             	mov    %edx,0x4(%eax)
  80387d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803880:	8b 00                	mov    (%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	75 08                	jne    80388e <realloc_block_FF+0x66a>
  803886:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803889:	a3 30 50 80 00       	mov    %eax,0x805030
  80388e:	a1 38 50 80 00       	mov    0x805038,%eax
  803893:	40                   	inc    %eax
  803894:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80389d:	75 17                	jne    8038b6 <realloc_block_FF+0x692>
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 8f 45 80 00       	push   $0x80458f
  8038a7:	68 45 02 00 00       	push   $0x245
  8038ac:	68 ad 45 80 00       	push   $0x8045ad
  8038b1:	e8 36 01 00 00       	call   8039ec <_panic>
  8038b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	85 c0                	test   %eax,%eax
  8038bd:	74 10                	je     8038cf <realloc_block_FF+0x6ab>
  8038bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c2:	8b 00                	mov    (%eax),%eax
  8038c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%eax)
  8038cd:	eb 0b                	jmp    8038da <realloc_block_FF+0x6b6>
  8038cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d2:	8b 40 04             	mov    0x4(%eax),%eax
  8038d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8038da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038dd:	8b 40 04             	mov    0x4(%eax),%eax
  8038e0:	85 c0                	test   %eax,%eax
  8038e2:	74 0f                	je     8038f3 <realloc_block_FF+0x6cf>
  8038e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ed:	8b 12                	mov    (%edx),%edx
  8038ef:	89 10                	mov    %edx,(%eax)
  8038f1:	eb 0a                	jmp    8038fd <realloc_block_FF+0x6d9>
  8038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803910:	a1 38 50 80 00       	mov    0x805038,%eax
  803915:	48                   	dec    %eax
  803916:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	6a 00                	push   $0x0
  803920:	ff 75 bc             	pushl  -0x44(%ebp)
  803923:	ff 75 b8             	pushl  -0x48(%ebp)
  803926:	e8 06 e9 ff ff       	call   802231 <set_block_data>
  80392b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	eb 0a                	jmp    80393d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803933:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80393d:	c9                   	leave  
  80393e:	c3                   	ret    

0080393f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80393f:	55                   	push   %ebp
  803940:	89 e5                	mov    %esp,%ebp
  803942:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	68 a4 46 80 00       	push   $0x8046a4
  80394d:	68 58 02 00 00       	push   $0x258
  803952:	68 ad 45 80 00       	push   $0x8045ad
  803957:	e8 90 00 00 00       	call   8039ec <_panic>

0080395c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80395c:	55                   	push   %ebp
  80395d:	89 e5                	mov    %esp,%ebp
  80395f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803962:	83 ec 04             	sub    $0x4,%esp
  803965:	68 cc 46 80 00       	push   $0x8046cc
  80396a:	68 61 02 00 00       	push   $0x261
  80396f:	68 ad 45 80 00       	push   $0x8045ad
  803974:	e8 73 00 00 00       	call   8039ec <_panic>

00803979 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803979:	55                   	push   %ebp
  80397a:	89 e5                	mov    %esp,%ebp
  80397c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	68 f4 46 80 00       	push   $0x8046f4
  803987:	6a 09                	push   $0x9
  803989:	68 1c 47 80 00       	push   $0x80471c
  80398e:	e8 59 00 00 00       	call   8039ec <_panic>

00803993 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803993:	55                   	push   %ebp
  803994:	89 e5                	mov    %esp,%ebp
  803996:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 2c 47 80 00       	push   $0x80472c
  8039a1:	6a 10                	push   $0x10
  8039a3:	68 1c 47 80 00       	push   $0x80471c
  8039a8:	e8 3f 00 00 00       	call   8039ec <_panic>

008039ad <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8039ad:	55                   	push   %ebp
  8039ae:	89 e5                	mov    %esp,%ebp
  8039b0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8039b3:	83 ec 04             	sub    $0x4,%esp
  8039b6:	68 54 47 80 00       	push   $0x804754
  8039bb:	6a 18                	push   $0x18
  8039bd:	68 1c 47 80 00       	push   $0x80471c
  8039c2:	e8 25 00 00 00       	call   8039ec <_panic>

008039c7 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8039c7:	55                   	push   %ebp
  8039c8:	89 e5                	mov    %esp,%ebp
  8039ca:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8039cd:	83 ec 04             	sub    $0x4,%esp
  8039d0:	68 7c 47 80 00       	push   $0x80477c
  8039d5:	6a 20                	push   $0x20
  8039d7:	68 1c 47 80 00       	push   $0x80471c
  8039dc:	e8 0b 00 00 00       	call   8039ec <_panic>

008039e1 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8039e1:	55                   	push   %ebp
  8039e2:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	8b 40 10             	mov    0x10(%eax),%eax
}
  8039ea:	5d                   	pop    %ebp
  8039eb:	c3                   	ret    

008039ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
  8039ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8039f5:	83 c0 04             	add    $0x4,%eax
  8039f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039fb:	a1 60 50 90 00       	mov    0x905060,%eax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 16                	je     803a1a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a04:	a1 60 50 90 00       	mov    0x905060,%eax
  803a09:	83 ec 08             	sub    $0x8,%esp
  803a0c:	50                   	push   %eax
  803a0d:	68 a4 47 80 00       	push   $0x8047a4
  803a12:	e8 96 cc ff ff       	call   8006ad <cprintf>
  803a17:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a1a:	a1 00 50 80 00       	mov    0x805000,%eax
  803a1f:	ff 75 0c             	pushl  0xc(%ebp)
  803a22:	ff 75 08             	pushl  0x8(%ebp)
  803a25:	50                   	push   %eax
  803a26:	68 a9 47 80 00       	push   $0x8047a9
  803a2b:	e8 7d cc ff ff       	call   8006ad <cprintf>
  803a30:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a33:	8b 45 10             	mov    0x10(%ebp),%eax
  803a36:	83 ec 08             	sub    $0x8,%esp
  803a39:	ff 75 f4             	pushl  -0xc(%ebp)
  803a3c:	50                   	push   %eax
  803a3d:	e8 00 cc ff ff       	call   800642 <vcprintf>
  803a42:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a45:	83 ec 08             	sub    $0x8,%esp
  803a48:	6a 00                	push   $0x0
  803a4a:	68 c5 47 80 00       	push   $0x8047c5
  803a4f:	e8 ee cb ff ff       	call   800642 <vcprintf>
  803a54:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a57:	e8 6f cb ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803a5c:	eb fe                	jmp    803a5c <_panic+0x70>

00803a5e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a5e:	55                   	push   %ebp
  803a5f:	89 e5                	mov    %esp,%ebp
  803a61:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a64:	a1 20 50 80 00       	mov    0x805020,%eax
  803a69:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a72:	39 c2                	cmp    %eax,%edx
  803a74:	74 14                	je     803a8a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a76:	83 ec 04             	sub    $0x4,%esp
  803a79:	68 c8 47 80 00       	push   $0x8047c8
  803a7e:	6a 26                	push   $0x26
  803a80:	68 14 48 80 00       	push   $0x804814
  803a85:	e8 62 ff ff ff       	call   8039ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a98:	e9 c5 00 00 00       	jmp    803b62 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaa:	01 d0                	add    %edx,%eax
  803aac:	8b 00                	mov    (%eax),%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	75 08                	jne    803aba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ab2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ab5:	e9 a5 00 00 00       	jmp    803b5f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803aba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ac1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ac8:	eb 69                	jmp    803b33 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803aca:	a1 20 50 80 00       	mov    0x805020,%eax
  803acf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	01 c0                	add    %eax,%eax
  803adc:	01 d0                	add    %edx,%eax
  803ade:	c1 e0 03             	shl    $0x3,%eax
  803ae1:	01 c8                	add    %ecx,%eax
  803ae3:	8a 40 04             	mov    0x4(%eax),%al
  803ae6:	84 c0                	test   %al,%al
  803ae8:	75 46                	jne    803b30 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803aea:	a1 20 50 80 00       	mov    0x805020,%eax
  803aef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af8:	89 d0                	mov    %edx,%eax
  803afa:	01 c0                	add    %eax,%eax
  803afc:	01 d0                	add    %edx,%eax
  803afe:	c1 e0 03             	shl    $0x3,%eax
  803b01:	01 c8                	add    %ecx,%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b10:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b15:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	01 c8                	add    %ecx,%eax
  803b21:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b23:	39 c2                	cmp    %eax,%edx
  803b25:	75 09                	jne    803b30 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b27:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b2e:	eb 15                	jmp    803b45 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b30:	ff 45 e8             	incl   -0x18(%ebp)
  803b33:	a1 20 50 80 00       	mov    0x805020,%eax
  803b38:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b41:	39 c2                	cmp    %eax,%edx
  803b43:	77 85                	ja     803aca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b49:	75 14                	jne    803b5f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b4b:	83 ec 04             	sub    $0x4,%esp
  803b4e:	68 20 48 80 00       	push   $0x804820
  803b53:	6a 3a                	push   $0x3a
  803b55:	68 14 48 80 00       	push   $0x804814
  803b5a:	e8 8d fe ff ff       	call   8039ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b5f:	ff 45 f0             	incl   -0x10(%ebp)
  803b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b65:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b68:	0f 8c 2f ff ff ff    	jl     803a9d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b7c:	eb 26                	jmp    803ba4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b7e:	a1 20 50 80 00       	mov    0x805020,%eax
  803b83:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b8c:	89 d0                	mov    %edx,%eax
  803b8e:	01 c0                	add    %eax,%eax
  803b90:	01 d0                	add    %edx,%eax
  803b92:	c1 e0 03             	shl    $0x3,%eax
  803b95:	01 c8                	add    %ecx,%eax
  803b97:	8a 40 04             	mov    0x4(%eax),%al
  803b9a:	3c 01                	cmp    $0x1,%al
  803b9c:	75 03                	jne    803ba1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b9e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ba1:	ff 45 e0             	incl   -0x20(%ebp)
  803ba4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb2:	39 c2                	cmp    %eax,%edx
  803bb4:	77 c8                	ja     803b7e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bbc:	74 14                	je     803bd2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bbe:	83 ec 04             	sub    $0x4,%esp
  803bc1:	68 74 48 80 00       	push   $0x804874
  803bc6:	6a 44                	push   $0x44
  803bc8:	68 14 48 80 00       	push   $0x804814
  803bcd:	e8 1a fe ff ff       	call   8039ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bd2:	90                   	nop
  803bd3:	c9                   	leave  
  803bd4:	c3                   	ret    
  803bd5:	66 90                	xchg   %ax,%ax
  803bd7:	90                   	nop

00803bd8 <__udivdi3>:
  803bd8:	55                   	push   %ebp
  803bd9:	57                   	push   %edi
  803bda:	56                   	push   %esi
  803bdb:	53                   	push   %ebx
  803bdc:	83 ec 1c             	sub    $0x1c,%esp
  803bdf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803be3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803be7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803beb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bef:	89 ca                	mov    %ecx,%edx
  803bf1:	89 f8                	mov    %edi,%eax
  803bf3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bf7:	85 f6                	test   %esi,%esi
  803bf9:	75 2d                	jne    803c28 <__udivdi3+0x50>
  803bfb:	39 cf                	cmp    %ecx,%edi
  803bfd:	77 65                	ja     803c64 <__udivdi3+0x8c>
  803bff:	89 fd                	mov    %edi,%ebp
  803c01:	85 ff                	test   %edi,%edi
  803c03:	75 0b                	jne    803c10 <__udivdi3+0x38>
  803c05:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0a:	31 d2                	xor    %edx,%edx
  803c0c:	f7 f7                	div    %edi
  803c0e:	89 c5                	mov    %eax,%ebp
  803c10:	31 d2                	xor    %edx,%edx
  803c12:	89 c8                	mov    %ecx,%eax
  803c14:	f7 f5                	div    %ebp
  803c16:	89 c1                	mov    %eax,%ecx
  803c18:	89 d8                	mov    %ebx,%eax
  803c1a:	f7 f5                	div    %ebp
  803c1c:	89 cf                	mov    %ecx,%edi
  803c1e:	89 fa                	mov    %edi,%edx
  803c20:	83 c4 1c             	add    $0x1c,%esp
  803c23:	5b                   	pop    %ebx
  803c24:	5e                   	pop    %esi
  803c25:	5f                   	pop    %edi
  803c26:	5d                   	pop    %ebp
  803c27:	c3                   	ret    
  803c28:	39 ce                	cmp    %ecx,%esi
  803c2a:	77 28                	ja     803c54 <__udivdi3+0x7c>
  803c2c:	0f bd fe             	bsr    %esi,%edi
  803c2f:	83 f7 1f             	xor    $0x1f,%edi
  803c32:	75 40                	jne    803c74 <__udivdi3+0x9c>
  803c34:	39 ce                	cmp    %ecx,%esi
  803c36:	72 0a                	jb     803c42 <__udivdi3+0x6a>
  803c38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c3c:	0f 87 9e 00 00 00    	ja     803ce0 <__udivdi3+0x108>
  803c42:	b8 01 00 00 00       	mov    $0x1,%eax
  803c47:	89 fa                	mov    %edi,%edx
  803c49:	83 c4 1c             	add    $0x1c,%esp
  803c4c:	5b                   	pop    %ebx
  803c4d:	5e                   	pop    %esi
  803c4e:	5f                   	pop    %edi
  803c4f:	5d                   	pop    %ebp
  803c50:	c3                   	ret    
  803c51:	8d 76 00             	lea    0x0(%esi),%esi
  803c54:	31 ff                	xor    %edi,%edi
  803c56:	31 c0                	xor    %eax,%eax
  803c58:	89 fa                	mov    %edi,%edx
  803c5a:	83 c4 1c             	add    $0x1c,%esp
  803c5d:	5b                   	pop    %ebx
  803c5e:	5e                   	pop    %esi
  803c5f:	5f                   	pop    %edi
  803c60:	5d                   	pop    %ebp
  803c61:	c3                   	ret    
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	89 d8                	mov    %ebx,%eax
  803c66:	f7 f7                	div    %edi
  803c68:	31 ff                	xor    %edi,%edi
  803c6a:	89 fa                	mov    %edi,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c79:	89 eb                	mov    %ebp,%ebx
  803c7b:	29 fb                	sub    %edi,%ebx
  803c7d:	89 f9                	mov    %edi,%ecx
  803c7f:	d3 e6                	shl    %cl,%esi
  803c81:	89 c5                	mov    %eax,%ebp
  803c83:	88 d9                	mov    %bl,%cl
  803c85:	d3 ed                	shr    %cl,%ebp
  803c87:	89 e9                	mov    %ebp,%ecx
  803c89:	09 f1                	or     %esi,%ecx
  803c8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c8f:	89 f9                	mov    %edi,%ecx
  803c91:	d3 e0                	shl    %cl,%eax
  803c93:	89 c5                	mov    %eax,%ebp
  803c95:	89 d6                	mov    %edx,%esi
  803c97:	88 d9                	mov    %bl,%cl
  803c99:	d3 ee                	shr    %cl,%esi
  803c9b:	89 f9                	mov    %edi,%ecx
  803c9d:	d3 e2                	shl    %cl,%edx
  803c9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca3:	88 d9                	mov    %bl,%cl
  803ca5:	d3 e8                	shr    %cl,%eax
  803ca7:	09 c2                	or     %eax,%edx
  803ca9:	89 d0                	mov    %edx,%eax
  803cab:	89 f2                	mov    %esi,%edx
  803cad:	f7 74 24 0c          	divl   0xc(%esp)
  803cb1:	89 d6                	mov    %edx,%esi
  803cb3:	89 c3                	mov    %eax,%ebx
  803cb5:	f7 e5                	mul    %ebp
  803cb7:	39 d6                	cmp    %edx,%esi
  803cb9:	72 19                	jb     803cd4 <__udivdi3+0xfc>
  803cbb:	74 0b                	je     803cc8 <__udivdi3+0xf0>
  803cbd:	89 d8                	mov    %ebx,%eax
  803cbf:	31 ff                	xor    %edi,%edi
  803cc1:	e9 58 ff ff ff       	jmp    803c1e <__udivdi3+0x46>
  803cc6:	66 90                	xchg   %ax,%ax
  803cc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ccc:	89 f9                	mov    %edi,%ecx
  803cce:	d3 e2                	shl    %cl,%edx
  803cd0:	39 c2                	cmp    %eax,%edx
  803cd2:	73 e9                	jae    803cbd <__udivdi3+0xe5>
  803cd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cd7:	31 ff                	xor    %edi,%edi
  803cd9:	e9 40 ff ff ff       	jmp    803c1e <__udivdi3+0x46>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	31 c0                	xor    %eax,%eax
  803ce2:	e9 37 ff ff ff       	jmp    803c1e <__udivdi3+0x46>
  803ce7:	90                   	nop

00803ce8 <__umoddi3>:
  803ce8:	55                   	push   %ebp
  803ce9:	57                   	push   %edi
  803cea:	56                   	push   %esi
  803ceb:	53                   	push   %ebx
  803cec:	83 ec 1c             	sub    $0x1c,%esp
  803cef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d07:	89 f3                	mov    %esi,%ebx
  803d09:	89 fa                	mov    %edi,%edx
  803d0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0f:	89 34 24             	mov    %esi,(%esp)
  803d12:	85 c0                	test   %eax,%eax
  803d14:	75 1a                	jne    803d30 <__umoddi3+0x48>
  803d16:	39 f7                	cmp    %esi,%edi
  803d18:	0f 86 a2 00 00 00    	jbe    803dc0 <__umoddi3+0xd8>
  803d1e:	89 c8                	mov    %ecx,%eax
  803d20:	89 f2                	mov    %esi,%edx
  803d22:	f7 f7                	div    %edi
  803d24:	89 d0                	mov    %edx,%eax
  803d26:	31 d2                	xor    %edx,%edx
  803d28:	83 c4 1c             	add    $0x1c,%esp
  803d2b:	5b                   	pop    %ebx
  803d2c:	5e                   	pop    %esi
  803d2d:	5f                   	pop    %edi
  803d2e:	5d                   	pop    %ebp
  803d2f:	c3                   	ret    
  803d30:	39 f0                	cmp    %esi,%eax
  803d32:	0f 87 ac 00 00 00    	ja     803de4 <__umoddi3+0xfc>
  803d38:	0f bd e8             	bsr    %eax,%ebp
  803d3b:	83 f5 1f             	xor    $0x1f,%ebp
  803d3e:	0f 84 ac 00 00 00    	je     803df0 <__umoddi3+0x108>
  803d44:	bf 20 00 00 00       	mov    $0x20,%edi
  803d49:	29 ef                	sub    %ebp,%edi
  803d4b:	89 fe                	mov    %edi,%esi
  803d4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d51:	89 e9                	mov    %ebp,%ecx
  803d53:	d3 e0                	shl    %cl,%eax
  803d55:	89 d7                	mov    %edx,%edi
  803d57:	89 f1                	mov    %esi,%ecx
  803d59:	d3 ef                	shr    %cl,%edi
  803d5b:	09 c7                	or     %eax,%edi
  803d5d:	89 e9                	mov    %ebp,%ecx
  803d5f:	d3 e2                	shl    %cl,%edx
  803d61:	89 14 24             	mov    %edx,(%esp)
  803d64:	89 d8                	mov    %ebx,%eax
  803d66:	d3 e0                	shl    %cl,%eax
  803d68:	89 c2                	mov    %eax,%edx
  803d6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d6e:	d3 e0                	shl    %cl,%eax
  803d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d78:	89 f1                	mov    %esi,%ecx
  803d7a:	d3 e8                	shr    %cl,%eax
  803d7c:	09 d0                	or     %edx,%eax
  803d7e:	d3 eb                	shr    %cl,%ebx
  803d80:	89 da                	mov    %ebx,%edx
  803d82:	f7 f7                	div    %edi
  803d84:	89 d3                	mov    %edx,%ebx
  803d86:	f7 24 24             	mull   (%esp)
  803d89:	89 c6                	mov    %eax,%esi
  803d8b:	89 d1                	mov    %edx,%ecx
  803d8d:	39 d3                	cmp    %edx,%ebx
  803d8f:	0f 82 87 00 00 00    	jb     803e1c <__umoddi3+0x134>
  803d95:	0f 84 91 00 00 00    	je     803e2c <__umoddi3+0x144>
  803d9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d9f:	29 f2                	sub    %esi,%edx
  803da1:	19 cb                	sbb    %ecx,%ebx
  803da3:	89 d8                	mov    %ebx,%eax
  803da5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803da9:	d3 e0                	shl    %cl,%eax
  803dab:	89 e9                	mov    %ebp,%ecx
  803dad:	d3 ea                	shr    %cl,%edx
  803daf:	09 d0                	or     %edx,%eax
  803db1:	89 e9                	mov    %ebp,%ecx
  803db3:	d3 eb                	shr    %cl,%ebx
  803db5:	89 da                	mov    %ebx,%edx
  803db7:	83 c4 1c             	add    $0x1c,%esp
  803dba:	5b                   	pop    %ebx
  803dbb:	5e                   	pop    %esi
  803dbc:	5f                   	pop    %edi
  803dbd:	5d                   	pop    %ebp
  803dbe:	c3                   	ret    
  803dbf:	90                   	nop
  803dc0:	89 fd                	mov    %edi,%ebp
  803dc2:	85 ff                	test   %edi,%edi
  803dc4:	75 0b                	jne    803dd1 <__umoddi3+0xe9>
  803dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcb:	31 d2                	xor    %edx,%edx
  803dcd:	f7 f7                	div    %edi
  803dcf:	89 c5                	mov    %eax,%ebp
  803dd1:	89 f0                	mov    %esi,%eax
  803dd3:	31 d2                	xor    %edx,%edx
  803dd5:	f7 f5                	div    %ebp
  803dd7:	89 c8                	mov    %ecx,%eax
  803dd9:	f7 f5                	div    %ebp
  803ddb:	89 d0                	mov    %edx,%eax
  803ddd:	e9 44 ff ff ff       	jmp    803d26 <__umoddi3+0x3e>
  803de2:	66 90                	xchg   %ax,%ax
  803de4:	89 c8                	mov    %ecx,%eax
  803de6:	89 f2                	mov    %esi,%edx
  803de8:	83 c4 1c             	add    $0x1c,%esp
  803deb:	5b                   	pop    %ebx
  803dec:	5e                   	pop    %esi
  803ded:	5f                   	pop    %edi
  803dee:	5d                   	pop    %ebp
  803def:	c3                   	ret    
  803df0:	3b 04 24             	cmp    (%esp),%eax
  803df3:	72 06                	jb     803dfb <__umoddi3+0x113>
  803df5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803df9:	77 0f                	ja     803e0a <__umoddi3+0x122>
  803dfb:	89 f2                	mov    %esi,%edx
  803dfd:	29 f9                	sub    %edi,%ecx
  803dff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e03:	89 14 24             	mov    %edx,(%esp)
  803e06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e0e:	8b 14 24             	mov    (%esp),%edx
  803e11:	83 c4 1c             	add    $0x1c,%esp
  803e14:	5b                   	pop    %ebx
  803e15:	5e                   	pop    %esi
  803e16:	5f                   	pop    %edi
  803e17:	5d                   	pop    %ebp
  803e18:	c3                   	ret    
  803e19:	8d 76 00             	lea    0x0(%esi),%esi
  803e1c:	2b 04 24             	sub    (%esp),%eax
  803e1f:	19 fa                	sbb    %edi,%edx
  803e21:	89 d1                	mov    %edx,%ecx
  803e23:	89 c6                	mov    %eax,%esi
  803e25:	e9 71 ff ff ff       	jmp    803d9b <__umoddi3+0xb3>
  803e2a:	66 90                	xchg   %ax,%ax
  803e2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e30:	72 ea                	jb     803e1c <__umoddi3+0x134>
  803e32:	89 d9                	mov    %ebx,%ecx
  803e34:	e9 62 ff ff ff       	jmp    803d9b <__umoddi3+0xb3>

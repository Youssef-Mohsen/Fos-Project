
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
  800044:	e8 45 1c 00 00       	call   801c8e <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 69 3f 80 00       	mov    $0x803f69,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 73 3f 80 00       	mov    $0x803f73,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 7f 3f 80 00       	mov    $0x803f7f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 8e 3f 80 00       	mov    $0x803f8e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 9d 3f 80 00       	mov    $0x803f9d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb b2 3f 80 00       	mov    $0x803fb2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb c7 3f 80 00       	mov    $0x803fc7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb d8 3f 80 00       	mov    $0x803fd8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb e9 3f 80 00       	mov    $0x803fe9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb fa 3f 80 00       	mov    $0x803ffa,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 03 40 80 00       	mov    $0x804003,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 0d 40 80 00       	mov    $0x80400d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 18 40 80 00       	mov    $0x804018,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 24 40 80 00       	mov    $0x804024,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 2e 40 80 00       	mov    $0x80402e,%ebx
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
  8001be:	bb 38 40 80 00       	mov    $0x804038,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 46 40 80 00       	mov    $0x804046,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 55 40 80 00       	mov    $0x804055,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 5c 40 80 00       	mov    $0x80405c,%ebx
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
  800222:	e8 0b 16 00 00       	call   801832 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 f6 15 00 00       	call   801832 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 de 15 00 00       	call   801832 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 c6 15 00 00       	call   801832 <sget>
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
  800286:	e8 dd 37 00 00       	call   803a68 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 c1 37 00 00       	call   803a68 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 a5 37 00 00       	call   803a68 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 89 37 00 00       	call   803a68 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 6d 37 00 00       	call   803a68 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 76 37 00 00       	call   803a82 <wait_semaphore>
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
  80032d:	e8 6a 37 00 00       	call   803a9c <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 3f 37 00 00       	call   803a82 <wait_semaphore>
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
  800363:	e8 1a 37 00 00       	call   803a82 <wait_semaphore>
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
  800397:	e8 00 37 00 00       	call   803a9c <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 ef 36 00 00       	call   803a9c <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 63 40 80 00       	mov    $0x804063,%ebx
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
  800425:	e8 3e 36 00 00       	call   803a68 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 47 36 00 00       	call   803a82 <wait_semaphore>
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
  80045e:	68 20 3f 80 00       	push   $0x803f20
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 48 3f 80 00       	push   $0x803f48
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 0e 36 00 00       	call   803a9c <signal_semaphore>
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
  8004a0:	e8 d0 17 00 00       	call   801c75 <sys_getenvindex>
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
  80050e:	e8 e6 14 00 00       	call   8019f9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 9c 40 80 00       	push   $0x80409c
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
  80053e:	68 c4 40 80 00       	push   $0x8040c4
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
  80056f:	68 ec 40 80 00       	push   $0x8040ec
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 44 41 80 00       	push   $0x804144
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 9c 40 80 00       	push   $0x80409c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 66 14 00 00       	call   801a13 <sys_unlock_cons>
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
  8005c0:	e8 7c 16 00 00       	call   801c41 <sys_destroy_env>
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
  8005d1:	e8 d1 16 00 00       	call   801ca7 <sys_exit_env>
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
  80061f:	e8 93 13 00 00       	call   8019b7 <sys_cputs>
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
  800696:	e8 1c 13 00 00       	call   8019b7 <sys_cputs>
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
  8006e0:	e8 14 13 00 00       	call   8019f9 <sys_lock_cons>
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
  800700:	e8 0e 13 00 00       	call   801a13 <sys_unlock_cons>
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
  80074a:	e8 5d 35 00 00       	call   803cac <__udivdi3>
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
  80079a:	e8 1d 36 00 00       	call   803dbc <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 74 43 80 00       	add    $0x804374,%eax
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
  8008f5:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  8009d6:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 85 43 80 00       	push   $0x804385
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
  8009fb:	68 8e 43 80 00       	push   $0x80438e
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
  800a28:	be 91 43 80 00       	mov    $0x804391,%esi
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
  801433:	68 08 45 80 00       	push   $0x804508
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 2a 45 80 00       	push   $0x80452a
  801442:	e8 7a 26 00 00       	call   803ac1 <_panic>

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
  801453:	e8 0a 0b 00 00       	call   801f62 <sys_sbrk>
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
  8014ce:	e8 13 09 00 00       	call   801de6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 53 0e 00 00       	call   802335 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 25 09 00 00       	call   801e17 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 ec 12 00 00       	call   8027f1 <alloc_block_BF>
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
  801550:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80159d:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801656:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	ff 75 f0             	pushl  -0x10(%ebp)
  801666:	e8 2e 09 00 00       	call   801f99 <sys_allocate_user_mem>
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
  8016ae:	e8 02 09 00 00       	call   801fb5 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 35 1b 00 00       	call   8031f9 <free_block>
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
  8016f9:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801736:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801756:	e8 22 08 00 00       	call   801f7d <sys_free_user_mem>
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
  801764:	68 38 45 80 00       	push   $0x804538
  801769:	68 85 00 00 00       	push   $0x85
  80176e:	68 62 45 80 00       	push   $0x804562
  801773:	e8 49 23 00 00       	call   803ac1 <_panic>
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
  80178a:	75 0a                	jne    801796 <smalloc+0x1c>
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	e9 9a 00 00 00       	jmp    801830 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a9:	39 d0                	cmp    %edx,%eax
  8017ab:	73 02                	jae    8017af <smalloc+0x35>
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	83 ec 0c             	sub    $0xc,%esp
  8017b2:	50                   	push   %eax
  8017b3:	e8 a5 fc ff ff       	call   80145d <malloc>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c2:	75 07                	jne    8017cb <smalloc+0x51>
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	eb 65                	jmp    801830 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017cb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 a6 03 00 00       	call   801b84 <sys_createSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e8:	74 06                	je     8017f0 <smalloc+0x76>
  8017ea:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ee:	75 07                	jne    8017f7 <smalloc+0x7d>
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	eb 39                	jmp    801830 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8017f7:	83 ec 08             	sub    $0x8,%esp
  8017fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8017fd:	68 6e 45 80 00       	push   $0x80456e
  801802:	e8 a6 ee ff ff       	call   8006ad <cprintf>
  801807:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80180a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80180d:	a1 20 50 80 00       	mov    0x805020,%eax
  801812:	8b 40 78             	mov    0x78(%eax),%eax
  801815:	29 c2                	sub    %eax,%edx
  801817:	89 d0                	mov    %edx,%eax
  801819:	2d 00 10 00 00       	sub    $0x1000,%eax
  80181e:	c1 e8 0c             	shr    $0xc,%eax
  801821:	89 c2                	mov    %eax,%edx
  801823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801826:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	e8 68 03 00 00       	call   801bae <sys_getSizeOfSharedObject>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80184c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801850:	75 07                	jne    801859 <sget+0x27>
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	eb 7f                	jmp    8018d8 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80185f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801866:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186c:	39 d0                	cmp    %edx,%eax
  80186e:	7d 02                	jge    801872 <sget+0x40>
  801870:	89 d0                	mov    %edx,%eax
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	50                   	push   %eax
  801876:	e8 e2 fb ff ff       	call   80145d <malloc>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801881:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801885:	75 07                	jne    80188e <sget+0x5c>
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	eb 4a                	jmp    8018d8 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	ff 75 e8             	pushl  -0x18(%ebp)
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 2c 03 00 00       	call   801bcb <sys_getSharedObject>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8018a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ad:	8b 40 78             	mov    0x78(%eax),%eax
  8018b0:	29 c2                	sub    %eax,%edx
  8018b2:	89 d0                	mov    %edx,%eax
  8018b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b9:	c1 e8 0c             	shr    $0xc,%eax
  8018bc:	89 c2                	mov    %eax,%edx
  8018be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c1:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018c8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018cc:	75 07                	jne    8018d5 <sget+0xa3>
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d3:	eb 03                	jmp    8018d8 <sget+0xa6>
	return ptr;
  8018d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8018e8:	8b 40 78             	mov    0x78(%eax),%eax
  8018eb:	29 c2                	sub    %eax,%edx
  8018ed:	89 d0                	mov    %edx,%eax
  8018ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018f4:	c1 e8 0c             	shr    $0xc,%eax
  8018f7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	ff 75 f4             	pushl  -0xc(%ebp)
  80190a:	e8 db 02 00 00       	call   801bea <sys_freeSharedObject>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 80 45 80 00       	push   $0x804580
  801926:	68 de 00 00 00       	push   $0xde
  80192b:	68 62 45 80 00       	push   $0x804562
  801930:	e8 8c 21 00 00       	call   803ac1 <_panic>

00801935 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 a6 45 80 00       	push   $0x8045a6
  801943:	68 ea 00 00 00       	push   $0xea
  801948:	68 62 45 80 00       	push   $0x804562
  80194d:	e8 6f 21 00 00       	call   803ac1 <_panic>

00801952 <shrink>:

}
void shrink(uint32 newSize)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 a6 45 80 00       	push   $0x8045a6
  801960:	68 ef 00 00 00       	push   $0xef
  801965:	68 62 45 80 00       	push   $0x804562
  80196a:	e8 52 21 00 00       	call   803ac1 <_panic>

0080196f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	68 a6 45 80 00       	push   $0x8045a6
  80197d:	68 f4 00 00 00       	push   $0xf4
  801982:	68 62 45 80 00       	push   $0x804562
  801987:	e8 35 21 00 00       	call   803ac1 <_panic>

0080198c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a7:	cd 30                	int    $0x30
  8019a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	5b                   	pop    %ebx
  8019b3:	5e                   	pop    %esi
  8019b4:	5f                   	pop    %edi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	52                   	push   %edx
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	e8 b2 ff ff ff       	call   80198c <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 02                	push   $0x2
  8019ef:	e8 98 ff ff ff       	call   80198c <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 03                	push   $0x3
  801a08:	e8 7f ff ff ff       	call   80198c <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	90                   	nop
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 04                	push   $0x4
  801a22:	e8 65 ff ff ff       	call   80198c <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	90                   	nop
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 08                	push   $0x8
  801a40:	e8 47 ff ff ff       	call   80198c <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	56                   	push   %esi
  801a4e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a4f:	8b 75 18             	mov    0x18(%ebp),%esi
  801a52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	51                   	push   %ecx
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 09                	push   $0x9
  801a65:	e8 22 ff ff ff       	call   80198c <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    

00801a74 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 0a                	push   $0xa
  801a87:	e8 00 ff ff ff       	call   80198c <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	6a 0b                	push   $0xb
  801aa2:	e8 e5 fe ff ff       	call   80198c <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 0c                	push   $0xc
  801abb:	e8 cc fe ff ff       	call   80198c <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 0d                	push   $0xd
  801ad4:	e8 b3 fe ff ff       	call   80198c <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 0e                	push   $0xe
  801aed:	e8 9a fe ff ff       	call   80198c <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 0f                	push   $0xf
  801b06:	e8 81 fe ff ff       	call   80198c <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	6a 10                	push   $0x10
  801b20:	e8 67 fe ff ff       	call   80198c <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 11                	push   $0x11
  801b39:	e8 4e fe ff ff       	call   80198c <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	50                   	push   %eax
  801b5d:	6a 01                	push   $0x1
  801b5f:	e8 28 fe ff ff       	call   80198c <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 14                	push   $0x14
  801b79:	e8 0e fe ff ff       	call   80198c <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	51                   	push   %ecx
  801b9d:	52                   	push   %edx
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	6a 15                	push   $0x15
  801ba4:	e8 e3 fd ff ff       	call   80198c <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 16                	push   $0x16
  801bc1:	e8 c6 fd ff ff       	call   80198c <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	51                   	push   %ecx
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 17                	push   $0x17
  801be0:	e8 a7 fd ff ff       	call   80198c <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 18                	push   $0x18
  801bfd:	e8 8a fd ff ff       	call   80198c <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 14             	pushl  0x14(%ebp)
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	50                   	push   %eax
  801c19:	6a 19                	push   $0x19
  801c1b:	e8 6c fd ff ff       	call   80198c <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	50                   	push   %eax
  801c34:	6a 1a                	push   $0x1a
  801c36:	e8 51 fd ff ff       	call   80198c <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	90                   	nop
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	50                   	push   %eax
  801c50:	6a 1b                	push   $0x1b
  801c52:	e8 35 fd ff ff       	call   80198c <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 05                	push   $0x5
  801c6b:	e8 1c fd ff ff       	call   80198c <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 06                	push   $0x6
  801c84:	e8 03 fd ff ff       	call   80198c <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 07                	push   $0x7
  801c9d:	e8 ea fc ff ff       	call   80198c <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 1c                	push   $0x1c
  801cb6:	e8 d1 fc ff ff       	call   80198c <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cca:	8d 50 04             	lea    0x4(%eax),%edx
  801ccd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 1d                	push   $0x1d
  801cda:	e8 ad fc ff ff       	call   80198c <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ceb:	89 01                	mov    %eax,(%ecx)
  801ced:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	c9                   	leave  
  801cf4:	c2 04 00             	ret    $0x4

00801cf7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	ff 75 10             	pushl  0x10(%ebp)
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	6a 13                	push   $0x13
  801d09:	e8 7e fc ff ff       	call   80198c <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 1e                	push   $0x1e
  801d23:	e8 64 fc ff ff       	call   80198c <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d39:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	50                   	push   %eax
  801d46:	6a 1f                	push   $0x1f
  801d48:	e8 3f fc ff ff       	call   80198c <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d50:	90                   	nop
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <rsttst>:
void rsttst()
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 21                	push   $0x21
  801d62:	e8 25 fc ff ff       	call   80198c <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6a:	90                   	nop
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d79:	8b 55 18             	mov    0x18(%ebp),%edx
  801d7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	ff 75 10             	pushl  0x10(%ebp)
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	6a 20                	push   $0x20
  801d8d:	e8 fa fb ff ff       	call   80198c <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <chktst>:
void chktst(uint32 n)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 22                	push   $0x22
  801da8:	e8 df fb ff ff       	call   80198c <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return ;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <inctst>:

void inctst()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 23                	push   $0x23
  801dc2:	e8 c5 fb ff ff       	call   80198c <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dca:	90                   	nop
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <gettst>:
uint32 gettst()
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 24                	push   $0x24
  801ddc:	e8 ab fb ff ff       	call   80198c <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 25                	push   $0x25
  801df8:	e8 8f fb ff ff       	call   80198c <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e07:	75 07                	jne    801e10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0e:	eb 05                	jmp    801e15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 25                	push   $0x25
  801e29:	e8 5e fb ff ff       	call   80198c <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
  801e31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e38:	75 07                	jne    801e41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3f:	eb 05                	jmp    801e46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 25                	push   $0x25
  801e5a:	e8 2d fb ff ff       	call   80198c <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
  801e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e69:	75 07                	jne    801e72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e70:	eb 05                	jmp    801e77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 25                	push   $0x25
  801e8b:	e8 fc fa ff ff       	call   80198c <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
  801e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e9a:	75 07                	jne    801ea3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea1:	eb 05                	jmp    801ea8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	6a 26                	push   $0x26
  801eba:	e8 cd fa ff ff       	call   80198c <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ecc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	53                   	push   %ebx
  801ed8:	51                   	push   %ecx
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	6a 27                	push   $0x27
  801edd:	e8 aa fa ff ff       	call   80198c <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	52                   	push   %edx
  801efa:	50                   	push   %eax
  801efb:	6a 28                	push   $0x28
  801efd:	e8 8a fa ff ff       	call   80198c <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	6a 00                	push   $0x0
  801f15:	51                   	push   %ecx
  801f16:	ff 75 10             	pushl  0x10(%ebp)
  801f19:	52                   	push   %edx
  801f1a:	50                   	push   %eax
  801f1b:	6a 29                	push   $0x29
  801f1d:	e8 6a fa ff ff       	call   80198c <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	6a 12                	push   $0x12
  801f39:	e8 4e fa ff ff       	call   80198c <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 2a                	push   $0x2a
  801f57:	e8 30 fa ff ff       	call   80198c <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	50                   	push   %eax
  801f71:	6a 2b                	push   $0x2b
  801f73:	e8 14 fa ff ff       	call   80198c <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	6a 2c                	push   $0x2c
  801f8e:	e8 f9 f9 ff ff       	call   80198c <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
	return;
  801f96:	90                   	nop
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	6a 2d                	push   $0x2d
  801faa:	e8 dd f9 ff ff       	call   80198c <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
	return;
  801fb2:	90                   	nop
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	83 e8 04             	sub    $0x4,%eax
  801fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	83 e8 04             	sub    $0x4,%eax
  801fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe0:	8b 00                	mov    (%eax),%eax
  801fe2:	83 e0 01             	and    $0x1,%eax
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	0f 94 c0             	sete   %al
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffc:	83 f8 02             	cmp    $0x2,%eax
  801fff:	74 2b                	je     80202c <alloc_block+0x40>
  802001:	83 f8 02             	cmp    $0x2,%eax
  802004:	7f 07                	jg     80200d <alloc_block+0x21>
  802006:	83 f8 01             	cmp    $0x1,%eax
  802009:	74 0e                	je     802019 <alloc_block+0x2d>
  80200b:	eb 58                	jmp    802065 <alloc_block+0x79>
  80200d:	83 f8 03             	cmp    $0x3,%eax
  802010:	74 2d                	je     80203f <alloc_block+0x53>
  802012:	83 f8 04             	cmp    $0x4,%eax
  802015:	74 3b                	je     802052 <alloc_block+0x66>
  802017:	eb 4c                	jmp    802065 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	e8 11 03 00 00       	call   802335 <alloc_block_FF>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202a:	eb 4a                	jmp    802076 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	e8 fa 19 00 00       	call   803a31 <alloc_block_NF>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80203d:	eb 37                	jmp    802076 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 a7 07 00 00       	call   8027f1 <alloc_block_BF>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802050:	eb 24                	jmp    802076 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 75 08             	pushl  0x8(%ebp)
  802058:	e8 b7 19 00 00       	call   803a14 <alloc_block_WF>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802063:	eb 11                	jmp    802076 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 b8 45 80 00       	push   $0x8045b8
  80206d:	e8 3b e6 ff ff       	call   8006ad <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
		break;
  802075:	90                   	nop
	}
	return va;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	53                   	push   %ebx
  80207f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	68 d8 45 80 00       	push   $0x8045d8
  80208a:	e8 1e e6 ff ff       	call   8006ad <cprintf>
  80208f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	68 03 46 80 00       	push   $0x804603
  80209a:	e8 0e e6 ff ff       	call   8006ad <cprintf>
  80209f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a8:	eb 37                	jmp    8020e1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b0:	e8 19 ff ff ff       	call   801fce <is_free_block>
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	0f be d8             	movsbl %al,%ebx
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c1:	e8 ef fe ff ff       	call   801fb5 <get_block_size>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	53                   	push   %ebx
  8020cd:	50                   	push   %eax
  8020ce:	68 1b 46 80 00       	push   $0x80461b
  8020d3:	e8 d5 e5 ff ff       	call   8006ad <cprintf>
  8020d8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020db:	8b 45 10             	mov    0x10(%ebp),%eax
  8020de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e5:	74 07                	je     8020ee <print_blocks_list+0x73>
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	eb 05                	jmp    8020f3 <print_blocks_list+0x78>
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	89 45 10             	mov    %eax,0x10(%ebp)
  8020f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	75 ad                	jne    8020aa <print_blocks_list+0x2f>
  8020fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802101:	75 a7                	jne    8020aa <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802103:	83 ec 0c             	sub    $0xc,%esp
  802106:	68 d8 45 80 00       	push   $0x8045d8
  80210b:	e8 9d e5 ff ff       	call   8006ad <cprintf>
  802110:	83 c4 10             	add    $0x10,%esp

}
  802113:	90                   	nop
  802114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80211f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802122:	83 e0 01             	and    $0x1,%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	74 03                	je     80212c <initialize_dynamic_allocator+0x13>
  802129:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80212c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802130:	0f 84 c7 01 00 00    	je     8022fd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802136:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80213d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802140:	8b 55 08             	mov    0x8(%ebp),%edx
  802143:	8b 45 0c             	mov    0xc(%ebp),%eax
  802146:	01 d0                	add    %edx,%eax
  802148:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80214d:	0f 87 ad 01 00 00    	ja     802300 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	0f 89 a5 01 00 00    	jns    802303 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	8b 45 0c             	mov    0xc(%ebp),%eax
  802164:	01 d0                	add    %edx,%eax
  802166:	83 e8 04             	sub    $0x4,%eax
  802169:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80216e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802175:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80217a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217d:	e9 87 00 00 00       	jmp    802209 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802182:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802186:	75 14                	jne    80219c <initialize_dynamic_allocator+0x83>
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	68 33 46 80 00       	push   $0x804633
  802190:	6a 79                	push   $0x79
  802192:	68 51 46 80 00       	push   $0x804651
  802197:	e8 25 19 00 00       	call   803ac1 <_panic>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 10                	je     8021b5 <initialize_dynamic_allocator+0x9c>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ad:	8b 52 04             	mov    0x4(%edx),%edx
  8021b0:	89 50 04             	mov    %edx,0x4(%eax)
  8021b3:	eb 0b                	jmp    8021c0 <initialize_dynamic_allocator+0xa7>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 40 04             	mov    0x4(%eax),%eax
  8021bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 40 04             	mov    0x4(%eax),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 0f                	je     8021d9 <initialize_dynamic_allocator+0xc0>
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 40 04             	mov    0x4(%eax),%eax
  8021d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d3:	8b 12                	mov    (%edx),%edx
  8021d5:	89 10                	mov    %edx,(%eax)
  8021d7:	eb 0a                	jmp    8021e3 <initialize_dynamic_allocator+0xca>
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8021fb:	48                   	dec    %eax
  8021fc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802201:	a1 34 50 80 00       	mov    0x805034,%eax
  802206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220d:	74 07                	je     802216 <initialize_dynamic_allocator+0xfd>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	eb 05                	jmp    80221b <initialize_dynamic_allocator+0x102>
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
  80221b:	a3 34 50 80 00       	mov    %eax,0x805034
  802220:	a1 34 50 80 00       	mov    0x805034,%eax
  802225:	85 c0                	test   %eax,%eax
  802227:	0f 85 55 ff ff ff    	jne    802182 <initialize_dynamic_allocator+0x69>
  80222d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802231:	0f 85 4b ff ff ff    	jne    802182 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802246:	a1 44 50 80 00       	mov    0x805044,%eax
  80224b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802250:	a1 40 50 80 00       	mov    0x805040,%eax
  802255:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	83 c0 08             	add    $0x8,%eax
  802261:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	83 c0 04             	add    $0x4,%eax
  80226a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226d:	83 ea 08             	sub    $0x8,%edx
  802270:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802272:	8b 55 0c             	mov    0xc(%ebp),%edx
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	01 d0                	add    %edx,%eax
  80227a:	83 e8 08             	sub    $0x8,%eax
  80227d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802280:	83 ea 08             	sub    $0x8,%edx
  802283:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802298:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80229c:	75 17                	jne    8022b5 <initialize_dynamic_allocator+0x19c>
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	68 6c 46 80 00       	push   $0x80466c
  8022a6:	68 90 00 00 00       	push   $0x90
  8022ab:	68 51 46 80 00       	push   $0x804651
  8022b0:	e8 0c 18 00 00       	call   803ac1 <_panic>
  8022b5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0d                	je     8022d6 <initialize_dynamic_allocator+0x1bd>
  8022c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d1:	89 50 04             	mov    %edx,0x4(%eax)
  8022d4:	eb 08                	jmp    8022de <initialize_dynamic_allocator+0x1c5>
  8022d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8022de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f5:	40                   	inc    %eax
  8022f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8022fb:	eb 07                	jmp    802304 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022fd:	90                   	nop
  8022fe:	eb 04                	jmp    802304 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802300:	90                   	nop
  802301:	eb 01                	jmp    802304 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802303:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802309:	8b 45 10             	mov    0x10(%ebp),%eax
  80230c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8d 50 fc             	lea    -0x4(%eax),%edx
  802315:	8b 45 0c             	mov    0xc(%ebp),%eax
  802318:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	83 e8 04             	sub    $0x4,%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	83 e0 fe             	and    $0xfffffffe,%eax
  802325:	8d 50 f8             	lea    -0x8(%eax),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	01 c2                	add    %eax,%edx
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 02                	mov    %eax,(%edx)
}
  802332:	90                   	nop
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    

00802335 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	83 e0 01             	and    $0x1,%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 03                	je     802348 <alloc_block_FF+0x13>
  802345:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802348:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80234c:	77 07                	ja     802355 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80234e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802355:	a1 24 50 80 00       	mov    0x805024,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	75 73                	jne    8023d1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	83 c0 10             	add    $0x10,%eax
  802364:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802367:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80236e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802374:	01 d0                	add    %edx,%eax
  802376:	48                   	dec    %eax
  802377:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80237a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80237d:	ba 00 00 00 00       	mov    $0x0,%edx
  802382:	f7 75 ec             	divl   -0x14(%ebp)
  802385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802388:	29 d0                	sub    %edx,%eax
  80238a:	c1 e8 0c             	shr    $0xc,%eax
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	50                   	push   %eax
  802391:	e8 b1 f0 ff ff       	call   801447 <sbrk>
  802396:	83 c4 10             	add    $0x10,%esp
  802399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	6a 00                	push   $0x0
  8023a1:	e8 a1 f0 ff ff       	call   801447 <sbrk>
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023af:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023b2:	83 ec 08             	sub    $0x8,%esp
  8023b5:	50                   	push   %eax
  8023b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023b9:	e8 5b fd ff ff       	call   802119 <initialize_dynamic_allocator>
  8023be:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023c1:	83 ec 0c             	sub    $0xc,%esp
  8023c4:	68 8f 46 80 00       	push   $0x80468f
  8023c9:	e8 df e2 ff ff       	call   8006ad <cprintf>
  8023ce:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d5:	75 0a                	jne    8023e1 <alloc_block_FF+0xac>
	        return NULL;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	e9 0e 04 00 00       	jmp    8027ef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f0:	e9 f3 02 00 00       	jmp    8026e8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023fb:	83 ec 0c             	sub    $0xc,%esp
  8023fe:	ff 75 bc             	pushl  -0x44(%ebp)
  802401:	e8 af fb ff ff       	call   801fb5 <get_block_size>
  802406:	83 c4 10             	add    $0x10,%esp
  802409:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	83 c0 08             	add    $0x8,%eax
  802412:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802415:	0f 87 c5 02 00 00    	ja     8026e0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	83 c0 18             	add    $0x18,%eax
  802421:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802424:	0f 87 19 02 00 00    	ja     802643 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80242a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80242d:	2b 45 08             	sub    0x8(%ebp),%eax
  802430:	83 e8 08             	sub    $0x8,%eax
  802433:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	8d 50 08             	lea    0x8(%eax),%edx
  80243c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80243f:	01 d0                	add    %edx,%eax
  802441:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	83 c0 08             	add    $0x8,%eax
  80244a:	83 ec 04             	sub    $0x4,%esp
  80244d:	6a 01                	push   $0x1
  80244f:	50                   	push   %eax
  802450:	ff 75 bc             	pushl  -0x44(%ebp)
  802453:	e8 ae fe ff ff       	call   802306 <set_block_data>
  802458:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 04             	mov    0x4(%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	75 68                	jne    8024cd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802465:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802469:	75 17                	jne    802482 <alloc_block_FF+0x14d>
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	68 6c 46 80 00       	push   $0x80466c
  802473:	68 d7 00 00 00       	push   $0xd7
  802478:	68 51 46 80 00       	push   $0x804651
  80247d:	e8 3f 16 00 00       	call   803ac1 <_panic>
  802482:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802488:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248b:	89 10                	mov    %edx,(%eax)
  80248d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	74 0d                	je     8024a3 <alloc_block_FF+0x16e>
  802496:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80249b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80249e:	89 50 04             	mov    %edx,0x4(%eax)
  8024a1:	eb 08                	jmp    8024ab <alloc_block_FF+0x176>
  8024a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c2:	40                   	inc    %eax
  8024c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8024c8:	e9 dc 00 00 00       	jmp    8025a9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	75 65                	jne    80253b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024d6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024da:	75 17                	jne    8024f3 <alloc_block_FF+0x1be>
  8024dc:	83 ec 04             	sub    $0x4,%esp
  8024df:	68 a0 46 80 00       	push   $0x8046a0
  8024e4:	68 db 00 00 00       	push   $0xdb
  8024e9:	68 51 46 80 00       	push   $0x804651
  8024ee:	e8 ce 15 00 00       	call   803ac1 <_panic>
  8024f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fc:	89 50 04             	mov    %edx,0x4(%eax)
  8024ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 0c                	je     802515 <alloc_block_FF+0x1e0>
  802509:	a1 30 50 80 00       	mov    0x805030,%eax
  80250e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802511:	89 10                	mov    %edx,(%eax)
  802513:	eb 08                	jmp    80251d <alloc_block_FF+0x1e8>
  802515:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802518:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80251d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802520:	a3 30 50 80 00       	mov    %eax,0x805030
  802525:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252e:	a1 38 50 80 00       	mov    0x805038,%eax
  802533:	40                   	inc    %eax
  802534:	a3 38 50 80 00       	mov    %eax,0x805038
  802539:	eb 6e                	jmp    8025a9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	74 06                	je     802547 <alloc_block_FF+0x212>
  802541:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802545:	75 17                	jne    80255e <alloc_block_FF+0x229>
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	68 c4 46 80 00       	push   $0x8046c4
  80254f:	68 df 00 00 00       	push   $0xdf
  802554:	68 51 46 80 00       	push   $0x804651
  802559:	e8 63 15 00 00       	call   803ac1 <_panic>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 10                	mov    (%eax),%edx
  802563:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802566:	89 10                	mov    %edx,(%eax)
  802568:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 0b                	je     80257c <alloc_block_FF+0x247>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802579:	89 50 04             	mov    %edx,0x4(%eax)
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802582:	89 10                	mov    %edx,(%eax)
  802584:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802587:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258a:	89 50 04             	mov    %edx,0x4(%eax)
  80258d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	75 08                	jne    80259e <alloc_block_FF+0x269>
  802596:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802599:	a3 30 50 80 00       	mov    %eax,0x805030
  80259e:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a3:	40                   	inc    %eax
  8025a4:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ad:	75 17                	jne    8025c6 <alloc_block_FF+0x291>
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	68 33 46 80 00       	push   $0x804633
  8025b7:	68 e1 00 00 00       	push   $0xe1
  8025bc:	68 51 46 80 00       	push   $0x804651
  8025c1:	e8 fb 14 00 00       	call   803ac1 <_panic>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 10                	je     8025df <alloc_block_FF+0x2aa>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d7:	8b 52 04             	mov    0x4(%edx),%edx
  8025da:	89 50 04             	mov    %edx,0x4(%eax)
  8025dd:	eb 0b                	jmp    8025ea <alloc_block_FF+0x2b5>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 04             	mov    0x4(%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 0f                	je     802603 <alloc_block_FF+0x2ce>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 04             	mov    0x4(%eax),%eax
  8025fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fd:	8b 12                	mov    (%edx),%edx
  8025ff:	89 10                	mov    %edx,(%eax)
  802601:	eb 0a                	jmp    80260d <alloc_block_FF+0x2d8>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802620:	a1 38 50 80 00       	mov    0x805038,%eax
  802625:	48                   	dec    %eax
  802626:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	6a 00                	push   $0x0
  802630:	ff 75 b4             	pushl  -0x4c(%ebp)
  802633:	ff 75 b0             	pushl  -0x50(%ebp)
  802636:	e8 cb fc ff ff       	call   802306 <set_block_data>
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	e9 95 00 00 00       	jmp    8026d8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	6a 01                	push   $0x1
  802648:	ff 75 b8             	pushl  -0x48(%ebp)
  80264b:	ff 75 bc             	pushl  -0x44(%ebp)
  80264e:	e8 b3 fc ff ff       	call   802306 <set_block_data>
  802653:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265a:	75 17                	jne    802673 <alloc_block_FF+0x33e>
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	68 33 46 80 00       	push   $0x804633
  802664:	68 e8 00 00 00       	push   $0xe8
  802669:	68 51 46 80 00       	push   $0x804651
  80266e:	e8 4e 14 00 00       	call   803ac1 <_panic>
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 10                	je     80268c <alloc_block_FF+0x357>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802684:	8b 52 04             	mov    0x4(%edx),%edx
  802687:	89 50 04             	mov    %edx,0x4(%eax)
  80268a:	eb 0b                	jmp    802697 <alloc_block_FF+0x362>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 04             	mov    0x4(%eax),%eax
  802692:	a3 30 50 80 00       	mov    %eax,0x805030
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 04             	mov    0x4(%eax),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	74 0f                	je     8026b0 <alloc_block_FF+0x37b>
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	8b 12                	mov    (%edx),%edx
  8026ac:	89 10                	mov    %edx,(%eax)
  8026ae:	eb 0a                	jmp    8026ba <alloc_block_FF+0x385>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d2:	48                   	dec    %eax
  8026d3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026db:	e9 0f 01 00 00       	jmp    8027ef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8026e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ec:	74 07                	je     8026f5 <alloc_block_FF+0x3c0>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	eb 05                	jmp    8026fa <alloc_block_FF+0x3c5>
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ff:	a1 34 50 80 00       	mov    0x805034,%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	0f 85 e9 fc ff ff    	jne    8023f5 <alloc_block_FF+0xc0>
  80270c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802710:	0f 85 df fc ff ff    	jne    8023f5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	83 c0 08             	add    $0x8,%eax
  80271c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80271f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802726:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802729:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	48                   	dec    %eax
  80272f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802735:	ba 00 00 00 00       	mov    $0x0,%edx
  80273a:	f7 75 d8             	divl   -0x28(%ebp)
  80273d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802740:	29 d0                	sub    %edx,%eax
  802742:	c1 e8 0c             	shr    $0xc,%eax
  802745:	83 ec 0c             	sub    $0xc,%esp
  802748:	50                   	push   %eax
  802749:	e8 f9 ec ff ff       	call   801447 <sbrk>
  80274e:	83 c4 10             	add    $0x10,%esp
  802751:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802754:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802758:	75 0a                	jne    802764 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	e9 8b 00 00 00       	jmp    8027ef <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802764:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80276b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80276e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	48                   	dec    %eax
  802774:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802777:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80277a:	ba 00 00 00 00       	mov    $0x0,%edx
  80277f:	f7 75 cc             	divl   -0x34(%ebp)
  802782:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802785:	29 d0                	sub    %edx,%eax
  802787:	8d 50 fc             	lea    -0x4(%eax),%edx
  80278a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802794:	a1 40 50 80 00       	mov    0x805040,%eax
  802799:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80279f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027ac:	01 d0                	add    %edx,%eax
  8027ae:	48                   	dec    %eax
  8027af:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ba:	f7 75 c4             	divl   -0x3c(%ebp)
  8027bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027c0:	29 d0                	sub    %edx,%eax
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	6a 01                	push   $0x1
  8027c7:	50                   	push   %eax
  8027c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8027cb:	e8 36 fb ff ff       	call   802306 <set_block_data>
  8027d0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027d3:	83 ec 0c             	sub    $0xc,%esp
  8027d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8027d9:	e8 1b 0a 00 00       	call   8031f9 <free_block>
  8027de:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	ff 75 08             	pushl  0x8(%ebp)
  8027e7:	e8 49 fb ff ff       	call   802335 <alloc_block_FF>
  8027ec:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	83 e0 01             	and    $0x1,%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 03                	je     802804 <alloc_block_BF+0x13>
  802801:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802804:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802808:	77 07                	ja     802811 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80280a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802811:	a1 24 50 80 00       	mov    0x805024,%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	75 73                	jne    80288d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	83 c0 10             	add    $0x10,%eax
  802820:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802823:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80282a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802830:	01 d0                	add    %edx,%eax
  802832:	48                   	dec    %eax
  802833:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802836:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802839:	ba 00 00 00 00       	mov    $0x0,%edx
  80283e:	f7 75 e0             	divl   -0x20(%ebp)
  802841:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802844:	29 d0                	sub    %edx,%eax
  802846:	c1 e8 0c             	shr    $0xc,%eax
  802849:	83 ec 0c             	sub    $0xc,%esp
  80284c:	50                   	push   %eax
  80284d:	e8 f5 eb ff ff       	call   801447 <sbrk>
  802852:	83 c4 10             	add    $0x10,%esp
  802855:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802858:	83 ec 0c             	sub    $0xc,%esp
  80285b:	6a 00                	push   $0x0
  80285d:	e8 e5 eb ff ff       	call   801447 <sbrk>
  802862:	83 c4 10             	add    $0x10,%esp
  802865:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80286e:	83 ec 08             	sub    $0x8,%esp
  802871:	50                   	push   %eax
  802872:	ff 75 d8             	pushl  -0x28(%ebp)
  802875:	e8 9f f8 ff ff       	call   802119 <initialize_dynamic_allocator>
  80287a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80287d:	83 ec 0c             	sub    $0xc,%esp
  802880:	68 8f 46 80 00       	push   $0x80468f
  802885:	e8 23 de ff ff       	call   8006ad <cprintf>
  80288a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80288d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802894:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80289b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b1:	e9 1d 01 00 00       	jmp    8029d3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028bc:	83 ec 0c             	sub    $0xc,%esp
  8028bf:	ff 75 a8             	pushl  -0x58(%ebp)
  8028c2:	e8 ee f6 ff ff       	call   801fb5 <get_block_size>
  8028c7:	83 c4 10             	add    $0x10,%esp
  8028ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	83 c0 08             	add    $0x8,%eax
  8028d3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d6:	0f 87 ef 00 00 00    	ja     8029cb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	83 c0 18             	add    $0x18,%eax
  8028e2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e5:	77 1d                	ja     802904 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ed:	0f 86 d8 00 00 00    	jbe    8029cb <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028ff:	e9 c7 00 00 00       	jmp    8029cb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	83 c0 08             	add    $0x8,%eax
  80290a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80290d:	0f 85 9d 00 00 00    	jne    8029b0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	6a 01                	push   $0x1
  802918:	ff 75 a4             	pushl  -0x5c(%ebp)
  80291b:	ff 75 a8             	pushl  -0x58(%ebp)
  80291e:	e8 e3 f9 ff ff       	call   802306 <set_block_data>
  802923:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292a:	75 17                	jne    802943 <alloc_block_BF+0x152>
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 33 46 80 00       	push   $0x804633
  802934:	68 2c 01 00 00       	push   $0x12c
  802939:	68 51 46 80 00       	push   $0x804651
  80293e:	e8 7e 11 00 00       	call   803ac1 <_panic>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 10                	je     80295c <alloc_block_BF+0x16b>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802954:	8b 52 04             	mov    0x4(%edx),%edx
  802957:	89 50 04             	mov    %edx,0x4(%eax)
  80295a:	eb 0b                	jmp    802967 <alloc_block_BF+0x176>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	a3 30 50 80 00       	mov    %eax,0x805030
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0f                	je     802980 <alloc_block_BF+0x18f>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297a:	8b 12                	mov    (%edx),%edx
  80297c:	89 10                	mov    %edx,(%eax)
  80297e:	eb 0a                	jmp    80298a <alloc_block_BF+0x199>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299d:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a2:	48                   	dec    %eax
  8029a3:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029a8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029ab:	e9 24 04 00 00       	jmp    802dd4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b6:	76 13                	jbe    8029cb <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029b8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d7:	74 07                	je     8029e0 <alloc_block_BF+0x1ef>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	eb 05                	jmp    8029e5 <alloc_block_BF+0x1f4>
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8029ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	0f 85 bf fe ff ff    	jne    8028b6 <alloc_block_BF+0xc5>
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	0f 85 b5 fe ff ff    	jne    8028b6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a05:	0f 84 26 02 00 00    	je     802c31 <alloc_block_BF+0x440>
  802a0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a0f:	0f 85 1c 02 00 00    	jne    802c31 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1b:	83 e8 08             	sub    $0x8,%eax
  802a1e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8d 50 08             	lea    0x8(%eax),%edx
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	01 d0                	add    %edx,%eax
  802a2c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	83 c0 08             	add    $0x8,%eax
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	6a 01                	push   $0x1
  802a3a:	50                   	push   %eax
  802a3b:	ff 75 f0             	pushl  -0x10(%ebp)
  802a3e:	e8 c3 f8 ff ff       	call   802306 <set_block_data>
  802a43:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	75 68                	jne    802ab8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a50:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a54:	75 17                	jne    802a6d <alloc_block_BF+0x27c>
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 6c 46 80 00       	push   $0x80466c
  802a5e:	68 45 01 00 00       	push   $0x145
  802a63:	68 51 46 80 00       	push   $0x804651
  802a68:	e8 54 10 00 00       	call   803ac1 <_panic>
  802a6d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a76:	89 10                	mov    %edx,(%eax)
  802a78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0d                	je     802a8e <alloc_block_BF+0x29d>
  802a81:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 08                	jmp    802a96 <alloc_block_BF+0x2a5>
  802a8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a91:	a3 30 50 80 00       	mov    %eax,0x805030
  802a96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a99:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa8:	a1 38 50 80 00       	mov    0x805038,%eax
  802aad:	40                   	inc    %eax
  802aae:	a3 38 50 80 00       	mov    %eax,0x805038
  802ab3:	e9 dc 00 00 00       	jmp    802b94 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	75 65                	jne    802b26 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ac1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac5:	75 17                	jne    802ade <alloc_block_BF+0x2ed>
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	68 a0 46 80 00       	push   $0x8046a0
  802acf:	68 4a 01 00 00       	push   $0x14a
  802ad4:	68 51 46 80 00       	push   $0x804651
  802ad9:	e8 e3 0f 00 00       	call   803ac1 <_panic>
  802ade:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ae4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aed:	8b 40 04             	mov    0x4(%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 0c                	je     802b00 <alloc_block_BF+0x30f>
  802af4:	a1 30 50 80 00       	mov    0x805030,%eax
  802af9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afc:	89 10                	mov    %edx,(%eax)
  802afe:	eb 08                	jmp    802b08 <alloc_block_BF+0x317>
  802b00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b19:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1e:	40                   	inc    %eax
  802b1f:	a3 38 50 80 00       	mov    %eax,0x805038
  802b24:	eb 6e                	jmp    802b94 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2a:	74 06                	je     802b32 <alloc_block_BF+0x341>
  802b2c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_BF+0x358>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 c4 46 80 00       	push   $0x8046c4
  802b3a:	68 4f 01 00 00       	push   $0x14f
  802b3f:	68 51 46 80 00       	push   $0x804651
  802b44:	e8 78 0f 00 00       	call   803ac1 <_panic>
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	8b 10                	mov    (%eax),%edx
  802b4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0b                	je     802b67 <alloc_block_BF+0x376>
  802b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b75:	89 50 04             	mov    %edx,0x4(%eax)
  802b78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	75 08                	jne    802b89 <alloc_block_BF+0x398>
  802b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b84:	a3 30 50 80 00       	mov    %eax,0x805030
  802b89:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8e:	40                   	inc    %eax
  802b8f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b98:	75 17                	jne    802bb1 <alloc_block_BF+0x3c0>
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 33 46 80 00       	push   $0x804633
  802ba2:	68 51 01 00 00       	push   $0x151
  802ba7:	68 51 46 80 00       	push   $0x804651
  802bac:	e8 10 0f 00 00       	call   803ac1 <_panic>
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 10                	je     802bca <alloc_block_BF+0x3d9>
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc2:	8b 52 04             	mov    0x4(%edx),%edx
  802bc5:	89 50 04             	mov    %edx,0x4(%eax)
  802bc8:	eb 0b                	jmp    802bd5 <alloc_block_BF+0x3e4>
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0f                	je     802bee <alloc_block_BF+0x3fd>
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be8:	8b 12                	mov    (%edx),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	eb 0a                	jmp    802bf8 <alloc_block_BF+0x407>
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c10:	48                   	dec    %eax
  802c11:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	6a 00                	push   $0x0
  802c1b:	ff 75 d0             	pushl  -0x30(%ebp)
  802c1e:	ff 75 cc             	pushl  -0x34(%ebp)
  802c21:	e8 e0 f6 ff ff       	call   802306 <set_block_data>
  802c26:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	e9 a3 01 00 00       	jmp    802dd4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c31:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c35:	0f 85 9d 00 00 00    	jne    802cd8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	6a 01                	push   $0x1
  802c40:	ff 75 ec             	pushl  -0x14(%ebp)
  802c43:	ff 75 f0             	pushl  -0x10(%ebp)
  802c46:	e8 bb f6 ff ff       	call   802306 <set_block_data>
  802c4b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c52:	75 17                	jne    802c6b <alloc_block_BF+0x47a>
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	68 33 46 80 00       	push   $0x804633
  802c5c:	68 58 01 00 00       	push   $0x158
  802c61:	68 51 46 80 00       	push   $0x804651
  802c66:	e8 56 0e 00 00       	call   803ac1 <_panic>
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 10                	je     802c84 <alloc_block_BF+0x493>
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7c:	8b 52 04             	mov    0x4(%edx),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 0b                	jmp    802c8f <alloc_block_BF+0x49e>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 0f                	je     802ca8 <alloc_block_BF+0x4b7>
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca2:	8b 12                	mov    (%edx),%edx
  802ca4:	89 10                	mov    %edx,(%eax)
  802ca6:	eb 0a                	jmp    802cb2 <alloc_block_BF+0x4c1>
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cca:	48                   	dec    %eax
  802ccb:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd3:	e9 fc 00 00 00       	jmp    802dd4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	83 c0 08             	add    $0x8,%eax
  802cde:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ce1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ce8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ceb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cee:	01 d0                	add    %edx,%eax
  802cf0:	48                   	dec    %eax
  802cf1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cf4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfc:	f7 75 c4             	divl   -0x3c(%ebp)
  802cff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d02:	29 d0                	sub    %edx,%eax
  802d04:	c1 e8 0c             	shr    $0xc,%eax
  802d07:	83 ec 0c             	sub    $0xc,%esp
  802d0a:	50                   	push   %eax
  802d0b:	e8 37 e7 ff ff       	call   801447 <sbrk>
  802d10:	83 c4 10             	add    $0x10,%esp
  802d13:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d16:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d1a:	75 0a                	jne    802d26 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	e9 ae 00 00 00       	jmp    802dd4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d26:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d33:	01 d0                	add    %edx,%eax
  802d35:	48                   	dec    %eax
  802d36:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d39:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802d41:	f7 75 b8             	divl   -0x48(%ebp)
  802d44:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d47:	29 d0                	sub    %edx,%eax
  802d49:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d4c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d56:	a1 40 50 80 00       	mov    0x805040,%eax
  802d5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d61:	83 ec 0c             	sub    $0xc,%esp
  802d64:	68 f8 46 80 00       	push   $0x8046f8
  802d69:	e8 3f d9 ff ff       	call   8006ad <cprintf>
  802d6e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d71:	83 ec 08             	sub    $0x8,%esp
  802d74:	ff 75 bc             	pushl  -0x44(%ebp)
  802d77:	68 fd 46 80 00       	push   $0x8046fd
  802d7c:	e8 2c d9 ff ff       	call   8006ad <cprintf>
  802d81:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d84:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d8b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d91:	01 d0                	add    %edx,%eax
  802d93:	48                   	dec    %eax
  802d94:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d97:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d9f:	f7 75 b0             	divl   -0x50(%ebp)
  802da2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da5:	29 d0                	sub    %edx,%eax
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	6a 01                	push   $0x1
  802dac:	50                   	push   %eax
  802dad:	ff 75 bc             	pushl  -0x44(%ebp)
  802db0:	e8 51 f5 ff ff       	call   802306 <set_block_data>
  802db5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802db8:	83 ec 0c             	sub    $0xc,%esp
  802dbb:	ff 75 bc             	pushl  -0x44(%ebp)
  802dbe:	e8 36 04 00 00       	call   8031f9 <free_block>
  802dc3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dc6:	83 ec 0c             	sub    $0xc,%esp
  802dc9:	ff 75 08             	pushl  0x8(%ebp)
  802dcc:	e8 20 fa ff ff       	call   8027f1 <alloc_block_BF>
  802dd1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802dd4:	c9                   	leave  
  802dd5:	c3                   	ret    

00802dd6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
  802dd9:	53                   	push   %ebx
  802dda:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ddd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802de4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802def:	74 1e                	je     802e0f <merging+0x39>
  802df1:	ff 75 08             	pushl  0x8(%ebp)
  802df4:	e8 bc f1 ff ff       	call   801fb5 <get_block_size>
  802df9:	83 c4 04             	add    $0x4,%esp
  802dfc:	89 c2                	mov    %eax,%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	01 d0                	add    %edx,%eax
  802e03:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e06:	75 07                	jne    802e0f <merging+0x39>
		prev_is_free = 1;
  802e08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e13:	74 1e                	je     802e33 <merging+0x5d>
  802e15:	ff 75 10             	pushl  0x10(%ebp)
  802e18:	e8 98 f1 ff ff       	call   801fb5 <get_block_size>
  802e1d:	83 c4 04             	add    $0x4,%esp
  802e20:	89 c2                	mov    %eax,%edx
  802e22:	8b 45 10             	mov    0x10(%ebp),%eax
  802e25:	01 d0                	add    %edx,%eax
  802e27:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e2a:	75 07                	jne    802e33 <merging+0x5d>
		next_is_free = 1;
  802e2c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e37:	0f 84 cc 00 00 00    	je     802f09 <merging+0x133>
  802e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e41:	0f 84 c2 00 00 00    	je     802f09 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e47:	ff 75 08             	pushl  0x8(%ebp)
  802e4a:	e8 66 f1 ff ff       	call   801fb5 <get_block_size>
  802e4f:	83 c4 04             	add    $0x4,%esp
  802e52:	89 c3                	mov    %eax,%ebx
  802e54:	ff 75 10             	pushl  0x10(%ebp)
  802e57:	e8 59 f1 ff ff       	call   801fb5 <get_block_size>
  802e5c:	83 c4 04             	add    $0x4,%esp
  802e5f:	01 c3                	add    %eax,%ebx
  802e61:	ff 75 0c             	pushl  0xc(%ebp)
  802e64:	e8 4c f1 ff ff       	call   801fb5 <get_block_size>
  802e69:	83 c4 04             	add    $0x4,%esp
  802e6c:	01 d8                	add    %ebx,%eax
  802e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e71:	6a 00                	push   $0x0
  802e73:	ff 75 ec             	pushl  -0x14(%ebp)
  802e76:	ff 75 08             	pushl  0x8(%ebp)
  802e79:	e8 88 f4 ff ff       	call   802306 <set_block_data>
  802e7e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e85:	75 17                	jne    802e9e <merging+0xc8>
  802e87:	83 ec 04             	sub    $0x4,%esp
  802e8a:	68 33 46 80 00       	push   $0x804633
  802e8f:	68 7d 01 00 00       	push   $0x17d
  802e94:	68 51 46 80 00       	push   $0x804651
  802e99:	e8 23 0c 00 00       	call   803ac1 <_panic>
  802e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 10                	je     802eb7 <merging+0xe1>
  802ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaf:	8b 52 04             	mov    0x4(%edx),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	eb 0b                	jmp    802ec2 <merging+0xec>
  802eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	a3 30 50 80 00       	mov    %eax,0x805030
  802ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0f                	je     802edb <merging+0x105>
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	8b 40 04             	mov    0x4(%eax),%eax
  802ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed5:	8b 12                	mov    (%edx),%edx
  802ed7:	89 10                	mov    %edx,(%eax)
  802ed9:	eb 0a                	jmp    802ee5 <merging+0x10f>
  802edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef8:	a1 38 50 80 00       	mov    0x805038,%eax
  802efd:	48                   	dec    %eax
  802efe:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f03:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f04:	e9 ea 02 00 00       	jmp    8031f3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0d:	74 3b                	je     802f4a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f0f:	83 ec 0c             	sub    $0xc,%esp
  802f12:	ff 75 08             	pushl  0x8(%ebp)
  802f15:	e8 9b f0 ff ff       	call   801fb5 <get_block_size>
  802f1a:	83 c4 10             	add    $0x10,%esp
  802f1d:	89 c3                	mov    %eax,%ebx
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 10             	pushl  0x10(%ebp)
  802f25:	e8 8b f0 ff ff       	call   801fb5 <get_block_size>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	01 d8                	add    %ebx,%eax
  802f2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	6a 00                	push   $0x0
  802f37:	ff 75 e8             	pushl  -0x18(%ebp)
  802f3a:	ff 75 08             	pushl  0x8(%ebp)
  802f3d:	e8 c4 f3 ff ff       	call   802306 <set_block_data>
  802f42:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f45:	e9 a9 02 00 00       	jmp    8031f3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4e:	0f 84 2d 01 00 00    	je     803081 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f54:	83 ec 0c             	sub    $0xc,%esp
  802f57:	ff 75 10             	pushl  0x10(%ebp)
  802f5a:	e8 56 f0 ff ff       	call   801fb5 <get_block_size>
  802f5f:	83 c4 10             	add    $0x10,%esp
  802f62:	89 c3                	mov    %eax,%ebx
  802f64:	83 ec 0c             	sub    $0xc,%esp
  802f67:	ff 75 0c             	pushl  0xc(%ebp)
  802f6a:	e8 46 f0 ff ff       	call   801fb5 <get_block_size>
  802f6f:	83 c4 10             	add    $0x10,%esp
  802f72:	01 d8                	add    %ebx,%eax
  802f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	6a 00                	push   $0x0
  802f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f7f:	ff 75 10             	pushl  0x10(%ebp)
  802f82:	e8 7f f3 ff ff       	call   802306 <set_block_data>
  802f87:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f94:	74 06                	je     802f9c <merging+0x1c6>
  802f96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f9a:	75 17                	jne    802fb3 <merging+0x1dd>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 0c 47 80 00       	push   $0x80470c
  802fa4:	68 8d 01 00 00       	push   $0x18d
  802fa9:	68 51 46 80 00       	push   $0x804651
  802fae:	e8 0e 0b 00 00       	call   803ac1 <_panic>
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	8b 50 04             	mov    0x4(%eax),%edx
  802fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbc:	89 50 04             	mov    %edx,0x4(%eax)
  802fbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 0d                	je     802fde <merging+0x208>
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fda:	89 10                	mov    %edx,(%eax)
  802fdc:	eb 08                	jmp    802fe6 <merging+0x210>
  802fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff4:	40                   	inc    %eax
  802ff5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ffa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ffe:	75 17                	jne    803017 <merging+0x241>
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	68 33 46 80 00       	push   $0x804633
  803008:	68 8e 01 00 00       	push   $0x18e
  80300d:	68 51 46 80 00       	push   $0x804651
  803012:	e8 aa 0a 00 00       	call   803ac1 <_panic>
  803017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 10                	je     803030 <merging+0x25a>
  803020:	8b 45 0c             	mov    0xc(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	8b 55 0c             	mov    0xc(%ebp),%edx
  803028:	8b 52 04             	mov    0x4(%edx),%edx
  80302b:	89 50 04             	mov    %edx,0x4(%eax)
  80302e:	eb 0b                	jmp    80303b <merging+0x265>
  803030:	8b 45 0c             	mov    0xc(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	a3 30 50 80 00       	mov    %eax,0x805030
  80303b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0f                	je     803054 <merging+0x27e>
  803045:	8b 45 0c             	mov    0xc(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304e:	8b 12                	mov    (%edx),%edx
  803050:	89 10                	mov    %edx,(%eax)
  803052:	eb 0a                	jmp    80305e <merging+0x288>
  803054:	8b 45 0c             	mov    0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80305e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803071:	a1 38 50 80 00       	mov    0x805038,%eax
  803076:	48                   	dec    %eax
  803077:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80307c:	e9 72 01 00 00       	jmp    8031f3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803081:	8b 45 10             	mov    0x10(%ebp),%eax
  803084:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308b:	74 79                	je     803106 <merging+0x330>
  80308d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803091:	74 73                	je     803106 <merging+0x330>
  803093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803097:	74 06                	je     80309f <merging+0x2c9>
  803099:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309d:	75 17                	jne    8030b6 <merging+0x2e0>
  80309f:	83 ec 04             	sub    $0x4,%esp
  8030a2:	68 c4 46 80 00       	push   $0x8046c4
  8030a7:	68 94 01 00 00       	push   $0x194
  8030ac:	68 51 46 80 00       	push   $0x804651
  8030b1:	e8 0b 0a 00 00       	call   803ac1 <_panic>
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	8b 10                	mov    (%eax),%edx
  8030bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0b                	je     8030d4 <merging+0x2fe>
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	75 08                	jne    8030f6 <merging+0x320>
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 38 50 80 00       	mov    %eax,0x805038
  803101:	e9 ce 00 00 00       	jmp    8031d4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803106:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310a:	74 65                	je     803171 <merging+0x39b>
  80310c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803110:	75 17                	jne    803129 <merging+0x353>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 a0 46 80 00       	push   $0x8046a0
  80311a:	68 95 01 00 00       	push   $0x195
  80311f:	68 51 46 80 00       	push   $0x804651
  803124:	e8 98 09 00 00       	call   803ac1 <_panic>
  803129:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80312f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803132:	89 50 04             	mov    %edx,0x4(%eax)
  803135:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	85 c0                	test   %eax,%eax
  80313d:	74 0c                	je     80314b <merging+0x375>
  80313f:	a1 30 50 80 00       	mov    0x805030,%eax
  803144:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803147:	89 10                	mov    %edx,(%eax)
  803149:	eb 08                	jmp    803153 <merging+0x37d>
  80314b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803153:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803156:	a3 30 50 80 00       	mov    %eax,0x805030
  80315b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803164:	a1 38 50 80 00       	mov    0x805038,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 38 50 80 00       	mov    %eax,0x805038
  80316f:	eb 63                	jmp    8031d4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803171:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803175:	75 17                	jne    80318e <merging+0x3b8>
  803177:	83 ec 04             	sub    $0x4,%esp
  80317a:	68 6c 46 80 00       	push   $0x80466c
  80317f:	68 98 01 00 00       	push   $0x198
  803184:	68 51 46 80 00       	push   $0x804651
  803189:	e8 33 09 00 00       	call   803ac1 <_panic>
  80318e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803194:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803197:	89 10                	mov    %edx,(%eax)
  803199:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	74 0d                	je     8031af <merging+0x3d9>
  8031a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%eax)
  8031ad:	eb 08                	jmp    8031b7 <merging+0x3e1>
  8031af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ce:	40                   	inc    %eax
  8031cf:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031d4:	83 ec 0c             	sub    $0xc,%esp
  8031d7:	ff 75 10             	pushl  0x10(%ebp)
  8031da:	e8 d6 ed ff ff       	call   801fb5 <get_block_size>
  8031df:	83 c4 10             	add    $0x10,%esp
  8031e2:	83 ec 04             	sub    $0x4,%esp
  8031e5:	6a 00                	push   $0x0
  8031e7:	50                   	push   %eax
  8031e8:	ff 75 10             	pushl  0x10(%ebp)
  8031eb:	e8 16 f1 ff ff       	call   802306 <set_block_data>
  8031f0:	83 c4 10             	add    $0x10,%esp
	}
}
  8031f3:	90                   	nop
  8031f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803204:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803207:	a1 30 50 80 00       	mov    0x805030,%eax
  80320c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320f:	73 1b                	jae    80322c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803211:	a1 30 50 80 00       	mov    0x805030,%eax
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	ff 75 08             	pushl  0x8(%ebp)
  80321c:	6a 00                	push   $0x0
  80321e:	50                   	push   %eax
  80321f:	e8 b2 fb ff ff       	call   802dd6 <merging>
  803224:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803227:	e9 8b 00 00 00       	jmp    8032b7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80322c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803231:	3b 45 08             	cmp    0x8(%ebp),%eax
  803234:	76 18                	jbe    80324e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803236:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	ff 75 08             	pushl  0x8(%ebp)
  803241:	50                   	push   %eax
  803242:	6a 00                	push   $0x0
  803244:	e8 8d fb ff ff       	call   802dd6 <merging>
  803249:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324c:	eb 69                	jmp    8032b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80324e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803256:	eb 39                	jmp    803291 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325e:	73 29                	jae    803289 <free_block+0x90>
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	3b 45 08             	cmp    0x8(%ebp),%eax
  803268:	76 1f                	jbe    803289 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803272:	83 ec 04             	sub    $0x4,%esp
  803275:	ff 75 08             	pushl  0x8(%ebp)
  803278:	ff 75 f0             	pushl  -0x10(%ebp)
  80327b:	ff 75 f4             	pushl  -0xc(%ebp)
  80327e:	e8 53 fb ff ff       	call   802dd6 <merging>
  803283:	83 c4 10             	add    $0x10,%esp
			break;
  803286:	90                   	nop
		}
	}
}
  803287:	eb 2e                	jmp    8032b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803289:	a1 34 50 80 00       	mov    0x805034,%eax
  80328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803295:	74 07                	je     80329e <free_block+0xa5>
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	eb 05                	jmp    8032a3 <free_block+0xaa>
  80329e:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8032a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	75 a7                	jne    803258 <free_block+0x5f>
  8032b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b5:	75 a1                	jne    803258 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032b7:	90                   	nop
  8032b8:	c9                   	leave  
  8032b9:	c3                   	ret    

008032ba <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
  8032bd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032c0:	ff 75 08             	pushl  0x8(%ebp)
  8032c3:	e8 ed ec ff ff       	call   801fb5 <get_block_size>
  8032c8:	83 c4 04             	add    $0x4,%esp
  8032cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032d5:	eb 17                	jmp    8032ee <copy_data+0x34>
  8032d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032dd:	01 c2                	add    %eax,%edx
  8032df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	01 c8                	add    %ecx,%eax
  8032e7:	8a 00                	mov    (%eax),%al
  8032e9:	88 02                	mov    %al,(%edx)
  8032eb:	ff 45 fc             	incl   -0x4(%ebp)
  8032ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032f4:	72 e1                	jb     8032d7 <copy_data+0x1d>
}
  8032f6:	90                   	nop
  8032f7:	c9                   	leave  
  8032f8:	c3                   	ret    

008032f9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
  8032fc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803303:	75 23                	jne    803328 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803309:	74 13                	je     80331e <realloc_block_FF+0x25>
  80330b:	83 ec 0c             	sub    $0xc,%esp
  80330e:	ff 75 0c             	pushl  0xc(%ebp)
  803311:	e8 1f f0 ff ff       	call   802335 <alloc_block_FF>
  803316:	83 c4 10             	add    $0x10,%esp
  803319:	e9 f4 06 00 00       	jmp    803a12 <realloc_block_FF+0x719>
		return NULL;
  80331e:	b8 00 00 00 00       	mov    $0x0,%eax
  803323:	e9 ea 06 00 00       	jmp    803a12 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803328:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332c:	75 18                	jne    803346 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80332e:	83 ec 0c             	sub    $0xc,%esp
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	e8 c0 fe ff ff       	call   8031f9 <free_block>
  803339:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80333c:	b8 00 00 00 00       	mov    $0x0,%eax
  803341:	e9 cc 06 00 00       	jmp    803a12 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803346:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80334a:	77 07                	ja     803353 <realloc_block_FF+0x5a>
  80334c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803353:	8b 45 0c             	mov    0xc(%ebp),%eax
  803356:	83 e0 01             	and    $0x1,%eax
  803359:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80335c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335f:	83 c0 08             	add    $0x8,%eax
  803362:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803365:	83 ec 0c             	sub    $0xc,%esp
  803368:	ff 75 08             	pushl  0x8(%ebp)
  80336b:	e8 45 ec ff ff       	call   801fb5 <get_block_size>
  803370:	83 c4 10             	add    $0x10,%esp
  803373:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803379:	83 e8 08             	sub    $0x8,%eax
  80337c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	83 e8 04             	sub    $0x4,%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	83 e0 fe             	and    $0xfffffffe,%eax
  80338a:	89 c2                	mov    %eax,%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	01 d0                	add    %edx,%eax
  803391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803394:	83 ec 0c             	sub    $0xc,%esp
  803397:	ff 75 e4             	pushl  -0x1c(%ebp)
  80339a:	e8 16 ec ff ff       	call   801fb5 <get_block_size>
  80339f:	83 c4 10             	add    $0x10,%esp
  8033a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a8:	83 e8 08             	sub    $0x8,%eax
  8033ab:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033b4:	75 08                	jne    8033be <realloc_block_FF+0xc5>
	{
		 return va;
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	e9 54 06 00 00       	jmp    803a12 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c4:	0f 83 e5 03 00 00    	jae    8037af <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033d3:	83 ec 0c             	sub    $0xc,%esp
  8033d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033d9:	e8 f0 eb ff ff       	call   801fce <is_free_block>
  8033de:	83 c4 10             	add    $0x10,%esp
  8033e1:	84 c0                	test   %al,%al
  8033e3:	0f 84 3b 01 00 00    	je     803524 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	6a 01                	push   $0x1
  8033f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8033fc:	ff 75 08             	pushl  0x8(%ebp)
  8033ff:	e8 02 ef ff ff       	call   802306 <set_block_data>
  803404:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	83 e8 04             	sub    $0x4,%eax
  80340d:	8b 00                	mov    (%eax),%eax
  80340f:	83 e0 fe             	and    $0xfffffffe,%eax
  803412:	89 c2                	mov    %eax,%edx
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	01 d0                	add    %edx,%eax
  803419:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80341c:	83 ec 04             	sub    $0x4,%esp
  80341f:	6a 00                	push   $0x0
  803421:	ff 75 cc             	pushl  -0x34(%ebp)
  803424:	ff 75 c8             	pushl  -0x38(%ebp)
  803427:	e8 da ee ff ff       	call   802306 <set_block_data>
  80342c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80342f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803433:	74 06                	je     80343b <realloc_block_FF+0x142>
  803435:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803439:	75 17                	jne    803452 <realloc_block_FF+0x159>
  80343b:	83 ec 04             	sub    $0x4,%esp
  80343e:	68 c4 46 80 00       	push   $0x8046c4
  803443:	68 f6 01 00 00       	push   $0x1f6
  803448:	68 51 46 80 00       	push   $0x804651
  80344d:	e8 6f 06 00 00       	call   803ac1 <_panic>
  803452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803455:	8b 10                	mov    (%eax),%edx
  803457:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345a:	89 10                	mov    %edx,(%eax)
  80345c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	85 c0                	test   %eax,%eax
  803463:	74 0b                	je     803470 <realloc_block_FF+0x177>
  803465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803468:	8b 00                	mov    (%eax),%eax
  80346a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80346d:	89 50 04             	mov    %edx,0x4(%eax)
  803470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803473:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803476:	89 10                	mov    %edx,(%eax)
  803478:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80347b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	75 08                	jne    803492 <realloc_block_FF+0x199>
  80348a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348d:	a3 30 50 80 00       	mov    %eax,0x805030
  803492:	a1 38 50 80 00       	mov    0x805038,%eax
  803497:	40                   	inc    %eax
  803498:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80349d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a1:	75 17                	jne    8034ba <realloc_block_FF+0x1c1>
  8034a3:	83 ec 04             	sub    $0x4,%esp
  8034a6:	68 33 46 80 00       	push   $0x804633
  8034ab:	68 f7 01 00 00       	push   $0x1f7
  8034b0:	68 51 46 80 00       	push   $0x804651
  8034b5:	e8 07 06 00 00       	call   803ac1 <_panic>
  8034ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 10                	je     8034d3 <realloc_block_FF+0x1da>
  8034c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034cb:	8b 52 04             	mov    0x4(%edx),%edx
  8034ce:	89 50 04             	mov    %edx,0x4(%eax)
  8034d1:	eb 0b                	jmp    8034de <realloc_block_FF+0x1e5>
  8034d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	74 0f                	je     8034f7 <realloc_block_FF+0x1fe>
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f1:	8b 12                	mov    (%edx),%edx
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	eb 0a                	jmp    803501 <realloc_block_FF+0x208>
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803514:	a1 38 50 80 00       	mov    0x805038,%eax
  803519:	48                   	dec    %eax
  80351a:	a3 38 50 80 00       	mov    %eax,0x805038
  80351f:	e9 83 02 00 00       	jmp    8037a7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803524:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803528:	0f 86 69 02 00 00    	jbe    803797 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	6a 01                	push   $0x1
  803533:	ff 75 f0             	pushl  -0x10(%ebp)
  803536:	ff 75 08             	pushl  0x8(%ebp)
  803539:	e8 c8 ed ff ff       	call   802306 <set_block_data>
  80353e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	83 e8 04             	sub    $0x4,%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	83 e0 fe             	and    $0xfffffffe,%eax
  80354c:	89 c2                	mov    %eax,%edx
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	01 d0                	add    %edx,%eax
  803553:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803556:	a1 38 50 80 00       	mov    0x805038,%eax
  80355b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80355e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803562:	75 68                	jne    8035cc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803564:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803568:	75 17                	jne    803581 <realloc_block_FF+0x288>
  80356a:	83 ec 04             	sub    $0x4,%esp
  80356d:	68 6c 46 80 00       	push   $0x80466c
  803572:	68 06 02 00 00       	push   $0x206
  803577:	68 51 46 80 00       	push   $0x804651
  80357c:	e8 40 05 00 00       	call   803ac1 <_panic>
  803581:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358a:	89 10                	mov    %edx,(%eax)
  80358c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	85 c0                	test   %eax,%eax
  803593:	74 0d                	je     8035a2 <realloc_block_FF+0x2a9>
  803595:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359d:	89 50 04             	mov    %edx,0x4(%eax)
  8035a0:	eb 08                	jmp    8035aa <realloc_block_FF+0x2b1>
  8035a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c1:	40                   	inc    %eax
  8035c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c7:	e9 b0 01 00 00       	jmp    80377c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d4:	76 68                	jbe    80363e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035da:	75 17                	jne    8035f3 <realloc_block_FF+0x2fa>
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	68 6c 46 80 00       	push   $0x80466c
  8035e4:	68 0b 02 00 00       	push   $0x20b
  8035e9:	68 51 46 80 00       	push   $0x804651
  8035ee:	e8 ce 04 00 00       	call   803ac1 <_panic>
  8035f3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0d                	je     803614 <realloc_block_FF+0x31b>
  803607:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	eb 08                	jmp    80361c <realloc_block_FF+0x323>
  803614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803617:	a3 30 50 80 00       	mov    %eax,0x805030
  80361c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362e:	a1 38 50 80 00       	mov    0x805038,%eax
  803633:	40                   	inc    %eax
  803634:	a3 38 50 80 00       	mov    %eax,0x805038
  803639:	e9 3e 01 00 00       	jmp    80377c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80363e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803643:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803646:	73 68                	jae    8036b0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803648:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80364c:	75 17                	jne    803665 <realloc_block_FF+0x36c>
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	68 a0 46 80 00       	push   $0x8046a0
  803656:	68 10 02 00 00       	push   $0x210
  80365b:	68 51 46 80 00       	push   $0x804651
  803660:	e8 5c 04 00 00       	call   803ac1 <_panic>
  803665:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80366b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366e:	89 50 04             	mov    %edx,0x4(%eax)
  803671:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803674:	8b 40 04             	mov    0x4(%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0c                	je     803687 <realloc_block_FF+0x38e>
  80367b:	a1 30 50 80 00       	mov    0x805030,%eax
  803680:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803683:	89 10                	mov    %edx,(%eax)
  803685:	eb 08                	jmp    80368f <realloc_block_FF+0x396>
  803687:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803692:	a3 30 50 80 00       	mov    %eax,0x805030
  803697:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a5:	40                   	inc    %eax
  8036a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ab:	e9 cc 00 00 00       	jmp    80377c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036bf:	e9 8a 00 00 00       	jmp    80374e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ca:	73 7a                	jae    803746 <realloc_block_FF+0x44d>
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d4:	73 70                	jae    803746 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036da:	74 06                	je     8036e2 <realloc_block_FF+0x3e9>
  8036dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e0:	75 17                	jne    8036f9 <realloc_block_FF+0x400>
  8036e2:	83 ec 04             	sub    $0x4,%esp
  8036e5:	68 c4 46 80 00       	push   $0x8046c4
  8036ea:	68 1a 02 00 00       	push   $0x21a
  8036ef:	68 51 46 80 00       	push   $0x804651
  8036f4:	e8 c8 03 00 00       	call   803ac1 <_panic>
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	8b 10                	mov    (%eax),%edx
  8036fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803701:	89 10                	mov    %edx,(%eax)
  803703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	85 c0                	test   %eax,%eax
  80370a:	74 0b                	je     803717 <realloc_block_FF+0x41e>
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803714:	89 50 04             	mov    %edx,0x4(%eax)
  803717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371d:	89 10                	mov    %edx,(%eax)
  80371f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803725:	89 50 04             	mov    %edx,0x4(%eax)
  803728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372b:	8b 00                	mov    (%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	75 08                	jne    803739 <realloc_block_FF+0x440>
  803731:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803734:	a3 30 50 80 00       	mov    %eax,0x805030
  803739:	a1 38 50 80 00       	mov    0x805038,%eax
  80373e:	40                   	inc    %eax
  80373f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803744:	eb 36                	jmp    80377c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803746:	a1 34 50 80 00       	mov    0x805034,%eax
  80374b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803752:	74 07                	je     80375b <realloc_block_FF+0x462>
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	eb 05                	jmp    803760 <realloc_block_FF+0x467>
  80375b:	b8 00 00 00 00       	mov    $0x0,%eax
  803760:	a3 34 50 80 00       	mov    %eax,0x805034
  803765:	a1 34 50 80 00       	mov    0x805034,%eax
  80376a:	85 c0                	test   %eax,%eax
  80376c:	0f 85 52 ff ff ff    	jne    8036c4 <realloc_block_FF+0x3cb>
  803772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803776:	0f 85 48 ff ff ff    	jne    8036c4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	6a 00                	push   $0x0
  803781:	ff 75 d8             	pushl  -0x28(%ebp)
  803784:	ff 75 d4             	pushl  -0x2c(%ebp)
  803787:	e8 7a eb ff ff       	call   802306 <set_block_data>
  80378c:	83 c4 10             	add    $0x10,%esp
				return va;
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	e9 7b 02 00 00       	jmp    803a12 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803797:	83 ec 0c             	sub    $0xc,%esp
  80379a:	68 41 47 80 00       	push   $0x804741
  80379f:	e8 09 cf ff ff       	call   8006ad <cprintf>
  8037a4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	e9 63 02 00 00       	jmp    803a12 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b5:	0f 86 4d 02 00 00    	jbe    803a08 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037bb:	83 ec 0c             	sub    $0xc,%esp
  8037be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c1:	e8 08 e8 ff ff       	call   801fce <is_free_block>
  8037c6:	83 c4 10             	add    $0x10,%esp
  8037c9:	84 c0                	test   %al,%al
  8037cb:	0f 84 37 02 00 00    	je     803a08 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037e0:	76 38                	jbe    80381a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037e2:	83 ec 0c             	sub    $0xc,%esp
  8037e5:	ff 75 08             	pushl  0x8(%ebp)
  8037e8:	e8 0c fa ff ff       	call   8031f9 <free_block>
  8037ed:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037f0:	83 ec 0c             	sub    $0xc,%esp
  8037f3:	ff 75 0c             	pushl  0xc(%ebp)
  8037f6:	e8 3a eb ff ff       	call   802335 <alloc_block_FF>
  8037fb:	83 c4 10             	add    $0x10,%esp
  8037fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803801:	83 ec 08             	sub    $0x8,%esp
  803804:	ff 75 c0             	pushl  -0x40(%ebp)
  803807:	ff 75 08             	pushl  0x8(%ebp)
  80380a:	e8 ab fa ff ff       	call   8032ba <copy_data>
  80380f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803812:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803815:	e9 f8 01 00 00       	jmp    803a12 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80381a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803820:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803823:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803827:	0f 87 a0 00 00 00    	ja     8038cd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80382d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803831:	75 17                	jne    80384a <realloc_block_FF+0x551>
  803833:	83 ec 04             	sub    $0x4,%esp
  803836:	68 33 46 80 00       	push   $0x804633
  80383b:	68 38 02 00 00       	push   $0x238
  803840:	68 51 46 80 00       	push   $0x804651
  803845:	e8 77 02 00 00       	call   803ac1 <_panic>
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	74 10                	je     803863 <realloc_block_FF+0x56a>
  803853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385b:	8b 52 04             	mov    0x4(%edx),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	eb 0b                	jmp    80386e <realloc_block_FF+0x575>
  803863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	a3 30 50 80 00       	mov    %eax,0x805030
  80386e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803871:	8b 40 04             	mov    0x4(%eax),%eax
  803874:	85 c0                	test   %eax,%eax
  803876:	74 0f                	je     803887 <realloc_block_FF+0x58e>
  803878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803881:	8b 12                	mov    (%edx),%edx
  803883:	89 10                	mov    %edx,(%eax)
  803885:	eb 0a                	jmp    803891 <realloc_block_FF+0x598>
  803887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a9:	48                   	dec    %eax
  8038aa:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b5:	01 d0                	add    %edx,%eax
  8038b7:	83 ec 04             	sub    $0x4,%esp
  8038ba:	6a 01                	push   $0x1
  8038bc:	50                   	push   %eax
  8038bd:	ff 75 08             	pushl  0x8(%ebp)
  8038c0:	e8 41 ea ff ff       	call   802306 <set_block_data>
  8038c5:	83 c4 10             	add    $0x10,%esp
  8038c8:	e9 36 01 00 00       	jmp    803a03 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038d3:	01 d0                	add    %edx,%eax
  8038d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038d8:	83 ec 04             	sub    $0x4,%esp
  8038db:	6a 01                	push   $0x1
  8038dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8038e0:	ff 75 08             	pushl  0x8(%ebp)
  8038e3:	e8 1e ea ff ff       	call   802306 <set_block_data>
  8038e8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	83 e8 04             	sub    $0x4,%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	83 e0 fe             	and    $0xfffffffe,%eax
  8038f6:	89 c2                	mov    %eax,%edx
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	01 d0                	add    %edx,%eax
  8038fd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803900:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803904:	74 06                	je     80390c <realloc_block_FF+0x613>
  803906:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80390a:	75 17                	jne    803923 <realloc_block_FF+0x62a>
  80390c:	83 ec 04             	sub    $0x4,%esp
  80390f:	68 c4 46 80 00       	push   $0x8046c4
  803914:	68 44 02 00 00       	push   $0x244
  803919:	68 51 46 80 00       	push   $0x804651
  80391e:	e8 9e 01 00 00       	call   803ac1 <_panic>
  803923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803926:	8b 10                	mov    (%eax),%edx
  803928:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392b:	89 10                	mov    %edx,(%eax)
  80392d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	74 0b                	je     803941 <realloc_block_FF+0x648>
  803936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80393e:	89 50 04             	mov    %edx,0x4(%eax)
  803941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803944:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803947:	89 10                	mov    %edx,(%eax)
  803949:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80394c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394f:	89 50 04             	mov    %edx,0x4(%eax)
  803952:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	85 c0                	test   %eax,%eax
  803959:	75 08                	jne    803963 <realloc_block_FF+0x66a>
  80395b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80395e:	a3 30 50 80 00       	mov    %eax,0x805030
  803963:	a1 38 50 80 00       	mov    0x805038,%eax
  803968:	40                   	inc    %eax
  803969:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80396e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803972:	75 17                	jne    80398b <realloc_block_FF+0x692>
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	68 33 46 80 00       	push   $0x804633
  80397c:	68 45 02 00 00       	push   $0x245
  803981:	68 51 46 80 00       	push   $0x804651
  803986:	e8 36 01 00 00       	call   803ac1 <_panic>
  80398b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	85 c0                	test   %eax,%eax
  803992:	74 10                	je     8039a4 <realloc_block_FF+0x6ab>
  803994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803997:	8b 00                	mov    (%eax),%eax
  803999:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399c:	8b 52 04             	mov    0x4(%edx),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	eb 0b                	jmp    8039af <realloc_block_FF+0x6b6>
  8039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a7:	8b 40 04             	mov    0x4(%eax),%eax
  8039aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 0f                	je     8039c8 <realloc_block_FF+0x6cf>
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	8b 40 04             	mov    0x4(%eax),%eax
  8039bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c2:	8b 12                	mov    (%edx),%edx
  8039c4:	89 10                	mov    %edx,(%eax)
  8039c6:	eb 0a                	jmp    8039d2 <realloc_block_FF+0x6d9>
  8039c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8039ea:	48                   	dec    %eax
  8039eb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	6a 00                	push   $0x0
  8039f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f8:	ff 75 b8             	pushl  -0x48(%ebp)
  8039fb:	e8 06 e9 ff ff       	call   802306 <set_block_data>
  803a00:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a03:	8b 45 08             	mov    0x8(%ebp),%eax
  803a06:	eb 0a                	jmp    803a12 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a08:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a12:	c9                   	leave  
  803a13:	c3                   	ret    

00803a14 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a14:	55                   	push   %ebp
  803a15:	89 e5                	mov    %esp,%ebp
  803a17:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a1a:	83 ec 04             	sub    $0x4,%esp
  803a1d:	68 48 47 80 00       	push   $0x804748
  803a22:	68 58 02 00 00       	push   $0x258
  803a27:	68 51 46 80 00       	push   $0x804651
  803a2c:	e8 90 00 00 00       	call   803ac1 <_panic>

00803a31 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a31:	55                   	push   %ebp
  803a32:	89 e5                	mov    %esp,%ebp
  803a34:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a37:	83 ec 04             	sub    $0x4,%esp
  803a3a:	68 70 47 80 00       	push   $0x804770
  803a3f:	68 61 02 00 00       	push   $0x261
  803a44:	68 51 46 80 00       	push   $0x804651
  803a49:	e8 73 00 00 00       	call   803ac1 <_panic>

00803a4e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a4e:	55                   	push   %ebp
  803a4f:	89 e5                	mov    %esp,%ebp
  803a51:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803a54:	83 ec 04             	sub    $0x4,%esp
  803a57:	68 98 47 80 00       	push   $0x804798
  803a5c:	6a 09                	push   $0x9
  803a5e:	68 c0 47 80 00       	push   $0x8047c0
  803a63:	e8 59 00 00 00       	call   803ac1 <_panic>

00803a68 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803a68:	55                   	push   %ebp
  803a69:	89 e5                	mov    %esp,%ebp
  803a6b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803a6e:	83 ec 04             	sub    $0x4,%esp
  803a71:	68 d0 47 80 00       	push   $0x8047d0
  803a76:	6a 10                	push   $0x10
  803a78:	68 c0 47 80 00       	push   $0x8047c0
  803a7d:	e8 3f 00 00 00       	call   803ac1 <_panic>

00803a82 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a82:	55                   	push   %ebp
  803a83:	89 e5                	mov    %esp,%ebp
  803a85:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a88:	83 ec 04             	sub    $0x4,%esp
  803a8b:	68 f8 47 80 00       	push   $0x8047f8
  803a90:	6a 18                	push   $0x18
  803a92:	68 c0 47 80 00       	push   $0x8047c0
  803a97:	e8 25 00 00 00       	call   803ac1 <_panic>

00803a9c <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a9c:	55                   	push   %ebp
  803a9d:	89 e5                	mov    %esp,%ebp
  803a9f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	68 20 48 80 00       	push   $0x804820
  803aaa:	6a 20                	push   $0x20
  803aac:	68 c0 47 80 00       	push   $0x8047c0
  803ab1:	e8 0b 00 00 00       	call   803ac1 <_panic>

00803ab6 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803ab6:	55                   	push   %ebp
  803ab7:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  803abc:	8b 40 10             	mov    0x10(%eax),%eax
}
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    

00803ac1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803ac1:	55                   	push   %ebp
  803ac2:	89 e5                	mov    %esp,%ebp
  803ac4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ac7:	8d 45 10             	lea    0x10(%ebp),%eax
  803aca:	83 c0 04             	add    $0x4,%eax
  803acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803ad0:	a1 60 50 98 00       	mov    0x985060,%eax
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	74 16                	je     803aef <_panic+0x2e>
		cprintf("%s: ", argv0);
  803ad9:	a1 60 50 98 00       	mov    0x985060,%eax
  803ade:	83 ec 08             	sub    $0x8,%esp
  803ae1:	50                   	push   %eax
  803ae2:	68 48 48 80 00       	push   $0x804848
  803ae7:	e8 c1 cb ff ff       	call   8006ad <cprintf>
  803aec:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803aef:	a1 00 50 80 00       	mov    0x805000,%eax
  803af4:	ff 75 0c             	pushl  0xc(%ebp)
  803af7:	ff 75 08             	pushl  0x8(%ebp)
  803afa:	50                   	push   %eax
  803afb:	68 4d 48 80 00       	push   $0x80484d
  803b00:	e8 a8 cb ff ff       	call   8006ad <cprintf>
  803b05:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803b08:	8b 45 10             	mov    0x10(%ebp),%eax
  803b0b:	83 ec 08             	sub    $0x8,%esp
  803b0e:	ff 75 f4             	pushl  -0xc(%ebp)
  803b11:	50                   	push   %eax
  803b12:	e8 2b cb ff ff       	call   800642 <vcprintf>
  803b17:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803b1a:	83 ec 08             	sub    $0x8,%esp
  803b1d:	6a 00                	push   $0x0
  803b1f:	68 69 48 80 00       	push   $0x804869
  803b24:	e8 19 cb ff ff       	call   800642 <vcprintf>
  803b29:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b2c:	e8 9a ca ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803b31:	eb fe                	jmp    803b31 <_panic+0x70>

00803b33 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803b33:	55                   	push   %ebp
  803b34:	89 e5                	mov    %esp,%ebp
  803b36:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b39:	a1 20 50 80 00       	mov    0x805020,%eax
  803b3e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b47:	39 c2                	cmp    %eax,%edx
  803b49:	74 14                	je     803b5f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b4b:	83 ec 04             	sub    $0x4,%esp
  803b4e:	68 6c 48 80 00       	push   $0x80486c
  803b53:	6a 26                	push   $0x26
  803b55:	68 b8 48 80 00       	push   $0x8048b8
  803b5a:	e8 62 ff ff ff       	call   803ac1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b6d:	e9 c5 00 00 00       	jmp    803c37 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7f:	01 d0                	add    %edx,%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	85 c0                	test   %eax,%eax
  803b85:	75 08                	jne    803b8f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b87:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b8a:	e9 a5 00 00 00       	jmp    803c34 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b9d:	eb 69                	jmp    803c08 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b9f:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803baa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bad:	89 d0                	mov    %edx,%eax
  803baf:	01 c0                	add    %eax,%eax
  803bb1:	01 d0                	add    %edx,%eax
  803bb3:	c1 e0 03             	shl    $0x3,%eax
  803bb6:	01 c8                	add    %ecx,%eax
  803bb8:	8a 40 04             	mov    0x4(%eax),%al
  803bbb:	84 c0                	test   %al,%al
  803bbd:	75 46                	jne    803c05 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bbf:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803bca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	01 c0                	add    %eax,%eax
  803bd1:	01 d0                	add    %edx,%eax
  803bd3:	c1 e0 03             	shl    $0x3,%eax
  803bd6:	01 c8                	add    %ecx,%eax
  803bd8:	8b 00                	mov    (%eax),%eax
  803bda:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803be5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf4:	01 c8                	add    %ecx,%eax
  803bf6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bf8:	39 c2                	cmp    %eax,%edx
  803bfa:	75 09                	jne    803c05 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bfc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c03:	eb 15                	jmp    803c1a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c05:	ff 45 e8             	incl   -0x18(%ebp)
  803c08:	a1 20 50 80 00       	mov    0x805020,%eax
  803c0d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c16:	39 c2                	cmp    %eax,%edx
  803c18:	77 85                	ja     803b9f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c1e:	75 14                	jne    803c34 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803c20:	83 ec 04             	sub    $0x4,%esp
  803c23:	68 c4 48 80 00       	push   $0x8048c4
  803c28:	6a 3a                	push   $0x3a
  803c2a:	68 b8 48 80 00       	push   $0x8048b8
  803c2f:	e8 8d fe ff ff       	call   803ac1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803c34:	ff 45 f0             	incl   -0x10(%ebp)
  803c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c3d:	0f 8c 2f ff ff ff    	jl     803b72 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c43:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c4a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c51:	eb 26                	jmp    803c79 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c53:	a1 20 50 80 00       	mov    0x805020,%eax
  803c58:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c61:	89 d0                	mov    %edx,%eax
  803c63:	01 c0                	add    %eax,%eax
  803c65:	01 d0                	add    %edx,%eax
  803c67:	c1 e0 03             	shl    $0x3,%eax
  803c6a:	01 c8                	add    %ecx,%eax
  803c6c:	8a 40 04             	mov    0x4(%eax),%al
  803c6f:	3c 01                	cmp    $0x1,%al
  803c71:	75 03                	jne    803c76 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c73:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c76:	ff 45 e0             	incl   -0x20(%ebp)
  803c79:	a1 20 50 80 00       	mov    0x805020,%eax
  803c7e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c87:	39 c2                	cmp    %eax,%edx
  803c89:	77 c8                	ja     803c53 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c91:	74 14                	je     803ca7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c93:	83 ec 04             	sub    $0x4,%esp
  803c96:	68 18 49 80 00       	push   $0x804918
  803c9b:	6a 44                	push   $0x44
  803c9d:	68 b8 48 80 00       	push   $0x8048b8
  803ca2:	e8 1a fe ff ff       	call   803ac1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ca7:	90                   	nop
  803ca8:	c9                   	leave  
  803ca9:	c3                   	ret    
  803caa:	66 90                	xchg   %ax,%ax

00803cac <__udivdi3>:
  803cac:	55                   	push   %ebp
  803cad:	57                   	push   %edi
  803cae:	56                   	push   %esi
  803caf:	53                   	push   %ebx
  803cb0:	83 ec 1c             	sub    $0x1c,%esp
  803cb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cc3:	89 ca                	mov    %ecx,%edx
  803cc5:	89 f8                	mov    %edi,%eax
  803cc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ccb:	85 f6                	test   %esi,%esi
  803ccd:	75 2d                	jne    803cfc <__udivdi3+0x50>
  803ccf:	39 cf                	cmp    %ecx,%edi
  803cd1:	77 65                	ja     803d38 <__udivdi3+0x8c>
  803cd3:	89 fd                	mov    %edi,%ebp
  803cd5:	85 ff                	test   %edi,%edi
  803cd7:	75 0b                	jne    803ce4 <__udivdi3+0x38>
  803cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cde:	31 d2                	xor    %edx,%edx
  803ce0:	f7 f7                	div    %edi
  803ce2:	89 c5                	mov    %eax,%ebp
  803ce4:	31 d2                	xor    %edx,%edx
  803ce6:	89 c8                	mov    %ecx,%eax
  803ce8:	f7 f5                	div    %ebp
  803cea:	89 c1                	mov    %eax,%ecx
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	f7 f5                	div    %ebp
  803cf0:	89 cf                	mov    %ecx,%edi
  803cf2:	89 fa                	mov    %edi,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	39 ce                	cmp    %ecx,%esi
  803cfe:	77 28                	ja     803d28 <__udivdi3+0x7c>
  803d00:	0f bd fe             	bsr    %esi,%edi
  803d03:	83 f7 1f             	xor    $0x1f,%edi
  803d06:	75 40                	jne    803d48 <__udivdi3+0x9c>
  803d08:	39 ce                	cmp    %ecx,%esi
  803d0a:	72 0a                	jb     803d16 <__udivdi3+0x6a>
  803d0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d10:	0f 87 9e 00 00 00    	ja     803db4 <__udivdi3+0x108>
  803d16:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1b:	89 fa                	mov    %edi,%edx
  803d1d:	83 c4 1c             	add    $0x1c,%esp
  803d20:	5b                   	pop    %ebx
  803d21:	5e                   	pop    %esi
  803d22:	5f                   	pop    %edi
  803d23:	5d                   	pop    %ebp
  803d24:	c3                   	ret    
  803d25:	8d 76 00             	lea    0x0(%esi),%esi
  803d28:	31 ff                	xor    %edi,%edi
  803d2a:	31 c0                	xor    %eax,%eax
  803d2c:	89 fa                	mov    %edi,%edx
  803d2e:	83 c4 1c             	add    $0x1c,%esp
  803d31:	5b                   	pop    %ebx
  803d32:	5e                   	pop    %esi
  803d33:	5f                   	pop    %edi
  803d34:	5d                   	pop    %ebp
  803d35:	c3                   	ret    
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	89 d8                	mov    %ebx,%eax
  803d3a:	f7 f7                	div    %edi
  803d3c:	31 ff                	xor    %edi,%edi
  803d3e:	89 fa                	mov    %edi,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d4d:	89 eb                	mov    %ebp,%ebx
  803d4f:	29 fb                	sub    %edi,%ebx
  803d51:	89 f9                	mov    %edi,%ecx
  803d53:	d3 e6                	shl    %cl,%esi
  803d55:	89 c5                	mov    %eax,%ebp
  803d57:	88 d9                	mov    %bl,%cl
  803d59:	d3 ed                	shr    %cl,%ebp
  803d5b:	89 e9                	mov    %ebp,%ecx
  803d5d:	09 f1                	or     %esi,%ecx
  803d5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d63:	89 f9                	mov    %edi,%ecx
  803d65:	d3 e0                	shl    %cl,%eax
  803d67:	89 c5                	mov    %eax,%ebp
  803d69:	89 d6                	mov    %edx,%esi
  803d6b:	88 d9                	mov    %bl,%cl
  803d6d:	d3 ee                	shr    %cl,%esi
  803d6f:	89 f9                	mov    %edi,%ecx
  803d71:	d3 e2                	shl    %cl,%edx
  803d73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d77:	88 d9                	mov    %bl,%cl
  803d79:	d3 e8                	shr    %cl,%eax
  803d7b:	09 c2                	or     %eax,%edx
  803d7d:	89 d0                	mov    %edx,%eax
  803d7f:	89 f2                	mov    %esi,%edx
  803d81:	f7 74 24 0c          	divl   0xc(%esp)
  803d85:	89 d6                	mov    %edx,%esi
  803d87:	89 c3                	mov    %eax,%ebx
  803d89:	f7 e5                	mul    %ebp
  803d8b:	39 d6                	cmp    %edx,%esi
  803d8d:	72 19                	jb     803da8 <__udivdi3+0xfc>
  803d8f:	74 0b                	je     803d9c <__udivdi3+0xf0>
  803d91:	89 d8                	mov    %ebx,%eax
  803d93:	31 ff                	xor    %edi,%edi
  803d95:	e9 58 ff ff ff       	jmp    803cf2 <__udivdi3+0x46>
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803da0:	89 f9                	mov    %edi,%ecx
  803da2:	d3 e2                	shl    %cl,%edx
  803da4:	39 c2                	cmp    %eax,%edx
  803da6:	73 e9                	jae    803d91 <__udivdi3+0xe5>
  803da8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dab:	31 ff                	xor    %edi,%edi
  803dad:	e9 40 ff ff ff       	jmp    803cf2 <__udivdi3+0x46>
  803db2:	66 90                	xchg   %ax,%ax
  803db4:	31 c0                	xor    %eax,%eax
  803db6:	e9 37 ff ff ff       	jmp    803cf2 <__udivdi3+0x46>
  803dbb:	90                   	nop

00803dbc <__umoddi3>:
  803dbc:	55                   	push   %ebp
  803dbd:	57                   	push   %edi
  803dbe:	56                   	push   %esi
  803dbf:	53                   	push   %ebx
  803dc0:	83 ec 1c             	sub    $0x1c,%esp
  803dc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803dc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803dcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dcf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803dd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ddb:	89 f3                	mov    %esi,%ebx
  803ddd:	89 fa                	mov    %edi,%edx
  803ddf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803de3:	89 34 24             	mov    %esi,(%esp)
  803de6:	85 c0                	test   %eax,%eax
  803de8:	75 1a                	jne    803e04 <__umoddi3+0x48>
  803dea:	39 f7                	cmp    %esi,%edi
  803dec:	0f 86 a2 00 00 00    	jbe    803e94 <__umoddi3+0xd8>
  803df2:	89 c8                	mov    %ecx,%eax
  803df4:	89 f2                	mov    %esi,%edx
  803df6:	f7 f7                	div    %edi
  803df8:	89 d0                	mov    %edx,%eax
  803dfa:	31 d2                	xor    %edx,%edx
  803dfc:	83 c4 1c             	add    $0x1c,%esp
  803dff:	5b                   	pop    %ebx
  803e00:	5e                   	pop    %esi
  803e01:	5f                   	pop    %edi
  803e02:	5d                   	pop    %ebp
  803e03:	c3                   	ret    
  803e04:	39 f0                	cmp    %esi,%eax
  803e06:	0f 87 ac 00 00 00    	ja     803eb8 <__umoddi3+0xfc>
  803e0c:	0f bd e8             	bsr    %eax,%ebp
  803e0f:	83 f5 1f             	xor    $0x1f,%ebp
  803e12:	0f 84 ac 00 00 00    	je     803ec4 <__umoddi3+0x108>
  803e18:	bf 20 00 00 00       	mov    $0x20,%edi
  803e1d:	29 ef                	sub    %ebp,%edi
  803e1f:	89 fe                	mov    %edi,%esi
  803e21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e25:	89 e9                	mov    %ebp,%ecx
  803e27:	d3 e0                	shl    %cl,%eax
  803e29:	89 d7                	mov    %edx,%edi
  803e2b:	89 f1                	mov    %esi,%ecx
  803e2d:	d3 ef                	shr    %cl,%edi
  803e2f:	09 c7                	or     %eax,%edi
  803e31:	89 e9                	mov    %ebp,%ecx
  803e33:	d3 e2                	shl    %cl,%edx
  803e35:	89 14 24             	mov    %edx,(%esp)
  803e38:	89 d8                	mov    %ebx,%eax
  803e3a:	d3 e0                	shl    %cl,%eax
  803e3c:	89 c2                	mov    %eax,%edx
  803e3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e42:	d3 e0                	shl    %cl,%eax
  803e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e4c:	89 f1                	mov    %esi,%ecx
  803e4e:	d3 e8                	shr    %cl,%eax
  803e50:	09 d0                	or     %edx,%eax
  803e52:	d3 eb                	shr    %cl,%ebx
  803e54:	89 da                	mov    %ebx,%edx
  803e56:	f7 f7                	div    %edi
  803e58:	89 d3                	mov    %edx,%ebx
  803e5a:	f7 24 24             	mull   (%esp)
  803e5d:	89 c6                	mov    %eax,%esi
  803e5f:	89 d1                	mov    %edx,%ecx
  803e61:	39 d3                	cmp    %edx,%ebx
  803e63:	0f 82 87 00 00 00    	jb     803ef0 <__umoddi3+0x134>
  803e69:	0f 84 91 00 00 00    	je     803f00 <__umoddi3+0x144>
  803e6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e73:	29 f2                	sub    %esi,%edx
  803e75:	19 cb                	sbb    %ecx,%ebx
  803e77:	89 d8                	mov    %ebx,%eax
  803e79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e7d:	d3 e0                	shl    %cl,%eax
  803e7f:	89 e9                	mov    %ebp,%ecx
  803e81:	d3 ea                	shr    %cl,%edx
  803e83:	09 d0                	or     %edx,%eax
  803e85:	89 e9                	mov    %ebp,%ecx
  803e87:	d3 eb                	shr    %cl,%ebx
  803e89:	89 da                	mov    %ebx,%edx
  803e8b:	83 c4 1c             	add    $0x1c,%esp
  803e8e:	5b                   	pop    %ebx
  803e8f:	5e                   	pop    %esi
  803e90:	5f                   	pop    %edi
  803e91:	5d                   	pop    %ebp
  803e92:	c3                   	ret    
  803e93:	90                   	nop
  803e94:	89 fd                	mov    %edi,%ebp
  803e96:	85 ff                	test   %edi,%edi
  803e98:	75 0b                	jne    803ea5 <__umoddi3+0xe9>
  803e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e9f:	31 d2                	xor    %edx,%edx
  803ea1:	f7 f7                	div    %edi
  803ea3:	89 c5                	mov    %eax,%ebp
  803ea5:	89 f0                	mov    %esi,%eax
  803ea7:	31 d2                	xor    %edx,%edx
  803ea9:	f7 f5                	div    %ebp
  803eab:	89 c8                	mov    %ecx,%eax
  803ead:	f7 f5                	div    %ebp
  803eaf:	89 d0                	mov    %edx,%eax
  803eb1:	e9 44 ff ff ff       	jmp    803dfa <__umoddi3+0x3e>
  803eb6:	66 90                	xchg   %ax,%ax
  803eb8:	89 c8                	mov    %ecx,%eax
  803eba:	89 f2                	mov    %esi,%edx
  803ebc:	83 c4 1c             	add    $0x1c,%esp
  803ebf:	5b                   	pop    %ebx
  803ec0:	5e                   	pop    %esi
  803ec1:	5f                   	pop    %edi
  803ec2:	5d                   	pop    %ebp
  803ec3:	c3                   	ret    
  803ec4:	3b 04 24             	cmp    (%esp),%eax
  803ec7:	72 06                	jb     803ecf <__umoddi3+0x113>
  803ec9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ecd:	77 0f                	ja     803ede <__umoddi3+0x122>
  803ecf:	89 f2                	mov    %esi,%edx
  803ed1:	29 f9                	sub    %edi,%ecx
  803ed3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ed7:	89 14 24             	mov    %edx,(%esp)
  803eda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ede:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ee2:	8b 14 24             	mov    (%esp),%edx
  803ee5:	83 c4 1c             	add    $0x1c,%esp
  803ee8:	5b                   	pop    %ebx
  803ee9:	5e                   	pop    %esi
  803eea:	5f                   	pop    %edi
  803eeb:	5d                   	pop    %ebp
  803eec:	c3                   	ret    
  803eed:	8d 76 00             	lea    0x0(%esi),%esi
  803ef0:	2b 04 24             	sub    (%esp),%eax
  803ef3:	19 fa                	sbb    %edi,%edx
  803ef5:	89 d1                	mov    %edx,%ecx
  803ef7:	89 c6                	mov    %eax,%esi
  803ef9:	e9 71 ff ff ff       	jmp    803e6f <__umoddi3+0xb3>
  803efe:	66 90                	xchg   %ax,%ax
  803f00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f04:	72 ea                	jb     803ef0 <__umoddi3+0x134>
  803f06:	89 d9                	mov    %ebx,%ecx
  803f08:	e9 62 ff ff ff       	jmp    803e6f <__umoddi3+0xb3>

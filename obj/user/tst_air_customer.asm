
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
  800044:	e8 22 1c 00 00       	call   801c6b <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 49 3f 80 00       	mov    $0x803f49,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 53 3f 80 00       	mov    $0x803f53,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 5f 3f 80 00       	mov    $0x803f5f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 6e 3f 80 00       	mov    $0x803f6e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 7d 3f 80 00       	mov    $0x803f7d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 92 3f 80 00       	mov    $0x803f92,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb a7 3f 80 00       	mov    $0x803fa7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb b8 3f 80 00       	mov    $0x803fb8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb c9 3f 80 00       	mov    $0x803fc9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb da 3f 80 00       	mov    $0x803fda,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb e3 3f 80 00       	mov    $0x803fe3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb ed 3f 80 00       	mov    $0x803fed,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb f8 3f 80 00       	mov    $0x803ff8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 04 40 80 00       	mov    $0x804004,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 0e 40 80 00       	mov    $0x80400e,%ebx
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
  8001be:	bb 18 40 80 00       	mov    $0x804018,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 26 40 80 00       	mov    $0x804026,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 35 40 80 00       	mov    $0x804035,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 3c 40 80 00       	mov    $0x80403c,%ebx
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
  800286:	e8 ba 37 00 00       	call   803a45 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 9e 37 00 00       	call   803a45 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 82 37 00 00       	call   803a45 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 66 37 00 00       	call   803a45 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 4a 37 00 00       	call   803a45 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 53 37 00 00       	call   803a5f <wait_semaphore>
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
  80032d:	e8 47 37 00 00       	call   803a79 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 1c 37 00 00       	call   803a5f <wait_semaphore>
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
  800363:	e8 f7 36 00 00       	call   803a5f <wait_semaphore>
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
  800397:	e8 dd 36 00 00       	call   803a79 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 cc 36 00 00       	call   803a79 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 43 40 80 00       	mov    $0x804043,%ebx
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
  800425:	e8 1b 36 00 00       	call   803a45 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 24 36 00 00       	call   803a5f <wait_semaphore>
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
  80045e:	68 00 3f 80 00       	push   $0x803f00
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 28 3f 80 00       	push   $0x803f28
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 eb 35 00 00       	call   803a79 <signal_semaphore>
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
  8004a0:	e8 ad 17 00 00       	call   801c52 <sys_getenvindex>
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
  80050e:	e8 c3 14 00 00       	call   8019d6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 7c 40 80 00       	push   $0x80407c
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
  80053e:	68 a4 40 80 00       	push   $0x8040a4
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
  80056f:	68 cc 40 80 00       	push   $0x8040cc
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 24 41 80 00       	push   $0x804124
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 7c 40 80 00       	push   $0x80407c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 43 14 00 00       	call   8019f0 <sys_unlock_cons>
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
  8005c0:	e8 59 16 00 00       	call   801c1e <sys_destroy_env>
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
  8005d1:	e8 ae 16 00 00       	call   801c84 <sys_exit_env>
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
  80061f:	e8 70 13 00 00       	call   801994 <sys_cputs>
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
  800696:	e8 f9 12 00 00       	call   801994 <sys_cputs>
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
  8006e0:	e8 f1 12 00 00       	call   8019d6 <sys_lock_cons>
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
  800700:	e8 eb 12 00 00       	call   8019f0 <sys_unlock_cons>
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
  80074a:	e8 39 35 00 00       	call   803c88 <__udivdi3>
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
  80079a:	e8 f9 35 00 00       	call   803d98 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 54 43 80 00       	add    $0x804354,%eax
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
  8008f5:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
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
  8009d6:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 65 43 80 00       	push   $0x804365
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
  8009fb:	68 6e 43 80 00       	push   $0x80436e
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
  800a28:	be 71 43 80 00       	mov    $0x804371,%esi
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
  801433:	68 e8 44 80 00       	push   $0x8044e8
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 0a 45 80 00       	push   $0x80450a
  801442:	e8 57 26 00 00       	call   803a9e <_panic>

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
  801453:	e8 e7 0a 00 00       	call   801f3f <sys_sbrk>
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
  8014ce:	e8 f0 08 00 00       	call   801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 30 0e 00 00       	call   802312 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 02 09 00 00       	call   801df4 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 c9 12 00 00       	call   8027ce <alloc_block_BF>
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
  801666:	e8 0b 09 00 00       	call   801f76 <sys_allocate_user_mem>
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
  8016ae:	e8 df 08 00 00       	call   801f92 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 12 1b 00 00       	call   8031d6 <free_block>
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
  801756:	e8 ff 07 00 00       	call   801f5a <sys_free_user_mem>
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
  801764:	68 18 45 80 00       	push   $0x804518
  801769:	68 85 00 00 00       	push   $0x85
  80176e:	68 42 45 80 00       	push   $0x804542
  801773:	e8 26 23 00 00       	call   803a9e <_panic>
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
  8017d9:	e8 83 03 00 00       	call   801b61 <sys_createSharedObject>
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
  8017fd:	68 4e 45 80 00       	push   $0x80454e
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
  801841:	e8 45 03 00 00       	call   801b8b <sys_getSizeOfSharedObject>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80184c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801850:	75 07                	jne    801859 <sget+0x27>
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	eb 5c                	jmp    8018b5 <sget+0x83>
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
  80188c:	eb 27                	jmp    8018b5 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	ff 75 e8             	pushl  -0x18(%ebp)
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 09 03 00 00       	call   801ba8 <sys_getSharedObject>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018a5:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018a9:	75 07                	jne    8018b2 <sget+0x80>
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	eb 03                	jmp    8018b5 <sget+0x83>
	return ptr;
  8018b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c5:	8b 40 78             	mov    0x78(%eax),%eax
  8018c8:	29 c2                	sub    %eax,%edx
  8018ca:	89 d0                	mov    %edx,%eax
  8018cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
  8018d4:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e7:	e8 db 02 00 00       	call   801bc7 <sys_freeSharedObject>
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 60 45 80 00       	push   $0x804560
  801903:	68 dd 00 00 00       	push   $0xdd
  801908:	68 42 45 80 00       	push   $0x804542
  80190d:	e8 8c 21 00 00       	call   803a9e <_panic>

00801912 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	68 86 45 80 00       	push   $0x804586
  801920:	68 e9 00 00 00       	push   $0xe9
  801925:	68 42 45 80 00       	push   $0x804542
  80192a:	e8 6f 21 00 00       	call   803a9e <_panic>

0080192f <shrink>:

}
void shrink(uint32 newSize)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 86 45 80 00       	push   $0x804586
  80193d:	68 ee 00 00 00       	push   $0xee
  801942:	68 42 45 80 00       	push   $0x804542
  801947:	e8 52 21 00 00       	call   803a9e <_panic>

0080194c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 86 45 80 00       	push   $0x804586
  80195a:	68 f3 00 00 00       	push   $0xf3
  80195f:	68 42 45 80 00       	push   $0x804542
  801964:	e8 35 21 00 00       	call   803a9e <_panic>

00801969 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801981:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801984:	cd 30                	int    $0x30
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    

00801994 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	50                   	push   %eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	e8 b2 ff ff ff       	call   801969 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 02                	push   $0x2
  8019cc:	e8 98 ff ff ff       	call   801969 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 03                	push   $0x3
  8019e5:	e8 7f ff ff ff       	call   801969 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 04                	push   $0x4
  8019ff:	e8 65 ff ff ff       	call   801969 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 08                	push   $0x8
  801a1d:	e8 47 ff ff ff       	call   801969 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a2c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	51                   	push   %ecx
  801a3e:	52                   	push   %edx
  801a3f:	50                   	push   %eax
  801a40:	6a 09                	push   $0x9
  801a42:	e8 22 ff ff ff       	call   801969 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 0a                	push   $0xa
  801a64:	e8 00 ff ff ff       	call   801969 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 0b                	push   $0xb
  801a7f:	e8 e5 fe ff ff       	call   801969 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 0c                	push   $0xc
  801a98:	e8 cc fe ff ff       	call   801969 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 0d                	push   $0xd
  801ab1:	e8 b3 fe ff ff       	call   801969 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 0e                	push   $0xe
  801aca:	e8 9a fe ff ff       	call   801969 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 0f                	push   $0xf
  801ae3:	e8 81 fe ff ff       	call   801969 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	6a 10                	push   $0x10
  801afd:	e8 67 fe ff ff       	call   801969 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 11                	push   $0x11
  801b16:	e8 4e fe ff ff       	call   801969 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	50                   	push   %eax
  801b3a:	6a 01                	push   $0x1
  801b3c:	e8 28 fe ff ff       	call   801969 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 14                	push   $0x14
  801b56:	e8 0e fe ff ff       	call   801969 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b6d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b70:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	51                   	push   %ecx
  801b7a:	52                   	push   %edx
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	50                   	push   %eax
  801b7f:	6a 15                	push   $0x15
  801b81:	e8 e3 fd ff ff       	call   801969 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 16                	push   $0x16
  801b9e:	e8 c6 fd ff ff       	call   801969 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	51                   	push   %ecx
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 17                	push   $0x17
  801bbd:	e8 a7 fd ff ff       	call   801969 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 18                	push   $0x18
  801bda:	e8 8a fd ff ff       	call   801969 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 14             	pushl  0x14(%ebp)
  801bef:	ff 75 10             	pushl  0x10(%ebp)
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	50                   	push   %eax
  801bf6:	6a 19                	push   $0x19
  801bf8:	e8 6c fd ff ff       	call   801969 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	50                   	push   %eax
  801c11:	6a 1a                	push   $0x1a
  801c13:	e8 51 fd ff ff       	call   801969 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	50                   	push   %eax
  801c2d:	6a 1b                	push   $0x1b
  801c2f:	e8 35 fd ff ff       	call   801969 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 05                	push   $0x5
  801c48:	e8 1c fd ff ff       	call   801969 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 06                	push   $0x6
  801c61:	e8 03 fd ff ff       	call   801969 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 07                	push   $0x7
  801c7a:	e8 ea fc ff ff       	call   801969 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_exit_env>:


void sys_exit_env(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 1c                	push   $0x1c
  801c93:	e8 d1 fc ff ff       	call   801969 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca7:	8d 50 04             	lea    0x4(%eax),%edx
  801caa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 1d                	push   $0x1d
  801cb7:	e8 ad fc ff ff       	call   801969 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return result;
  801cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc8:	89 01                	mov    %eax,(%ecx)
  801cca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	c9                   	leave  
  801cd1:	c2 04 00             	ret    $0x4

00801cd4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	6a 13                	push   $0x13
  801ce6:	e8 7e fc ff ff       	call   801969 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 1e                	push   $0x1e
  801d00:	e8 64 fc ff ff       	call   801969 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d16:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	50                   	push   %eax
  801d23:	6a 1f                	push   $0x1f
  801d25:	e8 3f fc ff ff       	call   801969 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2d:	90                   	nop
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <rsttst>:
void rsttst()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 21                	push   $0x21
  801d3f:	e8 25 fc ff ff       	call   801969 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d56:	8b 55 18             	mov    0x18(%ebp),%edx
  801d59:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	ff 75 10             	pushl  0x10(%ebp)
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	ff 75 08             	pushl  0x8(%ebp)
  801d68:	6a 20                	push   $0x20
  801d6a:	e8 fa fb ff ff       	call   801969 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <chktst>:
void chktst(uint32 n)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	6a 22                	push   $0x22
  801d85:	e8 df fb ff ff       	call   801969 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <inctst>:

void inctst()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 23                	push   $0x23
  801d9f:	e8 c5 fb ff ff       	call   801969 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <gettst>:
uint32 gettst()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 24                	push   $0x24
  801db9:	e8 ab fb ff ff       	call   801969 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 25                	push   $0x25
  801dd5:	e8 8f fb ff ff       	call   801969 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
  801ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de4:	75 07                	jne    801ded <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	eb 05                	jmp    801df2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 25                	push   $0x25
  801e06:	e8 5e fb ff ff       	call   801969 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
  801e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e11:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e15:	75 07                	jne    801e1e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e17:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1c:	eb 05                	jmp    801e23 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 25                	push   $0x25
  801e37:	e8 2d fb ff ff       	call   801969 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
  801e3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e42:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e46:	75 07                	jne    801e4f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e48:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4d:	eb 05                	jmp    801e54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 25                	push   $0x25
  801e68:	e8 fc fa ff ff       	call   801969 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e73:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e77:	75 07                	jne    801e80 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	eb 05                	jmp    801e85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	6a 26                	push   $0x26
  801e97:	e8 cd fa ff ff       	call   801969 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9f:	90                   	nop
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	53                   	push   %ebx
  801eb5:	51                   	push   %ecx
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 27                	push   $0x27
  801eba:	e8 aa fa ff ff       	call   801969 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	6a 28                	push   $0x28
  801eda:	e8 8a fa ff ff       	call   801969 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ee7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	51                   	push   %ecx
  801ef3:	ff 75 10             	pushl  0x10(%ebp)
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	6a 29                	push   $0x29
  801efa:	e8 6a fa ff ff       	call   801969 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	ff 75 10             	pushl  0x10(%ebp)
  801f0e:	ff 75 0c             	pushl  0xc(%ebp)
  801f11:	ff 75 08             	pushl  0x8(%ebp)
  801f14:	6a 12                	push   $0x12
  801f16:	e8 4e fa ff ff       	call   801969 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1e:	90                   	nop
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 2a                	push   $0x2a
  801f34:	e8 30 fa ff ff       	call   801969 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
	return;
  801f3c:	90                   	nop
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	50                   	push   %eax
  801f4e:	6a 2b                	push   $0x2b
  801f50:	e8 14 fa ff ff       	call   801969 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	6a 2c                	push   $0x2c
  801f6b:	e8 f9 f9 ff ff       	call   801969 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return;
  801f73:	90                   	nop
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 0c             	pushl  0xc(%ebp)
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	6a 2d                	push   $0x2d
  801f87:	e8 dd f9 ff ff       	call   801969 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
	return;
  801f8f:	90                   	nop
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	83 e8 04             	sub    $0x4,%eax
  801f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa4:	8b 00                	mov    (%eax),%eax
  801fa6:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	83 e8 04             	sub    $0x4,%eax
  801fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	83 e0 01             	and    $0x1,%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	0f 94 c0             	sete   %al
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd9:	83 f8 02             	cmp    $0x2,%eax
  801fdc:	74 2b                	je     802009 <alloc_block+0x40>
  801fde:	83 f8 02             	cmp    $0x2,%eax
  801fe1:	7f 07                	jg     801fea <alloc_block+0x21>
  801fe3:	83 f8 01             	cmp    $0x1,%eax
  801fe6:	74 0e                	je     801ff6 <alloc_block+0x2d>
  801fe8:	eb 58                	jmp    802042 <alloc_block+0x79>
  801fea:	83 f8 03             	cmp    $0x3,%eax
  801fed:	74 2d                	je     80201c <alloc_block+0x53>
  801fef:	83 f8 04             	cmp    $0x4,%eax
  801ff2:	74 3b                	je     80202f <alloc_block+0x66>
  801ff4:	eb 4c                	jmp    802042 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	e8 11 03 00 00       	call   802312 <alloc_block_FF>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802007:	eb 4a                	jmp    802053 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	e8 fa 19 00 00       	call   803a0e <alloc_block_NF>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80201a:	eb 37                	jmp    802053 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	e8 a7 07 00 00       	call   8027ce <alloc_block_BF>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202d:	eb 24                	jmp    802053 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	ff 75 08             	pushl  0x8(%ebp)
  802035:	e8 b7 19 00 00       	call   8039f1 <alloc_block_WF>
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802040:	eb 11                	jmp    802053 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	68 98 45 80 00       	push   $0x804598
  80204a:	e8 5e e6 ff ff       	call   8006ad <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp
		break;
  802052:	90                   	nop
	}
	return va;
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	53                   	push   %ebx
  80205c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	68 b8 45 80 00       	push   $0x8045b8
  802067:	e8 41 e6 ff ff       	call   8006ad <cprintf>
  80206c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	68 e3 45 80 00       	push   $0x8045e3
  802077:	e8 31 e6 ff ff       	call   8006ad <cprintf>
  80207c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802085:	eb 37                	jmp    8020be <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	ff 75 f4             	pushl  -0xc(%ebp)
  80208d:	e8 19 ff ff ff       	call   801fab <is_free_block>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	0f be d8             	movsbl %al,%ebx
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	ff 75 f4             	pushl  -0xc(%ebp)
  80209e:	e8 ef fe ff ff       	call   801f92 <get_block_size>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	53                   	push   %ebx
  8020aa:	50                   	push   %eax
  8020ab:	68 fb 45 80 00       	push   $0x8045fb
  8020b0:	e8 f8 e5 ff ff       	call   8006ad <cprintf>
  8020b5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c2:	74 07                	je     8020cb <print_blocks_list+0x73>
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	8b 00                	mov    (%eax),%eax
  8020c9:	eb 05                	jmp    8020d0 <print_blocks_list+0x78>
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	89 45 10             	mov    %eax,0x10(%ebp)
  8020d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	75 ad                	jne    802087 <print_blocks_list+0x2f>
  8020da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020de:	75 a7                	jne    802087 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	68 b8 45 80 00       	push   $0x8045b8
  8020e8:	e8 c0 e5 ff ff       	call   8006ad <cprintf>
  8020ed:	83 c4 10             	add    $0x10,%esp

}
  8020f0:	90                   	nop
  8020f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ff:	83 e0 01             	and    $0x1,%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	74 03                	je     802109 <initialize_dynamic_allocator+0x13>
  802106:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802109:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80210d:	0f 84 c7 01 00 00    	je     8022da <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802113:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80211a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80211d:	8b 55 08             	mov    0x8(%ebp),%edx
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	01 d0                	add    %edx,%eax
  802125:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80212a:	0f 87 ad 01 00 00    	ja     8022dd <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	0f 89 a5 01 00 00    	jns    8022e0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80213b:	8b 55 08             	mov    0x8(%ebp),%edx
  80213e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802141:	01 d0                	add    %edx,%eax
  802143:	83 e8 04             	sub    $0x4,%eax
  802146:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80214b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802152:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215a:	e9 87 00 00 00       	jmp    8021e6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80215f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802163:	75 14                	jne    802179 <initialize_dynamic_allocator+0x83>
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 13 46 80 00       	push   $0x804613
  80216d:	6a 79                	push   $0x79
  80216f:	68 31 46 80 00       	push   $0x804631
  802174:	e8 25 19 00 00       	call   803a9e <_panic>
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	74 10                	je     802192 <initialize_dynamic_allocator+0x9c>
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218a:	8b 52 04             	mov    0x4(%edx),%edx
  80218d:	89 50 04             	mov    %edx,0x4(%eax)
  802190:	eb 0b                	jmp    80219d <initialize_dynamic_allocator+0xa7>
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 40 04             	mov    0x4(%eax),%eax
  802198:	a3 30 50 80 00       	mov    %eax,0x805030
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 04             	mov    0x4(%eax),%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	74 0f                	je     8021b6 <initialize_dynamic_allocator+0xc0>
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 04             	mov    0x4(%eax),%eax
  8021ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b0:	8b 12                	mov    (%edx),%edx
  8021b2:	89 10                	mov    %edx,(%eax)
  8021b4:	eb 0a                	jmp    8021c0 <initialize_dynamic_allocator+0xca>
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8021d8:	48                   	dec    %eax
  8021d9:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021de:	a1 34 50 80 00       	mov    0x805034,%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ea:	74 07                	je     8021f3 <initialize_dynamic_allocator+0xfd>
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	eb 05                	jmp    8021f8 <initialize_dynamic_allocator+0x102>
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	a3 34 50 80 00       	mov    %eax,0x805034
  8021fd:	a1 34 50 80 00       	mov    0x805034,%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	0f 85 55 ff ff ff    	jne    80215f <initialize_dynamic_allocator+0x69>
  80220a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220e:	0f 85 4b ff ff ff    	jne    80215f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80221a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802223:	a1 44 50 80 00       	mov    0x805044,%eax
  802228:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80222d:	a1 40 50 80 00       	mov    0x805040,%eax
  802232:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	83 c0 08             	add    $0x8,%eax
  80223e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	83 c0 04             	add    $0x4,%eax
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	83 ea 08             	sub    $0x8,%edx
  80224d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80224f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	01 d0                	add    %edx,%eax
  802257:	83 e8 08             	sub    $0x8,%eax
  80225a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225d:	83 ea 08             	sub    $0x8,%edx
  802260:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802279:	75 17                	jne    802292 <initialize_dynamic_allocator+0x19c>
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 4c 46 80 00       	push   $0x80464c
  802283:	68 90 00 00 00       	push   $0x90
  802288:	68 31 46 80 00       	push   $0x804631
  80228d:	e8 0c 18 00 00       	call   803a9e <_panic>
  802292:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 0d                	je     8022b3 <initialize_dynamic_allocator+0x1bd>
  8022a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
  8022b1:	eb 08                	jmp    8022bb <initialize_dynamic_allocator+0x1c5>
  8022b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d2:	40                   	inc    %eax
  8022d3:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d8:	eb 07                	jmp    8022e1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022da:	90                   	nop
  8022db:	eb 04                	jmp    8022e1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022dd:	90                   	nop
  8022de:	eb 01                	jmp    8022e1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022e0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	83 e8 04             	sub    $0x4,%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	83 e0 fe             	and    $0xfffffffe,%eax
  802302:	8d 50 f8             	lea    -0x8(%eax),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	01 c2                	add    %eax,%edx
  80230a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230d:	89 02                	mov    %eax,(%edx)
}
  80230f:	90                   	nop
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    

00802312 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	83 e0 01             	and    $0x1,%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	74 03                	je     802325 <alloc_block_FF+0x13>
  802322:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802325:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802329:	77 07                	ja     802332 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80232b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802332:	a1 24 50 80 00       	mov    0x805024,%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	75 73                	jne    8023ae <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	83 c0 10             	add    $0x10,%eax
  802341:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802344:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80234b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802351:	01 d0                	add    %edx,%eax
  802353:	48                   	dec    %eax
  802354:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80235a:	ba 00 00 00 00       	mov    $0x0,%edx
  80235f:	f7 75 ec             	divl   -0x14(%ebp)
  802362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802365:	29 d0                	sub    %edx,%eax
  802367:	c1 e8 0c             	shr    $0xc,%eax
  80236a:	83 ec 0c             	sub    $0xc,%esp
  80236d:	50                   	push   %eax
  80236e:	e8 d4 f0 ff ff       	call   801447 <sbrk>
  802373:	83 c4 10             	add    $0x10,%esp
  802376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802379:	83 ec 0c             	sub    $0xc,%esp
  80237c:	6a 00                	push   $0x0
  80237e:	e8 c4 f0 ff ff       	call   801447 <sbrk>
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802389:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80238f:	83 ec 08             	sub    $0x8,%esp
  802392:	50                   	push   %eax
  802393:	ff 75 e4             	pushl  -0x1c(%ebp)
  802396:	e8 5b fd ff ff       	call   8020f6 <initialize_dynamic_allocator>
  80239b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80239e:	83 ec 0c             	sub    $0xc,%esp
  8023a1:	68 6f 46 80 00       	push   $0x80466f
  8023a6:	e8 02 e3 ff ff       	call   8006ad <cprintf>
  8023ab:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b2:	75 0a                	jne    8023be <alloc_block_FF+0xac>
	        return NULL;
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	e9 0e 04 00 00       	jmp    8027cc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cd:	e9 f3 02 00 00       	jmp    8026c5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	ff 75 bc             	pushl  -0x44(%ebp)
  8023de:	e8 af fb ff ff       	call   801f92 <get_block_size>
  8023e3:	83 c4 10             	add    $0x10,%esp
  8023e6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	83 c0 08             	add    $0x8,%eax
  8023ef:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023f2:	0f 87 c5 02 00 00    	ja     8026bd <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	83 c0 18             	add    $0x18,%eax
  8023fe:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802401:	0f 87 19 02 00 00    	ja     802620 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802407:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80240a:	2b 45 08             	sub    0x8(%ebp),%eax
  80240d:	83 e8 08             	sub    $0x8,%eax
  802410:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	8d 50 08             	lea    0x8(%eax),%edx
  802419:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80241c:	01 d0                	add    %edx,%eax
  80241e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	83 c0 08             	add    $0x8,%eax
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	6a 01                	push   $0x1
  80242c:	50                   	push   %eax
  80242d:	ff 75 bc             	pushl  -0x44(%ebp)
  802430:	e8 ae fe ff ff       	call   8022e3 <set_block_data>
  802435:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	75 68                	jne    8024aa <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802442:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802446:	75 17                	jne    80245f <alloc_block_FF+0x14d>
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	68 4c 46 80 00       	push   $0x80464c
  802450:	68 d7 00 00 00       	push   $0xd7
  802455:	68 31 46 80 00       	push   $0x804631
  80245a:	e8 3f 16 00 00       	call   803a9e <_panic>
  80245f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802465:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802468:	89 10                	mov    %edx,(%eax)
  80246a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 0d                	je     802480 <alloc_block_FF+0x16e>
  802473:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802478:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	eb 08                	jmp    802488 <alloc_block_FF+0x176>
  802480:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802483:	a3 30 50 80 00       	mov    %eax,0x805030
  802488:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802490:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249a:	a1 38 50 80 00       	mov    0x805038,%eax
  80249f:	40                   	inc    %eax
  8024a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a5:	e9 dc 00 00 00       	jmp    802586 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	75 65                	jne    802518 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024b3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b7:	75 17                	jne    8024d0 <alloc_block_FF+0x1be>
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	68 80 46 80 00       	push   $0x804680
  8024c1:	68 db 00 00 00       	push   $0xdb
  8024c6:	68 31 46 80 00       	push   $0x804631
  8024cb:	e8 ce 15 00 00       	call   803a9e <_panic>
  8024d0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)
  8024dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	74 0c                	je     8024f2 <alloc_block_FF+0x1e0>
  8024e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8024eb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	eb 08                	jmp    8024fa <alloc_block_FF+0x1e8>
  8024f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fd:	a3 30 50 80 00       	mov    %eax,0x805030
  802502:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250b:	a1 38 50 80 00       	mov    0x805038,%eax
  802510:	40                   	inc    %eax
  802511:	a3 38 50 80 00       	mov    %eax,0x805038
  802516:	eb 6e                	jmp    802586 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251c:	74 06                	je     802524 <alloc_block_FF+0x212>
  80251e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802522:	75 17                	jne    80253b <alloc_block_FF+0x229>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 a4 46 80 00       	push   $0x8046a4
  80252c:	68 df 00 00 00       	push   $0xdf
  802531:	68 31 46 80 00       	push   $0x804631
  802536:	e8 63 15 00 00       	call   803a9e <_panic>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 10                	mov    (%eax),%edx
  802540:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802543:	89 10                	mov    %edx,(%eax)
  802545:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0b                	je     802559 <alloc_block_FF+0x247>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802556:	89 50 04             	mov    %edx,0x4(%eax)
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80255f:	89 10                	mov    %edx,(%eax)
  802561:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802567:	89 50 04             	mov    %edx,0x4(%eax)
  80256a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	75 08                	jne    80257b <alloc_block_FF+0x269>
  802573:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802576:	a3 30 50 80 00       	mov    %eax,0x805030
  80257b:	a1 38 50 80 00       	mov    0x805038,%eax
  802580:	40                   	inc    %eax
  802581:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258a:	75 17                	jne    8025a3 <alloc_block_FF+0x291>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 13 46 80 00       	push   $0x804613
  802594:	68 e1 00 00 00       	push   $0xe1
  802599:	68 31 46 80 00       	push   $0x804631
  80259e:	e8 fb 14 00 00       	call   803a9e <_panic>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 10                	je     8025bc <alloc_block_FF+0x2aa>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b4:	8b 52 04             	mov    0x4(%edx),%edx
  8025b7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ba:	eb 0b                	jmp    8025c7 <alloc_block_FF+0x2b5>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 0f                	je     8025e0 <alloc_block_FF+0x2ce>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025da:	8b 12                	mov    (%edx),%edx
  8025dc:	89 10                	mov    %edx,(%eax)
  8025de:	eb 0a                	jmp    8025ea <alloc_block_FF+0x2d8>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802602:	48                   	dec    %eax
  802603:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	6a 00                	push   $0x0
  80260d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802610:	ff 75 b0             	pushl  -0x50(%ebp)
  802613:	e8 cb fc ff ff       	call   8022e3 <set_block_data>
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	e9 95 00 00 00       	jmp    8026b5 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	6a 01                	push   $0x1
  802625:	ff 75 b8             	pushl  -0x48(%ebp)
  802628:	ff 75 bc             	pushl  -0x44(%ebp)
  80262b:	e8 b3 fc ff ff       	call   8022e3 <set_block_data>
  802630:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802637:	75 17                	jne    802650 <alloc_block_FF+0x33e>
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	68 13 46 80 00       	push   $0x804613
  802641:	68 e8 00 00 00       	push   $0xe8
  802646:	68 31 46 80 00       	push   $0x804631
  80264b:	e8 4e 14 00 00       	call   803a9e <_panic>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 10                	je     802669 <alloc_block_FF+0x357>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802661:	8b 52 04             	mov    0x4(%edx),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	eb 0b                	jmp    802674 <alloc_block_FF+0x362>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	a3 30 50 80 00       	mov    %eax,0x805030
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0f                	je     80268d <alloc_block_FF+0x37b>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802687:	8b 12                	mov    (%edx),%edx
  802689:	89 10                	mov    %edx,(%eax)
  80268b:	eb 0a                	jmp    802697 <alloc_block_FF+0x385>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8026af:	48                   	dec    %eax
  8026b0:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026b8:	e9 0f 01 00 00       	jmp    8027cc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c9:	74 07                	je     8026d2 <alloc_block_FF+0x3c0>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	eb 05                	jmp    8026d7 <alloc_block_FF+0x3c5>
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8026dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	0f 85 e9 fc ff ff    	jne    8023d2 <alloc_block_FF+0xc0>
  8026e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ed:	0f 85 df fc ff ff    	jne    8023d2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	83 c0 08             	add    $0x8,%eax
  8026f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026fc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802703:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802706:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	48                   	dec    %eax
  80270c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80270f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802712:	ba 00 00 00 00       	mov    $0x0,%edx
  802717:	f7 75 d8             	divl   -0x28(%ebp)
  80271a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271d:	29 d0                	sub    %edx,%eax
  80271f:	c1 e8 0c             	shr    $0xc,%eax
  802722:	83 ec 0c             	sub    $0xc,%esp
  802725:	50                   	push   %eax
  802726:	e8 1c ed ff ff       	call   801447 <sbrk>
  80272b:	83 c4 10             	add    $0x10,%esp
  80272e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802731:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802735:	75 0a                	jne    802741 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
  80273c:	e9 8b 00 00 00       	jmp    8027cc <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802741:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802748:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80274b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274e:	01 d0                	add    %edx,%eax
  802750:	48                   	dec    %eax
  802751:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802754:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802757:	ba 00 00 00 00       	mov    $0x0,%edx
  80275c:	f7 75 cc             	divl   -0x34(%ebp)
  80275f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802762:	29 d0                	sub    %edx,%eax
  802764:	8d 50 fc             	lea    -0x4(%eax),%edx
  802767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80276a:	01 d0                	add    %edx,%eax
  80276c:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802771:	a1 40 50 80 00       	mov    0x805040,%eax
  802776:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80277c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802783:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802786:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802789:	01 d0                	add    %edx,%eax
  80278b:	48                   	dec    %eax
  80278c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80278f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802792:	ba 00 00 00 00       	mov    $0x0,%edx
  802797:	f7 75 c4             	divl   -0x3c(%ebp)
  80279a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80279d:	29 d0                	sub    %edx,%eax
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	6a 01                	push   $0x1
  8027a4:	50                   	push   %eax
  8027a5:	ff 75 d0             	pushl  -0x30(%ebp)
  8027a8:	e8 36 fb ff ff       	call   8022e3 <set_block_data>
  8027ad:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027b0:	83 ec 0c             	sub    $0xc,%esp
  8027b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8027b6:	e8 1b 0a 00 00       	call   8031d6 <free_block>
  8027bb:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	ff 75 08             	pushl  0x8(%ebp)
  8027c4:	e8 49 fb ff ff       	call   802312 <alloc_block_FF>
  8027c9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027cc:	c9                   	leave  
  8027cd:	c3                   	ret    

008027ce <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	83 e0 01             	and    $0x1,%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	74 03                	je     8027e1 <alloc_block_BF+0x13>
  8027de:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027e1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027e5:	77 07                	ja     8027ee <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027e7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 73                	jne    80286a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	83 c0 10             	add    $0x10,%eax
  8027fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802800:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802807:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80280a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280d:	01 d0                	add    %edx,%eax
  80280f:	48                   	dec    %eax
  802810:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802813:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802816:	ba 00 00 00 00       	mov    $0x0,%edx
  80281b:	f7 75 e0             	divl   -0x20(%ebp)
  80281e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802821:	29 d0                	sub    %edx,%eax
  802823:	c1 e8 0c             	shr    $0xc,%eax
  802826:	83 ec 0c             	sub    $0xc,%esp
  802829:	50                   	push   %eax
  80282a:	e8 18 ec ff ff       	call   801447 <sbrk>
  80282f:	83 c4 10             	add    $0x10,%esp
  802832:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802835:	83 ec 0c             	sub    $0xc,%esp
  802838:	6a 00                	push   $0x0
  80283a:	e8 08 ec ff ff       	call   801447 <sbrk>
  80283f:	83 c4 10             	add    $0x10,%esp
  802842:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802848:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80284b:	83 ec 08             	sub    $0x8,%esp
  80284e:	50                   	push   %eax
  80284f:	ff 75 d8             	pushl  -0x28(%ebp)
  802852:	e8 9f f8 ff ff       	call   8020f6 <initialize_dynamic_allocator>
  802857:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	68 6f 46 80 00       	push   $0x80466f
  802862:	e8 46 de ff ff       	call   8006ad <cprintf>
  802867:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80286a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802871:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802878:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80287f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802886:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80288b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288e:	e9 1d 01 00 00       	jmp    8029b0 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	ff 75 a8             	pushl  -0x58(%ebp)
  80289f:	e8 ee f6 ff ff       	call   801f92 <get_block_size>
  8028a4:	83 c4 10             	add    $0x10,%esp
  8028a7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	83 c0 08             	add    $0x8,%eax
  8028b0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b3:	0f 87 ef 00 00 00    	ja     8029a8 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	83 c0 18             	add    $0x18,%eax
  8028bf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c2:	77 1d                	ja     8028e1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ca:	0f 86 d8 00 00 00    	jbe    8029a8 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028d6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028dc:	e9 c7 00 00 00       	jmp    8029a8 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	83 c0 08             	add    $0x8,%eax
  8028e7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ea:	0f 85 9d 00 00 00    	jne    80298d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	6a 01                	push   $0x1
  8028f5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028f8:	ff 75 a8             	pushl  -0x58(%ebp)
  8028fb:	e8 e3 f9 ff ff       	call   8022e3 <set_block_data>
  802900:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802907:	75 17                	jne    802920 <alloc_block_BF+0x152>
  802909:	83 ec 04             	sub    $0x4,%esp
  80290c:	68 13 46 80 00       	push   $0x804613
  802911:	68 2c 01 00 00       	push   $0x12c
  802916:	68 31 46 80 00       	push   $0x804631
  80291b:	e8 7e 11 00 00       	call   803a9e <_panic>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	74 10                	je     802939 <alloc_block_BF+0x16b>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	8b 52 04             	mov    0x4(%edx),%edx
  802934:	89 50 04             	mov    %edx,0x4(%eax)
  802937:	eb 0b                	jmp    802944 <alloc_block_BF+0x176>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	a3 30 50 80 00       	mov    %eax,0x805030
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	85 c0                	test   %eax,%eax
  80294c:	74 0f                	je     80295d <alloc_block_BF+0x18f>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 40 04             	mov    0x4(%eax),%eax
  802954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802957:	8b 12                	mov    (%edx),%edx
  802959:	89 10                	mov    %edx,(%eax)
  80295b:	eb 0a                	jmp    802967 <alloc_block_BF+0x199>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297a:	a1 38 50 80 00       	mov    0x805038,%eax
  80297f:	48                   	dec    %eax
  802980:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802985:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802988:	e9 24 04 00 00       	jmp    802db1 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802993:	76 13                	jbe    8029a8 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802995:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80299c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80299f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029a2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029a5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8029ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b4:	74 07                	je     8029bd <alloc_block_BF+0x1ef>
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	eb 05                	jmp    8029c2 <alloc_block_BF+0x1f4>
  8029bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8029c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	0f 85 bf fe ff ff    	jne    802893 <alloc_block_BF+0xc5>
  8029d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d8:	0f 85 b5 fe ff ff    	jne    802893 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e2:	0f 84 26 02 00 00    	je     802c0e <alloc_block_BF+0x440>
  8029e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ec:	0f 85 1c 02 00 00    	jne    802c0e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f8:	83 e8 08             	sub    $0x8,%eax
  8029fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	8d 50 08             	lea    0x8(%eax),%edx
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	83 c0 08             	add    $0x8,%eax
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	6a 01                	push   $0x1
  802a17:	50                   	push   %eax
  802a18:	ff 75 f0             	pushl  -0x10(%ebp)
  802a1b:	e8 c3 f8 ff ff       	call   8022e3 <set_block_data>
  802a20:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 68                	jne    802a95 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a31:	75 17                	jne    802a4a <alloc_block_BF+0x27c>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 4c 46 80 00       	push   $0x80464c
  802a3b:	68 45 01 00 00       	push   $0x145
  802a40:	68 31 46 80 00       	push   $0x804631
  802a45:	e8 54 10 00 00       	call   803a9e <_panic>
  802a4a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0d                	je     802a6b <alloc_block_BF+0x29d>
  802a5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 08                	jmp    802a73 <alloc_block_BF+0x2a5>
  802a6b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a85:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8a:	40                   	inc    %eax
  802a8b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a90:	e9 dc 00 00 00       	jmp    802b71 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	75 65                	jne    802b03 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a9e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aa2:	75 17                	jne    802abb <alloc_block_BF+0x2ed>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 80 46 80 00       	push   $0x804680
  802aac:	68 4a 01 00 00       	push   $0x14a
  802ab1:	68 31 46 80 00       	push   $0x804631
  802ab6:	e8 e3 0f 00 00       	call   803a9e <_panic>
  802abb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ac1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 0c                	je     802add <alloc_block_BF+0x30f>
  802ad1:	a1 30 50 80 00       	mov    0x805030,%eax
  802ad6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	eb 08                	jmp    802ae5 <alloc_block_BF+0x317>
  802add:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae8:	a3 30 50 80 00       	mov    %eax,0x805030
  802aed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af6:	a1 38 50 80 00       	mov    0x805038,%eax
  802afb:	40                   	inc    %eax
  802afc:	a3 38 50 80 00       	mov    %eax,0x805038
  802b01:	eb 6e                	jmp    802b71 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b07:	74 06                	je     802b0f <alloc_block_BF+0x341>
  802b09:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b0d:	75 17                	jne    802b26 <alloc_block_BF+0x358>
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	68 a4 46 80 00       	push   $0x8046a4
  802b17:	68 4f 01 00 00       	push   $0x14f
  802b1c:	68 31 46 80 00       	push   $0x804631
  802b21:	e8 78 0f 00 00       	call   803a9e <_panic>
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 10                	mov    (%eax),%edx
  802b2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0b                	je     802b44 <alloc_block_BF+0x376>
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4a:	89 10                	mov    %edx,(%eax)
  802b4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	75 08                	jne    802b66 <alloc_block_BF+0x398>
  802b5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b61:	a3 30 50 80 00       	mov    %eax,0x805030
  802b66:	a1 38 50 80 00       	mov    0x805038,%eax
  802b6b:	40                   	inc    %eax
  802b6c:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b75:	75 17                	jne    802b8e <alloc_block_BF+0x3c0>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 13 46 80 00       	push   $0x804613
  802b7f:	68 51 01 00 00       	push   $0x151
  802b84:	68 31 46 80 00       	push   $0x804631
  802b89:	e8 10 0f 00 00       	call   803a9e <_panic>
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 10                	je     802ba7 <alloc_block_BF+0x3d9>
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ba2:	89 50 04             	mov    %edx,0x4(%eax)
  802ba5:	eb 0b                	jmp    802bb2 <alloc_block_BF+0x3e4>
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0f                	je     802bcb <alloc_block_BF+0x3fd>
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc5:	8b 12                	mov    (%edx),%edx
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	eb 0a                	jmp    802bd5 <alloc_block_BF+0x407>
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bed:	48                   	dec    %eax
  802bee:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	6a 00                	push   $0x0
  802bf8:	ff 75 d0             	pushl  -0x30(%ebp)
  802bfb:	ff 75 cc             	pushl  -0x34(%ebp)
  802bfe:	e8 e0 f6 ff ff       	call   8022e3 <set_block_data>
  802c03:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	e9 a3 01 00 00       	jmp    802db1 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c0e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c12:	0f 85 9d 00 00 00    	jne    802cb5 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	6a 01                	push   $0x1
  802c1d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c20:	ff 75 f0             	pushl  -0x10(%ebp)
  802c23:	e8 bb f6 ff ff       	call   8022e3 <set_block_data>
  802c28:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2f:	75 17                	jne    802c48 <alloc_block_BF+0x47a>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 13 46 80 00       	push   $0x804613
  802c39:	68 58 01 00 00       	push   $0x158
  802c3e:	68 31 46 80 00       	push   $0x804631
  802c43:	e8 56 0e 00 00       	call   803a9e <_panic>
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 10                	je     802c61 <alloc_block_BF+0x493>
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c59:	8b 52 04             	mov    0x4(%edx),%edx
  802c5c:	89 50 04             	mov    %edx,0x4(%eax)
  802c5f:	eb 0b                	jmp    802c6c <alloc_block_BF+0x49e>
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	a3 30 50 80 00       	mov    %eax,0x805030
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 0f                	je     802c85 <alloc_block_BF+0x4b7>
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7f:	8b 12                	mov    (%edx),%edx
  802c81:	89 10                	mov    %edx,(%eax)
  802c83:	eb 0a                	jmp    802c8f <alloc_block_BF+0x4c1>
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca7:	48                   	dec    %eax
  802ca8:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	e9 fc 00 00 00       	jmp    802db1 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	83 c0 08             	add    $0x8,%eax
  802cbb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cbe:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cc5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ccb:	01 d0                	add    %edx,%eax
  802ccd:	48                   	dec    %eax
  802cce:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cd1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd9:	f7 75 c4             	divl   -0x3c(%ebp)
  802cdc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cdf:	29 d0                	sub    %edx,%eax
  802ce1:	c1 e8 0c             	shr    $0xc,%eax
  802ce4:	83 ec 0c             	sub    $0xc,%esp
  802ce7:	50                   	push   %eax
  802ce8:	e8 5a e7 ff ff       	call   801447 <sbrk>
  802ced:	83 c4 10             	add    $0x10,%esp
  802cf0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cf3:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cf7:	75 0a                	jne    802d03 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfe:	e9 ae 00 00 00       	jmp    802db1 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d03:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d0a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d10:	01 d0                	add    %edx,%eax
  802d12:	48                   	dec    %eax
  802d13:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d19:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1e:	f7 75 b8             	divl   -0x48(%ebp)
  802d21:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d24:	29 d0                	sub    %edx,%eax
  802d26:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d29:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d2c:	01 d0                	add    %edx,%eax
  802d2e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d33:	a1 40 50 80 00       	mov    0x805040,%eax
  802d38:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	68 d8 46 80 00       	push   $0x8046d8
  802d46:	e8 62 d9 ff ff       	call   8006ad <cprintf>
  802d4b:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d4e:	83 ec 08             	sub    $0x8,%esp
  802d51:	ff 75 bc             	pushl  -0x44(%ebp)
  802d54:	68 dd 46 80 00       	push   $0x8046dd
  802d59:	e8 4f d9 ff ff       	call   8006ad <cprintf>
  802d5e:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d61:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d68:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d6e:	01 d0                	add    %edx,%eax
  802d70:	48                   	dec    %eax
  802d71:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d74:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d77:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7c:	f7 75 b0             	divl   -0x50(%ebp)
  802d7f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d82:	29 d0                	sub    %edx,%eax
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	6a 01                	push   $0x1
  802d89:	50                   	push   %eax
  802d8a:	ff 75 bc             	pushl  -0x44(%ebp)
  802d8d:	e8 51 f5 ff ff       	call   8022e3 <set_block_data>
  802d92:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 bc             	pushl  -0x44(%ebp)
  802d9b:	e8 36 04 00 00       	call   8031d6 <free_block>
  802da0:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	e8 20 fa ff ff       	call   8027ce <alloc_block_BF>
  802dae:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
  802db6:	53                   	push   %ebx
  802db7:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcc:	74 1e                	je     802dec <merging+0x39>
  802dce:	ff 75 08             	pushl  0x8(%ebp)
  802dd1:	e8 bc f1 ff ff       	call   801f92 <get_block_size>
  802dd6:	83 c4 04             	add    $0x4,%esp
  802dd9:	89 c2                	mov    %eax,%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	01 d0                	add    %edx,%eax
  802de0:	3b 45 10             	cmp    0x10(%ebp),%eax
  802de3:	75 07                	jne    802dec <merging+0x39>
		prev_is_free = 1;
  802de5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df0:	74 1e                	je     802e10 <merging+0x5d>
  802df2:	ff 75 10             	pushl  0x10(%ebp)
  802df5:	e8 98 f1 ff ff       	call   801f92 <get_block_size>
  802dfa:	83 c4 04             	add    $0x4,%esp
  802dfd:	89 c2                	mov    %eax,%edx
  802dff:	8b 45 10             	mov    0x10(%ebp),%eax
  802e02:	01 d0                	add    %edx,%eax
  802e04:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e07:	75 07                	jne    802e10 <merging+0x5d>
		next_is_free = 1;
  802e09:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e14:	0f 84 cc 00 00 00    	je     802ee6 <merging+0x133>
  802e1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1e:	0f 84 c2 00 00 00    	je     802ee6 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e24:	ff 75 08             	pushl  0x8(%ebp)
  802e27:	e8 66 f1 ff ff       	call   801f92 <get_block_size>
  802e2c:	83 c4 04             	add    $0x4,%esp
  802e2f:	89 c3                	mov    %eax,%ebx
  802e31:	ff 75 10             	pushl  0x10(%ebp)
  802e34:	e8 59 f1 ff ff       	call   801f92 <get_block_size>
  802e39:	83 c4 04             	add    $0x4,%esp
  802e3c:	01 c3                	add    %eax,%ebx
  802e3e:	ff 75 0c             	pushl  0xc(%ebp)
  802e41:	e8 4c f1 ff ff       	call   801f92 <get_block_size>
  802e46:	83 c4 04             	add    $0x4,%esp
  802e49:	01 d8                	add    %ebx,%eax
  802e4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e4e:	6a 00                	push   $0x0
  802e50:	ff 75 ec             	pushl  -0x14(%ebp)
  802e53:	ff 75 08             	pushl  0x8(%ebp)
  802e56:	e8 88 f4 ff ff       	call   8022e3 <set_block_data>
  802e5b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e62:	75 17                	jne    802e7b <merging+0xc8>
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	68 13 46 80 00       	push   $0x804613
  802e6c:	68 7d 01 00 00       	push   $0x17d
  802e71:	68 31 46 80 00       	push   $0x804631
  802e76:	e8 23 0c 00 00       	call   803a9e <_panic>
  802e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 10                	je     802e94 <merging+0xe1>
  802e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8c:	8b 52 04             	mov    0x4(%edx),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	eb 0b                	jmp    802e9f <merging+0xec>
  802e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e97:	8b 40 04             	mov    0x4(%eax),%eax
  802e9a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 0f                	je     802eb8 <merging+0x105>
  802ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eac:	8b 40 04             	mov    0x4(%eax),%eax
  802eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb2:	8b 12                	mov    (%edx),%edx
  802eb4:	89 10                	mov    %edx,(%eax)
  802eb6:	eb 0a                	jmp    802ec2 <merging+0x10f>
  802eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed5:	a1 38 50 80 00       	mov    0x805038,%eax
  802eda:	48                   	dec    %eax
  802edb:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ee0:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ee1:	e9 ea 02 00 00       	jmp    8031d0 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eea:	74 3b                	je     802f27 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802eec:	83 ec 0c             	sub    $0xc,%esp
  802eef:	ff 75 08             	pushl  0x8(%ebp)
  802ef2:	e8 9b f0 ff ff       	call   801f92 <get_block_size>
  802ef7:	83 c4 10             	add    $0x10,%esp
  802efa:	89 c3                	mov    %eax,%ebx
  802efc:	83 ec 0c             	sub    $0xc,%esp
  802eff:	ff 75 10             	pushl  0x10(%ebp)
  802f02:	e8 8b f0 ff ff       	call   801f92 <get_block_size>
  802f07:	83 c4 10             	add    $0x10,%esp
  802f0a:	01 d8                	add    %ebx,%eax
  802f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	6a 00                	push   $0x0
  802f14:	ff 75 e8             	pushl  -0x18(%ebp)
  802f17:	ff 75 08             	pushl  0x8(%ebp)
  802f1a:	e8 c4 f3 ff ff       	call   8022e3 <set_block_data>
  802f1f:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f22:	e9 a9 02 00 00       	jmp    8031d0 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2b:	0f 84 2d 01 00 00    	je     80305e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f31:	83 ec 0c             	sub    $0xc,%esp
  802f34:	ff 75 10             	pushl  0x10(%ebp)
  802f37:	e8 56 f0 ff ff       	call   801f92 <get_block_size>
  802f3c:	83 c4 10             	add    $0x10,%esp
  802f3f:	89 c3                	mov    %eax,%ebx
  802f41:	83 ec 0c             	sub    $0xc,%esp
  802f44:	ff 75 0c             	pushl  0xc(%ebp)
  802f47:	e8 46 f0 ff ff       	call   801f92 <get_block_size>
  802f4c:	83 c4 10             	add    $0x10,%esp
  802f4f:	01 d8                	add    %ebx,%eax
  802f51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f54:	83 ec 04             	sub    $0x4,%esp
  802f57:	6a 00                	push   $0x0
  802f59:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f5c:	ff 75 10             	pushl  0x10(%ebp)
  802f5f:	e8 7f f3 ff ff       	call   8022e3 <set_block_data>
  802f64:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f67:	8b 45 10             	mov    0x10(%ebp),%eax
  802f6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f71:	74 06                	je     802f79 <merging+0x1c6>
  802f73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f77:	75 17                	jne    802f90 <merging+0x1dd>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 ec 46 80 00       	push   $0x8046ec
  802f81:	68 8d 01 00 00       	push   $0x18d
  802f86:	68 31 46 80 00       	push   $0x804631
  802f8b:	e8 0e 0b 00 00       	call   803a9e <_panic>
  802f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f93:	8b 50 04             	mov    0x4(%eax),%edx
  802f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f99:	89 50 04             	mov    %edx,0x4(%eax)
  802f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa2:	89 10                	mov    %edx,(%eax)
  802fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 0d                	je     802fbb <merging+0x208>
  802fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb1:	8b 40 04             	mov    0x4(%eax),%eax
  802fb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 08                	jmp    802fc3 <merging+0x210>
  802fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdb:	75 17                	jne    802ff4 <merging+0x241>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 13 46 80 00       	push   $0x804613
  802fe5:	68 8e 01 00 00       	push   $0x18e
  802fea:	68 31 46 80 00       	push   $0x804631
  802fef:	e8 aa 0a 00 00       	call   803a9e <_panic>
  802ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 10                	je     80300d <merging+0x25a>
  802ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	8b 55 0c             	mov    0xc(%ebp),%edx
  803005:	8b 52 04             	mov    0x4(%edx),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 0b                	jmp    803018 <merging+0x265>
  80300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	a3 30 50 80 00       	mov    %eax,0x805030
  803018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0f                	je     803031 <merging+0x27e>
  803022:	8b 45 0c             	mov    0xc(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302b:	8b 12                	mov    (%edx),%edx
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	eb 0a                	jmp    80303b <merging+0x288>
  803031:	8b 45 0c             	mov    0xc(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803044:	8b 45 0c             	mov    0xc(%ebp),%eax
  803047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304e:	a1 38 50 80 00       	mov    0x805038,%eax
  803053:	48                   	dec    %eax
  803054:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803059:	e9 72 01 00 00       	jmp    8031d0 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80305e:	8b 45 10             	mov    0x10(%ebp),%eax
  803061:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803064:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803068:	74 79                	je     8030e3 <merging+0x330>
  80306a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306e:	74 73                	je     8030e3 <merging+0x330>
  803070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803074:	74 06                	je     80307c <merging+0x2c9>
  803076:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80307a:	75 17                	jne    803093 <merging+0x2e0>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 a4 46 80 00       	push   $0x8046a4
  803084:	68 94 01 00 00       	push   $0x194
  803089:	68 31 46 80 00       	push   $0x804631
  80308e:	e8 0b 0a 00 00       	call   803a9e <_panic>
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 10                	mov    (%eax),%edx
  803098:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0b                	je     8030b1 <merging+0x2fe>
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b7:	89 10                	mov    %edx,(%eax)
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bf:	89 50 04             	mov    %edx,0x4(%eax)
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	75 08                	jne    8030d3 <merging+0x320>
  8030cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d8:	40                   	inc    %eax
  8030d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8030de:	e9 ce 00 00 00       	jmp    8031b1 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e7:	74 65                	je     80314e <merging+0x39b>
  8030e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ed:	75 17                	jne    803106 <merging+0x353>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 80 46 80 00       	push   $0x804680
  8030f7:	68 95 01 00 00       	push   $0x195
  8030fc:	68 31 46 80 00       	push   $0x804631
  803101:	e8 98 09 00 00       	call   803a9e <_panic>
  803106:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80310c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803115:	8b 40 04             	mov    0x4(%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0c                	je     803128 <merging+0x375>
  80311c:	a1 30 50 80 00       	mov    0x805030,%eax
  803121:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803124:	89 10                	mov    %edx,(%eax)
  803126:	eb 08                	jmp    803130 <merging+0x37d>
  803128:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803133:	a3 30 50 80 00       	mov    %eax,0x805030
  803138:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	a1 38 50 80 00       	mov    0x805038,%eax
  803146:	40                   	inc    %eax
  803147:	a3 38 50 80 00       	mov    %eax,0x805038
  80314c:	eb 63                	jmp    8031b1 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80314e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803152:	75 17                	jne    80316b <merging+0x3b8>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 4c 46 80 00       	push   $0x80464c
  80315c:	68 98 01 00 00       	push   $0x198
  803161:	68 31 46 80 00       	push   $0x804631
  803166:	e8 33 09 00 00       	call   803a9e <_panic>
  80316b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803171:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803174:	89 10                	mov    %edx,(%eax)
  803176:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0d                	je     80318c <merging+0x3d9>
  80317f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803184:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	eb 08                	jmp    803194 <merging+0x3e1>
  80318c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318f:	a3 30 50 80 00       	mov    %eax,0x805030
  803194:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803197:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	ff 75 10             	pushl  0x10(%ebp)
  8031b7:	e8 d6 ed ff ff       	call   801f92 <get_block_size>
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	6a 00                	push   $0x0
  8031c4:	50                   	push   %eax
  8031c5:	ff 75 10             	pushl  0x10(%ebp)
  8031c8:	e8 16 f1 ff ff       	call   8022e3 <set_block_data>
  8031cd:	83 c4 10             	add    $0x10,%esp
	}
}
  8031d0:	90                   	nop
  8031d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d4:	c9                   	leave  
  8031d5:	c3                   	ret    

008031d6 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031d6:	55                   	push   %ebp
  8031d7:	89 e5                	mov    %esp,%ebp
  8031d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8031e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ec:	73 1b                	jae    803209 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8031f3:	83 ec 04             	sub    $0x4,%esp
  8031f6:	ff 75 08             	pushl  0x8(%ebp)
  8031f9:	6a 00                	push   $0x0
  8031fb:	50                   	push   %eax
  8031fc:	e8 b2 fb ff ff       	call   802db3 <merging>
  803201:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803204:	e9 8b 00 00 00       	jmp    803294 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803209:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803211:	76 18                	jbe    80322b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803213:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803218:	83 ec 04             	sub    $0x4,%esp
  80321b:	ff 75 08             	pushl  0x8(%ebp)
  80321e:	50                   	push   %eax
  80321f:	6a 00                	push   $0x0
  803221:	e8 8d fb ff ff       	call   802db3 <merging>
  803226:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803229:	eb 69                	jmp    803294 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80322b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803233:	eb 39                	jmp    80326e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	3b 45 08             	cmp    0x8(%ebp),%eax
  80323b:	73 29                	jae    803266 <free_block+0x90>
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	3b 45 08             	cmp    0x8(%ebp),%eax
  803245:	76 1f                	jbe    803266 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 00                	mov    (%eax),%eax
  80324c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	ff 75 08             	pushl  0x8(%ebp)
  803255:	ff 75 f0             	pushl  -0x10(%ebp)
  803258:	ff 75 f4             	pushl  -0xc(%ebp)
  80325b:	e8 53 fb ff ff       	call   802db3 <merging>
  803260:	83 c4 10             	add    $0x10,%esp
			break;
  803263:	90                   	nop
		}
	}
}
  803264:	eb 2e                	jmp    803294 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803266:	a1 34 50 80 00       	mov    0x805034,%eax
  80326b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803272:	74 07                	je     80327b <free_block+0xa5>
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	eb 05                	jmp    803280 <free_block+0xaa>
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	a3 34 50 80 00       	mov    %eax,0x805034
  803285:	a1 34 50 80 00       	mov    0x805034,%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	75 a7                	jne    803235 <free_block+0x5f>
  80328e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803292:	75 a1                	jne    803235 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803294:	90                   	nop
  803295:	c9                   	leave  
  803296:	c3                   	ret    

00803297 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803297:	55                   	push   %ebp
  803298:	89 e5                	mov    %esp,%ebp
  80329a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80329d:	ff 75 08             	pushl  0x8(%ebp)
  8032a0:	e8 ed ec ff ff       	call   801f92 <get_block_size>
  8032a5:	83 c4 04             	add    $0x4,%esp
  8032a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032b2:	eb 17                	jmp    8032cb <copy_data+0x34>
  8032b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ba:	01 c2                	add    %eax,%edx
  8032bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	01 c8                	add    %ecx,%eax
  8032c4:	8a 00                	mov    (%eax),%al
  8032c6:	88 02                	mov    %al,(%edx)
  8032c8:	ff 45 fc             	incl   -0x4(%ebp)
  8032cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032d1:	72 e1                	jb     8032b4 <copy_data+0x1d>
}
  8032d3:	90                   	nop
  8032d4:	c9                   	leave  
  8032d5:	c3                   	ret    

008032d6 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032d6:	55                   	push   %ebp
  8032d7:	89 e5                	mov    %esp,%ebp
  8032d9:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e0:	75 23                	jne    803305 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032e6:	74 13                	je     8032fb <realloc_block_FF+0x25>
  8032e8:	83 ec 0c             	sub    $0xc,%esp
  8032eb:	ff 75 0c             	pushl  0xc(%ebp)
  8032ee:	e8 1f f0 ff ff       	call   802312 <alloc_block_FF>
  8032f3:	83 c4 10             	add    $0x10,%esp
  8032f6:	e9 f4 06 00 00       	jmp    8039ef <realloc_block_FF+0x719>
		return NULL;
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803300:	e9 ea 06 00 00       	jmp    8039ef <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803309:	75 18                	jne    803323 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80330b:	83 ec 0c             	sub    $0xc,%esp
  80330e:	ff 75 08             	pushl  0x8(%ebp)
  803311:	e8 c0 fe ff ff       	call   8031d6 <free_block>
  803316:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803319:	b8 00 00 00 00       	mov    $0x0,%eax
  80331e:	e9 cc 06 00 00       	jmp    8039ef <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803323:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803327:	77 07                	ja     803330 <realloc_block_FF+0x5a>
  803329:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803330:	8b 45 0c             	mov    0xc(%ebp),%eax
  803333:	83 e0 01             	and    $0x1,%eax
  803336:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333c:	83 c0 08             	add    $0x8,%eax
  80333f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803342:	83 ec 0c             	sub    $0xc,%esp
  803345:	ff 75 08             	pushl  0x8(%ebp)
  803348:	e8 45 ec ff ff       	call   801f92 <get_block_size>
  80334d:	83 c4 10             	add    $0x10,%esp
  803350:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803353:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803356:	83 e8 08             	sub    $0x8,%eax
  803359:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	83 e8 04             	sub    $0x4,%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	83 e0 fe             	and    $0xfffffffe,%eax
  803367:	89 c2                	mov    %eax,%edx
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	01 d0                	add    %edx,%eax
  80336e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803371:	83 ec 0c             	sub    $0xc,%esp
  803374:	ff 75 e4             	pushl  -0x1c(%ebp)
  803377:	e8 16 ec ff ff       	call   801f92 <get_block_size>
  80337c:	83 c4 10             	add    $0x10,%esp
  80337f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803385:	83 e8 08             	sub    $0x8,%eax
  803388:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80338b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803391:	75 08                	jne    80339b <realloc_block_FF+0xc5>
	{
		 return va;
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	e9 54 06 00 00       	jmp    8039ef <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80339b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033a1:	0f 83 e5 03 00 00    	jae    80378c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033b0:	83 ec 0c             	sub    $0xc,%esp
  8033b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033b6:	e8 f0 eb ff ff       	call   801fab <is_free_block>
  8033bb:	83 c4 10             	add    $0x10,%esp
  8033be:	84 c0                	test   %al,%al
  8033c0:	0f 84 3b 01 00 00    	je     803501 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cc:	01 d0                	add    %edx,%eax
  8033ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	6a 01                	push   $0x1
  8033d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d9:	ff 75 08             	pushl  0x8(%ebp)
  8033dc:	e8 02 ef ff ff       	call   8022e3 <set_block_data>
  8033e1:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	83 e8 04             	sub    $0x4,%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	83 e0 fe             	and    $0xfffffffe,%eax
  8033ef:	89 c2                	mov    %eax,%edx
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	01 d0                	add    %edx,%eax
  8033f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	6a 00                	push   $0x0
  8033fe:	ff 75 cc             	pushl  -0x34(%ebp)
  803401:	ff 75 c8             	pushl  -0x38(%ebp)
  803404:	e8 da ee ff ff       	call   8022e3 <set_block_data>
  803409:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80340c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803410:	74 06                	je     803418 <realloc_block_FF+0x142>
  803412:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803416:	75 17                	jne    80342f <realloc_block_FF+0x159>
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	68 a4 46 80 00       	push   $0x8046a4
  803420:	68 f6 01 00 00       	push   $0x1f6
  803425:	68 31 46 80 00       	push   $0x804631
  80342a:	e8 6f 06 00 00       	call   803a9e <_panic>
  80342f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803432:	8b 10                	mov    (%eax),%edx
  803434:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803437:	89 10                	mov    %edx,(%eax)
  803439:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	85 c0                	test   %eax,%eax
  803440:	74 0b                	je     80344d <realloc_block_FF+0x177>
  803442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803453:	89 10                	mov    %edx,(%eax)
  803455:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345b:	89 50 04             	mov    %edx,0x4(%eax)
  80345e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	85 c0                	test   %eax,%eax
  803465:	75 08                	jne    80346f <realloc_block_FF+0x199>
  803467:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80346a:	a3 30 50 80 00       	mov    %eax,0x805030
  80346f:	a1 38 50 80 00       	mov    0x805038,%eax
  803474:	40                   	inc    %eax
  803475:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80347a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80347e:	75 17                	jne    803497 <realloc_block_FF+0x1c1>
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 13 46 80 00       	push   $0x804613
  803488:	68 f7 01 00 00       	push   $0x1f7
  80348d:	68 31 46 80 00       	push   $0x804631
  803492:	e8 07 06 00 00       	call   803a9e <_panic>
  803497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 10                	je     8034b0 <realloc_block_FF+0x1da>
  8034a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a8:	8b 52 04             	mov    0x4(%edx),%edx
  8034ab:	89 50 04             	mov    %edx,0x4(%eax)
  8034ae:	eb 0b                	jmp    8034bb <realloc_block_FF+0x1e5>
  8034b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034be:	8b 40 04             	mov    0x4(%eax),%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	74 0f                	je     8034d4 <realloc_block_FF+0x1fe>
  8034c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c8:	8b 40 04             	mov    0x4(%eax),%eax
  8034cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ce:	8b 12                	mov    (%edx),%edx
  8034d0:	89 10                	mov    %edx,(%eax)
  8034d2:	eb 0a                	jmp    8034de <realloc_block_FF+0x208>
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f6:	48                   	dec    %eax
  8034f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8034fc:	e9 83 02 00 00       	jmp    803784 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803501:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803505:	0f 86 69 02 00 00    	jbe    803774 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	6a 01                	push   $0x1
  803510:	ff 75 f0             	pushl  -0x10(%ebp)
  803513:	ff 75 08             	pushl  0x8(%ebp)
  803516:	e8 c8 ed ff ff       	call   8022e3 <set_block_data>
  80351b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	83 e8 04             	sub    $0x4,%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	83 e0 fe             	and    $0xfffffffe,%eax
  803529:	89 c2                	mov    %eax,%edx
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	01 d0                	add    %edx,%eax
  803530:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803533:	a1 38 50 80 00       	mov    0x805038,%eax
  803538:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80353b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80353f:	75 68                	jne    8035a9 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803541:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803545:	75 17                	jne    80355e <realloc_block_FF+0x288>
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	68 4c 46 80 00       	push   $0x80464c
  80354f:	68 06 02 00 00       	push   $0x206
  803554:	68 31 46 80 00       	push   $0x804631
  803559:	e8 40 05 00 00       	call   803a9e <_panic>
  80355e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803567:	89 10                	mov    %edx,(%eax)
  803569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0d                	je     80357f <realloc_block_FF+0x2a9>
  803572:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803577:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357a:	89 50 04             	mov    %edx,0x4(%eax)
  80357d:	eb 08                	jmp    803587 <realloc_block_FF+0x2b1>
  80357f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803582:	a3 30 50 80 00       	mov    %eax,0x805030
  803587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803599:	a1 38 50 80 00       	mov    0x805038,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a4:	e9 b0 01 00 00       	jmp    803759 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b1:	76 68                	jbe    80361b <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035b3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b7:	75 17                	jne    8035d0 <realloc_block_FF+0x2fa>
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 4c 46 80 00       	push   $0x80464c
  8035c1:	68 0b 02 00 00       	push   $0x20b
  8035c6:	68 31 46 80 00       	push   $0x804631
  8035cb:	e8 ce 04 00 00       	call   803a9e <_panic>
  8035d0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 0d                	je     8035f1 <realloc_block_FF+0x31b>
  8035e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	eb 08                	jmp    8035f9 <realloc_block_FF+0x323>
  8035f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803601:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360b:	a1 38 50 80 00       	mov    0x805038,%eax
  803610:	40                   	inc    %eax
  803611:	a3 38 50 80 00       	mov    %eax,0x805038
  803616:	e9 3e 01 00 00       	jmp    803759 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80361b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803620:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803623:	73 68                	jae    80368d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803625:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803629:	75 17                	jne    803642 <realloc_block_FF+0x36c>
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	68 80 46 80 00       	push   $0x804680
  803633:	68 10 02 00 00       	push   $0x210
  803638:	68 31 46 80 00       	push   $0x804631
  80363d:	e8 5c 04 00 00       	call   803a9e <_panic>
  803642:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364b:	89 50 04             	mov    %edx,0x4(%eax)
  80364e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803651:	8b 40 04             	mov    0x4(%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 0c                	je     803664 <realloc_block_FF+0x38e>
  803658:	a1 30 50 80 00       	mov    0x805030,%eax
  80365d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 08                	jmp    80366c <realloc_block_FF+0x396>
  803664:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803667:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80366c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366f:	a3 30 50 80 00       	mov    %eax,0x805030
  803674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367d:	a1 38 50 80 00       	mov    0x805038,%eax
  803682:	40                   	inc    %eax
  803683:	a3 38 50 80 00       	mov    %eax,0x805038
  803688:	e9 cc 00 00 00       	jmp    803759 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80368d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803694:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369c:	e9 8a 00 00 00       	jmp    80372b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a7:	73 7a                	jae    803723 <realloc_block_FF+0x44d>
  8036a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036b1:	73 70                	jae    803723 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b7:	74 06                	je     8036bf <realloc_block_FF+0x3e9>
  8036b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036bd:	75 17                	jne    8036d6 <realloc_block_FF+0x400>
  8036bf:	83 ec 04             	sub    $0x4,%esp
  8036c2:	68 a4 46 80 00       	push   $0x8046a4
  8036c7:	68 1a 02 00 00       	push   $0x21a
  8036cc:	68 31 46 80 00       	push   $0x804631
  8036d1:	e8 c8 03 00 00       	call   803a9e <_panic>
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 10                	mov    (%eax),%edx
  8036db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036de:	89 10                	mov    %edx,(%eax)
  8036e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	85 c0                	test   %eax,%eax
  8036e7:	74 0b                	je     8036f4 <realloc_block_FF+0x41e>
  8036e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ec:	8b 00                	mov    (%eax),%eax
  8036ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f1:	89 50 04             	mov    %edx,0x4(%eax)
  8036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036fa:	89 10                	mov    %edx,(%eax)
  8036fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803702:	89 50 04             	mov    %edx,0x4(%eax)
  803705:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	75 08                	jne    803716 <realloc_block_FF+0x440>
  80370e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803711:	a3 30 50 80 00       	mov    %eax,0x805030
  803716:	a1 38 50 80 00       	mov    0x805038,%eax
  80371b:	40                   	inc    %eax
  80371c:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803721:	eb 36                	jmp    803759 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803723:	a1 34 50 80 00       	mov    0x805034,%eax
  803728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372f:	74 07                	je     803738 <realloc_block_FF+0x462>
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	eb 05                	jmp    80373d <realloc_block_FF+0x467>
  803738:	b8 00 00 00 00       	mov    $0x0,%eax
  80373d:	a3 34 50 80 00       	mov    %eax,0x805034
  803742:	a1 34 50 80 00       	mov    0x805034,%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	0f 85 52 ff ff ff    	jne    8036a1 <realloc_block_FF+0x3cb>
  80374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803753:	0f 85 48 ff ff ff    	jne    8036a1 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803759:	83 ec 04             	sub    $0x4,%esp
  80375c:	6a 00                	push   $0x0
  80375e:	ff 75 d8             	pushl  -0x28(%ebp)
  803761:	ff 75 d4             	pushl  -0x2c(%ebp)
  803764:	e8 7a eb ff ff       	call   8022e3 <set_block_data>
  803769:	83 c4 10             	add    $0x10,%esp
				return va;
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	e9 7b 02 00 00       	jmp    8039ef <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803774:	83 ec 0c             	sub    $0xc,%esp
  803777:	68 21 47 80 00       	push   $0x804721
  80377c:	e8 2c cf ff ff       	call   8006ad <cprintf>
  803781:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	e9 63 02 00 00       	jmp    8039ef <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80378c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803792:	0f 86 4d 02 00 00    	jbe    8039e5 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803798:	83 ec 0c             	sub    $0xc,%esp
  80379b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80379e:	e8 08 e8 ff ff       	call   801fab <is_free_block>
  8037a3:	83 c4 10             	add    $0x10,%esp
  8037a6:	84 c0                	test   %al,%al
  8037a8:	0f 84 37 02 00 00    	je     8039e5 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037b4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037ba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037bd:	76 38                	jbe    8037f7 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037bf:	83 ec 0c             	sub    $0xc,%esp
  8037c2:	ff 75 08             	pushl  0x8(%ebp)
  8037c5:	e8 0c fa ff ff       	call   8031d6 <free_block>
  8037ca:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037cd:	83 ec 0c             	sub    $0xc,%esp
  8037d0:	ff 75 0c             	pushl  0xc(%ebp)
  8037d3:	e8 3a eb ff ff       	call   802312 <alloc_block_FF>
  8037d8:	83 c4 10             	add    $0x10,%esp
  8037db:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037de:	83 ec 08             	sub    $0x8,%esp
  8037e1:	ff 75 c0             	pushl  -0x40(%ebp)
  8037e4:	ff 75 08             	pushl  0x8(%ebp)
  8037e7:	e8 ab fa ff ff       	call   803297 <copy_data>
  8037ec:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037f2:	e9 f8 01 00 00       	jmp    8039ef <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fa:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803800:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803804:	0f 87 a0 00 00 00    	ja     8038aa <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80380a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380e:	75 17                	jne    803827 <realloc_block_FF+0x551>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 13 46 80 00       	push   $0x804613
  803818:	68 38 02 00 00       	push   $0x238
  80381d:	68 31 46 80 00       	push   $0x804631
  803822:	e8 77 02 00 00       	call   803a9e <_panic>
  803827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 10                	je     803840 <realloc_block_FF+0x56a>
  803830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803838:	8b 52 04             	mov    0x4(%edx),%edx
  80383b:	89 50 04             	mov    %edx,0x4(%eax)
  80383e:	eb 0b                	jmp    80384b <realloc_block_FF+0x575>
  803840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803843:	8b 40 04             	mov    0x4(%eax),%eax
  803846:	a3 30 50 80 00       	mov    %eax,0x805030
  80384b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384e:	8b 40 04             	mov    0x4(%eax),%eax
  803851:	85 c0                	test   %eax,%eax
  803853:	74 0f                	je     803864 <realloc_block_FF+0x58e>
  803855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803858:	8b 40 04             	mov    0x4(%eax),%eax
  80385b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385e:	8b 12                	mov    (%edx),%edx
  803860:	89 10                	mov    %edx,(%eax)
  803862:	eb 0a                	jmp    80386e <realloc_block_FF+0x598>
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80386e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803881:	a1 38 50 80 00       	mov    0x805038,%eax
  803886:	48                   	dec    %eax
  803887:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80388c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80388f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803892:	01 d0                	add    %edx,%eax
  803894:	83 ec 04             	sub    $0x4,%esp
  803897:	6a 01                	push   $0x1
  803899:	50                   	push   %eax
  80389a:	ff 75 08             	pushl  0x8(%ebp)
  80389d:	e8 41 ea ff ff       	call   8022e3 <set_block_data>
  8038a2:	83 c4 10             	add    $0x10,%esp
  8038a5:	e9 36 01 00 00       	jmp    8039e0 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038b0:	01 d0                	add    %edx,%eax
  8038b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	6a 01                	push   $0x1
  8038ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8038bd:	ff 75 08             	pushl  0x8(%ebp)
  8038c0:	e8 1e ea ff ff       	call   8022e3 <set_block_data>
  8038c5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	83 e8 04             	sub    $0x4,%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	83 e0 fe             	and    $0xfffffffe,%eax
  8038d3:	89 c2                	mov    %eax,%edx
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	01 d0                	add    %edx,%eax
  8038da:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e1:	74 06                	je     8038e9 <realloc_block_FF+0x613>
  8038e3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038e7:	75 17                	jne    803900 <realloc_block_FF+0x62a>
  8038e9:	83 ec 04             	sub    $0x4,%esp
  8038ec:	68 a4 46 80 00       	push   $0x8046a4
  8038f1:	68 44 02 00 00       	push   $0x244
  8038f6:	68 31 46 80 00       	push   $0x804631
  8038fb:	e8 9e 01 00 00       	call   803a9e <_panic>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 10                	mov    (%eax),%edx
  803905:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803908:	89 10                	mov    %edx,(%eax)
  80390a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	85 c0                	test   %eax,%eax
  803911:	74 0b                	je     80391e <realloc_block_FF+0x648>
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80391b:	89 50 04             	mov    %edx,0x4(%eax)
  80391e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803921:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803924:	89 10                	mov    %edx,(%eax)
  803926:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392c:	89 50 04             	mov    %edx,0x4(%eax)
  80392f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803932:	8b 00                	mov    (%eax),%eax
  803934:	85 c0                	test   %eax,%eax
  803936:	75 08                	jne    803940 <realloc_block_FF+0x66a>
  803938:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80393b:	a3 30 50 80 00       	mov    %eax,0x805030
  803940:	a1 38 50 80 00       	mov    0x805038,%eax
  803945:	40                   	inc    %eax
  803946:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80394b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80394f:	75 17                	jne    803968 <realloc_block_FF+0x692>
  803951:	83 ec 04             	sub    $0x4,%esp
  803954:	68 13 46 80 00       	push   $0x804613
  803959:	68 45 02 00 00       	push   $0x245
  80395e:	68 31 46 80 00       	push   $0x804631
  803963:	e8 36 01 00 00       	call   803a9e <_panic>
  803968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396b:	8b 00                	mov    (%eax),%eax
  80396d:	85 c0                	test   %eax,%eax
  80396f:	74 10                	je     803981 <realloc_block_FF+0x6ab>
  803971:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803974:	8b 00                	mov    (%eax),%eax
  803976:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803979:	8b 52 04             	mov    0x4(%edx),%edx
  80397c:	89 50 04             	mov    %edx,0x4(%eax)
  80397f:	eb 0b                	jmp    80398c <realloc_block_FF+0x6b6>
  803981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803984:	8b 40 04             	mov    0x4(%eax),%eax
  803987:	a3 30 50 80 00       	mov    %eax,0x805030
  80398c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	85 c0                	test   %eax,%eax
  803994:	74 0f                	je     8039a5 <realloc_block_FF+0x6cf>
  803996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803999:	8b 40 04             	mov    0x4(%eax),%eax
  80399c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399f:	8b 12                	mov    (%edx),%edx
  8039a1:	89 10                	mov    %edx,(%eax)
  8039a3:	eb 0a                	jmp    8039af <realloc_block_FF+0x6d9>
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c7:	48                   	dec    %eax
  8039c8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039cd:	83 ec 04             	sub    $0x4,%esp
  8039d0:	6a 00                	push   $0x0
  8039d2:	ff 75 bc             	pushl  -0x44(%ebp)
  8039d5:	ff 75 b8             	pushl  -0x48(%ebp)
  8039d8:	e8 06 e9 ff ff       	call   8022e3 <set_block_data>
  8039dd:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e3:	eb 0a                	jmp    8039ef <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039e5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039ef:	c9                   	leave  
  8039f0:	c3                   	ret    

008039f1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039f1:	55                   	push   %ebp
  8039f2:	89 e5                	mov    %esp,%ebp
  8039f4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	68 28 47 80 00       	push   $0x804728
  8039ff:	68 58 02 00 00       	push   $0x258
  803a04:	68 31 46 80 00       	push   $0x804631
  803a09:	e8 90 00 00 00       	call   803a9e <_panic>

00803a0e <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	68 50 47 80 00       	push   $0x804750
  803a1c:	68 61 02 00 00       	push   $0x261
  803a21:	68 31 46 80 00       	push   $0x804631
  803a26:	e8 73 00 00 00       	call   803a9e <_panic>

00803a2b <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803a2b:	55                   	push   %ebp
  803a2c:	89 e5                	mov    %esp,%ebp
  803a2e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803a31:	83 ec 04             	sub    $0x4,%esp
  803a34:	68 78 47 80 00       	push   $0x804778
  803a39:	6a 09                	push   $0x9
  803a3b:	68 a0 47 80 00       	push   $0x8047a0
  803a40:	e8 59 00 00 00       	call   803a9e <_panic>

00803a45 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803a45:	55                   	push   %ebp
  803a46:	89 e5                	mov    %esp,%ebp
  803a48:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803a4b:	83 ec 04             	sub    $0x4,%esp
  803a4e:	68 b0 47 80 00       	push   $0x8047b0
  803a53:	6a 10                	push   $0x10
  803a55:	68 a0 47 80 00       	push   $0x8047a0
  803a5a:	e8 3f 00 00 00       	call   803a9e <_panic>

00803a5f <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a5f:	55                   	push   %ebp
  803a60:	89 e5                	mov    %esp,%ebp
  803a62:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a65:	83 ec 04             	sub    $0x4,%esp
  803a68:	68 d8 47 80 00       	push   $0x8047d8
  803a6d:	6a 18                	push   $0x18
  803a6f:	68 a0 47 80 00       	push   $0x8047a0
  803a74:	e8 25 00 00 00       	call   803a9e <_panic>

00803a79 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a79:	55                   	push   %ebp
  803a7a:	89 e5                	mov    %esp,%ebp
  803a7c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803a7f:	83 ec 04             	sub    $0x4,%esp
  803a82:	68 00 48 80 00       	push   $0x804800
  803a87:	6a 20                	push   $0x20
  803a89:	68 a0 47 80 00       	push   $0x8047a0
  803a8e:	e8 0b 00 00 00       	call   803a9e <_panic>

00803a93 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803a93:	55                   	push   %ebp
  803a94:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	8b 40 10             	mov    0x10(%eax),%eax
}
  803a9c:	5d                   	pop    %ebp
  803a9d:	c3                   	ret    

00803a9e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803aa4:	8d 45 10             	lea    0x10(%ebp),%eax
  803aa7:	83 c0 04             	add    $0x4,%eax
  803aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803aad:	a1 60 50 98 00       	mov    0x985060,%eax
  803ab2:	85 c0                	test   %eax,%eax
  803ab4:	74 16                	je     803acc <_panic+0x2e>
		cprintf("%s: ", argv0);
  803ab6:	a1 60 50 98 00       	mov    0x985060,%eax
  803abb:	83 ec 08             	sub    $0x8,%esp
  803abe:	50                   	push   %eax
  803abf:	68 28 48 80 00       	push   $0x804828
  803ac4:	e8 e4 cb ff ff       	call   8006ad <cprintf>
  803ac9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803acc:	a1 00 50 80 00       	mov    0x805000,%eax
  803ad1:	ff 75 0c             	pushl  0xc(%ebp)
  803ad4:	ff 75 08             	pushl  0x8(%ebp)
  803ad7:	50                   	push   %eax
  803ad8:	68 2d 48 80 00       	push   $0x80482d
  803add:	e8 cb cb ff ff       	call   8006ad <cprintf>
  803ae2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  803ae8:	83 ec 08             	sub    $0x8,%esp
  803aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  803aee:	50                   	push   %eax
  803aef:	e8 4e cb ff ff       	call   800642 <vcprintf>
  803af4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803af7:	83 ec 08             	sub    $0x8,%esp
  803afa:	6a 00                	push   $0x0
  803afc:	68 49 48 80 00       	push   $0x804849
  803b01:	e8 3c cb ff ff       	call   800642 <vcprintf>
  803b06:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803b09:	e8 bd ca ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803b0e:	eb fe                	jmp    803b0e <_panic+0x70>

00803b10 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803b10:	55                   	push   %ebp
  803b11:	89 e5                	mov    %esp,%ebp
  803b13:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b16:	a1 20 50 80 00       	mov    0x805020,%eax
  803b1b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b24:	39 c2                	cmp    %eax,%edx
  803b26:	74 14                	je     803b3c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b28:	83 ec 04             	sub    $0x4,%esp
  803b2b:	68 4c 48 80 00       	push   $0x80484c
  803b30:	6a 26                	push   $0x26
  803b32:	68 98 48 80 00       	push   $0x804898
  803b37:	e8 62 ff ff ff       	call   803a9e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b4a:	e9 c5 00 00 00       	jmp    803c14 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b59:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5c:	01 d0                	add    %edx,%eax
  803b5e:	8b 00                	mov    (%eax),%eax
  803b60:	85 c0                	test   %eax,%eax
  803b62:	75 08                	jne    803b6c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b64:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b67:	e9 a5 00 00 00       	jmp    803c11 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b73:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b7a:	eb 69                	jmp    803be5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b7c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b81:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b8a:	89 d0                	mov    %edx,%eax
  803b8c:	01 c0                	add    %eax,%eax
  803b8e:	01 d0                	add    %edx,%eax
  803b90:	c1 e0 03             	shl    $0x3,%eax
  803b93:	01 c8                	add    %ecx,%eax
  803b95:	8a 40 04             	mov    0x4(%eax),%al
  803b98:	84 c0                	test   %al,%al
  803b9a:	75 46                	jne    803be2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b9c:	a1 20 50 80 00       	mov    0x805020,%eax
  803ba1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ba7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803baa:	89 d0                	mov    %edx,%eax
  803bac:	01 c0                	add    %eax,%eax
  803bae:	01 d0                	add    %edx,%eax
  803bb0:	c1 e0 03             	shl    $0x3,%eax
  803bb3:	01 c8                	add    %ecx,%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803bba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803bc2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803bce:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd1:	01 c8                	add    %ecx,%eax
  803bd3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bd5:	39 c2                	cmp    %eax,%edx
  803bd7:	75 09                	jne    803be2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bd9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803be0:	eb 15                	jmp    803bf7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803be2:	ff 45 e8             	incl   -0x18(%ebp)
  803be5:	a1 20 50 80 00       	mov    0x805020,%eax
  803bea:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf3:	39 c2                	cmp    %eax,%edx
  803bf5:	77 85                	ja     803b7c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803bf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bfb:	75 14                	jne    803c11 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803bfd:	83 ec 04             	sub    $0x4,%esp
  803c00:	68 a4 48 80 00       	push   $0x8048a4
  803c05:	6a 3a                	push   $0x3a
  803c07:	68 98 48 80 00       	push   $0x804898
  803c0c:	e8 8d fe ff ff       	call   803a9e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803c11:	ff 45 f0             	incl   -0x10(%ebp)
  803c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c17:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c1a:	0f 8c 2f ff ff ff    	jl     803b4f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c2e:	eb 26                	jmp    803c56 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c30:	a1 20 50 80 00       	mov    0x805020,%eax
  803c35:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c3e:	89 d0                	mov    %edx,%eax
  803c40:	01 c0                	add    %eax,%eax
  803c42:	01 d0                	add    %edx,%eax
  803c44:	c1 e0 03             	shl    $0x3,%eax
  803c47:	01 c8                	add    %ecx,%eax
  803c49:	8a 40 04             	mov    0x4(%eax),%al
  803c4c:	3c 01                	cmp    $0x1,%al
  803c4e:	75 03                	jne    803c53 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c50:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c53:	ff 45 e0             	incl   -0x20(%ebp)
  803c56:	a1 20 50 80 00       	mov    0x805020,%eax
  803c5b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c64:	39 c2                	cmp    %eax,%edx
  803c66:	77 c8                	ja     803c30 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c6e:	74 14                	je     803c84 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c70:	83 ec 04             	sub    $0x4,%esp
  803c73:	68 f8 48 80 00       	push   $0x8048f8
  803c78:	6a 44                	push   $0x44
  803c7a:	68 98 48 80 00       	push   $0x804898
  803c7f:	e8 1a fe ff ff       	call   803a9e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c84:	90                   	nop
  803c85:	c9                   	leave  
  803c86:	c3                   	ret    
  803c87:	90                   	nop

00803c88 <__udivdi3>:
  803c88:	55                   	push   %ebp
  803c89:	57                   	push   %edi
  803c8a:	56                   	push   %esi
  803c8b:	53                   	push   %ebx
  803c8c:	83 ec 1c             	sub    $0x1c,%esp
  803c8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c9f:	89 ca                	mov    %ecx,%edx
  803ca1:	89 f8                	mov    %edi,%eax
  803ca3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ca7:	85 f6                	test   %esi,%esi
  803ca9:	75 2d                	jne    803cd8 <__udivdi3+0x50>
  803cab:	39 cf                	cmp    %ecx,%edi
  803cad:	77 65                	ja     803d14 <__udivdi3+0x8c>
  803caf:	89 fd                	mov    %edi,%ebp
  803cb1:	85 ff                	test   %edi,%edi
  803cb3:	75 0b                	jne    803cc0 <__udivdi3+0x38>
  803cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cba:	31 d2                	xor    %edx,%edx
  803cbc:	f7 f7                	div    %edi
  803cbe:	89 c5                	mov    %eax,%ebp
  803cc0:	31 d2                	xor    %edx,%edx
  803cc2:	89 c8                	mov    %ecx,%eax
  803cc4:	f7 f5                	div    %ebp
  803cc6:	89 c1                	mov    %eax,%ecx
  803cc8:	89 d8                	mov    %ebx,%eax
  803cca:	f7 f5                	div    %ebp
  803ccc:	89 cf                	mov    %ecx,%edi
  803cce:	89 fa                	mov    %edi,%edx
  803cd0:	83 c4 1c             	add    $0x1c,%esp
  803cd3:	5b                   	pop    %ebx
  803cd4:	5e                   	pop    %esi
  803cd5:	5f                   	pop    %edi
  803cd6:	5d                   	pop    %ebp
  803cd7:	c3                   	ret    
  803cd8:	39 ce                	cmp    %ecx,%esi
  803cda:	77 28                	ja     803d04 <__udivdi3+0x7c>
  803cdc:	0f bd fe             	bsr    %esi,%edi
  803cdf:	83 f7 1f             	xor    $0x1f,%edi
  803ce2:	75 40                	jne    803d24 <__udivdi3+0x9c>
  803ce4:	39 ce                	cmp    %ecx,%esi
  803ce6:	72 0a                	jb     803cf2 <__udivdi3+0x6a>
  803ce8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cec:	0f 87 9e 00 00 00    	ja     803d90 <__udivdi3+0x108>
  803cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf7:	89 fa                	mov    %edi,%edx
  803cf9:	83 c4 1c             	add    $0x1c,%esp
  803cfc:	5b                   	pop    %ebx
  803cfd:	5e                   	pop    %esi
  803cfe:	5f                   	pop    %edi
  803cff:	5d                   	pop    %ebp
  803d00:	c3                   	ret    
  803d01:	8d 76 00             	lea    0x0(%esi),%esi
  803d04:	31 ff                	xor    %edi,%edi
  803d06:	31 c0                	xor    %eax,%eax
  803d08:	89 fa                	mov    %edi,%edx
  803d0a:	83 c4 1c             	add    $0x1c,%esp
  803d0d:	5b                   	pop    %ebx
  803d0e:	5e                   	pop    %esi
  803d0f:	5f                   	pop    %edi
  803d10:	5d                   	pop    %ebp
  803d11:	c3                   	ret    
  803d12:	66 90                	xchg   %ax,%ax
  803d14:	89 d8                	mov    %ebx,%eax
  803d16:	f7 f7                	div    %edi
  803d18:	31 ff                	xor    %edi,%edi
  803d1a:	89 fa                	mov    %edi,%edx
  803d1c:	83 c4 1c             	add    $0x1c,%esp
  803d1f:	5b                   	pop    %ebx
  803d20:	5e                   	pop    %esi
  803d21:	5f                   	pop    %edi
  803d22:	5d                   	pop    %ebp
  803d23:	c3                   	ret    
  803d24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d29:	89 eb                	mov    %ebp,%ebx
  803d2b:	29 fb                	sub    %edi,%ebx
  803d2d:	89 f9                	mov    %edi,%ecx
  803d2f:	d3 e6                	shl    %cl,%esi
  803d31:	89 c5                	mov    %eax,%ebp
  803d33:	88 d9                	mov    %bl,%cl
  803d35:	d3 ed                	shr    %cl,%ebp
  803d37:	89 e9                	mov    %ebp,%ecx
  803d39:	09 f1                	or     %esi,%ecx
  803d3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d3f:	89 f9                	mov    %edi,%ecx
  803d41:	d3 e0                	shl    %cl,%eax
  803d43:	89 c5                	mov    %eax,%ebp
  803d45:	89 d6                	mov    %edx,%esi
  803d47:	88 d9                	mov    %bl,%cl
  803d49:	d3 ee                	shr    %cl,%esi
  803d4b:	89 f9                	mov    %edi,%ecx
  803d4d:	d3 e2                	shl    %cl,%edx
  803d4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d53:	88 d9                	mov    %bl,%cl
  803d55:	d3 e8                	shr    %cl,%eax
  803d57:	09 c2                	or     %eax,%edx
  803d59:	89 d0                	mov    %edx,%eax
  803d5b:	89 f2                	mov    %esi,%edx
  803d5d:	f7 74 24 0c          	divl   0xc(%esp)
  803d61:	89 d6                	mov    %edx,%esi
  803d63:	89 c3                	mov    %eax,%ebx
  803d65:	f7 e5                	mul    %ebp
  803d67:	39 d6                	cmp    %edx,%esi
  803d69:	72 19                	jb     803d84 <__udivdi3+0xfc>
  803d6b:	74 0b                	je     803d78 <__udivdi3+0xf0>
  803d6d:	89 d8                	mov    %ebx,%eax
  803d6f:	31 ff                	xor    %edi,%edi
  803d71:	e9 58 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d7c:	89 f9                	mov    %edi,%ecx
  803d7e:	d3 e2                	shl    %cl,%edx
  803d80:	39 c2                	cmp    %eax,%edx
  803d82:	73 e9                	jae    803d6d <__udivdi3+0xe5>
  803d84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d87:	31 ff                	xor    %edi,%edi
  803d89:	e9 40 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	31 c0                	xor    %eax,%eax
  803d92:	e9 37 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d97:	90                   	nop

00803d98 <__umoddi3>:
  803d98:	55                   	push   %ebp
  803d99:	57                   	push   %edi
  803d9a:	56                   	push   %esi
  803d9b:	53                   	push   %ebx
  803d9c:	83 ec 1c             	sub    $0x1c,%esp
  803d9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803da3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803db3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803db7:	89 f3                	mov    %esi,%ebx
  803db9:	89 fa                	mov    %edi,%edx
  803dbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dbf:	89 34 24             	mov    %esi,(%esp)
  803dc2:	85 c0                	test   %eax,%eax
  803dc4:	75 1a                	jne    803de0 <__umoddi3+0x48>
  803dc6:	39 f7                	cmp    %esi,%edi
  803dc8:	0f 86 a2 00 00 00    	jbe    803e70 <__umoddi3+0xd8>
  803dce:	89 c8                	mov    %ecx,%eax
  803dd0:	89 f2                	mov    %esi,%edx
  803dd2:	f7 f7                	div    %edi
  803dd4:	89 d0                	mov    %edx,%eax
  803dd6:	31 d2                	xor    %edx,%edx
  803dd8:	83 c4 1c             	add    $0x1c,%esp
  803ddb:	5b                   	pop    %ebx
  803ddc:	5e                   	pop    %esi
  803ddd:	5f                   	pop    %edi
  803dde:	5d                   	pop    %ebp
  803ddf:	c3                   	ret    
  803de0:	39 f0                	cmp    %esi,%eax
  803de2:	0f 87 ac 00 00 00    	ja     803e94 <__umoddi3+0xfc>
  803de8:	0f bd e8             	bsr    %eax,%ebp
  803deb:	83 f5 1f             	xor    $0x1f,%ebp
  803dee:	0f 84 ac 00 00 00    	je     803ea0 <__umoddi3+0x108>
  803df4:	bf 20 00 00 00       	mov    $0x20,%edi
  803df9:	29 ef                	sub    %ebp,%edi
  803dfb:	89 fe                	mov    %edi,%esi
  803dfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e01:	89 e9                	mov    %ebp,%ecx
  803e03:	d3 e0                	shl    %cl,%eax
  803e05:	89 d7                	mov    %edx,%edi
  803e07:	89 f1                	mov    %esi,%ecx
  803e09:	d3 ef                	shr    %cl,%edi
  803e0b:	09 c7                	or     %eax,%edi
  803e0d:	89 e9                	mov    %ebp,%ecx
  803e0f:	d3 e2                	shl    %cl,%edx
  803e11:	89 14 24             	mov    %edx,(%esp)
  803e14:	89 d8                	mov    %ebx,%eax
  803e16:	d3 e0                	shl    %cl,%eax
  803e18:	89 c2                	mov    %eax,%edx
  803e1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e1e:	d3 e0                	shl    %cl,%eax
  803e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e28:	89 f1                	mov    %esi,%ecx
  803e2a:	d3 e8                	shr    %cl,%eax
  803e2c:	09 d0                	or     %edx,%eax
  803e2e:	d3 eb                	shr    %cl,%ebx
  803e30:	89 da                	mov    %ebx,%edx
  803e32:	f7 f7                	div    %edi
  803e34:	89 d3                	mov    %edx,%ebx
  803e36:	f7 24 24             	mull   (%esp)
  803e39:	89 c6                	mov    %eax,%esi
  803e3b:	89 d1                	mov    %edx,%ecx
  803e3d:	39 d3                	cmp    %edx,%ebx
  803e3f:	0f 82 87 00 00 00    	jb     803ecc <__umoddi3+0x134>
  803e45:	0f 84 91 00 00 00    	je     803edc <__umoddi3+0x144>
  803e4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e4f:	29 f2                	sub    %esi,%edx
  803e51:	19 cb                	sbb    %ecx,%ebx
  803e53:	89 d8                	mov    %ebx,%eax
  803e55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e59:	d3 e0                	shl    %cl,%eax
  803e5b:	89 e9                	mov    %ebp,%ecx
  803e5d:	d3 ea                	shr    %cl,%edx
  803e5f:	09 d0                	or     %edx,%eax
  803e61:	89 e9                	mov    %ebp,%ecx
  803e63:	d3 eb                	shr    %cl,%ebx
  803e65:	89 da                	mov    %ebx,%edx
  803e67:	83 c4 1c             	add    $0x1c,%esp
  803e6a:	5b                   	pop    %ebx
  803e6b:	5e                   	pop    %esi
  803e6c:	5f                   	pop    %edi
  803e6d:	5d                   	pop    %ebp
  803e6e:	c3                   	ret    
  803e6f:	90                   	nop
  803e70:	89 fd                	mov    %edi,%ebp
  803e72:	85 ff                	test   %edi,%edi
  803e74:	75 0b                	jne    803e81 <__umoddi3+0xe9>
  803e76:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7b:	31 d2                	xor    %edx,%edx
  803e7d:	f7 f7                	div    %edi
  803e7f:	89 c5                	mov    %eax,%ebp
  803e81:	89 f0                	mov    %esi,%eax
  803e83:	31 d2                	xor    %edx,%edx
  803e85:	f7 f5                	div    %ebp
  803e87:	89 c8                	mov    %ecx,%eax
  803e89:	f7 f5                	div    %ebp
  803e8b:	89 d0                	mov    %edx,%eax
  803e8d:	e9 44 ff ff ff       	jmp    803dd6 <__umoddi3+0x3e>
  803e92:	66 90                	xchg   %ax,%ax
  803e94:	89 c8                	mov    %ecx,%eax
  803e96:	89 f2                	mov    %esi,%edx
  803e98:	83 c4 1c             	add    $0x1c,%esp
  803e9b:	5b                   	pop    %ebx
  803e9c:	5e                   	pop    %esi
  803e9d:	5f                   	pop    %edi
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    
  803ea0:	3b 04 24             	cmp    (%esp),%eax
  803ea3:	72 06                	jb     803eab <__umoddi3+0x113>
  803ea5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ea9:	77 0f                	ja     803eba <__umoddi3+0x122>
  803eab:	89 f2                	mov    %esi,%edx
  803ead:	29 f9                	sub    %edi,%ecx
  803eaf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803eb3:	89 14 24             	mov    %edx,(%esp)
  803eb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ebe:	8b 14 24             	mov    (%esp),%edx
  803ec1:	83 c4 1c             	add    $0x1c,%esp
  803ec4:	5b                   	pop    %ebx
  803ec5:	5e                   	pop    %esi
  803ec6:	5f                   	pop    %edi
  803ec7:	5d                   	pop    %ebp
  803ec8:	c3                   	ret    
  803ec9:	8d 76 00             	lea    0x0(%esi),%esi
  803ecc:	2b 04 24             	sub    (%esp),%eax
  803ecf:	19 fa                	sbb    %edi,%edx
  803ed1:	89 d1                	mov    %edx,%ecx
  803ed3:	89 c6                	mov    %eax,%esi
  803ed5:	e9 71 ff ff ff       	jmp    803e4b <__umoddi3+0xb3>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ee0:	72 ea                	jb     803ecc <__umoddi3+0x134>
  803ee2:	89 d9                	mov    %ebx,%ecx
  803ee4:	e9 62 ff ff ff       	jmp    803e4b <__umoddi3+0xb3>

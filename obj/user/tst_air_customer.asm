
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
  80004f:	bb 09 41 80 00       	mov    $0x804109,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 13 41 80 00       	mov    $0x804113,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 1f 41 80 00       	mov    $0x80411f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 2e 41 80 00       	mov    $0x80412e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 3d 41 80 00       	mov    $0x80413d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 52 41 80 00       	mov    $0x804152,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 67 41 80 00       	mov    $0x804167,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 78 41 80 00       	mov    $0x804178,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 89 41 80 00       	mov    $0x804189,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 9a 41 80 00       	mov    $0x80419a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb a3 41 80 00       	mov    $0x8041a3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb ad 41 80 00       	mov    $0x8041ad,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb b8 41 80 00       	mov    $0x8041b8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb c4 41 80 00       	mov    $0x8041c4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ce 41 80 00       	mov    $0x8041ce,%ebx
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
  8001be:	bb d8 41 80 00       	mov    $0x8041d8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb e6 41 80 00       	mov    $0x8041e6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb f5 41 80 00       	mov    $0x8041f5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb fc 41 80 00       	mov    $0x8041fc,%ebx
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
  800286:	e8 8e 38 00 00       	call   803b19 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 72 38 00 00       	call   803b19 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 56 38 00 00       	call   803b19 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 3a 38 00 00       	call   803b19 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 1e 38 00 00       	call   803b19 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 58 38 00 00       	call   803b64 <wait_semaphore>
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
  80032d:	e8 b4 38 00 00       	call   803be6 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 21 38 00 00       	call   803b64 <wait_semaphore>
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
  800363:	e8 fc 37 00 00       	call   803b64 <wait_semaphore>
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
  800397:	e8 4a 38 00 00       	call   803be6 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 39 38 00 00       	call   803be6 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 03 42 80 00       	mov    $0x804203,%ebx
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
  800425:	e8 ef 36 00 00       	call   803b19 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 29 37 00 00       	call   803b64 <wait_semaphore>
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
  80045e:	68 c0 40 80 00       	push   $0x8040c0
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 e8 40 80 00       	push   $0x8040e8
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 58 37 00 00       	call   803be6 <signal_semaphore>
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
  800516:	68 3c 42 80 00       	push   $0x80423c
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
  80053e:	68 64 42 80 00       	push   $0x804264
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
  80056f:	68 8c 42 80 00       	push   $0x80428c
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 e4 42 80 00       	push   $0x8042e4
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 3c 42 80 00       	push   $0x80423c
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
  80074a:	e8 fd 36 00 00       	call   803e4c <__udivdi3>
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
  80079a:	e8 bd 37 00 00       	call   803f5c <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 14 45 80 00       	add    $0x804514,%eax
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
  8008f5:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
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
  8009d6:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 25 45 80 00       	push   $0x804525
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
  8009fb:	68 2e 45 80 00       	push   $0x80452e
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
  800a28:	be 31 45 80 00       	mov    $0x804531,%esi
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
  801433:	68 a8 46 80 00       	push   $0x8046a8
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 ca 46 80 00       	push   $0x8046ca
  801442:	e8 1c 28 00 00       	call   803c63 <_panic>

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
  8014dd:	e8 dd 0e 00 00       	call   8023bf <alloc_block_FF>
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
  801500:	e8 76 13 00 00       	call   80287b <alloc_block_BF>
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
  8016ae:	e8 8c 09 00 00       	call   80203f <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 9c 1b 00 00       	call   803260 <free_block>
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
  801764:	68 d8 46 80 00       	push   $0x8046d8
  801769:	68 87 00 00 00       	push   $0x87
  80176e:	68 02 47 80 00       	push   $0x804702
  801773:	e8 eb 24 00 00       	call   803c63 <_panic>
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
  80190f:	68 10 47 80 00       	push   $0x804710
  801914:	68 e4 00 00 00       	push   $0xe4
  801919:	68 02 47 80 00       	push   $0x804702
  80191e:	e8 40 23 00 00       	call   803c63 <_panic>

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
  80192c:	68 36 47 80 00       	push   $0x804736
  801931:	68 f0 00 00 00       	push   $0xf0
  801936:	68 02 47 80 00       	push   $0x804702
  80193b:	e8 23 23 00 00       	call   803c63 <_panic>

00801940 <shrink>:

}
void shrink(uint32 newSize)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	68 36 47 80 00       	push   $0x804736
  80194e:	68 f5 00 00 00       	push   $0xf5
  801953:	68 02 47 80 00       	push   $0x804702
  801958:	e8 06 23 00 00       	call   803c63 <_panic>

0080195d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	68 36 47 80 00       	push   $0x804736
  80196b:	68 fa 00 00 00       	push   $0xfa
  801970:	68 02 47 80 00       	push   $0x804702
  801975:	e8 e9 22 00 00       	call   803c63 <_panic>

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

00801fa3 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 2e                	push   $0x2e
  801fb5:	e8 c0 f9 ff ff       	call   80197a <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
  801fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	50                   	push   %eax
  801fd4:	6a 2f                	push   $0x2f
  801fd6:	e8 9f f9 ff ff       	call   80197a <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
	return;
  801fde:	90                   	nop
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801fe4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	6a 30                	push   $0x30
  801ff4:	e8 81 f9 ff ff       	call   80197a <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	50                   	push   %eax
  802011:	6a 31                	push   $0x31
  802013:	e8 62 f9 ff ff       	call   80197a <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
  80201b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80201e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	50                   	push   %eax
  802032:	6a 32                	push   $0x32
  802034:	e8 41 f9 ff ff       	call   80197a <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	83 e8 04             	sub    $0x4,%eax
  80204b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80204e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	83 e8 04             	sub    $0x4,%eax
  802064:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	83 e0 01             	and    $0x1,%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	0f 94 c0             	sete   %al
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80207c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802083:	8b 45 0c             	mov    0xc(%ebp),%eax
  802086:	83 f8 02             	cmp    $0x2,%eax
  802089:	74 2b                	je     8020b6 <alloc_block+0x40>
  80208b:	83 f8 02             	cmp    $0x2,%eax
  80208e:	7f 07                	jg     802097 <alloc_block+0x21>
  802090:	83 f8 01             	cmp    $0x1,%eax
  802093:	74 0e                	je     8020a3 <alloc_block+0x2d>
  802095:	eb 58                	jmp    8020ef <alloc_block+0x79>
  802097:	83 f8 03             	cmp    $0x3,%eax
  80209a:	74 2d                	je     8020c9 <alloc_block+0x53>
  80209c:	83 f8 04             	cmp    $0x4,%eax
  80209f:	74 3b                	je     8020dc <alloc_block+0x66>
  8020a1:	eb 4c                	jmp    8020ef <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	e8 11 03 00 00       	call   8023bf <alloc_block_FF>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020b4:	eb 4a                	jmp    802100 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	ff 75 08             	pushl  0x8(%ebp)
  8020bc:	e8 c7 19 00 00       	call   803a88 <alloc_block_NF>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c7:	eb 37                	jmp    802100 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020c9:	83 ec 0c             	sub    $0xc,%esp
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	e8 a7 07 00 00       	call   80287b <alloc_block_BF>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020da:	eb 24                	jmp    802100 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 84 19 00 00       	call   803a6b <alloc_block_WF>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ed:	eb 11                	jmp    802100 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	68 48 47 80 00       	push   $0x804748
  8020f7:	e8 b1 e5 ff ff       	call   8006ad <cprintf>
  8020fc:	83 c4 10             	add    $0x10,%esp
		break;
  8020ff:	90                   	nop
	}
	return va;
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
  802109:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	68 68 47 80 00       	push   $0x804768
  802114:	e8 94 e5 ff ff       	call   8006ad <cprintf>
  802119:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	68 93 47 80 00       	push   $0x804793
  802124:	e8 84 e5 ff ff       	call   8006ad <cprintf>
  802129:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802132:	eb 37                	jmp    80216b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	ff 75 f4             	pushl  -0xc(%ebp)
  80213a:	e8 19 ff ff ff       	call   802058 <is_free_block>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	0f be d8             	movsbl %al,%ebx
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	ff 75 f4             	pushl  -0xc(%ebp)
  80214b:	e8 ef fe ff ff       	call   80203f <get_block_size>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	53                   	push   %ebx
  802157:	50                   	push   %eax
  802158:	68 ab 47 80 00       	push   $0x8047ab
  80215d:	e8 4b e5 ff ff       	call   8006ad <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802165:	8b 45 10             	mov    0x10(%ebp),%eax
  802168:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216f:	74 07                	je     802178 <print_blocks_list+0x73>
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	eb 05                	jmp    80217d <print_blocks_list+0x78>
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
  80217d:	89 45 10             	mov    %eax,0x10(%ebp)
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	85 c0                	test   %eax,%eax
  802185:	75 ad                	jne    802134 <print_blocks_list+0x2f>
  802187:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218b:	75 a7                	jne    802134 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	68 68 47 80 00       	push   $0x804768
  802195:	e8 13 e5 ff ff       	call   8006ad <cprintf>
  80219a:	83 c4 10             	add    $0x10,%esp

}
  80219d:	90                   	nop
  80219e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	83 e0 01             	and    $0x1,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	74 03                	je     8021b6 <initialize_dynamic_allocator+0x13>
  8021b3:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021ba:	0f 84 c7 01 00 00    	je     802387 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021c0:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021c7:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	01 d0                	add    %edx,%eax
  8021d2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021d7:	0f 87 ad 01 00 00    	ja     80238a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	0f 89 a5 01 00 00    	jns    80238d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	01 d0                	add    %edx,%eax
  8021f0:	83 e8 04             	sub    $0x4,%eax
  8021f3:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802207:	e9 87 00 00 00       	jmp    802293 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80220c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802210:	75 14                	jne    802226 <initialize_dynamic_allocator+0x83>
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	68 c3 47 80 00       	push   $0x8047c3
  80221a:	6a 79                	push   $0x79
  80221c:	68 e1 47 80 00       	push   $0x8047e1
  802221:	e8 3d 1a 00 00       	call   803c63 <_panic>
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 10                	je     80223f <initialize_dynamic_allocator+0x9c>
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802237:	8b 52 04             	mov    0x4(%edx),%edx
  80223a:	89 50 04             	mov    %edx,0x4(%eax)
  80223d:	eb 0b                	jmp    80224a <initialize_dynamic_allocator+0xa7>
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 40 04             	mov    0x4(%eax),%eax
  802245:	a3 30 50 80 00       	mov    %eax,0x805030
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 04             	mov    0x4(%eax),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	74 0f                	je     802263 <initialize_dynamic_allocator+0xc0>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 40 04             	mov    0x4(%eax),%eax
  80225a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225d:	8b 12                	mov    (%edx),%edx
  80225f:	89 10                	mov    %edx,(%eax)
  802261:	eb 0a                	jmp    80226d <initialize_dynamic_allocator+0xca>
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802280:	a1 38 50 80 00       	mov    0x805038,%eax
  802285:	48                   	dec    %eax
  802286:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80228b:	a1 34 50 80 00       	mov    0x805034,%eax
  802290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802297:	74 07                	je     8022a0 <initialize_dynamic_allocator+0xfd>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	eb 05                	jmp    8022a5 <initialize_dynamic_allocator+0x102>
  8022a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8022aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	0f 85 55 ff ff ff    	jne    80220c <initialize_dynamic_allocator+0x69>
  8022b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bb:	0f 85 4b ff ff ff    	jne    80220c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8022d5:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022da:	a1 40 50 80 00       	mov    0x805040,%eax
  8022df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	83 c0 08             	add    $0x8,%eax
  8022eb:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	83 c0 04             	add    $0x4,%eax
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	83 ea 08             	sub    $0x8,%edx
  8022fa:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	01 d0                	add    %edx,%eax
  802304:	83 e8 08             	sub    $0x8,%eax
  802307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230a:	83 ea 08             	sub    $0x8,%edx
  80230d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80230f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802322:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802326:	75 17                	jne    80233f <initialize_dynamic_allocator+0x19c>
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 fc 47 80 00       	push   $0x8047fc
  802330:	68 90 00 00 00       	push   $0x90
  802335:	68 e1 47 80 00       	push   $0x8047e1
  80233a:	e8 24 19 00 00       	call   803c63 <_panic>
  80233f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802348:	89 10                	mov    %edx,(%eax)
  80234a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234d:	8b 00                	mov    (%eax),%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	74 0d                	je     802360 <initialize_dynamic_allocator+0x1bd>
  802353:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802358:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80235b:	89 50 04             	mov    %edx,0x4(%eax)
  80235e:	eb 08                	jmp    802368 <initialize_dynamic_allocator+0x1c5>
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	a3 30 50 80 00       	mov    %eax,0x805030
  802368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802373:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237a:	a1 38 50 80 00       	mov    0x805038,%eax
  80237f:	40                   	inc    %eax
  802380:	a3 38 50 80 00       	mov    %eax,0x805038
  802385:	eb 07                	jmp    80238e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802387:	90                   	nop
  802388:	eb 04                	jmp    80238e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80238a:	90                   	nop
  80238b:	eb 01                	jmp    80238e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80238d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802393:	8b 45 10             	mov    0x10(%ebp),%eax
  802396:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80239f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a2:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	83 e8 04             	sub    $0x4,%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	83 e0 fe             	and    $0xfffffffe,%eax
  8023af:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	01 c2                	add    %eax,%edx
  8023b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ba:	89 02                	mov    %eax,(%edx)
}
  8023bc:	90                   	nop
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	83 e0 01             	and    $0x1,%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 03                	je     8023d2 <alloc_block_FF+0x13>
  8023cf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023d2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023d6:	77 07                	ja     8023df <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023d8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023df:	a1 24 50 80 00       	mov    0x805024,%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 73                	jne    80245b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	83 c0 10             	add    $0x10,%eax
  8023ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023f1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fe:	01 d0                	add    %edx,%eax
  802400:	48                   	dec    %eax
  802401:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802407:	ba 00 00 00 00       	mov    $0x0,%edx
  80240c:	f7 75 ec             	divl   -0x14(%ebp)
  80240f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802412:	29 d0                	sub    %edx,%eax
  802414:	c1 e8 0c             	shr    $0xc,%eax
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	50                   	push   %eax
  80241b:	e8 27 f0 ff ff       	call   801447 <sbrk>
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	6a 00                	push   $0x0
  80242b:	e8 17 f0 ff ff       	call   801447 <sbrk>
  802430:	83 c4 10             	add    $0x10,%esp
  802433:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802439:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80243c:	83 ec 08             	sub    $0x8,%esp
  80243f:	50                   	push   %eax
  802440:	ff 75 e4             	pushl  -0x1c(%ebp)
  802443:	e8 5b fd ff ff       	call   8021a3 <initialize_dynamic_allocator>
  802448:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80244b:	83 ec 0c             	sub    $0xc,%esp
  80244e:	68 1f 48 80 00       	push   $0x80481f
  802453:	e8 55 e2 ff ff       	call   8006ad <cprintf>
  802458:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80245b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245f:	75 0a                	jne    80246b <alloc_block_FF+0xac>
	        return NULL;
  802461:	b8 00 00 00 00       	mov    $0x0,%eax
  802466:	e9 0e 04 00 00       	jmp    802879 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80246b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802472:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247a:	e9 f3 02 00 00       	jmp    802772 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802485:	83 ec 0c             	sub    $0xc,%esp
  802488:	ff 75 bc             	pushl  -0x44(%ebp)
  80248b:	e8 af fb ff ff       	call   80203f <get_block_size>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	83 c0 08             	add    $0x8,%eax
  80249c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80249f:	0f 87 c5 02 00 00    	ja     80276a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	83 c0 18             	add    $0x18,%eax
  8024ab:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ae:	0f 87 19 02 00 00    	ja     8026cd <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ba:	83 e8 08             	sub    $0x8,%eax
  8024bd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	8d 50 08             	lea    0x8(%eax),%edx
  8024c6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024c9:	01 d0                	add    %edx,%eax
  8024cb:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	83 c0 08             	add    $0x8,%eax
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	6a 01                	push   $0x1
  8024d9:	50                   	push   %eax
  8024da:	ff 75 bc             	pushl  -0x44(%ebp)
  8024dd:	e8 ae fe ff ff       	call   802390 <set_block_data>
  8024e2:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 68                	jne    802557 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024ef:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_FF+0x14d>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 fc 47 80 00       	push   $0x8047fc
  8024fd:	68 d7 00 00 00       	push   $0xd7
  802502:	68 e1 47 80 00       	push   $0x8047e1
  802507:	e8 57 17 00 00       	call   803c63 <_panic>
  80250c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802512:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802515:	89 10                	mov    %edx,(%eax)
  802517:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251a:	8b 00                	mov    (%eax),%eax
  80251c:	85 c0                	test   %eax,%eax
  80251e:	74 0d                	je     80252d <alloc_block_FF+0x16e>
  802520:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802525:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802528:	89 50 04             	mov    %edx,0x4(%eax)
  80252b:	eb 08                	jmp    802535 <alloc_block_FF+0x176>
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	a3 30 50 80 00       	mov    %eax,0x805030
  802535:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802538:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80253d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802547:	a1 38 50 80 00       	mov    0x805038,%eax
  80254c:	40                   	inc    %eax
  80254d:	a3 38 50 80 00       	mov    %eax,0x805038
  802552:	e9 dc 00 00 00       	jmp    802633 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	75 65                	jne    8025c5 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802560:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802564:	75 17                	jne    80257d <alloc_block_FF+0x1be>
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	68 30 48 80 00       	push   $0x804830
  80256e:	68 db 00 00 00       	push   $0xdb
  802573:	68 e1 47 80 00       	push   $0x8047e1
  802578:	e8 e6 16 00 00       	call   803c63 <_panic>
  80257d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802583:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802586:	89 50 04             	mov    %edx,0x4(%eax)
  802589:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258c:	8b 40 04             	mov    0x4(%eax),%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 0c                	je     80259f <alloc_block_FF+0x1e0>
  802593:	a1 30 50 80 00       	mov    0x805030,%eax
  802598:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80259b:	89 10                	mov    %edx,(%eax)
  80259d:	eb 08                	jmp    8025a7 <alloc_block_FF+0x1e8>
  80259f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8025af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8025bd:	40                   	inc    %eax
  8025be:	a3 38 50 80 00       	mov    %eax,0x805038
  8025c3:	eb 6e                	jmp    802633 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	74 06                	je     8025d1 <alloc_block_FF+0x212>
  8025cb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025cf:	75 17                	jne    8025e8 <alloc_block_FF+0x229>
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	68 54 48 80 00       	push   $0x804854
  8025d9:	68 df 00 00 00       	push   $0xdf
  8025de:	68 e1 47 80 00       	push   $0x8047e1
  8025e3:	e8 7b 16 00 00       	call   803c63 <_panic>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 10                	mov    (%eax),%edx
  8025ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f0:	89 10                	mov    %edx,(%eax)
  8025f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 0b                	je     802606 <alloc_block_FF+0x247>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802603:	89 50 04             	mov    %edx,0x4(%eax)
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80260c:	89 10                	mov    %edx,(%eax)
  80260e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802614:	89 50 04             	mov    %edx,0x4(%eax)
  802617:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	75 08                	jne    802628 <alloc_block_FF+0x269>
  802620:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802623:	a3 30 50 80 00       	mov    %eax,0x805030
  802628:	a1 38 50 80 00       	mov    0x805038,%eax
  80262d:	40                   	inc    %eax
  80262e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802637:	75 17                	jne    802650 <alloc_block_FF+0x291>
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	68 c3 47 80 00       	push   $0x8047c3
  802641:	68 e1 00 00 00       	push   $0xe1
  802646:	68 e1 47 80 00       	push   $0x8047e1
  80264b:	e8 13 16 00 00       	call   803c63 <_panic>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 10                	je     802669 <alloc_block_FF+0x2aa>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802661:	8b 52 04             	mov    0x4(%edx),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	eb 0b                	jmp    802674 <alloc_block_FF+0x2b5>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	a3 30 50 80 00       	mov    %eax,0x805030
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0f                	je     80268d <alloc_block_FF+0x2ce>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802687:	8b 12                	mov    (%edx),%edx
  802689:	89 10                	mov    %edx,(%eax)
  80268b:	eb 0a                	jmp    802697 <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  8026b5:	83 ec 04             	sub    $0x4,%esp
  8026b8:	6a 00                	push   $0x0
  8026ba:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026bd:	ff 75 b0             	pushl  -0x50(%ebp)
  8026c0:	e8 cb fc ff ff       	call   802390 <set_block_data>
  8026c5:	83 c4 10             	add    $0x10,%esp
  8026c8:	e9 95 00 00 00       	jmp    802762 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026cd:	83 ec 04             	sub    $0x4,%esp
  8026d0:	6a 01                	push   $0x1
  8026d2:	ff 75 b8             	pushl  -0x48(%ebp)
  8026d5:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d8:	e8 b3 fc ff ff       	call   802390 <set_block_data>
  8026dd:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e4:	75 17                	jne    8026fd <alloc_block_FF+0x33e>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 c3 47 80 00       	push   $0x8047c3
  8026ee:	68 e8 00 00 00       	push   $0xe8
  8026f3:	68 e1 47 80 00       	push   $0x8047e1
  8026f8:	e8 66 15 00 00       	call   803c63 <_panic>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	85 c0                	test   %eax,%eax
  802704:	74 10                	je     802716 <alloc_block_FF+0x357>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270e:	8b 52 04             	mov    0x4(%edx),%edx
  802711:	89 50 04             	mov    %edx,0x4(%eax)
  802714:	eb 0b                	jmp    802721 <alloc_block_FF+0x362>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 04             	mov    0x4(%eax),%eax
  80271c:	a3 30 50 80 00       	mov    %eax,0x805030
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 0f                	je     80273a <alloc_block_FF+0x37b>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802734:	8b 12                	mov    (%edx),%edx
  802736:	89 10                	mov    %edx,(%eax)
  802738:	eb 0a                	jmp    802744 <alloc_block_FF+0x385>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802757:	a1 38 50 80 00       	mov    0x805038,%eax
  80275c:	48                   	dec    %eax
  80275d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802762:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802765:	e9 0f 01 00 00       	jmp    802879 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80276a:	a1 34 50 80 00       	mov    0x805034,%eax
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 07                	je     80277f <alloc_block_FF+0x3c0>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	eb 05                	jmp    802784 <alloc_block_FF+0x3c5>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	a3 34 50 80 00       	mov    %eax,0x805034
  802789:	a1 34 50 80 00       	mov    0x805034,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	0f 85 e9 fc ff ff    	jne    80247f <alloc_block_FF+0xc0>
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	0f 85 df fc ff ff    	jne    80247f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	83 c0 08             	add    $0x8,%eax
  8027a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027a9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027b6:	01 d0                	add    %edx,%eax
  8027b8:	48                   	dec    %eax
  8027b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c4:	f7 75 d8             	divl   -0x28(%ebp)
  8027c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ca:	29 d0                	sub    %edx,%eax
  8027cc:	c1 e8 0c             	shr    $0xc,%eax
  8027cf:	83 ec 0c             	sub    $0xc,%esp
  8027d2:	50                   	push   %eax
  8027d3:	e8 6f ec ff ff       	call   801447 <sbrk>
  8027d8:	83 c4 10             	add    $0x10,%esp
  8027db:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027de:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027e2:	75 0a                	jne    8027ee <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e9:	e9 8b 00 00 00       	jmp    802879 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027ee:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fb:	01 d0                	add    %edx,%eax
  8027fd:	48                   	dec    %eax
  8027fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802801:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802804:	ba 00 00 00 00       	mov    $0x0,%edx
  802809:	f7 75 cc             	divl   -0x34(%ebp)
  80280c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80280f:	29 d0                	sub    %edx,%eax
  802811:	8d 50 fc             	lea    -0x4(%eax),%edx
  802814:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80281e:	a1 40 50 80 00       	mov    0x805040,%eax
  802823:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802829:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802830:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802833:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802836:	01 d0                	add    %edx,%eax
  802838:	48                   	dec    %eax
  802839:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80283c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80283f:	ba 00 00 00 00       	mov    $0x0,%edx
  802844:	f7 75 c4             	divl   -0x3c(%ebp)
  802847:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80284a:	29 d0                	sub    %edx,%eax
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	6a 01                	push   $0x1
  802851:	50                   	push   %eax
  802852:	ff 75 d0             	pushl  -0x30(%ebp)
  802855:	e8 36 fb ff ff       	call   802390 <set_block_data>
  80285a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80285d:	83 ec 0c             	sub    $0xc,%esp
  802860:	ff 75 d0             	pushl  -0x30(%ebp)
  802863:	e8 f8 09 00 00       	call   803260 <free_block>
  802868:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	ff 75 08             	pushl  0x8(%ebp)
  802871:	e8 49 fb ff ff       	call   8023bf <alloc_block_FF>
  802876:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	83 e0 01             	and    $0x1,%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	74 03                	je     80288e <alloc_block_BF+0x13>
  80288b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80288e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802892:	77 07                	ja     80289b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802894:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80289b:	a1 24 50 80 00       	mov    0x805024,%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	75 73                	jne    802917 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	83 c0 10             	add    $0x10,%eax
  8028aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028ad:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ba:	01 d0                	add    %edx,%eax
  8028bc:	48                   	dec    %eax
  8028bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c8:	f7 75 e0             	divl   -0x20(%ebp)
  8028cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ce:	29 d0                	sub    %edx,%eax
  8028d0:	c1 e8 0c             	shr    $0xc,%eax
  8028d3:	83 ec 0c             	sub    $0xc,%esp
  8028d6:	50                   	push   %eax
  8028d7:	e8 6b eb ff ff       	call   801447 <sbrk>
  8028dc:	83 c4 10             	add    $0x10,%esp
  8028df:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	6a 00                	push   $0x0
  8028e7:	e8 5b eb ff ff       	call   801447 <sbrk>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028f5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028f8:	83 ec 08             	sub    $0x8,%esp
  8028fb:	50                   	push   %eax
  8028fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8028ff:	e8 9f f8 ff ff       	call   8021a3 <initialize_dynamic_allocator>
  802904:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	68 1f 48 80 00       	push   $0x80481f
  80290f:	e8 99 dd ff ff       	call   8006ad <cprintf>
  802914:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802917:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80291e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802925:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80292c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802933:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293b:	e9 1d 01 00 00       	jmp    802a5d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802946:	83 ec 0c             	sub    $0xc,%esp
  802949:	ff 75 a8             	pushl  -0x58(%ebp)
  80294c:	e8 ee f6 ff ff       	call   80203f <get_block_size>
  802951:	83 c4 10             	add    $0x10,%esp
  802954:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	83 c0 08             	add    $0x8,%eax
  80295d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802960:	0f 87 ef 00 00 00    	ja     802a55 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	83 c0 18             	add    $0x18,%eax
  80296c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80296f:	77 1d                	ja     80298e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802977:	0f 86 d8 00 00 00    	jbe    802a55 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80297d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802980:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802983:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802986:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802989:	e9 c7 00 00 00       	jmp    802a55 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	83 c0 08             	add    $0x8,%eax
  802994:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802997:	0f 85 9d 00 00 00    	jne    802a3a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	6a 01                	push   $0x1
  8029a2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029a5:	ff 75 a8             	pushl  -0x58(%ebp)
  8029a8:	e8 e3 f9 ff ff       	call   802390 <set_block_data>
  8029ad:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_BF+0x152>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 c3 47 80 00       	push   $0x8047c3
  8029be:	68 2c 01 00 00       	push   $0x12c
  8029c3:	68 e1 47 80 00       	push   $0x8047e1
  8029c8:	e8 96 12 00 00       	call   803c63 <_panic>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 10                	je     8029e6 <alloc_block_BF+0x16b>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029de:	8b 52 04             	mov    0x4(%edx),%edx
  8029e1:	89 50 04             	mov    %edx,0x4(%eax)
  8029e4:	eb 0b                	jmp    8029f1 <alloc_block_BF+0x176>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0f                	je     802a0a <alloc_block_BF+0x18f>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a04:	8b 12                	mov    (%edx),%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	eb 0a                	jmp    802a14 <alloc_block_BF+0x199>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a27:	a1 38 50 80 00       	mov    0x805038,%eax
  802a2c:	48                   	dec    %eax
  802a2d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a32:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a35:	e9 01 04 00 00       	jmp    802e3b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a40:	76 13                	jbe    802a55 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a42:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a49:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a52:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a55:	a1 34 50 80 00       	mov    0x805034,%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <alloc_block_BF+0x1ef>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <alloc_block_BF+0x1f4>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a74:	a1 34 50 80 00       	mov    0x805034,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	0f 85 bf fe ff ff    	jne    802940 <alloc_block_BF+0xc5>
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	0f 85 b5 fe ff ff    	jne    802940 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a8f:	0f 84 26 02 00 00    	je     802cbb <alloc_block_BF+0x440>
  802a95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a99:	0f 85 1c 02 00 00    	jne    802cbb <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa5:	83 e8 08             	sub    $0x8,%eax
  802aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8d 50 08             	lea    0x8(%eax),%edx
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	01 d0                	add    %edx,%eax
  802ab6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	83 c0 08             	add    $0x8,%eax
  802abf:	83 ec 04             	sub    $0x4,%esp
  802ac2:	6a 01                	push   $0x1
  802ac4:	50                   	push   %eax
  802ac5:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac8:	e8 c3 f8 ff ff       	call   802390 <set_block_data>
  802acd:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	75 68                	jne    802b42 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ada:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ade:	75 17                	jne    802af7 <alloc_block_BF+0x27c>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 fc 47 80 00       	push   $0x8047fc
  802ae8:	68 45 01 00 00       	push   $0x145
  802aed:	68 e1 47 80 00       	push   $0x8047e1
  802af2:	e8 6c 11 00 00       	call   803c63 <_panic>
  802af7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802afd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0d                	je     802b18 <alloc_block_BF+0x29d>
  802b0b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b10:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b13:	89 50 04             	mov    %edx,0x4(%eax)
  802b16:	eb 08                	jmp    802b20 <alloc_block_BF+0x2a5>
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b23:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b32:	a1 38 50 80 00       	mov    0x805038,%eax
  802b37:	40                   	inc    %eax
  802b38:	a3 38 50 80 00       	mov    %eax,0x805038
  802b3d:	e9 dc 00 00 00       	jmp    802c1e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	75 65                	jne    802bb0 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b4b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b4f:	75 17                	jne    802b68 <alloc_block_BF+0x2ed>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 30 48 80 00       	push   $0x804830
  802b59:	68 4a 01 00 00       	push   $0x14a
  802b5e:	68 e1 47 80 00       	push   $0x8047e1
  802b63:	e8 fb 10 00 00       	call   803c63 <_panic>
  802b68:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0c                	je     802b8a <alloc_block_BF+0x30f>
  802b7e:	a1 30 50 80 00       	mov    0x805030,%eax
  802b83:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	eb 08                	jmp    802b92 <alloc_block_BF+0x317>
  802b8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b95:	a3 30 50 80 00       	mov    %eax,0x805030
  802b9a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba8:	40                   	inc    %eax
  802ba9:	a3 38 50 80 00       	mov    %eax,0x805038
  802bae:	eb 6e                	jmp    802c1e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb4:	74 06                	je     802bbc <alloc_block_BF+0x341>
  802bb6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bba:	75 17                	jne    802bd3 <alloc_block_BF+0x358>
  802bbc:	83 ec 04             	sub    $0x4,%esp
  802bbf:	68 54 48 80 00       	push   $0x804854
  802bc4:	68 4f 01 00 00       	push   $0x14f
  802bc9:	68 e1 47 80 00       	push   $0x8047e1
  802bce:	e8 90 10 00 00       	call   803c63 <_panic>
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 10                	mov    (%eax),%edx
  802bd8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bdb:	89 10                	mov    %edx,(%eax)
  802bdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 0b                	je     802bf1 <alloc_block_BF+0x376>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bee:	89 50 04             	mov    %edx,0x4(%eax)
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bf7:	89 10                	mov    %edx,(%eax)
  802bf9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	75 08                	jne    802c13 <alloc_block_BF+0x398>
  802c0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c13:	a1 38 50 80 00       	mov    0x805038,%eax
  802c18:	40                   	inc    %eax
  802c19:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c22:	75 17                	jne    802c3b <alloc_block_BF+0x3c0>
  802c24:	83 ec 04             	sub    $0x4,%esp
  802c27:	68 c3 47 80 00       	push   $0x8047c3
  802c2c:	68 51 01 00 00       	push   $0x151
  802c31:	68 e1 47 80 00       	push   $0x8047e1
  802c36:	e8 28 10 00 00       	call   803c63 <_panic>
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 10                	je     802c54 <alloc_block_BF+0x3d9>
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4c:	8b 52 04             	mov    0x4(%edx),%edx
  802c4f:	89 50 04             	mov    %edx,0x4(%eax)
  802c52:	eb 0b                	jmp    802c5f <alloc_block_BF+0x3e4>
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0f                	je     802c78 <alloc_block_BF+0x3fd>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c72:	8b 12                	mov    (%edx),%edx
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	eb 0a                	jmp    802c82 <alloc_block_BF+0x407>
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c95:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9a:	48                   	dec    %eax
  802c9b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	6a 00                	push   $0x0
  802ca5:	ff 75 d0             	pushl  -0x30(%ebp)
  802ca8:	ff 75 cc             	pushl  -0x34(%ebp)
  802cab:	e8 e0 f6 ff ff       	call   802390 <set_block_data>
  802cb0:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb6:	e9 80 01 00 00       	jmp    802e3b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802cbb:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cbf:	0f 85 9d 00 00 00    	jne    802d62 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cc5:	83 ec 04             	sub    $0x4,%esp
  802cc8:	6a 01                	push   $0x1
  802cca:	ff 75 ec             	pushl  -0x14(%ebp)
  802ccd:	ff 75 f0             	pushl  -0x10(%ebp)
  802cd0:	e8 bb f6 ff ff       	call   802390 <set_block_data>
  802cd5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cdc:	75 17                	jne    802cf5 <alloc_block_BF+0x47a>
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	68 c3 47 80 00       	push   $0x8047c3
  802ce6:	68 58 01 00 00       	push   $0x158
  802ceb:	68 e1 47 80 00       	push   $0x8047e1
  802cf0:	e8 6e 0f 00 00       	call   803c63 <_panic>
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 10                	je     802d0e <alloc_block_BF+0x493>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d06:	8b 52 04             	mov    0x4(%edx),%edx
  802d09:	89 50 04             	mov    %edx,0x4(%eax)
  802d0c:	eb 0b                	jmp    802d19 <alloc_block_BF+0x49e>
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	a3 30 50 80 00       	mov    %eax,0x805030
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 0f                	je     802d32 <alloc_block_BF+0x4b7>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2c:	8b 12                	mov    (%edx),%edx
  802d2e:	89 10                	mov    %edx,(%eax)
  802d30:	eb 0a                	jmp    802d3c <alloc_block_BF+0x4c1>
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d54:	48                   	dec    %eax
  802d55:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	e9 d9 00 00 00       	jmp    802e3b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	83 c0 08             	add    $0x8,%eax
  802d68:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d6b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d75:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	48                   	dec    %eax
  802d7b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d7e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d81:	ba 00 00 00 00       	mov    $0x0,%edx
  802d86:	f7 75 c4             	divl   -0x3c(%ebp)
  802d89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d8c:	29 d0                	sub    %edx,%eax
  802d8e:	c1 e8 0c             	shr    $0xc,%eax
  802d91:	83 ec 0c             	sub    $0xc,%esp
  802d94:	50                   	push   %eax
  802d95:	e8 ad e6 ff ff       	call   801447 <sbrk>
  802d9a:	83 c4 10             	add    $0x10,%esp
  802d9d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802da0:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802da4:	75 0a                	jne    802db0 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	e9 8b 00 00 00       	jmp    802e3b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802db0:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802db7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802dbd:	01 d0                	add    %edx,%eax
  802dbf:	48                   	dec    %eax
  802dc0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dc3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dcb:	f7 75 b8             	divl   -0x48(%ebp)
  802dce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dd1:	29 d0                	sub    %edx,%eax
  802dd3:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dd6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802de0:	a1 40 50 80 00       	mov    0x805040,%eax
  802de5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802deb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802df2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802df5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	48                   	dec    %eax
  802dfb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802dfe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e01:	ba 00 00 00 00       	mov    $0x0,%edx
  802e06:	f7 75 b0             	divl   -0x50(%ebp)
  802e09:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e0c:	29 d0                	sub    %edx,%eax
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	6a 01                	push   $0x1
  802e13:	50                   	push   %eax
  802e14:	ff 75 bc             	pushl  -0x44(%ebp)
  802e17:	e8 74 f5 ff ff       	call   802390 <set_block_data>
  802e1c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 bc             	pushl  -0x44(%ebp)
  802e25:	e8 36 04 00 00       	call   803260 <free_block>
  802e2a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e2d:	83 ec 0c             	sub    $0xc,%esp
  802e30:	ff 75 08             	pushl  0x8(%ebp)
  802e33:	e8 43 fa ff ff       	call   80287b <alloc_block_BF>
  802e38:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e3b:	c9                   	leave  
  802e3c:	c3                   	ret    

00802e3d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e3d:	55                   	push   %ebp
  802e3e:	89 e5                	mov    %esp,%ebp
  802e40:	53                   	push   %ebx
  802e41:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e56:	74 1e                	je     802e76 <merging+0x39>
  802e58:	ff 75 08             	pushl  0x8(%ebp)
  802e5b:	e8 df f1 ff ff       	call   80203f <get_block_size>
  802e60:	83 c4 04             	add    $0x4,%esp
  802e63:	89 c2                	mov    %eax,%edx
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	01 d0                	add    %edx,%eax
  802e6a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e6d:	75 07                	jne    802e76 <merging+0x39>
		prev_is_free = 1;
  802e6f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e7a:	74 1e                	je     802e9a <merging+0x5d>
  802e7c:	ff 75 10             	pushl  0x10(%ebp)
  802e7f:	e8 bb f1 ff ff       	call   80203f <get_block_size>
  802e84:	83 c4 04             	add    $0x4,%esp
  802e87:	89 c2                	mov    %eax,%edx
  802e89:	8b 45 10             	mov    0x10(%ebp),%eax
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e91:	75 07                	jne    802e9a <merging+0x5d>
		next_is_free = 1;
  802e93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9e:	0f 84 cc 00 00 00    	je     802f70 <merging+0x133>
  802ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea8:	0f 84 c2 00 00 00    	je     802f70 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802eae:	ff 75 08             	pushl  0x8(%ebp)
  802eb1:	e8 89 f1 ff ff       	call   80203f <get_block_size>
  802eb6:	83 c4 04             	add    $0x4,%esp
  802eb9:	89 c3                	mov    %eax,%ebx
  802ebb:	ff 75 10             	pushl  0x10(%ebp)
  802ebe:	e8 7c f1 ff ff       	call   80203f <get_block_size>
  802ec3:	83 c4 04             	add    $0x4,%esp
  802ec6:	01 c3                	add    %eax,%ebx
  802ec8:	ff 75 0c             	pushl  0xc(%ebp)
  802ecb:	e8 6f f1 ff ff       	call   80203f <get_block_size>
  802ed0:	83 c4 04             	add    $0x4,%esp
  802ed3:	01 d8                	add    %ebx,%eax
  802ed5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ed8:	6a 00                	push   $0x0
  802eda:	ff 75 ec             	pushl  -0x14(%ebp)
  802edd:	ff 75 08             	pushl  0x8(%ebp)
  802ee0:	e8 ab f4 ff ff       	call   802390 <set_block_data>
  802ee5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ee8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eec:	75 17                	jne    802f05 <merging+0xc8>
  802eee:	83 ec 04             	sub    $0x4,%esp
  802ef1:	68 c3 47 80 00       	push   $0x8047c3
  802ef6:	68 7d 01 00 00       	push   $0x17d
  802efb:	68 e1 47 80 00       	push   $0x8047e1
  802f00:	e8 5e 0d 00 00       	call   803c63 <_panic>
  802f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	74 10                	je     802f1e <merging+0xe1>
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f16:	8b 52 04             	mov    0x4(%edx),%edx
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	eb 0b                	jmp    802f29 <merging+0xec>
  802f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	a3 30 50 80 00       	mov    %eax,0x805030
  802f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0f                	je     802f42 <merging+0x105>
  802f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3c:	8b 12                	mov    (%edx),%edx
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	eb 0a                	jmp    802f4c <merging+0x10f>
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f64:	48                   	dec    %eax
  802f65:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f6a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f6b:	e9 ea 02 00 00       	jmp    80325a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f74:	74 3b                	je     802fb1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f76:	83 ec 0c             	sub    $0xc,%esp
  802f79:	ff 75 08             	pushl  0x8(%ebp)
  802f7c:	e8 be f0 ff ff       	call   80203f <get_block_size>
  802f81:	83 c4 10             	add    $0x10,%esp
  802f84:	89 c3                	mov    %eax,%ebx
  802f86:	83 ec 0c             	sub    $0xc,%esp
  802f89:	ff 75 10             	pushl  0x10(%ebp)
  802f8c:	e8 ae f0 ff ff       	call   80203f <get_block_size>
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	01 d8                	add    %ebx,%eax
  802f96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f99:	83 ec 04             	sub    $0x4,%esp
  802f9c:	6a 00                	push   $0x0
  802f9e:	ff 75 e8             	pushl  -0x18(%ebp)
  802fa1:	ff 75 08             	pushl  0x8(%ebp)
  802fa4:	e8 e7 f3 ff ff       	call   802390 <set_block_data>
  802fa9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fac:	e9 a9 02 00 00       	jmp    80325a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fb5:	0f 84 2d 01 00 00    	je     8030e8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fbb:	83 ec 0c             	sub    $0xc,%esp
  802fbe:	ff 75 10             	pushl  0x10(%ebp)
  802fc1:	e8 79 f0 ff ff       	call   80203f <get_block_size>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	89 c3                	mov    %eax,%ebx
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	ff 75 0c             	pushl  0xc(%ebp)
  802fd1:	e8 69 f0 ff ff       	call   80203f <get_block_size>
  802fd6:	83 c4 10             	add    $0x10,%esp
  802fd9:	01 d8                	add    %ebx,%eax
  802fdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	6a 00                	push   $0x0
  802fe3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fe6:	ff 75 10             	pushl  0x10(%ebp)
  802fe9:	e8 a2 f3 ff ff       	call   802390 <set_block_data>
  802fee:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ff7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ffb:	74 06                	je     803003 <merging+0x1c6>
  802ffd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803001:	75 17                	jne    80301a <merging+0x1dd>
  803003:	83 ec 04             	sub    $0x4,%esp
  803006:	68 88 48 80 00       	push   $0x804888
  80300b:	68 8d 01 00 00       	push   $0x18d
  803010:	68 e1 47 80 00       	push   $0x8047e1
  803015:	e8 49 0c 00 00       	call   803c63 <_panic>
  80301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301d:	8b 50 04             	mov    0x4(%eax),%edx
  803020:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803023:	89 50 04             	mov    %edx,0x4(%eax)
  803026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 0d                	je     803045 <merging+0x208>
  803038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803041:	89 10                	mov    %edx,(%eax)
  803043:	eb 08                	jmp    80304d <merging+0x210>
  803045:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803048:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80304d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803050:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803053:	89 50 04             	mov    %edx,0x4(%eax)
  803056:	a1 38 50 80 00       	mov    0x805038,%eax
  80305b:	40                   	inc    %eax
  80305c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803061:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803065:	75 17                	jne    80307e <merging+0x241>
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	68 c3 47 80 00       	push   $0x8047c3
  80306f:	68 8e 01 00 00       	push   $0x18e
  803074:	68 e1 47 80 00       	push   $0x8047e1
  803079:	e8 e5 0b 00 00       	call   803c63 <_panic>
  80307e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 10                	je     803097 <merging+0x25a>
  803087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308f:	8b 52 04             	mov    0x4(%edx),%edx
  803092:	89 50 04             	mov    %edx,0x4(%eax)
  803095:	eb 0b                	jmp    8030a2 <merging+0x265>
  803097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	74 0f                	je     8030bb <merging+0x27e>
  8030ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b5:	8b 12                	mov    (%edx),%edx
  8030b7:	89 10                	mov    %edx,(%eax)
  8030b9:	eb 0a                	jmp    8030c5 <merging+0x288>
  8030bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8030dd:	48                   	dec    %eax
  8030de:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030e3:	e9 72 01 00 00       	jmp    80325a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8030e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8030eb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8030ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f2:	74 79                	je     80316d <merging+0x330>
  8030f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030f8:	74 73                	je     80316d <merging+0x330>
  8030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fe:	74 06                	je     803106 <merging+0x2c9>
  803100:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803104:	75 17                	jne    80311d <merging+0x2e0>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 54 48 80 00       	push   $0x804854
  80310e:	68 94 01 00 00       	push   $0x194
  803113:	68 e1 47 80 00       	push   $0x8047e1
  803118:	e8 46 0b 00 00       	call   803c63 <_panic>
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 10                	mov    (%eax),%edx
  803122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803125:	89 10                	mov    %edx,(%eax)
  803127:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0b                	je     80313b <merging+0x2fe>
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803138:	89 50 04             	mov    %edx,0x4(%eax)
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803141:	89 10                	mov    %edx,(%eax)
  803143:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803146:	8b 55 08             	mov    0x8(%ebp),%edx
  803149:	89 50 04             	mov    %edx,0x4(%eax)
  80314c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	75 08                	jne    80315d <merging+0x320>
  803155:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803158:	a3 30 50 80 00       	mov    %eax,0x805030
  80315d:	a1 38 50 80 00       	mov    0x805038,%eax
  803162:	40                   	inc    %eax
  803163:	a3 38 50 80 00       	mov    %eax,0x805038
  803168:	e9 ce 00 00 00       	jmp    80323b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80316d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803171:	74 65                	je     8031d8 <merging+0x39b>
  803173:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803177:	75 17                	jne    803190 <merging+0x353>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 30 48 80 00       	push   $0x804830
  803181:	68 95 01 00 00       	push   $0x195
  803186:	68 e1 47 80 00       	push   $0x8047e1
  80318b:	e8 d3 0a 00 00       	call   803c63 <_panic>
  803190:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803196:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803199:	89 50 04             	mov    %edx,0x4(%eax)
  80319c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 0c                	je     8031b2 <merging+0x375>
  8031a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	eb 08                	jmp    8031ba <merging+0x37d>
  8031b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d0:	40                   	inc    %eax
  8031d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8031d6:	eb 63                	jmp    80323b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031dc:	75 17                	jne    8031f5 <merging+0x3b8>
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	68 fc 47 80 00       	push   $0x8047fc
  8031e6:	68 98 01 00 00       	push   $0x198
  8031eb:	68 e1 47 80 00       	push   $0x8047e1
  8031f0:	e8 6e 0a 00 00       	call   803c63 <_panic>
  8031f5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0d                	je     803216 <merging+0x3d9>
  803209:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 08                	jmp    80321e <merging+0x3e1>
  803216:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803219:	a3 30 50 80 00       	mov    %eax,0x805030
  80321e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803221:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803226:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 38 50 80 00       	mov    0x805038,%eax
  803235:	40                   	inc    %eax
  803236:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80323b:	83 ec 0c             	sub    $0xc,%esp
  80323e:	ff 75 10             	pushl  0x10(%ebp)
  803241:	e8 f9 ed ff ff       	call   80203f <get_block_size>
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	83 ec 04             	sub    $0x4,%esp
  80324c:	6a 00                	push   $0x0
  80324e:	50                   	push   %eax
  80324f:	ff 75 10             	pushl  0x10(%ebp)
  803252:	e8 39 f1 ff ff       	call   802390 <set_block_data>
  803257:	83 c4 10             	add    $0x10,%esp
	}
}
  80325a:	90                   	nop
  80325b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80325e:	c9                   	leave  
  80325f:	c3                   	ret    

00803260 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
  803263:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803266:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80326b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80326e:	a1 30 50 80 00       	mov    0x805030,%eax
  803273:	3b 45 08             	cmp    0x8(%ebp),%eax
  803276:	73 1b                	jae    803293 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803278:	a1 30 50 80 00       	mov    0x805030,%eax
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	ff 75 08             	pushl  0x8(%ebp)
  803283:	6a 00                	push   $0x0
  803285:	50                   	push   %eax
  803286:	e8 b2 fb ff ff       	call   802e3d <merging>
  80328b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80328e:	e9 8b 00 00 00       	jmp    80331e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803293:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803298:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329b:	76 18                	jbe    8032b5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80329d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a2:	83 ec 04             	sub    $0x4,%esp
  8032a5:	ff 75 08             	pushl  0x8(%ebp)
  8032a8:	50                   	push   %eax
  8032a9:	6a 00                	push   $0x0
  8032ab:	e8 8d fb ff ff       	call   802e3d <merging>
  8032b0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032b3:	eb 69                	jmp    80331e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032bd:	eb 39                	jmp    8032f8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032c5:	73 29                	jae    8032f0 <free_block+0x90>
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032cf:	76 1f                	jbe    8032f0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	ff 75 08             	pushl  0x8(%ebp)
  8032df:	ff 75 f0             	pushl  -0x10(%ebp)
  8032e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8032e5:	e8 53 fb ff ff       	call   802e3d <merging>
  8032ea:	83 c4 10             	add    $0x10,%esp
			break;
  8032ed:	90                   	nop
		}
	}
}
  8032ee:	eb 2e                	jmp    80331e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032f0:	a1 34 50 80 00       	mov    0x805034,%eax
  8032f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fc:	74 07                	je     803305 <free_block+0xa5>
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	eb 05                	jmp    80330a <free_block+0xaa>
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	a3 34 50 80 00       	mov    %eax,0x805034
  80330f:	a1 34 50 80 00       	mov    0x805034,%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	75 a7                	jne    8032bf <free_block+0x5f>
  803318:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331c:	75 a1                	jne    8032bf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80331e:	90                   	nop
  80331f:	c9                   	leave  
  803320:	c3                   	ret    

00803321 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803321:	55                   	push   %ebp
  803322:	89 e5                	mov    %esp,%ebp
  803324:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803327:	ff 75 08             	pushl  0x8(%ebp)
  80332a:	e8 10 ed ff ff       	call   80203f <get_block_size>
  80332f:	83 c4 04             	add    $0x4,%esp
  803332:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803335:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80333c:	eb 17                	jmp    803355 <copy_data+0x34>
  80333e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803341:	8b 45 0c             	mov    0xc(%ebp),%eax
  803344:	01 c2                	add    %eax,%edx
  803346:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	01 c8                	add    %ecx,%eax
  80334e:	8a 00                	mov    (%eax),%al
  803350:	88 02                	mov    %al,(%edx)
  803352:	ff 45 fc             	incl   -0x4(%ebp)
  803355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803358:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80335b:	72 e1                	jb     80333e <copy_data+0x1d>
}
  80335d:	90                   	nop
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803366:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336a:	75 23                	jne    80338f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80336c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803370:	74 13                	je     803385 <realloc_block_FF+0x25>
  803372:	83 ec 0c             	sub    $0xc,%esp
  803375:	ff 75 0c             	pushl  0xc(%ebp)
  803378:	e8 42 f0 ff ff       	call   8023bf <alloc_block_FF>
  80337d:	83 c4 10             	add    $0x10,%esp
  803380:	e9 e4 06 00 00       	jmp    803a69 <realloc_block_FF+0x709>
		return NULL;
  803385:	b8 00 00 00 00       	mov    $0x0,%eax
  80338a:	e9 da 06 00 00       	jmp    803a69 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80338f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803393:	75 18                	jne    8033ad <realloc_block_FF+0x4d>
	{
		free_block(va);
  803395:	83 ec 0c             	sub    $0xc,%esp
  803398:	ff 75 08             	pushl  0x8(%ebp)
  80339b:	e8 c0 fe ff ff       	call   803260 <free_block>
  8033a0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a8:	e9 bc 06 00 00       	jmp    803a69 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8033ad:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033b1:	77 07                	ja     8033ba <realloc_block_FF+0x5a>
  8033b3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bd:	83 e0 01             	and    $0x1,%eax
  8033c0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c6:	83 c0 08             	add    $0x8,%eax
  8033c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033cc:	83 ec 0c             	sub    $0xc,%esp
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	e8 68 ec ff ff       	call   80203f <get_block_size>
  8033d7:	83 c4 10             	add    $0x10,%esp
  8033da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e0:	83 e8 08             	sub    $0x8,%eax
  8033e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	83 e8 04             	sub    $0x4,%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	83 e0 fe             	and    $0xfffffffe,%eax
  8033f1:	89 c2                	mov    %eax,%edx
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	01 d0                	add    %edx,%eax
  8033f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8033fb:	83 ec 0c             	sub    $0xc,%esp
  8033fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803401:	e8 39 ec ff ff       	call   80203f <get_block_size>
  803406:	83 c4 10             	add    $0x10,%esp
  803409:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80340c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340f:	83 e8 08             	sub    $0x8,%eax
  803412:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803415:	8b 45 0c             	mov    0xc(%ebp),%eax
  803418:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80341b:	75 08                	jne    803425 <realloc_block_FF+0xc5>
	{
		 return va;
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	e9 44 06 00 00       	jmp    803a69 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803425:	8b 45 0c             	mov    0xc(%ebp),%eax
  803428:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80342b:	0f 83 d5 03 00 00    	jae    803806 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803434:	2b 45 0c             	sub    0xc(%ebp),%eax
  803437:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80343a:	83 ec 0c             	sub    $0xc,%esp
  80343d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803440:	e8 13 ec ff ff       	call   802058 <is_free_block>
  803445:	83 c4 10             	add    $0x10,%esp
  803448:	84 c0                	test   %al,%al
  80344a:	0f 84 3b 01 00 00    	je     80358b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803450:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803453:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803456:	01 d0                	add    %edx,%eax
  803458:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80345b:	83 ec 04             	sub    $0x4,%esp
  80345e:	6a 01                	push   $0x1
  803460:	ff 75 f0             	pushl  -0x10(%ebp)
  803463:	ff 75 08             	pushl  0x8(%ebp)
  803466:	e8 25 ef ff ff       	call   802390 <set_block_data>
  80346b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	83 e8 04             	sub    $0x4,%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	83 e0 fe             	and    $0xfffffffe,%eax
  803479:	89 c2                	mov    %eax,%edx
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	01 d0                	add    %edx,%eax
  803480:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803483:	83 ec 04             	sub    $0x4,%esp
  803486:	6a 00                	push   $0x0
  803488:	ff 75 cc             	pushl  -0x34(%ebp)
  80348b:	ff 75 c8             	pushl  -0x38(%ebp)
  80348e:	e8 fd ee ff ff       	call   802390 <set_block_data>
  803493:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803496:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80349a:	74 06                	je     8034a2 <realloc_block_FF+0x142>
  80349c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034a0:	75 17                	jne    8034b9 <realloc_block_FF+0x159>
  8034a2:	83 ec 04             	sub    $0x4,%esp
  8034a5:	68 54 48 80 00       	push   $0x804854
  8034aa:	68 f6 01 00 00       	push   $0x1f6
  8034af:	68 e1 47 80 00       	push   $0x8047e1
  8034b4:	e8 aa 07 00 00       	call   803c63 <_panic>
  8034b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bc:	8b 10                	mov    (%eax),%edx
  8034be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034c1:	89 10                	mov    %edx,(%eax)
  8034c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	74 0b                	je     8034d7 <realloc_block_FF+0x177>
  8034cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034da:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034dd:	89 10                	mov    %edx,(%eax)
  8034df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e5:	89 50 04             	mov    %edx,0x4(%eax)
  8034e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	75 08                	jne    8034f9 <realloc_block_FF+0x199>
  8034f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fe:	40                   	inc    %eax
  8034ff:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803508:	75 17                	jne    803521 <realloc_block_FF+0x1c1>
  80350a:	83 ec 04             	sub    $0x4,%esp
  80350d:	68 c3 47 80 00       	push   $0x8047c3
  803512:	68 f7 01 00 00       	push   $0x1f7
  803517:	68 e1 47 80 00       	push   $0x8047e1
  80351c:	e8 42 07 00 00       	call   803c63 <_panic>
  803521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 10                	je     80353a <realloc_block_FF+0x1da>
  80352a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803532:	8b 52 04             	mov    0x4(%edx),%edx
  803535:	89 50 04             	mov    %edx,0x4(%eax)
  803538:	eb 0b                	jmp    803545 <realloc_block_FF+0x1e5>
  80353a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353d:	8b 40 04             	mov    0x4(%eax),%eax
  803540:	a3 30 50 80 00       	mov    %eax,0x805030
  803545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	74 0f                	je     80355e <realloc_block_FF+0x1fe>
  80354f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803552:	8b 40 04             	mov    0x4(%eax),%eax
  803555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803558:	8b 12                	mov    (%edx),%edx
  80355a:	89 10                	mov    %edx,(%eax)
  80355c:	eb 0a                	jmp    803568 <realloc_block_FF+0x208>
  80355e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357b:	a1 38 50 80 00       	mov    0x805038,%eax
  803580:	48                   	dec    %eax
  803581:	a3 38 50 80 00       	mov    %eax,0x805038
  803586:	e9 73 02 00 00       	jmp    8037fe <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80358b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80358f:	0f 86 69 02 00 00    	jbe    8037fe <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	6a 01                	push   $0x1
  80359a:	ff 75 f0             	pushl  -0x10(%ebp)
  80359d:	ff 75 08             	pushl  0x8(%ebp)
  8035a0:	e8 eb ed ff ff       	call   802390 <set_block_data>
  8035a5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	83 e8 04             	sub    $0x4,%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8035b3:	89 c2                	mov    %eax,%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	01 d0                	add    %edx,%eax
  8035ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035c5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035c9:	75 68                	jne    803633 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035cf:	75 17                	jne    8035e8 <realloc_block_FF+0x288>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 fc 47 80 00       	push   $0x8047fc
  8035d9:	68 06 02 00 00       	push   $0x206
  8035de:	68 e1 47 80 00       	push   $0x8047e1
  8035e3:	e8 7b 06 00 00       	call   803c63 <_panic>
  8035e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	89 10                	mov    %edx,(%eax)
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	85 c0                	test   %eax,%eax
  8035fa:	74 0d                	je     803609 <realloc_block_FF+0x2a9>
  8035fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803601:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803604:	89 50 04             	mov    %edx,0x4(%eax)
  803607:	eb 08                	jmp    803611 <realloc_block_FF+0x2b1>
  803609:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360c:	a3 30 50 80 00       	mov    %eax,0x805030
  803611:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803614:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803623:	a1 38 50 80 00       	mov    0x805038,%eax
  803628:	40                   	inc    %eax
  803629:	a3 38 50 80 00       	mov    %eax,0x805038
  80362e:	e9 b0 01 00 00       	jmp    8037e3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803633:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803638:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80363b:	76 68                	jbe    8036a5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80363d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803641:	75 17                	jne    80365a <realloc_block_FF+0x2fa>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 fc 47 80 00       	push   $0x8047fc
  80364b:	68 0b 02 00 00       	push   $0x20b
  803650:	68 e1 47 80 00       	push   $0x8047e1
  803655:	e8 09 06 00 00       	call   803c63 <_panic>
  80365a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803663:	89 10                	mov    %edx,(%eax)
  803665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 0d                	je     80367b <realloc_block_FF+0x31b>
  80366e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803673:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	eb 08                	jmp    803683 <realloc_block_FF+0x323>
  80367b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367e:	a3 30 50 80 00       	mov    %eax,0x805030
  803683:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803686:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803695:	a1 38 50 80 00       	mov    0x805038,%eax
  80369a:	40                   	inc    %eax
  80369b:	a3 38 50 80 00       	mov    %eax,0x805038
  8036a0:	e9 3e 01 00 00       	jmp    8037e3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ad:	73 68                	jae    803717 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b3:	75 17                	jne    8036cc <realloc_block_FF+0x36c>
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 30 48 80 00       	push   $0x804830
  8036bd:	68 10 02 00 00       	push   $0x210
  8036c2:	68 e1 47 80 00       	push   $0x8047e1
  8036c7:	e8 97 05 00 00       	call   803c63 <_panic>
  8036cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d5:	89 50 04             	mov    %edx,0x4(%eax)
  8036d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036db:	8b 40 04             	mov    0x4(%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 0c                	je     8036ee <realloc_block_FF+0x38e>
  8036e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ea:	89 10                	mov    %edx,(%eax)
  8036ec:	eb 08                	jmp    8036f6 <realloc_block_FF+0x396>
  8036ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803707:	a1 38 50 80 00       	mov    0x805038,%eax
  80370c:	40                   	inc    %eax
  80370d:	a3 38 50 80 00       	mov    %eax,0x805038
  803712:	e9 cc 00 00 00       	jmp    8037e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803717:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80371e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803726:	e9 8a 00 00 00       	jmp    8037b5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803731:	73 7a                	jae    8037ad <realloc_block_FF+0x44d>
  803733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80373b:	73 70                	jae    8037ad <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803741:	74 06                	je     803749 <realloc_block_FF+0x3e9>
  803743:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803747:	75 17                	jne    803760 <realloc_block_FF+0x400>
  803749:	83 ec 04             	sub    $0x4,%esp
  80374c:	68 54 48 80 00       	push   $0x804854
  803751:	68 1a 02 00 00       	push   $0x21a
  803756:	68 e1 47 80 00       	push   $0x8047e1
  80375b:	e8 03 05 00 00       	call   803c63 <_panic>
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	8b 10                	mov    (%eax),%edx
  803765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	85 c0                	test   %eax,%eax
  803771:	74 0b                	je     80377e <realloc_block_FF+0x41e>
  803773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80377b:	89 50 04             	mov    %edx,0x4(%eax)
  80377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803781:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803784:	89 10                	mov    %edx,(%eax)
  803786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80378c:	89 50 04             	mov    %edx,0x4(%eax)
  80378f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	85 c0                	test   %eax,%eax
  803796:	75 08                	jne    8037a0 <realloc_block_FF+0x440>
  803798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80379b:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a5:	40                   	inc    %eax
  8037a6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037ab:	eb 36                	jmp    8037e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8037b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b9:	74 07                	je     8037c2 <realloc_block_FF+0x462>
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	eb 05                	jmp    8037c7 <realloc_block_FF+0x467>
  8037c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8037cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	0f 85 52 ff ff ff    	jne    80372b <realloc_block_FF+0x3cb>
  8037d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037dd:	0f 85 48 ff ff ff    	jne    80372b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	6a 00                	push   $0x0
  8037e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8037eb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037ee:	e8 9d eb ff ff       	call   802390 <set_block_data>
  8037f3:	83 c4 10             	add    $0x10,%esp
				return va;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	e9 6b 02 00 00       	jmp    803a69 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	e9 63 02 00 00       	jmp    803a69 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803806:	8b 45 0c             	mov    0xc(%ebp),%eax
  803809:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80380c:	0f 86 4d 02 00 00    	jbe    803a5f <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803812:	83 ec 0c             	sub    $0xc,%esp
  803815:	ff 75 e4             	pushl  -0x1c(%ebp)
  803818:	e8 3b e8 ff ff       	call   802058 <is_free_block>
  80381d:	83 c4 10             	add    $0x10,%esp
  803820:	84 c0                	test   %al,%al
  803822:	0f 84 37 02 00 00    	je     803a5f <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80382e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803831:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803834:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803837:	76 38                	jbe    803871 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803839:	83 ec 0c             	sub    $0xc,%esp
  80383c:	ff 75 0c             	pushl  0xc(%ebp)
  80383f:	e8 7b eb ff ff       	call   8023bf <alloc_block_FF>
  803844:	83 c4 10             	add    $0x10,%esp
  803847:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80384a:	83 ec 08             	sub    $0x8,%esp
  80384d:	ff 75 c0             	pushl  -0x40(%ebp)
  803850:	ff 75 08             	pushl  0x8(%ebp)
  803853:	e8 c9 fa ff ff       	call   803321 <copy_data>
  803858:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80385b:	83 ec 0c             	sub    $0xc,%esp
  80385e:	ff 75 08             	pushl  0x8(%ebp)
  803861:	e8 fa f9 ff ff       	call   803260 <free_block>
  803866:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803869:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80386c:	e9 f8 01 00 00       	jmp    803a69 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803874:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803877:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80387a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80387e:	0f 87 a0 00 00 00    	ja     803924 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803888:	75 17                	jne    8038a1 <realloc_block_FF+0x541>
  80388a:	83 ec 04             	sub    $0x4,%esp
  80388d:	68 c3 47 80 00       	push   $0x8047c3
  803892:	68 38 02 00 00       	push   $0x238
  803897:	68 e1 47 80 00       	push   $0x8047e1
  80389c:	e8 c2 03 00 00       	call   803c63 <_panic>
  8038a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	74 10                	je     8038ba <realloc_block_FF+0x55a>
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	8b 00                	mov    (%eax),%eax
  8038af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b2:	8b 52 04             	mov    0x4(%edx),%edx
  8038b5:	89 50 04             	mov    %edx,0x4(%eax)
  8038b8:	eb 0b                	jmp    8038c5 <realloc_block_FF+0x565>
  8038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bd:	8b 40 04             	mov    0x4(%eax),%eax
  8038c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c8:	8b 40 04             	mov    0x4(%eax),%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	74 0f                	je     8038de <realloc_block_FF+0x57e>
  8038cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d2:	8b 40 04             	mov    0x4(%eax),%eax
  8038d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d8:	8b 12                	mov    (%edx),%edx
  8038da:	89 10                	mov    %edx,(%eax)
  8038dc:	eb 0a                	jmp    8038e8 <realloc_block_FF+0x588>
  8038de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803900:	48                   	dec    %eax
  803901:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803906:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390c:	01 d0                	add    %edx,%eax
  80390e:	83 ec 04             	sub    $0x4,%esp
  803911:	6a 01                	push   $0x1
  803913:	50                   	push   %eax
  803914:	ff 75 08             	pushl  0x8(%ebp)
  803917:	e8 74 ea ff ff       	call   802390 <set_block_data>
  80391c:	83 c4 10             	add    $0x10,%esp
  80391f:	e9 36 01 00 00       	jmp    803a5a <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803924:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80392a:	01 d0                	add    %edx,%eax
  80392c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80392f:	83 ec 04             	sub    $0x4,%esp
  803932:	6a 01                	push   $0x1
  803934:	ff 75 f0             	pushl  -0x10(%ebp)
  803937:	ff 75 08             	pushl  0x8(%ebp)
  80393a:	e8 51 ea ff ff       	call   802390 <set_block_data>
  80393f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	83 e8 04             	sub    $0x4,%eax
  803948:	8b 00                	mov    (%eax),%eax
  80394a:	83 e0 fe             	and    $0xfffffffe,%eax
  80394d:	89 c2                	mov    %eax,%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	01 d0                	add    %edx,%eax
  803954:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803957:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80395b:	74 06                	je     803963 <realloc_block_FF+0x603>
  80395d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803961:	75 17                	jne    80397a <realloc_block_FF+0x61a>
  803963:	83 ec 04             	sub    $0x4,%esp
  803966:	68 54 48 80 00       	push   $0x804854
  80396b:	68 44 02 00 00       	push   $0x244
  803970:	68 e1 47 80 00       	push   $0x8047e1
  803975:	e8 e9 02 00 00       	call   803c63 <_panic>
  80397a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397d:	8b 10                	mov    (%eax),%edx
  80397f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803982:	89 10                	mov    %edx,(%eax)
  803984:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803987:	8b 00                	mov    (%eax),%eax
  803989:	85 c0                	test   %eax,%eax
  80398b:	74 0b                	je     803998 <realloc_block_FF+0x638>
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	8b 00                	mov    (%eax),%eax
  803992:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803995:	89 50 04             	mov    %edx,0x4(%eax)
  803998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80399e:	89 10                	mov    %edx,(%eax)
  8039a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a6:	89 50 04             	mov    %edx,0x4(%eax)
  8039a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	85 c0                	test   %eax,%eax
  8039b0:	75 08                	jne    8039ba <realloc_block_FF+0x65a>
  8039b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8039bf:	40                   	inc    %eax
  8039c0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039c9:	75 17                	jne    8039e2 <realloc_block_FF+0x682>
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	68 c3 47 80 00       	push   $0x8047c3
  8039d3:	68 45 02 00 00       	push   $0x245
  8039d8:	68 e1 47 80 00       	push   $0x8047e1
  8039dd:	e8 81 02 00 00       	call   803c63 <_panic>
  8039e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	74 10                	je     8039fb <realloc_block_FF+0x69b>
  8039eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f3:	8b 52 04             	mov    0x4(%edx),%edx
  8039f6:	89 50 04             	mov    %edx,0x4(%eax)
  8039f9:	eb 0b                	jmp    803a06 <realloc_block_FF+0x6a6>
  8039fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fe:	8b 40 04             	mov    0x4(%eax),%eax
  803a01:	a3 30 50 80 00       	mov    %eax,0x805030
  803a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a09:	8b 40 04             	mov    0x4(%eax),%eax
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	74 0f                	je     803a1f <realloc_block_FF+0x6bf>
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a19:	8b 12                	mov    (%edx),%edx
  803a1b:	89 10                	mov    %edx,(%eax)
  803a1d:	eb 0a                	jmp    803a29 <realloc_block_FF+0x6c9>
  803a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a22:	8b 00                	mov    (%eax),%eax
  803a24:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3c:	a1 38 50 80 00       	mov    0x805038,%eax
  803a41:	48                   	dec    %eax
  803a42:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a47:	83 ec 04             	sub    $0x4,%esp
  803a4a:	6a 00                	push   $0x0
  803a4c:	ff 75 bc             	pushl  -0x44(%ebp)
  803a4f:	ff 75 b8             	pushl  -0x48(%ebp)
  803a52:	e8 39 e9 ff ff       	call   802390 <set_block_data>
  803a57:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	eb 0a                	jmp    803a69 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a5f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a69:	c9                   	leave  
  803a6a:	c3                   	ret    

00803a6b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a6b:	55                   	push   %ebp
  803a6c:	89 e5                	mov    %esp,%ebp
  803a6e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a71:	83 ec 04             	sub    $0x4,%esp
  803a74:	68 c0 48 80 00       	push   $0x8048c0
  803a79:	68 58 02 00 00       	push   $0x258
  803a7e:	68 e1 47 80 00       	push   $0x8047e1
  803a83:	e8 db 01 00 00       	call   803c63 <_panic>

00803a88 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a88:	55                   	push   %ebp
  803a89:	89 e5                	mov    %esp,%ebp
  803a8b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a8e:	83 ec 04             	sub    $0x4,%esp
  803a91:	68 e8 48 80 00       	push   $0x8048e8
  803a96:	68 61 02 00 00       	push   $0x261
  803a9b:	68 e1 47 80 00       	push   $0x8047e1
  803aa0:	e8 be 01 00 00       	call   803c63 <_panic>

00803aa5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803aa5:	55                   	push   %ebp
  803aa6:	89 e5                	mov    %esp,%ebp
  803aa8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803aab:	83 ec 04             	sub    $0x4,%esp
  803aae:	6a 01                	push   $0x1
  803ab0:	6a 04                	push   $0x4
  803ab2:	ff 75 0c             	pushl  0xc(%ebp)
  803ab5:	e8 c1 dc ff ff       	call   80177b <smalloc>
  803aba:	83 c4 10             	add    $0x10,%esp
  803abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  803ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac4:	75 14                	jne    803ada <create_semaphore+0x35>
  803ac6:	83 ec 04             	sub    $0x4,%esp
  803ac9:	68 0e 49 80 00       	push   $0x80490e
  803ace:	6a 0d                	push   $0xd
  803ad0:	68 2b 49 80 00       	push   $0x80492b
  803ad5:	e8 89 01 00 00       	call   803c63 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803add:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  803ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae3:	8b 00                	mov    (%eax),%eax
  803ae5:	8b 55 10             	mov    0x10(%ebp),%edx
  803ae8:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  803aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aee:	8b 00                	mov    (%eax),%eax
  803af0:	83 ec 0c             	sub    $0xc,%esp
  803af3:	50                   	push   %eax
  803af4:	e8 cc e4 ff ff       	call   801fc5 <sys_init_queue>
  803af9:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  803afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aff:	8b 00                	mov    (%eax),%eax
  803b01:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0e:	8b 12                	mov    (%edx),%edx
  803b10:	89 10                	mov    %edx,(%eax)
}
  803b12:	8b 45 08             	mov    0x8(%ebp),%eax
  803b15:	c9                   	leave  
  803b16:	c2 04 00             	ret    $0x4

00803b19 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803b19:	55                   	push   %ebp
  803b1a:	89 e5                	mov    %esp,%ebp
  803b1c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803b1f:	83 ec 08             	sub    $0x8,%esp
  803b22:	ff 75 10             	pushl  0x10(%ebp)
  803b25:	ff 75 0c             	pushl  0xc(%ebp)
  803b28:	e8 f3 dc ff ff       	call   801820 <sget>
  803b2d:	83 c4 10             	add    $0x10,%esp
  803b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b37:	75 14                	jne    803b4d <get_semaphore+0x34>
  803b39:	83 ec 04             	sub    $0x4,%esp
  803b3c:	68 3b 49 80 00       	push   $0x80493b
  803b41:	6a 1f                	push   $0x1f
  803b43:	68 2b 49 80 00       	push   $0x80492b
  803b48:	e8 16 01 00 00       	call   803c63 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803b53:	8b 45 08             	mov    0x8(%ebp),%eax
  803b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b59:	8b 12                	mov    (%edx),%edx
  803b5b:	89 10                	mov    %edx,(%eax)
}
  803b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b60:	c9                   	leave  
  803b61:	c2 04 00             	ret    $0x4

00803b64 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803b64:	55                   	push   %ebp
  803b65:	89 e5                	mov    %esp,%ebp
  803b67:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  803b6a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	83 c0 14             	add    $0x14,%eax
  803b77:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b86:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803b89:	f0 87 02             	lock xchg %eax,(%edx)
  803b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b93:	75 dc                	jne    803b71 <wait_semaphore+0xd>

		    sem.semdata->count--;
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	8b 50 10             	mov    0x10(%eax),%edx
  803b9b:	4a                   	dec    %edx
  803b9c:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba2:	8b 40 10             	mov    0x10(%eax),%eax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	79 30                	jns    803bd9 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  803ba9:	e8 f5 e3 ff ff       	call   801fa3 <sys_get_cpu_process>
  803bae:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb4:	83 ec 08             	sub    $0x8,%esp
  803bb7:	ff 75 f0             	pushl  -0x10(%ebp)
  803bba:	50                   	push   %eax
  803bbb:	e8 21 e4 ff ff       	call   801fe1 <sys_enqueue>
  803bc0:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc6:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  803bd7:	eb 0a                	jmp    803be3 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  803bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803be3:	90                   	nop
  803be4:	c9                   	leave  
  803be5:	c3                   	ret    

00803be6 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803be6:	55                   	push   %ebp
  803be7:	89 e5                	mov    %esp,%ebp
  803be9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803bec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf6:	83 c0 14             	add    $0x14,%eax
  803bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803c02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c08:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803c0b:	f0 87 02             	lock xchg %eax,(%edx)
  803c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c15:	75 dc                	jne    803bf3 <signal_semaphore+0xd>
	    sem.semdata->count++;
  803c17:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1a:	8b 50 10             	mov    0x10(%eax),%edx
  803c1d:	42                   	inc    %edx
  803c1e:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803c21:	8b 45 08             	mov    0x8(%ebp),%eax
  803c24:	8b 40 10             	mov    0x10(%eax),%eax
  803c27:	85 c0                	test   %eax,%eax
  803c29:	7f 20                	jg     803c4b <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  803c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2e:	83 ec 0c             	sub    $0xc,%esp
  803c31:	50                   	push   %eax
  803c32:	e8 c8 e3 ff ff       	call   801fff <sys_dequeue>
  803c37:	83 c4 10             	add    $0x10,%esp
  803c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803c3d:	83 ec 0c             	sub    $0xc,%esp
  803c40:	ff 75 f0             	pushl  -0x10(%ebp)
  803c43:	e8 db e3 ff ff       	call   802023 <sys_sched_insert_ready>
  803c48:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  803c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803c55:	90                   	nop
  803c56:	c9                   	leave  
  803c57:	c3                   	ret    

00803c58 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  803c58:	55                   	push   %ebp
  803c59:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5e:	8b 40 10             	mov    0x10(%eax),%eax
}
  803c61:	5d                   	pop    %ebp
  803c62:	c3                   	ret    

00803c63 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803c63:	55                   	push   %ebp
  803c64:	89 e5                	mov    %esp,%ebp
  803c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803c69:	8d 45 10             	lea    0x10(%ebp),%eax
  803c6c:	83 c0 04             	add    $0x4,%eax
  803c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803c72:	a1 60 50 98 00       	mov    0x985060,%eax
  803c77:	85 c0                	test   %eax,%eax
  803c79:	74 16                	je     803c91 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803c7b:	a1 60 50 98 00       	mov    0x985060,%eax
  803c80:	83 ec 08             	sub    $0x8,%esp
  803c83:	50                   	push   %eax
  803c84:	68 5c 49 80 00       	push   $0x80495c
  803c89:	e8 1f ca ff ff       	call   8006ad <cprintf>
  803c8e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803c91:	a1 00 50 80 00       	mov    0x805000,%eax
  803c96:	ff 75 0c             	pushl  0xc(%ebp)
  803c99:	ff 75 08             	pushl  0x8(%ebp)
  803c9c:	50                   	push   %eax
  803c9d:	68 61 49 80 00       	push   $0x804961
  803ca2:	e8 06 ca ff ff       	call   8006ad <cprintf>
  803ca7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803caa:	8b 45 10             	mov    0x10(%ebp),%eax
  803cad:	83 ec 08             	sub    $0x8,%esp
  803cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  803cb3:	50                   	push   %eax
  803cb4:	e8 89 c9 ff ff       	call   800642 <vcprintf>
  803cb9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803cbc:	83 ec 08             	sub    $0x8,%esp
  803cbf:	6a 00                	push   $0x0
  803cc1:	68 7d 49 80 00       	push   $0x80497d
  803cc6:	e8 77 c9 ff ff       	call   800642 <vcprintf>
  803ccb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803cce:	e8 f8 c8 ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803cd3:	eb fe                	jmp    803cd3 <_panic+0x70>

00803cd5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803cd5:	55                   	push   %ebp
  803cd6:	89 e5                	mov    %esp,%ebp
  803cd8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803cdb:	a1 20 50 80 00       	mov    0x805020,%eax
  803ce0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce9:	39 c2                	cmp    %eax,%edx
  803ceb:	74 14                	je     803d01 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ced:	83 ec 04             	sub    $0x4,%esp
  803cf0:	68 80 49 80 00       	push   $0x804980
  803cf5:	6a 26                	push   $0x26
  803cf7:	68 cc 49 80 00       	push   $0x8049cc
  803cfc:	e8 62 ff ff ff       	call   803c63 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803d01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803d08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803d0f:	e9 c5 00 00 00       	jmp    803dd9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d21:	01 d0                	add    %edx,%eax
  803d23:	8b 00                	mov    (%eax),%eax
  803d25:	85 c0                	test   %eax,%eax
  803d27:	75 08                	jne    803d31 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803d29:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803d2c:	e9 a5 00 00 00       	jmp    803dd6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d38:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803d3f:	eb 69                	jmp    803daa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803d41:	a1 20 50 80 00       	mov    0x805020,%eax
  803d46:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d4f:	89 d0                	mov    %edx,%eax
  803d51:	01 c0                	add    %eax,%eax
  803d53:	01 d0                	add    %edx,%eax
  803d55:	c1 e0 03             	shl    $0x3,%eax
  803d58:	01 c8                	add    %ecx,%eax
  803d5a:	8a 40 04             	mov    0x4(%eax),%al
  803d5d:	84 c0                	test   %al,%al
  803d5f:	75 46                	jne    803da7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803d61:	a1 20 50 80 00       	mov    0x805020,%eax
  803d66:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d6f:	89 d0                	mov    %edx,%eax
  803d71:	01 c0                	add    %eax,%eax
  803d73:	01 d0                	add    %edx,%eax
  803d75:	c1 e0 03             	shl    $0x3,%eax
  803d78:	01 c8                	add    %ecx,%eax
  803d7a:	8b 00                	mov    (%eax),%eax
  803d7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803d7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803d87:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803d93:	8b 45 08             	mov    0x8(%ebp),%eax
  803d96:	01 c8                	add    %ecx,%eax
  803d98:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803d9a:	39 c2                	cmp    %eax,%edx
  803d9c:	75 09                	jne    803da7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803d9e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803da5:	eb 15                	jmp    803dbc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803da7:	ff 45 e8             	incl   -0x18(%ebp)
  803daa:	a1 20 50 80 00       	mov    0x805020,%eax
  803daf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db8:	39 c2                	cmp    %eax,%edx
  803dba:	77 85                	ja     803d41 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803dbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803dc0:	75 14                	jne    803dd6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803dc2:	83 ec 04             	sub    $0x4,%esp
  803dc5:	68 d8 49 80 00       	push   $0x8049d8
  803dca:	6a 3a                	push   $0x3a
  803dcc:	68 cc 49 80 00       	push   $0x8049cc
  803dd1:	e8 8d fe ff ff       	call   803c63 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803dd6:	ff 45 f0             	incl   -0x10(%ebp)
  803dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ddf:	0f 8c 2f ff ff ff    	jl     803d14 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803de5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803dec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803df3:	eb 26                	jmp    803e1b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803df5:	a1 20 50 80 00       	mov    0x805020,%eax
  803dfa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803e00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803e03:	89 d0                	mov    %edx,%eax
  803e05:	01 c0                	add    %eax,%eax
  803e07:	01 d0                	add    %edx,%eax
  803e09:	c1 e0 03             	shl    $0x3,%eax
  803e0c:	01 c8                	add    %ecx,%eax
  803e0e:	8a 40 04             	mov    0x4(%eax),%al
  803e11:	3c 01                	cmp    $0x1,%al
  803e13:	75 03                	jne    803e18 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803e15:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803e18:	ff 45 e0             	incl   -0x20(%ebp)
  803e1b:	a1 20 50 80 00       	mov    0x805020,%eax
  803e20:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e29:	39 c2                	cmp    %eax,%edx
  803e2b:	77 c8                	ja     803df5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e30:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803e33:	74 14                	je     803e49 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803e35:	83 ec 04             	sub    $0x4,%esp
  803e38:	68 2c 4a 80 00       	push   $0x804a2c
  803e3d:	6a 44                	push   $0x44
  803e3f:	68 cc 49 80 00       	push   $0x8049cc
  803e44:	e8 1a fe ff ff       	call   803c63 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803e49:	90                   	nop
  803e4a:	c9                   	leave  
  803e4b:	c3                   	ret    

00803e4c <__udivdi3>:
  803e4c:	55                   	push   %ebp
  803e4d:	57                   	push   %edi
  803e4e:	56                   	push   %esi
  803e4f:	53                   	push   %ebx
  803e50:	83 ec 1c             	sub    $0x1c,%esp
  803e53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e63:	89 ca                	mov    %ecx,%edx
  803e65:	89 f8                	mov    %edi,%eax
  803e67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e6b:	85 f6                	test   %esi,%esi
  803e6d:	75 2d                	jne    803e9c <__udivdi3+0x50>
  803e6f:	39 cf                	cmp    %ecx,%edi
  803e71:	77 65                	ja     803ed8 <__udivdi3+0x8c>
  803e73:	89 fd                	mov    %edi,%ebp
  803e75:	85 ff                	test   %edi,%edi
  803e77:	75 0b                	jne    803e84 <__udivdi3+0x38>
  803e79:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7e:	31 d2                	xor    %edx,%edx
  803e80:	f7 f7                	div    %edi
  803e82:	89 c5                	mov    %eax,%ebp
  803e84:	31 d2                	xor    %edx,%edx
  803e86:	89 c8                	mov    %ecx,%eax
  803e88:	f7 f5                	div    %ebp
  803e8a:	89 c1                	mov    %eax,%ecx
  803e8c:	89 d8                	mov    %ebx,%eax
  803e8e:	f7 f5                	div    %ebp
  803e90:	89 cf                	mov    %ecx,%edi
  803e92:	89 fa                	mov    %edi,%edx
  803e94:	83 c4 1c             	add    $0x1c,%esp
  803e97:	5b                   	pop    %ebx
  803e98:	5e                   	pop    %esi
  803e99:	5f                   	pop    %edi
  803e9a:	5d                   	pop    %ebp
  803e9b:	c3                   	ret    
  803e9c:	39 ce                	cmp    %ecx,%esi
  803e9e:	77 28                	ja     803ec8 <__udivdi3+0x7c>
  803ea0:	0f bd fe             	bsr    %esi,%edi
  803ea3:	83 f7 1f             	xor    $0x1f,%edi
  803ea6:	75 40                	jne    803ee8 <__udivdi3+0x9c>
  803ea8:	39 ce                	cmp    %ecx,%esi
  803eaa:	72 0a                	jb     803eb6 <__udivdi3+0x6a>
  803eac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803eb0:	0f 87 9e 00 00 00    	ja     803f54 <__udivdi3+0x108>
  803eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebb:	89 fa                	mov    %edi,%edx
  803ebd:	83 c4 1c             	add    $0x1c,%esp
  803ec0:	5b                   	pop    %ebx
  803ec1:	5e                   	pop    %esi
  803ec2:	5f                   	pop    %edi
  803ec3:	5d                   	pop    %ebp
  803ec4:	c3                   	ret    
  803ec5:	8d 76 00             	lea    0x0(%esi),%esi
  803ec8:	31 ff                	xor    %edi,%edi
  803eca:	31 c0                	xor    %eax,%eax
  803ecc:	89 fa                	mov    %edi,%edx
  803ece:	83 c4 1c             	add    $0x1c,%esp
  803ed1:	5b                   	pop    %ebx
  803ed2:	5e                   	pop    %esi
  803ed3:	5f                   	pop    %edi
  803ed4:	5d                   	pop    %ebp
  803ed5:	c3                   	ret    
  803ed6:	66 90                	xchg   %ax,%ax
  803ed8:	89 d8                	mov    %ebx,%eax
  803eda:	f7 f7                	div    %edi
  803edc:	31 ff                	xor    %edi,%edi
  803ede:	89 fa                	mov    %edi,%edx
  803ee0:	83 c4 1c             	add    $0x1c,%esp
  803ee3:	5b                   	pop    %ebx
  803ee4:	5e                   	pop    %esi
  803ee5:	5f                   	pop    %edi
  803ee6:	5d                   	pop    %ebp
  803ee7:	c3                   	ret    
  803ee8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803eed:	89 eb                	mov    %ebp,%ebx
  803eef:	29 fb                	sub    %edi,%ebx
  803ef1:	89 f9                	mov    %edi,%ecx
  803ef3:	d3 e6                	shl    %cl,%esi
  803ef5:	89 c5                	mov    %eax,%ebp
  803ef7:	88 d9                	mov    %bl,%cl
  803ef9:	d3 ed                	shr    %cl,%ebp
  803efb:	89 e9                	mov    %ebp,%ecx
  803efd:	09 f1                	or     %esi,%ecx
  803eff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f03:	89 f9                	mov    %edi,%ecx
  803f05:	d3 e0                	shl    %cl,%eax
  803f07:	89 c5                	mov    %eax,%ebp
  803f09:	89 d6                	mov    %edx,%esi
  803f0b:	88 d9                	mov    %bl,%cl
  803f0d:	d3 ee                	shr    %cl,%esi
  803f0f:	89 f9                	mov    %edi,%ecx
  803f11:	d3 e2                	shl    %cl,%edx
  803f13:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f17:	88 d9                	mov    %bl,%cl
  803f19:	d3 e8                	shr    %cl,%eax
  803f1b:	09 c2                	or     %eax,%edx
  803f1d:	89 d0                	mov    %edx,%eax
  803f1f:	89 f2                	mov    %esi,%edx
  803f21:	f7 74 24 0c          	divl   0xc(%esp)
  803f25:	89 d6                	mov    %edx,%esi
  803f27:	89 c3                	mov    %eax,%ebx
  803f29:	f7 e5                	mul    %ebp
  803f2b:	39 d6                	cmp    %edx,%esi
  803f2d:	72 19                	jb     803f48 <__udivdi3+0xfc>
  803f2f:	74 0b                	je     803f3c <__udivdi3+0xf0>
  803f31:	89 d8                	mov    %ebx,%eax
  803f33:	31 ff                	xor    %edi,%edi
  803f35:	e9 58 ff ff ff       	jmp    803e92 <__udivdi3+0x46>
  803f3a:	66 90                	xchg   %ax,%ax
  803f3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f40:	89 f9                	mov    %edi,%ecx
  803f42:	d3 e2                	shl    %cl,%edx
  803f44:	39 c2                	cmp    %eax,%edx
  803f46:	73 e9                	jae    803f31 <__udivdi3+0xe5>
  803f48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f4b:	31 ff                	xor    %edi,%edi
  803f4d:	e9 40 ff ff ff       	jmp    803e92 <__udivdi3+0x46>
  803f52:	66 90                	xchg   %ax,%ax
  803f54:	31 c0                	xor    %eax,%eax
  803f56:	e9 37 ff ff ff       	jmp    803e92 <__udivdi3+0x46>
  803f5b:	90                   	nop

00803f5c <__umoddi3>:
  803f5c:	55                   	push   %ebp
  803f5d:	57                   	push   %edi
  803f5e:	56                   	push   %esi
  803f5f:	53                   	push   %ebx
  803f60:	83 ec 1c             	sub    $0x1c,%esp
  803f63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f67:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f7b:	89 f3                	mov    %esi,%ebx
  803f7d:	89 fa                	mov    %edi,%edx
  803f7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f83:	89 34 24             	mov    %esi,(%esp)
  803f86:	85 c0                	test   %eax,%eax
  803f88:	75 1a                	jne    803fa4 <__umoddi3+0x48>
  803f8a:	39 f7                	cmp    %esi,%edi
  803f8c:	0f 86 a2 00 00 00    	jbe    804034 <__umoddi3+0xd8>
  803f92:	89 c8                	mov    %ecx,%eax
  803f94:	89 f2                	mov    %esi,%edx
  803f96:	f7 f7                	div    %edi
  803f98:	89 d0                	mov    %edx,%eax
  803f9a:	31 d2                	xor    %edx,%edx
  803f9c:	83 c4 1c             	add    $0x1c,%esp
  803f9f:	5b                   	pop    %ebx
  803fa0:	5e                   	pop    %esi
  803fa1:	5f                   	pop    %edi
  803fa2:	5d                   	pop    %ebp
  803fa3:	c3                   	ret    
  803fa4:	39 f0                	cmp    %esi,%eax
  803fa6:	0f 87 ac 00 00 00    	ja     804058 <__umoddi3+0xfc>
  803fac:	0f bd e8             	bsr    %eax,%ebp
  803faf:	83 f5 1f             	xor    $0x1f,%ebp
  803fb2:	0f 84 ac 00 00 00    	je     804064 <__umoddi3+0x108>
  803fb8:	bf 20 00 00 00       	mov    $0x20,%edi
  803fbd:	29 ef                	sub    %ebp,%edi
  803fbf:	89 fe                	mov    %edi,%esi
  803fc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fc5:	89 e9                	mov    %ebp,%ecx
  803fc7:	d3 e0                	shl    %cl,%eax
  803fc9:	89 d7                	mov    %edx,%edi
  803fcb:	89 f1                	mov    %esi,%ecx
  803fcd:	d3 ef                	shr    %cl,%edi
  803fcf:	09 c7                	or     %eax,%edi
  803fd1:	89 e9                	mov    %ebp,%ecx
  803fd3:	d3 e2                	shl    %cl,%edx
  803fd5:	89 14 24             	mov    %edx,(%esp)
  803fd8:	89 d8                	mov    %ebx,%eax
  803fda:	d3 e0                	shl    %cl,%eax
  803fdc:	89 c2                	mov    %eax,%edx
  803fde:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fe2:	d3 e0                	shl    %cl,%eax
  803fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fe8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fec:	89 f1                	mov    %esi,%ecx
  803fee:	d3 e8                	shr    %cl,%eax
  803ff0:	09 d0                	or     %edx,%eax
  803ff2:	d3 eb                	shr    %cl,%ebx
  803ff4:	89 da                	mov    %ebx,%edx
  803ff6:	f7 f7                	div    %edi
  803ff8:	89 d3                	mov    %edx,%ebx
  803ffa:	f7 24 24             	mull   (%esp)
  803ffd:	89 c6                	mov    %eax,%esi
  803fff:	89 d1                	mov    %edx,%ecx
  804001:	39 d3                	cmp    %edx,%ebx
  804003:	0f 82 87 00 00 00    	jb     804090 <__umoddi3+0x134>
  804009:	0f 84 91 00 00 00    	je     8040a0 <__umoddi3+0x144>
  80400f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804013:	29 f2                	sub    %esi,%edx
  804015:	19 cb                	sbb    %ecx,%ebx
  804017:	89 d8                	mov    %ebx,%eax
  804019:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80401d:	d3 e0                	shl    %cl,%eax
  80401f:	89 e9                	mov    %ebp,%ecx
  804021:	d3 ea                	shr    %cl,%edx
  804023:	09 d0                	or     %edx,%eax
  804025:	89 e9                	mov    %ebp,%ecx
  804027:	d3 eb                	shr    %cl,%ebx
  804029:	89 da                	mov    %ebx,%edx
  80402b:	83 c4 1c             	add    $0x1c,%esp
  80402e:	5b                   	pop    %ebx
  80402f:	5e                   	pop    %esi
  804030:	5f                   	pop    %edi
  804031:	5d                   	pop    %ebp
  804032:	c3                   	ret    
  804033:	90                   	nop
  804034:	89 fd                	mov    %edi,%ebp
  804036:	85 ff                	test   %edi,%edi
  804038:	75 0b                	jne    804045 <__umoddi3+0xe9>
  80403a:	b8 01 00 00 00       	mov    $0x1,%eax
  80403f:	31 d2                	xor    %edx,%edx
  804041:	f7 f7                	div    %edi
  804043:	89 c5                	mov    %eax,%ebp
  804045:	89 f0                	mov    %esi,%eax
  804047:	31 d2                	xor    %edx,%edx
  804049:	f7 f5                	div    %ebp
  80404b:	89 c8                	mov    %ecx,%eax
  80404d:	f7 f5                	div    %ebp
  80404f:	89 d0                	mov    %edx,%eax
  804051:	e9 44 ff ff ff       	jmp    803f9a <__umoddi3+0x3e>
  804056:	66 90                	xchg   %ax,%ax
  804058:	89 c8                	mov    %ecx,%eax
  80405a:	89 f2                	mov    %esi,%edx
  80405c:	83 c4 1c             	add    $0x1c,%esp
  80405f:	5b                   	pop    %ebx
  804060:	5e                   	pop    %esi
  804061:	5f                   	pop    %edi
  804062:	5d                   	pop    %ebp
  804063:	c3                   	ret    
  804064:	3b 04 24             	cmp    (%esp),%eax
  804067:	72 06                	jb     80406f <__umoddi3+0x113>
  804069:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80406d:	77 0f                	ja     80407e <__umoddi3+0x122>
  80406f:	89 f2                	mov    %esi,%edx
  804071:	29 f9                	sub    %edi,%ecx
  804073:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804077:	89 14 24             	mov    %edx,(%esp)
  80407a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80407e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804082:	8b 14 24             	mov    (%esp),%edx
  804085:	83 c4 1c             	add    $0x1c,%esp
  804088:	5b                   	pop    %ebx
  804089:	5e                   	pop    %esi
  80408a:	5f                   	pop    %edi
  80408b:	5d                   	pop    %ebp
  80408c:	c3                   	ret    
  80408d:	8d 76 00             	lea    0x0(%esi),%esi
  804090:	2b 04 24             	sub    (%esp),%eax
  804093:	19 fa                	sbb    %edi,%edx
  804095:	89 d1                	mov    %edx,%ecx
  804097:	89 c6                	mov    %eax,%esi
  804099:	e9 71 ff ff ff       	jmp    80400f <__umoddi3+0xb3>
  80409e:	66 90                	xchg   %ax,%ax
  8040a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040a4:	72 ea                	jb     804090 <__umoddi3+0x134>
  8040a6:	89 d9                	mov    %ebx,%ecx
  8040a8:	e9 62 ff ff ff       	jmp    80400f <__umoddi3+0xb3>

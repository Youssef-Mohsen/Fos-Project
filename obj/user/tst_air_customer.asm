
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
  800044:	e8 c8 1b 00 00       	call   801c11 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb e9 3e 80 00       	mov    $0x803ee9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb f3 3e 80 00       	mov    $0x803ef3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb ff 3e 80 00       	mov    $0x803eff,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 0e 3f 80 00       	mov    $0x803f0e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 1d 3f 80 00       	mov    $0x803f1d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 32 3f 80 00       	mov    $0x803f32,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 47 3f 80 00       	mov    $0x803f47,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 58 3f 80 00       	mov    $0x803f58,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 69 3f 80 00       	mov    $0x803f69,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 7a 3f 80 00       	mov    $0x803f7a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 83 3f 80 00       	mov    $0x803f83,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 8d 3f 80 00       	mov    $0x803f8d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 98 3f 80 00       	mov    $0x803f98,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb a4 3f 80 00       	mov    $0x803fa4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ae 3f 80 00       	mov    $0x803fae,%ebx
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
  8001be:	bb b8 3f 80 00       	mov    $0x803fb8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb c6 3f 80 00       	mov    $0x803fc6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb d5 3f 80 00       	mov    $0x803fd5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb dc 3f 80 00       	mov    $0x803fdc,%ebx
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
  800222:	e8 d2 15 00 00       	call   8017f9 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 bd 15 00 00       	call   8017f9 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 a5 15 00 00       	call   8017f9 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 8d 15 00 00       	call   8017f9 <sget>
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
  800286:	e8 60 37 00 00       	call   8039eb <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 44 37 00 00       	call   8039eb <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 28 37 00 00       	call   8039eb <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 0c 37 00 00       	call   8039eb <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 f0 36 00 00       	call   8039eb <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 f9 36 00 00       	call   803a05 <wait_semaphore>
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
  80032d:	e8 ed 36 00 00       	call   803a1f <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 c2 36 00 00       	call   803a05 <wait_semaphore>
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
  800363:	e8 9d 36 00 00       	call   803a05 <wait_semaphore>
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
  800397:	e8 83 36 00 00       	call   803a1f <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 72 36 00 00       	call   803a1f <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb e3 3f 80 00       	mov    $0x803fe3,%ebx
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
  800425:	e8 c1 35 00 00       	call   8039eb <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 ca 35 00 00       	call   803a05 <wait_semaphore>
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
  80045e:	68 a0 3e 80 00       	push   $0x803ea0
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 c8 3e 80 00       	push   $0x803ec8
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 91 35 00 00       	call   803a1f <signal_semaphore>
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
  8004a0:	e8 53 17 00 00       	call   801bf8 <sys_getenvindex>
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
  80050e:	e8 69 14 00 00       	call   80197c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 1c 40 80 00       	push   $0x80401c
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
  80053e:	68 44 40 80 00       	push   $0x804044
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
  80056f:	68 6c 40 80 00       	push   $0x80406c
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 c4 40 80 00       	push   $0x8040c4
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 1c 40 80 00       	push   $0x80401c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 e9 13 00 00       	call   801996 <sys_unlock_cons>
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
  8005c0:	e8 ff 15 00 00       	call   801bc4 <sys_destroy_env>
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
  8005d1:	e8 54 16 00 00       	call   801c2a <sys_exit_env>
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
  80061f:	e8 16 13 00 00       	call   80193a <sys_cputs>
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
  800696:	e8 9f 12 00 00       	call   80193a <sys_cputs>
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
  8006e0:	e8 97 12 00 00       	call   80197c <sys_lock_cons>
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
  800700:	e8 91 12 00 00       	call   801996 <sys_unlock_cons>
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
  80074a:	e8 e1 34 00 00       	call   803c30 <__udivdi3>
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
  80079a:	e8 a1 35 00 00       	call   803d40 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 f4 42 80 00       	add    $0x8042f4,%eax
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
  8008f5:	8b 04 85 18 43 80 00 	mov    0x804318(,%eax,4),%eax
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
  8009d6:	8b 34 9d 60 41 80 00 	mov    0x804160(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 05 43 80 00       	push   $0x804305
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
  8009fb:	68 0e 43 80 00       	push   $0x80430e
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
  800a28:	be 11 43 80 00       	mov    $0x804311,%esi
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
  801433:	68 88 44 80 00       	push   $0x804488
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 aa 44 80 00       	push   $0x8044aa
  801442:	e8 fd 25 00 00       	call   803a44 <_panic>

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
  801453:	e8 8d 0a 00 00       	call   801ee5 <sys_sbrk>
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
  8014ce:	e8 96 08 00 00       	call   801d69 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 d6 0d 00 00       	call   8022b8 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 a8 08 00 00       	call   801d9a <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 6f 12 00 00       	call   802774 <alloc_block_BF>
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
  801666:	e8 b1 08 00 00       	call   801f1c <sys_allocate_user_mem>
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
  8016ae:	e8 85 08 00 00       	call   801f38 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 b8 1a 00 00       	call   80317c <free_block>
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
  801756:	e8 a5 07 00 00       	call   801f00 <sys_free_user_mem>
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
  801764:	68 b8 44 80 00       	push   $0x8044b8
  801769:	68 84 00 00 00       	push   $0x84
  80176e:	68 e2 44 80 00       	push   $0x8044e2
  801773:	e8 cc 22 00 00       	call   803a44 <_panic>
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
  801791:	eb 64                	jmp    8017f7 <smalloc+0x7d>
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
  8017c6:	eb 2f                	jmp    8017f7 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017c8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8017cf:	50                   	push   %eax
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 2c 03 00 00       	call   801b07 <sys_createSharedObject>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e5:	74 06                	je     8017ed <smalloc+0x73>
  8017e7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017eb:	75 07                	jne    8017f4 <smalloc+0x7a>
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb 03                	jmp    8017f7 <smalloc+0x7d>
	 return ptr;
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	e8 24 03 00 00       	call   801b31 <sys_getSizeOfSharedObject>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801813:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801817:	75 07                	jne    801820 <sget+0x27>
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
  80181e:	eb 5c                	jmp    80187c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801823:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801826:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80182d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801833:	39 d0                	cmp    %edx,%eax
  801835:	7d 02                	jge    801839 <sget+0x40>
  801837:	89 d0                	mov    %edx,%eax
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	50                   	push   %eax
  80183d:	e8 1b fc ff ff       	call   80145d <malloc>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801848:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80184c:	75 07                	jne    801855 <sget+0x5c>
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	eb 27                	jmp    80187c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	ff 75 e8             	pushl  -0x18(%ebp)
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 e8 02 00 00       	call   801b4e <sys_getSharedObject>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80186c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801870:	75 07                	jne    801879 <sget+0x80>
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
  801877:	eb 03                	jmp    80187c <sget+0x83>
	return ptr;
  801879:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	68 f0 44 80 00       	push   $0x8044f0
  80188c:	68 c1 00 00 00       	push   $0xc1
  801891:	68 e2 44 80 00       	push   $0x8044e2
  801896:	e8 a9 21 00 00       	call   803a44 <_panic>

0080189b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	68 14 45 80 00       	push   $0x804514
  8018a9:	68 d8 00 00 00       	push   $0xd8
  8018ae:	68 e2 44 80 00       	push   $0x8044e2
  8018b3:	e8 8c 21 00 00       	call   803a44 <_panic>

008018b8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	68 3a 45 80 00       	push   $0x80453a
  8018c6:	68 e4 00 00 00       	push   $0xe4
  8018cb:	68 e2 44 80 00       	push   $0x8044e2
  8018d0:	e8 6f 21 00 00       	call   803a44 <_panic>

008018d5 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	68 3a 45 80 00       	push   $0x80453a
  8018e3:	68 e9 00 00 00       	push   $0xe9
  8018e8:	68 e2 44 80 00       	push   $0x8044e2
  8018ed:	e8 52 21 00 00       	call   803a44 <_panic>

008018f2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	68 3a 45 80 00       	push   $0x80453a
  801900:	68 ee 00 00 00       	push   $0xee
  801905:	68 e2 44 80 00       	push   $0x8044e2
  80190a:	e8 35 21 00 00       	call   803a44 <_panic>

0080190f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	57                   	push   %edi
  801913:	56                   	push   %esi
  801914:	53                   	push   %ebx
  801915:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801921:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801924:	8b 7d 18             	mov    0x18(%ebp),%edi
  801927:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80192a:	cd 30                	int    $0x30
  80192c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5f                   	pop    %edi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	8b 45 10             	mov    0x10(%ebp),%eax
  801943:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801946:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	52                   	push   %edx
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	50                   	push   %eax
  801956:	6a 00                	push   $0x0
  801958:	e8 b2 ff ff ff       	call   80190f <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	90                   	nop
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_cgetc>:

int
sys_cgetc(void)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 02                	push   $0x2
  801972:	e8 98 ff ff ff       	call   80190f <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 03                	push   $0x3
  80198b:	e8 7f ff ff ff       	call   80190f <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 04                	push   $0x4
  8019a5:	e8 65 ff ff ff       	call   80190f <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 08                	push   $0x8
  8019c3:	e8 47 ff ff ff       	call   80190f <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	56                   	push   %esi
  8019d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	56                   	push   %esi
  8019e2:	53                   	push   %ebx
  8019e3:	51                   	push   %ecx
  8019e4:	52                   	push   %edx
  8019e5:	50                   	push   %eax
  8019e6:	6a 09                	push   $0x9
  8019e8:	e8 22 ff ff ff       	call   80190f <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	52                   	push   %edx
  801a07:	50                   	push   %eax
  801a08:	6a 0a                	push   $0xa
  801a0a:	e8 00 ff ff ff       	call   80190f <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	ff 75 08             	pushl  0x8(%ebp)
  801a23:	6a 0b                	push   $0xb
  801a25:	e8 e5 fe ff ff       	call   80190f <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 0c                	push   $0xc
  801a3e:	e8 cc fe ff ff       	call   80190f <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 0d                	push   $0xd
  801a57:	e8 b3 fe ff ff       	call   80190f <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 0e                	push   $0xe
  801a70:	e8 9a fe ff ff       	call   80190f <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0f                	push   $0xf
  801a89:	e8 81 fe ff ff       	call   80190f <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 10                	push   $0x10
  801aa3:	e8 67 fe ff ff       	call   80190f <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 11                	push   $0x11
  801abc:	e8 4e fe ff ff       	call   80190f <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 01                	push   $0x1
  801ae2:	e8 28 fe ff ff       	call   80190f <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 14                	push   $0x14
  801afc:	e8 0e fe ff ff       	call   80190f <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b10:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b13:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	51                   	push   %ecx
  801b20:	52                   	push   %edx
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	6a 15                	push   $0x15
  801b27:	e8 e3 fd ff ff       	call   80190f <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 16                	push   $0x16
  801b44:	e8 c6 fd ff ff       	call   80190f <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	51                   	push   %ecx
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 17                	push   $0x17
  801b63:	e8 a7 fd ff ff       	call   80190f <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 18                	push   $0x18
  801b80:	e8 8a fd ff ff       	call   80190f <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	50                   	push   %eax
  801b9c:	6a 19                	push   $0x19
  801b9e:	e8 6c fd ff ff       	call   80190f <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	50                   	push   %eax
  801bb7:	6a 1a                	push   $0x1a
  801bb9:	e8 51 fd ff ff       	call   80190f <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	90                   	nop
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	50                   	push   %eax
  801bd3:	6a 1b                	push   $0x1b
  801bd5:	e8 35 fd ff ff       	call   80190f <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 05                	push   $0x5
  801bee:	e8 1c fd ff ff       	call   80190f <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 06                	push   $0x6
  801c07:	e8 03 fd ff ff       	call   80190f <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 07                	push   $0x7
  801c20:	e8 ea fc ff ff       	call   80190f <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_exit_env>:


void sys_exit_env(void)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 1c                	push   $0x1c
  801c39:	e8 d1 fc ff ff       	call   80190f <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	90                   	nop
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4d:	8d 50 04             	lea    0x4(%eax),%edx
  801c50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	52                   	push   %edx
  801c5a:	50                   	push   %eax
  801c5b:	6a 1d                	push   $0x1d
  801c5d:	e8 ad fc ff ff       	call   80190f <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return result;
  801c65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c6e:	89 01                	mov    %eax,(%ecx)
  801c70:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	c9                   	leave  
  801c77:	c2 04 00             	ret    $0x4

00801c7a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 10             	pushl  0x10(%ebp)
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	6a 13                	push   $0x13
  801c8c:	e8 7e fc ff ff       	call   80190f <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 1e                	push   $0x1e
  801ca6:	e8 64 fc ff ff       	call   80190f <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	50                   	push   %eax
  801cc9:	6a 1f                	push   $0x1f
  801ccb:	e8 3f fc ff ff       	call   80190f <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd3:	90                   	nop
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <rsttst>:
void rsttst()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 21                	push   $0x21
  801ce5:	e8 25 fc ff ff       	call   80190f <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfc:	8b 55 18             	mov    0x18(%ebp),%edx
  801cff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	ff 75 10             	pushl  0x10(%ebp)
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	ff 75 08             	pushl  0x8(%ebp)
  801d0e:	6a 20                	push   $0x20
  801d10:	e8 fa fb ff ff       	call   80190f <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <chktst>:
void chktst(uint32 n)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	6a 22                	push   $0x22
  801d2b:	e8 df fb ff ff       	call   80190f <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <inctst>:

void inctst()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 23                	push   $0x23
  801d45:	e8 c5 fb ff ff       	call   80190f <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <gettst>:
uint32 gettst()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 24                	push   $0x24
  801d5f:	e8 ab fb ff ff       	call   80190f <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 25                	push   $0x25
  801d7b:	e8 8f fb ff ff       	call   80190f <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
  801d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d86:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d8a:	75 07                	jne    801d93 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d91:	eb 05                	jmp    801d98 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 25                	push   $0x25
  801dac:	e8 5e fb ff ff       	call   80190f <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
  801db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dbb:	75 07                	jne    801dc4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc2:	eb 05                	jmp    801dc9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 25                	push   $0x25
  801ddd:	e8 2d fb ff ff       	call   80190f <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
  801de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801de8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dec:	75 07                	jne    801df5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	eb 05                	jmp    801dfa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 25                	push   $0x25
  801e0e:	e8 fc fa ff ff       	call   80190f <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
  801e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e19:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1d:	75 07                	jne    801e26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e24:	eb 05                	jmp    801e2b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 26                	push   $0x26
  801e3d:	e8 cd fa ff ff       	call   80190f <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	53                   	push   %ebx
  801e5b:	51                   	push   %ecx
  801e5c:	52                   	push   %edx
  801e5d:	50                   	push   %eax
  801e5e:	6a 27                	push   $0x27
  801e60:	e8 aa fa ff ff       	call   80190f <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	52                   	push   %edx
  801e7d:	50                   	push   %eax
  801e7e:	6a 28                	push   $0x28
  801e80:	e8 8a fa ff ff       	call   80190f <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e8d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	6a 00                	push   $0x0
  801e98:	51                   	push   %ecx
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	52                   	push   %edx
  801e9d:	50                   	push   %eax
  801e9e:	6a 29                	push   $0x29
  801ea0:	e8 6a fa ff ff       	call   80190f <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	ff 75 10             	pushl  0x10(%ebp)
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	6a 12                	push   $0x12
  801ebc:	e8 4e fa ff ff       	call   80190f <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec4:	90                   	nop
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	6a 2a                	push   $0x2a
  801eda:	e8 30 fa ff ff       	call   80190f <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	50                   	push   %eax
  801ef4:	6a 2b                	push   $0x2b
  801ef6:	e8 14 fa ff ff       	call   80190f <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	ff 75 0c             	pushl  0xc(%ebp)
  801f0c:	ff 75 08             	pushl  0x8(%ebp)
  801f0f:	6a 2c                	push   $0x2c
  801f11:	e8 f9 f9 ff ff       	call   80190f <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return;
  801f19:	90                   	nop
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	ff 75 08             	pushl  0x8(%ebp)
  801f2b:	6a 2d                	push   $0x2d
  801f2d:	e8 dd f9 ff ff       	call   80190f <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
	return;
  801f35:	90                   	nop
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	83 e8 04             	sub    $0x4,%eax
  801f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	83 e8 04             	sub    $0x4,%eax
  801f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f63:	8b 00                	mov    (%eax),%eax
  801f65:	83 e0 01             	and    $0x1,%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 94 c0             	sete   %al
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7f:	83 f8 02             	cmp    $0x2,%eax
  801f82:	74 2b                	je     801faf <alloc_block+0x40>
  801f84:	83 f8 02             	cmp    $0x2,%eax
  801f87:	7f 07                	jg     801f90 <alloc_block+0x21>
  801f89:	83 f8 01             	cmp    $0x1,%eax
  801f8c:	74 0e                	je     801f9c <alloc_block+0x2d>
  801f8e:	eb 58                	jmp    801fe8 <alloc_block+0x79>
  801f90:	83 f8 03             	cmp    $0x3,%eax
  801f93:	74 2d                	je     801fc2 <alloc_block+0x53>
  801f95:	83 f8 04             	cmp    $0x4,%eax
  801f98:	74 3b                	je     801fd5 <alloc_block+0x66>
  801f9a:	eb 4c                	jmp    801fe8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	ff 75 08             	pushl  0x8(%ebp)
  801fa2:	e8 11 03 00 00       	call   8022b8 <alloc_block_FF>
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fad:	eb 4a                	jmp    801ff9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	e8 fa 19 00 00       	call   8039b4 <alloc_block_NF>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc0:	eb 37                	jmp    801ff9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	e8 a7 07 00 00       	call   802774 <alloc_block_BF>
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd3:	eb 24                	jmp    801ff9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 b7 19 00 00       	call   803997 <alloc_block_WF>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe6:	eb 11                	jmp    801ff9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 4c 45 80 00       	push   $0x80454c
  801ff0:	e8 b8 e6 ff ff       	call   8006ad <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
		break;
  801ff8:	90                   	nop
	}
	return va;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	53                   	push   %ebx
  802002:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 6c 45 80 00       	push   $0x80456c
  80200d:	e8 9b e6 ff ff       	call   8006ad <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	68 97 45 80 00       	push   $0x804597
  80201d:	e8 8b e6 ff ff       	call   8006ad <cprintf>
  802022:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202b:	eb 37                	jmp    802064 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff 75 f4             	pushl  -0xc(%ebp)
  802033:	e8 19 ff ff ff       	call   801f51 <is_free_block>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	0f be d8             	movsbl %al,%ebx
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	ff 75 f4             	pushl  -0xc(%ebp)
  802044:	e8 ef fe ff ff       	call   801f38 <get_block_size>
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	53                   	push   %ebx
  802050:	50                   	push   %eax
  802051:	68 af 45 80 00       	push   $0x8045af
  802056:	e8 52 e6 ff ff       	call   8006ad <cprintf>
  80205b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80205e:	8b 45 10             	mov    0x10(%ebp),%eax
  802061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802068:	74 07                	je     802071 <print_blocks_list+0x73>
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 00                	mov    (%eax),%eax
  80206f:	eb 05                	jmp    802076 <print_blocks_list+0x78>
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	89 45 10             	mov    %eax,0x10(%ebp)
  802079:	8b 45 10             	mov    0x10(%ebp),%eax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 ad                	jne    80202d <print_blocks_list+0x2f>
  802080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802084:	75 a7                	jne    80202d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	68 6c 45 80 00       	push   $0x80456c
  80208e:	e8 1a e6 ff ff       	call   8006ad <cprintf>
  802093:	83 c4 10             	add    $0x10,%esp

}
  802096:	90                   	nop
  802097:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	83 e0 01             	and    $0x1,%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	74 03                	je     8020af <initialize_dynamic_allocator+0x13>
  8020ac:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020b3:	0f 84 c7 01 00 00    	je     802280 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020b9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020c0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	01 d0                	add    %edx,%eax
  8020cb:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020d0:	0f 87 ad 01 00 00    	ja     802283 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	0f 89 a5 01 00 00    	jns    802286 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	83 e8 04             	sub    $0x4,%eax
  8020ec:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802100:	e9 87 00 00 00       	jmp    80218c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802109:	75 14                	jne    80211f <initialize_dynamic_allocator+0x83>
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 c7 45 80 00       	push   $0x8045c7
  802113:	6a 79                	push   $0x79
  802115:	68 e5 45 80 00       	push   $0x8045e5
  80211a:	e8 25 19 00 00       	call   803a44 <_panic>
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	74 10                	je     802138 <initialize_dynamic_allocator+0x9c>
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	8b 52 04             	mov    0x4(%edx),%edx
  802133:	89 50 04             	mov    %edx,0x4(%eax)
  802136:	eb 0b                	jmp    802143 <initialize_dynamic_allocator+0xa7>
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	8b 40 04             	mov    0x4(%eax),%eax
  80213e:	a3 30 50 80 00       	mov    %eax,0x805030
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 40 04             	mov    0x4(%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	74 0f                	je     80215c <initialize_dynamic_allocator+0xc0>
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 40 04             	mov    0x4(%eax),%eax
  802153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802156:	8b 12                	mov    (%edx),%edx
  802158:	89 10                	mov    %edx,(%eax)
  80215a:	eb 0a                	jmp    802166 <initialize_dynamic_allocator+0xca>
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802179:	a1 38 50 80 00       	mov    0x805038,%eax
  80217e:	48                   	dec    %eax
  80217f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802184:	a1 34 50 80 00       	mov    0x805034,%eax
  802189:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802190:	74 07                	je     802199 <initialize_dynamic_allocator+0xfd>
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	eb 05                	jmp    80219e <initialize_dynamic_allocator+0x102>
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	a3 34 50 80 00       	mov    %eax,0x805034
  8021a3:	a1 34 50 80 00       	mov    0x805034,%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	0f 85 55 ff ff ff    	jne    802105 <initialize_dynamic_allocator+0x69>
  8021b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b4:	0f 85 4b ff ff ff    	jne    802105 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ce:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	83 c0 08             	add    $0x8,%eax
  8021e4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	83 c0 04             	add    $0x4,%eax
  8021ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f0:	83 ea 08             	sub    $0x8,%edx
  8021f3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	83 e8 08             	sub    $0x8,%eax
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	83 ea 08             	sub    $0x8,%edx
  802206:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80221b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80221f:	75 17                	jne    802238 <initialize_dynamic_allocator+0x19c>
  802221:	83 ec 04             	sub    $0x4,%esp
  802224:	68 00 46 80 00       	push   $0x804600
  802229:	68 90 00 00 00       	push   $0x90
  80222e:	68 e5 45 80 00       	push   $0x8045e5
  802233:	e8 0c 18 00 00       	call   803a44 <_panic>
  802238:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	89 10                	mov    %edx,(%eax)
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 0d                	je     802259 <initialize_dynamic_allocator+0x1bd>
  80224c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802251:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802254:	89 50 04             	mov    %edx,0x4(%eax)
  802257:	eb 08                	jmp    802261 <initialize_dynamic_allocator+0x1c5>
  802259:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225c:	a3 30 50 80 00       	mov    %eax,0x805030
  802261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802264:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802273:	a1 38 50 80 00       	mov    0x805038,%eax
  802278:	40                   	inc    %eax
  802279:	a3 38 50 80 00       	mov    %eax,0x805038
  80227e:	eb 07                	jmp    802287 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802280:	90                   	nop
  802281:	eb 04                	jmp    802287 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802283:	90                   	nop
  802284:	eb 01                	jmp    802287 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802286:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80228c:	8b 45 10             	mov    0x10(%ebp),%eax
  80228f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	8d 50 fc             	lea    -0x4(%eax),%edx
  802298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	83 e8 04             	sub    $0x4,%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8022a8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	01 c2                	add    %eax,%edx
  8022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b3:	89 02                	mov    %eax,(%edx)
}
  8022b5:	90                   	nop
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 03                	je     8022cb <alloc_block_FF+0x13>
  8022c8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022cb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022cf:	77 07                	ja     8022d8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022d1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	75 73                	jne    802354 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	83 c0 10             	add    $0x10,%eax
  8022e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022ea:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f7:	01 d0                	add    %edx,%eax
  8022f9:	48                   	dec    %eax
  8022fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802300:	ba 00 00 00 00       	mov    $0x0,%edx
  802305:	f7 75 ec             	divl   -0x14(%ebp)
  802308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230b:	29 d0                	sub    %edx,%eax
  80230d:	c1 e8 0c             	shr    $0xc,%eax
  802310:	83 ec 0c             	sub    $0xc,%esp
  802313:	50                   	push   %eax
  802314:	e8 2e f1 ff ff       	call   801447 <sbrk>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80231f:	83 ec 0c             	sub    $0xc,%esp
  802322:	6a 00                	push   $0x0
  802324:	e8 1e f1 ff ff       	call   801447 <sbrk>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80232f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802332:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802335:	83 ec 08             	sub    $0x8,%esp
  802338:	50                   	push   %eax
  802339:	ff 75 e4             	pushl  -0x1c(%ebp)
  80233c:	e8 5b fd ff ff       	call   80209c <initialize_dynamic_allocator>
  802341:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802344:	83 ec 0c             	sub    $0xc,%esp
  802347:	68 23 46 80 00       	push   $0x804623
  80234c:	e8 5c e3 ff ff       	call   8006ad <cprintf>
  802351:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802354:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802358:	75 0a                	jne    802364 <alloc_block_FF+0xac>
	        return NULL;
  80235a:	b8 00 00 00 00       	mov    $0x0,%eax
  80235f:	e9 0e 04 00 00       	jmp    802772 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802364:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80236b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802373:	e9 f3 02 00 00       	jmp    80266b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	ff 75 bc             	pushl  -0x44(%ebp)
  802384:	e8 af fb ff ff       	call   801f38 <get_block_size>
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	83 c0 08             	add    $0x8,%eax
  802395:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802398:	0f 87 c5 02 00 00    	ja     802663 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	83 c0 18             	add    $0x18,%eax
  8023a4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a7:	0f 87 19 02 00 00    	ja     8025c6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b3:	83 e8 08             	sub    $0x8,%eax
  8023b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8d 50 08             	lea    0x8(%eax),%edx
  8023bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023c2:	01 d0                	add    %edx,%eax
  8023c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	83 c0 08             	add    $0x8,%eax
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	6a 01                	push   $0x1
  8023d2:	50                   	push   %eax
  8023d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8023d6:	e8 ae fe ff ff       	call   802289 <set_block_data>
  8023db:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 04             	mov    0x4(%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 68                	jne    802450 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023e8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ec:	75 17                	jne    802405 <alloc_block_FF+0x14d>
  8023ee:	83 ec 04             	sub    $0x4,%esp
  8023f1:	68 00 46 80 00       	push   $0x804600
  8023f6:	68 d7 00 00 00       	push   $0xd7
  8023fb:	68 e5 45 80 00       	push   $0x8045e5
  802400:	e8 3f 16 00 00       	call   803a44 <_panic>
  802405:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80240b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240e:	89 10                	mov    %edx,(%eax)
  802410:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	74 0d                	je     802426 <alloc_block_FF+0x16e>
  802419:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80241e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802421:	89 50 04             	mov    %edx,0x4(%eax)
  802424:	eb 08                	jmp    80242e <alloc_block_FF+0x176>
  802426:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802429:	a3 30 50 80 00       	mov    %eax,0x805030
  80242e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802431:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802436:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802439:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802440:	a1 38 50 80 00       	mov    0x805038,%eax
  802445:	40                   	inc    %eax
  802446:	a3 38 50 80 00       	mov    %eax,0x805038
  80244b:	e9 dc 00 00 00       	jmp    80252c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	75 65                	jne    8024be <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802459:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80245d:	75 17                	jne    802476 <alloc_block_FF+0x1be>
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	68 34 46 80 00       	push   $0x804634
  802467:	68 db 00 00 00       	push   $0xdb
  80246c:	68 e5 45 80 00       	push   $0x8045e5
  802471:	e8 ce 15 00 00       	call   803a44 <_panic>
  802476:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80247c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802485:	8b 40 04             	mov    0x4(%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 0c                	je     802498 <alloc_block_FF+0x1e0>
  80248c:	a1 30 50 80 00       	mov    0x805030,%eax
  802491:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 08                	jmp    8024a0 <alloc_block_FF+0x1e8>
  802498:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b6:	40                   	inc    %eax
  8024b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8024bc:	eb 6e                	jmp    80252c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	74 06                	je     8024ca <alloc_block_FF+0x212>
  8024c4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024c8:	75 17                	jne    8024e1 <alloc_block_FF+0x229>
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	68 58 46 80 00       	push   $0x804658
  8024d2:	68 df 00 00 00       	push   $0xdf
  8024d7:	68 e5 45 80 00       	push   $0x8045e5
  8024dc:	e8 63 15 00 00       	call   803a44 <_panic>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 10                	mov    (%eax),%edx
  8024e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 0b                	je     8024ff <alloc_block_FF+0x247>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024fc:	89 50 04             	mov    %edx,0x4(%eax)
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250d:	89 50 04             	mov    %edx,0x4(%eax)
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	75 08                	jne    802521 <alloc_block_FF+0x269>
  802519:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251c:	a3 30 50 80 00       	mov    %eax,0x805030
  802521:	a1 38 50 80 00       	mov    0x805038,%eax
  802526:	40                   	inc    %eax
  802527:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	75 17                	jne    802549 <alloc_block_FF+0x291>
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	68 c7 45 80 00       	push   $0x8045c7
  80253a:	68 e1 00 00 00       	push   $0xe1
  80253f:	68 e5 45 80 00       	push   $0x8045e5
  802544:	e8 fb 14 00 00       	call   803a44 <_panic>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 10                	je     802562 <alloc_block_FF+0x2aa>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255a:	8b 52 04             	mov    0x4(%edx),%edx
  80255d:	89 50 04             	mov    %edx,0x4(%eax)
  802560:	eb 0b                	jmp    80256d <alloc_block_FF+0x2b5>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 04             	mov    0x4(%eax),%eax
  802568:	a3 30 50 80 00       	mov    %eax,0x805030
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 0f                	je     802586 <alloc_block_FF+0x2ce>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 04             	mov    0x4(%eax),%eax
  80257d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802580:	8b 12                	mov    (%edx),%edx
  802582:	89 10                	mov    %edx,(%eax)
  802584:	eb 0a                	jmp    802590 <alloc_block_FF+0x2d8>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a8:	48                   	dec    %eax
  8025a9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	6a 00                	push   $0x0
  8025b3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025b6:	ff 75 b0             	pushl  -0x50(%ebp)
  8025b9:	e8 cb fc ff ff       	call   802289 <set_block_data>
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	e9 95 00 00 00       	jmp    80265b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025c6:	83 ec 04             	sub    $0x4,%esp
  8025c9:	6a 01                	push   $0x1
  8025cb:	ff 75 b8             	pushl  -0x48(%ebp)
  8025ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8025d1:	e8 b3 fc ff ff       	call   802289 <set_block_data>
  8025d6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dd:	75 17                	jne    8025f6 <alloc_block_FF+0x33e>
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	68 c7 45 80 00       	push   $0x8045c7
  8025e7:	68 e8 00 00 00       	push   $0xe8
  8025ec:	68 e5 45 80 00       	push   $0x8045e5
  8025f1:	e8 4e 14 00 00       	call   803a44 <_panic>
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 10                	je     80260f <alloc_block_FF+0x357>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802607:	8b 52 04             	mov    0x4(%edx),%edx
  80260a:	89 50 04             	mov    %edx,0x4(%eax)
  80260d:	eb 0b                	jmp    80261a <alloc_block_FF+0x362>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	a3 30 50 80 00       	mov    %eax,0x805030
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 40 04             	mov    0x4(%eax),%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	74 0f                	je     802633 <alloc_block_FF+0x37b>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 04             	mov    0x4(%eax),%eax
  80262a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262d:	8b 12                	mov    (%edx),%edx
  80262f:	89 10                	mov    %edx,(%eax)
  802631:	eb 0a                	jmp    80263d <alloc_block_FF+0x385>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802650:	a1 38 50 80 00       	mov    0x805038,%eax
  802655:	48                   	dec    %eax
  802656:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80265b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80265e:	e9 0f 01 00 00       	jmp    802772 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802663:	a1 34 50 80 00       	mov    0x805034,%eax
  802668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266f:	74 07                	je     802678 <alloc_block_FF+0x3c0>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	eb 05                	jmp    80267d <alloc_block_FF+0x3c5>
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	a3 34 50 80 00       	mov    %eax,0x805034
  802682:	a1 34 50 80 00       	mov    0x805034,%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	0f 85 e9 fc ff ff    	jne    802378 <alloc_block_FF+0xc0>
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	0f 85 df fc ff ff    	jne    802378 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	83 c0 08             	add    $0x8,%eax
  80269f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026a2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	48                   	dec    %eax
  8026b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bd:	f7 75 d8             	divl   -0x28(%ebp)
  8026c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c3:	29 d0                	sub    %edx,%eax
  8026c5:	c1 e8 0c             	shr    $0xc,%eax
  8026c8:	83 ec 0c             	sub    $0xc,%esp
  8026cb:	50                   	push   %eax
  8026cc:	e8 76 ed ff ff       	call   801447 <sbrk>
  8026d1:	83 c4 10             	add    $0x10,%esp
  8026d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026d7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026db:	75 0a                	jne    8026e7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	e9 8b 00 00 00       	jmp    802772 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026e7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f4:	01 d0                	add    %edx,%eax
  8026f6:	48                   	dec    %eax
  8026f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802702:	f7 75 cc             	divl   -0x34(%ebp)
  802705:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802708:	29 d0                	sub    %edx,%eax
  80270a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80270d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802710:	01 d0                	add    %edx,%eax
  802712:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802717:	a1 40 50 80 00       	mov    0x805040,%eax
  80271c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802722:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802729:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80272f:	01 d0                	add    %edx,%eax
  802731:	48                   	dec    %eax
  802732:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802735:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802738:	ba 00 00 00 00       	mov    $0x0,%edx
  80273d:	f7 75 c4             	divl   -0x3c(%ebp)
  802740:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802743:	29 d0                	sub    %edx,%eax
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	6a 01                	push   $0x1
  80274a:	50                   	push   %eax
  80274b:	ff 75 d0             	pushl  -0x30(%ebp)
  80274e:	e8 36 fb ff ff       	call   802289 <set_block_data>
  802753:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802756:	83 ec 0c             	sub    $0xc,%esp
  802759:	ff 75 d0             	pushl  -0x30(%ebp)
  80275c:	e8 1b 0a 00 00       	call   80317c <free_block>
  802761:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	e8 49 fb ff ff       	call   8022b8 <alloc_block_FF>
  80276f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	83 e0 01             	and    $0x1,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 03                	je     802787 <alloc_block_BF+0x13>
  802784:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802787:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80278b:	77 07                	ja     802794 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80278d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802794:	a1 24 50 80 00       	mov    0x805024,%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	75 73                	jne    802810 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	83 c0 10             	add    $0x10,%eax
  8027a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027a6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b3:	01 d0                	add    %edx,%eax
  8027b5:	48                   	dec    %eax
  8027b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c1:	f7 75 e0             	divl   -0x20(%ebp)
  8027c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c7:	29 d0                	sub    %edx,%eax
  8027c9:	c1 e8 0c             	shr    $0xc,%eax
  8027cc:	83 ec 0c             	sub    $0xc,%esp
  8027cf:	50                   	push   %eax
  8027d0:	e8 72 ec ff ff       	call   801447 <sbrk>
  8027d5:	83 c4 10             	add    $0x10,%esp
  8027d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027db:	83 ec 0c             	sub    $0xc,%esp
  8027de:	6a 00                	push   $0x0
  8027e0:	e8 62 ec ff ff       	call   801447 <sbrk>
  8027e5:	83 c4 10             	add    $0x10,%esp
  8027e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ee:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027f1:	83 ec 08             	sub    $0x8,%esp
  8027f4:	50                   	push   %eax
  8027f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8027f8:	e8 9f f8 ff ff       	call   80209c <initialize_dynamic_allocator>
  8027fd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	68 23 46 80 00       	push   $0x804623
  802808:	e8 a0 de ff ff       	call   8006ad <cprintf>
  80280d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802817:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80281e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802825:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80282c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802831:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802834:	e9 1d 01 00 00       	jmp    802956 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	ff 75 a8             	pushl  -0x58(%ebp)
  802845:	e8 ee f6 ff ff       	call   801f38 <get_block_size>
  80284a:	83 c4 10             	add    $0x10,%esp
  80284d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	83 c0 08             	add    $0x8,%eax
  802856:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802859:	0f 87 ef 00 00 00    	ja     80294e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	83 c0 18             	add    $0x18,%eax
  802865:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802868:	77 1d                	ja     802887 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802870:	0f 86 d8 00 00 00    	jbe    80294e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802876:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802879:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80287c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80287f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802882:	e9 c7 00 00 00       	jmp    80294e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	83 c0 08             	add    $0x8,%eax
  80288d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802890:	0f 85 9d 00 00 00    	jne    802933 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802896:	83 ec 04             	sub    $0x4,%esp
  802899:	6a 01                	push   $0x1
  80289b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80289e:	ff 75 a8             	pushl  -0x58(%ebp)
  8028a1:	e8 e3 f9 ff ff       	call   802289 <set_block_data>
  8028a6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	75 17                	jne    8028c6 <alloc_block_BF+0x152>
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	68 c7 45 80 00       	push   $0x8045c7
  8028b7:	68 2c 01 00 00       	push   $0x12c
  8028bc:	68 e5 45 80 00       	push   $0x8045e5
  8028c1:	e8 7e 11 00 00       	call   803a44 <_panic>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 10                	je     8028df <alloc_block_BF+0x16b>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d7:	8b 52 04             	mov    0x4(%edx),%edx
  8028da:	89 50 04             	mov    %edx,0x4(%eax)
  8028dd:	eb 0b                	jmp    8028ea <alloc_block_BF+0x176>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 0f                	je     802903 <alloc_block_BF+0x18f>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fd:	8b 12                	mov    (%edx),%edx
  8028ff:	89 10                	mov    %edx,(%eax)
  802901:	eb 0a                	jmp    80290d <alloc_block_BF+0x199>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802920:	a1 38 50 80 00       	mov    0x805038,%eax
  802925:	48                   	dec    %eax
  802926:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80292b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80292e:	e9 24 04 00 00       	jmp    802d57 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802939:	76 13                	jbe    80294e <alloc_block_BF+0x1da>
					{
						internal = 1;
  80293b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802942:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802945:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802948:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80294b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80294e:	a1 34 50 80 00       	mov    0x805034,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295a:	74 07                	je     802963 <alloc_block_BF+0x1ef>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	eb 05                	jmp    802968 <alloc_block_BF+0x1f4>
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	a3 34 50 80 00       	mov    %eax,0x805034
  80296d:	a1 34 50 80 00       	mov    0x805034,%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	0f 85 bf fe ff ff    	jne    802839 <alloc_block_BF+0xc5>
  80297a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297e:	0f 85 b5 fe ff ff    	jne    802839 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802984:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802988:	0f 84 26 02 00 00    	je     802bb4 <alloc_block_BF+0x440>
  80298e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802992:	0f 85 1c 02 00 00    	jne    802bb4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299b:	2b 45 08             	sub    0x8(%ebp),%eax
  80299e:	83 e8 08             	sub    $0x8,%eax
  8029a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	8d 50 08             	lea    0x8(%eax),%edx
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	01 d0                	add    %edx,%eax
  8029af:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	83 c0 08             	add    $0x8,%eax
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	6a 01                	push   $0x1
  8029bd:	50                   	push   %eax
  8029be:	ff 75 f0             	pushl  -0x10(%ebp)
  8029c1:	e8 c3 f8 ff ff       	call   802289 <set_block_data>
  8029c6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	75 68                	jne    802a3b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029d7:	75 17                	jne    8029f0 <alloc_block_BF+0x27c>
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 00 46 80 00       	push   $0x804600
  8029e1:	68 45 01 00 00       	push   $0x145
  8029e6:	68 e5 45 80 00       	push   $0x8045e5
  8029eb:	e8 54 10 00 00       	call   803a44 <_panic>
  8029f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 0d                	je     802a11 <alloc_block_BF+0x29d>
  802a04:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	eb 08                	jmp    802a19 <alloc_block_BF+0x2a5>
  802a11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a14:	a3 30 50 80 00       	mov    %eax,0x805030
  802a19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a30:	40                   	inc    %eax
  802a31:	a3 38 50 80 00       	mov    %eax,0x805038
  802a36:	e9 dc 00 00 00       	jmp    802b17 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	75 65                	jne    802aa9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a44:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_BF+0x2ed>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 34 46 80 00       	push   $0x804634
  802a52:	68 4a 01 00 00       	push   $0x14a
  802a57:	68 e5 45 80 00       	push   $0x8045e5
  802a5c:	e8 e3 0f 00 00       	call   803a44 <_panic>
  802a61:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6a:	89 50 04             	mov    %edx,0x4(%eax)
  802a6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 0c                	je     802a83 <alloc_block_BF+0x30f>
  802a77:	a1 30 50 80 00       	mov    0x805030,%eax
  802a7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a7f:	89 10                	mov    %edx,(%eax)
  802a81:	eb 08                	jmp    802a8b <alloc_block_BF+0x317>
  802a83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa1:	40                   	inc    %eax
  802aa2:	a3 38 50 80 00       	mov    %eax,0x805038
  802aa7:	eb 6e                	jmp    802b17 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aad:	74 06                	je     802ab5 <alloc_block_BF+0x341>
  802aaf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ab3:	75 17                	jne    802acc <alloc_block_BF+0x358>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 58 46 80 00       	push   $0x804658
  802abd:	68 4f 01 00 00       	push   $0x14f
  802ac2:	68 e5 45 80 00       	push   $0x8045e5
  802ac7:	e8 78 0f 00 00       	call   803a44 <_panic>
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	8b 10                	mov    (%eax),%edx
  802ad1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	85 c0                	test   %eax,%eax
  802add:	74 0b                	je     802aea <alloc_block_BF+0x376>
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	75 08                	jne    802b0c <alloc_block_BF+0x398>
  802b04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b07:	a3 30 50 80 00       	mov    %eax,0x805030
  802b0c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b11:	40                   	inc    %eax
  802b12:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1b:	75 17                	jne    802b34 <alloc_block_BF+0x3c0>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 c7 45 80 00       	push   $0x8045c7
  802b25:	68 51 01 00 00       	push   $0x151
  802b2a:	68 e5 45 80 00       	push   $0x8045e5
  802b2f:	e8 10 0f 00 00       	call   803a44 <_panic>
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 10                	je     802b4d <alloc_block_BF+0x3d9>
  802b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b45:	8b 52 04             	mov    0x4(%edx),%edx
  802b48:	89 50 04             	mov    %edx,0x4(%eax)
  802b4b:	eb 0b                	jmp    802b58 <alloc_block_BF+0x3e4>
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	a3 30 50 80 00       	mov    %eax,0x805030
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0f                	je     802b71 <alloc_block_BF+0x3fd>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6b:	8b 12                	mov    (%edx),%edx
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	eb 0a                	jmp    802b7b <alloc_block_BF+0x407>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b93:	48                   	dec    %eax
  802b94:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	6a 00                	push   $0x0
  802b9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802ba1:	ff 75 cc             	pushl  -0x34(%ebp)
  802ba4:	e8 e0 f6 ff ff       	call   802289 <set_block_data>
  802ba9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	e9 a3 01 00 00       	jmp    802d57 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bb4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bb8:	0f 85 9d 00 00 00    	jne    802c5b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	6a 01                	push   $0x1
  802bc3:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  802bc9:	e8 bb f6 ff ff       	call   802289 <set_block_data>
  802bce:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd5:	75 17                	jne    802bee <alloc_block_BF+0x47a>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 c7 45 80 00       	push   $0x8045c7
  802bdf:	68 58 01 00 00       	push   $0x158
  802be4:	68 e5 45 80 00       	push   $0x8045e5
  802be9:	e8 56 0e 00 00       	call   803a44 <_panic>
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 10                	je     802c07 <alloc_block_BF+0x493>
  802bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bff:	8b 52 04             	mov    0x4(%edx),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 0b                	jmp    802c12 <alloc_block_BF+0x49e>
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 0f                	je     802c2b <alloc_block_BF+0x4b7>
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c25:	8b 12                	mov    (%edx),%edx
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	eb 0a                	jmp    802c35 <alloc_block_BF+0x4c1>
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c48:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4d:	48                   	dec    %eax
  802c4e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c56:	e9 fc 00 00 00       	jmp    802d57 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	83 c0 08             	add    $0x8,%eax
  802c61:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c64:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c6b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c71:	01 d0                	add    %edx,%eax
  802c73:	48                   	dec    %eax
  802c74:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7f:	f7 75 c4             	divl   -0x3c(%ebp)
  802c82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c85:	29 d0                	sub    %edx,%eax
  802c87:	c1 e8 0c             	shr    $0xc,%eax
  802c8a:	83 ec 0c             	sub    $0xc,%esp
  802c8d:	50                   	push   %eax
  802c8e:	e8 b4 e7 ff ff       	call   801447 <sbrk>
  802c93:	83 c4 10             	add    $0x10,%esp
  802c96:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c99:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c9d:	75 0a                	jne    802ca9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca4:	e9 ae 00 00 00       	jmp    802d57 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ca9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cb0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cb6:	01 d0                	add    %edx,%eax
  802cb8:	48                   	dec    %eax
  802cb9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cbc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc4:	f7 75 b8             	divl   -0x48(%ebp)
  802cc7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cca:	29 d0                	sub    %edx,%eax
  802ccc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ccf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cd2:	01 d0                	add    %edx,%eax
  802cd4:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cd9:	a1 40 50 80 00       	mov    0x805040,%eax
  802cde:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ce4:	83 ec 0c             	sub    $0xc,%esp
  802ce7:	68 8c 46 80 00       	push   $0x80468c
  802cec:	e8 bc d9 ff ff       	call   8006ad <cprintf>
  802cf1:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cf4:	83 ec 08             	sub    $0x8,%esp
  802cf7:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfa:	68 91 46 80 00       	push   $0x804691
  802cff:	e8 a9 d9 ff ff       	call   8006ad <cprintf>
  802d04:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d07:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d0e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d14:	01 d0                	add    %edx,%eax
  802d16:	48                   	dec    %eax
  802d17:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d22:	f7 75 b0             	divl   -0x50(%ebp)
  802d25:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d28:	29 d0                	sub    %edx,%eax
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	6a 01                	push   $0x1
  802d2f:	50                   	push   %eax
  802d30:	ff 75 bc             	pushl  -0x44(%ebp)
  802d33:	e8 51 f5 ff ff       	call   802289 <set_block_data>
  802d38:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d3b:	83 ec 0c             	sub    $0xc,%esp
  802d3e:	ff 75 bc             	pushl  -0x44(%ebp)
  802d41:	e8 36 04 00 00       	call   80317c <free_block>
  802d46:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d49:	83 ec 0c             	sub    $0xc,%esp
  802d4c:	ff 75 08             	pushl  0x8(%ebp)
  802d4f:	e8 20 fa ff ff       	call   802774 <alloc_block_BF>
  802d54:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d57:	c9                   	leave  
  802d58:	c3                   	ret    

00802d59 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
  802d5c:	53                   	push   %ebx
  802d5d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d72:	74 1e                	je     802d92 <merging+0x39>
  802d74:	ff 75 08             	pushl  0x8(%ebp)
  802d77:	e8 bc f1 ff ff       	call   801f38 <get_block_size>
  802d7c:	83 c4 04             	add    $0x4,%esp
  802d7f:	89 c2                	mov    %eax,%edx
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	01 d0                	add    %edx,%eax
  802d86:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d89:	75 07                	jne    802d92 <merging+0x39>
		prev_is_free = 1;
  802d8b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d96:	74 1e                	je     802db6 <merging+0x5d>
  802d98:	ff 75 10             	pushl  0x10(%ebp)
  802d9b:	e8 98 f1 ff ff       	call   801f38 <get_block_size>
  802da0:	83 c4 04             	add    $0x4,%esp
  802da3:	89 c2                	mov    %eax,%edx
  802da5:	8b 45 10             	mov    0x10(%ebp),%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dad:	75 07                	jne    802db6 <merging+0x5d>
		next_is_free = 1;
  802daf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	0f 84 cc 00 00 00    	je     802e8c <merging+0x133>
  802dc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc4:	0f 84 c2 00 00 00    	je     802e8c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 66 f1 ff ff       	call   801f38 <get_block_size>
  802dd2:	83 c4 04             	add    $0x4,%esp
  802dd5:	89 c3                	mov    %eax,%ebx
  802dd7:	ff 75 10             	pushl  0x10(%ebp)
  802dda:	e8 59 f1 ff ff       	call   801f38 <get_block_size>
  802ddf:	83 c4 04             	add    $0x4,%esp
  802de2:	01 c3                	add    %eax,%ebx
  802de4:	ff 75 0c             	pushl  0xc(%ebp)
  802de7:	e8 4c f1 ff ff       	call   801f38 <get_block_size>
  802dec:	83 c4 04             	add    $0x4,%esp
  802def:	01 d8                	add    %ebx,%eax
  802df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802df4:	6a 00                	push   $0x0
  802df6:	ff 75 ec             	pushl  -0x14(%ebp)
  802df9:	ff 75 08             	pushl  0x8(%ebp)
  802dfc:	e8 88 f4 ff ff       	call   802289 <set_block_data>
  802e01:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e08:	75 17                	jne    802e21 <merging+0xc8>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 c7 45 80 00       	push   $0x8045c7
  802e12:	68 7d 01 00 00       	push   $0x17d
  802e17:	68 e5 45 80 00       	push   $0x8045e5
  802e1c:	e8 23 0c 00 00       	call   803a44 <_panic>
  802e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 10                	je     802e3a <merging+0xe1>
  802e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e32:	8b 52 04             	mov    0x4(%edx),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%eax)
  802e38:	eb 0b                	jmp    802e45 <merging+0xec>
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	a3 30 50 80 00       	mov    %eax,0x805030
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0f                	je     802e5e <merging+0x105>
  802e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e58:	8b 12                	mov    (%edx),%edx
  802e5a:	89 10                	mov    %edx,(%eax)
  802e5c:	eb 0a                	jmp    802e68 <merging+0x10f>
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e80:	48                   	dec    %eax
  802e81:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e86:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e87:	e9 ea 02 00 00       	jmp    803176 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e90:	74 3b                	je     802ecd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	ff 75 08             	pushl  0x8(%ebp)
  802e98:	e8 9b f0 ff ff       	call   801f38 <get_block_size>
  802e9d:	83 c4 10             	add    $0x10,%esp
  802ea0:	89 c3                	mov    %eax,%ebx
  802ea2:	83 ec 0c             	sub    $0xc,%esp
  802ea5:	ff 75 10             	pushl  0x10(%ebp)
  802ea8:	e8 8b f0 ff ff       	call   801f38 <get_block_size>
  802ead:	83 c4 10             	add    $0x10,%esp
  802eb0:	01 d8                	add    %ebx,%eax
  802eb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802eb5:	83 ec 04             	sub    $0x4,%esp
  802eb8:	6a 00                	push   $0x0
  802eba:	ff 75 e8             	pushl  -0x18(%ebp)
  802ebd:	ff 75 08             	pushl  0x8(%ebp)
  802ec0:	e8 c4 f3 ff ff       	call   802289 <set_block_data>
  802ec5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec8:	e9 a9 02 00 00       	jmp    803176 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed1:	0f 84 2d 01 00 00    	je     803004 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ed7:	83 ec 0c             	sub    $0xc,%esp
  802eda:	ff 75 10             	pushl  0x10(%ebp)
  802edd:	e8 56 f0 ff ff       	call   801f38 <get_block_size>
  802ee2:	83 c4 10             	add    $0x10,%esp
  802ee5:	89 c3                	mov    %eax,%ebx
  802ee7:	83 ec 0c             	sub    $0xc,%esp
  802eea:	ff 75 0c             	pushl  0xc(%ebp)
  802eed:	e8 46 f0 ff ff       	call   801f38 <get_block_size>
  802ef2:	83 c4 10             	add    $0x10,%esp
  802ef5:	01 d8                	add    %ebx,%eax
  802ef7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	6a 00                	push   $0x0
  802eff:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f02:	ff 75 10             	pushl  0x10(%ebp)
  802f05:	e8 7f f3 ff ff       	call   802289 <set_block_data>
  802f0a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  802f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f17:	74 06                	je     802f1f <merging+0x1c6>
  802f19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f1d:	75 17                	jne    802f36 <merging+0x1dd>
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	68 a0 46 80 00       	push   $0x8046a0
  802f27:	68 8d 01 00 00       	push   $0x18d
  802f2c:	68 e5 45 80 00       	push   $0x8045e5
  802f31:	e8 0e 0b 00 00       	call   803a44 <_panic>
  802f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f39:	8b 50 04             	mov    0x4(%eax),%edx
  802f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3f:	89 50 04             	mov    %edx,0x4(%eax)
  802f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f48:	89 10                	mov    %edx,(%eax)
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 0d                	je     802f61 <merging+0x208>
  802f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5d:	89 10                	mov    %edx,(%eax)
  802f5f:	eb 08                	jmp    802f69 <merging+0x210>
  802f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f64:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6f:	89 50 04             	mov    %edx,0x4(%eax)
  802f72:	a1 38 50 80 00       	mov    0x805038,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f81:	75 17                	jne    802f9a <merging+0x241>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 c7 45 80 00       	push   $0x8045c7
  802f8b:	68 8e 01 00 00       	push   $0x18e
  802f90:	68 e5 45 80 00       	push   $0x8045e5
  802f95:	e8 aa 0a 00 00       	call   803a44 <_panic>
  802f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9d:	8b 00                	mov    (%eax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	74 10                	je     802fb3 <merging+0x25a>
  802fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fab:	8b 52 04             	mov    0x4(%edx),%edx
  802fae:	89 50 04             	mov    %edx,0x4(%eax)
  802fb1:	eb 0b                	jmp    802fbe <merging+0x265>
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 0f                	je     802fd7 <merging+0x27e>
  802fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd1:	8b 12                	mov    (%edx),%edx
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	eb 0a                	jmp    802fe1 <merging+0x288>
  802fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff9:	48                   	dec    %eax
  802ffa:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fff:	e9 72 01 00 00       	jmp    803176 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803004:	8b 45 10             	mov    0x10(%ebp),%eax
  803007:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	74 79                	je     803089 <merging+0x330>
  803010:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803014:	74 73                	je     803089 <merging+0x330>
  803016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301a:	74 06                	je     803022 <merging+0x2c9>
  80301c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803020:	75 17                	jne    803039 <merging+0x2e0>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 58 46 80 00       	push   $0x804658
  80302a:	68 94 01 00 00       	push   $0x194
  80302f:	68 e5 45 80 00       	push   $0x8045e5
  803034:	e8 0b 0a 00 00       	call   803a44 <_panic>
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 10                	mov    (%eax),%edx
  80303e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0b                	je     803057 <merging+0x2fe>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803062:	8b 55 08             	mov    0x8(%ebp),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	75 08                	jne    803079 <merging+0x320>
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	a3 30 50 80 00       	mov    %eax,0x805030
  803079:	a1 38 50 80 00       	mov    0x805038,%eax
  80307e:	40                   	inc    %eax
  80307f:	a3 38 50 80 00       	mov    %eax,0x805038
  803084:	e9 ce 00 00 00       	jmp    803157 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308d:	74 65                	je     8030f4 <merging+0x39b>
  80308f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803093:	75 17                	jne    8030ac <merging+0x353>
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 34 46 80 00       	push   $0x804634
  80309d:	68 95 01 00 00       	push   $0x195
  8030a2:	68 e5 45 80 00       	push   $0x8045e5
  8030a7:	e8 98 09 00 00       	call   803a44 <_panic>
  8030ac:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bb:	8b 40 04             	mov    0x4(%eax),%eax
  8030be:	85 c0                	test   %eax,%eax
  8030c0:	74 0c                	je     8030ce <merging+0x375>
  8030c2:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030ca:	89 10                	mov    %edx,(%eax)
  8030cc:	eb 08                	jmp    8030d6 <merging+0x37d>
  8030ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ec:	40                   	inc    %eax
  8030ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8030f2:	eb 63                	jmp    803157 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030f8:	75 17                	jne    803111 <merging+0x3b8>
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	68 00 46 80 00       	push   $0x804600
  803102:	68 98 01 00 00       	push   $0x198
  803107:	68 e5 45 80 00       	push   $0x8045e5
  80310c:	e8 33 09 00 00       	call   803a44 <_panic>
  803111:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803117:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0d                	je     803132 <merging+0x3d9>
  803125:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	eb 08                	jmp    80313a <merging+0x3e1>
  803132:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803135:	a3 30 50 80 00       	mov    %eax,0x805030
  80313a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803142:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 38 50 80 00       	mov    0x805038,%eax
  803151:	40                   	inc    %eax
  803152:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	ff 75 10             	pushl  0x10(%ebp)
  80315d:	e8 d6 ed ff ff       	call   801f38 <get_block_size>
  803162:	83 c4 10             	add    $0x10,%esp
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	6a 00                	push   $0x0
  80316a:	50                   	push   %eax
  80316b:	ff 75 10             	pushl  0x10(%ebp)
  80316e:	e8 16 f1 ff ff       	call   802289 <set_block_data>
  803173:	83 c4 10             	add    $0x10,%esp
	}
}
  803176:	90                   	nop
  803177:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80317a:	c9                   	leave  
  80317b:	c3                   	ret    

0080317c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803182:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803187:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80318a:	a1 30 50 80 00       	mov    0x805030,%eax
  80318f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803192:	73 1b                	jae    8031af <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803194:	a1 30 50 80 00       	mov    0x805030,%eax
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	ff 75 08             	pushl  0x8(%ebp)
  80319f:	6a 00                	push   $0x0
  8031a1:	50                   	push   %eax
  8031a2:	e8 b2 fb ff ff       	call   802d59 <merging>
  8031a7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031aa:	e9 8b 00 00 00       	jmp    80323a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b7:	76 18                	jbe    8031d1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031b9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	ff 75 08             	pushl  0x8(%ebp)
  8031c4:	50                   	push   %eax
  8031c5:	6a 00                	push   $0x0
  8031c7:	e8 8d fb ff ff       	call   802d59 <merging>
  8031cc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031cf:	eb 69                	jmp    80323a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d9:	eb 39                	jmp    803214 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e1:	73 29                	jae    80320c <free_block+0x90>
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031eb:	76 1f                	jbe    80320c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	ff 75 08             	pushl  0x8(%ebp)
  8031fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8031fe:	ff 75 f4             	pushl  -0xc(%ebp)
  803201:	e8 53 fb ff ff       	call   802d59 <merging>
  803206:	83 c4 10             	add    $0x10,%esp
			break;
  803209:	90                   	nop
		}
	}
}
  80320a:	eb 2e                	jmp    80323a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320c:	a1 34 50 80 00       	mov    0x805034,%eax
  803211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803218:	74 07                	je     803221 <free_block+0xa5>
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	eb 05                	jmp    803226 <free_block+0xaa>
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
  803226:	a3 34 50 80 00       	mov    %eax,0x805034
  80322b:	a1 34 50 80 00       	mov    0x805034,%eax
  803230:	85 c0                	test   %eax,%eax
  803232:	75 a7                	jne    8031db <free_block+0x5f>
  803234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803238:	75 a1                	jne    8031db <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80323a:	90                   	nop
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
  803240:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803243:	ff 75 08             	pushl  0x8(%ebp)
  803246:	e8 ed ec ff ff       	call   801f38 <get_block_size>
  80324b:	83 c4 04             	add    $0x4,%esp
  80324e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803258:	eb 17                	jmp    803271 <copy_data+0x34>
  80325a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80325d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	01 c8                	add    %ecx,%eax
  80326a:	8a 00                	mov    (%eax),%al
  80326c:	88 02                	mov    %al,(%edx)
  80326e:	ff 45 fc             	incl   -0x4(%ebp)
  803271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803277:	72 e1                	jb     80325a <copy_data+0x1d>
}
  803279:	90                   	nop
  80327a:	c9                   	leave  
  80327b:	c3                   	ret    

0080327c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80327c:	55                   	push   %ebp
  80327d:	89 e5                	mov    %esp,%ebp
  80327f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803286:	75 23                	jne    8032ab <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803288:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80328c:	74 13                	je     8032a1 <realloc_block_FF+0x25>
  80328e:	83 ec 0c             	sub    $0xc,%esp
  803291:	ff 75 0c             	pushl  0xc(%ebp)
  803294:	e8 1f f0 ff ff       	call   8022b8 <alloc_block_FF>
  803299:	83 c4 10             	add    $0x10,%esp
  80329c:	e9 f4 06 00 00       	jmp    803995 <realloc_block_FF+0x719>
		return NULL;
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	e9 ea 06 00 00       	jmp    803995 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032af:	75 18                	jne    8032c9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032b1:	83 ec 0c             	sub    $0xc,%esp
  8032b4:	ff 75 08             	pushl  0x8(%ebp)
  8032b7:	e8 c0 fe ff ff       	call   80317c <free_block>
  8032bc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c4:	e9 cc 06 00 00       	jmp    803995 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032c9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032cd:	77 07                	ja     8032d6 <realloc_block_FF+0x5a>
  8032cf:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d9:	83 e0 01             	and    $0x1,%eax
  8032dc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e2:	83 c0 08             	add    $0x8,%eax
  8032e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032e8:	83 ec 0c             	sub    $0xc,%esp
  8032eb:	ff 75 08             	pushl  0x8(%ebp)
  8032ee:	e8 45 ec ff ff       	call   801f38 <get_block_size>
  8032f3:	83 c4 10             	add    $0x10,%esp
  8032f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	83 e8 08             	sub    $0x8,%eax
  8032ff:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	83 e8 04             	sub    $0x4,%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	83 e0 fe             	and    $0xfffffffe,%eax
  80330d:	89 c2                	mov    %eax,%edx
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	01 d0                	add    %edx,%eax
  803314:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803317:	83 ec 0c             	sub    $0xc,%esp
  80331a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80331d:	e8 16 ec ff ff       	call   801f38 <get_block_size>
  803322:	83 c4 10             	add    $0x10,%esp
  803325:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332b:	83 e8 08             	sub    $0x8,%eax
  80332e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803331:	8b 45 0c             	mov    0xc(%ebp),%eax
  803334:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803337:	75 08                	jne    803341 <realloc_block_FF+0xc5>
	{
		 return va;
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	e9 54 06 00 00       	jmp    803995 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803341:	8b 45 0c             	mov    0xc(%ebp),%eax
  803344:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803347:	0f 83 e5 03 00 00    	jae    803732 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	2b 45 0c             	sub    0xc(%ebp),%eax
  803353:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803356:	83 ec 0c             	sub    $0xc,%esp
  803359:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335c:	e8 f0 eb ff ff       	call   801f51 <is_free_block>
  803361:	83 c4 10             	add    $0x10,%esp
  803364:	84 c0                	test   %al,%al
  803366:	0f 84 3b 01 00 00    	je     8034a7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80336c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80336f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803372:	01 d0                	add    %edx,%eax
  803374:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	6a 01                	push   $0x1
  80337c:	ff 75 f0             	pushl  -0x10(%ebp)
  80337f:	ff 75 08             	pushl  0x8(%ebp)
  803382:	e8 02 ef ff ff       	call   802289 <set_block_data>
  803387:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	83 e8 04             	sub    $0x4,%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	83 e0 fe             	and    $0xfffffffe,%eax
  803395:	89 c2                	mov    %eax,%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	01 d0                	add    %edx,%eax
  80339c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80339f:	83 ec 04             	sub    $0x4,%esp
  8033a2:	6a 00                	push   $0x0
  8033a4:	ff 75 cc             	pushl  -0x34(%ebp)
  8033a7:	ff 75 c8             	pushl  -0x38(%ebp)
  8033aa:	e8 da ee ff ff       	call   802289 <set_block_data>
  8033af:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b6:	74 06                	je     8033be <realloc_block_FF+0x142>
  8033b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033bc:	75 17                	jne    8033d5 <realloc_block_FF+0x159>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 58 46 80 00       	push   $0x804658
  8033c6:	68 f6 01 00 00       	push   $0x1f6
  8033cb:	68 e5 45 80 00       	push   $0x8045e5
  8033d0:	e8 6f 06 00 00       	call   803a44 <_panic>
  8033d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d8:	8b 10                	mov    (%eax),%edx
  8033da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033dd:	89 10                	mov    %edx,(%eax)
  8033df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 0b                	je     8033f3 <realloc_block_FF+0x177>
  8033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f0:	89 50 04             	mov    %edx,0x4(%eax)
  8033f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f9:	89 10                	mov    %edx,(%eax)
  8033fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	75 08                	jne    803415 <realloc_block_FF+0x199>
  80340d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803410:	a3 30 50 80 00       	mov    %eax,0x805030
  803415:	a1 38 50 80 00       	mov    0x805038,%eax
  80341a:	40                   	inc    %eax
  80341b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803420:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803424:	75 17                	jne    80343d <realloc_block_FF+0x1c1>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 c7 45 80 00       	push   $0x8045c7
  80342e:	68 f7 01 00 00       	push   $0x1f7
  803433:	68 e5 45 80 00       	push   $0x8045e5
  803438:	e8 07 06 00 00       	call   803a44 <_panic>
  80343d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 10                	je     803456 <realloc_block_FF+0x1da>
  803446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344e:	8b 52 04             	mov    0x4(%edx),%edx
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	eb 0b                	jmp    803461 <realloc_block_FF+0x1e5>
  803456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803459:	8b 40 04             	mov    0x4(%eax),%eax
  80345c:	a3 30 50 80 00       	mov    %eax,0x805030
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8b 40 04             	mov    0x4(%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 0f                	je     80347a <realloc_block_FF+0x1fe>
  80346b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803474:	8b 12                	mov    (%edx),%edx
  803476:	89 10                	mov    %edx,(%eax)
  803478:	eb 0a                	jmp    803484 <realloc_block_FF+0x208>
  80347a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803490:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803497:	a1 38 50 80 00       	mov    0x805038,%eax
  80349c:	48                   	dec    %eax
  80349d:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a2:	e9 83 02 00 00       	jmp    80372a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034a7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034ab:	0f 86 69 02 00 00    	jbe    80371a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034b1:	83 ec 04             	sub    $0x4,%esp
  8034b4:	6a 01                	push   $0x1
  8034b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034b9:	ff 75 08             	pushl  0x8(%ebp)
  8034bc:	e8 c8 ed ff ff       	call   802289 <set_block_data>
  8034c1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	83 e8 04             	sub    $0x4,%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034cf:	89 c2                	mov    %eax,%edx
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	01 d0                	add    %edx,%eax
  8034d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8034de:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034e1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034e5:	75 68                	jne    80354f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034eb:	75 17                	jne    803504 <realloc_block_FF+0x288>
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	68 00 46 80 00       	push   $0x804600
  8034f5:	68 06 02 00 00       	push   $0x206
  8034fa:	68 e5 45 80 00       	push   $0x8045e5
  8034ff:	e8 40 05 00 00       	call   803a44 <_panic>
  803504:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80350a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350d:	89 10                	mov    %edx,(%eax)
  80350f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 0d                	je     803525 <realloc_block_FF+0x2a9>
  803518:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803520:	89 50 04             	mov    %edx,0x4(%eax)
  803523:	eb 08                	jmp    80352d <realloc_block_FF+0x2b1>
  803525:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803528:	a3 30 50 80 00       	mov    %eax,0x805030
  80352d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803530:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803535:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353f:	a1 38 50 80 00       	mov    0x805038,%eax
  803544:	40                   	inc    %eax
  803545:	a3 38 50 80 00       	mov    %eax,0x805038
  80354a:	e9 b0 01 00 00       	jmp    8036ff <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80354f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803554:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803557:	76 68                	jbe    8035c1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803559:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80355d:	75 17                	jne    803576 <realloc_block_FF+0x2fa>
  80355f:	83 ec 04             	sub    $0x4,%esp
  803562:	68 00 46 80 00       	push   $0x804600
  803567:	68 0b 02 00 00       	push   $0x20b
  80356c:	68 e5 45 80 00       	push   $0x8045e5
  803571:	e8 ce 04 00 00       	call   803a44 <_panic>
  803576:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357f:	89 10                	mov    %edx,(%eax)
  803581:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	85 c0                	test   %eax,%eax
  803588:	74 0d                	je     803597 <realloc_block_FF+0x31b>
  80358a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80358f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803592:	89 50 04             	mov    %edx,0x4(%eax)
  803595:	eb 08                	jmp    80359f <realloc_block_FF+0x323>
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	a3 30 50 80 00       	mov    %eax,0x805030
  80359f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b6:	40                   	inc    %eax
  8035b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8035bc:	e9 3e 01 00 00       	jmp    8036ff <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035c9:	73 68                	jae    803633 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035cf:	75 17                	jne    8035e8 <realloc_block_FF+0x36c>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 34 46 80 00       	push   $0x804634
  8035d9:	68 10 02 00 00       	push   $0x210
  8035de:	68 e5 45 80 00       	push   $0x8045e5
  8035e3:	e8 5c 04 00 00       	call   803a44 <_panic>
  8035e8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	89 50 04             	mov    %edx,0x4(%eax)
  8035f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f7:	8b 40 04             	mov    0x4(%eax),%eax
  8035fa:	85 c0                	test   %eax,%eax
  8035fc:	74 0c                	je     80360a <realloc_block_FF+0x38e>
  8035fe:	a1 30 50 80 00       	mov    0x805030,%eax
  803603:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803606:	89 10                	mov    %edx,(%eax)
  803608:	eb 08                	jmp    803612 <realloc_block_FF+0x396>
  80360a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	a3 30 50 80 00       	mov    %eax,0x805030
  80361a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803623:	a1 38 50 80 00       	mov    0x805038,%eax
  803628:	40                   	inc    %eax
  803629:	a3 38 50 80 00       	mov    %eax,0x805038
  80362e:	e9 cc 00 00 00       	jmp    8036ff <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80363a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80363f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803642:	e9 8a 00 00 00       	jmp    8036d1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80364d:	73 7a                	jae    8036c9 <realloc_block_FF+0x44d>
  80364f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803652:	8b 00                	mov    (%eax),%eax
  803654:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803657:	73 70                	jae    8036c9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365d:	74 06                	je     803665 <realloc_block_FF+0x3e9>
  80365f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803663:	75 17                	jne    80367c <realloc_block_FF+0x400>
  803665:	83 ec 04             	sub    $0x4,%esp
  803668:	68 58 46 80 00       	push   $0x804658
  80366d:	68 1a 02 00 00       	push   $0x21a
  803672:	68 e5 45 80 00       	push   $0x8045e5
  803677:	e8 c8 03 00 00       	call   803a44 <_panic>
  80367c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367f:	8b 10                	mov    (%eax),%edx
  803681:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803684:	89 10                	mov    %edx,(%eax)
  803686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803689:	8b 00                	mov    (%eax),%eax
  80368b:	85 c0                	test   %eax,%eax
  80368d:	74 0b                	je     80369a <realloc_block_FF+0x41e>
  80368f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803697:	89 50 04             	mov    %edx,0x4(%eax)
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a0:	89 10                	mov    %edx,(%eax)
  8036a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	85 c0                	test   %eax,%eax
  8036b2:	75 08                	jne    8036bc <realloc_block_FF+0x440>
  8036b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c1:	40                   	inc    %eax
  8036c2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036c7:	eb 36                	jmp    8036ff <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d5:	74 07                	je     8036de <realloc_block_FF+0x462>
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 00                	mov    (%eax),%eax
  8036dc:	eb 05                	jmp    8036e3 <realloc_block_FF+0x467>
  8036de:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e3:	a3 34 50 80 00       	mov    %eax,0x805034
  8036e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	0f 85 52 ff ff ff    	jne    803647 <realloc_block_FF+0x3cb>
  8036f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f9:	0f 85 48 ff ff ff    	jne    803647 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	6a 00                	push   $0x0
  803704:	ff 75 d8             	pushl  -0x28(%ebp)
  803707:	ff 75 d4             	pushl  -0x2c(%ebp)
  80370a:	e8 7a eb ff ff       	call   802289 <set_block_data>
  80370f:	83 c4 10             	add    $0x10,%esp
				return va;
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	e9 7b 02 00 00       	jmp    803995 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80371a:	83 ec 0c             	sub    $0xc,%esp
  80371d:	68 d5 46 80 00       	push   $0x8046d5
  803722:	e8 86 cf ff ff       	call   8006ad <cprintf>
  803727:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	e9 63 02 00 00       	jmp    803995 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803732:	8b 45 0c             	mov    0xc(%ebp),%eax
  803735:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803738:	0f 86 4d 02 00 00    	jbe    80398b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80373e:	83 ec 0c             	sub    $0xc,%esp
  803741:	ff 75 e4             	pushl  -0x1c(%ebp)
  803744:	e8 08 e8 ff ff       	call   801f51 <is_free_block>
  803749:	83 c4 10             	add    $0x10,%esp
  80374c:	84 c0                	test   %al,%al
  80374e:	0f 84 37 02 00 00    	je     80398b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803754:	8b 45 0c             	mov    0xc(%ebp),%eax
  803757:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80375a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80375d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803763:	76 38                	jbe    80379d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803765:	83 ec 0c             	sub    $0xc,%esp
  803768:	ff 75 08             	pushl  0x8(%ebp)
  80376b:	e8 0c fa ff ff       	call   80317c <free_block>
  803770:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803773:	83 ec 0c             	sub    $0xc,%esp
  803776:	ff 75 0c             	pushl  0xc(%ebp)
  803779:	e8 3a eb ff ff       	call   8022b8 <alloc_block_FF>
  80377e:	83 c4 10             	add    $0x10,%esp
  803781:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803784:	83 ec 08             	sub    $0x8,%esp
  803787:	ff 75 c0             	pushl  -0x40(%ebp)
  80378a:	ff 75 08             	pushl  0x8(%ebp)
  80378d:	e8 ab fa ff ff       	call   80323d <copy_data>
  803792:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803795:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803798:	e9 f8 01 00 00       	jmp    803995 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80379d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037a3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037a6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037aa:	0f 87 a0 00 00 00    	ja     803850 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b4:	75 17                	jne    8037cd <realloc_block_FF+0x551>
  8037b6:	83 ec 04             	sub    $0x4,%esp
  8037b9:	68 c7 45 80 00       	push   $0x8045c7
  8037be:	68 38 02 00 00       	push   $0x238
  8037c3:	68 e5 45 80 00       	push   $0x8045e5
  8037c8:	e8 77 02 00 00       	call   803a44 <_panic>
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 10                	je     8037e6 <realloc_block_FF+0x56a>
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037de:	8b 52 04             	mov    0x4(%edx),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	eb 0b                	jmp    8037f1 <realloc_block_FF+0x575>
  8037e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 0f                	je     80380a <realloc_block_FF+0x58e>
  8037fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803804:	8b 12                	mov    (%edx),%edx
  803806:	89 10                	mov    %edx,(%eax)
  803808:	eb 0a                	jmp    803814 <realloc_block_FF+0x598>
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803827:	a1 38 50 80 00       	mov    0x805038,%eax
  80382c:	48                   	dec    %eax
  80382d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803832:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803838:	01 d0                	add    %edx,%eax
  80383a:	83 ec 04             	sub    $0x4,%esp
  80383d:	6a 01                	push   $0x1
  80383f:	50                   	push   %eax
  803840:	ff 75 08             	pushl  0x8(%ebp)
  803843:	e8 41 ea ff ff       	call   802289 <set_block_data>
  803848:	83 c4 10             	add    $0x10,%esp
  80384b:	e9 36 01 00 00       	jmp    803986 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803853:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803856:	01 d0                	add    %edx,%eax
  803858:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	6a 01                	push   $0x1
  803860:	ff 75 f0             	pushl  -0x10(%ebp)
  803863:	ff 75 08             	pushl  0x8(%ebp)
  803866:	e8 1e ea ff ff       	call   802289 <set_block_data>
  80386b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	83 e8 04             	sub    $0x4,%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	83 e0 fe             	and    $0xfffffffe,%eax
  803879:	89 c2                	mov    %eax,%edx
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	01 d0                	add    %edx,%eax
  803880:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803887:	74 06                	je     80388f <realloc_block_FF+0x613>
  803889:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80388d:	75 17                	jne    8038a6 <realloc_block_FF+0x62a>
  80388f:	83 ec 04             	sub    $0x4,%esp
  803892:	68 58 46 80 00       	push   $0x804658
  803897:	68 44 02 00 00       	push   $0x244
  80389c:	68 e5 45 80 00       	push   $0x8045e5
  8038a1:	e8 9e 01 00 00       	call   803a44 <_panic>
  8038a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a9:	8b 10                	mov    (%eax),%edx
  8038ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038ae:	89 10                	mov    %edx,(%eax)
  8038b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	74 0b                	je     8038c4 <realloc_block_FF+0x648>
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038c1:	89 50 04             	mov    %edx,0x4(%eax)
  8038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038ca:	89 10                	mov    %edx,(%eax)
  8038cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d2:	89 50 04             	mov    %edx,0x4(%eax)
  8038d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	75 08                	jne    8038e6 <realloc_block_FF+0x66a>
  8038de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8038eb:	40                   	inc    %eax
  8038ec:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038f5:	75 17                	jne    80390e <realloc_block_FF+0x692>
  8038f7:	83 ec 04             	sub    $0x4,%esp
  8038fa:	68 c7 45 80 00       	push   $0x8045c7
  8038ff:	68 45 02 00 00       	push   $0x245
  803904:	68 e5 45 80 00       	push   $0x8045e5
  803909:	e8 36 01 00 00       	call   803a44 <_panic>
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	74 10                	je     803927 <realloc_block_FF+0x6ab>
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80391f:	8b 52 04             	mov    0x4(%edx),%edx
  803922:	89 50 04             	mov    %edx,0x4(%eax)
  803925:	eb 0b                	jmp    803932 <realloc_block_FF+0x6b6>
  803927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392a:	8b 40 04             	mov    0x4(%eax),%eax
  80392d:	a3 30 50 80 00       	mov    %eax,0x805030
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	8b 40 04             	mov    0x4(%eax),%eax
  803938:	85 c0                	test   %eax,%eax
  80393a:	74 0f                	je     80394b <realloc_block_FF+0x6cf>
  80393c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803945:	8b 12                	mov    (%edx),%edx
  803947:	89 10                	mov    %edx,(%eax)
  803949:	eb 0a                	jmp    803955 <realloc_block_FF+0x6d9>
  80394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803968:	a1 38 50 80 00       	mov    0x805038,%eax
  80396d:	48                   	dec    %eax
  80396e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	6a 00                	push   $0x0
  803978:	ff 75 bc             	pushl  -0x44(%ebp)
  80397b:	ff 75 b8             	pushl  -0x48(%ebp)
  80397e:	e8 06 e9 ff ff       	call   802289 <set_block_data>
  803983:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	eb 0a                	jmp    803995 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80398b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803992:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803995:	c9                   	leave  
  803996:	c3                   	ret    

00803997 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803997:	55                   	push   %ebp
  803998:	89 e5                	mov    %esp,%ebp
  80399a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80399d:	83 ec 04             	sub    $0x4,%esp
  8039a0:	68 dc 46 80 00       	push   $0x8046dc
  8039a5:	68 58 02 00 00       	push   $0x258
  8039aa:	68 e5 45 80 00       	push   $0x8045e5
  8039af:	e8 90 00 00 00       	call   803a44 <_panic>

008039b4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039b4:	55                   	push   %ebp
  8039b5:	89 e5                	mov    %esp,%ebp
  8039b7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	68 04 47 80 00       	push   $0x804704
  8039c2:	68 61 02 00 00       	push   $0x261
  8039c7:	68 e5 45 80 00       	push   $0x8045e5
  8039cc:	e8 73 00 00 00       	call   803a44 <_panic>

008039d1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8039d1:	55                   	push   %ebp
  8039d2:	89 e5                	mov    %esp,%ebp
  8039d4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8039d7:	83 ec 04             	sub    $0x4,%esp
  8039da:	68 2c 47 80 00       	push   $0x80472c
  8039df:	6a 09                	push   $0x9
  8039e1:	68 54 47 80 00       	push   $0x804754
  8039e6:	e8 59 00 00 00       	call   803a44 <_panic>

008039eb <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8039eb:	55                   	push   %ebp
  8039ec:	89 e5                	mov    %esp,%ebp
  8039ee:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8039f1:	83 ec 04             	sub    $0x4,%esp
  8039f4:	68 64 47 80 00       	push   $0x804764
  8039f9:	6a 10                	push   $0x10
  8039fb:	68 54 47 80 00       	push   $0x804754
  803a00:	e8 3f 00 00 00       	call   803a44 <_panic>

00803a05 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803a05:	55                   	push   %ebp
  803a06:	89 e5                	mov    %esp,%ebp
  803a08:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	68 8c 47 80 00       	push   $0x80478c
  803a13:	6a 18                	push   $0x18
  803a15:	68 54 47 80 00       	push   $0x804754
  803a1a:	e8 25 00 00 00       	call   803a44 <_panic>

00803a1f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803a1f:	55                   	push   %ebp
  803a20:	89 e5                	mov    %esp,%ebp
  803a22:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 b4 47 80 00       	push   $0x8047b4
  803a2d:	6a 20                	push   $0x20
  803a2f:	68 54 47 80 00       	push   $0x804754
  803a34:	e8 0b 00 00 00       	call   803a44 <_panic>

00803a39 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803a39:	55                   	push   %ebp
  803a3a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3f:	8b 40 10             	mov    0x10(%eax),%eax
}
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    

00803a44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a44:	55                   	push   %ebp
  803a45:	89 e5                	mov    %esp,%ebp
  803a47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a4a:	8d 45 10             	lea    0x10(%ebp),%eax
  803a4d:	83 c0 04             	add    $0x4,%eax
  803a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a53:	a1 60 50 90 00       	mov    0x905060,%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	74 16                	je     803a72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a5c:	a1 60 50 90 00       	mov    0x905060,%eax
  803a61:	83 ec 08             	sub    $0x8,%esp
  803a64:	50                   	push   %eax
  803a65:	68 dc 47 80 00       	push   $0x8047dc
  803a6a:	e8 3e cc ff ff       	call   8006ad <cprintf>
  803a6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a72:	a1 00 50 80 00       	mov    0x805000,%eax
  803a77:	ff 75 0c             	pushl  0xc(%ebp)
  803a7a:	ff 75 08             	pushl  0x8(%ebp)
  803a7d:	50                   	push   %eax
  803a7e:	68 e1 47 80 00       	push   $0x8047e1
  803a83:	e8 25 cc ff ff       	call   8006ad <cprintf>
  803a88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  803a8e:	83 ec 08             	sub    $0x8,%esp
  803a91:	ff 75 f4             	pushl  -0xc(%ebp)
  803a94:	50                   	push   %eax
  803a95:	e8 a8 cb ff ff       	call   800642 <vcprintf>
  803a9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a9d:	83 ec 08             	sub    $0x8,%esp
  803aa0:	6a 00                	push   $0x0
  803aa2:	68 fd 47 80 00       	push   $0x8047fd
  803aa7:	e8 96 cb ff ff       	call   800642 <vcprintf>
  803aac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803aaf:	e8 17 cb ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803ab4:	eb fe                	jmp    803ab4 <_panic+0x70>

00803ab6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803ab6:	55                   	push   %ebp
  803ab7:	89 e5                	mov    %esp,%ebp
  803ab9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803abc:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aca:	39 c2                	cmp    %eax,%edx
  803acc:	74 14                	je     803ae2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 00 48 80 00       	push   $0x804800
  803ad6:	6a 26                	push   $0x26
  803ad8:	68 4c 48 80 00       	push   $0x80484c
  803add:	e8 62 ff ff ff       	call   803a44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803ae9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803af0:	e9 c5 00 00 00       	jmp    803bba <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803aff:	8b 45 08             	mov    0x8(%ebp),%eax
  803b02:	01 d0                	add    %edx,%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	85 c0                	test   %eax,%eax
  803b08:	75 08                	jne    803b12 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b0a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b0d:	e9 a5 00 00 00       	jmp    803bb7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b20:	eb 69                	jmp    803b8b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b22:	a1 20 50 80 00       	mov    0x805020,%eax
  803b27:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b30:	89 d0                	mov    %edx,%eax
  803b32:	01 c0                	add    %eax,%eax
  803b34:	01 d0                	add    %edx,%eax
  803b36:	c1 e0 03             	shl    $0x3,%eax
  803b39:	01 c8                	add    %ecx,%eax
  803b3b:	8a 40 04             	mov    0x4(%eax),%al
  803b3e:	84 c0                	test   %al,%al
  803b40:	75 46                	jne    803b88 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b42:	a1 20 50 80 00       	mov    0x805020,%eax
  803b47:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b50:	89 d0                	mov    %edx,%eax
  803b52:	01 c0                	add    %eax,%eax
  803b54:	01 d0                	add    %edx,%eax
  803b56:	c1 e0 03             	shl    $0x3,%eax
  803b59:	01 c8                	add    %ecx,%eax
  803b5b:	8b 00                	mov    (%eax),%eax
  803b5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b68:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b6d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	01 c8                	add    %ecx,%eax
  803b79:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b7b:	39 c2                	cmp    %eax,%edx
  803b7d:	75 09                	jne    803b88 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b7f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b86:	eb 15                	jmp    803b9d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b88:	ff 45 e8             	incl   -0x18(%ebp)
  803b8b:	a1 20 50 80 00       	mov    0x805020,%eax
  803b90:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b99:	39 c2                	cmp    %eax,%edx
  803b9b:	77 85                	ja     803b22 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ba1:	75 14                	jne    803bb7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ba3:	83 ec 04             	sub    $0x4,%esp
  803ba6:	68 58 48 80 00       	push   $0x804858
  803bab:	6a 3a                	push   $0x3a
  803bad:	68 4c 48 80 00       	push   $0x80484c
  803bb2:	e8 8d fe ff ff       	call   803a44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803bb7:	ff 45 f0             	incl   -0x10(%ebp)
  803bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bc0:	0f 8c 2f ff ff ff    	jl     803af5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bcd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803bd4:	eb 26                	jmp    803bfc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803bd6:	a1 20 50 80 00       	mov    0x805020,%eax
  803bdb:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803be1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803be4:	89 d0                	mov    %edx,%eax
  803be6:	01 c0                	add    %eax,%eax
  803be8:	01 d0                	add    %edx,%eax
  803bea:	c1 e0 03             	shl    $0x3,%eax
  803bed:	01 c8                	add    %ecx,%eax
  803bef:	8a 40 04             	mov    0x4(%eax),%al
  803bf2:	3c 01                	cmp    $0x1,%al
  803bf4:	75 03                	jne    803bf9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bf6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bf9:	ff 45 e0             	incl   -0x20(%ebp)
  803bfc:	a1 20 50 80 00       	mov    0x805020,%eax
  803c01:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0a:	39 c2                	cmp    %eax,%edx
  803c0c:	77 c8                	ja     803bd6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c11:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c14:	74 14                	je     803c2a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c16:	83 ec 04             	sub    $0x4,%esp
  803c19:	68 ac 48 80 00       	push   $0x8048ac
  803c1e:	6a 44                	push   $0x44
  803c20:	68 4c 48 80 00       	push   $0x80484c
  803c25:	e8 1a fe ff ff       	call   803a44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c2a:	90                   	nop
  803c2b:	c9                   	leave  
  803c2c:	c3                   	ret    
  803c2d:	66 90                	xchg   %ax,%ax
  803c2f:	90                   	nop

00803c30 <__udivdi3>:
  803c30:	55                   	push   %ebp
  803c31:	57                   	push   %edi
  803c32:	56                   	push   %esi
  803c33:	53                   	push   %ebx
  803c34:	83 ec 1c             	sub    $0x1c,%esp
  803c37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c47:	89 ca                	mov    %ecx,%edx
  803c49:	89 f8                	mov    %edi,%eax
  803c4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c4f:	85 f6                	test   %esi,%esi
  803c51:	75 2d                	jne    803c80 <__udivdi3+0x50>
  803c53:	39 cf                	cmp    %ecx,%edi
  803c55:	77 65                	ja     803cbc <__udivdi3+0x8c>
  803c57:	89 fd                	mov    %edi,%ebp
  803c59:	85 ff                	test   %edi,%edi
  803c5b:	75 0b                	jne    803c68 <__udivdi3+0x38>
  803c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c62:	31 d2                	xor    %edx,%edx
  803c64:	f7 f7                	div    %edi
  803c66:	89 c5                	mov    %eax,%ebp
  803c68:	31 d2                	xor    %edx,%edx
  803c6a:	89 c8                	mov    %ecx,%eax
  803c6c:	f7 f5                	div    %ebp
  803c6e:	89 c1                	mov    %eax,%ecx
  803c70:	89 d8                	mov    %ebx,%eax
  803c72:	f7 f5                	div    %ebp
  803c74:	89 cf                	mov    %ecx,%edi
  803c76:	89 fa                	mov    %edi,%edx
  803c78:	83 c4 1c             	add    $0x1c,%esp
  803c7b:	5b                   	pop    %ebx
  803c7c:	5e                   	pop    %esi
  803c7d:	5f                   	pop    %edi
  803c7e:	5d                   	pop    %ebp
  803c7f:	c3                   	ret    
  803c80:	39 ce                	cmp    %ecx,%esi
  803c82:	77 28                	ja     803cac <__udivdi3+0x7c>
  803c84:	0f bd fe             	bsr    %esi,%edi
  803c87:	83 f7 1f             	xor    $0x1f,%edi
  803c8a:	75 40                	jne    803ccc <__udivdi3+0x9c>
  803c8c:	39 ce                	cmp    %ecx,%esi
  803c8e:	72 0a                	jb     803c9a <__udivdi3+0x6a>
  803c90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c94:	0f 87 9e 00 00 00    	ja     803d38 <__udivdi3+0x108>
  803c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c9f:	89 fa                	mov    %edi,%edx
  803ca1:	83 c4 1c             	add    $0x1c,%esp
  803ca4:	5b                   	pop    %ebx
  803ca5:	5e                   	pop    %esi
  803ca6:	5f                   	pop    %edi
  803ca7:	5d                   	pop    %ebp
  803ca8:	c3                   	ret    
  803ca9:	8d 76 00             	lea    0x0(%esi),%esi
  803cac:	31 ff                	xor    %edi,%edi
  803cae:	31 c0                	xor    %eax,%eax
  803cb0:	89 fa                	mov    %edi,%edx
  803cb2:	83 c4 1c             	add    $0x1c,%esp
  803cb5:	5b                   	pop    %ebx
  803cb6:	5e                   	pop    %esi
  803cb7:	5f                   	pop    %edi
  803cb8:	5d                   	pop    %ebp
  803cb9:	c3                   	ret    
  803cba:	66 90                	xchg   %ax,%ax
  803cbc:	89 d8                	mov    %ebx,%eax
  803cbe:	f7 f7                	div    %edi
  803cc0:	31 ff                	xor    %edi,%edi
  803cc2:	89 fa                	mov    %edi,%edx
  803cc4:	83 c4 1c             	add    $0x1c,%esp
  803cc7:	5b                   	pop    %ebx
  803cc8:	5e                   	pop    %esi
  803cc9:	5f                   	pop    %edi
  803cca:	5d                   	pop    %ebp
  803ccb:	c3                   	ret    
  803ccc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cd1:	89 eb                	mov    %ebp,%ebx
  803cd3:	29 fb                	sub    %edi,%ebx
  803cd5:	89 f9                	mov    %edi,%ecx
  803cd7:	d3 e6                	shl    %cl,%esi
  803cd9:	89 c5                	mov    %eax,%ebp
  803cdb:	88 d9                	mov    %bl,%cl
  803cdd:	d3 ed                	shr    %cl,%ebp
  803cdf:	89 e9                	mov    %ebp,%ecx
  803ce1:	09 f1                	or     %esi,%ecx
  803ce3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ce7:	89 f9                	mov    %edi,%ecx
  803ce9:	d3 e0                	shl    %cl,%eax
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 d6                	mov    %edx,%esi
  803cef:	88 d9                	mov    %bl,%cl
  803cf1:	d3 ee                	shr    %cl,%esi
  803cf3:	89 f9                	mov    %edi,%ecx
  803cf5:	d3 e2                	shl    %cl,%edx
  803cf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cfb:	88 d9                	mov    %bl,%cl
  803cfd:	d3 e8                	shr    %cl,%eax
  803cff:	09 c2                	or     %eax,%edx
  803d01:	89 d0                	mov    %edx,%eax
  803d03:	89 f2                	mov    %esi,%edx
  803d05:	f7 74 24 0c          	divl   0xc(%esp)
  803d09:	89 d6                	mov    %edx,%esi
  803d0b:	89 c3                	mov    %eax,%ebx
  803d0d:	f7 e5                	mul    %ebp
  803d0f:	39 d6                	cmp    %edx,%esi
  803d11:	72 19                	jb     803d2c <__udivdi3+0xfc>
  803d13:	74 0b                	je     803d20 <__udivdi3+0xf0>
  803d15:	89 d8                	mov    %ebx,%eax
  803d17:	31 ff                	xor    %edi,%edi
  803d19:	e9 58 ff ff ff       	jmp    803c76 <__udivdi3+0x46>
  803d1e:	66 90                	xchg   %ax,%ax
  803d20:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d24:	89 f9                	mov    %edi,%ecx
  803d26:	d3 e2                	shl    %cl,%edx
  803d28:	39 c2                	cmp    %eax,%edx
  803d2a:	73 e9                	jae    803d15 <__udivdi3+0xe5>
  803d2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d2f:	31 ff                	xor    %edi,%edi
  803d31:	e9 40 ff ff ff       	jmp    803c76 <__udivdi3+0x46>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	31 c0                	xor    %eax,%eax
  803d3a:	e9 37 ff ff ff       	jmp    803c76 <__udivdi3+0x46>
  803d3f:	90                   	nop

00803d40 <__umoddi3>:
  803d40:	55                   	push   %ebp
  803d41:	57                   	push   %edi
  803d42:	56                   	push   %esi
  803d43:	53                   	push   %ebx
  803d44:	83 ec 1c             	sub    $0x1c,%esp
  803d47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d5f:	89 f3                	mov    %esi,%ebx
  803d61:	89 fa                	mov    %edi,%edx
  803d63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d67:	89 34 24             	mov    %esi,(%esp)
  803d6a:	85 c0                	test   %eax,%eax
  803d6c:	75 1a                	jne    803d88 <__umoddi3+0x48>
  803d6e:	39 f7                	cmp    %esi,%edi
  803d70:	0f 86 a2 00 00 00    	jbe    803e18 <__umoddi3+0xd8>
  803d76:	89 c8                	mov    %ecx,%eax
  803d78:	89 f2                	mov    %esi,%edx
  803d7a:	f7 f7                	div    %edi
  803d7c:	89 d0                	mov    %edx,%eax
  803d7e:	31 d2                	xor    %edx,%edx
  803d80:	83 c4 1c             	add    $0x1c,%esp
  803d83:	5b                   	pop    %ebx
  803d84:	5e                   	pop    %esi
  803d85:	5f                   	pop    %edi
  803d86:	5d                   	pop    %ebp
  803d87:	c3                   	ret    
  803d88:	39 f0                	cmp    %esi,%eax
  803d8a:	0f 87 ac 00 00 00    	ja     803e3c <__umoddi3+0xfc>
  803d90:	0f bd e8             	bsr    %eax,%ebp
  803d93:	83 f5 1f             	xor    $0x1f,%ebp
  803d96:	0f 84 ac 00 00 00    	je     803e48 <__umoddi3+0x108>
  803d9c:	bf 20 00 00 00       	mov    $0x20,%edi
  803da1:	29 ef                	sub    %ebp,%edi
  803da3:	89 fe                	mov    %edi,%esi
  803da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803da9:	89 e9                	mov    %ebp,%ecx
  803dab:	d3 e0                	shl    %cl,%eax
  803dad:	89 d7                	mov    %edx,%edi
  803daf:	89 f1                	mov    %esi,%ecx
  803db1:	d3 ef                	shr    %cl,%edi
  803db3:	09 c7                	or     %eax,%edi
  803db5:	89 e9                	mov    %ebp,%ecx
  803db7:	d3 e2                	shl    %cl,%edx
  803db9:	89 14 24             	mov    %edx,(%esp)
  803dbc:	89 d8                	mov    %ebx,%eax
  803dbe:	d3 e0                	shl    %cl,%eax
  803dc0:	89 c2                	mov    %eax,%edx
  803dc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dc6:	d3 e0                	shl    %cl,%eax
  803dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dd0:	89 f1                	mov    %esi,%ecx
  803dd2:	d3 e8                	shr    %cl,%eax
  803dd4:	09 d0                	or     %edx,%eax
  803dd6:	d3 eb                	shr    %cl,%ebx
  803dd8:	89 da                	mov    %ebx,%edx
  803dda:	f7 f7                	div    %edi
  803ddc:	89 d3                	mov    %edx,%ebx
  803dde:	f7 24 24             	mull   (%esp)
  803de1:	89 c6                	mov    %eax,%esi
  803de3:	89 d1                	mov    %edx,%ecx
  803de5:	39 d3                	cmp    %edx,%ebx
  803de7:	0f 82 87 00 00 00    	jb     803e74 <__umoddi3+0x134>
  803ded:	0f 84 91 00 00 00    	je     803e84 <__umoddi3+0x144>
  803df3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803df7:	29 f2                	sub    %esi,%edx
  803df9:	19 cb                	sbb    %ecx,%ebx
  803dfb:	89 d8                	mov    %ebx,%eax
  803dfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e01:	d3 e0                	shl    %cl,%eax
  803e03:	89 e9                	mov    %ebp,%ecx
  803e05:	d3 ea                	shr    %cl,%edx
  803e07:	09 d0                	or     %edx,%eax
  803e09:	89 e9                	mov    %ebp,%ecx
  803e0b:	d3 eb                	shr    %cl,%ebx
  803e0d:	89 da                	mov    %ebx,%edx
  803e0f:	83 c4 1c             	add    $0x1c,%esp
  803e12:	5b                   	pop    %ebx
  803e13:	5e                   	pop    %esi
  803e14:	5f                   	pop    %edi
  803e15:	5d                   	pop    %ebp
  803e16:	c3                   	ret    
  803e17:	90                   	nop
  803e18:	89 fd                	mov    %edi,%ebp
  803e1a:	85 ff                	test   %edi,%edi
  803e1c:	75 0b                	jne    803e29 <__umoddi3+0xe9>
  803e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e23:	31 d2                	xor    %edx,%edx
  803e25:	f7 f7                	div    %edi
  803e27:	89 c5                	mov    %eax,%ebp
  803e29:	89 f0                	mov    %esi,%eax
  803e2b:	31 d2                	xor    %edx,%edx
  803e2d:	f7 f5                	div    %ebp
  803e2f:	89 c8                	mov    %ecx,%eax
  803e31:	f7 f5                	div    %ebp
  803e33:	89 d0                	mov    %edx,%eax
  803e35:	e9 44 ff ff ff       	jmp    803d7e <__umoddi3+0x3e>
  803e3a:	66 90                	xchg   %ax,%ax
  803e3c:	89 c8                	mov    %ecx,%eax
  803e3e:	89 f2                	mov    %esi,%edx
  803e40:	83 c4 1c             	add    $0x1c,%esp
  803e43:	5b                   	pop    %ebx
  803e44:	5e                   	pop    %esi
  803e45:	5f                   	pop    %edi
  803e46:	5d                   	pop    %ebp
  803e47:	c3                   	ret    
  803e48:	3b 04 24             	cmp    (%esp),%eax
  803e4b:	72 06                	jb     803e53 <__umoddi3+0x113>
  803e4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e51:	77 0f                	ja     803e62 <__umoddi3+0x122>
  803e53:	89 f2                	mov    %esi,%edx
  803e55:	29 f9                	sub    %edi,%ecx
  803e57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e5b:	89 14 24             	mov    %edx,(%esp)
  803e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e62:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e66:	8b 14 24             	mov    (%esp),%edx
  803e69:	83 c4 1c             	add    $0x1c,%esp
  803e6c:	5b                   	pop    %ebx
  803e6d:	5e                   	pop    %esi
  803e6e:	5f                   	pop    %edi
  803e6f:	5d                   	pop    %ebp
  803e70:	c3                   	ret    
  803e71:	8d 76 00             	lea    0x0(%esi),%esi
  803e74:	2b 04 24             	sub    (%esp),%eax
  803e77:	19 fa                	sbb    %edi,%edx
  803e79:	89 d1                	mov    %edx,%ecx
  803e7b:	89 c6                	mov    %eax,%esi
  803e7d:	e9 71 ff ff ff       	jmp    803df3 <__umoddi3+0xb3>
  803e82:	66 90                	xchg   %ax,%ax
  803e84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e88:	72 ea                	jb     803e74 <__umoddi3+0x134>
  803e8a:	89 d9                	mov    %ebx,%ecx
  803e8c:	e9 62 ff ff ff       	jmp    803df3 <__umoddi3+0xb3>

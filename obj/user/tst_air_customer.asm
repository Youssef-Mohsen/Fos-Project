
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
  800044:	e8 22 18 00 00       	call   80186b <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb a9 20 80 00       	mov    $0x8020a9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb b3 20 80 00       	mov    $0x8020b3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb bf 20 80 00       	mov    $0x8020bf,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ce 20 80 00       	mov    $0x8020ce,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb dd 20 80 00       	mov    $0x8020dd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb f2 20 80 00       	mov    $0x8020f2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 07 21 80 00       	mov    $0x802107,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 18 21 80 00       	mov    $0x802118,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 29 21 80 00       	mov    $0x802129,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 3a 21 80 00       	mov    $0x80213a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 43 21 80 00       	mov    $0x802143,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 4d 21 80 00       	mov    $0x80214d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 58 21 80 00       	mov    $0x802158,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 64 21 80 00       	mov    $0x802164,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 6e 21 80 00       	mov    $0x80216e,%ebx
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
  8001be:	bb 78 21 80 00       	mov    $0x802178,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 86 21 80 00       	mov    $0x802186,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 95 21 80 00       	mov    $0x802195,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 9c 21 80 00       	mov    $0x80219c,%ebx
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
  800222:	e8 a0 12 00 00       	call   8014c7 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 8b 12 00 00       	call   8014c7 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 73 12 00 00       	call   8014c7 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 5b 12 00 00       	call   8014c7 <sget>
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
  800286:	e8 21 19 00 00       	call   801bac <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 05 19 00 00       	call   801bac <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 e9 18 00 00       	call   801bac <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 cd 18 00 00       	call   801bac <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 b1 18 00 00       	call   801bac <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 ba 18 00 00       	call   801bc6 <wait_semaphore>
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
  80032d:	e8 ae 18 00 00       	call   801be0 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 83 18 00 00       	call   801bc6 <wait_semaphore>
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
  800363:	e8 5e 18 00 00       	call   801bc6 <wait_semaphore>
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
  800397:	e8 44 18 00 00       	call   801be0 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 33 18 00 00       	call   801be0 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb a3 21 80 00       	mov    $0x8021a3,%ebx
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
  8003e9:	e8 f1 0d 00 00       	call   8011df <ltostr>
  8003ee:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	e8 aa 0e 00 00       	call   8012b8 <strcconcat>
  80040e:	83 c4 10             	add    $0x10,%esp
	//sys_waitSemaphore(parentenvID, sname);
	struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  800411:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	8d 95 63 fe ff ff    	lea    -0x19d(%ebp),%edx
  800420:	52                   	push   %edx
  800421:	ff 75 e4             	pushl  -0x1c(%ebp)
  800424:	50                   	push   %eax
  800425:	e8 82 17 00 00       	call   801bac <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 8b 17 00 00       	call   801bc6 <wait_semaphore>
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
  80045e:	68 60 20 80 00       	push   $0x802060
  800463:	e8 6a 02 00 00       	call   8006d2 <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 88 20 80 00       	push   $0x802088
  800478:	e8 55 02 00 00       	call   8006d2 <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 52 17 00 00       	call   801be0 <signal_semaphore>
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
  8004a0:	e8 ad 13 00 00       	call   801852 <sys_getenvindex>
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8004a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ab:	89 d0                	mov    %edx,%eax
  8004ad:	c1 e0 02             	shl    $0x2,%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	01 c0                	add    %eax,%eax
  8004b4:	01 d0                	add    %edx,%eax
  8004b6:	c1 e0 02             	shl    $0x2,%eax
  8004b9:	01 d0                	add    %edx,%eax
  8004bb:	01 c0                	add    %eax,%eax
  8004bd:	01 d0                	add    %edx,%eax
  8004bf:	c1 e0 04             	shl    $0x4,%eax
  8004c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004c7:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d1:	8a 40 20             	mov    0x20(%eax),%al
  8004d4:	84 c0                	test   %al,%al
  8004d6:	74 0d                	je     8004e5 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8004d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004dd:	83 c0 20             	add    $0x20,%eax
  8004e0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004e9:	7e 0a                	jle    8004f5 <libmain+0x5b>
		binaryname = argv[0];
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 35 fb ff ff       	call   800038 <_main>
  800503:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800506:	e8 cb 10 00 00       	call   8015d6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 dc 21 80 00       	push   $0x8021dc
  800513:	e8 8d 01 00 00       	call   8006a5 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80051b:	a1 04 30 80 00       	mov    0x803004,%eax
  800520:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800526:	a1 04 30 80 00       	mov    0x803004,%eax
  80052b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800531:	83 ec 04             	sub    $0x4,%esp
  800534:	52                   	push   %edx
  800535:	50                   	push   %eax
  800536:	68 04 22 80 00       	push   $0x802204
  80053b:	e8 65 01 00 00       	call   8006a5 <cprintf>
  800540:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800543:	a1 04 30 80 00       	mov    0x803004,%eax
  800548:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80054e:	a1 04 30 80 00       	mov    0x803004,%eax
  800553:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800559:	a1 04 30 80 00       	mov    0x803004,%eax
  80055e:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800564:	51                   	push   %ecx
  800565:	52                   	push   %edx
  800566:	50                   	push   %eax
  800567:	68 2c 22 80 00       	push   $0x80222c
  80056c:	e8 34 01 00 00       	call   8006a5 <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800574:	a1 04 30 80 00       	mov    0x803004,%eax
  800579:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	50                   	push   %eax
  800583:	68 84 22 80 00       	push   $0x802284
  800588:	e8 18 01 00 00       	call   8006a5 <cprintf>
  80058d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	68 dc 21 80 00       	push   $0x8021dc
  800598:	e8 08 01 00 00       	call   8006a5 <cprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a0:	e8 4b 10 00 00       	call   8015f0 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8005a5:	e8 19 00 00 00       	call   8005c3 <exit>
}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005b3:	83 ec 0c             	sub    $0xc,%esp
  8005b6:	6a 00                	push   $0x0
  8005b8:	e8 61 12 00 00       	call   80181e <sys_destroy_env>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <exit>:

void
exit(void)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005c9:	e8 b6 12 00 00       	call   801884 <sys_exit_env>
}
  8005ce:	90                   	nop
  8005cf:	c9                   	leave  
  8005d0:	c3                   	ret    

008005d1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005d1:	55                   	push   %ebp
  8005d2:	89 e5                	mov    %esp,%ebp
  8005d4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8005df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e2:	89 0a                	mov    %ecx,(%edx)
  8005e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e7:	88 d1                	mov    %dl,%cl
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fa:	75 2c                	jne    800628 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005fc:	a0 08 30 80 00       	mov    0x803008,%al
  800601:	0f b6 c0             	movzbl %al,%eax
  800604:	8b 55 0c             	mov    0xc(%ebp),%edx
  800607:	8b 12                	mov    (%edx),%edx
  800609:	89 d1                	mov    %edx,%ecx
  80060b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060e:	83 c2 08             	add    $0x8,%edx
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	50                   	push   %eax
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	e8 78 0f 00 00       	call   801594 <sys_cputs>
  80061c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	8b 40 04             	mov    0x4(%eax),%eax
  80062e:	8d 50 01             	lea    0x1(%eax),%edx
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	89 50 04             	mov    %edx,0x4(%eax)
}
  800637:	90                   	nop
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
  80063d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800643:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064a:	00 00 00 
	b.cnt = 0;
  80064d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800654:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 08             	pushl  0x8(%ebp)
  80065d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800663:	50                   	push   %eax
  800664:	68 d1 05 80 00       	push   $0x8005d1
  800669:	e8 11 02 00 00       	call   80087f <vprintfmt>
  80066e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800671:	a0 08 30 80 00       	mov    0x803008,%al
  800676:	0f b6 c0             	movzbl %al,%eax
  800679:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	50                   	push   %eax
  800683:	52                   	push   %edx
  800684:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068a:	83 c0 08             	add    $0x8,%eax
  80068d:	50                   	push   %eax
  80068e:	e8 01 0f 00 00       	call   801594 <sys_cputs>
  800693:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800696:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80069d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ab:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	e8 73 ff ff ff       	call   80063a <vcprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006d8:	e8 f9 0e 00 00       	call   8015d6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	e8 48 ff ff ff       	call   80063a <vcprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006f8:	e8 f3 0e 00 00       	call   8015f0 <sys_unlock_cons>
	return cnt;
  8006fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	53                   	push   %ebx
  800706:	83 ec 14             	sub    $0x14,%esp
  800709:	8b 45 10             	mov    0x10(%ebp),%eax
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800715:	8b 45 18             	mov    0x18(%ebp),%eax
  800718:	ba 00 00 00 00       	mov    $0x0,%edx
  80071d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800720:	77 55                	ja     800777 <printnum+0x75>
  800722:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800725:	72 05                	jb     80072c <printnum+0x2a>
  800727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072a:	77 4b                	ja     800777 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80072f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800732:	8b 45 18             	mov    0x18(%ebp),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	52                   	push   %edx
  80073b:	50                   	push   %eax
  80073c:	ff 75 f4             	pushl  -0xc(%ebp)
  80073f:	ff 75 f0             	pushl  -0x10(%ebp)
  800742:	e8 a9 16 00 00       	call   801df0 <__udivdi3>
  800747:	83 c4 10             	add    $0x10,%esp
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	ff 75 20             	pushl  0x20(%ebp)
  800750:	53                   	push   %ebx
  800751:	ff 75 18             	pushl  0x18(%ebp)
  800754:	52                   	push   %edx
  800755:	50                   	push   %eax
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	ff 75 08             	pushl  0x8(%ebp)
  80075c:	e8 a1 ff ff ff       	call   800702 <printnum>
  800761:	83 c4 20             	add    $0x20,%esp
  800764:	eb 1a                	jmp    800780 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	ff 75 20             	pushl  0x20(%ebp)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800777:	ff 4d 1c             	decl   0x1c(%ebp)
  80077a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80077e:	7f e6                	jg     800766 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800780:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800783:	bb 00 00 00 00       	mov    $0x0,%ebx
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078e:	53                   	push   %ebx
  80078f:	51                   	push   %ecx
  800790:	52                   	push   %edx
  800791:	50                   	push   %eax
  800792:	e8 69 17 00 00       	call   801f00 <__umoddi3>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	05 b4 24 80 00       	add    $0x8024b4,%eax
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f be c0             	movsbl %al,%eax
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
}
  8007b3:	90                   	nop
  8007b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c0:	7e 1c                	jle    8007de <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 08             	lea    0x8(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 08             	sub    $0x8,%eax
  8007d7:	8b 50 04             	mov    0x4(%eax),%edx
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	eb 40                	jmp    80081e <getuint+0x65>
	else if (lflag)
  8007de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e2:	74 1e                	je     800802 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	8d 50 04             	lea    0x4(%eax),%edx
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 10                	mov    %edx,(%eax)
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	83 e8 04             	sub    $0x4,%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	eb 1c                	jmp    80081e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	8d 50 04             	lea    0x4(%eax),%edx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	89 10                	mov    %edx,(%eax)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	83 e8 04             	sub    $0x4,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800823:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800827:	7e 1c                	jle    800845 <getint+0x25>
		return va_arg(*ap, long long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 08             	lea    0x8(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 08             	sub    $0x8,%eax
  80083e:	8b 50 04             	mov    0x4(%eax),%edx
  800841:	8b 00                	mov    (%eax),%eax
  800843:	eb 38                	jmp    80087d <getint+0x5d>
	else if (lflag)
  800845:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800849:	74 1a                	je     800865 <getint+0x45>
		return va_arg(*ap, long);
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	8d 50 04             	lea    0x4(%eax),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	89 10                	mov    %edx,(%eax)
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	99                   	cltd   
  800863:	eb 18                	jmp    80087d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	8d 50 04             	lea    0x4(%eax),%edx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	89 10                	mov    %edx,(%eax)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	99                   	cltd   
}
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800887:	eb 17                	jmp    8008a0 <vprintfmt+0x21>
			if (ch == '\0')
  800889:	85 db                	test   %ebx,%ebx
  80088b:	0f 84 c1 03 00 00    	je     800c52 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	53                   	push   %ebx
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a3:	8d 50 01             	lea    0x1(%eax),%edx
  8008a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a9:	8a 00                	mov    (%eax),%al
  8008ab:	0f b6 d8             	movzbl %al,%ebx
  8008ae:	83 fb 25             	cmp    $0x25,%ebx
  8008b1:	75 d6                	jne    800889 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	8d 50 01             	lea    0x1(%eax),%edx
  8008d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008dc:	8a 00                	mov    (%eax),%al
  8008de:	0f b6 d8             	movzbl %al,%ebx
  8008e1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e4:	83 f8 5b             	cmp    $0x5b,%eax
  8008e7:	0f 87 3d 03 00 00    	ja     800c2a <vprintfmt+0x3ab>
  8008ed:	8b 04 85 d8 24 80 00 	mov    0x8024d8(,%eax,4),%eax
  8008f4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fa:	eb d7                	jmp    8008d3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800900:	eb d1                	jmp    8008d3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800902:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090c:	89 d0                	mov    %edx,%eax
  80090e:	c1 e0 02             	shl    $0x2,%eax
  800911:	01 d0                	add    %edx,%eax
  800913:	01 c0                	add    %eax,%eax
  800915:	01 d8                	add    %ebx,%eax
  800917:	83 e8 30             	sub    $0x30,%eax
  80091a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	8a 00                	mov    (%eax),%al
  800922:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800925:	83 fb 2f             	cmp    $0x2f,%ebx
  800928:	7e 3e                	jle    800968 <vprintfmt+0xe9>
  80092a:	83 fb 39             	cmp    $0x39,%ebx
  80092d:	7f 39                	jg     800968 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800932:	eb d5                	jmp    800909 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 c0 04             	add    $0x4,%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 e8 04             	sub    $0x4,%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800948:	eb 1f                	jmp    800969 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	79 83                	jns    8008d3 <vprintfmt+0x54>
				width = 0;
  800950:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800957:	e9 77 ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800963:	e9 6b ff ff ff       	jmp    8008d3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800968:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	0f 89 60 ff ff ff    	jns    8008d3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800979:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800980:	e9 4e ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800985:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800988:	e9 46 ff ff ff       	jmp    8008d3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 c0 04             	add    $0x4,%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 e8 04             	sub    $0x4,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	50                   	push   %eax
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	ff d0                	call   *%eax
  8009aa:	83 c4 10             	add    $0x10,%esp
			break;
  8009ad:	e9 9b 02 00 00       	jmp    800c4d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	83 c0 04             	add    $0x4,%eax
  8009b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	83 e8 04             	sub    $0x4,%eax
  8009c1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c3:	85 db                	test   %ebx,%ebx
  8009c5:	79 02                	jns    8009c9 <vprintfmt+0x14a>
				err = -err;
  8009c7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c9:	83 fb 64             	cmp    $0x64,%ebx
  8009cc:	7f 0b                	jg     8009d9 <vprintfmt+0x15a>
  8009ce:	8b 34 9d 20 23 80 00 	mov    0x802320(,%ebx,4),%esi
  8009d5:	85 f6                	test   %esi,%esi
  8009d7:	75 19                	jne    8009f2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d9:	53                   	push   %ebx
  8009da:	68 c5 24 80 00       	push   $0x8024c5
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 70 02 00 00       	call   800c5a <printfmt>
  8009ea:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ed:	e9 5b 02 00 00       	jmp    800c4d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f2:	56                   	push   %esi
  8009f3:	68 ce 24 80 00       	push   $0x8024ce
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 57 02 00 00       	call   800c5a <printfmt>
  800a03:	83 c4 10             	add    $0x10,%esp
			break;
  800a06:	e9 42 02 00 00       	jmp    800c4d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	83 c0 04             	add    $0x4,%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 e8 04             	sub    $0x4,%eax
  800a1a:	8b 30                	mov    (%eax),%esi
  800a1c:	85 f6                	test   %esi,%esi
  800a1e:	75 05                	jne    800a25 <vprintfmt+0x1a6>
				p = "(null)";
  800a20:	be d1 24 80 00       	mov    $0x8024d1,%esi
			if (width > 0 && padc != '-')
  800a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a29:	7e 6d                	jle    800a98 <vprintfmt+0x219>
  800a2b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a2f:	74 67                	je     800a98 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	50                   	push   %eax
  800a38:	56                   	push   %esi
  800a39:	e8 1e 03 00 00       	call   800d5c <strnlen>
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a44:	eb 16                	jmp    800a5c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a46:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	ff d0                	call   *%eax
  800a56:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a59:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a60:	7f e4                	jg     800a46 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a62:	eb 34                	jmp    800a98 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a64:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a68:	74 1c                	je     800a86 <vprintfmt+0x207>
  800a6a:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6d:	7e 05                	jle    800a74 <vprintfmt+0x1f5>
  800a6f:	83 fb 7e             	cmp    $0x7e,%ebx
  800a72:	7e 12                	jle    800a86 <vprintfmt+0x207>
					putch('?', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 3f                	push   $0x3f
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	eb 0f                	jmp    800a95 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	53                   	push   %ebx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a95:	ff 4d e4             	decl   -0x1c(%ebp)
  800a98:	89 f0                	mov    %esi,%eax
  800a9a:	8d 70 01             	lea    0x1(%eax),%esi
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	0f be d8             	movsbl %al,%ebx
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	74 24                	je     800aca <vprintfmt+0x24b>
  800aa6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aaa:	78 b8                	js     800a64 <vprintfmt+0x1e5>
  800aac:	ff 4d e0             	decl   -0x20(%ebp)
  800aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab3:	79 af                	jns    800a64 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab5:	eb 13                	jmp    800aca <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 20                	push   $0x20
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac7:	ff 4d e4             	decl   -0x1c(%ebp)
  800aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ace:	7f e7                	jg     800ab7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad0:	e9 78 01 00 00       	jmp    800c4d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 e8             	pushl  -0x18(%ebp)
  800adb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ade:	50                   	push   %eax
  800adf:	e8 3c fd ff ff       	call   800820 <getint>
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af3:	85 d2                	test   %edx,%edx
  800af5:	79 23                	jns    800b1a <vprintfmt+0x29b>
				putch('-', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 2d                	push   $0x2d
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0d:	f7 d8                	neg    %eax
  800b0f:	83 d2 00             	adc    $0x0,%edx
  800b12:	f7 da                	neg    %edx
  800b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b21:	e9 bc 00 00 00       	jmp    800be2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b2f:	50                   	push   %eax
  800b30:	e8 84 fc ff ff       	call   8007b9 <getuint>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b45:	e9 98 00 00 00       	jmp    800be2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4a:	83 ec 08             	sub    $0x8,%esp
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	6a 58                	push   $0x58
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	6a 58                	push   $0x58
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	6a 58                	push   $0x58
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			break;
  800b7a:	e9 ce 00 00 00       	jmp    800c4d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	6a 30                	push   $0x30
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 78                	push   $0x78
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bab:	83 e8 04             	sub    $0x4,%eax
  800bae:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bba:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc1:	eb 1f                	jmp    800be2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcc:	50                   	push   %eax
  800bcd:	e8 e7 fb ff ff       	call   8007b9 <getuint>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bdb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be9:	83 ec 04             	sub    $0x4,%esp
  800bec:	52                   	push   %edx
  800bed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 08             	pushl  0x8(%ebp)
  800bfd:	e8 00 fb ff ff       	call   800702 <printnum>
  800c02:	83 c4 20             	add    $0x20,%esp
			break;
  800c05:	eb 46                	jmp    800c4d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			break;
  800c16:	eb 35                	jmp    800c4d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c18:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c1f:	eb 2c                	jmp    800c4d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c21:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c28:	eb 23                	jmp    800c4d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 25                	push   $0x25
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3a:	ff 4d 10             	decl   0x10(%ebp)
  800c3d:	eb 03                	jmp    800c42 <vprintfmt+0x3c3>
  800c3f:	ff 4d 10             	decl   0x10(%ebp)
  800c42:	8b 45 10             	mov    0x10(%ebp),%eax
  800c45:	48                   	dec    %eax
  800c46:	8a 00                	mov    (%eax),%al
  800c48:	3c 25                	cmp    $0x25,%al
  800c4a:	75 f3                	jne    800c3f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c4c:	90                   	nop
		}
	}
  800c4d:	e9 35 fc ff ff       	jmp    800887 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c52:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c60:	8d 45 10             	lea    0x10(%ebp),%eax
  800c63:	83 c0 04             	add    $0x4,%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	50                   	push   %eax
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	ff 75 08             	pushl  0x8(%ebp)
  800c76:	e8 04 fc ff ff       	call   80087f <vprintfmt>
  800c7b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c7e:	90                   	nop
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 40 08             	mov    0x8(%eax),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 10                	mov    (%eax),%edx
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8b 40 04             	mov    0x4(%eax),%eax
  800c9e:	39 c2                	cmp    %eax,%edx
  800ca0:	73 12                	jae    800cb4 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	8d 48 01             	lea    0x1(%eax),%ecx
  800caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cad:	89 0a                	mov    %ecx,(%edx)
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	88 10                	mov    %dl,(%eax)
}
  800cb4:	90                   	nop
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cdc:	74 06                	je     800ce4 <vsnprintf+0x2d>
  800cde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce2:	7f 07                	jg     800ceb <vsnprintf+0x34>
		return -E_INVAL;
  800ce4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce9:	eb 20                	jmp    800d0b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ceb:	ff 75 14             	pushl  0x14(%ebp)
  800cee:	ff 75 10             	pushl  0x10(%ebp)
  800cf1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf4:	50                   	push   %eax
  800cf5:	68 81 0c 80 00       	push   $0x800c81
  800cfa:	e8 80 fb ff ff       	call   80087f <vprintfmt>
  800cff:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d05:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d0b:	c9                   	leave  
  800d0c:	c3                   	ret    

00800d0d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d13:	8d 45 10             	lea    0x10(%ebp),%eax
  800d16:	83 c0 04             	add    $0x4,%eax
  800d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	ff 75 08             	pushl  0x8(%ebp)
  800d29:	e8 89 ff ff ff       	call   800cb7 <vsnprintf>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d46:	eb 06                	jmp    800d4e <strlen+0x15>
		n++;
  800d48:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	75 f1                	jne    800d48 <strlen+0xf>
		n++;
	return n;
  800d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5a:	c9                   	leave  
  800d5b:	c3                   	ret    

00800d5c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d69:	eb 09                	jmp    800d74 <strnlen+0x18>
		n++;
  800d6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6e:	ff 45 08             	incl   0x8(%ebp)
  800d71:	ff 4d 0c             	decl   0xc(%ebp)
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	74 09                	je     800d83 <strnlen+0x27>
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	84 c0                	test   %al,%al
  800d81:	75 e8                	jne    800d6b <strnlen+0xf>
		n++;
	return n;
  800d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d94:	90                   	nop
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8d 50 01             	lea    0x1(%eax),%edx
  800d9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da7:	8a 12                	mov    (%edx),%dl
  800da9:	88 10                	mov    %dl,(%eax)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	84 c0                	test   %al,%al
  800daf:	75 e4                	jne    800d95 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc9:	eb 1f                	jmp    800dea <strncpy+0x34>
		*dst++ = *src;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8d 50 01             	lea    0x1(%eax),%edx
  800dd1:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd7:	8a 12                	mov    (%edx),%dl
  800dd9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	84 c0                	test   %al,%al
  800de2:	74 03                	je     800de7 <strncpy+0x31>
			src++;
  800de4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de7:	ff 45 fc             	incl   -0x4(%ebp)
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df0:	72 d9                	jb     800dcb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e07:	74 30                	je     800e39 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e09:	eb 16                	jmp    800e21 <strlcpy+0x2a>
			*dst++ = *src++;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8d 50 01             	lea    0x1(%eax),%edx
  800e11:	89 55 08             	mov    %edx,0x8(%ebp)
  800e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1d:	8a 12                	mov    (%edx),%dl
  800e1f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e21:	ff 4d 10             	decl   0x10(%ebp)
  800e24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e28:	74 09                	je     800e33 <strlcpy+0x3c>
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 d8                	jne    800e0b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	29 c2                	sub    %eax,%edx
  800e41:	89 d0                	mov    %edx,%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e48:	eb 06                	jmp    800e50 <strcmp+0xb>
		p++, q++;
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	84 c0                	test   %al,%al
  800e57:	74 0e                	je     800e67 <strcmp+0x22>
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 10                	mov    (%eax),%dl
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	38 c2                	cmp    %al,%dl
  800e65:	74 e3                	je     800e4a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	0f b6 d0             	movzbl %al,%edx
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	0f b6 c0             	movzbl %al,%eax
  800e77:	29 c2                	sub    %eax,%edx
  800e79:	89 d0                	mov    %edx,%eax
}
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e80:	eb 09                	jmp    800e8b <strncmp+0xe>
		n--, p++, q++;
  800e82:	ff 4d 10             	decl   0x10(%ebp)
  800e85:	ff 45 08             	incl   0x8(%ebp)
  800e88:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8f:	74 17                	je     800ea8 <strncmp+0x2b>
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	74 0e                	je     800ea8 <strncmp+0x2b>
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 10                	mov    (%eax),%dl
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	38 c2                	cmp    %al,%dl
  800ea6:	74 da                	je     800e82 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eac:	75 07                	jne    800eb5 <strncmp+0x38>
		return 0;
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb3:	eb 14                	jmp    800ec9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 d0             	movzbl %al,%edx
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 c0             	movzbl %al,%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed7:	eb 12                	jmp    800eeb <strchr+0x20>
		if (*s == c)
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee1:	75 05                	jne    800ee8 <strchr+0x1d>
			return (char *) s;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	eb 11                	jmp    800ef9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 e5                	jne    800ed9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f07:	eb 0d                	jmp    800f16 <strfind+0x1b>
		if (*s == c)
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f11:	74 0e                	je     800f21 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	84 c0                	test   %al,%al
  800f1d:	75 ea                	jne    800f09 <strfind+0xe>
  800f1f:	eb 01                	jmp    800f22 <strfind+0x27>
		if (*s == c)
			break;
  800f21:	90                   	nop
	return (char *) s;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f39:	eb 0e                	jmp    800f49 <memset+0x22>
		*p++ = c;
  800f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f47:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f49:	ff 4d f8             	decl   -0x8(%ebp)
  800f4c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f50:	79 e9                	jns    800f3b <memset+0x14>
		*p++ = c;

	return v;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f69:	eb 16                	jmp    800f81 <memcpy+0x2a>
		*d++ = *s++;
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8d 50 01             	lea    0x1(%eax),%edx
  800f71:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f77:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f7d:	8a 12                	mov    (%edx),%dl
  800f7f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f87:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	75 dd                	jne    800f6b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fab:	73 50                	jae    800ffd <memmove+0x6a>
  800fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb3:	01 d0                	add    %edx,%eax
  800fb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb8:	76 43                	jbe    800ffd <memmove+0x6a>
		s += n;
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc6:	eb 10                	jmp    800fd8 <memmove+0x45>
			*--d = *--s;
  800fc8:	ff 4d f8             	decl   -0x8(%ebp)
  800fcb:	ff 4d fc             	decl   -0x4(%ebp)
  800fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd1:	8a 10                	mov    (%eax),%dl
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fde:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	75 e3                	jne    800fc8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe5:	eb 23                	jmp    80100a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fea:	8d 50 01             	lea    0x1(%eax),%edx
  800fed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff9:	8a 12                	mov    (%edx),%dl
  800ffb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 dd                	jne    800fe7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801021:	eb 2a                	jmp    80104d <memcmp+0x3e>
		if (*s1 != *s2)
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	8a 10                	mov    (%eax),%dl
  801028:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	38 c2                	cmp    %al,%dl
  80102f:	74 16                	je     801047 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f b6 d0             	movzbl %al,%edx
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f b6 c0             	movzbl %al,%eax
  801041:	29 c2                	sub    %eax,%edx
  801043:	89 d0                	mov    %edx,%eax
  801045:	eb 18                	jmp    80105f <memcmp+0x50>
		s1++, s2++;
  801047:	ff 45 fc             	incl   -0x4(%ebp)
  80104a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	8d 50 ff             	lea    -0x1(%eax),%edx
  801053:	89 55 10             	mov    %edx,0x10(%ebp)
  801056:	85 c0                	test   %eax,%eax
  801058:	75 c9                	jne    801023 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801067:	8b 55 08             	mov    0x8(%ebp),%edx
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801072:	eb 15                	jmp    801089 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f b6 d0             	movzbl %al,%edx
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	0f b6 c0             	movzbl %al,%eax
  801082:	39 c2                	cmp    %eax,%edx
  801084:	74 0d                	je     801093 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801086:	ff 45 08             	incl   0x8(%ebp)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108f:	72 e3                	jb     801074 <memfind+0x13>
  801091:	eb 01                	jmp    801094 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801093:	90                   	nop
	return (void *) s;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ad:	eb 03                	jmp    8010b2 <strtol+0x19>
		s++;
  8010af:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	3c 20                	cmp    $0x20,%al
  8010b9:	74 f4                	je     8010af <strtol+0x16>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 09                	cmp    $0x9,%al
  8010c2:	74 eb                	je     8010af <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 2b                	cmp    $0x2b,%al
  8010cb:	75 05                	jne    8010d2 <strtol+0x39>
		s++;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	eb 13                	jmp    8010e5 <strtol+0x4c>
	else if (*s == '-')
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	3c 2d                	cmp    $0x2d,%al
  8010d9:	75 0a                	jne    8010e5 <strtol+0x4c>
		s++, neg = 1;
  8010db:	ff 45 08             	incl   0x8(%ebp)
  8010de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e9:	74 06                	je     8010f1 <strtol+0x58>
  8010eb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ef:	75 20                	jne    801111 <strtol+0x78>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 30                	cmp    $0x30,%al
  8010f8:	75 17                	jne    801111 <strtol+0x78>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	40                   	inc    %eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 78                	cmp    $0x78,%al
  801102:	75 0d                	jne    801111 <strtol+0x78>
		s += 2, base = 16;
  801104:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801108:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80110f:	eb 28                	jmp    801139 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801111:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801115:	75 15                	jne    80112c <strtol+0x93>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 30                	cmp    $0x30,%al
  80111e:	75 0c                	jne    80112c <strtol+0x93>
		s++, base = 8;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112a:	eb 0d                	jmp    801139 <strtol+0xa0>
	else if (base == 0)
  80112c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801130:	75 07                	jne    801139 <strtol+0xa0>
		base = 10;
  801132:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	3c 2f                	cmp    $0x2f,%al
  801140:	7e 19                	jle    80115b <strtol+0xc2>
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 39                	cmp    $0x39,%al
  801149:	7f 10                	jg     80115b <strtol+0xc2>
			dig = *s - '0';
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	0f be c0             	movsbl %al,%eax
  801153:	83 e8 30             	sub    $0x30,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801159:	eb 42                	jmp    80119d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	3c 60                	cmp    $0x60,%al
  801162:	7e 19                	jle    80117d <strtol+0xe4>
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 7a                	cmp    $0x7a,%al
  80116b:	7f 10                	jg     80117d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f be c0             	movsbl %al,%eax
  801175:	83 e8 57             	sub    $0x57,%eax
  801178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117b:	eb 20                	jmp    80119d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 40                	cmp    $0x40,%al
  801184:	7e 39                	jle    8011bf <strtol+0x126>
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 5a                	cmp    $0x5a,%al
  80118d:	7f 30                	jg     8011bf <strtol+0x126>
			dig = *s - 'A' + 10;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f be c0             	movsbl %al,%eax
  801197:	83 e8 37             	sub    $0x37,%eax
  80119a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a3:	7d 19                	jge    8011be <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a5:	ff 45 08             	incl   0x8(%ebp)
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b9:	e9 7b ff ff ff       	jmp    801139 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011be:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c3:	74 08                	je     8011cd <strtol+0x134>
		*endptr = (char *) s;
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d1:	74 07                	je     8011da <strtol+0x141>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	f7 d8                	neg    %eax
  8011d8:	eb 03                	jmp    8011dd <strtol+0x144>
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <ltostr>:

void
ltostr(long value, char *str)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f7:	79 13                	jns    80120c <ltostr+0x2d>
	{
		neg = 1;
  8011f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801206:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801209:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801214:	99                   	cltd   
  801215:	f7 f9                	idiv   %ecx
  801217:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	8d 50 01             	lea    0x1(%eax),%edx
  801220:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801223:	89 c2                	mov    %eax,%edx
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	01 d0                	add    %edx,%eax
  80122a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122d:	83 c2 30             	add    $0x30,%edx
  801230:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801232:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801235:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123a:	f7 e9                	imul   %ecx
  80123c:	c1 fa 02             	sar    $0x2,%edx
  80123f:	89 c8                	mov    %ecx,%eax
  801241:	c1 f8 1f             	sar    $0x1f,%eax
  801244:	29 c2                	sub    %eax,%edx
  801246:	89 d0                	mov    %edx,%eax
  801248:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80124b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124f:	75 bb                	jne    80120c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125b:	48                   	dec    %eax
  80125c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80125f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801263:	74 3d                	je     8012a2 <ltostr+0xc3>
		start = 1 ;
  801265:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80126c:	eb 34                	jmp    8012a2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 d0                	add    %edx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80127b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	01 c2                	add    %eax,%edx
  801283:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c8                	add    %ecx,%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80128f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	01 c2                	add    %eax,%edx
  801297:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129a:	88 02                	mov    %al,(%edx)
		start++ ;
  80129c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80129f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a8:	7c c4                	jl     80126e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b5:	90                   	nop
  8012b6:	c9                   	leave  
  8012b7:	c3                   	ret    

008012b8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 73 fa ff ff       	call   800d39 <strlen>
  8012c6:	83 c4 04             	add    $0x4,%esp
  8012c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012cc:	ff 75 0c             	pushl  0xc(%ebp)
  8012cf:	e8 65 fa ff ff       	call   800d39 <strlen>
  8012d4:	83 c4 04             	add    $0x4,%esp
  8012d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e8:	eb 17                	jmp    801301 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 c2                	add    %eax,%edx
  8012f2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	01 c8                	add    %ecx,%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012fe:	ff 45 fc             	incl   -0x4(%ebp)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801307:	7c e1                	jl     8012ea <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801309:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801310:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801317:	eb 1f                	jmp    801338 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	8d 50 01             	lea    0x1(%eax),%edx
  80131f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801322:	89 c2                	mov    %eax,%edx
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 c2                	add    %eax,%edx
  801329:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	01 c8                	add    %ecx,%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801335:	ff 45 f8             	incl   -0x8(%ebp)
  801338:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133e:	7c d9                	jl     801319 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801340:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	c6 00 00             	movb   $0x0,(%eax)
}
  80134b:	90                   	nop
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801351:	8b 45 14             	mov    0x14(%ebp),%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801371:	eb 0c                	jmp    80137f <strsplit+0x31>
			*string++ = 0;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8d 50 01             	lea    0x1(%eax),%edx
  801379:	89 55 08             	mov    %edx,0x8(%ebp)
  80137c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 18                	je     8013a0 <strsplit+0x52>
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	0f be c0             	movsbl %al,%eax
  801390:	50                   	push   %eax
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	e8 32 fb ff ff       	call   800ecb <strchr>
  801399:	83 c4 08             	add    $0x8,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 d3                	jne    801373 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	84 c0                	test   %al,%al
  8013a7:	74 5a                	je     801403 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ac:	8b 00                	mov    (%eax),%eax
  8013ae:	83 f8 0f             	cmp    $0xf,%eax
  8013b1:	75 07                	jne    8013ba <strsplit+0x6c>
		{
			return 0;
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b8:	eb 66                	jmp    801420 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c5:	89 0a                	mov    %ecx,(%edx)
  8013c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	01 c2                	add    %eax,%edx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d8:	eb 03                	jmp    8013dd <strsplit+0x8f>
			string++;
  8013da:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 8b                	je     801371 <strsplit+0x23>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f be c0             	movsbl %al,%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	e8 d4 fa ff ff       	call   800ecb <strchr>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	74 dc                	je     8013da <strsplit+0x8c>
			string++;
	}
  8013fe:	e9 6e ff ff ff       	jmp    801371 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801403:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801404:	8b 45 14             	mov    0x14(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801410:	8b 45 10             	mov    0x10(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80141b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	68 48 26 80 00       	push   $0x802648
  801430:	68 3f 01 00 00       	push   $0x13f
  801435:	68 6a 26 80 00       	push   $0x80266a
  80143a:	e8 c6 07 00 00       	call   801c05 <_panic>

0080143f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801445:	83 ec 0c             	sub    $0xc,%esp
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 ef 06 00 00       	call   801b3f <sys_sbrk>
  801450:	83 c4 10             	add    $0x10,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80145b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80145f:	75 07                	jne    801468 <malloc+0x13>
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	eb 14                	jmp    80147c <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	68 78 26 80 00       	push   $0x802678
  801470:	6a 1b                	push   $0x1b
  801472:	68 9d 26 80 00       	push   $0x80269d
  801477:	e8 89 07 00 00       	call   801c05 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	68 ac 26 80 00       	push   $0x8026ac
  80148c:	6a 29                	push   $0x29
  80148e:	68 9d 26 80 00       	push   $0x80269d
  801493:	e8 6d 07 00 00       	call   801c05 <_panic>

00801498 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 18             	sub    $0x18,%esp
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a8:	75 07                	jne    8014b1 <smalloc+0x19>
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	eb 14                	jmp    8014c5 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	68 d0 26 80 00       	push   $0x8026d0
  8014b9:	6a 38                	push   $0x38
  8014bb:	68 9d 26 80 00       	push   $0x80269d
  8014c0:	e8 40 07 00 00       	call   801c05 <_panic>
	return NULL;
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	68 f8 26 80 00       	push   $0x8026f8
  8014d5:	6a 43                	push   $0x43
  8014d7:	68 9d 26 80 00       	push   $0x80269d
  8014dc:	e8 24 07 00 00       	call   801c05 <_panic>

008014e1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	68 1c 27 80 00       	push   $0x80271c
  8014ef:	6a 5b                	push   $0x5b
  8014f1:	68 9d 26 80 00       	push   $0x80269d
  8014f6:	e8 0a 07 00 00       	call   801c05 <_panic>

008014fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801501:	83 ec 04             	sub    $0x4,%esp
  801504:	68 40 27 80 00       	push   $0x802740
  801509:	6a 72                	push   $0x72
  80150b:	68 9d 26 80 00       	push   $0x80269d
  801510:	e8 f0 06 00 00       	call   801c05 <_panic>

00801515 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	68 66 27 80 00       	push   $0x802766
  801523:	6a 7e                	push   $0x7e
  801525:	68 9d 26 80 00       	push   $0x80269d
  80152a:	e8 d6 06 00 00       	call   801c05 <_panic>

0080152f <shrink>:

}
void shrink(uint32 newSize)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 66 27 80 00       	push   $0x802766
  80153d:	68 83 00 00 00       	push   $0x83
  801542:	68 9d 26 80 00       	push   $0x80269d
  801547:	e8 b9 06 00 00       	call   801c05 <_panic>

0080154c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 66 27 80 00       	push   $0x802766
  80155a:	68 88 00 00 00       	push   $0x88
  80155f:	68 9d 26 80 00       	push   $0x80269d
  801564:	e8 9c 06 00 00       	call   801c05 <_panic>

00801569 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	57                   	push   %edi
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80157e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801581:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801584:	cd 30                	int    $0x30
  801586:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	5b                   	pop    %ebx
  801590:	5e                   	pop    %esi
  801591:	5f                   	pop    %edi
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	8b 45 10             	mov    0x10(%ebp),%eax
  80159d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	52                   	push   %edx
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	50                   	push   %eax
  8015b0:	6a 00                	push   $0x0
  8015b2:	e8 b2 ff ff ff       	call   801569 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	90                   	nop
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 02                	push   $0x2
  8015cc:	e8 98 ff ff ff       	call   801569 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 03                	push   $0x3
  8015e5:	e8 7f ff ff ff       	call   801569 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	90                   	nop
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 04                	push   $0x4
  8015ff:	e8 65 ff ff ff       	call   801569 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	6a 08                	push   $0x8
  80161d:	e8 47 ff ff ff       	call   801569 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80162c:	8b 75 18             	mov    0x18(%ebp),%esi
  80162f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801632:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	56                   	push   %esi
  80163c:	53                   	push   %ebx
  80163d:	51                   	push   %ecx
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 09                	push   $0x9
  801642:	e8 22 ff ff ff       	call   801569 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5e                   	pop    %esi
  80164f:	5d                   	pop    %ebp
  801650:	c3                   	ret    

00801651 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	52                   	push   %edx
  801661:	50                   	push   %eax
  801662:	6a 0a                	push   $0xa
  801664:	e8 00 ff ff ff       	call   801569 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	ff 75 0c             	pushl  0xc(%ebp)
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	6a 0b                	push   $0xb
  80167f:	e8 e5 fe ff ff       	call   801569 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 0c                	push   $0xc
  801698:	e8 cc fe ff ff       	call   801569 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 0d                	push   $0xd
  8016b1:	e8 b3 fe ff ff       	call   801569 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 0e                	push   $0xe
  8016ca:	e8 9a fe ff ff       	call   801569 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 0f                	push   $0xf
  8016e3:	e8 81 fe ff ff       	call   801569 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	6a 10                	push   $0x10
  8016fd:	e8 67 fe ff ff       	call   801569 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 11                	push   $0x11
  801716:	e8 4e fe ff ff       	call   801569 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	90                   	nop
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_cputc>:

void
sys_cputc(const char c)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80172d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	50                   	push   %eax
  80173a:	6a 01                	push   $0x1
  80173c:	e8 28 fe ff ff       	call   801569 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 14                	push   $0x14
  801756:	e8 0e fe ff ff       	call   801569 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80176d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801770:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	51                   	push   %ecx
  80177a:	52                   	push   %edx
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	50                   	push   %eax
  80177f:	6a 15                	push   $0x15
  801781:	e8 e3 fd ff ff       	call   801569 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 16                	push   $0x16
  80179e:	e8 c6 fd ff ff       	call   801569 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	51                   	push   %ecx
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	6a 17                	push   $0x17
  8017bd:	e8 a7 fd ff ff       	call   801569 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 18                	push   $0x18
  8017da:	e8 8a fd ff ff       	call   801569 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 14             	pushl  0x14(%ebp)
  8017ef:	ff 75 10             	pushl  0x10(%ebp)
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	50                   	push   %eax
  8017f6:	6a 19                	push   $0x19
  8017f8:	e8 6c fd ff ff       	call   801569 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	50                   	push   %eax
  801811:	6a 1a                	push   $0x1a
  801813:	e8 51 fd ff ff       	call   801569 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	50                   	push   %eax
  80182d:	6a 1b                	push   $0x1b
  80182f:	e8 35 fd ff ff       	call   801569 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 05                	push   $0x5
  801848:	e8 1c fd ff ff       	call   801569 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 06                	push   $0x6
  801861:	e8 03 fd ff ff       	call   801569 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 07                	push   $0x7
  80187a:	e8 ea fc ff ff       	call   801569 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_exit_env>:


void sys_exit_env(void)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 1c                	push   $0x1c
  801893:	e8 d1 fc ff ff       	call   801569 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018a7:	8d 50 04             	lea    0x4(%eax),%edx
  8018aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 1d                	push   $0x1d
  8018b7:	e8 ad fc ff ff       	call   801569 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
	return result;
  8018bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c8:	89 01                	mov    %eax,(%ecx)
  8018ca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	c9                   	leave  
  8018d1:	c2 04 00             	ret    $0x4

008018d4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	6a 13                	push   $0x13
  8018e6:	e8 7e fc ff ff       	call   801569 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 1e                	push   $0x1e
  801900:	e8 64 fc ff ff       	call   801569 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801916:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	50                   	push   %eax
  801923:	6a 1f                	push   $0x1f
  801925:	e8 3f fc ff ff       	call   801569 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <rsttst>:
void rsttst()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 21                	push   $0x21
  80193f:	e8 25 fc ff ff       	call   801569 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 14             	mov    0x14(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801956:	8b 55 18             	mov    0x18(%ebp),%edx
  801959:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	ff 75 10             	pushl  0x10(%ebp)
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	ff 75 08             	pushl  0x8(%ebp)
  801968:	6a 20                	push   $0x20
  80196a:	e8 fa fb ff ff       	call   801569 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
	return ;
  801972:	90                   	nop
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <chktst>:
void chktst(uint32 n)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 22                	push   $0x22
  801985:	e8 df fb ff ff       	call   801569 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <inctst>:

void inctst()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 23                	push   $0x23
  80199f:	e8 c5 fb ff ff       	call   801569 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <gettst>:
uint32 gettst()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 24                	push   $0x24
  8019b9:	e8 ab fb ff ff       	call   801569 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 25                	push   $0x25
  8019d5:	e8 8f fb ff ff       	call   801569 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
  8019dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019e0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019e4:	75 07                	jne    8019ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019eb:	eb 05                	jmp    8019f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 25                	push   $0x25
  801a06:	e8 5e fb ff ff       	call   801569 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
  801a0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a11:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a15:	75 07                	jne    801a1e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a17:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1c:	eb 05                	jmp    801a23 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 25                	push   $0x25
  801a37:	e8 2d fb ff ff       	call   801569 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
  801a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a42:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a46:	75 07                	jne    801a4f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a48:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4d:	eb 05                	jmp    801a54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 25                	push   $0x25
  801a68:	e8 fc fa ff ff       	call   801569 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
  801a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a73:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a77:	75 07                	jne    801a80 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	eb 05                	jmp    801a85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 26                	push   $0x26
  801a97:	e8 cd fa ff ff       	call   801569 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aa6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	53                   	push   %ebx
  801ab5:	51                   	push   %ecx
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 27                	push   $0x27
  801aba:	e8 aa fa ff ff       	call   801569 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 28                	push   $0x28
  801ada:	e8 8a fa ff ff       	call   801569 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ae7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	51                   	push   %ecx
  801af3:	ff 75 10             	pushl  0x10(%ebp)
  801af6:	52                   	push   %edx
  801af7:	50                   	push   %eax
  801af8:	6a 29                	push   $0x29
  801afa:	e8 6a fa ff ff       	call   801569 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 10             	pushl  0x10(%ebp)
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	6a 12                	push   $0x12
  801b16:	e8 4e fa ff ff       	call   801569 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1e:	90                   	nop
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 2a                	push   $0x2a
  801b34:	e8 30 fa ff ff       	call   801569 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
	return;
  801b3c:	90                   	nop
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	50                   	push   %eax
  801b4e:	6a 2b                	push   $0x2b
  801b50:	e8 14 fa ff ff       	call   801569 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	6a 2c                	push   $0x2c
  801b6b:	e8 f9 f9 ff ff       	call   801569 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 2d                	push   $0x2d
  801b87:	e8 dd f9 ff ff       	call   801569 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	68 78 27 80 00       	push   $0x802778
  801ba0:	6a 09                	push   $0x9
  801ba2:	68 a0 27 80 00       	push   $0x8027a0
  801ba7:	e8 59 00 00 00       	call   801c05 <_panic>

00801bac <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 b0 27 80 00       	push   $0x8027b0
  801bba:	6a 10                	push   $0x10
  801bbc:	68 a0 27 80 00       	push   $0x8027a0
  801bc1:	e8 3f 00 00 00       	call   801c05 <_panic>

00801bc6 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	68 d8 27 80 00       	push   $0x8027d8
  801bd4:	6a 18                	push   $0x18
  801bd6:	68 a0 27 80 00       	push   $0x8027a0
  801bdb:	e8 25 00 00 00       	call   801c05 <_panic>

00801be0 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 00 28 80 00       	push   $0x802800
  801bee:	6a 20                	push   $0x20
  801bf0:	68 a0 27 80 00       	push   $0x8027a0
  801bf5:	e8 0b 00 00 00       	call   801c05 <_panic>

00801bfa <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	8b 40 10             	mov    0x10(%eax),%eax
}
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801c0b:	8d 45 10             	lea    0x10(%ebp),%eax
  801c0e:	83 c0 04             	add    $0x4,%eax
  801c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801c14:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	74 16                	je     801c33 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801c1d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801c22:	83 ec 08             	sub    $0x8,%esp
  801c25:	50                   	push   %eax
  801c26:	68 28 28 80 00       	push   $0x802828
  801c2b:	e8 75 ea ff ff       	call   8006a5 <cprintf>
  801c30:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801c33:	a1 00 30 80 00       	mov    0x803000,%eax
  801c38:	ff 75 0c             	pushl  0xc(%ebp)
  801c3b:	ff 75 08             	pushl  0x8(%ebp)
  801c3e:	50                   	push   %eax
  801c3f:	68 2d 28 80 00       	push   $0x80282d
  801c44:	e8 5c ea ff ff       	call   8006a5 <cprintf>
  801c49:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4f:	83 ec 08             	sub    $0x8,%esp
  801c52:	ff 75 f4             	pushl  -0xc(%ebp)
  801c55:	50                   	push   %eax
  801c56:	e8 df e9 ff ff       	call   80063a <vcprintf>
  801c5b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801c5e:	83 ec 08             	sub    $0x8,%esp
  801c61:	6a 00                	push   $0x0
  801c63:	68 49 28 80 00       	push   $0x802849
  801c68:	e8 cd e9 ff ff       	call   80063a <vcprintf>
  801c6d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801c70:	e8 4e e9 ff ff       	call   8005c3 <exit>

	// should not return here
	while (1) ;
  801c75:	eb fe                	jmp    801c75 <_panic+0x70>

00801c77 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801c7d:	a1 04 30 80 00       	mov    0x803004,%eax
  801c82:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	39 c2                	cmp    %eax,%edx
  801c8d:	74 14                	je     801ca3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	68 4c 28 80 00       	push   $0x80284c
  801c97:	6a 26                	push   $0x26
  801c99:	68 98 28 80 00       	push   $0x802898
  801c9e:	e8 62 ff ff ff       	call   801c05 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801cb1:	e9 c5 00 00 00       	jmp    801d7b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	01 d0                	add    %edx,%eax
  801cc5:	8b 00                	mov    (%eax),%eax
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	75 08                	jne    801cd3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ccb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801cce:	e9 a5 00 00 00       	jmp    801d78 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801cd3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cda:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ce1:	eb 69                	jmp    801d4c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ce3:	a1 04 30 80 00       	mov    0x803004,%eax
  801ce8:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801cee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	01 c0                	add    %eax,%eax
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	c1 e0 03             	shl    $0x3,%eax
  801cfa:	01 c8                	add    %ecx,%eax
  801cfc:	8a 40 04             	mov    0x4(%eax),%al
  801cff:	84 c0                	test   %al,%al
  801d01:	75 46                	jne    801d49 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d03:	a1 04 30 80 00       	mov    0x803004,%eax
  801d08:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	01 c0                	add    %eax,%eax
  801d15:	01 d0                	add    %edx,%eax
  801d17:	c1 e0 03             	shl    $0x3,%eax
  801d1a:	01 c8                	add    %ecx,%eax
  801d1c:	8b 00                	mov    (%eax),%eax
  801d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801d21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d29:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	01 c8                	add    %ecx,%eax
  801d3a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801d3c:	39 c2                	cmp    %eax,%edx
  801d3e:	75 09                	jne    801d49 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801d40:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801d47:	eb 15                	jmp    801d5e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d49:	ff 45 e8             	incl   -0x18(%ebp)
  801d4c:	a1 04 30 80 00       	mov    0x803004,%eax
  801d51:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d5a:	39 c2                	cmp    %eax,%edx
  801d5c:	77 85                	ja     801ce3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801d5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d62:	75 14                	jne    801d78 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	68 a4 28 80 00       	push   $0x8028a4
  801d6c:	6a 3a                	push   $0x3a
  801d6e:	68 98 28 80 00       	push   $0x802898
  801d73:	e8 8d fe ff ff       	call   801c05 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801d78:	ff 45 f0             	incl   -0x10(%ebp)
  801d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d81:	0f 8c 2f ff ff ff    	jl     801cb6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801d87:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801d8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d95:	eb 26                	jmp    801dbd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801d97:	a1 04 30 80 00       	mov    0x803004,%eax
  801d9c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801da2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da5:	89 d0                	mov    %edx,%eax
  801da7:	01 c0                	add    %eax,%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	c1 e0 03             	shl    $0x3,%eax
  801dae:	01 c8                	add    %ecx,%eax
  801db0:	8a 40 04             	mov    0x4(%eax),%al
  801db3:	3c 01                	cmp    $0x1,%al
  801db5:	75 03                	jne    801dba <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801db7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801dba:	ff 45 e0             	incl   -0x20(%ebp)
  801dbd:	a1 04 30 80 00       	mov    0x803004,%eax
  801dc2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dcb:	39 c2                	cmp    %eax,%edx
  801dcd:	77 c8                	ja     801d97 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801dd5:	74 14                	je     801deb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	68 f8 28 80 00       	push   $0x8028f8
  801ddf:	6a 44                	push   $0x44
  801de1:	68 98 28 80 00       	push   $0x802898
  801de6:	e8 1a fe ff ff       	call   801c05 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    
  801dee:	66 90                	xchg   %ax,%ax

00801df0 <__udivdi3>:
  801df0:	55                   	push   %ebp
  801df1:	57                   	push   %edi
  801df2:	56                   	push   %esi
  801df3:	53                   	push   %ebx
  801df4:	83 ec 1c             	sub    $0x1c,%esp
  801df7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801dff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e07:	89 ca                	mov    %ecx,%edx
  801e09:	89 f8                	mov    %edi,%eax
  801e0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e0f:	85 f6                	test   %esi,%esi
  801e11:	75 2d                	jne    801e40 <__udivdi3+0x50>
  801e13:	39 cf                	cmp    %ecx,%edi
  801e15:	77 65                	ja     801e7c <__udivdi3+0x8c>
  801e17:	89 fd                	mov    %edi,%ebp
  801e19:	85 ff                	test   %edi,%edi
  801e1b:	75 0b                	jne    801e28 <__udivdi3+0x38>
  801e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e22:	31 d2                	xor    %edx,%edx
  801e24:	f7 f7                	div    %edi
  801e26:	89 c5                	mov    %eax,%ebp
  801e28:	31 d2                	xor    %edx,%edx
  801e2a:	89 c8                	mov    %ecx,%eax
  801e2c:	f7 f5                	div    %ebp
  801e2e:	89 c1                	mov    %eax,%ecx
  801e30:	89 d8                	mov    %ebx,%eax
  801e32:	f7 f5                	div    %ebp
  801e34:	89 cf                	mov    %ecx,%edi
  801e36:	89 fa                	mov    %edi,%edx
  801e38:	83 c4 1c             	add    $0x1c,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    
  801e40:	39 ce                	cmp    %ecx,%esi
  801e42:	77 28                	ja     801e6c <__udivdi3+0x7c>
  801e44:	0f bd fe             	bsr    %esi,%edi
  801e47:	83 f7 1f             	xor    $0x1f,%edi
  801e4a:	75 40                	jne    801e8c <__udivdi3+0x9c>
  801e4c:	39 ce                	cmp    %ecx,%esi
  801e4e:	72 0a                	jb     801e5a <__udivdi3+0x6a>
  801e50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e54:	0f 87 9e 00 00 00    	ja     801ef8 <__udivdi3+0x108>
  801e5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5f:	89 fa                	mov    %edi,%edx
  801e61:	83 c4 1c             	add    $0x1c,%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5e                   	pop    %esi
  801e66:	5f                   	pop    %edi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    
  801e69:	8d 76 00             	lea    0x0(%esi),%esi
  801e6c:	31 ff                	xor    %edi,%edi
  801e6e:	31 c0                	xor    %eax,%eax
  801e70:	89 fa                	mov    %edi,%edx
  801e72:	83 c4 1c             	add    $0x1c,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5f                   	pop    %edi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	89 d8                	mov    %ebx,%eax
  801e7e:	f7 f7                	div    %edi
  801e80:	31 ff                	xor    %edi,%edi
  801e82:	89 fa                	mov    %edi,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e91:	89 eb                	mov    %ebp,%ebx
  801e93:	29 fb                	sub    %edi,%ebx
  801e95:	89 f9                	mov    %edi,%ecx
  801e97:	d3 e6                	shl    %cl,%esi
  801e99:	89 c5                	mov    %eax,%ebp
  801e9b:	88 d9                	mov    %bl,%cl
  801e9d:	d3 ed                	shr    %cl,%ebp
  801e9f:	89 e9                	mov    %ebp,%ecx
  801ea1:	09 f1                	or     %esi,%ecx
  801ea3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ea7:	89 f9                	mov    %edi,%ecx
  801ea9:	d3 e0                	shl    %cl,%eax
  801eab:	89 c5                	mov    %eax,%ebp
  801ead:	89 d6                	mov    %edx,%esi
  801eaf:	88 d9                	mov    %bl,%cl
  801eb1:	d3 ee                	shr    %cl,%esi
  801eb3:	89 f9                	mov    %edi,%ecx
  801eb5:	d3 e2                	shl    %cl,%edx
  801eb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ebb:	88 d9                	mov    %bl,%cl
  801ebd:	d3 e8                	shr    %cl,%eax
  801ebf:	09 c2                	or     %eax,%edx
  801ec1:	89 d0                	mov    %edx,%eax
  801ec3:	89 f2                	mov    %esi,%edx
  801ec5:	f7 74 24 0c          	divl   0xc(%esp)
  801ec9:	89 d6                	mov    %edx,%esi
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	f7 e5                	mul    %ebp
  801ecf:	39 d6                	cmp    %edx,%esi
  801ed1:	72 19                	jb     801eec <__udivdi3+0xfc>
  801ed3:	74 0b                	je     801ee0 <__udivdi3+0xf0>
  801ed5:	89 d8                	mov    %ebx,%eax
  801ed7:	31 ff                	xor    %edi,%edi
  801ed9:	e9 58 ff ff ff       	jmp    801e36 <__udivdi3+0x46>
  801ede:	66 90                	xchg   %ax,%ax
  801ee0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ee4:	89 f9                	mov    %edi,%ecx
  801ee6:	d3 e2                	shl    %cl,%edx
  801ee8:	39 c2                	cmp    %eax,%edx
  801eea:	73 e9                	jae    801ed5 <__udivdi3+0xe5>
  801eec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eef:	31 ff                	xor    %edi,%edi
  801ef1:	e9 40 ff ff ff       	jmp    801e36 <__udivdi3+0x46>
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	31 c0                	xor    %eax,%eax
  801efa:	e9 37 ff ff ff       	jmp    801e36 <__udivdi3+0x46>
  801eff:	90                   	nop

00801f00 <__umoddi3>:
  801f00:	55                   	push   %ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	83 ec 1c             	sub    $0x1c,%esp
  801f07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f1f:	89 f3                	mov    %esi,%ebx
  801f21:	89 fa                	mov    %edi,%edx
  801f23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f27:	89 34 24             	mov    %esi,(%esp)
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 1a                	jne    801f48 <__umoddi3+0x48>
  801f2e:	39 f7                	cmp    %esi,%edi
  801f30:	0f 86 a2 00 00 00    	jbe    801fd8 <__umoddi3+0xd8>
  801f36:	89 c8                	mov    %ecx,%eax
  801f38:	89 f2                	mov    %esi,%edx
  801f3a:	f7 f7                	div    %edi
  801f3c:	89 d0                	mov    %edx,%eax
  801f3e:	31 d2                	xor    %edx,%edx
  801f40:	83 c4 1c             	add    $0x1c,%esp
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    
  801f48:	39 f0                	cmp    %esi,%eax
  801f4a:	0f 87 ac 00 00 00    	ja     801ffc <__umoddi3+0xfc>
  801f50:	0f bd e8             	bsr    %eax,%ebp
  801f53:	83 f5 1f             	xor    $0x1f,%ebp
  801f56:	0f 84 ac 00 00 00    	je     802008 <__umoddi3+0x108>
  801f5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f61:	29 ef                	sub    %ebp,%edi
  801f63:	89 fe                	mov    %edi,%esi
  801f65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f69:	89 e9                	mov    %ebp,%ecx
  801f6b:	d3 e0                	shl    %cl,%eax
  801f6d:	89 d7                	mov    %edx,%edi
  801f6f:	89 f1                	mov    %esi,%ecx
  801f71:	d3 ef                	shr    %cl,%edi
  801f73:	09 c7                	or     %eax,%edi
  801f75:	89 e9                	mov    %ebp,%ecx
  801f77:	d3 e2                	shl    %cl,%edx
  801f79:	89 14 24             	mov    %edx,(%esp)
  801f7c:	89 d8                	mov    %ebx,%eax
  801f7e:	d3 e0                	shl    %cl,%eax
  801f80:	89 c2                	mov    %eax,%edx
  801f82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f86:	d3 e0                	shl    %cl,%eax
  801f88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f90:	89 f1                	mov    %esi,%ecx
  801f92:	d3 e8                	shr    %cl,%eax
  801f94:	09 d0                	or     %edx,%eax
  801f96:	d3 eb                	shr    %cl,%ebx
  801f98:	89 da                	mov    %ebx,%edx
  801f9a:	f7 f7                	div    %edi
  801f9c:	89 d3                	mov    %edx,%ebx
  801f9e:	f7 24 24             	mull   (%esp)
  801fa1:	89 c6                	mov    %eax,%esi
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	39 d3                	cmp    %edx,%ebx
  801fa7:	0f 82 87 00 00 00    	jb     802034 <__umoddi3+0x134>
  801fad:	0f 84 91 00 00 00    	je     802044 <__umoddi3+0x144>
  801fb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fb7:	29 f2                	sub    %esi,%edx
  801fb9:	19 cb                	sbb    %ecx,%ebx
  801fbb:	89 d8                	mov    %ebx,%eax
  801fbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801fc1:	d3 e0                	shl    %cl,%eax
  801fc3:	89 e9                	mov    %ebp,%ecx
  801fc5:	d3 ea                	shr    %cl,%edx
  801fc7:	09 d0                	or     %edx,%eax
  801fc9:	89 e9                	mov    %ebp,%ecx
  801fcb:	d3 eb                	shr    %cl,%ebx
  801fcd:	89 da                	mov    %ebx,%edx
  801fcf:	83 c4 1c             	add    $0x1c,%esp
  801fd2:	5b                   	pop    %ebx
  801fd3:	5e                   	pop    %esi
  801fd4:	5f                   	pop    %edi
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    
  801fd7:	90                   	nop
  801fd8:	89 fd                	mov    %edi,%ebp
  801fda:	85 ff                	test   %edi,%edi
  801fdc:	75 0b                	jne    801fe9 <__umoddi3+0xe9>
  801fde:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe3:	31 d2                	xor    %edx,%edx
  801fe5:	f7 f7                	div    %edi
  801fe7:	89 c5                	mov    %eax,%ebp
  801fe9:	89 f0                	mov    %esi,%eax
  801feb:	31 d2                	xor    %edx,%edx
  801fed:	f7 f5                	div    %ebp
  801fef:	89 c8                	mov    %ecx,%eax
  801ff1:	f7 f5                	div    %ebp
  801ff3:	89 d0                	mov    %edx,%eax
  801ff5:	e9 44 ff ff ff       	jmp    801f3e <__umoddi3+0x3e>
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	89 c8                	mov    %ecx,%eax
  801ffe:	89 f2                	mov    %esi,%edx
  802000:	83 c4 1c             	add    $0x1c,%esp
  802003:	5b                   	pop    %ebx
  802004:	5e                   	pop    %esi
  802005:	5f                   	pop    %edi
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    
  802008:	3b 04 24             	cmp    (%esp),%eax
  80200b:	72 06                	jb     802013 <__umoddi3+0x113>
  80200d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802011:	77 0f                	ja     802022 <__umoddi3+0x122>
  802013:	89 f2                	mov    %esi,%edx
  802015:	29 f9                	sub    %edi,%ecx
  802017:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80201b:	89 14 24             	mov    %edx,(%esp)
  80201e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802022:	8b 44 24 04          	mov    0x4(%esp),%eax
  802026:	8b 14 24             	mov    (%esp),%edx
  802029:	83 c4 1c             	add    $0x1c,%esp
  80202c:	5b                   	pop    %ebx
  80202d:	5e                   	pop    %esi
  80202e:	5f                   	pop    %edi
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    
  802031:	8d 76 00             	lea    0x0(%esi),%esi
  802034:	2b 04 24             	sub    (%esp),%eax
  802037:	19 fa                	sbb    %edi,%edx
  802039:	89 d1                	mov    %edx,%ecx
  80203b:	89 c6                	mov    %eax,%esi
  80203d:	e9 71 ff ff ff       	jmp    801fb3 <__umoddi3+0xb3>
  802042:	66 90                	xchg   %ax,%ax
  802044:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802048:	72 ea                	jb     802034 <__umoddi3+0x134>
  80204a:	89 d9                	mov    %ebx,%ecx
  80204c:	e9 62 ff ff ff       	jmp    801fb3 <__umoddi3+0xb3>

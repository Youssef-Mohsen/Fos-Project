
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 06 00 00       	call   800691 <libmain>
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
  80003e:	81 ec ac 01 00 00    	sub    $0x1ac,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 25 20 00 00       	call   80206e <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 55 41 80 00       	mov    $0x804155,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 5f 41 80 00       	mov    $0x80415f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 6b 41 80 00       	mov    $0x80416b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 7a 41 80 00       	mov    $0x80417a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 89 41 80 00       	mov    $0x804189,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 9e 41 80 00       	mov    $0x80419e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb b3 41 80 00       	mov    $0x8041b3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb c4 41 80 00       	mov    $0x8041c4,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb d5 41 80 00       	mov    $0x8041d5,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb e6 41 80 00       	mov    $0x8041e6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb ef 41 80 00       	mov    $0x8041ef,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb f9 41 80 00       	mov    $0x8041f9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 04 42 80 00       	mov    $0x804204,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 10 42 80 00       	mov    $0x804210,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 1a 42 80 00       	mov    $0x80421a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb 24 42 80 00       	mov    $0x804224,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 32 42 80 00       	mov    $0x804232,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 41 42 80 00       	mov    $0x804241,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 48 42 80 00       	mov    $0x804248,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 e8 19 00 00       	call   801c12 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 d3 19 00 00       	call   801c12 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 be 19 00 00       	call   801c12 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 a6 19 00 00       	call   801c12 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 8e 19 00 00       	call   801c12 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 76 19 00 00       	call   801c12 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 5e 19 00 00       	call   801c12 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 46 19 00 00       	call   801c12 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 2e 19 00 00       	call   801c12 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002ea:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	8d 95 09 ff ff ff    	lea    -0xf7(%ebp),%edx
  8002f9:	52                   	push   %edx
  8002fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002fd:	50                   	push   %eax
  8002fe:	e8 45 3b 00 00       	call   803e48 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 29 3b 00 00       	call   803e48 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 0d 3b 00 00       	call   803e48 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 f1 3a 00 00       	call   803e48 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 d5 3a 00 00       	call   803e48 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 de 3a 00 00       	call   803e62 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 cd 3a 00 00       	call   803e62 <wait_semaphore>
  800395:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800398:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80039b:	8b 00                	mov    (%eax),%eax
  80039d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  8003ae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	8d 50 01             	lea    0x1(%eax),%edx
  8003b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003b9:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  8003c4:	e8 b3 3a 00 00       	call   803e7c <signal_semaphore>
  8003c9:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  8003cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  8003e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003e3:	83 f8 02             	cmp    $0x2,%eax
  8003e6:	0f 84 88 00 00 00    	je     800474 <_main+0x43c>
  8003ec:	83 f8 03             	cmp    $0x3,%eax
  8003ef:	0f 84 f5 00 00 00    	je     8004ea <_main+0x4b2>
  8003f5:	83 f8 01             	cmp    $0x1,%eax
  8003f8:	0f 85 d8 01 00 00    	jne    8005d6 <_main+0x59e>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  800407:	e8 56 3a 00 00       	call   803e62 <wait_semaphore>
  80040c:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80040f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	7e 46                	jle    80045e <_main+0x426>
				{
					*flight1Counter = *flight1Counter - 1;
  800418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800420:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800423:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800425:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800428:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80042f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  80043b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044a:	01 c2                	add    %eax,%edx
  80044c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80044f:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800451:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 50 01             	lea    0x1(%eax),%edx
  800459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045c:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight1CS);
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  800467:	e8 10 3a 00 00       	call   803e7c <signal_semaphore>
  80046c:	83 c4 10             	add    $0x10,%esp
		}

		break;
  80046f:	e9 79 01 00 00       	jmp    8005ed <_main+0x5b5>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  80047d:	e8 e0 39 00 00       	call   803e62 <wait_semaphore>
  800482:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	7e 46                	jle    8004d4 <_main+0x49c>
				{
					*flight2Counter = *flight2Counter - 1;
  80048e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	8d 50 ff             	lea    -0x1(%eax),%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80049b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80049e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  8004b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c0:	01 c2                	add    %eax,%edx
  8004c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004c5:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  8004c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 01             	lea    0x1(%eax),%edx
  8004cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight2CS);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8004dd:	e8 9a 39 00 00       	call   803e7c <signal_semaphore>
  8004e2:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8004e5:	e9 03 01 00 00       	jmp    8005ed <_main+0x5b5>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8004ea:	83 ec 0c             	sub    $0xc,%esp
  8004ed:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  8004f3:	e8 6a 39 00 00       	call   803e62 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 59 39 00 00       	call   803e62 <wait_semaphore>
  800509:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  80050c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	85 c0                	test   %eax,%eax
  800513:	0f 8e 99 00 00 00    	jle    8005b2 <_main+0x57a>
  800519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	85 c0                	test   %eax,%eax
  800520:	0f 8e 8c 00 00 00    	jle    8005b2 <_main+0x57a>
				{
					*flight1Counter = *flight1Counter - 1;
  800526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80052e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800533:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800536:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	01 c2                	add    %eax,%edx
  80055a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80055d:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  80055f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	8d 50 01             	lea    0x1(%eax),%edx
  800567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056a:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  80056c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	8d 50 ff             	lea    -0x1(%eax),%edx
  800574:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800577:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800579:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80057c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80058f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80059e:	01 c2                	add    %eax,%edx
  8005a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8005a3:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  8005a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	8d 50 01             	lea    0x1(%eax),%edx
  8005ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  8005b2:	83 ec 0c             	sub    $0xc,%esp
  8005b5:	ff b5 ac fe ff ff    	pushl  -0x154(%ebp)
  8005bb:	e8 bc 38 00 00       	call   803e7c <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 ab 38 00 00       	call   803e7c <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 20 41 80 00       	push   $0x804120
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 40 41 80 00       	push   $0x804140
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 4f 42 80 00       	mov    $0x80424f,%ebx
  8005f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8005fd:	89 c7                	mov    %eax,%edi
  8005ff:	89 de                	mov    %ebx,%esi
  800601:	89 d1                	mov    %edx,%ecx
  800603:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800605:	8d 95 94 fe ff ff    	lea    -0x16c(%ebp),%edx
  80060b:	b9 04 00 00 00       	mov    $0x4,%ecx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	89 d7                	mov    %edx,%edi
  800617:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  800622:	50                   	push   %eax
  800623:	ff 75 bc             	pushl  -0x44(%ebp)
  800626:	e8 9c 0f 00 00       	call   8015c7 <ltostr>
  80062b:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	8d 85 4a fe ff ff    	lea    -0x1b6(%ebp),%eax
  800637:	50                   	push   %eax
  800638:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  80063e:	50                   	push   %eax
  80063f:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  800645:	50                   	push   %eax
  800646:	e8 55 10 00 00       	call   8016a0 <strcconcat>
  80064b:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80064e:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	8d 95 4a fe ff ff    	lea    -0x1b6(%ebp),%edx
  80065d:	52                   	push   %edx
  80065e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800661:	50                   	push   %eax
  800662:	e8 e1 37 00 00       	call   803e48 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 04 38 00 00       	call   803e7c <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 f3 37 00 00       	call   803e7c <signal_semaphore>
  800689:	83 c4 10             	add    $0x10,%esp
	}
  80068c:	e9 e5 fc ff ff       	jmp    800376 <_main+0x33e>

00800691 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800697:	e8 b9 19 00 00       	call   802055 <sys_getenvindex>
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80069f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a2:	89 d0                	mov    %edx,%eax
  8006a4:	c1 e0 03             	shl    $0x3,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006b0:	01 c8                	add    %ecx,%eax
  8006b2:	01 c0                	add    %eax,%eax
  8006b4:	01 d0                	add    %edx,%eax
  8006b6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8006bd:	01 c8                	add    %ecx,%eax
  8006bf:	01 d0                	add    %edx,%eax
  8006c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006c6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8a 40 20             	mov    0x20(%eax),%al
  8006d3:	84 c0                	test   %al,%al
  8006d5:	74 0d                	je     8006e4 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8006d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8006dc:	83 c0 20             	add    $0x20,%eax
  8006df:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e8:	7e 0a                	jle    8006f4 <libmain+0x63>
		binaryname = argv[0];
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	ff 75 08             	pushl  0x8(%ebp)
  8006fd:	e8 36 f9 ff ff       	call   800038 <_main>
  800702:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800705:	e8 cf 16 00 00       	call   801dd9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 88 42 80 00       	push   $0x804288
  800712:	e8 76 03 00 00       	call   800a8d <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80071a:	a1 20 50 80 00       	mov    0x805020,%eax
  80071f:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800725:	a1 20 50 80 00       	mov    0x805020,%eax
  80072a:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800730:	83 ec 04             	sub    $0x4,%esp
  800733:	52                   	push   %edx
  800734:	50                   	push   %eax
  800735:	68 b0 42 80 00       	push   $0x8042b0
  80073a:	e8 4e 03 00 00       	call   800a8d <cprintf>
  80073f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800742:	a1 20 50 80 00       	mov    0x805020,%eax
  800747:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80074d:	a1 20 50 80 00       	mov    0x805020,%eax
  800752:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800758:	a1 20 50 80 00       	mov    0x805020,%eax
  80075d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800763:	51                   	push   %ecx
  800764:	52                   	push   %edx
  800765:	50                   	push   %eax
  800766:	68 d8 42 80 00       	push   $0x8042d8
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 30 43 80 00       	push   $0x804330
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 88 42 80 00       	push   $0x804288
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 4f 16 00 00       	call   801df3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8007a4:	e8 19 00 00 00       	call   8007c2 <exit>
}
  8007a9:	90                   	nop
  8007aa:	c9                   	leave  
  8007ab:	c3                   	ret    

008007ac <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	e8 65 18 00 00       	call   802021 <sys_destroy_env>
  8007bc:	83 c4 10             	add    $0x10,%esp
}
  8007bf:	90                   	nop
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <exit>:

void
exit(void)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007c8:	e8 ba 18 00 00       	call   802087 <sys_exit_env>
}
  8007cd:	90                   	nop
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8007d9:	83 c0 04             	add    $0x4,%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8007e4:	85 c0                	test   %eax,%eax
  8007e6:	74 16                	je     8007fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	50                   	push   %eax
  8007f1:	68 44 43 80 00       	push   $0x804344
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 49 43 80 00       	push   $0x804349
  80080f:	e8 79 02 00 00       	call   800a8d <cprintf>
  800814:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 f4             	pushl  -0xc(%ebp)
  800820:	50                   	push   %eax
  800821:	e8 fc 01 00 00       	call   800a22 <vcprintf>
  800826:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	6a 00                	push   $0x0
  80082e:	68 65 43 80 00       	push   $0x804365
  800833:	e8 ea 01 00 00       	call   800a22 <vcprintf>
  800838:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80083b:	e8 82 ff ff ff       	call   8007c2 <exit>

	// should not return here
	while (1) ;
  800840:	eb fe                	jmp    800840 <_panic+0x70>

00800842 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800848:	a1 20 50 80 00       	mov    0x805020,%eax
  80084d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800853:	8b 45 0c             	mov    0xc(%ebp),%eax
  800856:	39 c2                	cmp    %eax,%edx
  800858:	74 14                	je     80086e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80085a:	83 ec 04             	sub    $0x4,%esp
  80085d:	68 68 43 80 00       	push   $0x804368
  800862:	6a 26                	push   $0x26
  800864:	68 b4 43 80 00       	push   $0x8043b4
  800869:	e8 62 ff ff ff       	call   8007d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800875:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80087c:	e9 c5 00 00 00       	jmp    800946 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800884:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	85 c0                	test   %eax,%eax
  800894:	75 08                	jne    80089e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800896:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800899:	e9 a5 00 00 00       	jmp    800943 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80089e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008ac:	eb 69                	jmp    800917 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8008b3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008bc:	89 d0                	mov    %edx,%eax
  8008be:	01 c0                	add    %eax,%eax
  8008c0:	01 d0                	add    %edx,%eax
  8008c2:	c1 e0 03             	shl    $0x3,%eax
  8008c5:	01 c8                	add    %ecx,%eax
  8008c7:	8a 40 04             	mov    0x4(%eax),%al
  8008ca:	84 c0                	test   %al,%al
  8008cc:	75 46                	jne    800914 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008dc:	89 d0                	mov    %edx,%eax
  8008de:	01 c0                	add    %eax,%eax
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	c1 e0 03             	shl    $0x3,%eax
  8008e5:	01 c8                	add    %ecx,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008f4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	01 c8                	add    %ecx,%eax
  800905:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800907:	39 c2                	cmp    %eax,%edx
  800909:	75 09                	jne    800914 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80090b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800912:	eb 15                	jmp    800929 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	ff 45 e8             	incl   -0x18(%ebp)
  800917:	a1 20 50 80 00       	mov    0x805020,%eax
  80091c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800925:	39 c2                	cmp    %eax,%edx
  800927:	77 85                	ja     8008ae <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800929:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80092d:	75 14                	jne    800943 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	68 c0 43 80 00       	push   $0x8043c0
  800937:	6a 3a                	push   $0x3a
  800939:	68 b4 43 80 00       	push   $0x8043b4
  80093e:	e8 8d fe ff ff       	call   8007d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800943:	ff 45 f0             	incl   -0x10(%ebp)
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80094c:	0f 8c 2f ff ff ff    	jl     800881 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800952:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800959:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800960:	eb 26                	jmp    800988 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800962:	a1 20 50 80 00       	mov    0x805020,%eax
  800967:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80096d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800970:	89 d0                	mov    %edx,%eax
  800972:	01 c0                	add    %eax,%eax
  800974:	01 d0                	add    %edx,%eax
  800976:	c1 e0 03             	shl    $0x3,%eax
  800979:	01 c8                	add    %ecx,%eax
  80097b:	8a 40 04             	mov    0x4(%eax),%al
  80097e:	3c 01                	cmp    $0x1,%al
  800980:	75 03                	jne    800985 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800982:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800985:	ff 45 e0             	incl   -0x20(%ebp)
  800988:	a1 20 50 80 00       	mov    0x805020,%eax
  80098d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800996:	39 c2                	cmp    %eax,%edx
  800998:	77 c8                	ja     800962 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80099a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009a0:	74 14                	je     8009b6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 14 44 80 00       	push   $0x804414
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 b4 43 80 00       	push   $0x8043b4
  8009b1:	e8 1a fe ff ff       	call   8007d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009b6:	90                   	nop
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	89 0a                	mov    %ecx,(%edx)
  8009cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8009cf:	88 d1                	mov    %dl,%cl
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009e2:	75 2c                	jne    800a10 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009e4:	a0 28 50 80 00       	mov    0x805028,%al
  8009e9:	0f b6 c0             	movzbl %al,%eax
  8009ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ef:	8b 12                	mov    (%edx),%edx
  8009f1:	89 d1                	mov    %edx,%ecx
  8009f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f6:	83 c2 08             	add    $0x8,%edx
  8009f9:	83 ec 04             	sub    $0x4,%esp
  8009fc:	50                   	push   %eax
  8009fd:	51                   	push   %ecx
  8009fe:	52                   	push   %edx
  8009ff:	e8 93 13 00 00       	call   801d97 <sys_cputs>
  800a04:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	8b 40 04             	mov    0x4(%eax),%eax
  800a16:	8d 50 01             	lea    0x1(%eax),%edx
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a1f:	90                   	nop
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a2b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a32:	00 00 00 
	b.cnt = 0;
  800a35:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a3c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a4b:	50                   	push   %eax
  800a4c:	68 b9 09 80 00       	push   $0x8009b9
  800a51:	e8 11 02 00 00       	call   800c67 <vprintfmt>
  800a56:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a59:	a0 28 50 80 00       	mov    0x805028,%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	50                   	push   %eax
  800a6b:	52                   	push   %edx
  800a6c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a72:	83 c0 08             	add    $0x8,%eax
  800a75:	50                   	push   %eax
  800a76:	e8 1c 13 00 00       	call   801d97 <sys_cputs>
  800a7b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a7e:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a85:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a93:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a9a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	e8 73 ff ff ff       	call   800a22 <vcprintf>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ac0:	e8 14 13 00 00       	call   801dd9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ac5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	e8 48 ff ff ff       	call   800a22 <vcprintf>
  800ada:	83 c4 10             	add    $0x10,%esp
  800add:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ae0:	e8 0e 13 00 00       	call   801df3 <sys_unlock_cons>
	return cnt;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	53                   	push   %ebx
  800aee:	83 ec 14             	sub    $0x14,%esp
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b08:	77 55                	ja     800b5f <printnum+0x75>
  800b0a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b0d:	72 05                	jb     800b14 <printnum+0x2a>
  800b0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b12:	77 4b                	ja     800b5f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b14:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b17:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b1a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	52                   	push   %edx
  800b23:	50                   	push   %eax
  800b24:	ff 75 f4             	pushl  -0xc(%ebp)
  800b27:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2a:	e8 75 33 00 00       	call   803ea4 <__udivdi3>
  800b2f:	83 c4 10             	add    $0x10,%esp
  800b32:	83 ec 04             	sub    $0x4,%esp
  800b35:	ff 75 20             	pushl  0x20(%ebp)
  800b38:	53                   	push   %ebx
  800b39:	ff 75 18             	pushl  0x18(%ebp)
  800b3c:	52                   	push   %edx
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 a1 ff ff ff       	call   800aea <printnum>
  800b49:	83 c4 20             	add    $0x20,%esp
  800b4c:	eb 1a                	jmp    800b68 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 20             	pushl  0x20(%ebp)
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b5f:	ff 4d 1c             	decl   0x1c(%ebp)
  800b62:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b66:	7f e6                	jg     800b4e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b68:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b76:	53                   	push   %ebx
  800b77:	51                   	push   %ecx
  800b78:	52                   	push   %edx
  800b79:	50                   	push   %eax
  800b7a:	e8 35 34 00 00       	call   803fb4 <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 74 46 80 00       	add    $0x804674,%eax
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f be c0             	movsbl %al,%eax
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	ff d0                	call   *%eax
  800b98:	83 c4 10             	add    $0x10,%esp
}
  800b9b:	90                   	nop
  800b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ba4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ba8:	7e 1c                	jle    800bc6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	8d 50 08             	lea    0x8(%eax),%edx
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 10                	mov    %edx,(%eax)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	83 e8 08             	sub    $0x8,%eax
  800bbf:	8b 50 04             	mov    0x4(%eax),%edx
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	eb 40                	jmp    800c06 <getuint+0x65>
	else if (lflag)
  800bc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bca:	74 1e                	je     800bea <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	8d 50 04             	lea    0x4(%eax),%edx
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	89 10                	mov    %edx,(%eax)
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	83 e8 04             	sub    $0x4,%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	eb 1c                	jmp    800c06 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8b 00                	mov    (%eax),%eax
  800bef:	8d 50 04             	lea    0x4(%eax),%edx
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 10                	mov    %edx,(%eax)
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	83 e8 04             	sub    $0x4,%eax
  800bff:	8b 00                	mov    (%eax),%eax
  800c01:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c0b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c0f:	7e 1c                	jle    800c2d <getint+0x25>
		return va_arg(*ap, long long);
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 00                	mov    (%eax),%eax
  800c16:	8d 50 08             	lea    0x8(%eax),%edx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 10                	mov    %edx,(%eax)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	83 e8 08             	sub    $0x8,%eax
  800c26:	8b 50 04             	mov    0x4(%eax),%edx
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	eb 38                	jmp    800c65 <getint+0x5d>
	else if (lflag)
  800c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c31:	74 1a                	je     800c4d <getint+0x45>
		return va_arg(*ap, long);
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	8d 50 04             	lea    0x4(%eax),%edx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 10                	mov    %edx,(%eax)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 00                	mov    (%eax),%eax
  800c45:	83 e8 04             	sub    $0x4,%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	99                   	cltd   
  800c4b:	eb 18                	jmp    800c65 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8b 00                	mov    (%eax),%eax
  800c52:	8d 50 04             	lea    0x4(%eax),%edx
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 10                	mov    %edx,(%eax)
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	83 e8 04             	sub    $0x4,%eax
  800c62:	8b 00                	mov    (%eax),%eax
  800c64:	99                   	cltd   
}
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
  800c6c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6f:	eb 17                	jmp    800c88 <vprintfmt+0x21>
			if (ch == '\0')
  800c71:	85 db                	test   %ebx,%ebx
  800c73:	0f 84 c1 03 00 00    	je     80103a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 0c             	pushl  0xc(%ebp)
  800c7f:	53                   	push   %ebx
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	ff d0                	call   *%eax
  800c85:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c88:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8b:	8d 50 01             	lea    0x1(%eax),%edx
  800c8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	0f b6 d8             	movzbl %al,%ebx
  800c96:	83 fb 25             	cmp    $0x25,%ebx
  800c99:	75 d6                	jne    800c71 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c9b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c9f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cb4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbe:	8d 50 01             	lea    0x1(%eax),%edx
  800cc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	0f b6 d8             	movzbl %al,%ebx
  800cc9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ccc:	83 f8 5b             	cmp    $0x5b,%eax
  800ccf:	0f 87 3d 03 00 00    	ja     801012 <vprintfmt+0x3ab>
  800cd5:	8b 04 85 98 46 80 00 	mov    0x804698(,%eax,4),%eax
  800cdc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cde:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ce2:	eb d7                	jmp    800cbb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ce4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ce8:	eb d1                	jmp    800cbb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cf4:	89 d0                	mov    %edx,%eax
  800cf6:	c1 e0 02             	shl    $0x2,%eax
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	01 c0                	add    %eax,%eax
  800cfd:	01 d8                	add    %ebx,%eax
  800cff:	83 e8 30             	sub    $0x30,%eax
  800d02:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d05:	8b 45 10             	mov    0x10(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d0d:	83 fb 2f             	cmp    $0x2f,%ebx
  800d10:	7e 3e                	jle    800d50 <vprintfmt+0xe9>
  800d12:	83 fb 39             	cmp    $0x39,%ebx
  800d15:	7f 39                	jg     800d50 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d17:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d1a:	eb d5                	jmp    800cf1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d30:	eb 1f                	jmp    800d51 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d36:	79 83                	jns    800cbb <vprintfmt+0x54>
				width = 0;
  800d38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d3f:	e9 77 ff ff ff       	jmp    800cbb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d44:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d4b:	e9 6b ff ff ff       	jmp    800cbb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d50:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d55:	0f 89 60 ff ff ff    	jns    800cbb <vprintfmt+0x54>
				width = precision, precision = -1;
  800d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d68:	e9 4e ff ff ff       	jmp    800cbb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d6d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d70:	e9 46 ff ff ff       	jmp    800cbb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d75:	8b 45 14             	mov    0x14(%ebp),%eax
  800d78:	83 c0 04             	add    $0x4,%eax
  800d7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d81:	83 e8 04             	sub    $0x4,%eax
  800d84:	8b 00                	mov    (%eax),%eax
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	50                   	push   %eax
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 9b 02 00 00       	jmp    801035 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800dab:	85 db                	test   %ebx,%ebx
  800dad:	79 02                	jns    800db1 <vprintfmt+0x14a>
				err = -err;
  800daf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800db1:	83 fb 64             	cmp    $0x64,%ebx
  800db4:	7f 0b                	jg     800dc1 <vprintfmt+0x15a>
  800db6:	8b 34 9d e0 44 80 00 	mov    0x8044e0(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 85 46 80 00       	push   $0x804685
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 70 02 00 00       	call   801042 <printfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dd5:	e9 5b 02 00 00       	jmp    801035 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dda:	56                   	push   %esi
  800ddb:	68 8e 46 80 00       	push   $0x80468e
  800de0:	ff 75 0c             	pushl  0xc(%ebp)
  800de3:	ff 75 08             	pushl  0x8(%ebp)
  800de6:	e8 57 02 00 00       	call   801042 <printfmt>
  800deb:	83 c4 10             	add    $0x10,%esp
			break;
  800dee:	e9 42 02 00 00       	jmp    801035 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800df3:	8b 45 14             	mov    0x14(%ebp),%eax
  800df6:	83 c0 04             	add    $0x4,%eax
  800df9:	89 45 14             	mov    %eax,0x14(%ebp)
  800dfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dff:	83 e8 04             	sub    $0x4,%eax
  800e02:	8b 30                	mov    (%eax),%esi
  800e04:	85 f6                	test   %esi,%esi
  800e06:	75 05                	jne    800e0d <vprintfmt+0x1a6>
				p = "(null)";
  800e08:	be 91 46 80 00       	mov    $0x804691,%esi
			if (width > 0 && padc != '-')
  800e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e11:	7e 6d                	jle    800e80 <vprintfmt+0x219>
  800e13:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e17:	74 67                	je     800e80 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	50                   	push   %eax
  800e20:	56                   	push   %esi
  800e21:	e8 1e 03 00 00       	call   801144 <strnlen>
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e2c:	eb 16                	jmp    800e44 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e2e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	50                   	push   %eax
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e41:	ff 4d e4             	decl   -0x1c(%ebp)
  800e44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e48:	7f e4                	jg     800e2e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e4a:	eb 34                	jmp    800e80 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e50:	74 1c                	je     800e6e <vprintfmt+0x207>
  800e52:	83 fb 1f             	cmp    $0x1f,%ebx
  800e55:	7e 05                	jle    800e5c <vprintfmt+0x1f5>
  800e57:	83 fb 7e             	cmp    $0x7e,%ebx
  800e5a:	7e 12                	jle    800e6e <vprintfmt+0x207>
					putch('?', putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	6a 3f                	push   $0x3f
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	ff d0                	call   *%eax
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	eb 0f                	jmp    800e7d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 0c             	pushl  0xc(%ebp)
  800e74:	53                   	push   %ebx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e80:	89 f0                	mov    %esi,%eax
  800e82:	8d 70 01             	lea    0x1(%eax),%esi
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f be d8             	movsbl %al,%ebx
  800e8a:	85 db                	test   %ebx,%ebx
  800e8c:	74 24                	je     800eb2 <vprintfmt+0x24b>
  800e8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e92:	78 b8                	js     800e4c <vprintfmt+0x1e5>
  800e94:	ff 4d e0             	decl   -0x20(%ebp)
  800e97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e9b:	79 af                	jns    800e4c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e9d:	eb 13                	jmp    800eb2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 20                	push   $0x20
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eaf:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb6:	7f e7                	jg     800e9f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eb8:	e9 78 01 00 00       	jmp    801035 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ec3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ec6:	50                   	push   %eax
  800ec7:	e8 3c fd ff ff       	call   800c08 <getint>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edb:	85 d2                	test   %edx,%edx
  800edd:	79 23                	jns    800f02 <vprintfmt+0x29b>
				putch('-', putdat);
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	ff 75 0c             	pushl  0xc(%ebp)
  800ee5:	6a 2d                	push   $0x2d
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	ff d0                	call   *%eax
  800eec:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef5:	f7 d8                	neg    %eax
  800ef7:	83 d2 00             	adc    $0x0,%edx
  800efa:	f7 da                	neg    %edx
  800efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 e8             	pushl  -0x18(%ebp)
  800f14:	8d 45 14             	lea    0x14(%ebp),%eax
  800f17:	50                   	push   %eax
  800f18:	e8 84 fc ff ff       	call   800ba1 <getuint>
  800f1d:	83 c4 10             	add    $0x10,%esp
  800f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f26:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f2d:	e9 98 00 00 00       	jmp    800fca <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	6a 58                	push   $0x58
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	ff d0                	call   *%eax
  800f3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 0c             	pushl  0xc(%ebp)
  800f48:	6a 58                	push   $0x58
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	6a 58                	push   $0x58
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	ff d0                	call   *%eax
  800f5f:	83 c4 10             	add    $0x10,%esp
			break;
  800f62:	e9 ce 00 00 00       	jmp    801035 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	ff 75 0c             	pushl  0xc(%ebp)
  800f6d:	6a 30                	push   $0x30
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	ff d0                	call   *%eax
  800f74:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 78                	push   $0x78
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	83 c0 04             	add    $0x4,%eax
  800f8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	83 e8 04             	sub    $0x4,%eax
  800f96:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fa2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fa9:	eb 1f                	jmp    800fca <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fb4:	50                   	push   %eax
  800fb5:	e8 e7 fb ff ff       	call   800ba1 <getuint>
  800fba:	83 c4 10             	add    $0x10,%esp
  800fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fc3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fca:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	52                   	push   %edx
  800fd5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fdc:	ff 75 f0             	pushl  -0x10(%ebp)
  800fdf:	ff 75 0c             	pushl  0xc(%ebp)
  800fe2:	ff 75 08             	pushl  0x8(%ebp)
  800fe5:	e8 00 fb ff ff       	call   800aea <printnum>
  800fea:	83 c4 20             	add    $0x20,%esp
			break;
  800fed:	eb 46                	jmp    801035 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	ff 75 0c             	pushl  0xc(%ebp)
  800ff5:	53                   	push   %ebx
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	ff d0                	call   *%eax
  800ffb:	83 c4 10             	add    $0x10,%esp
			break;
  800ffe:	eb 35                	jmp    801035 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801000:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  801007:	eb 2c                	jmp    801035 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801009:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  801010:	eb 23                	jmp    801035 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 25                	push   $0x25
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801022:	ff 4d 10             	decl   0x10(%ebp)
  801025:	eb 03                	jmp    80102a <vprintfmt+0x3c3>
  801027:	ff 4d 10             	decl   0x10(%ebp)
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	48                   	dec    %eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 25                	cmp    $0x25,%al
  801032:	75 f3                	jne    801027 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801034:	90                   	nop
		}
	}
  801035:	e9 35 fc ff ff       	jmp    800c6f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80103a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80103b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801048:	8d 45 10             	lea    0x10(%ebp),%eax
  80104b:	83 c0 04             	add    $0x4,%eax
  80104e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	ff 75 f4             	pushl  -0xc(%ebp)
  801057:	50                   	push   %eax
  801058:	ff 75 0c             	pushl  0xc(%ebp)
  80105b:	ff 75 08             	pushl  0x8(%ebp)
  80105e:	e8 04 fc ff ff       	call   800c67 <vprintfmt>
  801063:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801066:	90                   	nop
  801067:	c9                   	leave  
  801068:	c3                   	ret    

00801069 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	8b 40 08             	mov    0x8(%eax),%eax
  801072:	8d 50 01             	lea    0x1(%eax),%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8b 10                	mov    (%eax),%edx
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	8b 40 04             	mov    0x4(%eax),%eax
  801086:	39 c2                	cmp    %eax,%edx
  801088:	73 12                	jae    80109c <sprintputch+0x33>
		*b->buf++ = ch;
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	8b 00                	mov    (%eax),%eax
  80108f:	8d 48 01             	lea    0x1(%eax),%ecx
  801092:	8b 55 0c             	mov    0xc(%ebp),%edx
  801095:	89 0a                	mov    %ecx,(%edx)
  801097:	8b 55 08             	mov    0x8(%ebp),%edx
  80109a:	88 10                	mov    %dl,(%eax)
}
  80109c:	90                   	nop
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	01 d0                	add    %edx,%eax
  8010b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c4:	74 06                	je     8010cc <vsnprintf+0x2d>
  8010c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ca:	7f 07                	jg     8010d3 <vsnprintf+0x34>
		return -E_INVAL;
  8010cc:	b8 03 00 00 00       	mov    $0x3,%eax
  8010d1:	eb 20                	jmp    8010f3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010d3:	ff 75 14             	pushl  0x14(%ebp)
  8010d6:	ff 75 10             	pushl  0x10(%ebp)
  8010d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	68 69 10 80 00       	push   $0x801069
  8010e2:	e8 80 fb ff ff       	call   800c67 <vprintfmt>
  8010e7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fe:	83 c0 04             	add    $0x4,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	ff 75 f4             	pushl  -0xc(%ebp)
  80110a:	50                   	push   %eax
  80110b:	ff 75 0c             	pushl  0xc(%ebp)
  80110e:	ff 75 08             	pushl  0x8(%ebp)
  801111:	e8 89 ff ff ff       	call   80109f <vsnprintf>
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80111c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801127:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80112e:	eb 06                	jmp    801136 <strlen+0x15>
		n++;
  801130:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801133:	ff 45 08             	incl   0x8(%ebp)
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	84 c0                	test   %al,%al
  80113d:	75 f1                	jne    801130 <strlen+0xf>
		n++;
	return n;
  80113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801151:	eb 09                	jmp    80115c <strnlen+0x18>
		n++;
  801153:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801156:	ff 45 08             	incl   0x8(%ebp)
  801159:	ff 4d 0c             	decl   0xc(%ebp)
  80115c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801160:	74 09                	je     80116b <strnlen+0x27>
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	75 e8                	jne    801153 <strnlen+0xf>
		n++;
	return n;
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80117c:	90                   	nop
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8d 50 01             	lea    0x1(%eax),%edx
  801183:	89 55 08             	mov    %edx,0x8(%ebp)
  801186:	8b 55 0c             	mov    0xc(%ebp),%edx
  801189:	8d 4a 01             	lea    0x1(%edx),%ecx
  80118c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80118f:	8a 12                	mov    (%edx),%dl
  801191:	88 10                	mov    %dl,(%eax)
  801193:	8a 00                	mov    (%eax),%al
  801195:	84 c0                	test   %al,%al
  801197:	75 e4                	jne    80117d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801199:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b1:	eb 1f                	jmp    8011d2 <strncpy+0x34>
		*dst++ = *src;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8d 50 01             	lea    0x1(%eax),%edx
  8011b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bf:	8a 12                	mov    (%edx),%dl
  8011c1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	84 c0                	test   %al,%al
  8011ca:	74 03                	je     8011cf <strncpy+0x31>
			src++;
  8011cc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011cf:	ff 45 fc             	incl   -0x4(%ebp)
  8011d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d8:	72 d9                	jb     8011b3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ef:	74 30                	je     801221 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011f1:	eb 16                	jmp    801209 <strlcpy+0x2a>
			*dst++ = *src++;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801202:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801205:	8a 12                	mov    (%edx),%dl
  801207:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801209:	ff 4d 10             	decl   0x10(%ebp)
  80120c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801210:	74 09                	je     80121b <strlcpy+0x3c>
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	75 d8                	jne    8011f3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801227:	29 c2                	sub    %eax,%edx
  801229:	89 d0                	mov    %edx,%eax
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801230:	eb 06                	jmp    801238 <strcmp+0xb>
		p++, q++;
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	84 c0                	test   %al,%al
  80123f:	74 0e                	je     80124f <strcmp+0x22>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 10                	mov    (%eax),%dl
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	38 c2                	cmp    %al,%dl
  80124d:	74 e3                	je     801232 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	0f b6 d0             	movzbl %al,%edx
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	0f b6 c0             	movzbl %al,%eax
  80125f:	29 c2                	sub    %eax,%edx
  801261:	89 d0                	mov    %edx,%eax
}
  801263:	5d                   	pop    %ebp
  801264:	c3                   	ret    

00801265 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801268:	eb 09                	jmp    801273 <strncmp+0xe>
		n--, p++, q++;
  80126a:	ff 4d 10             	decl   0x10(%ebp)
  80126d:	ff 45 08             	incl   0x8(%ebp)
  801270:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	74 17                	je     801290 <strncmp+0x2b>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 0e                	je     801290 <strncmp+0x2b>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 10                	mov    (%eax),%dl
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	38 c2                	cmp    %al,%dl
  80128e:	74 da                	je     80126a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801294:	75 07                	jne    80129d <strncmp+0x38>
		return 0;
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	eb 14                	jmp    8012b1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	0f b6 d0             	movzbl %al,%edx
  8012a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	0f b6 c0             	movzbl %al,%eax
  8012ad:	29 c2                	sub    %eax,%edx
  8012af:	89 d0                	mov    %edx,%eax
}
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012bf:	eb 12                	jmp    8012d3 <strchr+0x20>
		if (*s == c)
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012c9:	75 05                	jne    8012d0 <strchr+0x1d>
			return (char *) s;
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	eb 11                	jmp    8012e1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012d0:	ff 45 08             	incl   0x8(%ebp)
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 e5                	jne    8012c1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 04             	sub    $0x4,%esp
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012ef:	eb 0d                	jmp    8012fe <strfind+0x1b>
		if (*s == c)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012f9:	74 0e                	je     801309 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012fb:	ff 45 08             	incl   0x8(%ebp)
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	84 c0                	test   %al,%al
  801305:	75 ea                	jne    8012f1 <strfind+0xe>
  801307:	eb 01                	jmp    80130a <strfind+0x27>
		if (*s == c)
			break;
  801309:	90                   	nop
	return (char *) s;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801321:	eb 0e                	jmp    801331 <memset+0x22>
		*p++ = c;
  801323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801326:	8d 50 01             	lea    0x1(%eax),%edx
  801329:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801331:	ff 4d f8             	decl   -0x8(%ebp)
  801334:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801338:	79 e9                	jns    801323 <memset+0x14>
		*p++ = c;

	return v;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801351:	eb 16                	jmp    801369 <memcpy+0x2a>
		*d++ = *s++;
  801353:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801356:	8d 50 01             	lea    0x1(%eax),%edx
  801359:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80135c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801362:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801365:	8a 12                	mov    (%edx),%dl
  801367:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136f:	89 55 10             	mov    %edx,0x10(%ebp)
  801372:	85 c0                	test   %eax,%eax
  801374:	75 dd                	jne    801353 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801390:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801393:	73 50                	jae    8013e5 <memmove+0x6a>
  801395:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 d0                	add    %edx,%eax
  80139d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013a0:	76 43                	jbe    8013e5 <memmove+0x6a>
		s += n;
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ab:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013ae:	eb 10                	jmp    8013c0 <memmove+0x45>
			*--d = *--s;
  8013b0:	ff 4d f8             	decl   -0x8(%ebp)
  8013b3:	ff 4d fc             	decl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	8a 10                	mov    (%eax),%dl
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013be:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	75 e3                	jne    8013b0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013cd:	eb 23                	jmp    8013f2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d2:	8d 50 01             	lea    0x1(%eax),%edx
  8013d5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013de:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013e1:	8a 12                	mov    (%edx),%dl
  8013e3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 dd                	jne    8013cf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801409:	eb 2a                	jmp    801435 <memcmp+0x3e>
		if (*s1 != *s2)
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8a 10                	mov    (%eax),%dl
  801410:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	38 c2                	cmp    %al,%dl
  801417:	74 16                	je     80142f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	0f b6 d0             	movzbl %al,%edx
  801421:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	0f b6 c0             	movzbl %al,%eax
  801429:	29 c2                	sub    %eax,%edx
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	eb 18                	jmp    801447 <memcmp+0x50>
		s1++, s2++;
  80142f:	ff 45 fc             	incl   -0x4(%ebp)
  801432:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	8d 50 ff             	lea    -0x1(%eax),%edx
  80143b:	89 55 10             	mov    %edx,0x10(%ebp)
  80143e:	85 c0                	test   %eax,%eax
  801440:	75 c9                	jne    80140b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80144f:	8b 55 08             	mov    0x8(%ebp),%edx
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80145a:	eb 15                	jmp    801471 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f b6 d0             	movzbl %al,%edx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	0f b6 c0             	movzbl %al,%eax
  80146a:	39 c2                	cmp    %eax,%edx
  80146c:	74 0d                	je     80147b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801477:	72 e3                	jb     80145c <memfind+0x13>
  801479:	eb 01                	jmp    80147c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80147b:	90                   	nop
	return (void *) s;
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80148e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801495:	eb 03                	jmp    80149a <strtol+0x19>
		s++;
  801497:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	3c 20                	cmp    $0x20,%al
  8014a1:	74 f4                	je     801497 <strtol+0x16>
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	3c 09                	cmp    $0x9,%al
  8014aa:	74 eb                	je     801497 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	3c 2b                	cmp    $0x2b,%al
  8014b3:	75 05                	jne    8014ba <strtol+0x39>
		s++;
  8014b5:	ff 45 08             	incl   0x8(%ebp)
  8014b8:	eb 13                	jmp    8014cd <strtol+0x4c>
	else if (*s == '-')
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 2d                	cmp    $0x2d,%al
  8014c1:	75 0a                	jne    8014cd <strtol+0x4c>
		s++, neg = 1;
  8014c3:	ff 45 08             	incl   0x8(%ebp)
  8014c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d1:	74 06                	je     8014d9 <strtol+0x58>
  8014d3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014d7:	75 20                	jne    8014f9 <strtol+0x78>
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	3c 30                	cmp    $0x30,%al
  8014e0:	75 17                	jne    8014f9 <strtol+0x78>
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	40                   	inc    %eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	3c 78                	cmp    $0x78,%al
  8014ea:	75 0d                	jne    8014f9 <strtol+0x78>
		s += 2, base = 16;
  8014ec:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014f0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014f7:	eb 28                	jmp    801521 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014fd:	75 15                	jne    801514 <strtol+0x93>
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	3c 30                	cmp    $0x30,%al
  801506:	75 0c                	jne    801514 <strtol+0x93>
		s++, base = 8;
  801508:	ff 45 08             	incl   0x8(%ebp)
  80150b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801512:	eb 0d                	jmp    801521 <strtol+0xa0>
	else if (base == 0)
  801514:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801518:	75 07                	jne    801521 <strtol+0xa0>
		base = 10;
  80151a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	3c 2f                	cmp    $0x2f,%al
  801528:	7e 19                	jle    801543 <strtol+0xc2>
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	3c 39                	cmp    $0x39,%al
  801531:	7f 10                	jg     801543 <strtol+0xc2>
			dig = *s - '0';
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	0f be c0             	movsbl %al,%eax
  80153b:	83 e8 30             	sub    $0x30,%eax
  80153e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801541:	eb 42                	jmp    801585 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	3c 60                	cmp    $0x60,%al
  80154a:	7e 19                	jle    801565 <strtol+0xe4>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	3c 7a                	cmp    $0x7a,%al
  801553:	7f 10                	jg     801565 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f be c0             	movsbl %al,%eax
  80155d:	83 e8 57             	sub    $0x57,%eax
  801560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801563:	eb 20                	jmp    801585 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 40                	cmp    $0x40,%al
  80156c:	7e 39                	jle    8015a7 <strtol+0x126>
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	3c 5a                	cmp    $0x5a,%al
  801575:	7f 30                	jg     8015a7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	0f be c0             	movsbl %al,%eax
  80157f:	83 e8 37             	sub    $0x37,%eax
  801582:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801588:	3b 45 10             	cmp    0x10(%ebp),%eax
  80158b:	7d 19                	jge    8015a6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80158d:	ff 45 08             	incl   0x8(%ebp)
  801590:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801593:	0f af 45 10          	imul   0x10(%ebp),%eax
  801597:	89 c2                	mov    %eax,%edx
  801599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159c:	01 d0                	add    %edx,%eax
  80159e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015a1:	e9 7b ff ff ff       	jmp    801521 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015a6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ab:	74 08                	je     8015b5 <strtol+0x134>
		*endptr = (char *) s;
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b9:	74 07                	je     8015c2 <strtol+0x141>
  8015bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015be:	f7 d8                	neg    %eax
  8015c0:	eb 03                	jmp    8015c5 <strtol+0x144>
  8015c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <ltostr>:

void
ltostr(long value, char *str)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015df:	79 13                	jns    8015f4 <ltostr+0x2d>
	{
		neg = 1;
  8015e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015ee:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015f1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015fc:	99                   	cltd   
  8015fd:	f7 f9                	idiv   %ecx
  8015ff:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801602:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801605:	8d 50 01             	lea    0x1(%eax),%edx
  801608:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80160b:	89 c2                	mov    %eax,%edx
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801615:	83 c2 30             	add    $0x30,%edx
  801618:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80161a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801622:	f7 e9                	imul   %ecx
  801624:	c1 fa 02             	sar    $0x2,%edx
  801627:	89 c8                	mov    %ecx,%eax
  801629:	c1 f8 1f             	sar    $0x1f,%eax
  80162c:	29 c2                	sub    %eax,%edx
  80162e:	89 d0                	mov    %edx,%eax
  801630:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801633:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801637:	75 bb                	jne    8015f4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801640:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801643:	48                   	dec    %eax
  801644:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801647:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80164b:	74 3d                	je     80168a <ltostr+0xc3>
		start = 1 ;
  80164d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801654:	eb 34                	jmp    80168a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165c:	01 d0                	add    %edx,%eax
  80165e:	8a 00                	mov    (%eax),%al
  801660:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c2                	add    %eax,%edx
  80166b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80166e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801671:	01 c8                	add    %ecx,%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801677:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	01 c2                	add    %eax,%edx
  80167f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801682:	88 02                	mov    %al,(%edx)
		start++ ;
  801684:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801687:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801690:	7c c4                	jl     801656 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801692:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801695:	8b 45 0c             	mov    0xc(%ebp),%eax
  801698:	01 d0                	add    %edx,%eax
  80169a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80169d:	90                   	nop
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016a6:	ff 75 08             	pushl  0x8(%ebp)
  8016a9:	e8 73 fa ff ff       	call   801121 <strlen>
  8016ae:	83 c4 04             	add    $0x4,%esp
  8016b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	e8 65 fa ff ff       	call   801121 <strlen>
  8016bc:	83 c4 04             	add    $0x4,%esp
  8016bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016d0:	eb 17                	jmp    8016e9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	01 c2                	add    %eax,%edx
  8016da:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	01 c8                	add    %ecx,%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016e6:	ff 45 fc             	incl   -0x4(%ebp)
  8016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016ef:	7c e1                	jl     8016d2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ff:	eb 1f                	jmp    801720 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801701:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801704:	8d 50 01             	lea    0x1(%eax),%edx
  801707:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80170a:	89 c2                	mov    %eax,%edx
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	01 c2                	add    %eax,%edx
  801711:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801714:	8b 45 0c             	mov    0xc(%ebp),%eax
  801717:	01 c8                	add    %ecx,%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80171d:	ff 45 f8             	incl   -0x8(%ebp)
  801720:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801723:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801726:	7c d9                	jl     801701 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801728:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172b:	8b 45 10             	mov    0x10(%ebp),%eax
  80172e:	01 d0                	add    %edx,%eax
  801730:	c6 00 00             	movb   $0x0,(%eax)
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801739:	8b 45 14             	mov    0x14(%ebp),%eax
  80173c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801742:	8b 45 14             	mov    0x14(%ebp),%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174e:	8b 45 10             	mov    0x10(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801759:	eb 0c                	jmp    801767 <strsplit+0x31>
			*string++ = 0;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8d 50 01             	lea    0x1(%eax),%edx
  801761:	89 55 08             	mov    %edx,0x8(%ebp)
  801764:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	84 c0                	test   %al,%al
  80176e:	74 18                	je     801788 <strsplit+0x52>
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	0f be c0             	movsbl %al,%eax
  801778:	50                   	push   %eax
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	e8 32 fb ff ff       	call   8012b3 <strchr>
  801781:	83 c4 08             	add    $0x8,%esp
  801784:	85 c0                	test   %eax,%eax
  801786:	75 d3                	jne    80175b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	84 c0                	test   %al,%al
  80178f:	74 5a                	je     8017eb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801791:	8b 45 14             	mov    0x14(%ebp),%eax
  801794:	8b 00                	mov    (%eax),%eax
  801796:	83 f8 0f             	cmp    $0xf,%eax
  801799:	75 07                	jne    8017a2 <strsplit+0x6c>
		{
			return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a0:	eb 66                	jmp    801808 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8017aa:	8b 55 14             	mov    0x14(%ebp),%edx
  8017ad:	89 0a                	mov    %ecx,(%edx)
  8017af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b9:	01 c2                	add    %eax,%edx
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017c0:	eb 03                	jmp    8017c5 <strsplit+0x8f>
			string++;
  8017c2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	84 c0                	test   %al,%al
  8017cc:	74 8b                	je     801759 <strsplit+0x23>
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	0f be c0             	movsbl %al,%eax
  8017d6:	50                   	push   %eax
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	e8 d4 fa ff ff       	call   8012b3 <strchr>
  8017df:	83 c4 08             	add    $0x8,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	74 dc                	je     8017c2 <strsplit+0x8c>
			string++;
	}
  8017e6:	e9 6e ff ff ff       	jmp    801759 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017eb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	01 d0                	add    %edx,%eax
  8017fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801803:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	68 08 48 80 00       	push   $0x804808
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 2a 48 80 00       	push   $0x80482a
  801822:	e8 a9 ef ff ff       	call   8007d0 <_panic>

00801827 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	e8 0a 0b 00 00       	call   802342 <sys_sbrk>
  801838:	83 c4 10             	add    $0x10,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801847:	75 0a                	jne    801853 <malloc+0x16>
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
  80184e:	e9 07 02 00 00       	jmp    801a5a <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801853:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80185a:	8b 55 08             	mov    0x8(%ebp),%edx
  80185d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	48                   	dec    %eax
  801863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801866:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801869:	ba 00 00 00 00       	mov    $0x0,%edx
  80186e:	f7 75 dc             	divl   -0x24(%ebp)
  801871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801874:	29 d0                	sub    %edx,%eax
  801876:	c1 e8 0c             	shr    $0xc,%eax
  801879:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80187c:	a1 20 50 80 00       	mov    0x805020,%eax
  801881:	8b 40 78             	mov    0x78(%eax),%eax
  801884:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801889:	29 c2                	sub    %eax,%edx
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801890:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801893:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801898:	c1 e8 0c             	shr    $0xc,%eax
  80189b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80189e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018a5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018ac:	77 42                	ja     8018f0 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ae:	e8 13 09 00 00       	call   8021c6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 53 0e 00 00       	call   802715 <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 25 09 00 00       	call   8021f7 <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 ec 12 00 00       	call   802bd1 <alloc_block_BF>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018eb:	e9 67 01 00 00       	jmp    801a57 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8018f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018f3:	48                   	dec    %eax
  8018f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018f7:	0f 86 53 01 00 00    	jbe    801a50 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8018fd:	a1 20 50 80 00       	mov    0x805020,%eax
  801902:	8b 40 78             	mov    0x78(%eax),%eax
  801905:	05 00 10 00 00       	add    $0x1000,%eax
  80190a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80190d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801914:	e9 de 00 00 00       	jmp    8019f7 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801919:	a1 20 50 80 00       	mov    0x805020,%eax
  80191e:	8b 40 78             	mov    0x78(%eax),%eax
  801921:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801924:	29 c2                	sub    %eax,%edx
  801926:	89 d0                	mov    %edx,%eax
  801928:	2d 00 10 00 00       	sub    $0x1000,%eax
  80192d:	c1 e8 0c             	shr    $0xc,%eax
  801930:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801937:	85 c0                	test   %eax,%eax
  801939:	0f 85 ab 00 00 00    	jne    8019ea <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	05 00 10 00 00       	add    $0x1000,%eax
  801947:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80194a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801951:	eb 47                	jmp    80199a <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801953:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80195a:	76 0a                	jbe    801966 <malloc+0x129>
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	e9 f4 00 00 00       	jmp    801a5a <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801966:	a1 20 50 80 00       	mov    0x805020,%eax
  80196b:	8b 40 78             	mov    0x78(%eax),%eax
  80196e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801971:	29 c2                	sub    %eax,%edx
  801973:	89 d0                	mov    %edx,%eax
  801975:	2d 00 10 00 00       	sub    $0x1000,%eax
  80197a:	c1 e8 0c             	shr    $0xc,%eax
  80197d:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801984:	85 c0                	test   %eax,%eax
  801986:	74 08                	je     801990 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80198e:	eb 5a                	jmp    8019ea <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801990:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801997:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80199a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80199d:	48                   	dec    %eax
  80199e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019a1:	77 b0                	ja     801953 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8019a3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8019aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019b1:	eb 2f                	jmp    8019e2 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8019b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b6:	c1 e0 0c             	shl    $0xc,%eax
  8019b9:	89 c2                	mov    %eax,%edx
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019be:	01 c2                	add    %eax,%edx
  8019c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8019c5:	8b 40 78             	mov    0x78(%eax),%eax
  8019c8:	29 c2                	sub    %eax,%edx
  8019ca:	89 d0                	mov    %edx,%eax
  8019cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019d1:	c1 e8 0c             	shr    $0xc,%eax
  8019d4:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8019db:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8019df:	ff 45 e0             	incl   -0x20(%ebp)
  8019e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8019e8:	72 c9                	jb     8019b3 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8019ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ee:	75 16                	jne    801a06 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8019f0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8019f7:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019fe:	0f 86 15 ff ff ff    	jbe    801919 <malloc+0xdc>
  801a04:	eb 01                	jmp    801a07 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801a06:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801a07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a0b:	75 07                	jne    801a14 <malloc+0x1d7>
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	eb 46                	jmp    801a5a <malloc+0x21d>
		ptr = (void*)i;
  801a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801a1a:	a1 20 50 80 00       	mov    0x805020,%eax
  801a1f:	8b 40 78             	mov    0x78(%eax),%eax
  801a22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a25:	29 c2                	sub    %eax,%edx
  801a27:	89 d0                	mov    %edx,%eax
  801a29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a2e:	c1 e8 0c             	shr    $0xc,%eax
  801a31:	89 c2                	mov    %eax,%edx
  801a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a36:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	ff 75 f0             	pushl  -0x10(%ebp)
  801a46:	e8 2e 09 00 00       	call   802379 <sys_allocate_user_mem>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	eb 07                	jmp    801a57 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
  801a55:	eb 03                	jmp    801a5a <malloc+0x21d>
	}
	return ptr;
  801a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801a62:	a1 20 50 80 00       	mov    0x805020,%eax
  801a67:	8b 40 78             	mov    0x78(%eax),%eax
  801a6a:	05 00 10 00 00       	add    $0x1000,%eax
  801a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801a72:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801a79:	a1 20 50 80 00       	mov    0x805020,%eax
  801a7e:	8b 50 78             	mov    0x78(%eax),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	39 c2                	cmp    %eax,%edx
  801a86:	76 24                	jbe    801aac <free+0x50>
		size = get_block_size(va);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 08             	pushl  0x8(%ebp)
  801a8e:	e8 02 09 00 00       	call   802395 <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 35 1b 00 00       	call   8035d9 <free_block>
  801aa4:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801aa7:	e9 ac 00 00 00       	jmp    801b58 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ab2:	0f 82 89 00 00 00    	jb     801b41 <free+0xe5>
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801ac0:	77 7f                	ja     801b41 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac5:	a1 20 50 80 00       	mov    0x805020,%eax
  801aca:	8b 40 78             	mov    0x78(%eax),%eax
  801acd:	29 c2                	sub    %eax,%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ad6:	c1 e8 0c             	shr    $0xc,%eax
  801ad9:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae6:	c1 e0 0c             	shl    $0xc,%eax
  801ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801af3:	eb 2f                	jmp    801b24 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	c1 e0 0c             	shl    $0xc,%eax
  801afb:	89 c2                	mov    %eax,%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	01 c2                	add    %eax,%edx
  801b02:	a1 20 50 80 00       	mov    0x805020,%eax
  801b07:	8b 40 78             	mov    0x78(%eax),%eax
  801b0a:	29 c2                	sub    %eax,%edx
  801b0c:	89 d0                	mov    %edx,%eax
  801b0e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b13:	c1 e8 0c             	shr    $0xc,%eax
  801b16:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801b1d:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801b21:	ff 45 f4             	incl   -0xc(%ebp)
  801b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b27:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b2a:	72 c9                	jb     801af5 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 ec             	pushl  -0x14(%ebp)
  801b35:	50                   	push   %eax
  801b36:	e8 22 08 00 00       	call   80235d <sys_free_user_mem>
  801b3b:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801b3e:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801b3f:	eb 17                	jmp    801b58 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	68 38 48 80 00       	push   $0x804838
  801b49:	68 85 00 00 00       	push   $0x85
  801b4e:	68 62 48 80 00       	push   $0x804862
  801b53:	e8 78 ec ff ff       	call   8007d0 <_panic>
	}
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 28             	sub    $0x28,%esp
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b6a:	75 0a                	jne    801b76 <smalloc+0x1c>
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b71:	e9 9a 00 00 00       	jmp    801c10 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	39 d0                	cmp    %edx,%eax
  801b8b:	73 02                	jae    801b8f <smalloc+0x35>
  801b8d:	89 d0                	mov    %edx,%eax
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	50                   	push   %eax
  801b93:	e8 a5 fc ff ff       	call   80183d <malloc>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801b9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ba2:	75 07                	jne    801bab <smalloc+0x51>
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba9:	eb 65                	jmp    801c10 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bab:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801baf:	ff 75 ec             	pushl  -0x14(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	e8 a6 03 00 00       	call   801f64 <sys_createSharedObject>
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801bc4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bc8:	74 06                	je     801bd0 <smalloc+0x76>
  801bca:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bce:	75 07                	jne    801bd7 <smalloc+0x7d>
  801bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd5:	eb 39                	jmp    801c10 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801bd7:	83 ec 08             	sub    $0x8,%esp
  801bda:	ff 75 ec             	pushl  -0x14(%ebp)
  801bdd:	68 6e 48 80 00       	push   $0x80486e
  801be2:	e8 a6 ee ff ff       	call   800a8d <cprintf>
  801be7:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801bea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bed:	a1 20 50 80 00       	mov    0x805020,%eax
  801bf2:	8b 40 78             	mov    0x78(%eax),%eax
  801bf5:	29 c2                	sub    %eax,%edx
  801bf7:	89 d0                	mov    %edx,%eax
  801bf9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bfe:	c1 e8 0c             	shr    $0xc,%eax
  801c01:	89 c2                	mov    %eax,%edx
  801c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c06:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 68 03 00 00       	call   801f8e <sys_getSizeOfSharedObject>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c2c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c30:	75 07                	jne    801c39 <sget+0x27>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 7f                	jmp    801cb8 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c3f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4c:	39 d0                	cmp    %edx,%eax
  801c4e:	7d 02                	jge    801c52 <sget+0x40>
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	50                   	push   %eax
  801c56:	e8 e2 fb ff ff       	call   80183d <malloc>
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c65:	75 07                	jne    801c6e <sget+0x5c>
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6c:	eb 4a                	jmp    801cb8 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	ff 75 e8             	pushl  -0x18(%ebp)
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	e8 2c 03 00 00       	call   801fab <sys_getSharedObject>
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c88:	a1 20 50 80 00       	mov    0x805020,%eax
  801c8d:	8b 40 78             	mov    0x78(%eax),%eax
  801c90:	29 c2                	sub    %eax,%edx
  801c92:	89 d0                	mov    %edx,%eax
  801c94:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c99:	c1 e8 0c             	shr    $0xc,%eax
  801c9c:	89 c2                	mov    %eax,%edx
  801c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca1:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ca8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801cac:	75 07                	jne    801cb5 <sget+0xa3>
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	eb 03                	jmp    801cb8 <sget+0xa6>
	return ptr;
  801cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc3:	a1 20 50 80 00       	mov    0x805020,%eax
  801cc8:	8b 40 78             	mov    0x78(%eax),%eax
  801ccb:	29 c2                	sub    %eax,%edx
  801ccd:	89 d0                	mov    %edx,%eax
  801ccf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cd4:	c1 e8 0c             	shr    $0xc,%eax
  801cd7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801ce1:	83 ec 08             	sub    $0x8,%esp
  801ce4:	ff 75 08             	pushl  0x8(%ebp)
  801ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cea:	e8 db 02 00 00       	call   801fca <sys_freeSharedObject>
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801cf5:	90                   	nop
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	68 80 48 80 00       	push   $0x804880
  801d06:	68 de 00 00 00       	push   $0xde
  801d0b:	68 62 48 80 00       	push   $0x804862
  801d10:	e8 bb ea ff ff       	call   8007d0 <_panic>

00801d15 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	68 a6 48 80 00       	push   $0x8048a6
  801d23:	68 ea 00 00 00       	push   $0xea
  801d28:	68 62 48 80 00       	push   $0x804862
  801d2d:	e8 9e ea ff ff       	call   8007d0 <_panic>

00801d32 <shrink>:

}
void shrink(uint32 newSize)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	68 a6 48 80 00       	push   $0x8048a6
  801d40:	68 ef 00 00 00       	push   $0xef
  801d45:	68 62 48 80 00       	push   $0x804862
  801d4a:	e8 81 ea ff ff       	call   8007d0 <_panic>

00801d4f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	68 a6 48 80 00       	push   $0x8048a6
  801d5d:	68 f4 00 00 00       	push   $0xf4
  801d62:	68 62 48 80 00       	push   $0x804862
  801d67:	e8 64 ea ff ff       	call   8007d0 <_panic>

00801d6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	57                   	push   %edi
  801d70:	56                   	push   %esi
  801d71:	53                   	push   %ebx
  801d72:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d81:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d84:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d87:	cd 30                	int    $0x30
  801d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5e                   	pop    %esi
  801d94:	5f                   	pop    %edi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801da0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801da3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	52                   	push   %edx
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	50                   	push   %eax
  801db3:	6a 00                	push   $0x0
  801db5:	e8 b2 ff ff ff       	call   801d6c <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 02                	push   $0x2
  801dcf:	e8 98 ff ff ff       	call   801d6c <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 03                	push   $0x3
  801de8:	e8 7f ff ff ff       	call   801d6c <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 04                	push   $0x4
  801e02:	e8 65 ff ff ff       	call   801d6c <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 08                	push   $0x8
  801e20:	e8 47 ff ff ff       	call   801d6c <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	56                   	push   %esi
  801e2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e2f:	8b 75 18             	mov    0x18(%ebp),%esi
  801e32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	51                   	push   %ecx
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 09                	push   $0x9
  801e45:	e8 22 ff ff ff       	call   801d6c <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	6a 0a                	push   $0xa
  801e67:	e8 00 ff ff ff       	call   801d6c <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 0b                	push   $0xb
  801e82:	e8 e5 fe ff ff       	call   801d6c <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 0c                	push   $0xc
  801e9b:	e8 cc fe ff ff       	call   801d6c <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 0d                	push   $0xd
  801eb4:	e8 b3 fe ff ff       	call   801d6c <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 0e                	push   $0xe
  801ecd:	e8 9a fe ff ff       	call   801d6c <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 0f                	push   $0xf
  801ee6:	e8 81 fe ff ff       	call   801d6c <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	6a 10                	push   $0x10
  801f00:	e8 67 fe ff ff       	call   801d6c <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 11                	push   $0x11
  801f19:	e8 4e fe ff ff       	call   801d6c <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	90                   	nop
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	50                   	push   %eax
  801f3d:	6a 01                	push   $0x1
  801f3f:	e8 28 fe ff ff       	call   801d6c <syscall>
  801f44:	83 c4 18             	add    $0x18,%esp
}
  801f47:	90                   	nop
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 14                	push   $0x14
  801f59:	e8 0e fe ff ff       	call   801d6c <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	51                   	push   %ecx
  801f7d:	52                   	push   %edx
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	50                   	push   %eax
  801f82:	6a 15                	push   $0x15
  801f84:	e8 e3 fd ff ff       	call   801d6c <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	52                   	push   %edx
  801f9e:	50                   	push   %eax
  801f9f:	6a 16                	push   $0x16
  801fa1:	e8 c6 fd ff ff       	call   801d6c <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	51                   	push   %ecx
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	6a 17                	push   $0x17
  801fc0:	e8 a7 fd ff ff       	call   801d6c <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 18                	push   $0x18
  801fdd:	e8 8a fd ff ff       	call   801d6c <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	ff 75 14             	pushl  0x14(%ebp)
  801ff2:	ff 75 10             	pushl  0x10(%ebp)
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	50                   	push   %eax
  801ff9:	6a 19                	push   $0x19
  801ffb:	e8 6c fd ff ff       	call   801d6c <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	50                   	push   %eax
  802014:	6a 1a                	push   $0x1a
  802016:	e8 51 fd ff ff       	call   801d6c <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	90                   	nop
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	50                   	push   %eax
  802030:	6a 1b                	push   $0x1b
  802032:	e8 35 fd ff ff       	call   801d6c <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 05                	push   $0x5
  80204b:	e8 1c fd ff ff       	call   801d6c <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 06                	push   $0x6
  802064:	e8 03 fd ff ff       	call   801d6c <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 07                	push   $0x7
  80207d:	e8 ea fc ff ff       	call   801d6c <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_exit_env>:


void sys_exit_env(void)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 1c                	push   $0x1c
  802096:	e8 d1 fc ff ff       	call   801d6c <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	90                   	nop
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020aa:	8d 50 04             	lea    0x4(%eax),%edx
  8020ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	52                   	push   %edx
  8020b7:	50                   	push   %eax
  8020b8:	6a 1d                	push   $0x1d
  8020ba:	e8 ad fc ff ff       	call   801d6c <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
	return result;
  8020c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020cb:	89 01                	mov    %eax,(%ecx)
  8020cd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	c9                   	leave  
  8020d4:	c2 04 00             	ret    $0x4

008020d7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	ff 75 10             	pushl  0x10(%ebp)
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	6a 13                	push   $0x13
  8020e9:	e8 7e fc ff ff       	call   801d6c <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f1:	90                   	nop
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 1e                	push   $0x1e
  802103:	e8 64 fc ff ff       	call   801d6c <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802119:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	50                   	push   %eax
  802126:	6a 1f                	push   $0x1f
  802128:	e8 3f fc ff ff       	call   801d6c <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
	return ;
  802130:	90                   	nop
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <rsttst>:
void rsttst()
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 21                	push   $0x21
  802142:	e8 25 fc ff ff       	call   801d6c <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
	return ;
  80214a:	90                   	nop
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	8b 45 14             	mov    0x14(%ebp),%eax
  802156:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802159:	8b 55 18             	mov    0x18(%ebp),%edx
  80215c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802160:	52                   	push   %edx
  802161:	50                   	push   %eax
  802162:	ff 75 10             	pushl  0x10(%ebp)
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	6a 20                	push   $0x20
  80216d:	e8 fa fb ff ff       	call   801d6c <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return ;
  802175:	90                   	nop
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <chktst>:
void chktst(uint32 n)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	6a 22                	push   $0x22
  802188:	e8 df fb ff ff       	call   801d6c <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
	return ;
  802190:	90                   	nop
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <inctst>:

void inctst()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 23                	push   $0x23
  8021a2:	e8 c5 fb ff ff       	call   801d6c <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021aa:	90                   	nop
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <gettst>:
uint32 gettst()
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 24                	push   $0x24
  8021bc:	e8 ab fb ff ff       	call   801d6c <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 25                	push   $0x25
  8021d8:	e8 8f fb ff ff       	call   801d6c <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
  8021e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021e3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021e7:	75 07                	jne    8021f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ee:	eb 05                	jmp    8021f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 25                	push   $0x25
  802209:	e8 5e fb ff ff       	call   801d6c <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
  802211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802214:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802218:	75 07                	jne    802221 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80221a:	b8 01 00 00 00       	mov    $0x1,%eax
  80221f:	eb 05                	jmp    802226 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 25                	push   $0x25
  80223a:	e8 2d fb ff ff       	call   801d6c <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
  802242:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802245:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802249:	75 07                	jne    802252 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80224b:	b8 01 00 00 00       	mov    $0x1,%eax
  802250:	eb 05                	jmp    802257 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802252:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 25                	push   $0x25
  80226b:	e8 fc fa ff ff       	call   801d6c <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
  802273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802276:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80227a:	75 07                	jne    802283 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80227c:	b8 01 00 00 00       	mov    $0x1,%eax
  802281:	eb 05                	jmp    802288 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	ff 75 08             	pushl  0x8(%ebp)
  802298:	6a 26                	push   $0x26
  80229a:	e8 cd fa ff ff       	call   801d6c <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a2:	90                   	nop
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	53                   	push   %ebx
  8022b8:	51                   	push   %ecx
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 27                	push   $0x27
  8022bd:	e8 aa fa ff ff       	call   801d6c <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	52                   	push   %edx
  8022da:	50                   	push   %eax
  8022db:	6a 28                	push   $0x28
  8022dd:	e8 8a fa ff ff       	call   801d6c <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8022ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	51                   	push   %ecx
  8022f6:	ff 75 10             	pushl  0x10(%ebp)
  8022f9:	52                   	push   %edx
  8022fa:	50                   	push   %eax
  8022fb:	6a 29                	push   $0x29
  8022fd:	e8 6a fa ff ff       	call   801d6c <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	ff 75 10             	pushl  0x10(%ebp)
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	ff 75 08             	pushl  0x8(%ebp)
  802317:	6a 12                	push   $0x12
  802319:	e8 4e fa ff ff       	call   801d6c <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
	return ;
  802321:	90                   	nop
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	52                   	push   %edx
  802334:	50                   	push   %eax
  802335:	6a 2a                	push   $0x2a
  802337:	e8 30 fa ff ff       	call   801d6c <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
	return;
  80233f:	90                   	nop
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	50                   	push   %eax
  802351:	6a 2b                	push   $0x2b
  802353:	e8 14 fa ff ff       	call   801d6c <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 2c                	push   $0x2c
  80236e:	e8 f9 f9 ff ff       	call   801d6c <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
	return;
  802376:	90                   	nop
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	ff 75 0c             	pushl  0xc(%ebp)
  802385:	ff 75 08             	pushl  0x8(%ebp)
  802388:	6a 2d                	push   $0x2d
  80238a:	e8 dd f9 ff ff       	call   801d6c <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
	return;
  802392:	90                   	nop
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	83 e8 04             	sub    $0x4,%eax
  8023a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8023a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	83 e8 04             	sub    $0x4,%eax
  8023ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8023bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	83 e0 01             	and    $0x1,%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	0f 94 c0             	sete   %al
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8023d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8023d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023dc:	83 f8 02             	cmp    $0x2,%eax
  8023df:	74 2b                	je     80240c <alloc_block+0x40>
  8023e1:	83 f8 02             	cmp    $0x2,%eax
  8023e4:	7f 07                	jg     8023ed <alloc_block+0x21>
  8023e6:	83 f8 01             	cmp    $0x1,%eax
  8023e9:	74 0e                	je     8023f9 <alloc_block+0x2d>
  8023eb:	eb 58                	jmp    802445 <alloc_block+0x79>
  8023ed:	83 f8 03             	cmp    $0x3,%eax
  8023f0:	74 2d                	je     80241f <alloc_block+0x53>
  8023f2:	83 f8 04             	cmp    $0x4,%eax
  8023f5:	74 3b                	je     802432 <alloc_block+0x66>
  8023f7:	eb 4c                	jmp    802445 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	ff 75 08             	pushl  0x8(%ebp)
  8023ff:	e8 11 03 00 00       	call   802715 <alloc_block_FF>
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80240a:	eb 4a                	jmp    802456 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80240c:	83 ec 0c             	sub    $0xc,%esp
  80240f:	ff 75 08             	pushl  0x8(%ebp)
  802412:	e8 fa 19 00 00       	call   803e11 <alloc_block_NF>
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80241d:	eb 37                	jmp    802456 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	ff 75 08             	pushl  0x8(%ebp)
  802425:	e8 a7 07 00 00       	call   802bd1 <alloc_block_BF>
  80242a:	83 c4 10             	add    $0x10,%esp
  80242d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802430:	eb 24                	jmp    802456 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	ff 75 08             	pushl  0x8(%ebp)
  802438:	e8 b7 19 00 00       	call   803df4 <alloc_block_WF>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802443:	eb 11                	jmp    802456 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	68 b8 48 80 00       	push   $0x8048b8
  80244d:	e8 3b e6 ff ff       	call   800a8d <cprintf>
  802452:	83 c4 10             	add    $0x10,%esp
		break;
  802455:	90                   	nop
	}
	return va;
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	53                   	push   %ebx
  80245f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	68 d8 48 80 00       	push   $0x8048d8
  80246a:	e8 1e e6 ff ff       	call   800a8d <cprintf>
  80246f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802472:	83 ec 0c             	sub    $0xc,%esp
  802475:	68 03 49 80 00       	push   $0x804903
  80247a:	e8 0e e6 ff ff       	call   800a8d <cprintf>
  80247f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802488:	eb 37                	jmp    8024c1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	ff 75 f4             	pushl  -0xc(%ebp)
  802490:	e8 19 ff ff ff       	call   8023ae <is_free_block>
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	0f be d8             	movsbl %al,%ebx
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a1:	e8 ef fe ff ff       	call   802395 <get_block_size>
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	53                   	push   %ebx
  8024ad:	50                   	push   %eax
  8024ae:	68 1b 49 80 00       	push   $0x80491b
  8024b3:	e8 d5 e5 ff ff       	call   800a8d <cprintf>
  8024b8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8024bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c5:	74 07                	je     8024ce <print_blocks_list+0x73>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	eb 05                	jmp    8024d3 <print_blocks_list+0x78>
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	89 45 10             	mov    %eax,0x10(%ebp)
  8024d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 ad                	jne    80248a <print_blocks_list+0x2f>
  8024dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e1:	75 a7                	jne    80248a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	68 d8 48 80 00       	push   $0x8048d8
  8024eb:	e8 9d e5 ff ff       	call   800a8d <cprintf>
  8024f0:	83 c4 10             	add    $0x10,%esp

}
  8024f3:	90                   	nop
  8024f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802502:	83 e0 01             	and    $0x1,%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 03                	je     80250c <initialize_dynamic_allocator+0x13>
  802509:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80250c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802510:	0f 84 c7 01 00 00    	je     8026dd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802516:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80251d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802520:	8b 55 08             	mov    0x8(%ebp),%edx
  802523:	8b 45 0c             	mov    0xc(%ebp),%eax
  802526:	01 d0                	add    %edx,%eax
  802528:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80252d:	0f 87 ad 01 00 00    	ja     8026e0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	0f 89 a5 01 00 00    	jns    8026e3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80253e:	8b 55 08             	mov    0x8(%ebp),%edx
  802541:	8b 45 0c             	mov    0xc(%ebp),%eax
  802544:	01 d0                	add    %edx,%eax
  802546:	83 e8 04             	sub    $0x4,%eax
  802549:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80254e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802555:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80255a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255d:	e9 87 00 00 00       	jmp    8025e9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	75 14                	jne    80257c <initialize_dynamic_allocator+0x83>
  802568:	83 ec 04             	sub    $0x4,%esp
  80256b:	68 33 49 80 00       	push   $0x804933
  802570:	6a 79                	push   $0x79
  802572:	68 51 49 80 00       	push   $0x804951
  802577:	e8 54 e2 ff ff       	call   8007d0 <_panic>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <initialize_dynamic_allocator+0x9c>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <initialize_dynamic_allocator+0xa7>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <initialize_dynamic_allocator+0xc0>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <initialize_dynamic_allocator+0xca>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8025e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	74 07                	je     8025f6 <initialize_dynamic_allocator+0xfd>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	eb 05                	jmp    8025fb <initialize_dynamic_allocator+0x102>
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802600:	a1 34 50 80 00       	mov    0x805034,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 85 55 ff ff ff    	jne    802562 <initialize_dynamic_allocator+0x69>
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	0f 85 4b ff ff ff    	jne    802562 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
  80261a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802626:	a1 44 50 80 00       	mov    0x805044,%eax
  80262b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802630:	a1 40 50 80 00       	mov    0x805040,%eax
  802635:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	83 c0 08             	add    $0x8,%eax
  802641:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	83 c0 04             	add    $0x4,%eax
  80264a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264d:	83 ea 08             	sub    $0x8,%edx
  802650:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802652:	8b 55 0c             	mov    0xc(%ebp),%edx
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	83 e8 08             	sub    $0x8,%eax
  80265d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802660:	83 ea 08             	sub    $0x8,%edx
  802663:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802678:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80267c:	75 17                	jne    802695 <initialize_dynamic_allocator+0x19c>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 6c 49 80 00       	push   $0x80496c
  802686:	68 90 00 00 00       	push   $0x90
  80268b:	68 51 49 80 00       	push   $0x804951
  802690:	e8 3b e1 ff ff       	call   8007d0 <_panic>
  802695:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	89 10                	mov    %edx,(%eax)
  8026a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 0d                	je     8026b6 <initialize_dynamic_allocator+0x1bd>
  8026a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b1:	89 50 04             	mov    %edx,0x4(%eax)
  8026b4:	eb 08                	jmp    8026be <initialize_dynamic_allocator+0x1c5>
  8026b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8026be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d5:	40                   	inc    %eax
  8026d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8026db:	eb 07                	jmp    8026e4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8026dd:	90                   	nop
  8026de:	eb 04                	jmp    8026e4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8026e0:	90                   	nop
  8026e1:	eb 01                	jmp    8026e4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8026e3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ec:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	83 e8 04             	sub    $0x4,%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	83 e0 fe             	and    $0xfffffffe,%eax
  802705:	8d 50 f8             	lea    -0x8(%eax),%edx
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	01 c2                	add    %eax,%edx
  80270d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802710:	89 02                	mov    %eax,(%edx)
}
  802712:	90                   	nop
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    

00802715 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	83 e0 01             	and    $0x1,%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 03                	je     802728 <alloc_block_FF+0x13>
  802725:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802728:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80272c:	77 07                	ja     802735 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80272e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802735:	a1 24 50 80 00       	mov    0x805024,%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	75 73                	jne    8027b1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	83 c0 10             	add    $0x10,%eax
  802744:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802747:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80274e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802754:	01 d0                	add    %edx,%eax
  802756:	48                   	dec    %eax
  802757:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80275a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275d:	ba 00 00 00 00       	mov    $0x0,%edx
  802762:	f7 75 ec             	divl   -0x14(%ebp)
  802765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802768:	29 d0                	sub    %edx,%eax
  80276a:	c1 e8 0c             	shr    $0xc,%eax
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	50                   	push   %eax
  802771:	e8 b1 f0 ff ff       	call   801827 <sbrk>
  802776:	83 c4 10             	add    $0x10,%esp
  802779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80277c:	83 ec 0c             	sub    $0xc,%esp
  80277f:	6a 00                	push   $0x0
  802781:	e8 a1 f0 ff ff       	call   801827 <sbrk>
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80278c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802792:	83 ec 08             	sub    $0x8,%esp
  802795:	50                   	push   %eax
  802796:	ff 75 e4             	pushl  -0x1c(%ebp)
  802799:	e8 5b fd ff ff       	call   8024f9 <initialize_dynamic_allocator>
  80279e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	68 8f 49 80 00       	push   $0x80498f
  8027a9:	e8 df e2 ff ff       	call   800a8d <cprintf>
  8027ae:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8027b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b5:	75 0a                	jne    8027c1 <alloc_block_FF+0xac>
	        return NULL;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	e9 0e 04 00 00       	jmp    802bcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8027c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d0:	e9 f3 02 00 00       	jmp    802ac8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8027db:	83 ec 0c             	sub    $0xc,%esp
  8027de:	ff 75 bc             	pushl  -0x44(%ebp)
  8027e1:	e8 af fb ff ff       	call   802395 <get_block_size>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	83 c0 08             	add    $0x8,%eax
  8027f2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027f5:	0f 87 c5 02 00 00    	ja     802ac0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	83 c0 18             	add    $0x18,%eax
  802801:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802804:	0f 87 19 02 00 00    	ja     802a23 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80280a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80280d:	2b 45 08             	sub    0x8(%ebp),%eax
  802810:	83 e8 08             	sub    $0x8,%eax
  802813:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	8d 50 08             	lea    0x8(%eax),%edx
  80281c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80281f:	01 d0                	add    %edx,%eax
  802821:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	83 c0 08             	add    $0x8,%eax
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	6a 01                	push   $0x1
  80282f:	50                   	push   %eax
  802830:	ff 75 bc             	pushl  -0x44(%ebp)
  802833:	e8 ae fe ff ff       	call   8026e6 <set_block_data>
  802838:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 04             	mov    0x4(%eax),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	75 68                	jne    8028ad <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802845:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802849:	75 17                	jne    802862 <alloc_block_FF+0x14d>
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 6c 49 80 00       	push   $0x80496c
  802853:	68 d7 00 00 00       	push   $0xd7
  802858:	68 51 49 80 00       	push   $0x804951
  80285d:	e8 6e df ff ff       	call   8007d0 <_panic>
  802862:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802868:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80286b:	89 10                	mov    %edx,(%eax)
  80286d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 0d                	je     802883 <alloc_block_FF+0x16e>
  802876:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80287b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80287e:	89 50 04             	mov    %edx,0x4(%eax)
  802881:	eb 08                	jmp    80288b <alloc_block_FF+0x176>
  802883:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802886:	a3 30 50 80 00       	mov    %eax,0x805030
  80288b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80288e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802893:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289d:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a2:	40                   	inc    %eax
  8028a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8028a8:	e9 dc 00 00 00       	jmp    802989 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	75 65                	jne    80291b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028b6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028ba:	75 17                	jne    8028d3 <alloc_block_FF+0x1be>
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	68 a0 49 80 00       	push   $0x8049a0
  8028c4:	68 db 00 00 00       	push   $0xdb
  8028c9:	68 51 49 80 00       	push   $0x804951
  8028ce:	e8 fd de ff ff       	call   8007d0 <_panic>
  8028d3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 0c                	je     8028f5 <alloc_block_FF+0x1e0>
  8028e9:	a1 30 50 80 00       	mov    0x805030,%eax
  8028ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028f1:	89 10                	mov    %edx,(%eax)
  8028f3:	eb 08                	jmp    8028fd <alloc_block_FF+0x1e8>
  8028f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802900:	a3 30 50 80 00       	mov    %eax,0x805030
  802905:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290e:	a1 38 50 80 00       	mov    0x805038,%eax
  802913:	40                   	inc    %eax
  802914:	a3 38 50 80 00       	mov    %eax,0x805038
  802919:	eb 6e                	jmp    802989 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80291b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291f:	74 06                	je     802927 <alloc_block_FF+0x212>
  802921:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802925:	75 17                	jne    80293e <alloc_block_FF+0x229>
  802927:	83 ec 04             	sub    $0x4,%esp
  80292a:	68 c4 49 80 00       	push   $0x8049c4
  80292f:	68 df 00 00 00       	push   $0xdf
  802934:	68 51 49 80 00       	push   $0x804951
  802939:	e8 92 de ff ff       	call   8007d0 <_panic>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 10                	mov    (%eax),%edx
  802943:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802946:	89 10                	mov    %edx,(%eax)
  802948:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0b                	je     80295c <alloc_block_FF+0x247>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802959:	89 50 04             	mov    %edx,0x4(%eax)
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802962:	89 10                	mov    %edx,(%eax)
  802964:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	75 08                	jne    80297e <alloc_block_FF+0x269>
  802976:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802979:	a3 30 50 80 00       	mov    %eax,0x805030
  80297e:	a1 38 50 80 00       	mov    0x805038,%eax
  802983:	40                   	inc    %eax
  802984:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	75 17                	jne    8029a6 <alloc_block_FF+0x291>
  80298f:	83 ec 04             	sub    $0x4,%esp
  802992:	68 33 49 80 00       	push   $0x804933
  802997:	68 e1 00 00 00       	push   $0xe1
  80299c:	68 51 49 80 00       	push   $0x804951
  8029a1:	e8 2a de ff ff       	call   8007d0 <_panic>
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 10                	je     8029bf <alloc_block_FF+0x2aa>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	eb 0b                	jmp    8029ca <alloc_block_FF+0x2b5>
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	74 0f                	je     8029e3 <alloc_block_FF+0x2ce>
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029dd:	8b 12                	mov    (%edx),%edx
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	eb 0a                	jmp    8029ed <alloc_block_FF+0x2d8>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a00:	a1 38 50 80 00       	mov    0x805038,%eax
  802a05:	48                   	dec    %eax
  802a06:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	6a 00                	push   $0x0
  802a10:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a13:	ff 75 b0             	pushl  -0x50(%ebp)
  802a16:	e8 cb fc ff ff       	call   8026e6 <set_block_data>
  802a1b:	83 c4 10             	add    $0x10,%esp
  802a1e:	e9 95 00 00 00       	jmp    802ab8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	6a 01                	push   $0x1
  802a28:	ff 75 b8             	pushl  -0x48(%ebp)
  802a2b:	ff 75 bc             	pushl  -0x44(%ebp)
  802a2e:	e8 b3 fc ff ff       	call   8026e6 <set_block_data>
  802a33:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_FF+0x33e>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 33 49 80 00       	push   $0x804933
  802a44:	68 e8 00 00 00       	push   $0xe8
  802a49:	68 51 49 80 00       	push   $0x804951
  802a4e:	e8 7d dd ff ff       	call   8007d0 <_panic>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 10                	je     802a6c <alloc_block_FF+0x357>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a64:	8b 52 04             	mov    0x4(%edx),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 0b                	jmp    802a77 <alloc_block_FF+0x362>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	a3 30 50 80 00       	mov    %eax,0x805030
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0f                	je     802a90 <alloc_block_FF+0x37b>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	8b 12                	mov    (%edx),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 0a                	jmp    802a9a <alloc_block_FF+0x385>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aad:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab2:	48                   	dec    %eax
  802ab3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802ab8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802abb:	e9 0f 01 00 00       	jmp    802bcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ac0:	a1 34 50 80 00       	mov    0x805034,%eax
  802ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acc:	74 07                	je     802ad5 <alloc_block_FF+0x3c0>
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	eb 05                	jmp    802ada <alloc_block_FF+0x3c5>
  802ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  802ada:	a3 34 50 80 00       	mov    %eax,0x805034
  802adf:	a1 34 50 80 00       	mov    0x805034,%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	0f 85 e9 fc ff ff    	jne    8027d5 <alloc_block_FF+0xc0>
  802aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af0:	0f 85 df fc ff ff    	jne    8027d5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	83 c0 08             	add    $0x8,%eax
  802afc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802aff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b06:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b0c:	01 d0                	add    %edx,%eax
  802b0e:	48                   	dec    %eax
  802b0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b15:	ba 00 00 00 00       	mov    $0x0,%edx
  802b1a:	f7 75 d8             	divl   -0x28(%ebp)
  802b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b20:	29 d0                	sub    %edx,%eax
  802b22:	c1 e8 0c             	shr    $0xc,%eax
  802b25:	83 ec 0c             	sub    $0xc,%esp
  802b28:	50                   	push   %eax
  802b29:	e8 f9 ec ff ff       	call   801827 <sbrk>
  802b2e:	83 c4 10             	add    $0x10,%esp
  802b31:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b34:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b38:	75 0a                	jne    802b44 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3f:	e9 8b 00 00 00       	jmp    802bcf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b44:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	48                   	dec    %eax
  802b54:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b57:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5f:	f7 75 cc             	divl   -0x34(%ebp)
  802b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b65:	29 d0                	sub    %edx,%eax
  802b67:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b6d:	01 d0                	add    %edx,%eax
  802b6f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b74:	a1 40 50 80 00       	mov    0x805040,%eax
  802b79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b7f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b8c:	01 d0                	add    %edx,%eax
  802b8e:	48                   	dec    %eax
  802b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b95:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9a:	f7 75 c4             	divl   -0x3c(%ebp)
  802b9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ba0:	29 d0                	sub    %edx,%eax
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	6a 01                	push   $0x1
  802ba7:	50                   	push   %eax
  802ba8:	ff 75 d0             	pushl  -0x30(%ebp)
  802bab:	e8 36 fb ff ff       	call   8026e6 <set_block_data>
  802bb0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb9:	e8 1b 0a 00 00       	call   8035d9 <free_block>
  802bbe:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802bc1:	83 ec 0c             	sub    $0xc,%esp
  802bc4:	ff 75 08             	pushl  0x8(%ebp)
  802bc7:	e8 49 fb ff ff       	call   802715 <alloc_block_FF>
  802bcc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	83 e0 01             	and    $0x1,%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	74 03                	je     802be4 <alloc_block_BF+0x13>
  802be1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802be4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802be8:	77 07                	ja     802bf1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bf1:	a1 24 50 80 00       	mov    0x805024,%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	75 73                	jne    802c6d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	83 c0 10             	add    $0x10,%eax
  802c00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c03:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c10:	01 d0                	add    %edx,%eax
  802c12:	48                   	dec    %eax
  802c13:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c19:	ba 00 00 00 00       	mov    $0x0,%edx
  802c1e:	f7 75 e0             	divl   -0x20(%ebp)
  802c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c24:	29 d0                	sub    %edx,%eax
  802c26:	c1 e8 0c             	shr    $0xc,%eax
  802c29:	83 ec 0c             	sub    $0xc,%esp
  802c2c:	50                   	push   %eax
  802c2d:	e8 f5 eb ff ff       	call   801827 <sbrk>
  802c32:	83 c4 10             	add    $0x10,%esp
  802c35:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c38:	83 ec 0c             	sub    $0xc,%esp
  802c3b:	6a 00                	push   $0x0
  802c3d:	e8 e5 eb ff ff       	call   801827 <sbrk>
  802c42:	83 c4 10             	add    $0x10,%esp
  802c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c4b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c4e:	83 ec 08             	sub    $0x8,%esp
  802c51:	50                   	push   %eax
  802c52:	ff 75 d8             	pushl  -0x28(%ebp)
  802c55:	e8 9f f8 ff ff       	call   8024f9 <initialize_dynamic_allocator>
  802c5a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c5d:	83 ec 0c             	sub    $0xc,%esp
  802c60:	68 8f 49 80 00       	push   $0x80498f
  802c65:	e8 23 de ff ff       	call   800a8d <cprintf>
  802c6a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c7b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	e9 1d 01 00 00       	jmp    802db3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c9c:	83 ec 0c             	sub    $0xc,%esp
  802c9f:	ff 75 a8             	pushl  -0x58(%ebp)
  802ca2:	e8 ee f6 ff ff       	call   802395 <get_block_size>
  802ca7:	83 c4 10             	add    $0x10,%esp
  802caa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	83 c0 08             	add    $0x8,%eax
  802cb3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cb6:	0f 87 ef 00 00 00    	ja     802dab <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	83 c0 18             	add    $0x18,%eax
  802cc2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cc5:	77 1d                	ja     802ce4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ccd:	0f 86 d8 00 00 00    	jbe    802dab <alloc_block_BF+0x1da>
				{
					best_va = va;
  802cd3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802cd9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cdf:	e9 c7 00 00 00       	jmp    802dab <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	83 c0 08             	add    $0x8,%eax
  802cea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ced:	0f 85 9d 00 00 00    	jne    802d90 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	6a 01                	push   $0x1
  802cf8:	ff 75 a4             	pushl  -0x5c(%ebp)
  802cfb:	ff 75 a8             	pushl  -0x58(%ebp)
  802cfe:	e8 e3 f9 ff ff       	call   8026e6 <set_block_data>
  802d03:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	75 17                	jne    802d23 <alloc_block_BF+0x152>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 33 49 80 00       	push   $0x804933
  802d14:	68 2c 01 00 00       	push   $0x12c
  802d19:	68 51 49 80 00       	push   $0x804951
  802d1e:	e8 ad da ff ff       	call   8007d0 <_panic>
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 10                	je     802d3c <alloc_block_BF+0x16b>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d34:	8b 52 04             	mov    0x4(%edx),%edx
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	eb 0b                	jmp    802d47 <alloc_block_BF+0x176>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 04             	mov    0x4(%eax),%eax
  802d42:	a3 30 50 80 00       	mov    %eax,0x805030
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 0f                	je     802d60 <alloc_block_BF+0x18f>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5a:	8b 12                	mov    (%edx),%edx
  802d5c:	89 10                	mov    %edx,(%eax)
  802d5e:	eb 0a                	jmp    802d6a <alloc_block_BF+0x199>
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d82:	48                   	dec    %eax
  802d83:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802d88:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d8b:	e9 24 04 00 00       	jmp    8031b4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d93:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d96:	76 13                	jbe    802dab <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d98:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802da5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802da8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802dab:	a1 34 50 80 00       	mov    0x805034,%eax
  802db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	74 07                	je     802dc0 <alloc_block_BF+0x1ef>
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	eb 05                	jmp    802dc5 <alloc_block_BF+0x1f4>
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc5:	a3 34 50 80 00       	mov    %eax,0x805034
  802dca:	a1 34 50 80 00       	mov    0x805034,%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	0f 85 bf fe ff ff    	jne    802c96 <alloc_block_BF+0xc5>
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	0f 85 b5 fe ff ff    	jne    802c96 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de5:	0f 84 26 02 00 00    	je     803011 <alloc_block_BF+0x440>
  802deb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802def:	0f 85 1c 02 00 00    	jne    803011 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dfb:	83 e8 08             	sub    $0x8,%eax
  802dfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8d 50 08             	lea    0x8(%eax),%edx
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	01 d0                	add    %edx,%eax
  802e0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	83 c0 08             	add    $0x8,%eax
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	6a 01                	push   $0x1
  802e1a:	50                   	push   %eax
  802e1b:	ff 75 f0             	pushl  -0x10(%ebp)
  802e1e:	e8 c3 f8 ff ff       	call   8026e6 <set_block_data>
  802e23:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	75 68                	jne    802e98 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e30:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e34:	75 17                	jne    802e4d <alloc_block_BF+0x27c>
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 6c 49 80 00       	push   $0x80496c
  802e3e:	68 45 01 00 00       	push   $0x145
  802e43:	68 51 49 80 00       	push   $0x804951
  802e48:	e8 83 d9 ff ff       	call   8007d0 <_panic>
  802e4d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0d                	je     802e6e <alloc_block_BF+0x29d>
  802e61:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e66:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e69:	89 50 04             	mov    %edx,0x4(%eax)
  802e6c:	eb 08                	jmp    802e76 <alloc_block_BF+0x2a5>
  802e6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e71:	a3 30 50 80 00       	mov    %eax,0x805030
  802e76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e79:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e88:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8d:	40                   	inc    %eax
  802e8e:	a3 38 50 80 00       	mov    %eax,0x805038
  802e93:	e9 dc 00 00 00       	jmp    802f74 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	75 65                	jne    802f06 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ea1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ea5:	75 17                	jne    802ebe <alloc_block_BF+0x2ed>
  802ea7:	83 ec 04             	sub    $0x4,%esp
  802eaa:	68 a0 49 80 00       	push   $0x8049a0
  802eaf:	68 4a 01 00 00       	push   $0x14a
  802eb4:	68 51 49 80 00       	push   $0x804951
  802eb9:	e8 12 d9 ff ff       	call   8007d0 <_panic>
  802ebe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ec4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec7:	89 50 04             	mov    %edx,0x4(%eax)
  802eca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 0c                	je     802ee0 <alloc_block_BF+0x30f>
  802ed4:	a1 30 50 80 00       	mov    0x805030,%eax
  802ed9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802edc:	89 10                	mov    %edx,(%eax)
  802ede:	eb 08                	jmp    802ee8 <alloc_block_BF+0x317>
  802ee0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ee8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eeb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ef0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef9:	a1 38 50 80 00       	mov    0x805038,%eax
  802efe:	40                   	inc    %eax
  802eff:	a3 38 50 80 00       	mov    %eax,0x805038
  802f04:	eb 6e                	jmp    802f74 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0a:	74 06                	je     802f12 <alloc_block_BF+0x341>
  802f0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f10:	75 17                	jne    802f29 <alloc_block_BF+0x358>
  802f12:	83 ec 04             	sub    $0x4,%esp
  802f15:	68 c4 49 80 00       	push   $0x8049c4
  802f1a:	68 4f 01 00 00       	push   $0x14f
  802f1f:	68 51 49 80 00       	push   $0x804951
  802f24:	e8 a7 d8 ff ff       	call   8007d0 <_panic>
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	8b 10                	mov    (%eax),%edx
  802f2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f31:	89 10                	mov    %edx,(%eax)
  802f33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0b                	je     802f47 <alloc_block_BF+0x376>
  802f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	75 08                	jne    802f69 <alloc_block_BF+0x398>
  802f61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f64:	a3 30 50 80 00       	mov    %eax,0x805030
  802f69:	a1 38 50 80 00       	mov    0x805038,%eax
  802f6e:	40                   	inc    %eax
  802f6f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f78:	75 17                	jne    802f91 <alloc_block_BF+0x3c0>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 33 49 80 00       	push   $0x804933
  802f82:	68 51 01 00 00       	push   $0x151
  802f87:	68 51 49 80 00       	push   $0x804951
  802f8c:	e8 3f d8 ff ff       	call   8007d0 <_panic>
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 10                	je     802faa <alloc_block_BF+0x3d9>
  802f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9d:	8b 00                	mov    (%eax),%eax
  802f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa2:	8b 52 04             	mov    0x4(%edx),%edx
  802fa5:	89 50 04             	mov    %edx,0x4(%eax)
  802fa8:	eb 0b                	jmp    802fb5 <alloc_block_BF+0x3e4>
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	a3 30 50 80 00       	mov    %eax,0x805030
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	85 c0                	test   %eax,%eax
  802fbd:	74 0f                	je     802fce <alloc_block_BF+0x3fd>
  802fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc8:	8b 12                	mov    (%edx),%edx
  802fca:	89 10                	mov    %edx,(%eax)
  802fcc:	eb 0a                	jmp    802fd8 <alloc_block_BF+0x407>
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 00                	mov    (%eax),%eax
  802fd3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802feb:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff0:	48                   	dec    %eax
  802ff1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ff6:	83 ec 04             	sub    $0x4,%esp
  802ff9:	6a 00                	push   $0x0
  802ffb:	ff 75 d0             	pushl  -0x30(%ebp)
  802ffe:	ff 75 cc             	pushl  -0x34(%ebp)
  803001:	e8 e0 f6 ff ff       	call   8026e6 <set_block_data>
  803006:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300c:	e9 a3 01 00 00       	jmp    8031b4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803011:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803015:	0f 85 9d 00 00 00    	jne    8030b8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	6a 01                	push   $0x1
  803020:	ff 75 ec             	pushl  -0x14(%ebp)
  803023:	ff 75 f0             	pushl  -0x10(%ebp)
  803026:	e8 bb f6 ff ff       	call   8026e6 <set_block_data>
  80302b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80302e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803032:	75 17                	jne    80304b <alloc_block_BF+0x47a>
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 33 49 80 00       	push   $0x804933
  80303c:	68 58 01 00 00       	push   $0x158
  803041:	68 51 49 80 00       	push   $0x804951
  803046:	e8 85 d7 ff ff       	call   8007d0 <_panic>
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 10                	je     803064 <alloc_block_BF+0x493>
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305c:	8b 52 04             	mov    0x4(%edx),%edx
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	eb 0b                	jmp    80306f <alloc_block_BF+0x49e>
  803064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	a3 30 50 80 00       	mov    %eax,0x805030
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 0f                	je     803088 <alloc_block_BF+0x4b7>
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803082:	8b 12                	mov    (%edx),%edx
  803084:	89 10                	mov    %edx,(%eax)
  803086:	eb 0a                	jmp    803092 <alloc_block_BF+0x4c1>
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8030aa:	48                   	dec    %eax
  8030ab:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	e9 fc 00 00 00       	jmp    8031b4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	83 c0 08             	add    $0x8,%eax
  8030be:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8030c1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030ce:	01 d0                	add    %edx,%eax
  8030d0:	48                   	dec    %eax
  8030d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8030d4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8030dc:	f7 75 c4             	divl   -0x3c(%ebp)
  8030df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030e2:	29 d0                	sub    %edx,%eax
  8030e4:	c1 e8 0c             	shr    $0xc,%eax
  8030e7:	83 ec 0c             	sub    $0xc,%esp
  8030ea:	50                   	push   %eax
  8030eb:	e8 37 e7 ff ff       	call   801827 <sbrk>
  8030f0:	83 c4 10             	add    $0x10,%esp
  8030f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8030f6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8030fa:	75 0a                	jne    803106 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8030fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803101:	e9 ae 00 00 00       	jmp    8031b4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803106:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80310d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803110:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803113:	01 d0                	add    %edx,%eax
  803115:	48                   	dec    %eax
  803116:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803119:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80311c:	ba 00 00 00 00       	mov    $0x0,%edx
  803121:	f7 75 b8             	divl   -0x48(%ebp)
  803124:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803127:	29 d0                	sub    %edx,%eax
  803129:	8d 50 fc             	lea    -0x4(%eax),%edx
  80312c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80312f:	01 d0                	add    %edx,%eax
  803131:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803136:	a1 40 50 80 00       	mov    0x805040,%eax
  80313b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803141:	83 ec 0c             	sub    $0xc,%esp
  803144:	68 f8 49 80 00       	push   $0x8049f8
  803149:	e8 3f d9 ff ff       	call   800a8d <cprintf>
  80314e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803151:	83 ec 08             	sub    $0x8,%esp
  803154:	ff 75 bc             	pushl  -0x44(%ebp)
  803157:	68 fd 49 80 00       	push   $0x8049fd
  80315c:	e8 2c d9 ff ff       	call   800a8d <cprintf>
  803161:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803164:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80316b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80316e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803171:	01 d0                	add    %edx,%eax
  803173:	48                   	dec    %eax
  803174:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803177:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80317a:	ba 00 00 00 00       	mov    $0x0,%edx
  80317f:	f7 75 b0             	divl   -0x50(%ebp)
  803182:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803185:	29 d0                	sub    %edx,%eax
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	6a 01                	push   $0x1
  80318c:	50                   	push   %eax
  80318d:	ff 75 bc             	pushl  -0x44(%ebp)
  803190:	e8 51 f5 ff ff       	call   8026e6 <set_block_data>
  803195:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803198:	83 ec 0c             	sub    $0xc,%esp
  80319b:	ff 75 bc             	pushl  -0x44(%ebp)
  80319e:	e8 36 04 00 00       	call   8035d9 <free_block>
  8031a3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8031a6:	83 ec 0c             	sub    $0xc,%esp
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	e8 20 fa ff ff       	call   802bd1 <alloc_block_BF>
  8031b1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8031b4:	c9                   	leave  
  8031b5:	c3                   	ret    

008031b6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8031b6:	55                   	push   %ebp
  8031b7:	89 e5                	mov    %esp,%ebp
  8031b9:	53                   	push   %ebx
  8031ba:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8031bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8031cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cf:	74 1e                	je     8031ef <merging+0x39>
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	e8 bc f1 ff ff       	call   802395 <get_block_size>
  8031d9:	83 c4 04             	add    $0x4,%esp
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	01 d0                	add    %edx,%eax
  8031e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8031e6:	75 07                	jne    8031ef <merging+0x39>
		prev_is_free = 1;
  8031e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8031ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031f3:	74 1e                	je     803213 <merging+0x5d>
  8031f5:	ff 75 10             	pushl  0x10(%ebp)
  8031f8:	e8 98 f1 ff ff       	call   802395 <get_block_size>
  8031fd:	83 c4 04             	add    $0x4,%esp
  803200:	89 c2                	mov    %eax,%edx
  803202:	8b 45 10             	mov    0x10(%ebp),%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80320a:	75 07                	jne    803213 <merging+0x5d>
		next_is_free = 1;
  80320c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803217:	0f 84 cc 00 00 00    	je     8032e9 <merging+0x133>
  80321d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803221:	0f 84 c2 00 00 00    	je     8032e9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	e8 66 f1 ff ff       	call   802395 <get_block_size>
  80322f:	83 c4 04             	add    $0x4,%esp
  803232:	89 c3                	mov    %eax,%ebx
  803234:	ff 75 10             	pushl  0x10(%ebp)
  803237:	e8 59 f1 ff ff       	call   802395 <get_block_size>
  80323c:	83 c4 04             	add    $0x4,%esp
  80323f:	01 c3                	add    %eax,%ebx
  803241:	ff 75 0c             	pushl  0xc(%ebp)
  803244:	e8 4c f1 ff ff       	call   802395 <get_block_size>
  803249:	83 c4 04             	add    $0x4,%esp
  80324c:	01 d8                	add    %ebx,%eax
  80324e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803251:	6a 00                	push   $0x0
  803253:	ff 75 ec             	pushl  -0x14(%ebp)
  803256:	ff 75 08             	pushl  0x8(%ebp)
  803259:	e8 88 f4 ff ff       	call   8026e6 <set_block_data>
  80325e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803265:	75 17                	jne    80327e <merging+0xc8>
  803267:	83 ec 04             	sub    $0x4,%esp
  80326a:	68 33 49 80 00       	push   $0x804933
  80326f:	68 7d 01 00 00       	push   $0x17d
  803274:	68 51 49 80 00       	push   $0x804951
  803279:	e8 52 d5 ff ff       	call   8007d0 <_panic>
  80327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	74 10                	je     803297 <merging+0xe1>
  803287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80328f:	8b 52 04             	mov    0x4(%edx),%edx
  803292:	89 50 04             	mov    %edx,0x4(%eax)
  803295:	eb 0b                	jmp    8032a2 <merging+0xec>
  803297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329a:	8b 40 04             	mov    0x4(%eax),%eax
  80329d:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	8b 40 04             	mov    0x4(%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0f                	je     8032bb <merging+0x105>
  8032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032af:	8b 40 04             	mov    0x4(%eax),%eax
  8032b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032b5:	8b 12                	mov    (%edx),%edx
  8032b7:	89 10                	mov    %edx,(%eax)
  8032b9:	eb 0a                	jmp    8032c5 <merging+0x10f>
  8032bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032dd:	48                   	dec    %eax
  8032de:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8032e3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032e4:	e9 ea 02 00 00       	jmp    8035d3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8032e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ed:	74 3b                	je     80332a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8032ef:	83 ec 0c             	sub    $0xc,%esp
  8032f2:	ff 75 08             	pushl  0x8(%ebp)
  8032f5:	e8 9b f0 ff ff       	call   802395 <get_block_size>
  8032fa:	83 c4 10             	add    $0x10,%esp
  8032fd:	89 c3                	mov    %eax,%ebx
  8032ff:	83 ec 0c             	sub    $0xc,%esp
  803302:	ff 75 10             	pushl  0x10(%ebp)
  803305:	e8 8b f0 ff ff       	call   802395 <get_block_size>
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	01 d8                	add    %ebx,%eax
  80330f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803312:	83 ec 04             	sub    $0x4,%esp
  803315:	6a 00                	push   $0x0
  803317:	ff 75 e8             	pushl  -0x18(%ebp)
  80331a:	ff 75 08             	pushl  0x8(%ebp)
  80331d:	e8 c4 f3 ff ff       	call   8026e6 <set_block_data>
  803322:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803325:	e9 a9 02 00 00       	jmp    8035d3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80332a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80332e:	0f 84 2d 01 00 00    	je     803461 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803334:	83 ec 0c             	sub    $0xc,%esp
  803337:	ff 75 10             	pushl  0x10(%ebp)
  80333a:	e8 56 f0 ff ff       	call   802395 <get_block_size>
  80333f:	83 c4 10             	add    $0x10,%esp
  803342:	89 c3                	mov    %eax,%ebx
  803344:	83 ec 0c             	sub    $0xc,%esp
  803347:	ff 75 0c             	pushl  0xc(%ebp)
  80334a:	e8 46 f0 ff ff       	call   802395 <get_block_size>
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	01 d8                	add    %ebx,%eax
  803354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	6a 00                	push   $0x0
  80335c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335f:	ff 75 10             	pushl  0x10(%ebp)
  803362:	e8 7f f3 ff ff       	call   8026e6 <set_block_data>
  803367:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80336a:	8b 45 10             	mov    0x10(%ebp),%eax
  80336d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803370:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803374:	74 06                	je     80337c <merging+0x1c6>
  803376:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80337a:	75 17                	jne    803393 <merging+0x1dd>
  80337c:	83 ec 04             	sub    $0x4,%esp
  80337f:	68 0c 4a 80 00       	push   $0x804a0c
  803384:	68 8d 01 00 00       	push   $0x18d
  803389:	68 51 49 80 00       	push   $0x804951
  80338e:	e8 3d d4 ff ff       	call   8007d0 <_panic>
  803393:	8b 45 0c             	mov    0xc(%ebp),%eax
  803396:	8b 50 04             	mov    0x4(%eax),%edx
  803399:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a5:	89 10                	mov    %edx,(%eax)
  8033a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033aa:	8b 40 04             	mov    0x4(%eax),%eax
  8033ad:	85 c0                	test   %eax,%eax
  8033af:	74 0d                	je     8033be <merging+0x208>
  8033b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b4:	8b 40 04             	mov    0x4(%eax),%eax
  8033b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	eb 08                	jmp    8033c6 <merging+0x210>
  8033be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d4:	40                   	inc    %eax
  8033d5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8033da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033de:	75 17                	jne    8033f7 <merging+0x241>
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	68 33 49 80 00       	push   $0x804933
  8033e8:	68 8e 01 00 00       	push   $0x18e
  8033ed:	68 51 49 80 00       	push   $0x804951
  8033f2:	e8 d9 d3 ff ff       	call   8007d0 <_panic>
  8033f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 10                	je     803410 <merging+0x25a>
  803400:	8b 45 0c             	mov    0xc(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	8b 55 0c             	mov    0xc(%ebp),%edx
  803408:	8b 52 04             	mov    0x4(%edx),%edx
  80340b:	89 50 04             	mov    %edx,0x4(%eax)
  80340e:	eb 0b                	jmp    80341b <merging+0x265>
  803410:	8b 45 0c             	mov    0xc(%ebp),%eax
  803413:	8b 40 04             	mov    0x4(%eax),%eax
  803416:	a3 30 50 80 00       	mov    %eax,0x805030
  80341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341e:	8b 40 04             	mov    0x4(%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 0f                	je     803434 <merging+0x27e>
  803425:	8b 45 0c             	mov    0xc(%ebp),%eax
  803428:	8b 40 04             	mov    0x4(%eax),%eax
  80342b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342e:	8b 12                	mov    (%edx),%edx
  803430:	89 10                	mov    %edx,(%eax)
  803432:	eb 0a                	jmp    80343e <merging+0x288>
  803434:	8b 45 0c             	mov    0xc(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80343e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803451:	a1 38 50 80 00       	mov    0x805038,%eax
  803456:	48                   	dec    %eax
  803457:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80345c:	e9 72 01 00 00       	jmp    8035d3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803461:	8b 45 10             	mov    0x10(%ebp),%eax
  803464:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803467:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346b:	74 79                	je     8034e6 <merging+0x330>
  80346d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803471:	74 73                	je     8034e6 <merging+0x330>
  803473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803477:	74 06                	je     80347f <merging+0x2c9>
  803479:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80347d:	75 17                	jne    803496 <merging+0x2e0>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 c4 49 80 00       	push   $0x8049c4
  803487:	68 94 01 00 00       	push   $0x194
  80348c:	68 51 49 80 00       	push   $0x804951
  803491:	e8 3a d3 ff ff       	call   8007d0 <_panic>
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	8b 10                	mov    (%eax),%edx
  80349b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80349e:	89 10                	mov    %edx,(%eax)
  8034a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0b                	je     8034b4 <merging+0x2fe>
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034b1:	89 50 04             	mov    %edx,0x4(%eax)
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	75 08                	jne    8034d6 <merging+0x320>
  8034ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8034db:	40                   	inc    %eax
  8034dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e1:	e9 ce 00 00 00       	jmp    8035b4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8034e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ea:	74 65                	je     803551 <merging+0x39b>
  8034ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034f0:	75 17                	jne    803509 <merging+0x353>
  8034f2:	83 ec 04             	sub    $0x4,%esp
  8034f5:	68 a0 49 80 00       	push   $0x8049a0
  8034fa:	68 95 01 00 00       	push   $0x195
  8034ff:	68 51 49 80 00       	push   $0x804951
  803504:	e8 c7 d2 ff ff       	call   8007d0 <_panic>
  803509:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80350f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803512:	89 50 04             	mov    %edx,0x4(%eax)
  803515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803518:	8b 40 04             	mov    0x4(%eax),%eax
  80351b:	85 c0                	test   %eax,%eax
  80351d:	74 0c                	je     80352b <merging+0x375>
  80351f:	a1 30 50 80 00       	mov    0x805030,%eax
  803524:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803527:	89 10                	mov    %edx,(%eax)
  803529:	eb 08                	jmp    803533 <merging+0x37d>
  80352b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803533:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803536:	a3 30 50 80 00       	mov    %eax,0x805030
  80353b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803544:	a1 38 50 80 00       	mov    0x805038,%eax
  803549:	40                   	inc    %eax
  80354a:	a3 38 50 80 00       	mov    %eax,0x805038
  80354f:	eb 63                	jmp    8035b4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803551:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803555:	75 17                	jne    80356e <merging+0x3b8>
  803557:	83 ec 04             	sub    $0x4,%esp
  80355a:	68 6c 49 80 00       	push   $0x80496c
  80355f:	68 98 01 00 00       	push   $0x198
  803564:	68 51 49 80 00       	push   $0x804951
  803569:	e8 62 d2 ff ff       	call   8007d0 <_panic>
  80356e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803574:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803577:	89 10                	mov    %edx,(%eax)
  803579:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	85 c0                	test   %eax,%eax
  803580:	74 0d                	je     80358f <merging+0x3d9>
  803582:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803587:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80358a:	89 50 04             	mov    %edx,0x4(%eax)
  80358d:	eb 08                	jmp    803597 <merging+0x3e1>
  80358f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803592:	a3 30 50 80 00       	mov    %eax,0x805030
  803597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80359f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ae:	40                   	inc    %eax
  8035af:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8035b4:	83 ec 0c             	sub    $0xc,%esp
  8035b7:	ff 75 10             	pushl  0x10(%ebp)
  8035ba:	e8 d6 ed ff ff       	call   802395 <get_block_size>
  8035bf:	83 c4 10             	add    $0x10,%esp
  8035c2:	83 ec 04             	sub    $0x4,%esp
  8035c5:	6a 00                	push   $0x0
  8035c7:	50                   	push   %eax
  8035c8:	ff 75 10             	pushl  0x10(%ebp)
  8035cb:	e8 16 f1 ff ff       	call   8026e6 <set_block_data>
  8035d0:	83 c4 10             	add    $0x10,%esp
	}
}
  8035d3:	90                   	nop
  8035d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035d7:	c9                   	leave  
  8035d8:	c3                   	ret    

008035d9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8035d9:	55                   	push   %ebp
  8035da:	89 e5                	mov    %esp,%ebp
  8035dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8035df:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8035e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ef:	73 1b                	jae    80360c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8035f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8035f6:	83 ec 04             	sub    $0x4,%esp
  8035f9:	ff 75 08             	pushl  0x8(%ebp)
  8035fc:	6a 00                	push   $0x0
  8035fe:	50                   	push   %eax
  8035ff:	e8 b2 fb ff ff       	call   8031b6 <merging>
  803604:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803607:	e9 8b 00 00 00       	jmp    803697 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80360c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803611:	3b 45 08             	cmp    0x8(%ebp),%eax
  803614:	76 18                	jbe    80362e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803616:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80361b:	83 ec 04             	sub    $0x4,%esp
  80361e:	ff 75 08             	pushl  0x8(%ebp)
  803621:	50                   	push   %eax
  803622:	6a 00                	push   $0x0
  803624:	e8 8d fb ff ff       	call   8031b6 <merging>
  803629:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80362c:	eb 69                	jmp    803697 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80362e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803636:	eb 39                	jmp    803671 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80363e:	73 29                	jae    803669 <free_block+0x90>
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	3b 45 08             	cmp    0x8(%ebp),%eax
  803648:	76 1f                	jbe    803669 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	ff 75 08             	pushl  0x8(%ebp)
  803658:	ff 75 f0             	pushl  -0x10(%ebp)
  80365b:	ff 75 f4             	pushl  -0xc(%ebp)
  80365e:	e8 53 fb ff ff       	call   8031b6 <merging>
  803663:	83 c4 10             	add    $0x10,%esp
			break;
  803666:	90                   	nop
		}
	}
}
  803667:	eb 2e                	jmp    803697 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803669:	a1 34 50 80 00       	mov    0x805034,%eax
  80366e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803675:	74 07                	je     80367e <free_block+0xa5>
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	eb 05                	jmp    803683 <free_block+0xaa>
  80367e:	b8 00 00 00 00       	mov    $0x0,%eax
  803683:	a3 34 50 80 00       	mov    %eax,0x805034
  803688:	a1 34 50 80 00       	mov    0x805034,%eax
  80368d:	85 c0                	test   %eax,%eax
  80368f:	75 a7                	jne    803638 <free_block+0x5f>
  803691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803695:	75 a1                	jne    803638 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803697:	90                   	nop
  803698:	c9                   	leave  
  803699:	c3                   	ret    

0080369a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80369a:	55                   	push   %ebp
  80369b:	89 e5                	mov    %esp,%ebp
  80369d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8036a0:	ff 75 08             	pushl  0x8(%ebp)
  8036a3:	e8 ed ec ff ff       	call   802395 <get_block_size>
  8036a8:	83 c4 04             	add    $0x4,%esp
  8036ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8036ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8036b5:	eb 17                	jmp    8036ce <copy_data+0x34>
  8036b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bd:	01 c2                	add    %eax,%edx
  8036bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	01 c8                	add    %ecx,%eax
  8036c7:	8a 00                	mov    (%eax),%al
  8036c9:	88 02                	mov    %al,(%edx)
  8036cb:	ff 45 fc             	incl   -0x4(%ebp)
  8036ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036d4:	72 e1                	jb     8036b7 <copy_data+0x1d>
}
  8036d6:	90                   	nop
  8036d7:	c9                   	leave  
  8036d8:	c3                   	ret    

008036d9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8036d9:	55                   	push   %ebp
  8036da:	89 e5                	mov    %esp,%ebp
  8036dc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8036df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e3:	75 23                	jne    803708 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8036e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036e9:	74 13                	je     8036fe <realloc_block_FF+0x25>
  8036eb:	83 ec 0c             	sub    $0xc,%esp
  8036ee:	ff 75 0c             	pushl  0xc(%ebp)
  8036f1:	e8 1f f0 ff ff       	call   802715 <alloc_block_FF>
  8036f6:	83 c4 10             	add    $0x10,%esp
  8036f9:	e9 f4 06 00 00       	jmp    803df2 <realloc_block_FF+0x719>
		return NULL;
  8036fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803703:	e9 ea 06 00 00       	jmp    803df2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80370c:	75 18                	jne    803726 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80370e:	83 ec 0c             	sub    $0xc,%esp
  803711:	ff 75 08             	pushl  0x8(%ebp)
  803714:	e8 c0 fe ff ff       	call   8035d9 <free_block>
  803719:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80371c:	b8 00 00 00 00       	mov    $0x0,%eax
  803721:	e9 cc 06 00 00       	jmp    803df2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803726:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80372a:	77 07                	ja     803733 <realloc_block_FF+0x5a>
  80372c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803733:	8b 45 0c             	mov    0xc(%ebp),%eax
  803736:	83 e0 01             	and    $0x1,%eax
  803739:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80373c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373f:	83 c0 08             	add    $0x8,%eax
  803742:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803745:	83 ec 0c             	sub    $0xc,%esp
  803748:	ff 75 08             	pushl  0x8(%ebp)
  80374b:	e8 45 ec ff ff       	call   802395 <get_block_size>
  803750:	83 c4 10             	add    $0x10,%esp
  803753:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803759:	83 e8 08             	sub    $0x8,%eax
  80375c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80375f:	8b 45 08             	mov    0x8(%ebp),%eax
  803762:	83 e8 04             	sub    $0x4,%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	83 e0 fe             	and    $0xfffffffe,%eax
  80376a:	89 c2                	mov    %eax,%edx
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	01 d0                	add    %edx,%eax
  803771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803774:	83 ec 0c             	sub    $0xc,%esp
  803777:	ff 75 e4             	pushl  -0x1c(%ebp)
  80377a:	e8 16 ec ff ff       	call   802395 <get_block_size>
  80377f:	83 c4 10             	add    $0x10,%esp
  803782:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803788:	83 e8 08             	sub    $0x8,%eax
  80378b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80378e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803791:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803794:	75 08                	jne    80379e <realloc_block_FF+0xc5>
	{
		 return va;
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	e9 54 06 00 00       	jmp    803df2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80379e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037a4:	0f 83 e5 03 00 00    	jae    803b8f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8037aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8037b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8037b3:	83 ec 0c             	sub    $0xc,%esp
  8037b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037b9:	e8 f0 eb ff ff       	call   8023ae <is_free_block>
  8037be:	83 c4 10             	add    $0x10,%esp
  8037c1:	84 c0                	test   %al,%al
  8037c3:	0f 84 3b 01 00 00    	je     803904 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8037c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037cf:	01 d0                	add    %edx,%eax
  8037d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8037d4:	83 ec 04             	sub    $0x4,%esp
  8037d7:	6a 01                	push   $0x1
  8037d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8037dc:	ff 75 08             	pushl  0x8(%ebp)
  8037df:	e8 02 ef ff ff       	call   8026e6 <set_block_data>
  8037e4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	83 e8 04             	sub    $0x4,%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8037f2:	89 c2                	mov    %eax,%edx
  8037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f7:	01 d0                	add    %edx,%eax
  8037f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8037fc:	83 ec 04             	sub    $0x4,%esp
  8037ff:	6a 00                	push   $0x0
  803801:	ff 75 cc             	pushl  -0x34(%ebp)
  803804:	ff 75 c8             	pushl  -0x38(%ebp)
  803807:	e8 da ee ff ff       	call   8026e6 <set_block_data>
  80380c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80380f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803813:	74 06                	je     80381b <realloc_block_FF+0x142>
  803815:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803819:	75 17                	jne    803832 <realloc_block_FF+0x159>
  80381b:	83 ec 04             	sub    $0x4,%esp
  80381e:	68 c4 49 80 00       	push   $0x8049c4
  803823:	68 f6 01 00 00       	push   $0x1f6
  803828:	68 51 49 80 00       	push   $0x804951
  80382d:	e8 9e cf ff ff       	call   8007d0 <_panic>
  803832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803835:	8b 10                	mov    (%eax),%edx
  803837:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80383a:	89 10                	mov    %edx,(%eax)
  80383c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0b                	je     803850 <realloc_block_FF+0x177>
  803845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803848:	8b 00                	mov    (%eax),%eax
  80384a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80384d:	89 50 04             	mov    %edx,0x4(%eax)
  803850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803853:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80385b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	85 c0                	test   %eax,%eax
  803868:	75 08                	jne    803872 <realloc_block_FF+0x199>
  80386a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80386d:	a3 30 50 80 00       	mov    %eax,0x805030
  803872:	a1 38 50 80 00       	mov    0x805038,%eax
  803877:	40                   	inc    %eax
  803878:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80387d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803881:	75 17                	jne    80389a <realloc_block_FF+0x1c1>
  803883:	83 ec 04             	sub    $0x4,%esp
  803886:	68 33 49 80 00       	push   $0x804933
  80388b:	68 f7 01 00 00       	push   $0x1f7
  803890:	68 51 49 80 00       	push   $0x804951
  803895:	e8 36 cf ff ff       	call   8007d0 <_panic>
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	85 c0                	test   %eax,%eax
  8038a1:	74 10                	je     8038b3 <realloc_block_FF+0x1da>
  8038a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ab:	8b 52 04             	mov    0x4(%edx),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	eb 0b                	jmp    8038be <realloc_block_FF+0x1e5>
  8038b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b6:	8b 40 04             	mov    0x4(%eax),%eax
  8038b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	85 c0                	test   %eax,%eax
  8038c6:	74 0f                	je     8038d7 <realloc_block_FF+0x1fe>
  8038c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cb:	8b 40 04             	mov    0x4(%eax),%eax
  8038ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d1:	8b 12                	mov    (%edx),%edx
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	eb 0a                	jmp    8038e1 <realloc_block_FF+0x208>
  8038d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8038f9:	48                   	dec    %eax
  8038fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8038ff:	e9 83 02 00 00       	jmp    803b87 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803904:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803908:	0f 86 69 02 00 00    	jbe    803b77 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80390e:	83 ec 04             	sub    $0x4,%esp
  803911:	6a 01                	push   $0x1
  803913:	ff 75 f0             	pushl  -0x10(%ebp)
  803916:	ff 75 08             	pushl  0x8(%ebp)
  803919:	e8 c8 ed ff ff       	call   8026e6 <set_block_data>
  80391e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	83 e8 04             	sub    $0x4,%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	83 e0 fe             	and    $0xfffffffe,%eax
  80392c:	89 c2                	mov    %eax,%edx
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	01 d0                	add    %edx,%eax
  803933:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803936:	a1 38 50 80 00       	mov    0x805038,%eax
  80393b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80393e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803942:	75 68                	jne    8039ac <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803944:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803948:	75 17                	jne    803961 <realloc_block_FF+0x288>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 6c 49 80 00       	push   $0x80496c
  803952:	68 06 02 00 00       	push   $0x206
  803957:	68 51 49 80 00       	push   $0x804951
  80395c:	e8 6f ce ff ff       	call   8007d0 <_panic>
  803961:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396a:	89 10                	mov    %edx,(%eax)
  80396c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396f:	8b 00                	mov    (%eax),%eax
  803971:	85 c0                	test   %eax,%eax
  803973:	74 0d                	je     803982 <realloc_block_FF+0x2a9>
  803975:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80397a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80397d:	89 50 04             	mov    %edx,0x4(%eax)
  803980:	eb 08                	jmp    80398a <realloc_block_FF+0x2b1>
  803982:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803985:	a3 30 50 80 00       	mov    %eax,0x805030
  80398a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803995:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399c:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a1:	40                   	inc    %eax
  8039a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8039a7:	e9 b0 01 00 00       	jmp    803b5c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8039ac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039b1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039b4:	76 68                	jbe    803a1e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039ba:	75 17                	jne    8039d3 <realloc_block_FF+0x2fa>
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 6c 49 80 00       	push   $0x80496c
  8039c4:	68 0b 02 00 00       	push   $0x20b
  8039c9:	68 51 49 80 00       	push   $0x804951
  8039ce:	e8 fd cd ff ff       	call   8007d0 <_panic>
  8039d3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039dc:	89 10                	mov    %edx,(%eax)
  8039de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	74 0d                	je     8039f4 <realloc_block_FF+0x31b>
  8039e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039ef:	89 50 04             	mov    %edx,0x4(%eax)
  8039f2:	eb 08                	jmp    8039fc <realloc_block_FF+0x323>
  8039f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8039fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0e:	a1 38 50 80 00       	mov    0x805038,%eax
  803a13:	40                   	inc    %eax
  803a14:	a3 38 50 80 00       	mov    %eax,0x805038
  803a19:	e9 3e 01 00 00       	jmp    803b5c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a1e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a23:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a26:	73 68                	jae    803a90 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a2c:	75 17                	jne    803a45 <realloc_block_FF+0x36c>
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	68 a0 49 80 00       	push   $0x8049a0
  803a36:	68 10 02 00 00       	push   $0x210
  803a3b:	68 51 49 80 00       	push   $0x804951
  803a40:	e8 8b cd ff ff       	call   8007d0 <_panic>
  803a45:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4e:	89 50 04             	mov    %edx,0x4(%eax)
  803a51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a54:	8b 40 04             	mov    0x4(%eax),%eax
  803a57:	85 c0                	test   %eax,%eax
  803a59:	74 0c                	je     803a67 <realloc_block_FF+0x38e>
  803a5b:	a1 30 50 80 00       	mov    0x805030,%eax
  803a60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a63:	89 10                	mov    %edx,(%eax)
  803a65:	eb 08                	jmp    803a6f <realloc_block_FF+0x396>
  803a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a72:	a3 30 50 80 00       	mov    %eax,0x805030
  803a77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a80:	a1 38 50 80 00       	mov    0x805038,%eax
  803a85:	40                   	inc    %eax
  803a86:	a3 38 50 80 00       	mov    %eax,0x805038
  803a8b:	e9 cc 00 00 00       	jmp    803b5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a97:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a9f:	e9 8a 00 00 00       	jmp    803b2e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aaa:	73 7a                	jae    803b26 <realloc_block_FF+0x44d>
  803aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ab4:	73 70                	jae    803b26 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aba:	74 06                	je     803ac2 <realloc_block_FF+0x3e9>
  803abc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ac0:	75 17                	jne    803ad9 <realloc_block_FF+0x400>
  803ac2:	83 ec 04             	sub    $0x4,%esp
  803ac5:	68 c4 49 80 00       	push   $0x8049c4
  803aca:	68 1a 02 00 00       	push   $0x21a
  803acf:	68 51 49 80 00       	push   $0x804951
  803ad4:	e8 f7 cc ff ff       	call   8007d0 <_panic>
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	8b 10                	mov    (%eax),%edx
  803ade:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae1:	89 10                	mov    %edx,(%eax)
  803ae3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	85 c0                	test   %eax,%eax
  803aea:	74 0b                	je     803af7 <realloc_block_FF+0x41e>
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	8b 00                	mov    (%eax),%eax
  803af1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803af4:	89 50 04             	mov    %edx,0x4(%eax)
  803af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803afd:	89 10                	mov    %edx,(%eax)
  803aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b05:	89 50 04             	mov    %edx,0x4(%eax)
  803b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0b:	8b 00                	mov    (%eax),%eax
  803b0d:	85 c0                	test   %eax,%eax
  803b0f:	75 08                	jne    803b19 <realloc_block_FF+0x440>
  803b11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b14:	a3 30 50 80 00       	mov    %eax,0x805030
  803b19:	a1 38 50 80 00       	mov    0x805038,%eax
  803b1e:	40                   	inc    %eax
  803b1f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b24:	eb 36                	jmp    803b5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b26:	a1 34 50 80 00       	mov    0x805034,%eax
  803b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b32:	74 07                	je     803b3b <realloc_block_FF+0x462>
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	8b 00                	mov    (%eax),%eax
  803b39:	eb 05                	jmp    803b40 <realloc_block_FF+0x467>
  803b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b40:	a3 34 50 80 00       	mov    %eax,0x805034
  803b45:	a1 34 50 80 00       	mov    0x805034,%eax
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	0f 85 52 ff ff ff    	jne    803aa4 <realloc_block_FF+0x3cb>
  803b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b56:	0f 85 48 ff ff ff    	jne    803aa4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	6a 00                	push   $0x0
  803b61:	ff 75 d8             	pushl  -0x28(%ebp)
  803b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b67:	e8 7a eb ff ff       	call   8026e6 <set_block_data>
  803b6c:	83 c4 10             	add    $0x10,%esp
				return va;
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	e9 7b 02 00 00       	jmp    803df2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b77:	83 ec 0c             	sub    $0xc,%esp
  803b7a:	68 41 4a 80 00       	push   $0x804a41
  803b7f:	e8 09 cf ff ff       	call   800a8d <cprintf>
  803b84:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	e9 63 02 00 00       	jmp    803df2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b95:	0f 86 4d 02 00 00    	jbe    803de8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803b9b:	83 ec 0c             	sub    $0xc,%esp
  803b9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ba1:	e8 08 e8 ff ff       	call   8023ae <is_free_block>
  803ba6:	83 c4 10             	add    $0x10,%esp
  803ba9:	84 c0                	test   %al,%al
  803bab:	0f 84 37 02 00 00    	je     803de8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803bb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803bba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803bbd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803bc0:	76 38                	jbe    803bfa <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803bc2:	83 ec 0c             	sub    $0xc,%esp
  803bc5:	ff 75 08             	pushl  0x8(%ebp)
  803bc8:	e8 0c fa ff ff       	call   8035d9 <free_block>
  803bcd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803bd0:	83 ec 0c             	sub    $0xc,%esp
  803bd3:	ff 75 0c             	pushl  0xc(%ebp)
  803bd6:	e8 3a eb ff ff       	call   802715 <alloc_block_FF>
  803bdb:	83 c4 10             	add    $0x10,%esp
  803bde:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803be1:	83 ec 08             	sub    $0x8,%esp
  803be4:	ff 75 c0             	pushl  -0x40(%ebp)
  803be7:	ff 75 08             	pushl  0x8(%ebp)
  803bea:	e8 ab fa ff ff       	call   80369a <copy_data>
  803bef:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803bf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bf5:	e9 f8 01 00 00       	jmp    803df2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bfd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c00:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c03:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c07:	0f 87 a0 00 00 00    	ja     803cad <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c11:	75 17                	jne    803c2a <realloc_block_FF+0x551>
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 33 49 80 00       	push   $0x804933
  803c1b:	68 38 02 00 00       	push   $0x238
  803c20:	68 51 49 80 00       	push   $0x804951
  803c25:	e8 a6 cb ff ff       	call   8007d0 <_panic>
  803c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	85 c0                	test   %eax,%eax
  803c31:	74 10                	je     803c43 <realloc_block_FF+0x56a>
  803c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c36:	8b 00                	mov    (%eax),%eax
  803c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c3b:	8b 52 04             	mov    0x4(%edx),%edx
  803c3e:	89 50 04             	mov    %edx,0x4(%eax)
  803c41:	eb 0b                	jmp    803c4e <realloc_block_FF+0x575>
  803c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c46:	8b 40 04             	mov    0x4(%eax),%eax
  803c49:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c51:	8b 40 04             	mov    0x4(%eax),%eax
  803c54:	85 c0                	test   %eax,%eax
  803c56:	74 0f                	je     803c67 <realloc_block_FF+0x58e>
  803c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5b:	8b 40 04             	mov    0x4(%eax),%eax
  803c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c61:	8b 12                	mov    (%edx),%edx
  803c63:	89 10                	mov    %edx,(%eax)
  803c65:	eb 0a                	jmp    803c71 <realloc_block_FF+0x598>
  803c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6a:	8b 00                	mov    (%eax),%eax
  803c6c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c84:	a1 38 50 80 00       	mov    0x805038,%eax
  803c89:	48                   	dec    %eax
  803c8a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c95:	01 d0                	add    %edx,%eax
  803c97:	83 ec 04             	sub    $0x4,%esp
  803c9a:	6a 01                	push   $0x1
  803c9c:	50                   	push   %eax
  803c9d:	ff 75 08             	pushl  0x8(%ebp)
  803ca0:	e8 41 ea ff ff       	call   8026e6 <set_block_data>
  803ca5:	83 c4 10             	add    $0x10,%esp
  803ca8:	e9 36 01 00 00       	jmp    803de3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803cad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cb3:	01 d0                	add    %edx,%eax
  803cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803cb8:	83 ec 04             	sub    $0x4,%esp
  803cbb:	6a 01                	push   $0x1
  803cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  803cc0:	ff 75 08             	pushl  0x8(%ebp)
  803cc3:	e8 1e ea ff ff       	call   8026e6 <set_block_data>
  803cc8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cce:	83 e8 04             	sub    $0x4,%eax
  803cd1:	8b 00                	mov    (%eax),%eax
  803cd3:	83 e0 fe             	and    $0xfffffffe,%eax
  803cd6:	89 c2                	mov    %eax,%edx
  803cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdb:	01 d0                	add    %edx,%eax
  803cdd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ce0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ce4:	74 06                	je     803cec <realloc_block_FF+0x613>
  803ce6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803cea:	75 17                	jne    803d03 <realloc_block_FF+0x62a>
  803cec:	83 ec 04             	sub    $0x4,%esp
  803cef:	68 c4 49 80 00       	push   $0x8049c4
  803cf4:	68 44 02 00 00       	push   $0x244
  803cf9:	68 51 49 80 00       	push   $0x804951
  803cfe:	e8 cd ca ff ff       	call   8007d0 <_panic>
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	8b 10                	mov    (%eax),%edx
  803d08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d0b:	89 10                	mov    %edx,(%eax)
  803d0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d10:	8b 00                	mov    (%eax),%eax
  803d12:	85 c0                	test   %eax,%eax
  803d14:	74 0b                	je     803d21 <realloc_block_FF+0x648>
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d1e:	89 50 04             	mov    %edx,0x4(%eax)
  803d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d24:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d27:	89 10                	mov    %edx,(%eax)
  803d29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d2f:	89 50 04             	mov    %edx,0x4(%eax)
  803d32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d35:	8b 00                	mov    (%eax),%eax
  803d37:	85 c0                	test   %eax,%eax
  803d39:	75 08                	jne    803d43 <realloc_block_FF+0x66a>
  803d3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d3e:	a3 30 50 80 00       	mov    %eax,0x805030
  803d43:	a1 38 50 80 00       	mov    0x805038,%eax
  803d48:	40                   	inc    %eax
  803d49:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d52:	75 17                	jne    803d6b <realloc_block_FF+0x692>
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	68 33 49 80 00       	push   $0x804933
  803d5c:	68 45 02 00 00       	push   $0x245
  803d61:	68 51 49 80 00       	push   $0x804951
  803d66:	e8 65 ca ff ff       	call   8007d0 <_panic>
  803d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	74 10                	je     803d84 <realloc_block_FF+0x6ab>
  803d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d7c:	8b 52 04             	mov    0x4(%edx),%edx
  803d7f:	89 50 04             	mov    %edx,0x4(%eax)
  803d82:	eb 0b                	jmp    803d8f <realloc_block_FF+0x6b6>
  803d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d87:	8b 40 04             	mov    0x4(%eax),%eax
  803d8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 0f                	je     803da8 <realloc_block_FF+0x6cf>
  803d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9c:	8b 40 04             	mov    0x4(%eax),%eax
  803d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da2:	8b 12                	mov    (%edx),%edx
  803da4:	89 10                	mov    %edx,(%eax)
  803da6:	eb 0a                	jmp    803db2 <realloc_block_FF+0x6d9>
  803da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dab:	8b 00                	mov    (%eax),%eax
  803dad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc5:	a1 38 50 80 00       	mov    0x805038,%eax
  803dca:	48                   	dec    %eax
  803dcb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803dd0:	83 ec 04             	sub    $0x4,%esp
  803dd3:	6a 00                	push   $0x0
  803dd5:	ff 75 bc             	pushl  -0x44(%ebp)
  803dd8:	ff 75 b8             	pushl  -0x48(%ebp)
  803ddb:	e8 06 e9 ff ff       	call   8026e6 <set_block_data>
  803de0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	eb 0a                	jmp    803df2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803de8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803df2:	c9                   	leave  
  803df3:	c3                   	ret    

00803df4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803df4:	55                   	push   %ebp
  803df5:	89 e5                	mov    %esp,%ebp
  803df7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803dfa:	83 ec 04             	sub    $0x4,%esp
  803dfd:	68 48 4a 80 00       	push   $0x804a48
  803e02:	68 58 02 00 00       	push   $0x258
  803e07:	68 51 49 80 00       	push   $0x804951
  803e0c:	e8 bf c9 ff ff       	call   8007d0 <_panic>

00803e11 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e11:	55                   	push   %ebp
  803e12:	89 e5                	mov    %esp,%ebp
  803e14:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e17:	83 ec 04             	sub    $0x4,%esp
  803e1a:	68 70 4a 80 00       	push   $0x804a70
  803e1f:	68 61 02 00 00       	push   $0x261
  803e24:	68 51 49 80 00       	push   $0x804951
  803e29:	e8 a2 c9 ff ff       	call   8007d0 <_panic>

00803e2e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803e2e:	55                   	push   %ebp
  803e2f:	89 e5                	mov    %esp,%ebp
  803e31:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803e34:	83 ec 04             	sub    $0x4,%esp
  803e37:	68 98 4a 80 00       	push   $0x804a98
  803e3c:	6a 09                	push   $0x9
  803e3e:	68 c0 4a 80 00       	push   $0x804ac0
  803e43:	e8 88 c9 ff ff       	call   8007d0 <_panic>

00803e48 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803e48:	55                   	push   %ebp
  803e49:	89 e5                	mov    %esp,%ebp
  803e4b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803e4e:	83 ec 04             	sub    $0x4,%esp
  803e51:	68 d0 4a 80 00       	push   $0x804ad0
  803e56:	6a 10                	push   $0x10
  803e58:	68 c0 4a 80 00       	push   $0x804ac0
  803e5d:	e8 6e c9 ff ff       	call   8007d0 <_panic>

00803e62 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803e62:	55                   	push   %ebp
  803e63:	89 e5                	mov    %esp,%ebp
  803e65:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803e68:	83 ec 04             	sub    $0x4,%esp
  803e6b:	68 f8 4a 80 00       	push   $0x804af8
  803e70:	6a 18                	push   $0x18
  803e72:	68 c0 4a 80 00       	push   $0x804ac0
  803e77:	e8 54 c9 ff ff       	call   8007d0 <_panic>

00803e7c <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803e7c:	55                   	push   %ebp
  803e7d:	89 e5                	mov    %esp,%ebp
  803e7f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803e82:	83 ec 04             	sub    $0x4,%esp
  803e85:	68 20 4b 80 00       	push   $0x804b20
  803e8a:	6a 20                	push   $0x20
  803e8c:	68 c0 4a 80 00       	push   $0x804ac0
  803e91:	e8 3a c9 ff ff       	call   8007d0 <_panic>

00803e96 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803e96:	55                   	push   %ebp
  803e97:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e99:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9c:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e9f:	5d                   	pop    %ebp
  803ea0:	c3                   	ret    
  803ea1:	66 90                	xchg   %ax,%ax
  803ea3:	90                   	nop

00803ea4 <__udivdi3>:
  803ea4:	55                   	push   %ebp
  803ea5:	57                   	push   %edi
  803ea6:	56                   	push   %esi
  803ea7:	53                   	push   %ebx
  803ea8:	83 ec 1c             	sub    $0x1c,%esp
  803eab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803eaf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ebb:	89 ca                	mov    %ecx,%edx
  803ebd:	89 f8                	mov    %edi,%eax
  803ebf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ec3:	85 f6                	test   %esi,%esi
  803ec5:	75 2d                	jne    803ef4 <__udivdi3+0x50>
  803ec7:	39 cf                	cmp    %ecx,%edi
  803ec9:	77 65                	ja     803f30 <__udivdi3+0x8c>
  803ecb:	89 fd                	mov    %edi,%ebp
  803ecd:	85 ff                	test   %edi,%edi
  803ecf:	75 0b                	jne    803edc <__udivdi3+0x38>
  803ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed6:	31 d2                	xor    %edx,%edx
  803ed8:	f7 f7                	div    %edi
  803eda:	89 c5                	mov    %eax,%ebp
  803edc:	31 d2                	xor    %edx,%edx
  803ede:	89 c8                	mov    %ecx,%eax
  803ee0:	f7 f5                	div    %ebp
  803ee2:	89 c1                	mov    %eax,%ecx
  803ee4:	89 d8                	mov    %ebx,%eax
  803ee6:	f7 f5                	div    %ebp
  803ee8:	89 cf                	mov    %ecx,%edi
  803eea:	89 fa                	mov    %edi,%edx
  803eec:	83 c4 1c             	add    $0x1c,%esp
  803eef:	5b                   	pop    %ebx
  803ef0:	5e                   	pop    %esi
  803ef1:	5f                   	pop    %edi
  803ef2:	5d                   	pop    %ebp
  803ef3:	c3                   	ret    
  803ef4:	39 ce                	cmp    %ecx,%esi
  803ef6:	77 28                	ja     803f20 <__udivdi3+0x7c>
  803ef8:	0f bd fe             	bsr    %esi,%edi
  803efb:	83 f7 1f             	xor    $0x1f,%edi
  803efe:	75 40                	jne    803f40 <__udivdi3+0x9c>
  803f00:	39 ce                	cmp    %ecx,%esi
  803f02:	72 0a                	jb     803f0e <__udivdi3+0x6a>
  803f04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f08:	0f 87 9e 00 00 00    	ja     803fac <__udivdi3+0x108>
  803f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f13:	89 fa                	mov    %edi,%edx
  803f15:	83 c4 1c             	add    $0x1c,%esp
  803f18:	5b                   	pop    %ebx
  803f19:	5e                   	pop    %esi
  803f1a:	5f                   	pop    %edi
  803f1b:	5d                   	pop    %ebp
  803f1c:	c3                   	ret    
  803f1d:	8d 76 00             	lea    0x0(%esi),%esi
  803f20:	31 ff                	xor    %edi,%edi
  803f22:	31 c0                	xor    %eax,%eax
  803f24:	89 fa                	mov    %edi,%edx
  803f26:	83 c4 1c             	add    $0x1c,%esp
  803f29:	5b                   	pop    %ebx
  803f2a:	5e                   	pop    %esi
  803f2b:	5f                   	pop    %edi
  803f2c:	5d                   	pop    %ebp
  803f2d:	c3                   	ret    
  803f2e:	66 90                	xchg   %ax,%ax
  803f30:	89 d8                	mov    %ebx,%eax
  803f32:	f7 f7                	div    %edi
  803f34:	31 ff                	xor    %edi,%edi
  803f36:	89 fa                	mov    %edi,%edx
  803f38:	83 c4 1c             	add    $0x1c,%esp
  803f3b:	5b                   	pop    %ebx
  803f3c:	5e                   	pop    %esi
  803f3d:	5f                   	pop    %edi
  803f3e:	5d                   	pop    %ebp
  803f3f:	c3                   	ret    
  803f40:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f45:	89 eb                	mov    %ebp,%ebx
  803f47:	29 fb                	sub    %edi,%ebx
  803f49:	89 f9                	mov    %edi,%ecx
  803f4b:	d3 e6                	shl    %cl,%esi
  803f4d:	89 c5                	mov    %eax,%ebp
  803f4f:	88 d9                	mov    %bl,%cl
  803f51:	d3 ed                	shr    %cl,%ebp
  803f53:	89 e9                	mov    %ebp,%ecx
  803f55:	09 f1                	or     %esi,%ecx
  803f57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f5b:	89 f9                	mov    %edi,%ecx
  803f5d:	d3 e0                	shl    %cl,%eax
  803f5f:	89 c5                	mov    %eax,%ebp
  803f61:	89 d6                	mov    %edx,%esi
  803f63:	88 d9                	mov    %bl,%cl
  803f65:	d3 ee                	shr    %cl,%esi
  803f67:	89 f9                	mov    %edi,%ecx
  803f69:	d3 e2                	shl    %cl,%edx
  803f6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f6f:	88 d9                	mov    %bl,%cl
  803f71:	d3 e8                	shr    %cl,%eax
  803f73:	09 c2                	or     %eax,%edx
  803f75:	89 d0                	mov    %edx,%eax
  803f77:	89 f2                	mov    %esi,%edx
  803f79:	f7 74 24 0c          	divl   0xc(%esp)
  803f7d:	89 d6                	mov    %edx,%esi
  803f7f:	89 c3                	mov    %eax,%ebx
  803f81:	f7 e5                	mul    %ebp
  803f83:	39 d6                	cmp    %edx,%esi
  803f85:	72 19                	jb     803fa0 <__udivdi3+0xfc>
  803f87:	74 0b                	je     803f94 <__udivdi3+0xf0>
  803f89:	89 d8                	mov    %ebx,%eax
  803f8b:	31 ff                	xor    %edi,%edi
  803f8d:	e9 58 ff ff ff       	jmp    803eea <__udivdi3+0x46>
  803f92:	66 90                	xchg   %ax,%ax
  803f94:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f98:	89 f9                	mov    %edi,%ecx
  803f9a:	d3 e2                	shl    %cl,%edx
  803f9c:	39 c2                	cmp    %eax,%edx
  803f9e:	73 e9                	jae    803f89 <__udivdi3+0xe5>
  803fa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fa3:	31 ff                	xor    %edi,%edi
  803fa5:	e9 40 ff ff ff       	jmp    803eea <__udivdi3+0x46>
  803faa:	66 90                	xchg   %ax,%ax
  803fac:	31 c0                	xor    %eax,%eax
  803fae:	e9 37 ff ff ff       	jmp    803eea <__udivdi3+0x46>
  803fb3:	90                   	nop

00803fb4 <__umoddi3>:
  803fb4:	55                   	push   %ebp
  803fb5:	57                   	push   %edi
  803fb6:	56                   	push   %esi
  803fb7:	53                   	push   %ebx
  803fb8:	83 ec 1c             	sub    $0x1c,%esp
  803fbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fd3:	89 f3                	mov    %esi,%ebx
  803fd5:	89 fa                	mov    %edi,%edx
  803fd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fdb:	89 34 24             	mov    %esi,(%esp)
  803fde:	85 c0                	test   %eax,%eax
  803fe0:	75 1a                	jne    803ffc <__umoddi3+0x48>
  803fe2:	39 f7                	cmp    %esi,%edi
  803fe4:	0f 86 a2 00 00 00    	jbe    80408c <__umoddi3+0xd8>
  803fea:	89 c8                	mov    %ecx,%eax
  803fec:	89 f2                	mov    %esi,%edx
  803fee:	f7 f7                	div    %edi
  803ff0:	89 d0                	mov    %edx,%eax
  803ff2:	31 d2                	xor    %edx,%edx
  803ff4:	83 c4 1c             	add    $0x1c,%esp
  803ff7:	5b                   	pop    %ebx
  803ff8:	5e                   	pop    %esi
  803ff9:	5f                   	pop    %edi
  803ffa:	5d                   	pop    %ebp
  803ffb:	c3                   	ret    
  803ffc:	39 f0                	cmp    %esi,%eax
  803ffe:	0f 87 ac 00 00 00    	ja     8040b0 <__umoddi3+0xfc>
  804004:	0f bd e8             	bsr    %eax,%ebp
  804007:	83 f5 1f             	xor    $0x1f,%ebp
  80400a:	0f 84 ac 00 00 00    	je     8040bc <__umoddi3+0x108>
  804010:	bf 20 00 00 00       	mov    $0x20,%edi
  804015:	29 ef                	sub    %ebp,%edi
  804017:	89 fe                	mov    %edi,%esi
  804019:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80401d:	89 e9                	mov    %ebp,%ecx
  80401f:	d3 e0                	shl    %cl,%eax
  804021:	89 d7                	mov    %edx,%edi
  804023:	89 f1                	mov    %esi,%ecx
  804025:	d3 ef                	shr    %cl,%edi
  804027:	09 c7                	or     %eax,%edi
  804029:	89 e9                	mov    %ebp,%ecx
  80402b:	d3 e2                	shl    %cl,%edx
  80402d:	89 14 24             	mov    %edx,(%esp)
  804030:	89 d8                	mov    %ebx,%eax
  804032:	d3 e0                	shl    %cl,%eax
  804034:	89 c2                	mov    %eax,%edx
  804036:	8b 44 24 08          	mov    0x8(%esp),%eax
  80403a:	d3 e0                	shl    %cl,%eax
  80403c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804040:	8b 44 24 08          	mov    0x8(%esp),%eax
  804044:	89 f1                	mov    %esi,%ecx
  804046:	d3 e8                	shr    %cl,%eax
  804048:	09 d0                	or     %edx,%eax
  80404a:	d3 eb                	shr    %cl,%ebx
  80404c:	89 da                	mov    %ebx,%edx
  80404e:	f7 f7                	div    %edi
  804050:	89 d3                	mov    %edx,%ebx
  804052:	f7 24 24             	mull   (%esp)
  804055:	89 c6                	mov    %eax,%esi
  804057:	89 d1                	mov    %edx,%ecx
  804059:	39 d3                	cmp    %edx,%ebx
  80405b:	0f 82 87 00 00 00    	jb     8040e8 <__umoddi3+0x134>
  804061:	0f 84 91 00 00 00    	je     8040f8 <__umoddi3+0x144>
  804067:	8b 54 24 04          	mov    0x4(%esp),%edx
  80406b:	29 f2                	sub    %esi,%edx
  80406d:	19 cb                	sbb    %ecx,%ebx
  80406f:	89 d8                	mov    %ebx,%eax
  804071:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804075:	d3 e0                	shl    %cl,%eax
  804077:	89 e9                	mov    %ebp,%ecx
  804079:	d3 ea                	shr    %cl,%edx
  80407b:	09 d0                	or     %edx,%eax
  80407d:	89 e9                	mov    %ebp,%ecx
  80407f:	d3 eb                	shr    %cl,%ebx
  804081:	89 da                	mov    %ebx,%edx
  804083:	83 c4 1c             	add    $0x1c,%esp
  804086:	5b                   	pop    %ebx
  804087:	5e                   	pop    %esi
  804088:	5f                   	pop    %edi
  804089:	5d                   	pop    %ebp
  80408a:	c3                   	ret    
  80408b:	90                   	nop
  80408c:	89 fd                	mov    %edi,%ebp
  80408e:	85 ff                	test   %edi,%edi
  804090:	75 0b                	jne    80409d <__umoddi3+0xe9>
  804092:	b8 01 00 00 00       	mov    $0x1,%eax
  804097:	31 d2                	xor    %edx,%edx
  804099:	f7 f7                	div    %edi
  80409b:	89 c5                	mov    %eax,%ebp
  80409d:	89 f0                	mov    %esi,%eax
  80409f:	31 d2                	xor    %edx,%edx
  8040a1:	f7 f5                	div    %ebp
  8040a3:	89 c8                	mov    %ecx,%eax
  8040a5:	f7 f5                	div    %ebp
  8040a7:	89 d0                	mov    %edx,%eax
  8040a9:	e9 44 ff ff ff       	jmp    803ff2 <__umoddi3+0x3e>
  8040ae:	66 90                	xchg   %ax,%ax
  8040b0:	89 c8                	mov    %ecx,%eax
  8040b2:	89 f2                	mov    %esi,%edx
  8040b4:	83 c4 1c             	add    $0x1c,%esp
  8040b7:	5b                   	pop    %ebx
  8040b8:	5e                   	pop    %esi
  8040b9:	5f                   	pop    %edi
  8040ba:	5d                   	pop    %ebp
  8040bb:	c3                   	ret    
  8040bc:	3b 04 24             	cmp    (%esp),%eax
  8040bf:	72 06                	jb     8040c7 <__umoddi3+0x113>
  8040c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040c5:	77 0f                	ja     8040d6 <__umoddi3+0x122>
  8040c7:	89 f2                	mov    %esi,%edx
  8040c9:	29 f9                	sub    %edi,%ecx
  8040cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040cf:	89 14 24             	mov    %edx,(%esp)
  8040d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040da:	8b 14 24             	mov    (%esp),%edx
  8040dd:	83 c4 1c             	add    $0x1c,%esp
  8040e0:	5b                   	pop    %ebx
  8040e1:	5e                   	pop    %esi
  8040e2:	5f                   	pop    %edi
  8040e3:	5d                   	pop    %ebp
  8040e4:	c3                   	ret    
  8040e5:	8d 76 00             	lea    0x0(%esi),%esi
  8040e8:	2b 04 24             	sub    (%esp),%eax
  8040eb:	19 fa                	sbb    %edi,%edx
  8040ed:	89 d1                	mov    %edx,%ecx
  8040ef:	89 c6                	mov    %eax,%esi
  8040f1:	e9 71 ff ff ff       	jmp    804067 <__umoddi3+0xb3>
  8040f6:	66 90                	xchg   %ax,%ax
  8040f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040fc:	72 ea                	jb     8040e8 <__umoddi3+0x134>
  8040fe:	89 d9                	mov    %ebx,%ecx
  804100:	e9 62 ff ff ff       	jmp    804067 <__umoddi3+0xb3>

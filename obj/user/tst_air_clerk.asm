
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
  800044:	e8 b8 1f 00 00       	call   802001 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb d5 40 80 00       	mov    $0x8040d5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb df 40 80 00       	mov    $0x8040df,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb eb 40 80 00       	mov    $0x8040eb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb fa 40 80 00       	mov    $0x8040fa,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 09 41 80 00       	mov    $0x804109,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 1e 41 80 00       	mov    $0x80411e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 33 41 80 00       	mov    $0x804133,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 44 41 80 00       	mov    $0x804144,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 55 41 80 00       	mov    $0x804155,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 66 41 80 00       	mov    $0x804166,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 6f 41 80 00       	mov    $0x80416f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 79 41 80 00       	mov    $0x804179,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 84 41 80 00       	mov    $0x804184,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 90 41 80 00       	mov    $0x804190,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 9a 41 80 00       	mov    $0x80419a,%ebx
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
  8001c1:	bb a4 41 80 00       	mov    $0x8041a4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb b2 41 80 00       	mov    $0x8041b2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb c1 41 80 00       	mov    $0x8041c1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb c8 41 80 00       	mov    $0x8041c8,%ebx
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
  800225:	e8 bf 19 00 00       	call   801be9 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 aa 19 00 00       	call   801be9 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 95 19 00 00       	call   801be9 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 7d 19 00 00       	call   801be9 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 65 19 00 00       	call   801be9 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 4d 19 00 00       	call   801be9 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 35 19 00 00       	call   801be9 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 1d 19 00 00       	call   801be9 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 05 19 00 00       	call   801be9 <sget>
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
  8002fe:	e8 d8 3a 00 00       	call   803ddb <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 bc 3a 00 00       	call   803ddb <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 a0 3a 00 00       	call   803ddb <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 84 3a 00 00       	call   803ddb <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 68 3a 00 00       	call   803ddb <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 71 3a 00 00       	call   803df5 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 60 3a 00 00       	call   803df5 <wait_semaphore>
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
  8003c4:	e8 46 3a 00 00       	call   803e0f <signal_semaphore>
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
  800407:	e8 e9 39 00 00       	call   803df5 <wait_semaphore>
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
  800467:	e8 a3 39 00 00       	call   803e0f <signal_semaphore>
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
  80047d:	e8 73 39 00 00       	call   803df5 <wait_semaphore>
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
  8004dd:	e8 2d 39 00 00       	call   803e0f <signal_semaphore>
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
  8004f3:	e8 fd 38 00 00       	call   803df5 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 ec 38 00 00       	call   803df5 <wait_semaphore>
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
  8005bb:	e8 4f 38 00 00       	call   803e0f <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 3e 38 00 00       	call   803e0f <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 a0 40 80 00       	push   $0x8040a0
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 c0 40 80 00       	push   $0x8040c0
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb cf 41 80 00       	mov    $0x8041cf,%ebx
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
  800662:	e8 74 37 00 00       	call   803ddb <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 97 37 00 00       	call   803e0f <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 86 37 00 00       	call   803e0f <signal_semaphore>
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
  800697:	e8 4c 19 00 00       	call   801fe8 <sys_getenvindex>
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
  800705:	e8 62 16 00 00       	call   801d6c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 08 42 80 00       	push   $0x804208
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
  800735:	68 30 42 80 00       	push   $0x804230
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
  800766:	68 58 42 80 00       	push   $0x804258
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 b0 42 80 00       	push   $0x8042b0
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 08 42 80 00       	push   $0x804208
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 e2 15 00 00       	call   801d86 <sys_unlock_cons>
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
  8007b7:	e8 f8 17 00 00       	call   801fb4 <sys_destroy_env>
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
  8007c8:	e8 4d 18 00 00       	call   80201a <sys_exit_env>
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
  8007f1:	68 c4 42 80 00       	push   $0x8042c4
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 c9 42 80 00       	push   $0x8042c9
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
  80082e:	68 e5 42 80 00       	push   $0x8042e5
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
  80085d:	68 e8 42 80 00       	push   $0x8042e8
  800862:	6a 26                	push   $0x26
  800864:	68 34 43 80 00       	push   $0x804334
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
  800932:	68 40 43 80 00       	push   $0x804340
  800937:	6a 3a                	push   $0x3a
  800939:	68 34 43 80 00       	push   $0x804334
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
  8009a5:	68 94 43 80 00       	push   $0x804394
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 34 43 80 00       	push   $0x804334
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
  8009ff:	e8 26 13 00 00       	call   801d2a <sys_cputs>
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
  800a76:	e8 af 12 00 00       	call   801d2a <sys_cputs>
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
  800ac0:	e8 a7 12 00 00       	call   801d6c <sys_lock_cons>
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
  800ae0:	e8 a1 12 00 00       	call   801d86 <sys_unlock_cons>
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
  800b2a:	e8 05 33 00 00       	call   803e34 <__udivdi3>
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
  800b7a:	e8 c5 33 00 00       	call   803f44 <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 f4 45 80 00       	add    $0x8045f4,%eax
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
  800cd5:	8b 04 85 18 46 80 00 	mov    0x804618(,%eax,4),%eax
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
  800db6:	8b 34 9d 60 44 80 00 	mov    0x804460(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 05 46 80 00       	push   $0x804605
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
  800ddb:	68 0e 46 80 00       	push   $0x80460e
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
  800e08:	be 11 46 80 00       	mov    $0x804611,%esi
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
  801813:	68 88 47 80 00       	push   $0x804788
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 aa 47 80 00       	push   $0x8047aa
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
  801833:	e8 9d 0a 00 00       	call   8022d5 <sys_sbrk>
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
  8018ae:	e8 a6 08 00 00       	call   802159 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 e6 0d 00 00       	call   8026a8 <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 b8 08 00 00       	call   80218a <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 7f 12 00 00       	call   802b64 <alloc_block_BF>
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
  801930:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  80197d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8019d4:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801a36:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	ff 75 f0             	pushl  -0x10(%ebp)
  801a46:	e8 c1 08 00 00       	call   80230c <sys_allocate_user_mem>
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
  801a8e:	e8 95 08 00 00       	call   802328 <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 c8 1a 00 00       	call   80356c <free_block>
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
  801ad9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801b16:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801b36:	e8 b5 07 00 00       	call   8022f0 <sys_free_user_mem>
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
  801b44:	68 b8 47 80 00       	push   $0x8047b8
  801b49:	68 84 00 00 00       	push   $0x84
  801b4e:	68 e2 47 80 00       	push   $0x8047e2
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
  801b6a:	75 07                	jne    801b73 <smalloc+0x19>
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b71:	eb 74                	jmp    801be7 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b79:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	39 d0                	cmp    %edx,%eax
  801b88:	73 02                	jae    801b8c <smalloc+0x32>
  801b8a:	89 d0                	mov    %edx,%eax
  801b8c:	83 ec 0c             	sub    $0xc,%esp
  801b8f:	50                   	push   %eax
  801b90:	e8 a8 fc ff ff       	call   80183d <malloc>
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801b9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b9f:	75 07                	jne    801ba8 <smalloc+0x4e>
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba6:	eb 3f                	jmp    801be7 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801ba8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bac:	ff 75 ec             	pushl  -0x14(%ebp)
  801baf:	50                   	push   %eax
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	e8 3c 03 00 00       	call   801ef7 <sys_createSharedObject>
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801bc1:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bc5:	74 06                	je     801bcd <smalloc+0x73>
  801bc7:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bcb:	75 07                	jne    801bd4 <smalloc+0x7a>
  801bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd2:	eb 13                	jmp    801be7 <smalloc+0x8d>
	 cprintf("153\n");
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	68 ee 47 80 00       	push   $0x8047ee
  801bdc:	e8 ac ee ff ff       	call   800a8d <cprintf>
  801be1:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	e8 24 03 00 00       	call   801f21 <sys_getSizeOfSharedObject>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c03:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c07:	75 07                	jne    801c10 <sget+0x27>
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	eb 5c                	jmp    801c6c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c16:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	39 d0                	cmp    %edx,%eax
  801c25:	7d 02                	jge    801c29 <sget+0x40>
  801c27:	89 d0                	mov    %edx,%eax
  801c29:	83 ec 0c             	sub    $0xc,%esp
  801c2c:	50                   	push   %eax
  801c2d:	e8 0b fc ff ff       	call   80183d <malloc>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c3c:	75 07                	jne    801c45 <sget+0x5c>
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c43:	eb 27                	jmp    801c6c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	ff 75 e8             	pushl  -0x18(%ebp)
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	e8 e8 02 00 00       	call   801f3e <sys_getSharedObject>
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c5c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c60:	75 07                	jne    801c69 <sget+0x80>
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
  801c67:	eb 03                	jmp    801c6c <sget+0x83>
	return ptr;
  801c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	68 f4 47 80 00       	push   $0x8047f4
  801c7c:	68 c2 00 00 00       	push   $0xc2
  801c81:	68 e2 47 80 00       	push   $0x8047e2
  801c86:	e8 45 eb ff ff       	call   8007d0 <_panic>

00801c8b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	68 18 48 80 00       	push   $0x804818
  801c99:	68 d9 00 00 00       	push   $0xd9
  801c9e:	68 e2 47 80 00       	push   $0x8047e2
  801ca3:	e8 28 eb ff ff       	call   8007d0 <_panic>

00801ca8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cae:	83 ec 04             	sub    $0x4,%esp
  801cb1:	68 3e 48 80 00       	push   $0x80483e
  801cb6:	68 e5 00 00 00       	push   $0xe5
  801cbb:	68 e2 47 80 00       	push   $0x8047e2
  801cc0:	e8 0b eb ff ff       	call   8007d0 <_panic>

00801cc5 <shrink>:

}
void shrink(uint32 newSize)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	68 3e 48 80 00       	push   $0x80483e
  801cd3:	68 ea 00 00 00       	push   $0xea
  801cd8:	68 e2 47 80 00       	push   $0x8047e2
  801cdd:	e8 ee ea ff ff       	call   8007d0 <_panic>

00801ce2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	68 3e 48 80 00       	push   $0x80483e
  801cf0:	68 ef 00 00 00       	push   $0xef
  801cf5:	68 e2 47 80 00       	push   $0x8047e2
  801cfa:	e8 d1 ea ff ff       	call   8007d0 <_panic>

00801cff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	57                   	push   %edi
  801d03:	56                   	push   %esi
  801d04:	53                   	push   %ebx
  801d05:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d14:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d17:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d1a:	cd 30                	int    $0x30
  801d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	8b 45 10             	mov    0x10(%ebp),%eax
  801d33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	6a 00                	push   $0x0
  801d48:	e8 b2 ff ff ff       	call   801cff <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	90                   	nop
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 02                	push   $0x2
  801d62:	e8 98 ff ff ff       	call   801cff <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 03                	push   $0x3
  801d7b:	e8 7f ff ff ff       	call   801cff <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	90                   	nop
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 04                	push   $0x4
  801d95:	e8 65 ff ff ff       	call   801cff <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	90                   	nop
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	52                   	push   %edx
  801db0:	50                   	push   %eax
  801db1:	6a 08                	push   $0x8
  801db3:	e8 47 ff ff ff       	call   801cff <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801dc2:	8b 75 18             	mov    0x18(%ebp),%esi
  801dc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	51                   	push   %ecx
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	6a 09                	push   $0x9
  801dd8:	e8 22 ff ff ff       	call   801cff <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 0a                	push   $0xa
  801dfa:	e8 00 ff ff ff       	call   801cff <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	6a 0b                	push   $0xb
  801e15:	e8 e5 fe ff ff       	call   801cff <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 0c                	push   $0xc
  801e2e:	e8 cc fe ff ff       	call   801cff <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 0d                	push   $0xd
  801e47:	e8 b3 fe ff ff       	call   801cff <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 0e                	push   $0xe
  801e60:	e8 9a fe ff ff       	call   801cff <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 0f                	push   $0xf
  801e79:	e8 81 fe ff ff       	call   801cff <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	6a 10                	push   $0x10
  801e93:	e8 67 fe ff ff       	call   801cff <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 11                	push   $0x11
  801eac:	e8 4e fe ff ff       	call   801cff <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	90                   	nop
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_cputc>:

void
sys_cputc(const char c)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ec3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	50                   	push   %eax
  801ed0:	6a 01                	push   $0x1
  801ed2:	e8 28 fe ff ff       	call   801cff <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	90                   	nop
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 14                	push   $0x14
  801eec:	e8 0e fe ff ff       	call   801cff <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	90                   	nop
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	8b 45 10             	mov    0x10(%ebp),%eax
  801f00:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	51                   	push   %ecx
  801f10:	52                   	push   %edx
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	50                   	push   %eax
  801f15:	6a 15                	push   $0x15
  801f17:	e8 e3 fd ff ff       	call   801cff <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 16                	push   $0x16
  801f34:	e8 c6 fd ff ff       	call   801cff <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	51                   	push   %ecx
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	6a 17                	push   $0x17
  801f53:	e8 a7 fd ff ff       	call   801cff <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	6a 18                	push   $0x18
  801f70:	e8 8a fd ff ff       	call   801cff <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 14             	pushl  0x14(%ebp)
  801f85:	ff 75 10             	pushl  0x10(%ebp)
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	50                   	push   %eax
  801f8c:	6a 19                	push   $0x19
  801f8e:	e8 6c fd ff ff       	call   801cff <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	50                   	push   %eax
  801fa7:	6a 1a                	push   $0x1a
  801fa9:	e8 51 fd ff ff       	call   801cff <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	50                   	push   %eax
  801fc3:	6a 1b                	push   $0x1b
  801fc5:	e8 35 fd ff ff       	call   801cff <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 05                	push   $0x5
  801fde:	e8 1c fd ff ff       	call   801cff <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 06                	push   $0x6
  801ff7:	e8 03 fd ff ff       	call   801cff <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 07                	push   $0x7
  802010:	e8 ea fc ff ff       	call   801cff <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_exit_env>:


void sys_exit_env(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 1c                	push   $0x1c
  802029:	e8 d1 fc ff ff       	call   801cff <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	90                   	nop
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80203a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80203d:	8d 50 04             	lea    0x4(%eax),%edx
  802040:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	52                   	push   %edx
  80204a:	50                   	push   %eax
  80204b:	6a 1d                	push   $0x1d
  80204d:	e8 ad fc ff ff       	call   801cff <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
	return result;
  802055:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802058:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80205b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80205e:	89 01                	mov    %eax,(%ecx)
  802060:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	c9                   	leave  
  802067:	c2 04 00             	ret    $0x4

0080206a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	ff 75 08             	pushl  0x8(%ebp)
  80207a:	6a 13                	push   $0x13
  80207c:	e8 7e fc ff ff       	call   801cff <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
	return ;
  802084:	90                   	nop
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_rcr2>:
uint32 sys_rcr2()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 1e                	push   $0x1e
  802096:	e8 64 fc ff ff       	call   801cff <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020ac:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	50                   	push   %eax
  8020b9:	6a 1f                	push   $0x1f
  8020bb:	e8 3f fc ff ff       	call   801cff <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c3:	90                   	nop
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <rsttst>:
void rsttst()
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 21                	push   $0x21
  8020d5:	e8 25 fc ff ff       	call   801cff <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
	return ;
  8020dd:	90                   	nop
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020ec:	8b 55 18             	mov    0x18(%ebp),%edx
  8020ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f3:	52                   	push   %edx
  8020f4:	50                   	push   %eax
  8020f5:	ff 75 10             	pushl  0x10(%ebp)
  8020f8:	ff 75 0c             	pushl  0xc(%ebp)
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	6a 20                	push   $0x20
  802100:	e8 fa fb ff ff       	call   801cff <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
	return ;
  802108:	90                   	nop
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <chktst>:
void chktst(uint32 n)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	6a 22                	push   $0x22
  80211b:	e8 df fb ff ff       	call   801cff <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
	return ;
  802123:	90                   	nop
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <inctst>:

void inctst()
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 23                	push   $0x23
  802135:	e8 c5 fb ff ff       	call   801cff <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
	return ;
  80213d:	90                   	nop
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <gettst>:
uint32 gettst()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 24                	push   $0x24
  80214f:	e8 ab fb ff ff       	call   801cff <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 25                	push   $0x25
  80216b:	e8 8f fb ff ff       	call   801cff <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
  802173:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802176:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80217a:	75 07                	jne    802183 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80217c:	b8 01 00 00 00       	mov    $0x1,%eax
  802181:	eb 05                	jmp    802188 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802183:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 25                	push   $0x25
  80219c:	e8 5e fb ff ff       	call   801cff <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021a7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021ab:	75 07                	jne    8021b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b2:	eb 05                	jmp    8021b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 25                	push   $0x25
  8021cd:	e8 2d fb ff ff       	call   801cff <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
  8021d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021d8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021dc:	75 07                	jne    8021e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e3:	eb 05                	jmp    8021ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 25                	push   $0x25
  8021fe:	e8 fc fa ff ff       	call   801cff <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
  802206:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802209:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80220d:	75 07                	jne    802216 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80220f:	b8 01 00 00 00       	mov    $0x1,%eax
  802214:	eb 05                	jmp    80221b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	ff 75 08             	pushl  0x8(%ebp)
  80222b:	6a 26                	push   $0x26
  80222d:	e8 cd fa ff ff       	call   801cff <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
	return ;
  802235:	90                   	nop
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80223c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	6a 00                	push   $0x0
  80224a:	53                   	push   %ebx
  80224b:	51                   	push   %ecx
  80224c:	52                   	push   %edx
  80224d:	50                   	push   %eax
  80224e:	6a 27                	push   $0x27
  802250:	e8 aa fa ff ff       	call   801cff <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802260:	8b 55 0c             	mov    0xc(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 28                	push   $0x28
  802270:	e8 8a fa ff ff       	call   801cff <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80227d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802280:	8b 55 0c             	mov    0xc(%ebp),%edx
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	51                   	push   %ecx
  802289:	ff 75 10             	pushl  0x10(%ebp)
  80228c:	52                   	push   %edx
  80228d:	50                   	push   %eax
  80228e:	6a 29                	push   $0x29
  802290:	e8 6a fa ff ff       	call   801cff <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	ff 75 10             	pushl  0x10(%ebp)
  8022a4:	ff 75 0c             	pushl  0xc(%ebp)
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	6a 12                	push   $0x12
  8022ac:	e8 4e fa ff ff       	call   801cff <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b4:	90                   	nop
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8022ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	52                   	push   %edx
  8022c7:	50                   	push   %eax
  8022c8:	6a 2a                	push   $0x2a
  8022ca:	e8 30 fa ff ff       	call   801cff <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
	return;
  8022d2:	90                   	nop
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	50                   	push   %eax
  8022e4:	6a 2b                	push   $0x2b
  8022e6:	e8 14 fa ff ff       	call   801cff <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	ff 75 0c             	pushl  0xc(%ebp)
  8022fc:	ff 75 08             	pushl  0x8(%ebp)
  8022ff:	6a 2c                	push   $0x2c
  802301:	e8 f9 f9 ff ff       	call   801cff <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
	return;
  802309:	90                   	nop
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	ff 75 0c             	pushl  0xc(%ebp)
  802318:	ff 75 08             	pushl  0x8(%ebp)
  80231b:	6a 2d                	push   $0x2d
  80231d:	e8 dd f9 ff ff       	call   801cff <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return;
  802325:	90                   	nop
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	83 e8 04             	sub    $0x4,%eax
  802334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802337:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	83 e8 04             	sub    $0x4,%eax
  80234d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802350:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	83 e0 01             	and    $0x1,%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	0f 94 c0             	sete   %al
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80236c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236f:	83 f8 02             	cmp    $0x2,%eax
  802372:	74 2b                	je     80239f <alloc_block+0x40>
  802374:	83 f8 02             	cmp    $0x2,%eax
  802377:	7f 07                	jg     802380 <alloc_block+0x21>
  802379:	83 f8 01             	cmp    $0x1,%eax
  80237c:	74 0e                	je     80238c <alloc_block+0x2d>
  80237e:	eb 58                	jmp    8023d8 <alloc_block+0x79>
  802380:	83 f8 03             	cmp    $0x3,%eax
  802383:	74 2d                	je     8023b2 <alloc_block+0x53>
  802385:	83 f8 04             	cmp    $0x4,%eax
  802388:	74 3b                	je     8023c5 <alloc_block+0x66>
  80238a:	eb 4c                	jmp    8023d8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80238c:	83 ec 0c             	sub    $0xc,%esp
  80238f:	ff 75 08             	pushl  0x8(%ebp)
  802392:	e8 11 03 00 00       	call   8026a8 <alloc_block_FF>
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80239d:	eb 4a                	jmp    8023e9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	e8 fa 19 00 00       	call   803da4 <alloc_block_NF>
  8023aa:	83 c4 10             	add    $0x10,%esp
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023b0:	eb 37                	jmp    8023e9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	e8 a7 07 00 00       	call   802b64 <alloc_block_BF>
  8023bd:	83 c4 10             	add    $0x10,%esp
  8023c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023c3:	eb 24                	jmp    8023e9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8023c5:	83 ec 0c             	sub    $0xc,%esp
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	e8 b7 19 00 00       	call   803d87 <alloc_block_WF>
  8023d0:	83 c4 10             	add    $0x10,%esp
  8023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023d6:	eb 11                	jmp    8023e9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	68 50 48 80 00       	push   $0x804850
  8023e0:	e8 a8 e6 ff ff       	call   800a8d <cprintf>
  8023e5:	83 c4 10             	add    $0x10,%esp
		break;
  8023e8:	90                   	nop
	}
	return va;
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	53                   	push   %ebx
  8023f2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8023f5:	83 ec 0c             	sub    $0xc,%esp
  8023f8:	68 70 48 80 00       	push   $0x804870
  8023fd:	e8 8b e6 ff ff       	call   800a8d <cprintf>
  802402:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	68 9b 48 80 00       	push   $0x80489b
  80240d:	e8 7b e6 ff ff       	call   800a8d <cprintf>
  802412:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241b:	eb 37                	jmp    802454 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80241d:	83 ec 0c             	sub    $0xc,%esp
  802420:	ff 75 f4             	pushl  -0xc(%ebp)
  802423:	e8 19 ff ff ff       	call   802341 <is_free_block>
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	0f be d8             	movsbl %al,%ebx
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	ff 75 f4             	pushl  -0xc(%ebp)
  802434:	e8 ef fe ff ff       	call   802328 <get_block_size>
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	53                   	push   %ebx
  802440:	50                   	push   %eax
  802441:	68 b3 48 80 00       	push   $0x8048b3
  802446:	e8 42 e6 ff ff       	call   800a8d <cprintf>
  80244b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80244e:	8b 45 10             	mov    0x10(%ebp),%eax
  802451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	74 07                	je     802461 <print_blocks_list+0x73>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	eb 05                	jmp    802466 <print_blocks_list+0x78>
  802461:	b8 00 00 00 00       	mov    $0x0,%eax
  802466:	89 45 10             	mov    %eax,0x10(%ebp)
  802469:	8b 45 10             	mov    0x10(%ebp),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	75 ad                	jne    80241d <print_blocks_list+0x2f>
  802470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802474:	75 a7                	jne    80241d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802476:	83 ec 0c             	sub    $0xc,%esp
  802479:	68 70 48 80 00       	push   $0x804870
  80247e:	e8 0a e6 ff ff       	call   800a8d <cprintf>
  802483:	83 c4 10             	add    $0x10,%esp

}
  802486:	90                   	nop
  802487:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802492:	8b 45 0c             	mov    0xc(%ebp),%eax
  802495:	83 e0 01             	and    $0x1,%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 03                	je     80249f <initialize_dynamic_allocator+0x13>
  80249c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80249f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024a3:	0f 84 c7 01 00 00    	je     802670 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8024a9:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8024b0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8024b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8024c0:	0f 87 ad 01 00 00    	ja     802673 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	0f 89 a5 01 00 00    	jns    802676 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8024d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	83 e8 04             	sub    $0x4,%eax
  8024dc:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8024e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8024e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f0:	e9 87 00 00 00       	jmp    80257c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8024f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f9:	75 14                	jne    80250f <initialize_dynamic_allocator+0x83>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 cb 48 80 00       	push   $0x8048cb
  802503:	6a 79                	push   $0x79
  802505:	68 e9 48 80 00       	push   $0x8048e9
  80250a:	e8 c1 e2 ff ff       	call   8007d0 <_panic>
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 10                	je     802528 <initialize_dynamic_allocator+0x9c>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802520:	8b 52 04             	mov    0x4(%edx),%edx
  802523:	89 50 04             	mov    %edx,0x4(%eax)
  802526:	eb 0b                	jmp    802533 <initialize_dynamic_allocator+0xa7>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	a3 30 50 80 00       	mov    %eax,0x805030
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 0f                	je     80254c <initialize_dynamic_allocator+0xc0>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	8b 12                	mov    (%edx),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	eb 0a                	jmp    802556 <initialize_dynamic_allocator+0xca>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802569:	a1 38 50 80 00       	mov    0x805038,%eax
  80256e:	48                   	dec    %eax
  80256f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802574:	a1 34 50 80 00       	mov    0x805034,%eax
  802579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802580:	74 07                	je     802589 <initialize_dynamic_allocator+0xfd>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	eb 05                	jmp    80258e <initialize_dynamic_allocator+0x102>
  802589:	b8 00 00 00 00       	mov    $0x0,%eax
  80258e:	a3 34 50 80 00       	mov    %eax,0x805034
  802593:	a1 34 50 80 00       	mov    0x805034,%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 85 55 ff ff ff    	jne    8024f5 <initialize_dynamic_allocator+0x69>
  8025a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a4:	0f 85 4b ff ff ff    	jne    8024f5 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8025b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8025be:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8025c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	83 c0 08             	add    $0x8,%eax
  8025d4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	83 c0 04             	add    $0x4,%eax
  8025dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e0:	83 ea 08             	sub    $0x8,%edx
  8025e3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8025e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	83 e8 08             	sub    $0x8,%eax
  8025f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f3:	83 ea 08             	sub    $0x8,%edx
  8025f6:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8025f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80260b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260f:	75 17                	jne    802628 <initialize_dynamic_allocator+0x19c>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 04 49 80 00       	push   $0x804904
  802619:	68 90 00 00 00       	push   $0x90
  80261e:	68 e9 48 80 00       	push   $0x8048e9
  802623:	e8 a8 e1 ff ff       	call   8007d0 <_panic>
  802628:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	89 10                	mov    %edx,(%eax)
  802633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 0d                	je     802649 <initialize_dynamic_allocator+0x1bd>
  80263c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802641:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802644:	89 50 04             	mov    %edx,0x4(%eax)
  802647:	eb 08                	jmp    802651 <initialize_dynamic_allocator+0x1c5>
  802649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264c:	a3 30 50 80 00       	mov    %eax,0x805030
  802651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802654:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802663:	a1 38 50 80 00       	mov    0x805038,%eax
  802668:	40                   	inc    %eax
  802669:	a3 38 50 80 00       	mov    %eax,0x805038
  80266e:	eb 07                	jmp    802677 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802670:	90                   	nop
  802671:	eb 04                	jmp    802677 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802673:	90                   	nop
  802674:	eb 01                	jmp    802677 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802676:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80267c:	8b 45 10             	mov    0x10(%ebp),%eax
  80267f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8d 50 fc             	lea    -0x4(%eax),%edx
  802688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	83 e8 04             	sub    $0x4,%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	83 e0 fe             	and    $0xfffffffe,%eax
  802698:	8d 50 f8             	lea    -0x8(%eax),%edx
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	01 c2                	add    %eax,%edx
  8026a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a3:	89 02                	mov    %eax,(%edx)
}
  8026a5:	90                   	nop
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    

008026a8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	83 e0 01             	and    $0x1,%eax
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	74 03                	je     8026bb <alloc_block_FF+0x13>
  8026b8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026bb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026bf:	77 07                	ja     8026c8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026c1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026c8:	a1 24 50 80 00       	mov    0x805024,%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	75 73                	jne    802744 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	83 c0 10             	add    $0x10,%eax
  8026d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026da:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	48                   	dec    %eax
  8026ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f5:	f7 75 ec             	divl   -0x14(%ebp)
  8026f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fb:	29 d0                	sub    %edx,%eax
  8026fd:	c1 e8 0c             	shr    $0xc,%eax
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	50                   	push   %eax
  802704:	e8 1e f1 ff ff       	call   801827 <sbrk>
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80270f:	83 ec 0c             	sub    $0xc,%esp
  802712:	6a 00                	push   $0x0
  802714:	e8 0e f1 ff ff       	call   801827 <sbrk>
  802719:	83 c4 10             	add    $0x10,%esp
  80271c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80271f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802722:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802725:	83 ec 08             	sub    $0x8,%esp
  802728:	50                   	push   %eax
  802729:	ff 75 e4             	pushl  -0x1c(%ebp)
  80272c:	e8 5b fd ff ff       	call   80248c <initialize_dynamic_allocator>
  802731:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	68 27 49 80 00       	push   $0x804927
  80273c:	e8 4c e3 ff ff       	call   800a8d <cprintf>
  802741:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802744:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802748:	75 0a                	jne    802754 <alloc_block_FF+0xac>
	        return NULL;
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
  80274f:	e9 0e 04 00 00       	jmp    802b62 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80275b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802763:	e9 f3 02 00 00       	jmp    802a5b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80276e:	83 ec 0c             	sub    $0xc,%esp
  802771:	ff 75 bc             	pushl  -0x44(%ebp)
  802774:	e8 af fb ff ff       	call   802328 <get_block_size>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	83 c0 08             	add    $0x8,%eax
  802785:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802788:	0f 87 c5 02 00 00    	ja     802a53 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	83 c0 18             	add    $0x18,%eax
  802794:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802797:	0f 87 19 02 00 00    	ja     8029b6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80279d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a3:	83 e8 08             	sub    $0x8,%eax
  8027a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	8d 50 08             	lea    0x8(%eax),%edx
  8027af:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027b2:	01 d0                	add    %edx,%eax
  8027b4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	83 c0 08             	add    $0x8,%eax
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	6a 01                	push   $0x1
  8027c2:	50                   	push   %eax
  8027c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8027c6:	e8 ae fe ff ff       	call   802679 <set_block_data>
  8027cb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	75 68                	jne    802840 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027d8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027dc:	75 17                	jne    8027f5 <alloc_block_FF+0x14d>
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	68 04 49 80 00       	push   $0x804904
  8027e6:	68 d7 00 00 00       	push   $0xd7
  8027eb:	68 e9 48 80 00       	push   $0x8048e9
  8027f0:	e8 db df ff ff       	call   8007d0 <_panic>
  8027f5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027fe:	89 10                	mov    %edx,(%eax)
  802800:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	74 0d                	je     802816 <alloc_block_FF+0x16e>
  802809:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80280e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802811:	89 50 04             	mov    %edx,0x4(%eax)
  802814:	eb 08                	jmp    80281e <alloc_block_FF+0x176>
  802816:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802819:	a3 30 50 80 00       	mov    %eax,0x805030
  80281e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802821:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802826:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 38 50 80 00       	mov    0x805038,%eax
  802835:	40                   	inc    %eax
  802836:	a3 38 50 80 00       	mov    %eax,0x805038
  80283b:	e9 dc 00 00 00       	jmp    80291c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	75 65                	jne    8028ae <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802849:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80284d:	75 17                	jne    802866 <alloc_block_FF+0x1be>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 38 49 80 00       	push   $0x804938
  802857:	68 db 00 00 00       	push   $0xdb
  80285c:	68 e9 48 80 00       	push   $0x8048e9
  802861:	e8 6a df ff ff       	call   8007d0 <_panic>
  802866:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80286c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80286f:	89 50 04             	mov    %edx,0x4(%eax)
  802872:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 0c                	je     802888 <alloc_block_FF+0x1e0>
  80287c:	a1 30 50 80 00       	mov    0x805030,%eax
  802881:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802884:	89 10                	mov    %edx,(%eax)
  802886:	eb 08                	jmp    802890 <alloc_block_FF+0x1e8>
  802888:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80288b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802890:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802893:	a3 30 50 80 00       	mov    %eax,0x805030
  802898:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a6:	40                   	inc    %eax
  8028a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ac:	eb 6e                	jmp    80291c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	74 06                	je     8028ba <alloc_block_FF+0x212>
  8028b4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028b8:	75 17                	jne    8028d1 <alloc_block_FF+0x229>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 5c 49 80 00       	push   $0x80495c
  8028c2:	68 df 00 00 00       	push   $0xdf
  8028c7:	68 e9 48 80 00       	push   $0x8048e9
  8028cc:	e8 ff de ff ff       	call   8007d0 <_panic>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 10                	mov    (%eax),%edx
  8028d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028d9:	89 10                	mov    %edx,(%eax)
  8028db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 0b                	je     8028ef <alloc_block_FF+0x247>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028ec:	89 50 04             	mov    %edx,0x4(%eax)
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fd:	89 50 04             	mov    %edx,0x4(%eax)
  802900:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	75 08                	jne    802911 <alloc_block_FF+0x269>
  802909:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290c:	a3 30 50 80 00       	mov    %eax,0x805030
  802911:	a1 38 50 80 00       	mov    0x805038,%eax
  802916:	40                   	inc    %eax
  802917:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80291c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802920:	75 17                	jne    802939 <alloc_block_FF+0x291>
  802922:	83 ec 04             	sub    $0x4,%esp
  802925:	68 cb 48 80 00       	push   $0x8048cb
  80292a:	68 e1 00 00 00       	push   $0xe1
  80292f:	68 e9 48 80 00       	push   $0x8048e9
  802934:	e8 97 de ff ff       	call   8007d0 <_panic>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	74 10                	je     802952 <alloc_block_FF+0x2aa>
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294a:	8b 52 04             	mov    0x4(%edx),%edx
  80294d:	89 50 04             	mov    %edx,0x4(%eax)
  802950:	eb 0b                	jmp    80295d <alloc_block_FF+0x2b5>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	a3 30 50 80 00       	mov    %eax,0x805030
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	74 0f                	je     802976 <alloc_block_FF+0x2ce>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802970:	8b 12                	mov    (%edx),%edx
  802972:	89 10                	mov    %edx,(%eax)
  802974:	eb 0a                	jmp    802980 <alloc_block_FF+0x2d8>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802993:	a1 38 50 80 00       	mov    0x805038,%eax
  802998:	48                   	dec    %eax
  802999:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	6a 00                	push   $0x0
  8029a3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8029a6:	ff 75 b0             	pushl  -0x50(%ebp)
  8029a9:	e8 cb fc ff ff       	call   802679 <set_block_data>
  8029ae:	83 c4 10             	add    $0x10,%esp
  8029b1:	e9 95 00 00 00       	jmp    802a4b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	6a 01                	push   $0x1
  8029bb:	ff 75 b8             	pushl  -0x48(%ebp)
  8029be:	ff 75 bc             	pushl  -0x44(%ebp)
  8029c1:	e8 b3 fc ff ff       	call   802679 <set_block_data>
  8029c6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	75 17                	jne    8029e6 <alloc_block_FF+0x33e>
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	68 cb 48 80 00       	push   $0x8048cb
  8029d7:	68 e8 00 00 00       	push   $0xe8
  8029dc:	68 e9 48 80 00       	push   $0x8048e9
  8029e1:	e8 ea dd ff ff       	call   8007d0 <_panic>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 10                	je     8029ff <alloc_block_FF+0x357>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f7:	8b 52 04             	mov    0x4(%edx),%edx
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	eb 0b                	jmp    802a0a <alloc_block_FF+0x362>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0f                	je     802a23 <alloc_block_FF+0x37b>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	8b 12                	mov    (%edx),%edx
  802a1f:	89 10                	mov    %edx,(%eax)
  802a21:	eb 0a                	jmp    802a2d <alloc_block_FF+0x385>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a40:	a1 38 50 80 00       	mov    0x805038,%eax
  802a45:	48                   	dec    %eax
  802a46:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802a4b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a4e:	e9 0f 01 00 00       	jmp    802b62 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a53:	a1 34 50 80 00       	mov    0x805034,%eax
  802a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	74 07                	je     802a68 <alloc_block_FF+0x3c0>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	eb 05                	jmp    802a6d <alloc_block_FF+0x3c5>
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6d:	a3 34 50 80 00       	mov    %eax,0x805034
  802a72:	a1 34 50 80 00       	mov    0x805034,%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	0f 85 e9 fc ff ff    	jne    802768 <alloc_block_FF+0xc0>
  802a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a83:	0f 85 df fc ff ff    	jne    802768 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	83 c0 08             	add    $0x8,%eax
  802a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a92:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802aa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  802aad:	f7 75 d8             	divl   -0x28(%ebp)
  802ab0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab3:	29 d0                	sub    %edx,%eax
  802ab5:	c1 e8 0c             	shr    $0xc,%eax
  802ab8:	83 ec 0c             	sub    $0xc,%esp
  802abb:	50                   	push   %eax
  802abc:	e8 66 ed ff ff       	call   801827 <sbrk>
  802ac1:	83 c4 10             	add    $0x10,%esp
  802ac4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ac7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802acb:	75 0a                	jne    802ad7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802acd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad2:	e9 8b 00 00 00       	jmp    802b62 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ad7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ade:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ae1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae4:	01 d0                	add    %edx,%eax
  802ae6:	48                   	dec    %eax
  802ae7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802aea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802aed:	ba 00 00 00 00       	mov    $0x0,%edx
  802af2:	f7 75 cc             	divl   -0x34(%ebp)
  802af5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802af8:	29 d0                	sub    %edx,%eax
  802afa:	8d 50 fc             	lea    -0x4(%eax),%edx
  802afd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b00:	01 d0                	add    %edx,%eax
  802b02:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b07:	a1 40 50 80 00       	mov    0x805040,%eax
  802b0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b12:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	48                   	dec    %eax
  802b22:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b28:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2d:	f7 75 c4             	divl   -0x3c(%ebp)
  802b30:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b33:	29 d0                	sub    %edx,%eax
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	6a 01                	push   $0x1
  802b3a:	50                   	push   %eax
  802b3b:	ff 75 d0             	pushl  -0x30(%ebp)
  802b3e:	e8 36 fb ff ff       	call   802679 <set_block_data>
  802b43:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b46:	83 ec 0c             	sub    $0xc,%esp
  802b49:	ff 75 d0             	pushl  -0x30(%ebp)
  802b4c:	e8 1b 0a 00 00       	call   80356c <free_block>
  802b51:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	ff 75 08             	pushl  0x8(%ebp)
  802b5a:	e8 49 fb ff ff       	call   8026a8 <alloc_block_FF>
  802b5f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	83 e0 01             	and    $0x1,%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 03                	je     802b77 <alloc_block_BF+0x13>
  802b74:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b77:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b7b:	77 07                	ja     802b84 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b7d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b84:	a1 24 50 80 00       	mov    0x805024,%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	75 73                	jne    802c00 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	83 c0 10             	add    $0x10,%eax
  802b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b96:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802b9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	48                   	dec    %eax
  802ba6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bac:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb1:	f7 75 e0             	divl   -0x20(%ebp)
  802bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bb7:	29 d0                	sub    %edx,%eax
  802bb9:	c1 e8 0c             	shr    $0xc,%eax
  802bbc:	83 ec 0c             	sub    $0xc,%esp
  802bbf:	50                   	push   %eax
  802bc0:	e8 62 ec ff ff       	call   801827 <sbrk>
  802bc5:	83 c4 10             	add    $0x10,%esp
  802bc8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bcb:	83 ec 0c             	sub    $0xc,%esp
  802bce:	6a 00                	push   $0x0
  802bd0:	e8 52 ec ff ff       	call   801827 <sbrk>
  802bd5:	83 c4 10             	add    $0x10,%esp
  802bd8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bde:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802be1:	83 ec 08             	sub    $0x8,%esp
  802be4:	50                   	push   %eax
  802be5:	ff 75 d8             	pushl  -0x28(%ebp)
  802be8:	e8 9f f8 ff ff       	call   80248c <initialize_dynamic_allocator>
  802bed:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802bf0:	83 ec 0c             	sub    $0xc,%esp
  802bf3:	68 27 49 80 00       	push   $0x804927
  802bf8:	e8 90 de ff ff       	call   800a8d <cprintf>
  802bfd:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c0e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c15:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c1c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c24:	e9 1d 01 00 00       	jmp    802d46 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c2f:	83 ec 0c             	sub    $0xc,%esp
  802c32:	ff 75 a8             	pushl  -0x58(%ebp)
  802c35:	e8 ee f6 ff ff       	call   802328 <get_block_size>
  802c3a:	83 c4 10             	add    $0x10,%esp
  802c3d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	83 c0 08             	add    $0x8,%eax
  802c46:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c49:	0f 87 ef 00 00 00    	ja     802d3e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	83 c0 18             	add    $0x18,%eax
  802c55:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c58:	77 1d                	ja     802c77 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c60:	0f 86 d8 00 00 00    	jbe    802d3e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802c66:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c6c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c72:	e9 c7 00 00 00       	jmp    802d3e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	83 c0 08             	add    $0x8,%eax
  802c7d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c80:	0f 85 9d 00 00 00    	jne    802d23 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	6a 01                	push   $0x1
  802c8b:	ff 75 a4             	pushl  -0x5c(%ebp)
  802c8e:	ff 75 a8             	pushl  -0x58(%ebp)
  802c91:	e8 e3 f9 ff ff       	call   802679 <set_block_data>
  802c96:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_BF+0x152>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 cb 48 80 00       	push   $0x8048cb
  802ca7:	68 2c 01 00 00       	push   $0x12c
  802cac:	68 e9 48 80 00       	push   $0x8048e9
  802cb1:	e8 1a db ff ff       	call   8007d0 <_panic>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 10                	je     802ccf <alloc_block_BF+0x16b>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc7:	8b 52 04             	mov    0x4(%edx),%edx
  802cca:	89 50 04             	mov    %edx,0x4(%eax)
  802ccd:	eb 0b                	jmp    802cda <alloc_block_BF+0x176>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	a3 30 50 80 00       	mov    %eax,0x805030
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block_BF+0x18f>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 0a                	jmp    802cfd <alloc_block_BF+0x199>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 38 50 80 00       	mov    0x805038,%eax
  802d15:	48                   	dec    %eax
  802d16:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802d1b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d1e:	e9 24 04 00 00       	jmp    803147 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d26:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d29:	76 13                	jbe    802d3e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d2b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d32:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802d38:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802d3e:	a1 34 50 80 00       	mov    0x805034,%eax
  802d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	74 07                	je     802d53 <alloc_block_BF+0x1ef>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	eb 05                	jmp    802d58 <alloc_block_BF+0x1f4>
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	a3 34 50 80 00       	mov    %eax,0x805034
  802d5d:	a1 34 50 80 00       	mov    0x805034,%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	0f 85 bf fe ff ff    	jne    802c29 <alloc_block_BF+0xc5>
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	0f 85 b5 fe ff ff    	jne    802c29 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d78:	0f 84 26 02 00 00    	je     802fa4 <alloc_block_BF+0x440>
  802d7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d82:	0f 85 1c 02 00 00    	jne    802fa4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d8e:	83 e8 08             	sub    $0x8,%eax
  802d91:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8d 50 08             	lea    0x8(%eax),%edx
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	01 d0                	add    %edx,%eax
  802d9f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	83 c0 08             	add    $0x8,%eax
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	6a 01                	push   $0x1
  802dad:	50                   	push   %eax
  802dae:	ff 75 f0             	pushl  -0x10(%ebp)
  802db1:	e8 c3 f8 ff ff       	call   802679 <set_block_data>
  802db6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	75 68                	jne    802e2b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802dc3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dc7:	75 17                	jne    802de0 <alloc_block_BF+0x27c>
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	68 04 49 80 00       	push   $0x804904
  802dd1:	68 45 01 00 00       	push   $0x145
  802dd6:	68 e9 48 80 00       	push   $0x8048e9
  802ddb:	e8 f0 d9 ff ff       	call   8007d0 <_panic>
  802de0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802de6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 0d                	je     802e01 <alloc_block_BF+0x29d>
  802df4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802df9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802dfc:	89 50 04             	mov    %edx,0x4(%eax)
  802dff:	eb 08                	jmp    802e09 <alloc_block_BF+0x2a5>
  802e01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e04:	a3 30 50 80 00       	mov    %eax,0x805030
  802e09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e20:	40                   	inc    %eax
  802e21:	a3 38 50 80 00       	mov    %eax,0x805038
  802e26:	e9 dc 00 00 00       	jmp    802f07 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	75 65                	jne    802e99 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e34:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e38:	75 17                	jne    802e51 <alloc_block_BF+0x2ed>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 38 49 80 00       	push   $0x804938
  802e42:	68 4a 01 00 00       	push   $0x14a
  802e47:	68 e9 48 80 00       	push   $0x8048e9
  802e4c:	e8 7f d9 ff ff       	call   8007d0 <_panic>
  802e51:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	85 c0                	test   %eax,%eax
  802e65:	74 0c                	je     802e73 <alloc_block_BF+0x30f>
  802e67:	a1 30 50 80 00       	mov    0x805030,%eax
  802e6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e6f:	89 10                	mov    %edx,(%eax)
  802e71:	eb 08                	jmp    802e7b <alloc_block_BF+0x317>
  802e73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7e:	a3 30 50 80 00       	mov    %eax,0x805030
  802e83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e91:	40                   	inc    %eax
  802e92:	a3 38 50 80 00       	mov    %eax,0x805038
  802e97:	eb 6e                	jmp    802f07 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802e99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e9d:	74 06                	je     802ea5 <alloc_block_BF+0x341>
  802e9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ea3:	75 17                	jne    802ebc <alloc_block_BF+0x358>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 5c 49 80 00       	push   $0x80495c
  802ead:	68 4f 01 00 00       	push   $0x14f
  802eb2:	68 e9 48 80 00       	push   $0x8048e9
  802eb7:	e8 14 d9 ff ff       	call   8007d0 <_panic>
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 10                	mov    (%eax),%edx
  802ec1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec4:	89 10                	mov    %edx,(%eax)
  802ec6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	74 0b                	je     802eda <alloc_block_BF+0x376>
  802ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ed7:	89 50 04             	mov    %edx,0x4(%eax)
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee8:	89 50 04             	mov    %edx,0x4(%eax)
  802eeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	75 08                	jne    802efc <alloc_block_BF+0x398>
  802ef4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef7:	a3 30 50 80 00       	mov    %eax,0x805030
  802efc:	a1 38 50 80 00       	mov    0x805038,%eax
  802f01:	40                   	inc    %eax
  802f02:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0b:	75 17                	jne    802f24 <alloc_block_BF+0x3c0>
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	68 cb 48 80 00       	push   $0x8048cb
  802f15:	68 51 01 00 00       	push   $0x151
  802f1a:	68 e9 48 80 00       	push   $0x8048e9
  802f1f:	e8 ac d8 ff ff       	call   8007d0 <_panic>
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 10                	je     802f3d <alloc_block_BF+0x3d9>
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f35:	8b 52 04             	mov    0x4(%edx),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 0b                	jmp    802f48 <alloc_block_BF+0x3e4>
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	a3 30 50 80 00       	mov    %eax,0x805030
  802f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4b:	8b 40 04             	mov    0x4(%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 0f                	je     802f61 <alloc_block_BF+0x3fd>
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5b:	8b 12                	mov    (%edx),%edx
  802f5d:	89 10                	mov    %edx,(%eax)
  802f5f:	eb 0a                	jmp    802f6b <alloc_block_BF+0x407>
  802f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f83:	48                   	dec    %eax
  802f84:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	6a 00                	push   $0x0
  802f8e:	ff 75 d0             	pushl  -0x30(%ebp)
  802f91:	ff 75 cc             	pushl  -0x34(%ebp)
  802f94:	e8 e0 f6 ff ff       	call   802679 <set_block_data>
  802f99:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	e9 a3 01 00 00       	jmp    803147 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802fa4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802fa8:	0f 85 9d 00 00 00    	jne    80304b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	6a 01                	push   $0x1
  802fb3:	ff 75 ec             	pushl  -0x14(%ebp)
  802fb6:	ff 75 f0             	pushl  -0x10(%ebp)
  802fb9:	e8 bb f6 ff ff       	call   802679 <set_block_data>
  802fbe:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802fc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc5:	75 17                	jne    802fde <alloc_block_BF+0x47a>
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	68 cb 48 80 00       	push   $0x8048cb
  802fcf:	68 58 01 00 00       	push   $0x158
  802fd4:	68 e9 48 80 00       	push   $0x8048e9
  802fd9:	e8 f2 d7 ff ff       	call   8007d0 <_panic>
  802fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	85 c0                	test   %eax,%eax
  802fe5:	74 10                	je     802ff7 <alloc_block_BF+0x493>
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fef:	8b 52 04             	mov    0x4(%edx),%edx
  802ff2:	89 50 04             	mov    %edx,0x4(%eax)
  802ff5:	eb 0b                	jmp    803002 <alloc_block_BF+0x49e>
  802ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	a3 30 50 80 00       	mov    %eax,0x805030
  803002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803005:	8b 40 04             	mov    0x4(%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 0f                	je     80301b <alloc_block_BF+0x4b7>
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803015:	8b 12                	mov    (%edx),%edx
  803017:	89 10                	mov    %edx,(%eax)
  803019:	eb 0a                	jmp    803025 <alloc_block_BF+0x4c1>
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803031:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803038:	a1 38 50 80 00       	mov    0x805038,%eax
  80303d:	48                   	dec    %eax
  80303e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803046:	e9 fc 00 00 00       	jmp    803147 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	83 c0 08             	add    $0x8,%eax
  803051:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803054:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80305b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80305e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803061:	01 d0                	add    %edx,%eax
  803063:	48                   	dec    %eax
  803064:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803067:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80306a:	ba 00 00 00 00       	mov    $0x0,%edx
  80306f:	f7 75 c4             	divl   -0x3c(%ebp)
  803072:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803075:	29 d0                	sub    %edx,%eax
  803077:	c1 e8 0c             	shr    $0xc,%eax
  80307a:	83 ec 0c             	sub    $0xc,%esp
  80307d:	50                   	push   %eax
  80307e:	e8 a4 e7 ff ff       	call   801827 <sbrk>
  803083:	83 c4 10             	add    $0x10,%esp
  803086:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803089:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80308d:	75 0a                	jne    803099 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80308f:	b8 00 00 00 00       	mov    $0x0,%eax
  803094:	e9 ae 00 00 00       	jmp    803147 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803099:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8030a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030a6:	01 d0                	add    %edx,%eax
  8030a8:	48                   	dec    %eax
  8030a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8030ac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030af:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b4:	f7 75 b8             	divl   -0x48(%ebp)
  8030b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030ba:	29 d0                	sub    %edx,%eax
  8030bc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8030bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8030c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8030ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	68 90 49 80 00       	push   $0x804990
  8030dc:	e8 ac d9 ff ff       	call   800a8d <cprintf>
  8030e1:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8030e4:	83 ec 08             	sub    $0x8,%esp
  8030e7:	ff 75 bc             	pushl  -0x44(%ebp)
  8030ea:	68 95 49 80 00       	push   $0x804995
  8030ef:	e8 99 d9 ff ff       	call   800a8d <cprintf>
  8030f4:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8030f7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8030fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803101:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803104:	01 d0                	add    %edx,%eax
  803106:	48                   	dec    %eax
  803107:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80310a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80310d:	ba 00 00 00 00       	mov    $0x0,%edx
  803112:	f7 75 b0             	divl   -0x50(%ebp)
  803115:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803118:	29 d0                	sub    %edx,%eax
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	6a 01                	push   $0x1
  80311f:	50                   	push   %eax
  803120:	ff 75 bc             	pushl  -0x44(%ebp)
  803123:	e8 51 f5 ff ff       	call   802679 <set_block_data>
  803128:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80312b:	83 ec 0c             	sub    $0xc,%esp
  80312e:	ff 75 bc             	pushl  -0x44(%ebp)
  803131:	e8 36 04 00 00       	call   80356c <free_block>
  803136:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803139:	83 ec 0c             	sub    $0xc,%esp
  80313c:	ff 75 08             	pushl  0x8(%ebp)
  80313f:	e8 20 fa ff ff       	call   802b64 <alloc_block_BF>
  803144:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    

00803149 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
  80314c:	53                   	push   %ebx
  80314d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803150:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803157:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80315e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803162:	74 1e                	je     803182 <merging+0x39>
  803164:	ff 75 08             	pushl  0x8(%ebp)
  803167:	e8 bc f1 ff ff       	call   802328 <get_block_size>
  80316c:	83 c4 04             	add    $0x4,%esp
  80316f:	89 c2                	mov    %eax,%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	01 d0                	add    %edx,%eax
  803176:	3b 45 10             	cmp    0x10(%ebp),%eax
  803179:	75 07                	jne    803182 <merging+0x39>
		prev_is_free = 1;
  80317b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803182:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803186:	74 1e                	je     8031a6 <merging+0x5d>
  803188:	ff 75 10             	pushl  0x10(%ebp)
  80318b:	e8 98 f1 ff ff       	call   802328 <get_block_size>
  803190:	83 c4 04             	add    $0x4,%esp
  803193:	89 c2                	mov    %eax,%edx
  803195:	8b 45 10             	mov    0x10(%ebp),%eax
  803198:	01 d0                	add    %edx,%eax
  80319a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80319d:	75 07                	jne    8031a6 <merging+0x5d>
		next_is_free = 1;
  80319f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8031a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031aa:	0f 84 cc 00 00 00    	je     80327c <merging+0x133>
  8031b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b4:	0f 84 c2 00 00 00    	je     80327c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8031ba:	ff 75 08             	pushl  0x8(%ebp)
  8031bd:	e8 66 f1 ff ff       	call   802328 <get_block_size>
  8031c2:	83 c4 04             	add    $0x4,%esp
  8031c5:	89 c3                	mov    %eax,%ebx
  8031c7:	ff 75 10             	pushl  0x10(%ebp)
  8031ca:	e8 59 f1 ff ff       	call   802328 <get_block_size>
  8031cf:	83 c4 04             	add    $0x4,%esp
  8031d2:	01 c3                	add    %eax,%ebx
  8031d4:	ff 75 0c             	pushl  0xc(%ebp)
  8031d7:	e8 4c f1 ff ff       	call   802328 <get_block_size>
  8031dc:	83 c4 04             	add    $0x4,%esp
  8031df:	01 d8                	add    %ebx,%eax
  8031e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8031e4:	6a 00                	push   $0x0
  8031e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8031e9:	ff 75 08             	pushl  0x8(%ebp)
  8031ec:	e8 88 f4 ff ff       	call   802679 <set_block_data>
  8031f1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8031f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031f8:	75 17                	jne    803211 <merging+0xc8>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 cb 48 80 00       	push   $0x8048cb
  803202:	68 7d 01 00 00       	push   $0x17d
  803207:	68 e9 48 80 00       	push   $0x8048e9
  80320c:	e8 bf d5 ff ff       	call   8007d0 <_panic>
  803211:	8b 45 0c             	mov    0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 10                	je     80322a <merging+0xe1>
  80321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803222:	8b 52 04             	mov    0x4(%edx),%edx
  803225:	89 50 04             	mov    %edx,0x4(%eax)
  803228:	eb 0b                	jmp    803235 <merging+0xec>
  80322a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322d:	8b 40 04             	mov    0x4(%eax),%eax
  803230:	a3 30 50 80 00       	mov    %eax,0x805030
  803235:	8b 45 0c             	mov    0xc(%ebp),%eax
  803238:	8b 40 04             	mov    0x4(%eax),%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 0f                	je     80324e <merging+0x105>
  80323f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803242:	8b 40 04             	mov    0x4(%eax),%eax
  803245:	8b 55 0c             	mov    0xc(%ebp),%edx
  803248:	8b 12                	mov    (%edx),%edx
  80324a:	89 10                	mov    %edx,(%eax)
  80324c:	eb 0a                	jmp    803258 <merging+0x10f>
  80324e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803261:	8b 45 0c             	mov    0xc(%ebp),%eax
  803264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326b:	a1 38 50 80 00       	mov    0x805038,%eax
  803270:	48                   	dec    %eax
  803271:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803276:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803277:	e9 ea 02 00 00       	jmp    803566 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80327c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803280:	74 3b                	je     8032bd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803282:	83 ec 0c             	sub    $0xc,%esp
  803285:	ff 75 08             	pushl  0x8(%ebp)
  803288:	e8 9b f0 ff ff       	call   802328 <get_block_size>
  80328d:	83 c4 10             	add    $0x10,%esp
  803290:	89 c3                	mov    %eax,%ebx
  803292:	83 ec 0c             	sub    $0xc,%esp
  803295:	ff 75 10             	pushl  0x10(%ebp)
  803298:	e8 8b f0 ff ff       	call   802328 <get_block_size>
  80329d:	83 c4 10             	add    $0x10,%esp
  8032a0:	01 d8                	add    %ebx,%eax
  8032a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032a5:	83 ec 04             	sub    $0x4,%esp
  8032a8:	6a 00                	push   $0x0
  8032aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8032ad:	ff 75 08             	pushl  0x8(%ebp)
  8032b0:	e8 c4 f3 ff ff       	call   802679 <set_block_data>
  8032b5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032b8:	e9 a9 02 00 00       	jmp    803566 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8032bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c1:	0f 84 2d 01 00 00    	je     8033f4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8032c7:	83 ec 0c             	sub    $0xc,%esp
  8032ca:	ff 75 10             	pushl  0x10(%ebp)
  8032cd:	e8 56 f0 ff ff       	call   802328 <get_block_size>
  8032d2:	83 c4 10             	add    $0x10,%esp
  8032d5:	89 c3                	mov    %eax,%ebx
  8032d7:	83 ec 0c             	sub    $0xc,%esp
  8032da:	ff 75 0c             	pushl  0xc(%ebp)
  8032dd:	e8 46 f0 ff ff       	call   802328 <get_block_size>
  8032e2:	83 c4 10             	add    $0x10,%esp
  8032e5:	01 d8                	add    %ebx,%eax
  8032e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	6a 00                	push   $0x0
  8032ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032f2:	ff 75 10             	pushl  0x10(%ebp)
  8032f5:	e8 7f f3 ff ff       	call   802679 <set_block_data>
  8032fa:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8032fd:	8b 45 10             	mov    0x10(%ebp),%eax
  803300:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803303:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803307:	74 06                	je     80330f <merging+0x1c6>
  803309:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80330d:	75 17                	jne    803326 <merging+0x1dd>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 a4 49 80 00       	push   $0x8049a4
  803317:	68 8d 01 00 00       	push   $0x18d
  80331c:	68 e9 48 80 00       	push   $0x8048e9
  803321:	e8 aa d4 ff ff       	call   8007d0 <_panic>
  803326:	8b 45 0c             	mov    0xc(%ebp),%eax
  803329:	8b 50 04             	mov    0x4(%eax),%edx
  80332c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803335:	8b 55 0c             	mov    0xc(%ebp),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 0d                	je     803351 <merging+0x208>
  803344:	8b 45 0c             	mov    0xc(%ebp),%eax
  803347:	8b 40 04             	mov    0x4(%eax),%eax
  80334a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	eb 08                	jmp    803359 <merging+0x210>
  803351:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803354:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	a1 38 50 80 00       	mov    0x805038,%eax
  803367:	40                   	inc    %eax
  803368:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80336d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803371:	75 17                	jne    80338a <merging+0x241>
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	68 cb 48 80 00       	push   $0x8048cb
  80337b:	68 8e 01 00 00       	push   $0x18e
  803380:	68 e9 48 80 00       	push   $0x8048e9
  803385:	e8 46 d4 ff ff       	call   8007d0 <_panic>
  80338a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	74 10                	je     8033a3 <merging+0x25a>
  803393:	8b 45 0c             	mov    0xc(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80339b:	8b 52 04             	mov    0x4(%edx),%edx
  80339e:	89 50 04             	mov    %edx,0x4(%eax)
  8033a1:	eb 0b                	jmp    8033ae <merging+0x265>
  8033a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a6:	8b 40 04             	mov    0x4(%eax),%eax
  8033a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b1:	8b 40 04             	mov    0x4(%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 0f                	je     8033c7 <merging+0x27e>
  8033b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c1:	8b 12                	mov    (%edx),%edx
  8033c3:	89 10                	mov    %edx,(%eax)
  8033c5:	eb 0a                	jmp    8033d1 <merging+0x288>
  8033c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e9:	48                   	dec    %eax
  8033ea:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033ef:	e9 72 01 00 00       	jmp    803566 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8033f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8033f7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8033fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fe:	74 79                	je     803479 <merging+0x330>
  803400:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803404:	74 73                	je     803479 <merging+0x330>
  803406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340a:	74 06                	je     803412 <merging+0x2c9>
  80340c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803410:	75 17                	jne    803429 <merging+0x2e0>
  803412:	83 ec 04             	sub    $0x4,%esp
  803415:	68 5c 49 80 00       	push   $0x80495c
  80341a:	68 94 01 00 00       	push   $0x194
  80341f:	68 e9 48 80 00       	push   $0x8048e9
  803424:	e8 a7 d3 ff ff       	call   8007d0 <_panic>
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 10                	mov    (%eax),%edx
  80342e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803431:	89 10                	mov    %edx,(%eax)
  803433:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	85 c0                	test   %eax,%eax
  80343a:	74 0b                	je     803447 <merging+0x2fe>
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 00                	mov    (%eax),%eax
  803441:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803444:	89 50 04             	mov    %edx,0x4(%eax)
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80344d:	89 10                	mov    %edx,(%eax)
  80344f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803452:	8b 55 08             	mov    0x8(%ebp),%edx
  803455:	89 50 04             	mov    %edx,0x4(%eax)
  803458:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	75 08                	jne    803469 <merging+0x320>
  803461:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803464:	a3 30 50 80 00       	mov    %eax,0x805030
  803469:	a1 38 50 80 00       	mov    0x805038,%eax
  80346e:	40                   	inc    %eax
  80346f:	a3 38 50 80 00       	mov    %eax,0x805038
  803474:	e9 ce 00 00 00       	jmp    803547 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347d:	74 65                	je     8034e4 <merging+0x39b>
  80347f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803483:	75 17                	jne    80349c <merging+0x353>
  803485:	83 ec 04             	sub    $0x4,%esp
  803488:	68 38 49 80 00       	push   $0x804938
  80348d:	68 95 01 00 00       	push   $0x195
  803492:	68 e9 48 80 00       	push   $0x8048e9
  803497:	e8 34 d3 ff ff       	call   8007d0 <_panic>
  80349c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a5:	89 50 04             	mov    %edx,0x4(%eax)
  8034a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0c                	je     8034be <merging+0x375>
  8034b2:	a1 30 50 80 00       	mov    0x805030,%eax
  8034b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	eb 08                	jmp    8034c6 <merging+0x37d>
  8034be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8034dc:	40                   	inc    %eax
  8034dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e2:	eb 63                	jmp    803547 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8034e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034e8:	75 17                	jne    803501 <merging+0x3b8>
  8034ea:	83 ec 04             	sub    $0x4,%esp
  8034ed:	68 04 49 80 00       	push   $0x804904
  8034f2:	68 98 01 00 00       	push   $0x198
  8034f7:	68 e9 48 80 00       	push   $0x8048e9
  8034fc:	e8 cf d2 ff ff       	call   8007d0 <_panic>
  803501:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803507:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350a:	89 10                	mov    %edx,(%eax)
  80350c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	74 0d                	je     803522 <merging+0x3d9>
  803515:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
  803520:	eb 08                	jmp    80352a <merging+0x3e1>
  803522:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803525:	a3 30 50 80 00       	mov    %eax,0x805030
  80352a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803532:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353c:	a1 38 50 80 00       	mov    0x805038,%eax
  803541:	40                   	inc    %eax
  803542:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803547:	83 ec 0c             	sub    $0xc,%esp
  80354a:	ff 75 10             	pushl  0x10(%ebp)
  80354d:	e8 d6 ed ff ff       	call   802328 <get_block_size>
  803552:	83 c4 10             	add    $0x10,%esp
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	6a 00                	push   $0x0
  80355a:	50                   	push   %eax
  80355b:	ff 75 10             	pushl  0x10(%ebp)
  80355e:	e8 16 f1 ff ff       	call   802679 <set_block_data>
  803563:	83 c4 10             	add    $0x10,%esp
	}
}
  803566:	90                   	nop
  803567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
  80356f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803572:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803577:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80357a:	a1 30 50 80 00       	mov    0x805030,%eax
  80357f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803582:	73 1b                	jae    80359f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803584:	a1 30 50 80 00       	mov    0x805030,%eax
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	ff 75 08             	pushl  0x8(%ebp)
  80358f:	6a 00                	push   $0x0
  803591:	50                   	push   %eax
  803592:	e8 b2 fb ff ff       	call   803149 <merging>
  803597:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80359a:	e9 8b 00 00 00       	jmp    80362a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80359f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035a7:	76 18                	jbe    8035c1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8035a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	ff 75 08             	pushl  0x8(%ebp)
  8035b4:	50                   	push   %eax
  8035b5:	6a 00                	push   $0x0
  8035b7:	e8 8d fb ff ff       	call   803149 <merging>
  8035bc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035bf:	eb 69                	jmp    80362a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c9:	eb 39                	jmp    803604 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035d1:	73 29                	jae    8035fc <free_block+0x90>
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035db:	76 1f                	jbe    8035fc <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e0:	8b 00                	mov    (%eax),%eax
  8035e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8035e5:	83 ec 04             	sub    $0x4,%esp
  8035e8:	ff 75 08             	pushl  0x8(%ebp)
  8035eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8035ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8035f1:	e8 53 fb ff ff       	call   803149 <merging>
  8035f6:	83 c4 10             	add    $0x10,%esp
			break;
  8035f9:	90                   	nop
		}
	}
}
  8035fa:	eb 2e                	jmp    80362a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8035fc:	a1 34 50 80 00       	mov    0x805034,%eax
  803601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803608:	74 07                	je     803611 <free_block+0xa5>
  80360a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	eb 05                	jmp    803616 <free_block+0xaa>
  803611:	b8 00 00 00 00       	mov    $0x0,%eax
  803616:	a3 34 50 80 00       	mov    %eax,0x805034
  80361b:	a1 34 50 80 00       	mov    0x805034,%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	75 a7                	jne    8035cb <free_block+0x5f>
  803624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803628:	75 a1                	jne    8035cb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80362a:	90                   	nop
  80362b:	c9                   	leave  
  80362c:	c3                   	ret    

0080362d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80362d:	55                   	push   %ebp
  80362e:	89 e5                	mov    %esp,%ebp
  803630:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803633:	ff 75 08             	pushl  0x8(%ebp)
  803636:	e8 ed ec ff ff       	call   802328 <get_block_size>
  80363b:	83 c4 04             	add    $0x4,%esp
  80363e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803641:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803648:	eb 17                	jmp    803661 <copy_data+0x34>
  80364a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80364d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803650:	01 c2                	add    %eax,%edx
  803652:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	01 c8                	add    %ecx,%eax
  80365a:	8a 00                	mov    (%eax),%al
  80365c:	88 02                	mov    %al,(%edx)
  80365e:	ff 45 fc             	incl   -0x4(%ebp)
  803661:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803667:	72 e1                	jb     80364a <copy_data+0x1d>
}
  803669:	90                   	nop
  80366a:	c9                   	leave  
  80366b:	c3                   	ret    

0080366c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80366c:	55                   	push   %ebp
  80366d:	89 e5                	mov    %esp,%ebp
  80366f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803672:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803676:	75 23                	jne    80369b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803678:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80367c:	74 13                	je     803691 <realloc_block_FF+0x25>
  80367e:	83 ec 0c             	sub    $0xc,%esp
  803681:	ff 75 0c             	pushl  0xc(%ebp)
  803684:	e8 1f f0 ff ff       	call   8026a8 <alloc_block_FF>
  803689:	83 c4 10             	add    $0x10,%esp
  80368c:	e9 f4 06 00 00       	jmp    803d85 <realloc_block_FF+0x719>
		return NULL;
  803691:	b8 00 00 00 00       	mov    $0x0,%eax
  803696:	e9 ea 06 00 00       	jmp    803d85 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80369b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80369f:	75 18                	jne    8036b9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8036a1:	83 ec 0c             	sub    $0xc,%esp
  8036a4:	ff 75 08             	pushl  0x8(%ebp)
  8036a7:	e8 c0 fe ff ff       	call   80356c <free_block>
  8036ac:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8036af:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b4:	e9 cc 06 00 00       	jmp    803d85 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8036b9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8036bd:	77 07                	ja     8036c6 <realloc_block_FF+0x5a>
  8036bf:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8036c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c9:	83 e0 01             	and    $0x1,%eax
  8036cc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8036cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d2:	83 c0 08             	add    $0x8,%eax
  8036d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8036d8:	83 ec 0c             	sub    $0xc,%esp
  8036db:	ff 75 08             	pushl  0x8(%ebp)
  8036de:	e8 45 ec ff ff       	call   802328 <get_block_size>
  8036e3:	83 c4 10             	add    $0x10,%esp
  8036e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ec:	83 e8 08             	sub    $0x8,%eax
  8036ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	83 e8 04             	sub    $0x4,%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	83 e0 fe             	and    $0xfffffffe,%eax
  8036fd:	89 c2                	mov    %eax,%edx
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	01 d0                	add    %edx,%eax
  803704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803707:	83 ec 0c             	sub    $0xc,%esp
  80370a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80370d:	e8 16 ec ff ff       	call   802328 <get_block_size>
  803712:	83 c4 10             	add    $0x10,%esp
  803715:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803718:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371b:	83 e8 08             	sub    $0x8,%eax
  80371e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803721:	8b 45 0c             	mov    0xc(%ebp),%eax
  803724:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803727:	75 08                	jne    803731 <realloc_block_FF+0xc5>
	{
		 return va;
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	e9 54 06 00 00       	jmp    803d85 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803731:	8b 45 0c             	mov    0xc(%ebp),%eax
  803734:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803737:	0f 83 e5 03 00 00    	jae    803b22 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80373d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803740:	2b 45 0c             	sub    0xc(%ebp),%eax
  803743:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803746:	83 ec 0c             	sub    $0xc,%esp
  803749:	ff 75 e4             	pushl  -0x1c(%ebp)
  80374c:	e8 f0 eb ff ff       	call   802341 <is_free_block>
  803751:	83 c4 10             	add    $0x10,%esp
  803754:	84 c0                	test   %al,%al
  803756:	0f 84 3b 01 00 00    	je     803897 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80375c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80375f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803762:	01 d0                	add    %edx,%eax
  803764:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803767:	83 ec 04             	sub    $0x4,%esp
  80376a:	6a 01                	push   $0x1
  80376c:	ff 75 f0             	pushl  -0x10(%ebp)
  80376f:	ff 75 08             	pushl  0x8(%ebp)
  803772:	e8 02 ef ff ff       	call   802679 <set_block_data>
  803777:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	83 e8 04             	sub    $0x4,%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	83 e0 fe             	and    $0xfffffffe,%eax
  803785:	89 c2                	mov    %eax,%edx
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
  80378a:	01 d0                	add    %edx,%eax
  80378c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	6a 00                	push   $0x0
  803794:	ff 75 cc             	pushl  -0x34(%ebp)
  803797:	ff 75 c8             	pushl  -0x38(%ebp)
  80379a:	e8 da ee ff ff       	call   802679 <set_block_data>
  80379f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037a6:	74 06                	je     8037ae <realloc_block_FF+0x142>
  8037a8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037ac:	75 17                	jne    8037c5 <realloc_block_FF+0x159>
  8037ae:	83 ec 04             	sub    $0x4,%esp
  8037b1:	68 5c 49 80 00       	push   $0x80495c
  8037b6:	68 f6 01 00 00       	push   $0x1f6
  8037bb:	68 e9 48 80 00       	push   $0x8048e9
  8037c0:	e8 0b d0 ff ff       	call   8007d0 <_panic>
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	8b 10                	mov    (%eax),%edx
  8037ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037cd:	89 10                	mov    %edx,(%eax)
  8037cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	85 c0                	test   %eax,%eax
  8037d6:	74 0b                	je     8037e3 <realloc_block_FF+0x177>
  8037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f1:	89 50 04             	mov    %edx,0x4(%eax)
  8037f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	75 08                	jne    803805 <realloc_block_FF+0x199>
  8037fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803800:	a3 30 50 80 00       	mov    %eax,0x805030
  803805:	a1 38 50 80 00       	mov    0x805038,%eax
  80380a:	40                   	inc    %eax
  80380b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803814:	75 17                	jne    80382d <realloc_block_FF+0x1c1>
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	68 cb 48 80 00       	push   $0x8048cb
  80381e:	68 f7 01 00 00       	push   $0x1f7
  803823:	68 e9 48 80 00       	push   $0x8048e9
  803828:	e8 a3 cf ff ff       	call   8007d0 <_panic>
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 00                	mov    (%eax),%eax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 10                	je     803846 <realloc_block_FF+0x1da>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383e:	8b 52 04             	mov    0x4(%edx),%edx
  803841:	89 50 04             	mov    %edx,0x4(%eax)
  803844:	eb 0b                	jmp    803851 <realloc_block_FF+0x1e5>
  803846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803849:	8b 40 04             	mov    0x4(%eax),%eax
  80384c:	a3 30 50 80 00       	mov    %eax,0x805030
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	8b 40 04             	mov    0x4(%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 0f                	je     80386a <realloc_block_FF+0x1fe>
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803864:	8b 12                	mov    (%edx),%edx
  803866:	89 10                	mov    %edx,(%eax)
  803868:	eb 0a                	jmp    803874 <realloc_block_FF+0x208>
  80386a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386d:	8b 00                	mov    (%eax),%eax
  80386f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803887:	a1 38 50 80 00       	mov    0x805038,%eax
  80388c:	48                   	dec    %eax
  80388d:	a3 38 50 80 00       	mov    %eax,0x805038
  803892:	e9 83 02 00 00       	jmp    803b1a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803897:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80389b:	0f 86 69 02 00 00    	jbe    803b0a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	6a 01                	push   $0x1
  8038a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8038a9:	ff 75 08             	pushl  0x8(%ebp)
  8038ac:	e8 c8 ed ff ff       	call   802679 <set_block_data>
  8038b1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	83 e8 04             	sub    $0x4,%eax
  8038ba:	8b 00                	mov    (%eax),%eax
  8038bc:	83 e0 fe             	and    $0xfffffffe,%eax
  8038bf:	89 c2                	mov    %eax,%edx
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	01 d0                	add    %edx,%eax
  8038c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8038c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8038d1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038d5:	75 68                	jne    80393f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038db:	75 17                	jne    8038f4 <realloc_block_FF+0x288>
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	68 04 49 80 00       	push   $0x804904
  8038e5:	68 06 02 00 00       	push   $0x206
  8038ea:	68 e9 48 80 00       	push   $0x8048e9
  8038ef:	e8 dc ce ff ff       	call   8007d0 <_panic>
  8038f4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8038fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038fd:	89 10                	mov    %edx,(%eax)
  8038ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803902:	8b 00                	mov    (%eax),%eax
  803904:	85 c0                	test   %eax,%eax
  803906:	74 0d                	je     803915 <realloc_block_FF+0x2a9>
  803908:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80390d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803910:	89 50 04             	mov    %edx,0x4(%eax)
  803913:	eb 08                	jmp    80391d <realloc_block_FF+0x2b1>
  803915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803918:	a3 30 50 80 00       	mov    %eax,0x805030
  80391d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803920:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803925:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803928:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392f:	a1 38 50 80 00       	mov    0x805038,%eax
  803934:	40                   	inc    %eax
  803935:	a3 38 50 80 00       	mov    %eax,0x805038
  80393a:	e9 b0 01 00 00       	jmp    803aef <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80393f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803944:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803947:	76 68                	jbe    8039b1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803949:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80394d:	75 17                	jne    803966 <realloc_block_FF+0x2fa>
  80394f:	83 ec 04             	sub    $0x4,%esp
  803952:	68 04 49 80 00       	push   $0x804904
  803957:	68 0b 02 00 00       	push   $0x20b
  80395c:	68 e9 48 80 00       	push   $0x8048e9
  803961:	e8 6a ce ff ff       	call   8007d0 <_panic>
  803966:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80396c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396f:	89 10                	mov    %edx,(%eax)
  803971:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803974:	8b 00                	mov    (%eax),%eax
  803976:	85 c0                	test   %eax,%eax
  803978:	74 0d                	je     803987 <realloc_block_FF+0x31b>
  80397a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80397f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	eb 08                	jmp    80398f <realloc_block_FF+0x323>
  803987:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398a:	a3 30 50 80 00       	mov    %eax,0x805030
  80398f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803992:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a6:	40                   	inc    %eax
  8039a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8039ac:	e9 3e 01 00 00       	jmp    803aef <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8039b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039b9:	73 68                	jae    803a23 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039bf:	75 17                	jne    8039d8 <realloc_block_FF+0x36c>
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	68 38 49 80 00       	push   $0x804938
  8039c9:	68 10 02 00 00       	push   $0x210
  8039ce:	68 e9 48 80 00       	push   $0x8048e9
  8039d3:	e8 f8 cd ff ff       	call   8007d0 <_panic>
  8039d8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8039de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e1:	89 50 04             	mov    %edx,0x4(%eax)
  8039e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	74 0c                	je     8039fa <realloc_block_FF+0x38e>
  8039ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8039f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039f6:	89 10                	mov    %edx,(%eax)
  8039f8:	eb 08                	jmp    803a02 <realloc_block_FF+0x396>
  8039fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a05:	a3 30 50 80 00       	mov    %eax,0x805030
  803a0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a13:	a1 38 50 80 00       	mov    0x805038,%eax
  803a18:	40                   	inc    %eax
  803a19:	a3 38 50 80 00       	mov    %eax,0x805038
  803a1e:	e9 cc 00 00 00       	jmp    803aef <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a2a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a32:	e9 8a 00 00 00       	jmp    803ac1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a3d:	73 7a                	jae    803ab9 <realloc_block_FF+0x44d>
  803a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a47:	73 70                	jae    803ab9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a4d:	74 06                	je     803a55 <realloc_block_FF+0x3e9>
  803a4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a53:	75 17                	jne    803a6c <realloc_block_FF+0x400>
  803a55:	83 ec 04             	sub    $0x4,%esp
  803a58:	68 5c 49 80 00       	push   $0x80495c
  803a5d:	68 1a 02 00 00       	push   $0x21a
  803a62:	68 e9 48 80 00       	push   $0x8048e9
  803a67:	e8 64 cd ff ff       	call   8007d0 <_panic>
  803a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6f:	8b 10                	mov    (%eax),%edx
  803a71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a74:	89 10                	mov    %edx,(%eax)
  803a76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	74 0b                	je     803a8a <realloc_block_FF+0x41e>
  803a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a87:	89 50 04             	mov    %edx,0x4(%eax)
  803a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a90:	89 10                	mov    %edx,(%eax)
  803a92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a98:	89 50 04             	mov    %edx,0x4(%eax)
  803a9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9e:	8b 00                	mov    (%eax),%eax
  803aa0:	85 c0                	test   %eax,%eax
  803aa2:	75 08                	jne    803aac <realloc_block_FF+0x440>
  803aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa7:	a3 30 50 80 00       	mov    %eax,0x805030
  803aac:	a1 38 50 80 00       	mov    0x805038,%eax
  803ab1:	40                   	inc    %eax
  803ab2:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803ab7:	eb 36                	jmp    803aef <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ab9:	a1 34 50 80 00       	mov    0x805034,%eax
  803abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac5:	74 07                	je     803ace <realloc_block_FF+0x462>
  803ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aca:	8b 00                	mov    (%eax),%eax
  803acc:	eb 05                	jmp    803ad3 <realloc_block_FF+0x467>
  803ace:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad3:	a3 34 50 80 00       	mov    %eax,0x805034
  803ad8:	a1 34 50 80 00       	mov    0x805034,%eax
  803add:	85 c0                	test   %eax,%eax
  803adf:	0f 85 52 ff ff ff    	jne    803a37 <realloc_block_FF+0x3cb>
  803ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae9:	0f 85 48 ff ff ff    	jne    803a37 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803aef:	83 ec 04             	sub    $0x4,%esp
  803af2:	6a 00                	push   $0x0
  803af4:	ff 75 d8             	pushl  -0x28(%ebp)
  803af7:	ff 75 d4             	pushl  -0x2c(%ebp)
  803afa:	e8 7a eb ff ff       	call   802679 <set_block_data>
  803aff:	83 c4 10             	add    $0x10,%esp
				return va;
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	e9 7b 02 00 00       	jmp    803d85 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b0a:	83 ec 0c             	sub    $0xc,%esp
  803b0d:	68 d9 49 80 00       	push   $0x8049d9
  803b12:	e8 76 cf ff ff       	call   800a8d <cprintf>
  803b17:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1d:	e9 63 02 00 00       	jmp    803d85 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b25:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b28:	0f 86 4d 02 00 00    	jbe    803d7b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803b2e:	83 ec 0c             	sub    $0xc,%esp
  803b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b34:	e8 08 e8 ff ff       	call   802341 <is_free_block>
  803b39:	83 c4 10             	add    $0x10,%esp
  803b3c:	84 c0                	test   %al,%al
  803b3e:	0f 84 37 02 00 00    	je     803d7b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b47:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b50:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b53:	76 38                	jbe    803b8d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803b55:	83 ec 0c             	sub    $0xc,%esp
  803b58:	ff 75 08             	pushl  0x8(%ebp)
  803b5b:	e8 0c fa ff ff       	call   80356c <free_block>
  803b60:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803b63:	83 ec 0c             	sub    $0xc,%esp
  803b66:	ff 75 0c             	pushl  0xc(%ebp)
  803b69:	e8 3a eb ff ff       	call   8026a8 <alloc_block_FF>
  803b6e:	83 c4 10             	add    $0x10,%esp
  803b71:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b74:	83 ec 08             	sub    $0x8,%esp
  803b77:	ff 75 c0             	pushl  -0x40(%ebp)
  803b7a:	ff 75 08             	pushl  0x8(%ebp)
  803b7d:	e8 ab fa ff ff       	call   80362d <copy_data>
  803b82:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b85:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b88:	e9 f8 01 00 00       	jmp    803d85 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b90:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803b93:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803b96:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803b9a:	0f 87 a0 00 00 00    	ja     803c40 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ba4:	75 17                	jne    803bbd <realloc_block_FF+0x551>
  803ba6:	83 ec 04             	sub    $0x4,%esp
  803ba9:	68 cb 48 80 00       	push   $0x8048cb
  803bae:	68 38 02 00 00       	push   $0x238
  803bb3:	68 e9 48 80 00       	push   $0x8048e9
  803bb8:	e8 13 cc ff ff       	call   8007d0 <_panic>
  803bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	74 10                	je     803bd6 <realloc_block_FF+0x56a>
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bce:	8b 52 04             	mov    0x4(%edx),%edx
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	eb 0b                	jmp    803be1 <realloc_block_FF+0x575>
  803bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd9:	8b 40 04             	mov    0x4(%eax),%eax
  803bdc:	a3 30 50 80 00       	mov    %eax,0x805030
  803be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be4:	8b 40 04             	mov    0x4(%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 0f                	je     803bfa <realloc_block_FF+0x58e>
  803beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bee:	8b 40 04             	mov    0x4(%eax),%eax
  803bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf4:	8b 12                	mov    (%edx),%edx
  803bf6:	89 10                	mov    %edx,(%eax)
  803bf8:	eb 0a                	jmp    803c04 <realloc_block_FF+0x598>
  803bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfd:	8b 00                	mov    (%eax),%eax
  803bff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c17:	a1 38 50 80 00       	mov    0x805038,%eax
  803c1c:	48                   	dec    %eax
  803c1d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c28:	01 d0                	add    %edx,%eax
  803c2a:	83 ec 04             	sub    $0x4,%esp
  803c2d:	6a 01                	push   $0x1
  803c2f:	50                   	push   %eax
  803c30:	ff 75 08             	pushl  0x8(%ebp)
  803c33:	e8 41 ea ff ff       	call   802679 <set_block_data>
  803c38:	83 c4 10             	add    $0x10,%esp
  803c3b:	e9 36 01 00 00       	jmp    803d76 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803c40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c46:	01 d0                	add    %edx,%eax
  803c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c4b:	83 ec 04             	sub    $0x4,%esp
  803c4e:	6a 01                	push   $0x1
  803c50:	ff 75 f0             	pushl  -0x10(%ebp)
  803c53:	ff 75 08             	pushl  0x8(%ebp)
  803c56:	e8 1e ea ff ff       	call   802679 <set_block_data>
  803c5b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	83 e8 04             	sub    $0x4,%eax
  803c64:	8b 00                	mov    (%eax),%eax
  803c66:	83 e0 fe             	and    $0xfffffffe,%eax
  803c69:	89 c2                	mov    %eax,%edx
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	01 d0                	add    %edx,%eax
  803c70:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c77:	74 06                	je     803c7f <realloc_block_FF+0x613>
  803c79:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c7d:	75 17                	jne    803c96 <realloc_block_FF+0x62a>
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	68 5c 49 80 00       	push   $0x80495c
  803c87:	68 44 02 00 00       	push   $0x244
  803c8c:	68 e9 48 80 00       	push   $0x8048e9
  803c91:	e8 3a cb ff ff       	call   8007d0 <_panic>
  803c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c99:	8b 10                	mov    (%eax),%edx
  803c9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c9e:	89 10                	mov    %edx,(%eax)
  803ca0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ca3:	8b 00                	mov    (%eax),%eax
  803ca5:	85 c0                	test   %eax,%eax
  803ca7:	74 0b                	je     803cb4 <realloc_block_FF+0x648>
  803ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cac:	8b 00                	mov    (%eax),%eax
  803cae:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cb1:	89 50 04             	mov    %edx,0x4(%eax)
  803cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cba:	89 10                	mov    %edx,(%eax)
  803cbc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cc2:	89 50 04             	mov    %edx,0x4(%eax)
  803cc5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	75 08                	jne    803cd6 <realloc_block_FF+0x66a>
  803cce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803cd1:	a3 30 50 80 00       	mov    %eax,0x805030
  803cd6:	a1 38 50 80 00       	mov    0x805038,%eax
  803cdb:	40                   	inc    %eax
  803cdc:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ce1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ce5:	75 17                	jne    803cfe <realloc_block_FF+0x692>
  803ce7:	83 ec 04             	sub    $0x4,%esp
  803cea:	68 cb 48 80 00       	push   $0x8048cb
  803cef:	68 45 02 00 00       	push   $0x245
  803cf4:	68 e9 48 80 00       	push   $0x8048e9
  803cf9:	e8 d2 ca ff ff       	call   8007d0 <_panic>
  803cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d01:	8b 00                	mov    (%eax),%eax
  803d03:	85 c0                	test   %eax,%eax
  803d05:	74 10                	je     803d17 <realloc_block_FF+0x6ab>
  803d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0a:	8b 00                	mov    (%eax),%eax
  803d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d0f:	8b 52 04             	mov    0x4(%edx),%edx
  803d12:	89 50 04             	mov    %edx,0x4(%eax)
  803d15:	eb 0b                	jmp    803d22 <realloc_block_FF+0x6b6>
  803d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1a:	8b 40 04             	mov    0x4(%eax),%eax
  803d1d:	a3 30 50 80 00       	mov    %eax,0x805030
  803d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d25:	8b 40 04             	mov    0x4(%eax),%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 0f                	je     803d3b <realloc_block_FF+0x6cf>
  803d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2f:	8b 40 04             	mov    0x4(%eax),%eax
  803d32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d35:	8b 12                	mov    (%edx),%edx
  803d37:	89 10                	mov    %edx,(%eax)
  803d39:	eb 0a                	jmp    803d45 <realloc_block_FF+0x6d9>
  803d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3e:	8b 00                	mov    (%eax),%eax
  803d40:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d58:	a1 38 50 80 00       	mov    0x805038,%eax
  803d5d:	48                   	dec    %eax
  803d5e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803d63:	83 ec 04             	sub    $0x4,%esp
  803d66:	6a 00                	push   $0x0
  803d68:	ff 75 bc             	pushl  -0x44(%ebp)
  803d6b:	ff 75 b8             	pushl  -0x48(%ebp)
  803d6e:	e8 06 e9 ff ff       	call   802679 <set_block_data>
  803d73:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d76:	8b 45 08             	mov    0x8(%ebp),%eax
  803d79:	eb 0a                	jmp    803d85 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d7b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d85:	c9                   	leave  
  803d86:	c3                   	ret    

00803d87 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d87:	55                   	push   %ebp
  803d88:	89 e5                	mov    %esp,%ebp
  803d8a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803d8d:	83 ec 04             	sub    $0x4,%esp
  803d90:	68 e0 49 80 00       	push   $0x8049e0
  803d95:	68 58 02 00 00       	push   $0x258
  803d9a:	68 e9 48 80 00       	push   $0x8048e9
  803d9f:	e8 2c ca ff ff       	call   8007d0 <_panic>

00803da4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803da4:	55                   	push   %ebp
  803da5:	89 e5                	mov    %esp,%ebp
  803da7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803daa:	83 ec 04             	sub    $0x4,%esp
  803dad:	68 08 4a 80 00       	push   $0x804a08
  803db2:	68 61 02 00 00       	push   $0x261
  803db7:	68 e9 48 80 00       	push   $0x8048e9
  803dbc:	e8 0f ca ff ff       	call   8007d0 <_panic>

00803dc1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803dc1:	55                   	push   %ebp
  803dc2:	89 e5                	mov    %esp,%ebp
  803dc4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803dc7:	83 ec 04             	sub    $0x4,%esp
  803dca:	68 30 4a 80 00       	push   $0x804a30
  803dcf:	6a 09                	push   $0x9
  803dd1:	68 58 4a 80 00       	push   $0x804a58
  803dd6:	e8 f5 c9 ff ff       	call   8007d0 <_panic>

00803ddb <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803ddb:	55                   	push   %ebp
  803ddc:	89 e5                	mov    %esp,%ebp
  803dde:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803de1:	83 ec 04             	sub    $0x4,%esp
  803de4:	68 68 4a 80 00       	push   $0x804a68
  803de9:	6a 10                	push   $0x10
  803deb:	68 58 4a 80 00       	push   $0x804a58
  803df0:	e8 db c9 ff ff       	call   8007d0 <_panic>

00803df5 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803df5:	55                   	push   %ebp
  803df6:	89 e5                	mov    %esp,%ebp
  803df8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803dfb:	83 ec 04             	sub    $0x4,%esp
  803dfe:	68 90 4a 80 00       	push   $0x804a90
  803e03:	6a 18                	push   $0x18
  803e05:	68 58 4a 80 00       	push   $0x804a58
  803e0a:	e8 c1 c9 ff ff       	call   8007d0 <_panic>

00803e0f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803e0f:	55                   	push   %ebp
  803e10:	89 e5                	mov    %esp,%ebp
  803e12:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803e15:	83 ec 04             	sub    $0x4,%esp
  803e18:	68 b8 4a 80 00       	push   $0x804ab8
  803e1d:	6a 20                	push   $0x20
  803e1f:	68 58 4a 80 00       	push   $0x804a58
  803e24:	e8 a7 c9 ff ff       	call   8007d0 <_panic>

00803e29 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803e29:	55                   	push   %ebp
  803e2a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2f:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e32:	5d                   	pop    %ebp
  803e33:	c3                   	ret    

00803e34 <__udivdi3>:
  803e34:	55                   	push   %ebp
  803e35:	57                   	push   %edi
  803e36:	56                   	push   %esi
  803e37:	53                   	push   %ebx
  803e38:	83 ec 1c             	sub    $0x1c,%esp
  803e3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e4b:	89 ca                	mov    %ecx,%edx
  803e4d:	89 f8                	mov    %edi,%eax
  803e4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e53:	85 f6                	test   %esi,%esi
  803e55:	75 2d                	jne    803e84 <__udivdi3+0x50>
  803e57:	39 cf                	cmp    %ecx,%edi
  803e59:	77 65                	ja     803ec0 <__udivdi3+0x8c>
  803e5b:	89 fd                	mov    %edi,%ebp
  803e5d:	85 ff                	test   %edi,%edi
  803e5f:	75 0b                	jne    803e6c <__udivdi3+0x38>
  803e61:	b8 01 00 00 00       	mov    $0x1,%eax
  803e66:	31 d2                	xor    %edx,%edx
  803e68:	f7 f7                	div    %edi
  803e6a:	89 c5                	mov    %eax,%ebp
  803e6c:	31 d2                	xor    %edx,%edx
  803e6e:	89 c8                	mov    %ecx,%eax
  803e70:	f7 f5                	div    %ebp
  803e72:	89 c1                	mov    %eax,%ecx
  803e74:	89 d8                	mov    %ebx,%eax
  803e76:	f7 f5                	div    %ebp
  803e78:	89 cf                	mov    %ecx,%edi
  803e7a:	89 fa                	mov    %edi,%edx
  803e7c:	83 c4 1c             	add    $0x1c,%esp
  803e7f:	5b                   	pop    %ebx
  803e80:	5e                   	pop    %esi
  803e81:	5f                   	pop    %edi
  803e82:	5d                   	pop    %ebp
  803e83:	c3                   	ret    
  803e84:	39 ce                	cmp    %ecx,%esi
  803e86:	77 28                	ja     803eb0 <__udivdi3+0x7c>
  803e88:	0f bd fe             	bsr    %esi,%edi
  803e8b:	83 f7 1f             	xor    $0x1f,%edi
  803e8e:	75 40                	jne    803ed0 <__udivdi3+0x9c>
  803e90:	39 ce                	cmp    %ecx,%esi
  803e92:	72 0a                	jb     803e9e <__udivdi3+0x6a>
  803e94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e98:	0f 87 9e 00 00 00    	ja     803f3c <__udivdi3+0x108>
  803e9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ea3:	89 fa                	mov    %edi,%edx
  803ea5:	83 c4 1c             	add    $0x1c,%esp
  803ea8:	5b                   	pop    %ebx
  803ea9:	5e                   	pop    %esi
  803eaa:	5f                   	pop    %edi
  803eab:	5d                   	pop    %ebp
  803eac:	c3                   	ret    
  803ead:	8d 76 00             	lea    0x0(%esi),%esi
  803eb0:	31 ff                	xor    %edi,%edi
  803eb2:	31 c0                	xor    %eax,%eax
  803eb4:	89 fa                	mov    %edi,%edx
  803eb6:	83 c4 1c             	add    $0x1c,%esp
  803eb9:	5b                   	pop    %ebx
  803eba:	5e                   	pop    %esi
  803ebb:	5f                   	pop    %edi
  803ebc:	5d                   	pop    %ebp
  803ebd:	c3                   	ret    
  803ebe:	66 90                	xchg   %ax,%ax
  803ec0:	89 d8                	mov    %ebx,%eax
  803ec2:	f7 f7                	div    %edi
  803ec4:	31 ff                	xor    %edi,%edi
  803ec6:	89 fa                	mov    %edi,%edx
  803ec8:	83 c4 1c             	add    $0x1c,%esp
  803ecb:	5b                   	pop    %ebx
  803ecc:	5e                   	pop    %esi
  803ecd:	5f                   	pop    %edi
  803ece:	5d                   	pop    %ebp
  803ecf:	c3                   	ret    
  803ed0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ed5:	89 eb                	mov    %ebp,%ebx
  803ed7:	29 fb                	sub    %edi,%ebx
  803ed9:	89 f9                	mov    %edi,%ecx
  803edb:	d3 e6                	shl    %cl,%esi
  803edd:	89 c5                	mov    %eax,%ebp
  803edf:	88 d9                	mov    %bl,%cl
  803ee1:	d3 ed                	shr    %cl,%ebp
  803ee3:	89 e9                	mov    %ebp,%ecx
  803ee5:	09 f1                	or     %esi,%ecx
  803ee7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803eeb:	89 f9                	mov    %edi,%ecx
  803eed:	d3 e0                	shl    %cl,%eax
  803eef:	89 c5                	mov    %eax,%ebp
  803ef1:	89 d6                	mov    %edx,%esi
  803ef3:	88 d9                	mov    %bl,%cl
  803ef5:	d3 ee                	shr    %cl,%esi
  803ef7:	89 f9                	mov    %edi,%ecx
  803ef9:	d3 e2                	shl    %cl,%edx
  803efb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eff:	88 d9                	mov    %bl,%cl
  803f01:	d3 e8                	shr    %cl,%eax
  803f03:	09 c2                	or     %eax,%edx
  803f05:	89 d0                	mov    %edx,%eax
  803f07:	89 f2                	mov    %esi,%edx
  803f09:	f7 74 24 0c          	divl   0xc(%esp)
  803f0d:	89 d6                	mov    %edx,%esi
  803f0f:	89 c3                	mov    %eax,%ebx
  803f11:	f7 e5                	mul    %ebp
  803f13:	39 d6                	cmp    %edx,%esi
  803f15:	72 19                	jb     803f30 <__udivdi3+0xfc>
  803f17:	74 0b                	je     803f24 <__udivdi3+0xf0>
  803f19:	89 d8                	mov    %ebx,%eax
  803f1b:	31 ff                	xor    %edi,%edi
  803f1d:	e9 58 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f28:	89 f9                	mov    %edi,%ecx
  803f2a:	d3 e2                	shl    %cl,%edx
  803f2c:	39 c2                	cmp    %eax,%edx
  803f2e:	73 e9                	jae    803f19 <__udivdi3+0xe5>
  803f30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f33:	31 ff                	xor    %edi,%edi
  803f35:	e9 40 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f3a:	66 90                	xchg   %ax,%ax
  803f3c:	31 c0                	xor    %eax,%eax
  803f3e:	e9 37 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f43:	90                   	nop

00803f44 <__umoddi3>:
  803f44:	55                   	push   %ebp
  803f45:	57                   	push   %edi
  803f46:	56                   	push   %esi
  803f47:	53                   	push   %ebx
  803f48:	83 ec 1c             	sub    $0x1c,%esp
  803f4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f63:	89 f3                	mov    %esi,%ebx
  803f65:	89 fa                	mov    %edi,%edx
  803f67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f6b:	89 34 24             	mov    %esi,(%esp)
  803f6e:	85 c0                	test   %eax,%eax
  803f70:	75 1a                	jne    803f8c <__umoddi3+0x48>
  803f72:	39 f7                	cmp    %esi,%edi
  803f74:	0f 86 a2 00 00 00    	jbe    80401c <__umoddi3+0xd8>
  803f7a:	89 c8                	mov    %ecx,%eax
  803f7c:	89 f2                	mov    %esi,%edx
  803f7e:	f7 f7                	div    %edi
  803f80:	89 d0                	mov    %edx,%eax
  803f82:	31 d2                	xor    %edx,%edx
  803f84:	83 c4 1c             	add    $0x1c,%esp
  803f87:	5b                   	pop    %ebx
  803f88:	5e                   	pop    %esi
  803f89:	5f                   	pop    %edi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    
  803f8c:	39 f0                	cmp    %esi,%eax
  803f8e:	0f 87 ac 00 00 00    	ja     804040 <__umoddi3+0xfc>
  803f94:	0f bd e8             	bsr    %eax,%ebp
  803f97:	83 f5 1f             	xor    $0x1f,%ebp
  803f9a:	0f 84 ac 00 00 00    	je     80404c <__umoddi3+0x108>
  803fa0:	bf 20 00 00 00       	mov    $0x20,%edi
  803fa5:	29 ef                	sub    %ebp,%edi
  803fa7:	89 fe                	mov    %edi,%esi
  803fa9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fad:	89 e9                	mov    %ebp,%ecx
  803faf:	d3 e0                	shl    %cl,%eax
  803fb1:	89 d7                	mov    %edx,%edi
  803fb3:	89 f1                	mov    %esi,%ecx
  803fb5:	d3 ef                	shr    %cl,%edi
  803fb7:	09 c7                	or     %eax,%edi
  803fb9:	89 e9                	mov    %ebp,%ecx
  803fbb:	d3 e2                	shl    %cl,%edx
  803fbd:	89 14 24             	mov    %edx,(%esp)
  803fc0:	89 d8                	mov    %ebx,%eax
  803fc2:	d3 e0                	shl    %cl,%eax
  803fc4:	89 c2                	mov    %eax,%edx
  803fc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fca:	d3 e0                	shl    %cl,%eax
  803fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fd4:	89 f1                	mov    %esi,%ecx
  803fd6:	d3 e8                	shr    %cl,%eax
  803fd8:	09 d0                	or     %edx,%eax
  803fda:	d3 eb                	shr    %cl,%ebx
  803fdc:	89 da                	mov    %ebx,%edx
  803fde:	f7 f7                	div    %edi
  803fe0:	89 d3                	mov    %edx,%ebx
  803fe2:	f7 24 24             	mull   (%esp)
  803fe5:	89 c6                	mov    %eax,%esi
  803fe7:	89 d1                	mov    %edx,%ecx
  803fe9:	39 d3                	cmp    %edx,%ebx
  803feb:	0f 82 87 00 00 00    	jb     804078 <__umoddi3+0x134>
  803ff1:	0f 84 91 00 00 00    	je     804088 <__umoddi3+0x144>
  803ff7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ffb:	29 f2                	sub    %esi,%edx
  803ffd:	19 cb                	sbb    %ecx,%ebx
  803fff:	89 d8                	mov    %ebx,%eax
  804001:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804005:	d3 e0                	shl    %cl,%eax
  804007:	89 e9                	mov    %ebp,%ecx
  804009:	d3 ea                	shr    %cl,%edx
  80400b:	09 d0                	or     %edx,%eax
  80400d:	89 e9                	mov    %ebp,%ecx
  80400f:	d3 eb                	shr    %cl,%ebx
  804011:	89 da                	mov    %ebx,%edx
  804013:	83 c4 1c             	add    $0x1c,%esp
  804016:	5b                   	pop    %ebx
  804017:	5e                   	pop    %esi
  804018:	5f                   	pop    %edi
  804019:	5d                   	pop    %ebp
  80401a:	c3                   	ret    
  80401b:	90                   	nop
  80401c:	89 fd                	mov    %edi,%ebp
  80401e:	85 ff                	test   %edi,%edi
  804020:	75 0b                	jne    80402d <__umoddi3+0xe9>
  804022:	b8 01 00 00 00       	mov    $0x1,%eax
  804027:	31 d2                	xor    %edx,%edx
  804029:	f7 f7                	div    %edi
  80402b:	89 c5                	mov    %eax,%ebp
  80402d:	89 f0                	mov    %esi,%eax
  80402f:	31 d2                	xor    %edx,%edx
  804031:	f7 f5                	div    %ebp
  804033:	89 c8                	mov    %ecx,%eax
  804035:	f7 f5                	div    %ebp
  804037:	89 d0                	mov    %edx,%eax
  804039:	e9 44 ff ff ff       	jmp    803f82 <__umoddi3+0x3e>
  80403e:	66 90                	xchg   %ax,%ax
  804040:	89 c8                	mov    %ecx,%eax
  804042:	89 f2                	mov    %esi,%edx
  804044:	83 c4 1c             	add    $0x1c,%esp
  804047:	5b                   	pop    %ebx
  804048:	5e                   	pop    %esi
  804049:	5f                   	pop    %edi
  80404a:	5d                   	pop    %ebp
  80404b:	c3                   	ret    
  80404c:	3b 04 24             	cmp    (%esp),%eax
  80404f:	72 06                	jb     804057 <__umoddi3+0x113>
  804051:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804055:	77 0f                	ja     804066 <__umoddi3+0x122>
  804057:	89 f2                	mov    %esi,%edx
  804059:	29 f9                	sub    %edi,%ecx
  80405b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80405f:	89 14 24             	mov    %edx,(%esp)
  804062:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804066:	8b 44 24 04          	mov    0x4(%esp),%eax
  80406a:	8b 14 24             	mov    (%esp),%edx
  80406d:	83 c4 1c             	add    $0x1c,%esp
  804070:	5b                   	pop    %ebx
  804071:	5e                   	pop    %esi
  804072:	5f                   	pop    %edi
  804073:	5d                   	pop    %ebp
  804074:	c3                   	ret    
  804075:	8d 76 00             	lea    0x0(%esi),%esi
  804078:	2b 04 24             	sub    (%esp),%eax
  80407b:	19 fa                	sbb    %edi,%edx
  80407d:	89 d1                	mov    %edx,%ecx
  80407f:	89 c6                	mov    %eax,%esi
  804081:	e9 71 ff ff ff       	jmp    803ff7 <__umoddi3+0xb3>
  804086:	66 90                	xchg   %ax,%ax
  804088:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80408c:	72 ea                	jb     804078 <__umoddi3+0x134>
  80408e:	89 d9                	mov    %ebx,%ecx
  804090:	e9 62 ff ff ff       	jmp    803ff7 <__umoddi3+0xb3>

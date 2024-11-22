
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
  800044:	e8 50 1f 00 00       	call   801f99 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 75 40 80 00       	mov    $0x804075,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 7f 40 80 00       	mov    $0x80407f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 8b 40 80 00       	mov    $0x80408b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 9a 40 80 00       	mov    $0x80409a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb a9 40 80 00       	mov    $0x8040a9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb be 40 80 00       	mov    $0x8040be,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb d3 40 80 00       	mov    $0x8040d3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb e4 40 80 00       	mov    $0x8040e4,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb f5 40 80 00       	mov    $0x8040f5,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 06 41 80 00       	mov    $0x804106,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 0f 41 80 00       	mov    $0x80410f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 19 41 80 00       	mov    $0x804119,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 24 41 80 00       	mov    $0x804124,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 30 41 80 00       	mov    $0x804130,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 3a 41 80 00       	mov    $0x80413a,%ebx
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
  8001c1:	bb 44 41 80 00       	mov    $0x804144,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 52 41 80 00       	mov    $0x804152,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 61 41 80 00       	mov    $0x804161,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 68 41 80 00       	mov    $0x804168,%ebx
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
  8002fe:	e8 70 3a 00 00       	call   803d73 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 54 3a 00 00       	call   803d73 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 38 3a 00 00       	call   803d73 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 1c 3a 00 00       	call   803d73 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 00 3a 00 00       	call   803d73 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 09 3a 00 00       	call   803d8d <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 f8 39 00 00       	call   803d8d <wait_semaphore>
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
  8003c4:	e8 de 39 00 00       	call   803da7 <signal_semaphore>
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
  800407:	e8 81 39 00 00       	call   803d8d <wait_semaphore>
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
  800467:	e8 3b 39 00 00       	call   803da7 <signal_semaphore>
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
  80047d:	e8 0b 39 00 00       	call   803d8d <wait_semaphore>
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
  8004dd:	e8 c5 38 00 00       	call   803da7 <signal_semaphore>
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
  8004f3:	e8 95 38 00 00       	call   803d8d <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 84 38 00 00       	call   803d8d <wait_semaphore>
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
  8005bb:	e8 e7 37 00 00       	call   803da7 <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 d6 37 00 00       	call   803da7 <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 40 40 80 00       	push   $0x804040
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 60 40 80 00       	push   $0x804060
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 6f 41 80 00       	mov    $0x80416f,%ebx
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
  800662:	e8 0c 37 00 00       	call   803d73 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 2f 37 00 00       	call   803da7 <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 1e 37 00 00       	call   803da7 <signal_semaphore>
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
  800697:	e8 e4 18 00 00       	call   801f80 <sys_getenvindex>
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
  800705:	e8 fa 15 00 00       	call   801d04 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 a8 41 80 00       	push   $0x8041a8
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
  800735:	68 d0 41 80 00       	push   $0x8041d0
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
  800766:	68 f8 41 80 00       	push   $0x8041f8
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 50 42 80 00       	push   $0x804250
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 a8 41 80 00       	push   $0x8041a8
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 7a 15 00 00       	call   801d1e <sys_unlock_cons>
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
  8007b7:	e8 90 17 00 00       	call   801f4c <sys_destroy_env>
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
  8007c8:	e8 e5 17 00 00       	call   801fb2 <sys_exit_env>
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
  8007f1:	68 64 42 80 00       	push   $0x804264
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 69 42 80 00       	push   $0x804269
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
  80082e:	68 85 42 80 00       	push   $0x804285
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
  80085d:	68 88 42 80 00       	push   $0x804288
  800862:	6a 26                	push   $0x26
  800864:	68 d4 42 80 00       	push   $0x8042d4
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
  800932:	68 e0 42 80 00       	push   $0x8042e0
  800937:	6a 3a                	push   $0x3a
  800939:	68 d4 42 80 00       	push   $0x8042d4
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
  8009a5:	68 34 43 80 00       	push   $0x804334
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 d4 42 80 00       	push   $0x8042d4
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
  8009ff:	e8 be 12 00 00       	call   801cc2 <sys_cputs>
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
  800a76:	e8 47 12 00 00       	call   801cc2 <sys_cputs>
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
  800ac0:	e8 3f 12 00 00       	call   801d04 <sys_lock_cons>
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
  800ae0:	e8 39 12 00 00       	call   801d1e <sys_unlock_cons>
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
  800b2a:	e8 9d 32 00 00       	call   803dcc <__udivdi3>
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
  800b7a:	e8 5d 33 00 00       	call   803edc <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 94 45 80 00       	add    $0x804594,%eax
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
  800cd5:	8b 04 85 b8 45 80 00 	mov    0x8045b8(,%eax,4),%eax
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
  800db6:	8b 34 9d 00 44 80 00 	mov    0x804400(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 a5 45 80 00       	push   $0x8045a5
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
  800ddb:	68 ae 45 80 00       	push   $0x8045ae
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
  800e08:	be b1 45 80 00       	mov    $0x8045b1,%esi
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
  801813:	68 28 47 80 00       	push   $0x804728
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 4a 47 80 00       	push   $0x80474a
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
  801833:	e8 35 0a 00 00       	call   80226d <sys_sbrk>
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
  8018ae:	e8 3e 08 00 00       	call   8020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 7e 0d 00 00       	call   802640 <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 50 08 00 00       	call   802122 <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 17 12 00 00       	call   802afc <alloc_block_BF>
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
  801a46:	e8 59 08 00 00       	call   8022a4 <sys_allocate_user_mem>
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
  801a8e:	e8 2d 08 00 00       	call   8022c0 <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 60 1a 00 00       	call   803504 <free_block>
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
  801b36:	e8 4d 07 00 00       	call   802288 <sys_free_user_mem>
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
  801b44:	68 58 47 80 00       	push   $0x804758
  801b49:	68 84 00 00 00       	push   $0x84
  801b4e:	68 82 47 80 00       	push   $0x804782
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
  801bb6:	e8 d4 02 00 00       	call   801e8f <sys_createSharedObject>
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
  801bd7:	68 8e 47 80 00       	push   $0x80478e
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
  801bec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 94 47 80 00       	push   $0x804794
  801bf7:	68 a4 00 00 00       	push   $0xa4
  801bfc:	68 82 47 80 00       	push   $0x804782
  801c01:	e8 ca eb ff ff       	call   8007d0 <_panic>

00801c06 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	68 b8 47 80 00       	push   $0x8047b8
  801c14:	68 bc 00 00 00       	push   $0xbc
  801c19:	68 82 47 80 00       	push   $0x804782
  801c1e:	e8 ad eb ff ff       	call   8007d0 <_panic>

00801c23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	68 dc 47 80 00       	push   $0x8047dc
  801c31:	68 d3 00 00 00       	push   $0xd3
  801c36:	68 82 47 80 00       	push   $0x804782
  801c3b:	e8 90 eb ff ff       	call   8007d0 <_panic>

00801c40 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	68 02 48 80 00       	push   $0x804802
  801c4e:	68 df 00 00 00       	push   $0xdf
  801c53:	68 82 47 80 00       	push   $0x804782
  801c58:	e8 73 eb ff ff       	call   8007d0 <_panic>

00801c5d <shrink>:

}
void shrink(uint32 newSize)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	68 02 48 80 00       	push   $0x804802
  801c6b:	68 e4 00 00 00       	push   $0xe4
  801c70:	68 82 47 80 00       	push   $0x804782
  801c75:	e8 56 eb ff ff       	call   8007d0 <_panic>

00801c7a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	68 02 48 80 00       	push   $0x804802
  801c88:	68 e9 00 00 00       	push   $0xe9
  801c8d:	68 82 47 80 00       	push   $0x804782
  801c92:	e8 39 eb ff ff       	call   8007d0 <_panic>

00801c97 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	57                   	push   %edi
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cac:	8b 7d 18             	mov    0x18(%ebp),%edi
  801caf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb2:	cd 30                	int    $0x30
  801cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5f                   	pop    %edi
  801cc0:	5d                   	pop    %ebp
  801cc1:	c3                   	ret    

00801cc2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	50                   	push   %eax
  801cde:	6a 00                	push   $0x0
  801ce0:	e8 b2 ff ff ff       	call   801c97 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_cgetc>:

int
sys_cgetc(void)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 02                	push   $0x2
  801cfa:	e8 98 ff ff ff       	call   801c97 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 03                	push   $0x3
  801d13:	e8 7f ff ff ff       	call   801c97 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	90                   	nop
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 04                	push   $0x4
  801d2d:	e8 65 ff ff ff       	call   801c97 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	90                   	nop
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 08                	push   $0x8
  801d4b:	e8 47 ff ff ff       	call   801c97 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d5a:	8b 75 18             	mov    0x18(%ebp),%esi
  801d5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	56                   	push   %esi
  801d6a:	53                   	push   %ebx
  801d6b:	51                   	push   %ecx
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 09                	push   $0x9
  801d70:	e8 22 ff ff ff       	call   801c97 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    

00801d7f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	52                   	push   %edx
  801d8f:	50                   	push   %eax
  801d90:	6a 0a                	push   $0xa
  801d92:	e8 00 ff ff ff       	call   801c97 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 0c             	pushl  0xc(%ebp)
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 0b                	push   $0xb
  801dad:	e8 e5 fe ff ff       	call   801c97 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 0c                	push   $0xc
  801dc6:	e8 cc fe ff ff       	call   801c97 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 0d                	push   $0xd
  801ddf:	e8 b3 fe ff ff       	call   801c97 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 0e                	push   $0xe
  801df8:	e8 9a fe ff ff       	call   801c97 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 0f                	push   $0xf
  801e11:	e8 81 fe ff ff       	call   801c97 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 10                	push   $0x10
  801e2b:	e8 67 fe ff ff       	call   801c97 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 11                	push   $0x11
  801e44:	e8 4e fe ff ff       	call   801c97 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	90                   	nop
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_cputc>:

void
sys_cputc(const char c)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	50                   	push   %eax
  801e68:	6a 01                	push   $0x1
  801e6a:	e8 28 fe ff ff       	call   801c97 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 14                	push   $0x14
  801e84:	e8 0e fe ff ff       	call   801c97 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	90                   	nop
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	8b 45 10             	mov    0x10(%ebp),%eax
  801e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e9b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e9e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	51                   	push   %ecx
  801ea8:	52                   	push   %edx
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	50                   	push   %eax
  801ead:	6a 15                	push   $0x15
  801eaf:	e8 e3 fd ff ff       	call   801c97 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 16                	push   $0x16
  801ecc:	e8 c6 fd ff ff       	call   801c97 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ed9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	51                   	push   %ecx
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 17                	push   $0x17
  801eeb:	e8 a7 fd ff ff       	call   801c97 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	6a 18                	push   $0x18
  801f08:	e8 8a fd ff ff       	call   801c97 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 14             	pushl  0x14(%ebp)
  801f1d:	ff 75 10             	pushl  0x10(%ebp)
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	6a 19                	push   $0x19
  801f26:	e8 6c fd ff ff       	call   801c97 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	50                   	push   %eax
  801f3f:	6a 1a                	push   $0x1a
  801f41:	e8 51 fd ff ff       	call   801c97 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	50                   	push   %eax
  801f5b:	6a 1b                	push   $0x1b
  801f5d:	e8 35 fd ff ff       	call   801c97 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 05                	push   $0x5
  801f76:	e8 1c fd ff ff       	call   801c97 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 06                	push   $0x6
  801f8f:	e8 03 fd ff ff       	call   801c97 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 07                	push   $0x7
  801fa8:	e8 ea fc ff ff       	call   801c97 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 1c                	push   $0x1c
  801fc1:	e8 d1 fc ff ff       	call   801c97 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd5:	8d 50 04             	lea    0x4(%eax),%edx
  801fd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	52                   	push   %edx
  801fe2:	50                   	push   %eax
  801fe3:	6a 1d                	push   $0x1d
  801fe5:	e8 ad fc ff ff       	call   801c97 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return result;
  801fed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff6:	89 01                	mov    %eax,(%ecx)
  801ff8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	c9                   	leave  
  801fff:	c2 04 00             	ret    $0x4

00802002 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	6a 13                	push   $0x13
  802014:	e8 7e fc ff ff       	call   801c97 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
	return ;
  80201c:	90                   	nop
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_rcr2>:
uint32 sys_rcr2()
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 1e                	push   $0x1e
  80202e:	e8 64 fc ff ff       	call   801c97 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802044:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	50                   	push   %eax
  802051:	6a 1f                	push   $0x1f
  802053:	e8 3f fc ff ff       	call   801c97 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <rsttst>:
void rsttst()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 21                	push   $0x21
  80206d:	e8 25 fc ff ff       	call   801c97 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	8b 45 14             	mov    0x14(%ebp),%eax
  802081:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802084:	8b 55 18             	mov    0x18(%ebp),%edx
  802087:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208b:	52                   	push   %edx
  80208c:	50                   	push   %eax
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	6a 20                	push   $0x20
  802098:	e8 fa fb ff ff       	call   801c97 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a0:	90                   	nop
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <chktst>:
void chktst(uint32 n)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 22                	push   $0x22
  8020b3:	e8 df fb ff ff       	call   801c97 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <inctst>:

void inctst()
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 23                	push   $0x23
  8020cd:	e8 c5 fb ff ff       	call   801c97 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d5:	90                   	nop
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <gettst>:
uint32 gettst()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 24                	push   $0x24
  8020e7:	e8 ab fb ff ff       	call   801c97 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 25                	push   $0x25
  802103:	e8 8f fb ff ff       	call   801c97 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80210e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802112:	75 07                	jne    80211b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802114:	b8 01 00 00 00       	mov    $0x1,%eax
  802119:	eb 05                	jmp    802120 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 25                	push   $0x25
  802134:	e8 5e fb ff ff       	call   801c97 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
  80213c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80213f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802143:	75 07                	jne    80214c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802145:	b8 01 00 00 00       	mov    $0x1,%eax
  80214a:	eb 05                	jmp    802151 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 25                	push   $0x25
  802165:	e8 2d fb ff ff       	call   801c97 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802170:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802174:	75 07                	jne    80217d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	eb 05                	jmp    802182 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 25                	push   $0x25
  802196:	e8 fc fa ff ff       	call   801c97 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
  80219e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021a1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021a5:	75 07                	jne    8021ae <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ac:	eb 05                	jmp    8021b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	6a 26                	push   $0x26
  8021c5:	e8 cd fa ff ff       	call   801c97 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	53                   	push   %ebx
  8021e3:	51                   	push   %ecx
  8021e4:	52                   	push   %edx
  8021e5:	50                   	push   %eax
  8021e6:	6a 27                	push   $0x27
  8021e8:	e8 aa fa ff ff       	call   801c97 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	52                   	push   %edx
  802205:	50                   	push   %eax
  802206:	6a 28                	push   $0x28
  802208:	e8 8a fa ff ff       	call   801c97 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802215:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	51                   	push   %ecx
  802221:	ff 75 10             	pushl  0x10(%ebp)
  802224:	52                   	push   %edx
  802225:	50                   	push   %eax
  802226:	6a 29                	push   $0x29
  802228:	e8 6a fa ff ff       	call   801c97 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	ff 75 10             	pushl  0x10(%ebp)
  80223c:	ff 75 0c             	pushl  0xc(%ebp)
  80223f:	ff 75 08             	pushl  0x8(%ebp)
  802242:	6a 12                	push   $0x12
  802244:	e8 4e fa ff ff       	call   801c97 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
	return ;
  80224c:	90                   	nop
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802252:	8b 55 0c             	mov    0xc(%ebp),%edx
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	52                   	push   %edx
  80225f:	50                   	push   %eax
  802260:	6a 2a                	push   $0x2a
  802262:	e8 30 fa ff ff       	call   801c97 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
	return;
  80226a:	90                   	nop
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	50                   	push   %eax
  80227c:	6a 2b                	push   $0x2b
  80227e:	e8 14 fa ff ff       	call   801c97 <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	ff 75 08             	pushl  0x8(%ebp)
  802297:	6a 2c                	push   $0x2c
  802299:	e8 f9 f9 ff ff       	call   801c97 <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
	return;
  8022a1:	90                   	nop
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	ff 75 0c             	pushl  0xc(%ebp)
  8022b0:	ff 75 08             	pushl  0x8(%ebp)
  8022b3:	6a 2d                	push   $0x2d
  8022b5:	e8 dd f9 ff ff       	call   801c97 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
	return;
  8022bd:	90                   	nop
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	83 e8 04             	sub    $0x4,%eax
  8022cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8022cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	83 e8 04             	sub    $0x4,%eax
  8022e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8022e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	83 e0 01             	and    $0x1,%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	0f 94 c0             	sete   %al
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8022fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	83 f8 02             	cmp    $0x2,%eax
  80230a:	74 2b                	je     802337 <alloc_block+0x40>
  80230c:	83 f8 02             	cmp    $0x2,%eax
  80230f:	7f 07                	jg     802318 <alloc_block+0x21>
  802311:	83 f8 01             	cmp    $0x1,%eax
  802314:	74 0e                	je     802324 <alloc_block+0x2d>
  802316:	eb 58                	jmp    802370 <alloc_block+0x79>
  802318:	83 f8 03             	cmp    $0x3,%eax
  80231b:	74 2d                	je     80234a <alloc_block+0x53>
  80231d:	83 f8 04             	cmp    $0x4,%eax
  802320:	74 3b                	je     80235d <alloc_block+0x66>
  802322:	eb 4c                	jmp    802370 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802324:	83 ec 0c             	sub    $0xc,%esp
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	e8 11 03 00 00       	call   802640 <alloc_block_FF>
  80232f:	83 c4 10             	add    $0x10,%esp
  802332:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802335:	eb 4a                	jmp    802381 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802337:	83 ec 0c             	sub    $0xc,%esp
  80233a:	ff 75 08             	pushl  0x8(%ebp)
  80233d:	e8 fa 19 00 00       	call   803d3c <alloc_block_NF>
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802348:	eb 37                	jmp    802381 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80234a:	83 ec 0c             	sub    $0xc,%esp
  80234d:	ff 75 08             	pushl  0x8(%ebp)
  802350:	e8 a7 07 00 00       	call   802afc <alloc_block_BF>
  802355:	83 c4 10             	add    $0x10,%esp
  802358:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80235b:	eb 24                	jmp    802381 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	ff 75 08             	pushl  0x8(%ebp)
  802363:	e8 b7 19 00 00       	call   803d1f <alloc_block_WF>
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80236e:	eb 11                	jmp    802381 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802370:	83 ec 0c             	sub    $0xc,%esp
  802373:	68 14 48 80 00       	push   $0x804814
  802378:	e8 10 e7 ff ff       	call   800a8d <cprintf>
  80237d:	83 c4 10             	add    $0x10,%esp
		break;
  802380:	90                   	nop
	}
	return va;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	53                   	push   %ebx
  80238a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	68 34 48 80 00       	push   $0x804834
  802395:	e8 f3 e6 ff ff       	call   800a8d <cprintf>
  80239a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	68 5f 48 80 00       	push   $0x80485f
  8023a5:	e8 e3 e6 ff ff       	call   800a8d <cprintf>
  8023aa:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b3:	eb 37                	jmp    8023ec <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023bb:	e8 19 ff ff ff       	call   8022d9 <is_free_block>
  8023c0:	83 c4 10             	add    $0x10,%esp
  8023c3:	0f be d8             	movsbl %al,%ebx
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cc:	e8 ef fe ff ff       	call   8022c0 <get_block_size>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	53                   	push   %ebx
  8023d8:	50                   	push   %eax
  8023d9:	68 77 48 80 00       	push   $0x804877
  8023de:	e8 aa e6 ff ff       	call   800a8d <cprintf>
  8023e3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8023e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f0:	74 07                	je     8023f9 <print_blocks_list+0x73>
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	eb 05                	jmp    8023fe <print_blocks_list+0x78>
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fe:	89 45 10             	mov    %eax,0x10(%ebp)
  802401:	8b 45 10             	mov    0x10(%ebp),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	75 ad                	jne    8023b5 <print_blocks_list+0x2f>
  802408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240c:	75 a7                	jne    8023b5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	68 34 48 80 00       	push   $0x804834
  802416:	e8 72 e6 ff ff       	call   800a8d <cprintf>
  80241b:	83 c4 10             	add    $0x10,%esp

}
  80241e:	90                   	nop
  80241f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80242a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242d:	83 e0 01             	and    $0x1,%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 03                	je     802437 <initialize_dynamic_allocator+0x13>
  802434:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80243b:	0f 84 c7 01 00 00    	je     802608 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802441:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802448:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80244b:	8b 55 08             	mov    0x8(%ebp),%edx
  80244e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802451:	01 d0                	add    %edx,%eax
  802453:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802458:	0f 87 ad 01 00 00    	ja     80260b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	0f 89 a5 01 00 00    	jns    80260e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802469:	8b 55 08             	mov    0x8(%ebp),%edx
  80246c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246f:	01 d0                	add    %edx,%eax
  802471:	83 e8 04             	sub    $0x4,%eax
  802474:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802479:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802480:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802488:	e9 87 00 00 00       	jmp    802514 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80248d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802491:	75 14                	jne    8024a7 <initialize_dynamic_allocator+0x83>
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 8f 48 80 00       	push   $0x80488f
  80249b:	6a 79                	push   $0x79
  80249d:	68 ad 48 80 00       	push   $0x8048ad
  8024a2:	e8 29 e3 ff ff       	call   8007d0 <_panic>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 10                	je     8024c0 <initialize_dynamic_allocator+0x9c>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 52 04             	mov    0x4(%edx),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	eb 0b                	jmp    8024cb <initialize_dynamic_allocator+0xa7>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 04             	mov    0x4(%eax),%eax
  8024c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0f                	je     8024e4 <initialize_dynamic_allocator+0xc0>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024de:	8b 12                	mov    (%edx),%edx
  8024e0:	89 10                	mov    %edx,(%eax)
  8024e2:	eb 0a                	jmp    8024ee <initialize_dynamic_allocator+0xca>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802501:	a1 38 50 80 00       	mov    0x805038,%eax
  802506:	48                   	dec    %eax
  802507:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80250c:	a1 34 50 80 00       	mov    0x805034,%eax
  802511:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802518:	74 07                	je     802521 <initialize_dynamic_allocator+0xfd>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	eb 05                	jmp    802526 <initialize_dynamic_allocator+0x102>
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	a3 34 50 80 00       	mov    %eax,0x805034
  80252b:	a1 34 50 80 00       	mov    0x805034,%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	0f 85 55 ff ff ff    	jne    80248d <initialize_dynamic_allocator+0x69>
  802538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253c:	0f 85 4b ff ff ff    	jne    80248d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802551:	a1 44 50 80 00       	mov    0x805044,%eax
  802556:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80255b:	a1 40 50 80 00       	mov    0x805040,%eax
  802560:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	83 c0 08             	add    $0x8,%eax
  80256c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	83 c0 04             	add    $0x4,%eax
  802575:	8b 55 0c             	mov    0xc(%ebp),%edx
  802578:	83 ea 08             	sub    $0x8,%edx
  80257b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80257d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	01 d0                	add    %edx,%eax
  802585:	83 e8 08             	sub    $0x8,%eax
  802588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258b:	83 ea 08             	sub    $0x8,%edx
  80258e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8025a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a7:	75 17                	jne    8025c0 <initialize_dynamic_allocator+0x19c>
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 c8 48 80 00       	push   $0x8048c8
  8025b1:	68 90 00 00 00       	push   $0x90
  8025b6:	68 ad 48 80 00       	push   $0x8048ad
  8025bb:	e8 10 e2 ff ff       	call   8007d0 <_panic>
  8025c0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c9:	89 10                	mov    %edx,(%eax)
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	74 0d                	je     8025e1 <initialize_dynamic_allocator+0x1bd>
  8025d4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025dc:	89 50 04             	mov    %edx,0x4(%eax)
  8025df:	eb 08                	jmp    8025e9 <initialize_dynamic_allocator+0x1c5>
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fb:	a1 38 50 80 00       	mov    0x805038,%eax
  802600:	40                   	inc    %eax
  802601:	a3 38 50 80 00       	mov    %eax,0x805038
  802606:	eb 07                	jmp    80260f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802608:	90                   	nop
  802609:	eb 04                	jmp    80260f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80260b:	90                   	nop
  80260c:	eb 01                	jmp    80260f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80260e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802614:	8b 45 10             	mov    0x10(%ebp),%eax
  802617:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802620:	8b 45 0c             	mov    0xc(%ebp),%eax
  802623:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	83 e8 04             	sub    $0x4,%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	83 e0 fe             	and    $0xfffffffe,%eax
  802630:	8d 50 f8             	lea    -0x8(%eax),%edx
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	01 c2                	add    %eax,%edx
  802638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263b:	89 02                	mov    %eax,(%edx)
}
  80263d:	90                   	nop
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    

00802640 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	83 e0 01             	and    $0x1,%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 03                	je     802653 <alloc_block_FF+0x13>
  802650:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802653:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802657:	77 07                	ja     802660 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802659:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802660:	a1 24 50 80 00       	mov    0x805024,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	75 73                	jne    8026dc <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	83 c0 10             	add    $0x10,%eax
  80266f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802672:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802679:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	48                   	dec    %eax
  802682:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	f7 75 ec             	divl   -0x14(%ebp)
  802690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802693:	29 d0                	sub    %edx,%eax
  802695:	c1 e8 0c             	shr    $0xc,%eax
  802698:	83 ec 0c             	sub    $0xc,%esp
  80269b:	50                   	push   %eax
  80269c:	e8 86 f1 ff ff       	call   801827 <sbrk>
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	6a 00                	push   $0x0
  8026ac:	e8 76 f1 ff ff       	call   801827 <sbrk>
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026bd:	83 ec 08             	sub    $0x8,%esp
  8026c0:	50                   	push   %eax
  8026c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c4:	e8 5b fd ff ff       	call   802424 <initialize_dynamic_allocator>
  8026c9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	68 eb 48 80 00       	push   $0x8048eb
  8026d4:	e8 b4 e3 ff ff       	call   800a8d <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8026dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e0:	75 0a                	jne    8026ec <alloc_block_FF+0xac>
	        return NULL;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e7:	e9 0e 04 00 00       	jmp    802afa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8026ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fb:	e9 f3 02 00 00       	jmp    8029f3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802706:	83 ec 0c             	sub    $0xc,%esp
  802709:	ff 75 bc             	pushl  -0x44(%ebp)
  80270c:	e8 af fb ff ff       	call   8022c0 <get_block_size>
  802711:	83 c4 10             	add    $0x10,%esp
  802714:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	83 c0 08             	add    $0x8,%eax
  80271d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802720:	0f 87 c5 02 00 00    	ja     8029eb <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	83 c0 18             	add    $0x18,%eax
  80272c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80272f:	0f 87 19 02 00 00    	ja     80294e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802735:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802738:	2b 45 08             	sub    0x8(%ebp),%eax
  80273b:	83 e8 08             	sub    $0x8,%eax
  80273e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	8d 50 08             	lea    0x8(%eax),%edx
  802747:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80274a:	01 d0                	add    %edx,%eax
  80274c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	83 c0 08             	add    $0x8,%eax
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	6a 01                	push   $0x1
  80275a:	50                   	push   %eax
  80275b:	ff 75 bc             	pushl  -0x44(%ebp)
  80275e:	e8 ae fe ff ff       	call   802611 <set_block_data>
  802763:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	75 68                	jne    8027d8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802770:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802774:	75 17                	jne    80278d <alloc_block_FF+0x14d>
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 c8 48 80 00       	push   $0x8048c8
  80277e:	68 d7 00 00 00       	push   $0xd7
  802783:	68 ad 48 80 00       	push   $0x8048ad
  802788:	e8 43 e0 ff ff       	call   8007d0 <_panic>
  80278d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802793:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802796:	89 10                	mov    %edx,(%eax)
  802798:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 0d                	je     8027ae <alloc_block_FF+0x16e>
  8027a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027a6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 08                	jmp    8027b6 <alloc_block_FF+0x176>
  8027ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8027cd:	40                   	inc    %eax
  8027ce:	a3 38 50 80 00       	mov    %eax,0x805038
  8027d3:	e9 dc 00 00 00       	jmp    8028b4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	75 65                	jne    802846 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027e1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8027e5:	75 17                	jne    8027fe <alloc_block_FF+0x1be>
  8027e7:	83 ec 04             	sub    $0x4,%esp
  8027ea:	68 fc 48 80 00       	push   $0x8048fc
  8027ef:	68 db 00 00 00       	push   $0xdb
  8027f4:	68 ad 48 80 00       	push   $0x8048ad
  8027f9:	e8 d2 df ff ff       	call   8007d0 <_panic>
  8027fe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802804:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802807:	89 50 04             	mov    %edx,0x4(%eax)
  80280a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 0c                	je     802820 <alloc_block_FF+0x1e0>
  802814:	a1 30 50 80 00       	mov    0x805030,%eax
  802819:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80281c:	89 10                	mov    %edx,(%eax)
  80281e:	eb 08                	jmp    802828 <alloc_block_FF+0x1e8>
  802820:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802823:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802828:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282b:	a3 30 50 80 00       	mov    %eax,0x805030
  802830:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	a1 38 50 80 00       	mov    0x805038,%eax
  80283e:	40                   	inc    %eax
  80283f:	a3 38 50 80 00       	mov    %eax,0x805038
  802844:	eb 6e                	jmp    8028b4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284a:	74 06                	je     802852 <alloc_block_FF+0x212>
  80284c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802850:	75 17                	jne    802869 <alloc_block_FF+0x229>
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	68 20 49 80 00       	push   $0x804920
  80285a:	68 df 00 00 00       	push   $0xdf
  80285f:	68 ad 48 80 00       	push   $0x8048ad
  802864:	e8 67 df ff ff       	call   8007d0 <_panic>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 10                	mov    (%eax),%edx
  80286e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802871:	89 10                	mov    %edx,(%eax)
  802873:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 0b                	je     802887 <alloc_block_FF+0x247>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802884:	89 50 04             	mov    %edx,0x4(%eax)
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80288d:	89 10                	mov    %edx,(%eax)
  80288f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802895:	89 50 04             	mov    %edx,0x4(%eax)
  802898:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	75 08                	jne    8028a9 <alloc_block_FF+0x269>
  8028a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ae:	40                   	inc    %eax
  8028af:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8028b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b8:	75 17                	jne    8028d1 <alloc_block_FF+0x291>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 8f 48 80 00       	push   $0x80488f
  8028c2:	68 e1 00 00 00       	push   $0xe1
  8028c7:	68 ad 48 80 00       	push   $0x8048ad
  8028cc:	e8 ff de ff ff       	call   8007d0 <_panic>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 10                	je     8028ea <alloc_block_FF+0x2aa>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	8b 52 04             	mov    0x4(%edx),%edx
  8028e5:	89 50 04             	mov    %edx,0x4(%eax)
  8028e8:	eb 0b                	jmp    8028f5 <alloc_block_FF+0x2b5>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 0f                	je     80290e <alloc_block_FF+0x2ce>
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802908:	8b 12                	mov    (%edx),%edx
  80290a:	89 10                	mov    %edx,(%eax)
  80290c:	eb 0a                	jmp    802918 <alloc_block_FF+0x2d8>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292b:	a1 38 50 80 00       	mov    0x805038,%eax
  802930:	48                   	dec    %eax
  802931:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	6a 00                	push   $0x0
  80293b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80293e:	ff 75 b0             	pushl  -0x50(%ebp)
  802941:	e8 cb fc ff ff       	call   802611 <set_block_data>
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	e9 95 00 00 00       	jmp    8029e3 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80294e:	83 ec 04             	sub    $0x4,%esp
  802951:	6a 01                	push   $0x1
  802953:	ff 75 b8             	pushl  -0x48(%ebp)
  802956:	ff 75 bc             	pushl  -0x44(%ebp)
  802959:	e8 b3 fc ff ff       	call   802611 <set_block_data>
  80295e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802961:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802965:	75 17                	jne    80297e <alloc_block_FF+0x33e>
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 8f 48 80 00       	push   $0x80488f
  80296f:	68 e8 00 00 00       	push   $0xe8
  802974:	68 ad 48 80 00       	push   $0x8048ad
  802979:	e8 52 de ff ff       	call   8007d0 <_panic>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 10                	je     802997 <alloc_block_FF+0x357>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298f:	8b 52 04             	mov    0x4(%edx),%edx
  802992:	89 50 04             	mov    %edx,0x4(%eax)
  802995:	eb 0b                	jmp    8029a2 <alloc_block_FF+0x362>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 40 04             	mov    0x4(%eax),%eax
  80299d:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 0f                	je     8029bb <alloc_block_FF+0x37b>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b5:	8b 12                	mov    (%edx),%edx
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	eb 0a                	jmp    8029c5 <alloc_block_FF+0x385>
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029dd:	48                   	dec    %eax
  8029de:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8029e3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029e6:	e9 0f 01 00 00       	jmp    802afa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029eb:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	74 07                	je     802a00 <alloc_block_FF+0x3c0>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	eb 05                	jmp    802a05 <alloc_block_FF+0x3c5>
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	a3 34 50 80 00       	mov    %eax,0x805034
  802a0a:	a1 34 50 80 00       	mov    0x805034,%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	0f 85 e9 fc ff ff    	jne    802700 <alloc_block_FF+0xc0>
  802a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1b:	0f 85 df fc ff ff    	jne    802700 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	83 c0 08             	add    $0x8,%eax
  802a27:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a2a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802a31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a37:	01 d0                	add    %edx,%eax
  802a39:	48                   	dec    %eax
  802a3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a40:	ba 00 00 00 00       	mov    $0x0,%edx
  802a45:	f7 75 d8             	divl   -0x28(%ebp)
  802a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a4b:	29 d0                	sub    %edx,%eax
  802a4d:	c1 e8 0c             	shr    $0xc,%eax
  802a50:	83 ec 0c             	sub    $0xc,%esp
  802a53:	50                   	push   %eax
  802a54:	e8 ce ed ff ff       	call   801827 <sbrk>
  802a59:	83 c4 10             	add    $0x10,%esp
  802a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802a5f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a63:	75 0a                	jne    802a6f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	e9 8b 00 00 00       	jmp    802afa <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a6f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802a76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7c:	01 d0                	add    %edx,%eax
  802a7e:	48                   	dec    %eax
  802a7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802a82:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a85:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8a:	f7 75 cc             	divl   -0x34(%ebp)
  802a8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a90:	29 d0                	sub    %edx,%eax
  802a92:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a98:	01 d0                	add    %edx,%eax
  802a9a:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802a9f:	a1 40 50 80 00       	mov    0x805040,%eax
  802aa4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802aaa:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ab1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ab4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ab7:	01 d0                	add    %edx,%eax
  802ab9:	48                   	dec    %eax
  802aba:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802abd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ac5:	f7 75 c4             	divl   -0x3c(%ebp)
  802ac8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802acb:	29 d0                	sub    %edx,%eax
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	6a 01                	push   $0x1
  802ad2:	50                   	push   %eax
  802ad3:	ff 75 d0             	pushl  -0x30(%ebp)
  802ad6:	e8 36 fb ff ff       	call   802611 <set_block_data>
  802adb:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ade:	83 ec 0c             	sub    $0xc,%esp
  802ae1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ae4:	e8 1b 0a 00 00       	call   803504 <free_block>
  802ae9:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802aec:	83 ec 0c             	sub    $0xc,%esp
  802aef:	ff 75 08             	pushl  0x8(%ebp)
  802af2:	e8 49 fb ff ff       	call   802640 <alloc_block_FF>
  802af7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	83 e0 01             	and    $0x1,%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 03                	je     802b0f <alloc_block_BF+0x13>
  802b0c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b0f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b13:	77 07                	ja     802b1c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b15:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b1c:	a1 24 50 80 00       	mov    0x805024,%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	75 73                	jne    802b98 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	83 c0 10             	add    $0x10,%eax
  802b2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b2e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802b35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3b:	01 d0                	add    %edx,%eax
  802b3d:	48                   	dec    %eax
  802b3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b44:	ba 00 00 00 00       	mov    $0x0,%edx
  802b49:	f7 75 e0             	divl   -0x20(%ebp)
  802b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b4f:	29 d0                	sub    %edx,%eax
  802b51:	c1 e8 0c             	shr    $0xc,%eax
  802b54:	83 ec 0c             	sub    $0xc,%esp
  802b57:	50                   	push   %eax
  802b58:	e8 ca ec ff ff       	call   801827 <sbrk>
  802b5d:	83 c4 10             	add    $0x10,%esp
  802b60:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b63:	83 ec 0c             	sub    $0xc,%esp
  802b66:	6a 00                	push   $0x0
  802b68:	e8 ba ec ff ff       	call   801827 <sbrk>
  802b6d:	83 c4 10             	add    $0x10,%esp
  802b70:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b76:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802b79:	83 ec 08             	sub    $0x8,%esp
  802b7c:	50                   	push   %eax
  802b7d:	ff 75 d8             	pushl  -0x28(%ebp)
  802b80:	e8 9f f8 ff ff       	call   802424 <initialize_dynamic_allocator>
  802b85:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	68 eb 48 80 00       	push   $0x8048eb
  802b90:	e8 f8 de ff ff       	call   800a8d <cprintf>
  802b95:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802b9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ba6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802bad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802bb4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbc:	e9 1d 01 00 00       	jmp    802cde <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802bc7:	83 ec 0c             	sub    $0xc,%esp
  802bca:	ff 75 a8             	pushl  -0x58(%ebp)
  802bcd:	e8 ee f6 ff ff       	call   8022c0 <get_block_size>
  802bd2:	83 c4 10             	add    $0x10,%esp
  802bd5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	83 c0 08             	add    $0x8,%eax
  802bde:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802be1:	0f 87 ef 00 00 00    	ja     802cd6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	83 c0 18             	add    $0x18,%eax
  802bed:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bf0:	77 1d                	ja     802c0f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bf8:	0f 86 d8 00 00 00    	jbe    802cd6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802bfe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802c04:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802c07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c0a:	e9 c7 00 00 00       	jmp    802cd6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	83 c0 08             	add    $0x8,%eax
  802c15:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c18:	0f 85 9d 00 00 00    	jne    802cbb <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	6a 01                	push   $0x1
  802c23:	ff 75 a4             	pushl  -0x5c(%ebp)
  802c26:	ff 75 a8             	pushl  -0x58(%ebp)
  802c29:	e8 e3 f9 ff ff       	call   802611 <set_block_data>
  802c2e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c35:	75 17                	jne    802c4e <alloc_block_BF+0x152>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 8f 48 80 00       	push   $0x80488f
  802c3f:	68 2c 01 00 00       	push   $0x12c
  802c44:	68 ad 48 80 00       	push   $0x8048ad
  802c49:	e8 82 db ff ff       	call   8007d0 <_panic>
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 00                	mov    (%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 10                	je     802c67 <alloc_block_BF+0x16b>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5f:	8b 52 04             	mov    0x4(%edx),%edx
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	eb 0b                	jmp    802c72 <alloc_block_BF+0x176>
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0f                	je     802c8b <alloc_block_BF+0x18f>
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 04             	mov    0x4(%eax),%eax
  802c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c85:	8b 12                	mov    (%edx),%edx
  802c87:	89 10                	mov    %edx,(%eax)
  802c89:	eb 0a                	jmp    802c95 <alloc_block_BF+0x199>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cad:	48                   	dec    %eax
  802cae:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802cb3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cb6:	e9 24 04 00 00       	jmp    8030df <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cc1:	76 13                	jbe    802cd6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802cc3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802cca:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802cd0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802cd6:	a1 34 50 80 00       	mov    0x805034,%eax
  802cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	74 07                	je     802ceb <alloc_block_BF+0x1ef>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	eb 05                	jmp    802cf0 <alloc_block_BF+0x1f4>
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	a3 34 50 80 00       	mov    %eax,0x805034
  802cf5:	a1 34 50 80 00       	mov    0x805034,%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	0f 85 bf fe ff ff    	jne    802bc1 <alloc_block_BF+0xc5>
  802d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d06:	0f 85 b5 fe ff ff    	jne    802bc1 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d10:	0f 84 26 02 00 00    	je     802f3c <alloc_block_BF+0x440>
  802d16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d1a:	0f 85 1c 02 00 00    	jne    802f3c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	2b 45 08             	sub    0x8(%ebp),%eax
  802d26:	83 e8 08             	sub    $0x8,%eax
  802d29:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8d 50 08             	lea    0x8(%eax),%edx
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	01 d0                	add    %edx,%eax
  802d37:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	83 c0 08             	add    $0x8,%eax
  802d40:	83 ec 04             	sub    $0x4,%esp
  802d43:	6a 01                	push   $0x1
  802d45:	50                   	push   %eax
  802d46:	ff 75 f0             	pushl  -0x10(%ebp)
  802d49:	e8 c3 f8 ff ff       	call   802611 <set_block_data>
  802d4e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	75 68                	jne    802dc3 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d5b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d5f:	75 17                	jne    802d78 <alloc_block_BF+0x27c>
  802d61:	83 ec 04             	sub    $0x4,%esp
  802d64:	68 c8 48 80 00       	push   $0x8048c8
  802d69:	68 45 01 00 00       	push   $0x145
  802d6e:	68 ad 48 80 00       	push   $0x8048ad
  802d73:	e8 58 da ff ff       	call   8007d0 <_panic>
  802d78:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802d7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d81:	89 10                	mov    %edx,(%eax)
  802d83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 0d                	je     802d99 <alloc_block_BF+0x29d>
  802d8c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d91:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	eb 08                	jmp    802da1 <alloc_block_BF+0x2a5>
  802d99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d9c:	a3 30 50 80 00       	mov    %eax,0x805030
  802da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db3:	a1 38 50 80 00       	mov    0x805038,%eax
  802db8:	40                   	inc    %eax
  802db9:	a3 38 50 80 00       	mov    %eax,0x805038
  802dbe:	e9 dc 00 00 00       	jmp    802e9f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	75 65                	jne    802e31 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802dcc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802dd0:	75 17                	jne    802de9 <alloc_block_BF+0x2ed>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 fc 48 80 00       	push   $0x8048fc
  802dda:	68 4a 01 00 00       	push   $0x14a
  802ddf:	68 ad 48 80 00       	push   $0x8048ad
  802de4:	e8 e7 d9 ff ff       	call   8007d0 <_panic>
  802de9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802def:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 0c                	je     802e0b <alloc_block_BF+0x30f>
  802dff:	a1 30 50 80 00       	mov    0x805030,%eax
  802e04:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 08                	jmp    802e13 <alloc_block_BF+0x317>
  802e0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e16:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e24:	a1 38 50 80 00       	mov    0x805038,%eax
  802e29:	40                   	inc    %eax
  802e2a:	a3 38 50 80 00       	mov    %eax,0x805038
  802e2f:	eb 6e                	jmp    802e9f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e35:	74 06                	je     802e3d <alloc_block_BF+0x341>
  802e37:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e3b:	75 17                	jne    802e54 <alloc_block_BF+0x358>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 20 49 80 00       	push   $0x804920
  802e45:	68 4f 01 00 00       	push   $0x14f
  802e4a:	68 ad 48 80 00       	push   $0x8048ad
  802e4f:	e8 7c d9 ff ff       	call   8007d0 <_panic>
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 10                	mov    (%eax),%edx
  802e59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	85 c0                	test   %eax,%eax
  802e65:	74 0b                	je     802e72 <alloc_block_BF+0x376>
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e78:	89 10                	mov    %edx,(%eax)
  802e7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	75 08                	jne    802e94 <alloc_block_BF+0x398>
  802e8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802e94:	a1 38 50 80 00       	mov    0x805038,%eax
  802e99:	40                   	inc    %eax
  802e9a:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802e9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea3:	75 17                	jne    802ebc <alloc_block_BF+0x3c0>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 8f 48 80 00       	push   $0x80488f
  802ead:	68 51 01 00 00       	push   $0x151
  802eb2:	68 ad 48 80 00       	push   $0x8048ad
  802eb7:	e8 14 d9 ff ff       	call   8007d0 <_panic>
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 10                	je     802ed5 <alloc_block_BF+0x3d9>
  802ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecd:	8b 52 04             	mov    0x4(%edx),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 0b                	jmp    802ee0 <alloc_block_BF+0x3e4>
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0f                	je     802ef9 <alloc_block_BF+0x3fd>
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef3:	8b 12                	mov    (%edx),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	eb 0a                	jmp    802f03 <alloc_block_BF+0x407>
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1b:	48                   	dec    %eax
  802f1c:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	6a 00                	push   $0x0
  802f26:	ff 75 d0             	pushl  -0x30(%ebp)
  802f29:	ff 75 cc             	pushl  -0x34(%ebp)
  802f2c:	e8 e0 f6 ff ff       	call   802611 <set_block_data>
  802f31:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	e9 a3 01 00 00       	jmp    8030df <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802f3c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802f40:	0f 85 9d 00 00 00    	jne    802fe3 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802f46:	83 ec 04             	sub    $0x4,%esp
  802f49:	6a 01                	push   $0x1
  802f4b:	ff 75 ec             	pushl  -0x14(%ebp)
  802f4e:	ff 75 f0             	pushl  -0x10(%ebp)
  802f51:	e8 bb f6 ff ff       	call   802611 <set_block_data>
  802f56:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5d:	75 17                	jne    802f76 <alloc_block_BF+0x47a>
  802f5f:	83 ec 04             	sub    $0x4,%esp
  802f62:	68 8f 48 80 00       	push   $0x80488f
  802f67:	68 58 01 00 00       	push   $0x158
  802f6c:	68 ad 48 80 00       	push   $0x8048ad
  802f71:	e8 5a d8 ff ff       	call   8007d0 <_panic>
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 10                	je     802f8f <alloc_block_BF+0x493>
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f87:	8b 52 04             	mov    0x4(%edx),%edx
  802f8a:	89 50 04             	mov    %edx,0x4(%eax)
  802f8d:	eb 0b                	jmp    802f9a <alloc_block_BF+0x49e>
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 40 04             	mov    0x4(%eax),%eax
  802f95:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 0f                	je     802fb3 <alloc_block_BF+0x4b7>
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fad:	8b 12                	mov    (%edx),%edx
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	eb 0a                	jmp    802fbd <alloc_block_BF+0x4c1>
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd0:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd5:	48                   	dec    %eax
  802fd6:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	e9 fc 00 00 00       	jmp    8030df <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	83 c0 08             	add    $0x8,%eax
  802fe9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802fec:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ff3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ff6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	48                   	dec    %eax
  802ffc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803002:	ba 00 00 00 00       	mov    $0x0,%edx
  803007:	f7 75 c4             	divl   -0x3c(%ebp)
  80300a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80300d:	29 d0                	sub    %edx,%eax
  80300f:	c1 e8 0c             	shr    $0xc,%eax
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	50                   	push   %eax
  803016:	e8 0c e8 ff ff       	call   801827 <sbrk>
  80301b:	83 c4 10             	add    $0x10,%esp
  80301e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803021:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803025:	75 0a                	jne    803031 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803027:	b8 00 00 00 00       	mov    $0x0,%eax
  80302c:	e9 ae 00 00 00       	jmp    8030df <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803031:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803038:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80303b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80303e:	01 d0                	add    %edx,%eax
  803040:	48                   	dec    %eax
  803041:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803044:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803047:	ba 00 00 00 00       	mov    $0x0,%edx
  80304c:	f7 75 b8             	divl   -0x48(%ebp)
  80304f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803052:	29 d0                	sub    %edx,%eax
  803054:	8d 50 fc             	lea    -0x4(%eax),%edx
  803057:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80305a:	01 d0                	add    %edx,%eax
  80305c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803061:	a1 40 50 80 00       	mov    0x805040,%eax
  803066:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80306c:	83 ec 0c             	sub    $0xc,%esp
  80306f:	68 54 49 80 00       	push   $0x804954
  803074:	e8 14 da ff ff       	call   800a8d <cprintf>
  803079:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80307c:	83 ec 08             	sub    $0x8,%esp
  80307f:	ff 75 bc             	pushl  -0x44(%ebp)
  803082:	68 59 49 80 00       	push   $0x804959
  803087:	e8 01 da ff ff       	call   800a8d <cprintf>
  80308c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80308f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803096:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803099:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80309c:	01 d0                	add    %edx,%eax
  80309e:	48                   	dec    %eax
  80309f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8030a2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8030aa:	f7 75 b0             	divl   -0x50(%ebp)
  8030ad:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8030b0:	29 d0                	sub    %edx,%eax
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	6a 01                	push   $0x1
  8030b7:	50                   	push   %eax
  8030b8:	ff 75 bc             	pushl  -0x44(%ebp)
  8030bb:	e8 51 f5 ff ff       	call   802611 <set_block_data>
  8030c0:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8030c3:	83 ec 0c             	sub    $0xc,%esp
  8030c6:	ff 75 bc             	pushl  -0x44(%ebp)
  8030c9:	e8 36 04 00 00       	call   803504 <free_block>
  8030ce:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8030d1:	83 ec 0c             	sub    $0xc,%esp
  8030d4:	ff 75 08             	pushl  0x8(%ebp)
  8030d7:	e8 20 fa ff ff       	call   802afc <alloc_block_BF>
  8030dc:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
  8030e4:	53                   	push   %ebx
  8030e5:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8030e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8030ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8030f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fa:	74 1e                	je     80311a <merging+0x39>
  8030fc:	ff 75 08             	pushl  0x8(%ebp)
  8030ff:	e8 bc f1 ff ff       	call   8022c0 <get_block_size>
  803104:	83 c4 04             	add    $0x4,%esp
  803107:	89 c2                	mov    %eax,%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	01 d0                	add    %edx,%eax
  80310e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803111:	75 07                	jne    80311a <merging+0x39>
		prev_is_free = 1;
  803113:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80311a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80311e:	74 1e                	je     80313e <merging+0x5d>
  803120:	ff 75 10             	pushl  0x10(%ebp)
  803123:	e8 98 f1 ff ff       	call   8022c0 <get_block_size>
  803128:	83 c4 04             	add    $0x4,%esp
  80312b:	89 c2                	mov    %eax,%edx
  80312d:	8b 45 10             	mov    0x10(%ebp),%eax
  803130:	01 d0                	add    %edx,%eax
  803132:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803135:	75 07                	jne    80313e <merging+0x5d>
		next_is_free = 1;
  803137:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80313e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803142:	0f 84 cc 00 00 00    	je     803214 <merging+0x133>
  803148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314c:	0f 84 c2 00 00 00    	je     803214 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803152:	ff 75 08             	pushl  0x8(%ebp)
  803155:	e8 66 f1 ff ff       	call   8022c0 <get_block_size>
  80315a:	83 c4 04             	add    $0x4,%esp
  80315d:	89 c3                	mov    %eax,%ebx
  80315f:	ff 75 10             	pushl  0x10(%ebp)
  803162:	e8 59 f1 ff ff       	call   8022c0 <get_block_size>
  803167:	83 c4 04             	add    $0x4,%esp
  80316a:	01 c3                	add    %eax,%ebx
  80316c:	ff 75 0c             	pushl  0xc(%ebp)
  80316f:	e8 4c f1 ff ff       	call   8022c0 <get_block_size>
  803174:	83 c4 04             	add    $0x4,%esp
  803177:	01 d8                	add    %ebx,%eax
  803179:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80317c:	6a 00                	push   $0x0
  80317e:	ff 75 ec             	pushl  -0x14(%ebp)
  803181:	ff 75 08             	pushl  0x8(%ebp)
  803184:	e8 88 f4 ff ff       	call   802611 <set_block_data>
  803189:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80318c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803190:	75 17                	jne    8031a9 <merging+0xc8>
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	68 8f 48 80 00       	push   $0x80488f
  80319a:	68 7d 01 00 00       	push   $0x17d
  80319f:	68 ad 48 80 00       	push   $0x8048ad
  8031a4:	e8 27 d6 ff ff       	call   8007d0 <_panic>
  8031a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 10                	je     8031c2 <merging+0xe1>
  8031b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ba:	8b 52 04             	mov    0x4(%edx),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	eb 0b                	jmp    8031cd <merging+0xec>
  8031c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d0:	8b 40 04             	mov    0x4(%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0f                	je     8031e6 <merging+0x105>
  8031d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e0:	8b 12                	mov    (%edx),%edx
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	eb 0a                	jmp    8031f0 <merging+0x10f>
  8031e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803203:	a1 38 50 80 00       	mov    0x805038,%eax
  803208:	48                   	dec    %eax
  803209:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80320e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80320f:	e9 ea 02 00 00       	jmp    8034fe <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803218:	74 3b                	je     803255 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80321a:	83 ec 0c             	sub    $0xc,%esp
  80321d:	ff 75 08             	pushl  0x8(%ebp)
  803220:	e8 9b f0 ff ff       	call   8022c0 <get_block_size>
  803225:	83 c4 10             	add    $0x10,%esp
  803228:	89 c3                	mov    %eax,%ebx
  80322a:	83 ec 0c             	sub    $0xc,%esp
  80322d:	ff 75 10             	pushl  0x10(%ebp)
  803230:	e8 8b f0 ff ff       	call   8022c0 <get_block_size>
  803235:	83 c4 10             	add    $0x10,%esp
  803238:	01 d8                	add    %ebx,%eax
  80323a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80323d:	83 ec 04             	sub    $0x4,%esp
  803240:	6a 00                	push   $0x0
  803242:	ff 75 e8             	pushl  -0x18(%ebp)
  803245:	ff 75 08             	pushl  0x8(%ebp)
  803248:	e8 c4 f3 ff ff       	call   802611 <set_block_data>
  80324d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803250:	e9 a9 02 00 00       	jmp    8034fe <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803255:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803259:	0f 84 2d 01 00 00    	je     80338c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80325f:	83 ec 0c             	sub    $0xc,%esp
  803262:	ff 75 10             	pushl  0x10(%ebp)
  803265:	e8 56 f0 ff ff       	call   8022c0 <get_block_size>
  80326a:	83 c4 10             	add    $0x10,%esp
  80326d:	89 c3                	mov    %eax,%ebx
  80326f:	83 ec 0c             	sub    $0xc,%esp
  803272:	ff 75 0c             	pushl  0xc(%ebp)
  803275:	e8 46 f0 ff ff       	call   8022c0 <get_block_size>
  80327a:	83 c4 10             	add    $0x10,%esp
  80327d:	01 d8                	add    %ebx,%eax
  80327f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	6a 00                	push   $0x0
  803287:	ff 75 e4             	pushl  -0x1c(%ebp)
  80328a:	ff 75 10             	pushl  0x10(%ebp)
  80328d:	e8 7f f3 ff ff       	call   802611 <set_block_data>
  803292:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803295:	8b 45 10             	mov    0x10(%ebp),%eax
  803298:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80329b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329f:	74 06                	je     8032a7 <merging+0x1c6>
  8032a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032a5:	75 17                	jne    8032be <merging+0x1dd>
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	68 68 49 80 00       	push   $0x804968
  8032af:	68 8d 01 00 00       	push   $0x18d
  8032b4:	68 ad 48 80 00       	push   $0x8048ad
  8032b9:	e8 12 d5 ff ff       	call   8007d0 <_panic>
  8032be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c1:	8b 50 04             	mov    0x4(%eax),%edx
  8032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032d0:	89 10                	mov    %edx,(%eax)
  8032d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d5:	8b 40 04             	mov    0x4(%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0d                	je     8032e9 <merging+0x208>
  8032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	eb 08                	jmp    8032f1 <merging+0x210>
  8032e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ff:	40                   	inc    %eax
  803300:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803309:	75 17                	jne    803322 <merging+0x241>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 8f 48 80 00       	push   $0x80488f
  803313:	68 8e 01 00 00       	push   $0x18e
  803318:	68 ad 48 80 00       	push   $0x8048ad
  80331d:	e8 ae d4 ff ff       	call   8007d0 <_panic>
  803322:	8b 45 0c             	mov    0xc(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 10                	je     80333b <merging+0x25a>
  80332b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	8b 55 0c             	mov    0xc(%ebp),%edx
  803333:	8b 52 04             	mov    0x4(%edx),%edx
  803336:	89 50 04             	mov    %edx,0x4(%eax)
  803339:	eb 0b                	jmp    803346 <merging+0x265>
  80333b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333e:	8b 40 04             	mov    0x4(%eax),%eax
  803341:	a3 30 50 80 00       	mov    %eax,0x805030
  803346:	8b 45 0c             	mov    0xc(%ebp),%eax
  803349:	8b 40 04             	mov    0x4(%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 0f                	je     80335f <merging+0x27e>
  803350:	8b 45 0c             	mov    0xc(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	8b 55 0c             	mov    0xc(%ebp),%edx
  803359:	8b 12                	mov    (%edx),%edx
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	eb 0a                	jmp    803369 <merging+0x288>
  80335f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803372:	8b 45 0c             	mov    0xc(%ebp),%eax
  803375:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337c:	a1 38 50 80 00       	mov    0x805038,%eax
  803381:	48                   	dec    %eax
  803382:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803387:	e9 72 01 00 00       	jmp    8034fe <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80338c:	8b 45 10             	mov    0x10(%ebp),%eax
  80338f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803396:	74 79                	je     803411 <merging+0x330>
  803398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80339c:	74 73                	je     803411 <merging+0x330>
  80339e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a2:	74 06                	je     8033aa <merging+0x2c9>
  8033a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033a8:	75 17                	jne    8033c1 <merging+0x2e0>
  8033aa:	83 ec 04             	sub    $0x4,%esp
  8033ad:	68 20 49 80 00       	push   $0x804920
  8033b2:	68 94 01 00 00       	push   $0x194
  8033b7:	68 ad 48 80 00       	push   $0x8048ad
  8033bc:	e8 0f d4 ff ff       	call   8007d0 <_panic>
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	8b 10                	mov    (%eax),%edx
  8033c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	74 0b                	je     8033df <merging+0x2fe>
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033e5:	89 10                	mov    %edx,(%eax)
  8033e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ed:	89 50 04             	mov    %edx,0x4(%eax)
  8033f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	75 08                	jne    803401 <merging+0x320>
  8033f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803401:	a1 38 50 80 00       	mov    0x805038,%eax
  803406:	40                   	inc    %eax
  803407:	a3 38 50 80 00       	mov    %eax,0x805038
  80340c:	e9 ce 00 00 00       	jmp    8034df <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803411:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803415:	74 65                	je     80347c <merging+0x39b>
  803417:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80341b:	75 17                	jne    803434 <merging+0x353>
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	68 fc 48 80 00       	push   $0x8048fc
  803425:	68 95 01 00 00       	push   $0x195
  80342a:	68 ad 48 80 00       	push   $0x8048ad
  80342f:	e8 9c d3 ff ff       	call   8007d0 <_panic>
  803434:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80343a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803443:	8b 40 04             	mov    0x4(%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0c                	je     803456 <merging+0x375>
  80344a:	a1 30 50 80 00       	mov    0x805030,%eax
  80344f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803452:	89 10                	mov    %edx,(%eax)
  803454:	eb 08                	jmp    80345e <merging+0x37d>
  803456:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803459:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80345e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803461:	a3 30 50 80 00       	mov    %eax,0x805030
  803466:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	a1 38 50 80 00       	mov    0x805038,%eax
  803474:	40                   	inc    %eax
  803475:	a3 38 50 80 00       	mov    %eax,0x805038
  80347a:	eb 63                	jmp    8034df <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80347c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803480:	75 17                	jne    803499 <merging+0x3b8>
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	68 c8 48 80 00       	push   $0x8048c8
  80348a:	68 98 01 00 00       	push   $0x198
  80348f:	68 ad 48 80 00       	push   $0x8048ad
  803494:	e8 37 d3 ff ff       	call   8007d0 <_panic>
  803499:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80349f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a2:	89 10                	mov    %edx,(%eax)
  8034a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a7:	8b 00                	mov    (%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0d                	je     8034ba <merging+0x3d9>
  8034ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034b5:	89 50 04             	mov    %edx,0x4(%eax)
  8034b8:	eb 08                	jmp    8034c2 <merging+0x3e1>
  8034ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d9:	40                   	inc    %eax
  8034da:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8034df:	83 ec 0c             	sub    $0xc,%esp
  8034e2:	ff 75 10             	pushl  0x10(%ebp)
  8034e5:	e8 d6 ed ff ff       	call   8022c0 <get_block_size>
  8034ea:	83 c4 10             	add    $0x10,%esp
  8034ed:	83 ec 04             	sub    $0x4,%esp
  8034f0:	6a 00                	push   $0x0
  8034f2:	50                   	push   %eax
  8034f3:	ff 75 10             	pushl  0x10(%ebp)
  8034f6:	e8 16 f1 ff ff       	call   802611 <set_block_data>
  8034fb:	83 c4 10             	add    $0x10,%esp
	}
}
  8034fe:	90                   	nop
  8034ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803502:	c9                   	leave  
  803503:	c3                   	ret    

00803504 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803504:	55                   	push   %ebp
  803505:	89 e5                	mov    %esp,%ebp
  803507:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80350a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803512:	a1 30 50 80 00       	mov    0x805030,%eax
  803517:	3b 45 08             	cmp    0x8(%ebp),%eax
  80351a:	73 1b                	jae    803537 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80351c:	a1 30 50 80 00       	mov    0x805030,%eax
  803521:	83 ec 04             	sub    $0x4,%esp
  803524:	ff 75 08             	pushl  0x8(%ebp)
  803527:	6a 00                	push   $0x0
  803529:	50                   	push   %eax
  80352a:	e8 b2 fb ff ff       	call   8030e1 <merging>
  80352f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803532:	e9 8b 00 00 00       	jmp    8035c2 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803537:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80353c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80353f:	76 18                	jbe    803559 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803541:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803546:	83 ec 04             	sub    $0x4,%esp
  803549:	ff 75 08             	pushl  0x8(%ebp)
  80354c:	50                   	push   %eax
  80354d:	6a 00                	push   $0x0
  80354f:	e8 8d fb ff ff       	call   8030e1 <merging>
  803554:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803557:	eb 69                	jmp    8035c2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803559:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80355e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803561:	eb 39                	jmp    80359c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	3b 45 08             	cmp    0x8(%ebp),%eax
  803569:	73 29                	jae    803594 <free_block+0x90>
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	3b 45 08             	cmp    0x8(%ebp),%eax
  803573:	76 1f                	jbe    803594 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80357d:	83 ec 04             	sub    $0x4,%esp
  803580:	ff 75 08             	pushl  0x8(%ebp)
  803583:	ff 75 f0             	pushl  -0x10(%ebp)
  803586:	ff 75 f4             	pushl  -0xc(%ebp)
  803589:	e8 53 fb ff ff       	call   8030e1 <merging>
  80358e:	83 c4 10             	add    $0x10,%esp
			break;
  803591:	90                   	nop
		}
	}
}
  803592:	eb 2e                	jmp    8035c2 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803594:	a1 34 50 80 00       	mov    0x805034,%eax
  803599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	74 07                	je     8035a9 <free_block+0xa5>
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	eb 05                	jmp    8035ae <free_block+0xaa>
  8035a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	75 a7                	jne    803563 <free_block+0x5f>
  8035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c0:	75 a1                	jne    803563 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035c2:	90                   	nop
  8035c3:	c9                   	leave  
  8035c4:	c3                   	ret    

008035c5 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8035c5:	55                   	push   %ebp
  8035c6:	89 e5                	mov    %esp,%ebp
  8035c8:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8035cb:	ff 75 08             	pushl  0x8(%ebp)
  8035ce:	e8 ed ec ff ff       	call   8022c0 <get_block_size>
  8035d3:	83 c4 04             	add    $0x4,%esp
  8035d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8035d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8035e0:	eb 17                	jmp    8035f9 <copy_data+0x34>
  8035e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8035e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e8:	01 c2                	add    %eax,%edx
  8035ea:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	01 c8                	add    %ecx,%eax
  8035f2:	8a 00                	mov    (%eax),%al
  8035f4:	88 02                	mov    %al,(%edx)
  8035f6:	ff 45 fc             	incl   -0x4(%ebp)
  8035f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8035ff:	72 e1                	jb     8035e2 <copy_data+0x1d>
}
  803601:	90                   	nop
  803602:	c9                   	leave  
  803603:	c3                   	ret    

00803604 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803604:	55                   	push   %ebp
  803605:	89 e5                	mov    %esp,%ebp
  803607:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80360a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360e:	75 23                	jne    803633 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803610:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803614:	74 13                	je     803629 <realloc_block_FF+0x25>
  803616:	83 ec 0c             	sub    $0xc,%esp
  803619:	ff 75 0c             	pushl  0xc(%ebp)
  80361c:	e8 1f f0 ff ff       	call   802640 <alloc_block_FF>
  803621:	83 c4 10             	add    $0x10,%esp
  803624:	e9 f4 06 00 00       	jmp    803d1d <realloc_block_FF+0x719>
		return NULL;
  803629:	b8 00 00 00 00       	mov    $0x0,%eax
  80362e:	e9 ea 06 00 00       	jmp    803d1d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803637:	75 18                	jne    803651 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803639:	83 ec 0c             	sub    $0xc,%esp
  80363c:	ff 75 08             	pushl  0x8(%ebp)
  80363f:	e8 c0 fe ff ff       	call   803504 <free_block>
  803644:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803647:	b8 00 00 00 00       	mov    $0x0,%eax
  80364c:	e9 cc 06 00 00       	jmp    803d1d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803651:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803655:	77 07                	ja     80365e <realloc_block_FF+0x5a>
  803657:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80365e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803661:	83 e0 01             	and    $0x1,%eax
  803664:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366a:	83 c0 08             	add    $0x8,%eax
  80366d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	ff 75 08             	pushl  0x8(%ebp)
  803676:	e8 45 ec ff ff       	call   8022c0 <get_block_size>
  80367b:	83 c4 10             	add    $0x10,%esp
  80367e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803684:	83 e8 08             	sub    $0x8,%eax
  803687:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	83 e8 04             	sub    $0x4,%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	83 e0 fe             	and    $0xfffffffe,%eax
  803695:	89 c2                	mov    %eax,%edx
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	01 d0                	add    %edx,%eax
  80369c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80369f:	83 ec 0c             	sub    $0xc,%esp
  8036a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036a5:	e8 16 ec ff ff       	call   8022c0 <get_block_size>
  8036aa:	83 c4 10             	add    $0x10,%esp
  8036ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b3:	83 e8 08             	sub    $0x8,%eax
  8036b6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036bf:	75 08                	jne    8036c9 <realloc_block_FF+0xc5>
	{
		 return va;
  8036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c4:	e9 54 06 00 00       	jmp    803d1d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8036c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036cf:	0f 83 e5 03 00 00    	jae    803aba <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8036d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036db:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8036de:	83 ec 0c             	sub    $0xc,%esp
  8036e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036e4:	e8 f0 eb ff ff       	call   8022d9 <is_free_block>
  8036e9:	83 c4 10             	add    $0x10,%esp
  8036ec:	84 c0                	test   %al,%al
  8036ee:	0f 84 3b 01 00 00    	je     80382f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8036f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036fa:	01 d0                	add    %edx,%eax
  8036fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	6a 01                	push   $0x1
  803704:	ff 75 f0             	pushl  -0x10(%ebp)
  803707:	ff 75 08             	pushl  0x8(%ebp)
  80370a:	e8 02 ef ff ff       	call   802611 <set_block_data>
  80370f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	83 e8 04             	sub    $0x4,%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	83 e0 fe             	and    $0xfffffffe,%eax
  80371d:	89 c2                	mov    %eax,%edx
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	01 d0                	add    %edx,%eax
  803724:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	6a 00                	push   $0x0
  80372c:	ff 75 cc             	pushl  -0x34(%ebp)
  80372f:	ff 75 c8             	pushl  -0x38(%ebp)
  803732:	e8 da ee ff ff       	call   802611 <set_block_data>
  803737:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80373a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80373e:	74 06                	je     803746 <realloc_block_FF+0x142>
  803740:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803744:	75 17                	jne    80375d <realloc_block_FF+0x159>
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	68 20 49 80 00       	push   $0x804920
  80374e:	68 f6 01 00 00       	push   $0x1f6
  803753:	68 ad 48 80 00       	push   $0x8048ad
  803758:	e8 73 d0 ff ff       	call   8007d0 <_panic>
  80375d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803760:	8b 10                	mov    (%eax),%edx
  803762:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803765:	89 10                	mov    %edx,(%eax)
  803767:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	85 c0                	test   %eax,%eax
  80376e:	74 0b                	je     80377b <realloc_block_FF+0x177>
  803770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803778:	89 50 04             	mov    %edx,0x4(%eax)
  80377b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803786:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803789:	89 50 04             	mov    %edx,0x4(%eax)
  80378c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80378f:	8b 00                	mov    (%eax),%eax
  803791:	85 c0                	test   %eax,%eax
  803793:	75 08                	jne    80379d <realloc_block_FF+0x199>
  803795:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803798:	a3 30 50 80 00       	mov    %eax,0x805030
  80379d:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a2:	40                   	inc    %eax
  8037a3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ac:	75 17                	jne    8037c5 <realloc_block_FF+0x1c1>
  8037ae:	83 ec 04             	sub    $0x4,%esp
  8037b1:	68 8f 48 80 00       	push   $0x80488f
  8037b6:	68 f7 01 00 00       	push   $0x1f7
  8037bb:	68 ad 48 80 00       	push   $0x8048ad
  8037c0:	e8 0b d0 ff ff       	call   8007d0 <_panic>
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	74 10                	je     8037de <realloc_block_FF+0x1da>
  8037ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d6:	8b 52 04             	mov    0x4(%edx),%edx
  8037d9:	89 50 04             	mov    %edx,0x4(%eax)
  8037dc:	eb 0b                	jmp    8037e9 <realloc_block_FF+0x1e5>
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ec:	8b 40 04             	mov    0x4(%eax),%eax
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	74 0f                	je     803802 <realloc_block_FF+0x1fe>
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 40 04             	mov    0x4(%eax),%eax
  8037f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037fc:	8b 12                	mov    (%edx),%edx
  8037fe:	89 10                	mov    %edx,(%eax)
  803800:	eb 0a                	jmp    80380c <realloc_block_FF+0x208>
  803802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381f:	a1 38 50 80 00       	mov    0x805038,%eax
  803824:	48                   	dec    %eax
  803825:	a3 38 50 80 00       	mov    %eax,0x805038
  80382a:	e9 83 02 00 00       	jmp    803ab2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80382f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803833:	0f 86 69 02 00 00    	jbe    803aa2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803839:	83 ec 04             	sub    $0x4,%esp
  80383c:	6a 01                	push   $0x1
  80383e:	ff 75 f0             	pushl  -0x10(%ebp)
  803841:	ff 75 08             	pushl  0x8(%ebp)
  803844:	e8 c8 ed ff ff       	call   802611 <set_block_data>
  803849:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80384c:	8b 45 08             	mov    0x8(%ebp),%eax
  80384f:	83 e8 04             	sub    $0x4,%eax
  803852:	8b 00                	mov    (%eax),%eax
  803854:	83 e0 fe             	and    $0xfffffffe,%eax
  803857:	89 c2                	mov    %eax,%edx
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	01 d0                	add    %edx,%eax
  80385e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803861:	a1 38 50 80 00       	mov    0x805038,%eax
  803866:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803869:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80386d:	75 68                	jne    8038d7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80386f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803873:	75 17                	jne    80388c <realloc_block_FF+0x288>
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	68 c8 48 80 00       	push   $0x8048c8
  80387d:	68 06 02 00 00       	push   $0x206
  803882:	68 ad 48 80 00       	push   $0x8048ad
  803887:	e8 44 cf ff ff       	call   8007d0 <_panic>
  80388c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803892:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803895:	89 10                	mov    %edx,(%eax)
  803897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80389a:	8b 00                	mov    (%eax),%eax
  80389c:	85 c0                	test   %eax,%eax
  80389e:	74 0d                	je     8038ad <realloc_block_FF+0x2a9>
  8038a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038a8:	89 50 04             	mov    %edx,0x4(%eax)
  8038ab:	eb 08                	jmp    8038b5 <realloc_block_FF+0x2b1>
  8038ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cc:	40                   	inc    %eax
  8038cd:	a3 38 50 80 00       	mov    %eax,0x805038
  8038d2:	e9 b0 01 00 00       	jmp    803a87 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8038d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038df:	76 68                	jbe    803949 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8038e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038e5:	75 17                	jne    8038fe <realloc_block_FF+0x2fa>
  8038e7:	83 ec 04             	sub    $0x4,%esp
  8038ea:	68 c8 48 80 00       	push   $0x8048c8
  8038ef:	68 0b 02 00 00       	push   $0x20b
  8038f4:	68 ad 48 80 00       	push   $0x8048ad
  8038f9:	e8 d2 ce ff ff       	call   8007d0 <_panic>
  8038fe:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803907:	89 10                	mov    %edx,(%eax)
  803909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	85 c0                	test   %eax,%eax
  803910:	74 0d                	je     80391f <realloc_block_FF+0x31b>
  803912:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803917:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80391a:	89 50 04             	mov    %edx,0x4(%eax)
  80391d:	eb 08                	jmp    803927 <realloc_block_FF+0x323>
  80391f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803922:	a3 30 50 80 00       	mov    %eax,0x805030
  803927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80392f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803939:	a1 38 50 80 00       	mov    0x805038,%eax
  80393e:	40                   	inc    %eax
  80393f:	a3 38 50 80 00       	mov    %eax,0x805038
  803944:	e9 3e 01 00 00       	jmp    803a87 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803949:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80394e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803951:	73 68                	jae    8039bb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803953:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803957:	75 17                	jne    803970 <realloc_block_FF+0x36c>
  803959:	83 ec 04             	sub    $0x4,%esp
  80395c:	68 fc 48 80 00       	push   $0x8048fc
  803961:	68 10 02 00 00       	push   $0x210
  803966:	68 ad 48 80 00       	push   $0x8048ad
  80396b:	e8 60 ce ff ff       	call   8007d0 <_panic>
  803970:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803976:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803979:	89 50 04             	mov    %edx,0x4(%eax)
  80397c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80397f:	8b 40 04             	mov    0x4(%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	74 0c                	je     803992 <realloc_block_FF+0x38e>
  803986:	a1 30 50 80 00       	mov    0x805030,%eax
  80398b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80398e:	89 10                	mov    %edx,(%eax)
  803990:	eb 08                	jmp    80399a <realloc_block_FF+0x396>
  803992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803995:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80399a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80399d:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b0:	40                   	inc    %eax
  8039b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8039b6:	e9 cc 00 00 00       	jmp    803a87 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8039bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8039c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ca:	e9 8a 00 00 00       	jmp    803a59 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039d5:	73 7a                	jae    803a51 <realloc_block_FF+0x44d>
  8039d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039da:	8b 00                	mov    (%eax),%eax
  8039dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8039df:	73 70                	jae    803a51 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8039e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039e5:	74 06                	je     8039ed <realloc_block_FF+0x3e9>
  8039e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039eb:	75 17                	jne    803a04 <realloc_block_FF+0x400>
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	68 20 49 80 00       	push   $0x804920
  8039f5:	68 1a 02 00 00       	push   $0x21a
  8039fa:	68 ad 48 80 00       	push   $0x8048ad
  8039ff:	e8 cc cd ff ff       	call   8007d0 <_panic>
  803a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a07:	8b 10                	mov    (%eax),%edx
  803a09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0c:	89 10                	mov    %edx,(%eax)
  803a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a11:	8b 00                	mov    (%eax),%eax
  803a13:	85 c0                	test   %eax,%eax
  803a15:	74 0b                	je     803a22 <realloc_block_FF+0x41e>
  803a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a1f:	89 50 04             	mov    %edx,0x4(%eax)
  803a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a25:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a28:	89 10                	mov    %edx,(%eax)
  803a2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a30:	89 50 04             	mov    %edx,0x4(%eax)
  803a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a36:	8b 00                	mov    (%eax),%eax
  803a38:	85 c0                	test   %eax,%eax
  803a3a:	75 08                	jne    803a44 <realloc_block_FF+0x440>
  803a3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a3f:	a3 30 50 80 00       	mov    %eax,0x805030
  803a44:	a1 38 50 80 00       	mov    0x805038,%eax
  803a49:	40                   	inc    %eax
  803a4a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803a4f:	eb 36                	jmp    803a87 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803a51:	a1 34 50 80 00       	mov    0x805034,%eax
  803a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5d:	74 07                	je     803a66 <realloc_block_FF+0x462>
  803a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a62:	8b 00                	mov    (%eax),%eax
  803a64:	eb 05                	jmp    803a6b <realloc_block_FF+0x467>
  803a66:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6b:	a3 34 50 80 00       	mov    %eax,0x805034
  803a70:	a1 34 50 80 00       	mov    0x805034,%eax
  803a75:	85 c0                	test   %eax,%eax
  803a77:	0f 85 52 ff ff ff    	jne    8039cf <realloc_block_FF+0x3cb>
  803a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a81:	0f 85 48 ff ff ff    	jne    8039cf <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	6a 00                	push   $0x0
  803a8c:	ff 75 d8             	pushl  -0x28(%ebp)
  803a8f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a92:	e8 7a eb ff ff       	call   802611 <set_block_data>
  803a97:	83 c4 10             	add    $0x10,%esp
				return va;
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	e9 7b 02 00 00       	jmp    803d1d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803aa2:	83 ec 0c             	sub    $0xc,%esp
  803aa5:	68 9d 49 80 00       	push   $0x80499d
  803aaa:	e8 de cf ff ff       	call   800a8d <cprintf>
  803aaf:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab5:	e9 63 02 00 00       	jmp    803d1d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  803abd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ac0:	0f 86 4d 02 00 00    	jbe    803d13 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ac6:	83 ec 0c             	sub    $0xc,%esp
  803ac9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803acc:	e8 08 e8 ff ff       	call   8022d9 <is_free_block>
  803ad1:	83 c4 10             	add    $0x10,%esp
  803ad4:	84 c0                	test   %al,%al
  803ad6:	0f 84 37 02 00 00    	je     803d13 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803adf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ae2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803ae5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ae8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803aeb:	76 38                	jbe    803b25 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803aed:	83 ec 0c             	sub    $0xc,%esp
  803af0:	ff 75 08             	pushl  0x8(%ebp)
  803af3:	e8 0c fa ff ff       	call   803504 <free_block>
  803af8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803afb:	83 ec 0c             	sub    $0xc,%esp
  803afe:	ff 75 0c             	pushl  0xc(%ebp)
  803b01:	e8 3a eb ff ff       	call   802640 <alloc_block_FF>
  803b06:	83 c4 10             	add    $0x10,%esp
  803b09:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803b0c:	83 ec 08             	sub    $0x8,%esp
  803b0f:	ff 75 c0             	pushl  -0x40(%ebp)
  803b12:	ff 75 08             	pushl  0x8(%ebp)
  803b15:	e8 ab fa ff ff       	call   8035c5 <copy_data>
  803b1a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803b1d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803b20:	e9 f8 01 00 00       	jmp    803d1d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b28:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803b2b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803b2e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803b32:	0f 87 a0 00 00 00    	ja     803bd8 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803b38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b3c:	75 17                	jne    803b55 <realloc_block_FF+0x551>
  803b3e:	83 ec 04             	sub    $0x4,%esp
  803b41:	68 8f 48 80 00       	push   $0x80488f
  803b46:	68 38 02 00 00       	push   $0x238
  803b4b:	68 ad 48 80 00       	push   $0x8048ad
  803b50:	e8 7b cc ff ff       	call   8007d0 <_panic>
  803b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b58:	8b 00                	mov    (%eax),%eax
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	74 10                	je     803b6e <realloc_block_FF+0x56a>
  803b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b66:	8b 52 04             	mov    0x4(%edx),%edx
  803b69:	89 50 04             	mov    %edx,0x4(%eax)
  803b6c:	eb 0b                	jmp    803b79 <realloc_block_FF+0x575>
  803b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b71:	8b 40 04             	mov    0x4(%eax),%eax
  803b74:	a3 30 50 80 00       	mov    %eax,0x805030
  803b79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7c:	8b 40 04             	mov    0x4(%eax),%eax
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	74 0f                	je     803b92 <realloc_block_FF+0x58e>
  803b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b86:	8b 40 04             	mov    0x4(%eax),%eax
  803b89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b8c:	8b 12                	mov    (%edx),%edx
  803b8e:	89 10                	mov    %edx,(%eax)
  803b90:	eb 0a                	jmp    803b9c <realloc_block_FF+0x598>
  803b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b95:	8b 00                	mov    (%eax),%eax
  803b97:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803baf:	a1 38 50 80 00       	mov    0x805038,%eax
  803bb4:	48                   	dec    %eax
  803bb5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803bba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc0:	01 d0                	add    %edx,%eax
  803bc2:	83 ec 04             	sub    $0x4,%esp
  803bc5:	6a 01                	push   $0x1
  803bc7:	50                   	push   %eax
  803bc8:	ff 75 08             	pushl  0x8(%ebp)
  803bcb:	e8 41 ea ff ff       	call   802611 <set_block_data>
  803bd0:	83 c4 10             	add    $0x10,%esp
  803bd3:	e9 36 01 00 00       	jmp    803d0e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803bd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bdb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803bde:	01 d0                	add    %edx,%eax
  803be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803be3:	83 ec 04             	sub    $0x4,%esp
  803be6:	6a 01                	push   $0x1
  803be8:	ff 75 f0             	pushl  -0x10(%ebp)
  803beb:	ff 75 08             	pushl  0x8(%ebp)
  803bee:	e8 1e ea ff ff       	call   802611 <set_block_data>
  803bf3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf9:	83 e8 04             	sub    $0x4,%eax
  803bfc:	8b 00                	mov    (%eax),%eax
  803bfe:	83 e0 fe             	and    $0xfffffffe,%eax
  803c01:	89 c2                	mov    %eax,%edx
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	01 d0                	add    %edx,%eax
  803c08:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c0f:	74 06                	je     803c17 <realloc_block_FF+0x613>
  803c11:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803c15:	75 17                	jne    803c2e <realloc_block_FF+0x62a>
  803c17:	83 ec 04             	sub    $0x4,%esp
  803c1a:	68 20 49 80 00       	push   $0x804920
  803c1f:	68 44 02 00 00       	push   $0x244
  803c24:	68 ad 48 80 00       	push   $0x8048ad
  803c29:	e8 a2 cb ff ff       	call   8007d0 <_panic>
  803c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c31:	8b 10                	mov    (%eax),%edx
  803c33:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c36:	89 10                	mov    %edx,(%eax)
  803c38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c3b:	8b 00                	mov    (%eax),%eax
  803c3d:	85 c0                	test   %eax,%eax
  803c3f:	74 0b                	je     803c4c <realloc_block_FF+0x648>
  803c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c44:	8b 00                	mov    (%eax),%eax
  803c46:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c49:	89 50 04             	mov    %edx,0x4(%eax)
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803c52:	89 10                	mov    %edx,(%eax)
  803c54:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c5a:	89 50 04             	mov    %edx,0x4(%eax)
  803c5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c60:	8b 00                	mov    (%eax),%eax
  803c62:	85 c0                	test   %eax,%eax
  803c64:	75 08                	jne    803c6e <realloc_block_FF+0x66a>
  803c66:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803c69:	a3 30 50 80 00       	mov    %eax,0x805030
  803c6e:	a1 38 50 80 00       	mov    0x805038,%eax
  803c73:	40                   	inc    %eax
  803c74:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c7d:	75 17                	jne    803c96 <realloc_block_FF+0x692>
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	68 8f 48 80 00       	push   $0x80488f
  803c87:	68 45 02 00 00       	push   $0x245
  803c8c:	68 ad 48 80 00       	push   $0x8048ad
  803c91:	e8 3a cb ff ff       	call   8007d0 <_panic>
  803c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	85 c0                	test   %eax,%eax
  803c9d:	74 10                	je     803caf <realloc_block_FF+0x6ab>
  803c9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca2:	8b 00                	mov    (%eax),%eax
  803ca4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ca7:	8b 52 04             	mov    0x4(%edx),%edx
  803caa:	89 50 04             	mov    %edx,0x4(%eax)
  803cad:	eb 0b                	jmp    803cba <realloc_block_FF+0x6b6>
  803caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb2:	8b 40 04             	mov    0x4(%eax),%eax
  803cb5:	a3 30 50 80 00       	mov    %eax,0x805030
  803cba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbd:	8b 40 04             	mov    0x4(%eax),%eax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	74 0f                	je     803cd3 <realloc_block_FF+0x6cf>
  803cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc7:	8b 40 04             	mov    0x4(%eax),%eax
  803cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ccd:	8b 12                	mov    (%edx),%edx
  803ccf:	89 10                	mov    %edx,(%eax)
  803cd1:	eb 0a                	jmp    803cdd <realloc_block_FF+0x6d9>
  803cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd6:	8b 00                	mov    (%eax),%eax
  803cd8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf0:	a1 38 50 80 00       	mov    0x805038,%eax
  803cf5:	48                   	dec    %eax
  803cf6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803cfb:	83 ec 04             	sub    $0x4,%esp
  803cfe:	6a 00                	push   $0x0
  803d00:	ff 75 bc             	pushl  -0x44(%ebp)
  803d03:	ff 75 b8             	pushl  -0x48(%ebp)
  803d06:	e8 06 e9 ff ff       	call   802611 <set_block_data>
  803d0b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d11:	eb 0a                	jmp    803d1d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803d13:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803d1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803d1d:	c9                   	leave  
  803d1e:	c3                   	ret    

00803d1f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803d1f:	55                   	push   %ebp
  803d20:	89 e5                	mov    %esp,%ebp
  803d22:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803d25:	83 ec 04             	sub    $0x4,%esp
  803d28:	68 a4 49 80 00       	push   $0x8049a4
  803d2d:	68 58 02 00 00       	push   $0x258
  803d32:	68 ad 48 80 00       	push   $0x8048ad
  803d37:	e8 94 ca ff ff       	call   8007d0 <_panic>

00803d3c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803d3c:	55                   	push   %ebp
  803d3d:	89 e5                	mov    %esp,%ebp
  803d3f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803d42:	83 ec 04             	sub    $0x4,%esp
  803d45:	68 cc 49 80 00       	push   $0x8049cc
  803d4a:	68 61 02 00 00       	push   $0x261
  803d4f:	68 ad 48 80 00       	push   $0x8048ad
  803d54:	e8 77 ca ff ff       	call   8007d0 <_panic>

00803d59 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803d59:	55                   	push   %ebp
  803d5a:	89 e5                	mov    %esp,%ebp
  803d5c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803d5f:	83 ec 04             	sub    $0x4,%esp
  803d62:	68 f4 49 80 00       	push   $0x8049f4
  803d67:	6a 09                	push   $0x9
  803d69:	68 1c 4a 80 00       	push   $0x804a1c
  803d6e:	e8 5d ca ff ff       	call   8007d0 <_panic>

00803d73 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803d73:	55                   	push   %ebp
  803d74:	89 e5                	mov    %esp,%ebp
  803d76:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803d79:	83 ec 04             	sub    $0x4,%esp
  803d7c:	68 2c 4a 80 00       	push   $0x804a2c
  803d81:	6a 10                	push   $0x10
  803d83:	68 1c 4a 80 00       	push   $0x804a1c
  803d88:	e8 43 ca ff ff       	call   8007d0 <_panic>

00803d8d <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803d8d:	55                   	push   %ebp
  803d8e:	89 e5                	mov    %esp,%ebp
  803d90:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803d93:	83 ec 04             	sub    $0x4,%esp
  803d96:	68 54 4a 80 00       	push   $0x804a54
  803d9b:	6a 18                	push   $0x18
  803d9d:	68 1c 4a 80 00       	push   $0x804a1c
  803da2:	e8 29 ca ff ff       	call   8007d0 <_panic>

00803da7 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803da7:	55                   	push   %ebp
  803da8:	89 e5                	mov    %esp,%ebp
  803daa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803dad:	83 ec 04             	sub    $0x4,%esp
  803db0:	68 7c 4a 80 00       	push   $0x804a7c
  803db5:	6a 20                	push   $0x20
  803db7:	68 1c 4a 80 00       	push   $0x804a1c
  803dbc:	e8 0f ca ff ff       	call   8007d0 <_panic>

00803dc1 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803dc1:	55                   	push   %ebp
  803dc2:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc7:	8b 40 10             	mov    0x10(%eax),%eax
}
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    

00803dcc <__udivdi3>:
  803dcc:	55                   	push   %ebp
  803dcd:	57                   	push   %edi
  803dce:	56                   	push   %esi
  803dcf:	53                   	push   %ebx
  803dd0:	83 ec 1c             	sub    $0x1c,%esp
  803dd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803dd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ddb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ddf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803de3:	89 ca                	mov    %ecx,%edx
  803de5:	89 f8                	mov    %edi,%eax
  803de7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803deb:	85 f6                	test   %esi,%esi
  803ded:	75 2d                	jne    803e1c <__udivdi3+0x50>
  803def:	39 cf                	cmp    %ecx,%edi
  803df1:	77 65                	ja     803e58 <__udivdi3+0x8c>
  803df3:	89 fd                	mov    %edi,%ebp
  803df5:	85 ff                	test   %edi,%edi
  803df7:	75 0b                	jne    803e04 <__udivdi3+0x38>
  803df9:	b8 01 00 00 00       	mov    $0x1,%eax
  803dfe:	31 d2                	xor    %edx,%edx
  803e00:	f7 f7                	div    %edi
  803e02:	89 c5                	mov    %eax,%ebp
  803e04:	31 d2                	xor    %edx,%edx
  803e06:	89 c8                	mov    %ecx,%eax
  803e08:	f7 f5                	div    %ebp
  803e0a:	89 c1                	mov    %eax,%ecx
  803e0c:	89 d8                	mov    %ebx,%eax
  803e0e:	f7 f5                	div    %ebp
  803e10:	89 cf                	mov    %ecx,%edi
  803e12:	89 fa                	mov    %edi,%edx
  803e14:	83 c4 1c             	add    $0x1c,%esp
  803e17:	5b                   	pop    %ebx
  803e18:	5e                   	pop    %esi
  803e19:	5f                   	pop    %edi
  803e1a:	5d                   	pop    %ebp
  803e1b:	c3                   	ret    
  803e1c:	39 ce                	cmp    %ecx,%esi
  803e1e:	77 28                	ja     803e48 <__udivdi3+0x7c>
  803e20:	0f bd fe             	bsr    %esi,%edi
  803e23:	83 f7 1f             	xor    $0x1f,%edi
  803e26:	75 40                	jne    803e68 <__udivdi3+0x9c>
  803e28:	39 ce                	cmp    %ecx,%esi
  803e2a:	72 0a                	jb     803e36 <__udivdi3+0x6a>
  803e2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e30:	0f 87 9e 00 00 00    	ja     803ed4 <__udivdi3+0x108>
  803e36:	b8 01 00 00 00       	mov    $0x1,%eax
  803e3b:	89 fa                	mov    %edi,%edx
  803e3d:	83 c4 1c             	add    $0x1c,%esp
  803e40:	5b                   	pop    %ebx
  803e41:	5e                   	pop    %esi
  803e42:	5f                   	pop    %edi
  803e43:	5d                   	pop    %ebp
  803e44:	c3                   	ret    
  803e45:	8d 76 00             	lea    0x0(%esi),%esi
  803e48:	31 ff                	xor    %edi,%edi
  803e4a:	31 c0                	xor    %eax,%eax
  803e4c:	89 fa                	mov    %edi,%edx
  803e4e:	83 c4 1c             	add    $0x1c,%esp
  803e51:	5b                   	pop    %ebx
  803e52:	5e                   	pop    %esi
  803e53:	5f                   	pop    %edi
  803e54:	5d                   	pop    %ebp
  803e55:	c3                   	ret    
  803e56:	66 90                	xchg   %ax,%ax
  803e58:	89 d8                	mov    %ebx,%eax
  803e5a:	f7 f7                	div    %edi
  803e5c:	31 ff                	xor    %edi,%edi
  803e5e:	89 fa                	mov    %edi,%edx
  803e60:	83 c4 1c             	add    $0x1c,%esp
  803e63:	5b                   	pop    %ebx
  803e64:	5e                   	pop    %esi
  803e65:	5f                   	pop    %edi
  803e66:	5d                   	pop    %ebp
  803e67:	c3                   	ret    
  803e68:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e6d:	89 eb                	mov    %ebp,%ebx
  803e6f:	29 fb                	sub    %edi,%ebx
  803e71:	89 f9                	mov    %edi,%ecx
  803e73:	d3 e6                	shl    %cl,%esi
  803e75:	89 c5                	mov    %eax,%ebp
  803e77:	88 d9                	mov    %bl,%cl
  803e79:	d3 ed                	shr    %cl,%ebp
  803e7b:	89 e9                	mov    %ebp,%ecx
  803e7d:	09 f1                	or     %esi,%ecx
  803e7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e83:	89 f9                	mov    %edi,%ecx
  803e85:	d3 e0                	shl    %cl,%eax
  803e87:	89 c5                	mov    %eax,%ebp
  803e89:	89 d6                	mov    %edx,%esi
  803e8b:	88 d9                	mov    %bl,%cl
  803e8d:	d3 ee                	shr    %cl,%esi
  803e8f:	89 f9                	mov    %edi,%ecx
  803e91:	d3 e2                	shl    %cl,%edx
  803e93:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e97:	88 d9                	mov    %bl,%cl
  803e99:	d3 e8                	shr    %cl,%eax
  803e9b:	09 c2                	or     %eax,%edx
  803e9d:	89 d0                	mov    %edx,%eax
  803e9f:	89 f2                	mov    %esi,%edx
  803ea1:	f7 74 24 0c          	divl   0xc(%esp)
  803ea5:	89 d6                	mov    %edx,%esi
  803ea7:	89 c3                	mov    %eax,%ebx
  803ea9:	f7 e5                	mul    %ebp
  803eab:	39 d6                	cmp    %edx,%esi
  803ead:	72 19                	jb     803ec8 <__udivdi3+0xfc>
  803eaf:	74 0b                	je     803ebc <__udivdi3+0xf0>
  803eb1:	89 d8                	mov    %ebx,%eax
  803eb3:	31 ff                	xor    %edi,%edi
  803eb5:	e9 58 ff ff ff       	jmp    803e12 <__udivdi3+0x46>
  803eba:	66 90                	xchg   %ax,%ax
  803ebc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ec0:	89 f9                	mov    %edi,%ecx
  803ec2:	d3 e2                	shl    %cl,%edx
  803ec4:	39 c2                	cmp    %eax,%edx
  803ec6:	73 e9                	jae    803eb1 <__udivdi3+0xe5>
  803ec8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ecb:	31 ff                	xor    %edi,%edi
  803ecd:	e9 40 ff ff ff       	jmp    803e12 <__udivdi3+0x46>
  803ed2:	66 90                	xchg   %ax,%ax
  803ed4:	31 c0                	xor    %eax,%eax
  803ed6:	e9 37 ff ff ff       	jmp    803e12 <__udivdi3+0x46>
  803edb:	90                   	nop

00803edc <__umoddi3>:
  803edc:	55                   	push   %ebp
  803edd:	57                   	push   %edi
  803ede:	56                   	push   %esi
  803edf:	53                   	push   %ebx
  803ee0:	83 ec 1c             	sub    $0x1c,%esp
  803ee3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ee7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ef3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ef7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803efb:	89 f3                	mov    %esi,%ebx
  803efd:	89 fa                	mov    %edi,%edx
  803eff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f03:	89 34 24             	mov    %esi,(%esp)
  803f06:	85 c0                	test   %eax,%eax
  803f08:	75 1a                	jne    803f24 <__umoddi3+0x48>
  803f0a:	39 f7                	cmp    %esi,%edi
  803f0c:	0f 86 a2 00 00 00    	jbe    803fb4 <__umoddi3+0xd8>
  803f12:	89 c8                	mov    %ecx,%eax
  803f14:	89 f2                	mov    %esi,%edx
  803f16:	f7 f7                	div    %edi
  803f18:	89 d0                	mov    %edx,%eax
  803f1a:	31 d2                	xor    %edx,%edx
  803f1c:	83 c4 1c             	add    $0x1c,%esp
  803f1f:	5b                   	pop    %ebx
  803f20:	5e                   	pop    %esi
  803f21:	5f                   	pop    %edi
  803f22:	5d                   	pop    %ebp
  803f23:	c3                   	ret    
  803f24:	39 f0                	cmp    %esi,%eax
  803f26:	0f 87 ac 00 00 00    	ja     803fd8 <__umoddi3+0xfc>
  803f2c:	0f bd e8             	bsr    %eax,%ebp
  803f2f:	83 f5 1f             	xor    $0x1f,%ebp
  803f32:	0f 84 ac 00 00 00    	je     803fe4 <__umoddi3+0x108>
  803f38:	bf 20 00 00 00       	mov    $0x20,%edi
  803f3d:	29 ef                	sub    %ebp,%edi
  803f3f:	89 fe                	mov    %edi,%esi
  803f41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f45:	89 e9                	mov    %ebp,%ecx
  803f47:	d3 e0                	shl    %cl,%eax
  803f49:	89 d7                	mov    %edx,%edi
  803f4b:	89 f1                	mov    %esi,%ecx
  803f4d:	d3 ef                	shr    %cl,%edi
  803f4f:	09 c7                	or     %eax,%edi
  803f51:	89 e9                	mov    %ebp,%ecx
  803f53:	d3 e2                	shl    %cl,%edx
  803f55:	89 14 24             	mov    %edx,(%esp)
  803f58:	89 d8                	mov    %ebx,%eax
  803f5a:	d3 e0                	shl    %cl,%eax
  803f5c:	89 c2                	mov    %eax,%edx
  803f5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f62:	d3 e0                	shl    %cl,%eax
  803f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f6c:	89 f1                	mov    %esi,%ecx
  803f6e:	d3 e8                	shr    %cl,%eax
  803f70:	09 d0                	or     %edx,%eax
  803f72:	d3 eb                	shr    %cl,%ebx
  803f74:	89 da                	mov    %ebx,%edx
  803f76:	f7 f7                	div    %edi
  803f78:	89 d3                	mov    %edx,%ebx
  803f7a:	f7 24 24             	mull   (%esp)
  803f7d:	89 c6                	mov    %eax,%esi
  803f7f:	89 d1                	mov    %edx,%ecx
  803f81:	39 d3                	cmp    %edx,%ebx
  803f83:	0f 82 87 00 00 00    	jb     804010 <__umoddi3+0x134>
  803f89:	0f 84 91 00 00 00    	je     804020 <__umoddi3+0x144>
  803f8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f93:	29 f2                	sub    %esi,%edx
  803f95:	19 cb                	sbb    %ecx,%ebx
  803f97:	89 d8                	mov    %ebx,%eax
  803f99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f9d:	d3 e0                	shl    %cl,%eax
  803f9f:	89 e9                	mov    %ebp,%ecx
  803fa1:	d3 ea                	shr    %cl,%edx
  803fa3:	09 d0                	or     %edx,%eax
  803fa5:	89 e9                	mov    %ebp,%ecx
  803fa7:	d3 eb                	shr    %cl,%ebx
  803fa9:	89 da                	mov    %ebx,%edx
  803fab:	83 c4 1c             	add    $0x1c,%esp
  803fae:	5b                   	pop    %ebx
  803faf:	5e                   	pop    %esi
  803fb0:	5f                   	pop    %edi
  803fb1:	5d                   	pop    %ebp
  803fb2:	c3                   	ret    
  803fb3:	90                   	nop
  803fb4:	89 fd                	mov    %edi,%ebp
  803fb6:	85 ff                	test   %edi,%edi
  803fb8:	75 0b                	jne    803fc5 <__umoddi3+0xe9>
  803fba:	b8 01 00 00 00       	mov    $0x1,%eax
  803fbf:	31 d2                	xor    %edx,%edx
  803fc1:	f7 f7                	div    %edi
  803fc3:	89 c5                	mov    %eax,%ebp
  803fc5:	89 f0                	mov    %esi,%eax
  803fc7:	31 d2                	xor    %edx,%edx
  803fc9:	f7 f5                	div    %ebp
  803fcb:	89 c8                	mov    %ecx,%eax
  803fcd:	f7 f5                	div    %ebp
  803fcf:	89 d0                	mov    %edx,%eax
  803fd1:	e9 44 ff ff ff       	jmp    803f1a <__umoddi3+0x3e>
  803fd6:	66 90                	xchg   %ax,%ax
  803fd8:	89 c8                	mov    %ecx,%eax
  803fda:	89 f2                	mov    %esi,%edx
  803fdc:	83 c4 1c             	add    $0x1c,%esp
  803fdf:	5b                   	pop    %ebx
  803fe0:	5e                   	pop    %esi
  803fe1:	5f                   	pop    %edi
  803fe2:	5d                   	pop    %ebp
  803fe3:	c3                   	ret    
  803fe4:	3b 04 24             	cmp    (%esp),%eax
  803fe7:	72 06                	jb     803fef <__umoddi3+0x113>
  803fe9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fed:	77 0f                	ja     803ffe <__umoddi3+0x122>
  803fef:	89 f2                	mov    %esi,%edx
  803ff1:	29 f9                	sub    %edi,%ecx
  803ff3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ff7:	89 14 24             	mov    %edx,(%esp)
  803ffa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ffe:	8b 44 24 04          	mov    0x4(%esp),%eax
  804002:	8b 14 24             	mov    (%esp),%edx
  804005:	83 c4 1c             	add    $0x1c,%esp
  804008:	5b                   	pop    %ebx
  804009:	5e                   	pop    %esi
  80400a:	5f                   	pop    %edi
  80400b:	5d                   	pop    %ebp
  80400c:	c3                   	ret    
  80400d:	8d 76 00             	lea    0x0(%esi),%esi
  804010:	2b 04 24             	sub    (%esp),%eax
  804013:	19 fa                	sbb    %edi,%edx
  804015:	89 d1                	mov    %edx,%ecx
  804017:	89 c6                	mov    %eax,%esi
  804019:	e9 71 ff ff ff       	jmp    803f8f <__umoddi3+0xb3>
  80401e:	66 90                	xchg   %ax,%ax
  804020:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804024:	72 ea                	jb     804010 <__umoddi3+0x134>
  804026:	89 d9                	mov    %ebx,%ecx
  804028:	e9 62 ff ff ff       	jmp    803f8f <__umoddi3+0xb3>

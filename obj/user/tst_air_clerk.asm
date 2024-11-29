
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
  800044:	e8 00 21 00 00       	call   802149 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 15 42 80 00       	mov    $0x804215,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 1f 42 80 00       	mov    $0x80421f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 2b 42 80 00       	mov    $0x80422b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 3a 42 80 00       	mov    $0x80423a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 49 42 80 00       	mov    $0x804249,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 5e 42 80 00       	mov    $0x80425e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 73 42 80 00       	mov    $0x804273,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 84 42 80 00       	mov    $0x804284,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 95 42 80 00       	mov    $0x804295,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb a6 42 80 00       	mov    $0x8042a6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb af 42 80 00       	mov    $0x8042af,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb b9 42 80 00       	mov    $0x8042b9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb c4 42 80 00       	mov    $0x8042c4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb d0 42 80 00       	mov    $0x8042d0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb da 42 80 00       	mov    $0x8042da,%ebx
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
  8001c1:	bb e4 42 80 00       	mov    $0x8042e4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb f2 42 80 00       	mov    $0x8042f2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 01 43 80 00       	mov    $0x804301,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 08 43 80 00       	mov    $0x804308,%ebx
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
  800225:	e8 3b 1a 00 00       	call   801c65 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 26 1a 00 00       	call   801c65 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 11 1a 00 00       	call   801c65 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 f9 19 00 00       	call   801c65 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 e1 19 00 00       	call   801c65 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 c9 19 00 00       	call   801c65 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 b1 19 00 00       	call   801c65 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 99 19 00 00       	call   801c65 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 81 19 00 00       	call   801c65 <sget>
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
  8002fe:	e8 20 3c 00 00       	call   803f23 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 04 3c 00 00       	call   803f23 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 e8 3b 00 00       	call   803f23 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 cc 3b 00 00       	call   803f23 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 b0 3b 00 00       	call   803f23 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 b9 3b 00 00       	call   803f3d <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 a8 3b 00 00       	call   803f3d <wait_semaphore>
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
  8003c4:	e8 8e 3b 00 00       	call   803f57 <signal_semaphore>
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
  800407:	e8 31 3b 00 00       	call   803f3d <wait_semaphore>
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
  800467:	e8 eb 3a 00 00       	call   803f57 <signal_semaphore>
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
  80047d:	e8 bb 3a 00 00       	call   803f3d <wait_semaphore>
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
  8004dd:	e8 75 3a 00 00       	call   803f57 <signal_semaphore>
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
  8004f3:	e8 45 3a 00 00       	call   803f3d <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 34 3a 00 00       	call   803f3d <wait_semaphore>
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
  8005bb:	e8 97 39 00 00       	call   803f57 <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 86 39 00 00       	call   803f57 <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 e0 41 80 00       	push   $0x8041e0
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 00 42 80 00       	push   $0x804200
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 0f 43 80 00       	mov    $0x80430f,%ebx
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
  800662:	e8 bc 38 00 00       	call   803f23 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 df 38 00 00       	call   803f57 <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 ce 38 00 00       	call   803f57 <signal_semaphore>
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
  800697:	e8 94 1a 00 00       	call   802130 <sys_getenvindex>
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
  800705:	e8 aa 17 00 00       	call   801eb4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 48 43 80 00       	push   $0x804348
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
  800735:	68 70 43 80 00       	push   $0x804370
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
  800766:	68 98 43 80 00       	push   $0x804398
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 f0 43 80 00       	push   $0x8043f0
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 48 43 80 00       	push   $0x804348
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 2a 17 00 00       	call   801ece <sys_unlock_cons>
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
  8007b7:	e8 40 19 00 00       	call   8020fc <sys_destroy_env>
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
  8007c8:	e8 95 19 00 00       	call   802162 <sys_exit_env>
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
  8007df:	a1 50 50 80 00       	mov    0x805050,%eax
  8007e4:	85 c0                	test   %eax,%eax
  8007e6:	74 16                	je     8007fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	50                   	push   %eax
  8007f1:	68 04 44 80 00       	push   $0x804404
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 09 44 80 00       	push   $0x804409
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
  80082e:	68 25 44 80 00       	push   $0x804425
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
  80085d:	68 28 44 80 00       	push   $0x804428
  800862:	6a 26                	push   $0x26
  800864:	68 74 44 80 00       	push   $0x804474
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
  800932:	68 80 44 80 00       	push   $0x804480
  800937:	6a 3a                	push   $0x3a
  800939:	68 74 44 80 00       	push   $0x804474
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
  8009a5:	68 d4 44 80 00       	push   $0x8044d4
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 74 44 80 00       	push   $0x804474
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
  8009e4:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8009ff:	e8 6e 14 00 00       	call   801e72 <sys_cputs>
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
  800a59:	a0 2c 50 80 00       	mov    0x80502c,%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	50                   	push   %eax
  800a6b:	52                   	push   %edx
  800a6c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a72:	83 c0 08             	add    $0x8,%eax
  800a75:	50                   	push   %eax
  800a76:	e8 f7 13 00 00       	call   801e72 <sys_cputs>
  800a7b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a7e:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800a93:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800ac0:	e8 ef 13 00 00       	call   801eb4 <sys_lock_cons>
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
  800ae0:	e8 e9 13 00 00       	call   801ece <sys_unlock_cons>
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
  800b2a:	e8 4d 34 00 00       	call   803f7c <__udivdi3>
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
  800b7a:	e8 0d 35 00 00       	call   80408c <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 34 47 80 00       	add    $0x804734,%eax
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
  800cd5:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
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
  800db6:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 45 47 80 00       	push   $0x804745
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
  800ddb:	68 4e 47 80 00       	push   $0x80474e
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
  800e08:	be 51 47 80 00       	mov    $0x804751,%esi
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
  801000:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  801007:	eb 2c                	jmp    801035 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801009:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801813:	68 c8 48 80 00       	push   $0x8048c8
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 ea 48 80 00       	push   $0x8048ea
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
  801833:	e8 e5 0b 00 00       	call   80241d <sys_sbrk>
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
  8018ae:	e8 ee 09 00 00       	call   8022a1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 2e 0f 00 00       	call   8027f0 <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 00 0a 00 00       	call   8022d2 <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 c7 13 00 00       	call   802cac <alloc_block_BF>
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
  801930:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80197d:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8019d4:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801a36:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	ff 75 f0             	pushl  -0x10(%ebp)
  801a46:	e8 09 0a 00 00       	call   802454 <sys_allocate_user_mem>
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
  801a8e:	e8 dd 09 00 00       	call   802470 <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 10 1c 00 00       	call   8036b4 <free_block>
  801aa4:	83 c4 10             	add    $0x10,%esp
		}

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
  801ad9:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae6:	c1 e0 0c             	shl    $0xc,%eax
  801ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801af3:	eb 42                	jmp    801b37 <free+0xdb>
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
  801b16:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801b1d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	e8 07 09 00 00       	call   802438 <sys_free_user_mem>
  801b31:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801b34:	ff 45 f4             	incl   -0xc(%ebp)
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b3d:	72 b6                	jb     801af5 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801b3f:	eb 17                	jmp    801b58 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	68 f8 48 80 00       	push   $0x8048f8
  801b49:	68 88 00 00 00       	push   $0x88
  801b4e:	68 22 49 80 00       	push   $0x804922
  801b53:	e8 78 ec ff ff       	call   8007d0 <_panic>
	}
}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 28             	sub    $0x28,%esp
  801b61:	8b 45 10             	mov    0x10(%ebp),%eax
  801b64:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b6b:	75 0a                	jne    801b77 <smalloc+0x1c>
  801b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b72:	e9 ec 00 00 00       	jmp    801c63 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b7d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8a:	39 d0                	cmp    %edx,%eax
  801b8c:	73 02                	jae    801b90 <smalloc+0x35>
  801b8e:	89 d0                	mov    %edx,%eax
  801b90:	83 ec 0c             	sub    $0xc,%esp
  801b93:	50                   	push   %eax
  801b94:	e8 a4 fc ff ff       	call   80183d <malloc>
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801b9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ba3:	75 0a                	jne    801baf <smalloc+0x54>
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  801baa:	e9 b4 00 00 00       	jmp    801c63 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801baf:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bb3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 7d 04 00 00       	call   80203f <sys_createSharedObject>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801bc8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bcc:	74 06                	je     801bd4 <smalloc+0x79>
  801bce:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bd2:	75 0a                	jne    801bde <smalloc+0x83>
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	e9 85 00 00 00       	jmp    801c63 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	ff 75 ec             	pushl  -0x14(%ebp)
  801be4:	68 2e 49 80 00       	push   $0x80492e
  801be9:	e8 9f ee ff ff       	call   800a8d <cprintf>
  801bee:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801bf1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  801bf9:	8b 40 78             	mov    0x78(%eax),%eax
  801bfc:	29 c2                	sub    %eax,%edx
  801bfe:	89 d0                	mov    %edx,%eax
  801c00:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c05:	c1 e8 0c             	shr    $0xc,%eax
  801c08:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c0e:	42                   	inc    %edx
  801c0f:	89 15 24 50 80 00    	mov    %edx,0x805024
  801c15:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801c1b:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801c22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c25:	a1 20 50 80 00       	mov    0x805020,%eax
  801c2a:	8b 40 78             	mov    0x78(%eax),%eax
  801c2d:	29 c2                	sub    %eax,%edx
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c36:	c1 e8 0c             	shr    $0xc,%eax
  801c39:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801c40:	a1 20 50 80 00       	mov    0x805020,%eax
  801c45:	8b 50 10             	mov    0x10(%eax),%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 e0 02             	shl    $0x2,%eax
  801c4d:	89 c1                	mov    %eax,%ecx
  801c4f:	c1 e1 09             	shl    $0x9,%ecx
  801c52:	01 c8                	add    %ecx,%eax
  801c54:	01 c2                	add    %eax,%edx
  801c56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c59:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	e8 f0 03 00 00       	call   802069 <sys_getSizeOfSharedObject>
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c7f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c83:	75 0a                	jne    801c8f <sget+0x2a>
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8a:	e9 e7 00 00 00       	jmp    801d76 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c95:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca2:	39 d0                	cmp    %edx,%eax
  801ca4:	73 02                	jae    801ca8 <sget+0x43>
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	50                   	push   %eax
  801cac:	e8 8c fb ff ff       	call   80183d <malloc>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801cb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801cbb:	75 0a                	jne    801cc7 <sget+0x62>
  801cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc2:	e9 af 00 00 00       	jmp    801d76 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	ff 75 e8             	pushl  -0x18(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 ae 03 00 00       	call   802086 <sys_getSharedObject>
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801cde:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce1:	a1 20 50 80 00       	mov    0x805020,%eax
  801ce6:	8b 40 78             	mov    0x78(%eax),%eax
  801ce9:	29 c2                	sub    %eax,%edx
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cf2:	c1 e8 0c             	shr    $0xc,%eax
  801cf5:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801cfb:	42                   	inc    %edx
  801cfc:	89 15 24 50 80 00    	mov    %edx,0x805024
  801d02:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801d08:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d12:	a1 20 50 80 00       	mov    0x805020,%eax
  801d17:	8b 40 78             	mov    0x78(%eax),%eax
  801d1a:	29 c2                	sub    %eax,%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d23:	c1 e8 0c             	shr    $0xc,%eax
  801d26:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801d2d:	a1 20 50 80 00       	mov    0x805020,%eax
  801d32:	8b 50 10             	mov    0x10(%eax),%edx
  801d35:	89 c8                	mov    %ecx,%eax
  801d37:	c1 e0 02             	shl    $0x2,%eax
  801d3a:	89 c1                	mov    %eax,%ecx
  801d3c:	c1 e1 09             	shl    $0x9,%ecx
  801d3f:	01 c8                	add    %ecx,%eax
  801d41:	01 c2                	add    %eax,%edx
  801d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d46:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801d4d:	a1 20 50 80 00       	mov    0x805020,%eax
  801d52:	8b 40 10             	mov    0x10(%eax),%eax
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	50                   	push   %eax
  801d59:	68 3d 49 80 00       	push   $0x80493d
  801d5e:	e8 2a ed ff ff       	call   800a8d <cprintf>
  801d63:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801d66:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801d6a:	75 07                	jne    801d73 <sget+0x10e>
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	eb 03                	jmp    801d76 <sget+0x111>
	return ptr;
  801d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d81:	a1 20 50 80 00       	mov    0x805020,%eax
  801d86:	8b 40 78             	mov    0x78(%eax),%eax
  801d89:	29 c2                	sub    %eax,%edx
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d92:	c1 e8 0c             	shr    $0xc,%eax
  801d95:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801d9c:	a1 20 50 80 00       	mov    0x805020,%eax
  801da1:	8b 50 10             	mov    0x10(%eax),%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 e0 02             	shl    $0x2,%eax
  801da9:	89 c1                	mov    %eax,%ecx
  801dab:	c1 e1 09             	shl    $0x9,%ecx
  801dae:	01 c8                	add    %ecx,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc5:	e8 db 02 00 00       	call   8020a5 <sys_freeSharedObject>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	68 4c 49 80 00       	push   $0x80494c
  801de1:	68 e5 00 00 00       	push   $0xe5
  801de6:	68 22 49 80 00       	push   $0x804922
  801deb:	e8 e0 e9 ff ff       	call   8007d0 <_panic>

00801df0 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	68 72 49 80 00       	push   $0x804972
  801dfe:	68 f1 00 00 00       	push   $0xf1
  801e03:	68 22 49 80 00       	push   $0x804922
  801e08:	e8 c3 e9 ff ff       	call   8007d0 <_panic>

00801e0d <shrink>:

}
void shrink(uint32 newSize)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	68 72 49 80 00       	push   $0x804972
  801e1b:	68 f6 00 00 00       	push   $0xf6
  801e20:	68 22 49 80 00       	push   $0x804922
  801e25:	e8 a6 e9 ff ff       	call   8007d0 <_panic>

00801e2a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	68 72 49 80 00       	push   $0x804972
  801e38:	68 fb 00 00 00       	push   $0xfb
  801e3d:	68 22 49 80 00       	push   $0x804922
  801e42:	e8 89 e9 ff ff       	call   8007d0 <_panic>

00801e47 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	57                   	push   %edi
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
  801e4d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e5f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e62:	cd 30                	int    $0x30
  801e64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	5b                   	pop    %ebx
  801e6e:	5e                   	pop    %esi
  801e6f:	5f                   	pop    %edi
  801e70:	5d                   	pop    %ebp
  801e71:	c3                   	ret    

00801e72 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	52                   	push   %edx
  801e8a:	ff 75 0c             	pushl  0xc(%ebp)
  801e8d:	50                   	push   %eax
  801e8e:	6a 00                	push   $0x0
  801e90:	e8 b2 ff ff ff       	call   801e47 <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	90                   	nop
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_cgetc>:

int
sys_cgetc(void)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 02                	push   $0x2
  801eaa:	e8 98 ff ff ff       	call   801e47 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 03                	push   $0x3
  801ec3:	e8 7f ff ff ff       	call   801e47 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	90                   	nop
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 04                	push   $0x4
  801edd:	e8 65 ff ff ff       	call   801e47 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	90                   	nop
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 08                	push   $0x8
  801efb:	e8 47 ff ff ff       	call   801e47 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f0a:	8b 75 18             	mov    0x18(%ebp),%esi
  801f0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	51                   	push   %ecx
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	6a 09                	push   $0x9
  801f20:	e8 22 ff ff ff       	call   801e47 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    

00801f2f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 0a                	push   $0xa
  801f42:	e8 00 ff ff ff       	call   801e47 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	ff 75 08             	pushl  0x8(%ebp)
  801f5b:	6a 0b                	push   $0xb
  801f5d:	e8 e5 fe ff ff       	call   801e47 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 0c                	push   $0xc
  801f76:	e8 cc fe ff ff       	call   801e47 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 0d                	push   $0xd
  801f8f:	e8 b3 fe ff ff       	call   801e47 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 0e                	push   $0xe
  801fa8:	e8 9a fe ff ff       	call   801e47 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 0f                	push   $0xf
  801fc1:	e8 81 fe ff ff       	call   801e47 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	6a 10                	push   $0x10
  801fdb:	e8 67 fe ff ff       	call   801e47 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 11                	push   $0x11
  801ff4:	e8 4e fe ff ff       	call   801e47 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	90                   	nop
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_cputc>:

void
sys_cputc(const char c)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80200b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	50                   	push   %eax
  802018:	6a 01                	push   $0x1
  80201a:	e8 28 fe ff ff       	call   801e47 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	90                   	nop
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 14                	push   $0x14
  802034:	e8 0e fe ff ff       	call   801e47 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	90                   	nop
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	8b 45 10             	mov    0x10(%ebp),%eax
  802048:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80204b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80204e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	6a 00                	push   $0x0
  802057:	51                   	push   %ecx
  802058:	52                   	push   %edx
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	50                   	push   %eax
  80205d:	6a 15                	push   $0x15
  80205f:	e8 e3 fd ff ff       	call   801e47 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80206c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 16                	push   $0x16
  80207c:	e8 c6 fd ff ff       	call   801e47 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802089:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	51                   	push   %ecx
  802097:	52                   	push   %edx
  802098:	50                   	push   %eax
  802099:	6a 17                	push   $0x17
  80209b:	e8 a7 fd ff ff       	call   801e47 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	6a 18                	push   $0x18
  8020b8:	e8 8a fd ff ff       	call   801e47 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	6a 00                	push   $0x0
  8020ca:	ff 75 14             	pushl  0x14(%ebp)
  8020cd:	ff 75 10             	pushl  0x10(%ebp)
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	50                   	push   %eax
  8020d4:	6a 19                	push   $0x19
  8020d6:	e8 6c fd ff ff       	call   801e47 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	50                   	push   %eax
  8020ef:	6a 1a                	push   $0x1a
  8020f1:	e8 51 fd ff ff       	call   801e47 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
}
  8020f9:	90                   	nop
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	50                   	push   %eax
  80210b:	6a 1b                	push   $0x1b
  80210d:	e8 35 fd ff ff       	call   801e47 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 05                	push   $0x5
  802126:	e8 1c fd ff ff       	call   801e47 <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 06                	push   $0x6
  80213f:	e8 03 fd ff ff       	call   801e47 <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 07                	push   $0x7
  802158:	e8 ea fc ff ff       	call   801e47 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_exit_env>:


void sys_exit_env(void)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 1c                	push   $0x1c
  802171:	e8 d1 fc ff ff       	call   801e47 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802182:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802185:	8d 50 04             	lea    0x4(%eax),%edx
  802188:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	52                   	push   %edx
  802192:	50                   	push   %eax
  802193:	6a 1d                	push   $0x1d
  802195:	e8 ad fc ff ff       	call   801e47 <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
	return result;
  80219d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a6:	89 01                	mov    %eax,(%ecx)
  8021a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	c9                   	leave  
  8021af:	c2 04 00             	ret    $0x4

008021b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 10             	pushl  0x10(%ebp)
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	6a 13                	push   $0x13
  8021c4:	e8 7e fc ff ff       	call   801e47 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cc:	90                   	nop
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 1e                	push   $0x1e
  8021de:	e8 64 fc ff ff       	call   801e47 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	50                   	push   %eax
  802201:	6a 1f                	push   $0x1f
  802203:	e8 3f fc ff ff       	call   801e47 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
	return ;
  80220b:	90                   	nop
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <rsttst>:
void rsttst()
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 21                	push   $0x21
  80221d:	e8 25 fc ff ff       	call   801e47 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
	return ;
  802225:	90                   	nop
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	8b 45 14             	mov    0x14(%ebp),%eax
  802231:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802234:	8b 55 18             	mov    0x18(%ebp),%edx
  802237:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80223b:	52                   	push   %edx
  80223c:	50                   	push   %eax
  80223d:	ff 75 10             	pushl  0x10(%ebp)
  802240:	ff 75 0c             	pushl  0xc(%ebp)
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	6a 20                	push   $0x20
  802248:	e8 fa fb ff ff       	call   801e47 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return ;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <chktst>:
void chktst(uint32 n)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	ff 75 08             	pushl  0x8(%ebp)
  802261:	6a 22                	push   $0x22
  802263:	e8 df fb ff ff       	call   801e47 <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <inctst>:

void inctst()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 23                	push   $0x23
  80227d:	e8 c5 fb ff ff       	call   801e47 <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
	return ;
  802285:	90                   	nop
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <gettst>:
uint32 gettst()
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 24                	push   $0x24
  802297:	e8 ab fb ff ff       	call   801e47 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 25                	push   $0x25
  8022b3:	e8 8f fb ff ff       	call   801e47 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
  8022bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022be:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022c2:	75 07                	jne    8022cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c9:	eb 05                	jmp    8022d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 25                	push   $0x25
  8022e4:	e8 5e fb ff ff       	call   801e47 <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
  8022ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022ef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022f3:	75 07                	jne    8022fc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fa:	eb 05                	jmp    802301 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 25                	push   $0x25
  802315:	e8 2d fb ff ff       	call   801e47 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
  80231d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802320:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802324:	75 07                	jne    80232d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	eb 05                	jmp    802332 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 25                	push   $0x25
  802346:	e8 fc fa ff ff       	call   801e47 <syscall>
  80234b:	83 c4 18             	add    $0x18,%esp
  80234e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802351:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802355:	75 07                	jne    80235e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802357:	b8 01 00 00 00       	mov    $0x1,%eax
  80235c:	eb 05                	jmp    802363 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	ff 75 08             	pushl  0x8(%ebp)
  802373:	6a 26                	push   $0x26
  802375:	e8 cd fa ff ff       	call   801e47 <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
	return ;
  80237d:	90                   	nop
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802384:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802387:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	53                   	push   %ebx
  802393:	51                   	push   %ecx
  802394:	52                   	push   %edx
  802395:	50                   	push   %eax
  802396:	6a 27                	push   $0x27
  802398:	e8 aa fa ff ff       	call   801e47 <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
}
  8023a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	52                   	push   %edx
  8023b5:	50                   	push   %eax
  8023b6:	6a 28                	push   $0x28
  8023b8:	e8 8a fa ff ff       	call   801e47 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8023c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	6a 00                	push   $0x0
  8023d0:	51                   	push   %ecx
  8023d1:	ff 75 10             	pushl  0x10(%ebp)
  8023d4:	52                   	push   %edx
  8023d5:	50                   	push   %eax
  8023d6:	6a 29                	push   $0x29
  8023d8:	e8 6a fa ff ff       	call   801e47 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	ff 75 10             	pushl  0x10(%ebp)
  8023ec:	ff 75 0c             	pushl  0xc(%ebp)
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	6a 12                	push   $0x12
  8023f4:	e8 4e fa ff ff       	call   801e47 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fc:	90                   	nop
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802402:	8b 55 0c             	mov    0xc(%ebp),%edx
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	52                   	push   %edx
  80240f:	50                   	push   %eax
  802410:	6a 2a                	push   $0x2a
  802412:	e8 30 fa ff ff       	call   801e47 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
	return;
  80241a:	90                   	nop
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	50                   	push   %eax
  80242c:	6a 2b                	push   $0x2b
  80242e:	e8 14 fa ff ff       	call   801e47 <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	ff 75 0c             	pushl  0xc(%ebp)
  802444:	ff 75 08             	pushl  0x8(%ebp)
  802447:	6a 2c                	push   $0x2c
  802449:	e8 f9 f9 ff ff       	call   801e47 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
	return;
  802451:	90                   	nop
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	ff 75 0c             	pushl  0xc(%ebp)
  802460:	ff 75 08             	pushl  0x8(%ebp)
  802463:	6a 2d                	push   $0x2d
  802465:	e8 dd f9 ff ff       	call   801e47 <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
	return;
  80246d:	90                   	nop
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	83 e8 04             	sub    $0x4,%eax
  80247c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80247f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	83 e8 04             	sub    $0x4,%eax
  802495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	83 e0 01             	and    $0x1,%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	0f 94 c0             	sete   %al
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b7:	83 f8 02             	cmp    $0x2,%eax
  8024ba:	74 2b                	je     8024e7 <alloc_block+0x40>
  8024bc:	83 f8 02             	cmp    $0x2,%eax
  8024bf:	7f 07                	jg     8024c8 <alloc_block+0x21>
  8024c1:	83 f8 01             	cmp    $0x1,%eax
  8024c4:	74 0e                	je     8024d4 <alloc_block+0x2d>
  8024c6:	eb 58                	jmp    802520 <alloc_block+0x79>
  8024c8:	83 f8 03             	cmp    $0x3,%eax
  8024cb:	74 2d                	je     8024fa <alloc_block+0x53>
  8024cd:	83 f8 04             	cmp    $0x4,%eax
  8024d0:	74 3b                	je     80250d <alloc_block+0x66>
  8024d2:	eb 4c                	jmp    802520 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024d4:	83 ec 0c             	sub    $0xc,%esp
  8024d7:	ff 75 08             	pushl  0x8(%ebp)
  8024da:	e8 11 03 00 00       	call   8027f0 <alloc_block_FF>
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024e5:	eb 4a                	jmp    802531 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	e8 fa 19 00 00       	call   803eec <alloc_block_NF>
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024f8:	eb 37                	jmp    802531 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024fa:	83 ec 0c             	sub    $0xc,%esp
  8024fd:	ff 75 08             	pushl  0x8(%ebp)
  802500:	e8 a7 07 00 00       	call   802cac <alloc_block_BF>
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80250b:	eb 24                	jmp    802531 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80250d:	83 ec 0c             	sub    $0xc,%esp
  802510:	ff 75 08             	pushl  0x8(%ebp)
  802513:	e8 b7 19 00 00       	call   803ecf <alloc_block_WF>
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80251e:	eb 11                	jmp    802531 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	68 84 49 80 00       	push   $0x804984
  802528:	e8 60 e5 ff ff       	call   800a8d <cprintf>
  80252d:	83 c4 10             	add    $0x10,%esp
		break;
  802530:	90                   	nop
	}
	return va;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	53                   	push   %ebx
  80253a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	68 a4 49 80 00       	push   $0x8049a4
  802545:	e8 43 e5 ff ff       	call   800a8d <cprintf>
  80254a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80254d:	83 ec 0c             	sub    $0xc,%esp
  802550:	68 cf 49 80 00       	push   $0x8049cf
  802555:	e8 33 e5 ff ff       	call   800a8d <cprintf>
  80255a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	eb 37                	jmp    80259c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	ff 75 f4             	pushl  -0xc(%ebp)
  80256b:	e8 19 ff ff ff       	call   802489 <is_free_block>
  802570:	83 c4 10             	add    $0x10,%esp
  802573:	0f be d8             	movsbl %al,%ebx
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	ff 75 f4             	pushl  -0xc(%ebp)
  80257c:	e8 ef fe ff ff       	call   802470 <get_block_size>
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	53                   	push   %ebx
  802588:	50                   	push   %eax
  802589:	68 e7 49 80 00       	push   $0x8049e7
  80258e:	e8 fa e4 ff ff       	call   800a8d <cprintf>
  802593:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802596:	8b 45 10             	mov    0x10(%ebp),%eax
  802599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a0:	74 07                	je     8025a9 <print_blocks_list+0x73>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 00                	mov    (%eax),%eax
  8025a7:	eb 05                	jmp    8025ae <print_blocks_list+0x78>
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	89 45 10             	mov    %eax,0x10(%ebp)
  8025b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	75 ad                	jne    802565 <print_blocks_list+0x2f>
  8025b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bc:	75 a7                	jne    802565 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	68 a4 49 80 00       	push   $0x8049a4
  8025c6:	e8 c2 e4 ff ff       	call   800a8d <cprintf>
  8025cb:	83 c4 10             	add    $0x10,%esp

}
  8025ce:	90                   	nop
  8025cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8025da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025dd:	83 e0 01             	and    $0x1,%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 03                	je     8025e7 <initialize_dynamic_allocator+0x13>
  8025e4:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8025e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025eb:	0f 84 c7 01 00 00    	je     8027b8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025f1:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8025f8:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	01 d0                	add    %edx,%eax
  802603:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802608:	0f 87 ad 01 00 00    	ja     8027bb <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	0f 89 a5 01 00 00    	jns    8027be <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802619:	8b 55 08             	mov    0x8(%ebp),%edx
  80261c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261f:	01 d0                	add    %edx,%eax
  802621:	83 e8 04             	sub    $0x4,%eax
  802624:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802630:	a1 30 50 80 00       	mov    0x805030,%eax
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802638:	e9 87 00 00 00       	jmp    8026c4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	75 14                	jne    802657 <initialize_dynamic_allocator+0x83>
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	68 ff 49 80 00       	push   $0x8049ff
  80264b:	6a 79                	push   $0x79
  80264d:	68 1d 4a 80 00       	push   $0x804a1d
  802652:	e8 79 e1 ff ff       	call   8007d0 <_panic>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	74 10                	je     802670 <initialize_dynamic_allocator+0x9c>
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802668:	8b 52 04             	mov    0x4(%edx),%edx
  80266b:	89 50 04             	mov    %edx,0x4(%eax)
  80266e:	eb 0b                	jmp    80267b <initialize_dynamic_allocator+0xa7>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	a3 34 50 80 00       	mov    %eax,0x805034
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 0f                	je     802694 <initialize_dynamic_allocator+0xc0>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268e:	8b 12                	mov    (%edx),%edx
  802690:	89 10                	mov    %edx,(%eax)
  802692:	eb 0a                	jmp    80269e <initialize_dynamic_allocator+0xca>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	a3 30 50 80 00       	mov    %eax,0x805030
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026b6:	48                   	dec    %eax
  8026b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	74 07                	je     8026d1 <initialize_dynamic_allocator+0xfd>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	eb 05                	jmp    8026d6 <initialize_dynamic_allocator+0x102>
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8026db:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	0f 85 55 ff ff ff    	jne    80263d <initialize_dynamic_allocator+0x69>
  8026e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ec:	0f 85 4b ff ff ff    	jne    80263d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802701:	a1 48 50 80 00       	mov    0x805048,%eax
  802706:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80270b:	a1 44 50 80 00       	mov    0x805044,%eax
  802710:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	83 c0 08             	add    $0x8,%eax
  80271c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	83 c0 04             	add    $0x4,%eax
  802725:	8b 55 0c             	mov    0xc(%ebp),%edx
  802728:	83 ea 08             	sub    $0x8,%edx
  80272b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80272d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	01 d0                	add    %edx,%eax
  802735:	83 e8 08             	sub    $0x8,%eax
  802738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273b:	83 ea 08             	sub    $0x8,%edx
  80273e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802753:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802757:	75 17                	jne    802770 <initialize_dynamic_allocator+0x19c>
  802759:	83 ec 04             	sub    $0x4,%esp
  80275c:	68 38 4a 80 00       	push   $0x804a38
  802761:	68 90 00 00 00       	push   $0x90
  802766:	68 1d 4a 80 00       	push   $0x804a1d
  80276b:	e8 60 e0 ff ff       	call   8007d0 <_panic>
  802770:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	89 10                	mov    %edx,(%eax)
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 0d                	je     802791 <initialize_dynamic_allocator+0x1bd>
  802784:	a1 30 50 80 00       	mov    0x805030,%eax
  802789:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278c:	89 50 04             	mov    %edx,0x4(%eax)
  80278f:	eb 08                	jmp    802799 <initialize_dynamic_allocator+0x1c5>
  802791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802794:	a3 34 50 80 00       	mov    %eax,0x805034
  802799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279c:	a3 30 50 80 00       	mov    %eax,0x805030
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027b0:	40                   	inc    %eax
  8027b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027b6:	eb 07                	jmp    8027bf <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027b8:	90                   	nop
  8027b9:	eb 04                	jmp    8027bf <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027bb:	90                   	nop
  8027bc:	eb 01                	jmp    8027bf <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027be:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d3:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	83 e8 04             	sub    $0x4,%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8027e0:	8d 50 f8             	lea    -0x8(%eax),%edx
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	01 c2                	add    %eax,%edx
  8027e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027eb:	89 02                	mov    %eax,(%edx)
}
  8027ed:	90                   	nop
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    

008027f0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	83 e0 01             	and    $0x1,%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 03                	je     802803 <alloc_block_FF+0x13>
  802800:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802803:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802807:	77 07                	ja     802810 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802809:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802810:	a1 28 50 80 00       	mov    0x805028,%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	75 73                	jne    80288c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	83 c0 10             	add    $0x10,%eax
  80281f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802822:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802829:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	48                   	dec    %eax
  802832:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802838:	ba 00 00 00 00       	mov    $0x0,%edx
  80283d:	f7 75 ec             	divl   -0x14(%ebp)
  802840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802843:	29 d0                	sub    %edx,%eax
  802845:	c1 e8 0c             	shr    $0xc,%eax
  802848:	83 ec 0c             	sub    $0xc,%esp
  80284b:	50                   	push   %eax
  80284c:	e8 d6 ef ff ff       	call   801827 <sbrk>
  802851:	83 c4 10             	add    $0x10,%esp
  802854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	6a 00                	push   $0x0
  80285c:	e8 c6 ef ff ff       	call   801827 <sbrk>
  802861:	83 c4 10             	add    $0x10,%esp
  802864:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80286d:	83 ec 08             	sub    $0x8,%esp
  802870:	50                   	push   %eax
  802871:	ff 75 e4             	pushl  -0x1c(%ebp)
  802874:	e8 5b fd ff ff       	call   8025d4 <initialize_dynamic_allocator>
  802879:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	68 5b 4a 80 00       	push   $0x804a5b
  802884:	e8 04 e2 ff ff       	call   800a8d <cprintf>
  802889:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80288c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802890:	75 0a                	jne    80289c <alloc_block_FF+0xac>
	        return NULL;
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	e9 0e 04 00 00       	jmp    802caa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80289c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028a3:	a1 30 50 80 00       	mov    0x805030,%eax
  8028a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ab:	e9 f3 02 00 00       	jmp    802ba3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028b6:	83 ec 0c             	sub    $0xc,%esp
  8028b9:	ff 75 bc             	pushl  -0x44(%ebp)
  8028bc:	e8 af fb ff ff       	call   802470 <get_block_size>
  8028c1:	83 c4 10             	add    $0x10,%esp
  8028c4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	83 c0 08             	add    $0x8,%eax
  8028cd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028d0:	0f 87 c5 02 00 00    	ja     802b9b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	83 c0 18             	add    $0x18,%eax
  8028dc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028df:	0f 87 19 02 00 00    	ja     802afe <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8028e5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8028eb:	83 e8 08             	sub    $0x8,%eax
  8028ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8d 50 08             	lea    0x8(%eax),%edx
  8028f7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028fa:	01 d0                	add    %edx,%eax
  8028fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	83 c0 08             	add    $0x8,%eax
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	6a 01                	push   $0x1
  80290a:	50                   	push   %eax
  80290b:	ff 75 bc             	pushl  -0x44(%ebp)
  80290e:	e8 ae fe ff ff       	call   8027c1 <set_block_data>
  802913:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	85 c0                	test   %eax,%eax
  80291e:	75 68                	jne    802988 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802920:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802924:	75 17                	jne    80293d <alloc_block_FF+0x14d>
  802926:	83 ec 04             	sub    $0x4,%esp
  802929:	68 38 4a 80 00       	push   $0x804a38
  80292e:	68 d7 00 00 00       	push   $0xd7
  802933:	68 1d 4a 80 00       	push   $0x804a1d
  802938:	e8 93 de ff ff       	call   8007d0 <_panic>
  80293d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802943:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802946:	89 10                	mov    %edx,(%eax)
  802948:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0d                	je     80295e <alloc_block_FF+0x16e>
  802951:	a1 30 50 80 00       	mov    0x805030,%eax
  802956:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802959:	89 50 04             	mov    %edx,0x4(%eax)
  80295c:	eb 08                	jmp    802966 <alloc_block_FF+0x176>
  80295e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802961:	a3 34 50 80 00       	mov    %eax,0x805034
  802966:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802969:	a3 30 50 80 00       	mov    %eax,0x805030
  80296e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802978:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80297d:	40                   	inc    %eax
  80297e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802983:	e9 dc 00 00 00       	jmp    802a64 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	75 65                	jne    8029f6 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802991:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_FF+0x1be>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 6c 4a 80 00       	push   $0x804a6c
  80299f:	68 db 00 00 00       	push   $0xdb
  8029a4:	68 1d 4a 80 00       	push   $0x804a1d
  8029a9:	e8 22 de ff ff       	call   8007d0 <_panic>
  8029ae:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029bd:	8b 40 04             	mov    0x4(%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 0c                	je     8029d0 <alloc_block_FF+0x1e0>
  8029c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8029c9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029cc:	89 10                	mov    %edx,(%eax)
  8029ce:	eb 08                	jmp    8029d8 <alloc_block_FF+0x1e8>
  8029d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029db:	a3 34 50 80 00       	mov    %eax,0x805034
  8029e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029f4:	eb 6e                	jmp    802a64 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	74 06                	je     802a02 <alloc_block_FF+0x212>
  8029fc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_FF+0x229>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 90 4a 80 00       	push   $0x804a90
  802a0a:	68 df 00 00 00       	push   $0xdf
  802a0f:	68 1d 4a 80 00       	push   $0x804a1d
  802a14:	e8 b7 dd ff ff       	call   8007d0 <_panic>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 10                	mov    (%eax),%edx
  802a1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a21:	89 10                	mov    %edx,(%eax)
  802a23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 0b                	je     802a37 <alloc_block_FF+0x247>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	75 08                	jne    802a59 <alloc_block_FF+0x269>
  802a51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a54:	a3 34 50 80 00       	mov    %eax,0x805034
  802a59:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a5e:	40                   	inc    %eax
  802a5f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a68:	75 17                	jne    802a81 <alloc_block_FF+0x291>
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 ff 49 80 00       	push   $0x8049ff
  802a72:	68 e1 00 00 00       	push   $0xe1
  802a77:	68 1d 4a 80 00       	push   $0x804a1d
  802a7c:	e8 4f dd ff ff       	call   8007d0 <_panic>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	74 10                	je     802a9a <alloc_block_FF+0x2aa>
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a92:	8b 52 04             	mov    0x4(%edx),%edx
  802a95:	89 50 04             	mov    %edx,0x4(%eax)
  802a98:	eb 0b                	jmp    802aa5 <alloc_block_FF+0x2b5>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	a3 34 50 80 00       	mov    %eax,0x805034
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 0f                	je     802abe <alloc_block_FF+0x2ce>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab8:	8b 12                	mov    (%edx),%edx
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	eb 0a                	jmp    802ac8 <alloc_block_FF+0x2d8>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ae0:	48                   	dec    %eax
  802ae1:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802ae6:	83 ec 04             	sub    $0x4,%esp
  802ae9:	6a 00                	push   $0x0
  802aeb:	ff 75 b4             	pushl  -0x4c(%ebp)
  802aee:	ff 75 b0             	pushl  -0x50(%ebp)
  802af1:	e8 cb fc ff ff       	call   8027c1 <set_block_data>
  802af6:	83 c4 10             	add    $0x10,%esp
  802af9:	e9 95 00 00 00       	jmp    802b93 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	6a 01                	push   $0x1
  802b03:	ff 75 b8             	pushl  -0x48(%ebp)
  802b06:	ff 75 bc             	pushl  -0x44(%ebp)
  802b09:	e8 b3 fc ff ff       	call   8027c1 <set_block_data>
  802b0e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b15:	75 17                	jne    802b2e <alloc_block_FF+0x33e>
  802b17:	83 ec 04             	sub    $0x4,%esp
  802b1a:	68 ff 49 80 00       	push   $0x8049ff
  802b1f:	68 e8 00 00 00       	push   $0xe8
  802b24:	68 1d 4a 80 00       	push   $0x804a1d
  802b29:	e8 a2 dc ff ff       	call   8007d0 <_panic>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	74 10                	je     802b47 <alloc_block_FF+0x357>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3f:	8b 52 04             	mov    0x4(%edx),%edx
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
  802b45:	eb 0b                	jmp    802b52 <alloc_block_FF+0x362>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 40 04             	mov    0x4(%eax),%eax
  802b4d:	a3 34 50 80 00       	mov    %eax,0x805034
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0f                	je     802b6b <alloc_block_FF+0x37b>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 04             	mov    0x4(%eax),%eax
  802b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b65:	8b 12                	mov    (%edx),%edx
  802b67:	89 10                	mov    %edx,(%eax)
  802b69:	eb 0a                	jmp    802b75 <alloc_block_FF+0x385>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	a3 30 50 80 00       	mov    %eax,0x805030
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b8d:	48                   	dec    %eax
  802b8e:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802b93:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b96:	e9 0f 01 00 00       	jmp    802caa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba7:	74 07                	je     802bb0 <alloc_block_FF+0x3c0>
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	eb 05                	jmp    802bb5 <alloc_block_FF+0x3c5>
  802bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb5:	a3 38 50 80 00       	mov    %eax,0x805038
  802bba:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	0f 85 e9 fc ff ff    	jne    8028b0 <alloc_block_FF+0xc0>
  802bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcb:	0f 85 df fc ff ff    	jne    8028b0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	83 c0 08             	add    $0x8,%eax
  802bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bda:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802be1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802be4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802be7:	01 d0                	add    %edx,%eax
  802be9:	48                   	dec    %eax
  802bea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf5:	f7 75 d8             	divl   -0x28(%ebp)
  802bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bfb:	29 d0                	sub    %edx,%eax
  802bfd:	c1 e8 0c             	shr    $0xc,%eax
  802c00:	83 ec 0c             	sub    $0xc,%esp
  802c03:	50                   	push   %eax
  802c04:	e8 1e ec ff ff       	call   801827 <sbrk>
  802c09:	83 c4 10             	add    $0x10,%esp
  802c0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c0f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c13:	75 0a                	jne    802c1f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1a:	e9 8b 00 00 00       	jmp    802caa <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c1f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	48                   	dec    %eax
  802c2f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c35:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3a:	f7 75 cc             	divl   -0x34(%ebp)
  802c3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c40:	29 d0                	sub    %edx,%eax
  802c42:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c48:	01 d0                	add    %edx,%eax
  802c4a:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c4f:	a1 44 50 80 00       	mov    0x805044,%eax
  802c54:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c5a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c67:	01 d0                	add    %edx,%eax
  802c69:	48                   	dec    %eax
  802c6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c70:	ba 00 00 00 00       	mov    $0x0,%edx
  802c75:	f7 75 c4             	divl   -0x3c(%ebp)
  802c78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c7b:	29 d0                	sub    %edx,%eax
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	6a 01                	push   $0x1
  802c82:	50                   	push   %eax
  802c83:	ff 75 d0             	pushl  -0x30(%ebp)
  802c86:	e8 36 fb ff ff       	call   8027c1 <set_block_data>
  802c8b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c8e:	83 ec 0c             	sub    $0xc,%esp
  802c91:	ff 75 d0             	pushl  -0x30(%ebp)
  802c94:	e8 1b 0a 00 00       	call   8036b4 <free_block>
  802c99:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c9c:	83 ec 0c             	sub    $0xc,%esp
  802c9f:	ff 75 08             	pushl  0x8(%ebp)
  802ca2:	e8 49 fb ff ff       	call   8027f0 <alloc_block_FF>
  802ca7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802caa:	c9                   	leave  
  802cab:	c3                   	ret    

00802cac <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802cac:	55                   	push   %ebp
  802cad:	89 e5                	mov    %esp,%ebp
  802caf:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	83 e0 01             	and    $0x1,%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 03                	je     802cbf <alloc_block_BF+0x13>
  802cbc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cbf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cc3:	77 07                	ja     802ccc <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cc5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ccc:	a1 28 50 80 00       	mov    0x805028,%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	75 73                	jne    802d48 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	83 c0 10             	add    $0x10,%eax
  802cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cde:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ce5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ceb:	01 d0                	add    %edx,%eax
  802ced:	48                   	dec    %eax
  802cee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802cf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf9:	f7 75 e0             	divl   -0x20(%ebp)
  802cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cff:	29 d0                	sub    %edx,%eax
  802d01:	c1 e8 0c             	shr    $0xc,%eax
  802d04:	83 ec 0c             	sub    $0xc,%esp
  802d07:	50                   	push   %eax
  802d08:	e8 1a eb ff ff       	call   801827 <sbrk>
  802d0d:	83 c4 10             	add    $0x10,%esp
  802d10:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	6a 00                	push   $0x0
  802d18:	e8 0a eb ff ff       	call   801827 <sbrk>
  802d1d:	83 c4 10             	add    $0x10,%esp
  802d20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d26:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d29:	83 ec 08             	sub    $0x8,%esp
  802d2c:	50                   	push   %eax
  802d2d:	ff 75 d8             	pushl  -0x28(%ebp)
  802d30:	e8 9f f8 ff ff       	call   8025d4 <initialize_dynamic_allocator>
  802d35:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d38:	83 ec 0c             	sub    $0xc,%esp
  802d3b:	68 5b 4a 80 00       	push   $0x804a5b
  802d40:	e8 48 dd ff ff       	call   800a8d <cprintf>
  802d45:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d56:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d64:	a1 30 50 80 00       	mov    0x805030,%eax
  802d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6c:	e9 1d 01 00 00       	jmp    802e8e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	ff 75 a8             	pushl  -0x58(%ebp)
  802d7d:	e8 ee f6 ff ff       	call   802470 <get_block_size>
  802d82:	83 c4 10             	add    $0x10,%esp
  802d85:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	83 c0 08             	add    $0x8,%eax
  802d8e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d91:	0f 87 ef 00 00 00    	ja     802e86 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	83 c0 18             	add    $0x18,%eax
  802d9d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802da0:	77 1d                	ja     802dbf <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802da8:	0f 86 d8 00 00 00    	jbe    802e86 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802dae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802db4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dba:	e9 c7 00 00 00       	jmp    802e86 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	83 c0 08             	add    $0x8,%eax
  802dc5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dc8:	0f 85 9d 00 00 00    	jne    802e6b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	6a 01                	push   $0x1
  802dd3:	ff 75 a4             	pushl  -0x5c(%ebp)
  802dd6:	ff 75 a8             	pushl  -0x58(%ebp)
  802dd9:	e8 e3 f9 ff ff       	call   8027c1 <set_block_data>
  802dde:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de5:	75 17                	jne    802dfe <alloc_block_BF+0x152>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 ff 49 80 00       	push   $0x8049ff
  802def:	68 2c 01 00 00       	push   $0x12c
  802df4:	68 1d 4a 80 00       	push   $0x804a1d
  802df9:	e8 d2 d9 ff ff       	call   8007d0 <_panic>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 10                	je     802e17 <alloc_block_BF+0x16b>
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0f:	8b 52 04             	mov    0x4(%edx),%edx
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	eb 0b                	jmp    802e22 <alloc_block_BF+0x176>
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	a3 34 50 80 00       	mov    %eax,0x805034
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 0f                	je     802e3b <alloc_block_BF+0x18f>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 40 04             	mov    0x4(%eax),%eax
  802e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e35:	8b 12                	mov    (%edx),%edx
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	eb 0a                	jmp    802e45 <alloc_block_BF+0x199>
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	a3 30 50 80 00       	mov    %eax,0x805030
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e58:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e5d:	48                   	dec    %eax
  802e5e:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e63:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e66:	e9 24 04 00 00       	jmp    80328f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e71:	76 13                	jbe    802e86 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e73:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e7a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e80:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e83:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e86:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e92:	74 07                	je     802e9b <alloc_block_BF+0x1ef>
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	eb 05                	jmp    802ea0 <alloc_block_BF+0x1f4>
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea0:	a3 38 50 80 00       	mov    %eax,0x805038
  802ea5:	a1 38 50 80 00       	mov    0x805038,%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	0f 85 bf fe ff ff    	jne    802d71 <alloc_block_BF+0xc5>
  802eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb6:	0f 85 b5 fe ff ff    	jne    802d71 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec0:	0f 84 26 02 00 00    	je     8030ec <alloc_block_BF+0x440>
  802ec6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eca:	0f 85 1c 02 00 00    	jne    8030ec <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ed6:	83 e8 08             	sub    $0x8,%eax
  802ed9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	8d 50 08             	lea    0x8(%eax),%edx
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	01 d0                	add    %edx,%eax
  802ee7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	83 c0 08             	add    $0x8,%eax
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	6a 01                	push   $0x1
  802ef5:	50                   	push   %eax
  802ef6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ef9:	e8 c3 f8 ff ff       	call   8027c1 <set_block_data>
  802efe:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	75 68                	jne    802f73 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f0b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f0f:	75 17                	jne    802f28 <alloc_block_BF+0x27c>
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	68 38 4a 80 00       	push   $0x804a38
  802f19:	68 45 01 00 00       	push   $0x145
  802f1e:	68 1d 4a 80 00       	push   $0x804a1d
  802f23:	e8 a8 d8 ff ff       	call   8007d0 <_panic>
  802f28:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f31:	89 10                	mov    %edx,(%eax)
  802f33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0d                	je     802f49 <alloc_block_BF+0x29d>
  802f3c:	a1 30 50 80 00       	mov    0x805030,%eax
  802f41:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	eb 08                	jmp    802f51 <alloc_block_BF+0x2a5>
  802f49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f4c:	a3 34 50 80 00       	mov    %eax,0x805034
  802f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f54:	a3 30 50 80 00       	mov    %eax,0x805030
  802f59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f63:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f68:	40                   	inc    %eax
  802f69:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f6e:	e9 dc 00 00 00       	jmp    80304f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	75 65                	jne    802fe1 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f7c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f80:	75 17                	jne    802f99 <alloc_block_BF+0x2ed>
  802f82:	83 ec 04             	sub    $0x4,%esp
  802f85:	68 6c 4a 80 00       	push   $0x804a6c
  802f8a:	68 4a 01 00 00       	push   $0x14a
  802f8f:	68 1d 4a 80 00       	push   $0x804a1d
  802f94:	e8 37 d8 ff ff       	call   8007d0 <_panic>
  802f99:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802f9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 0c                	je     802fbb <alloc_block_BF+0x30f>
  802faf:	a1 34 50 80 00       	mov    0x805034,%eax
  802fb4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 08                	jmp    802fc3 <alloc_block_BF+0x317>
  802fbb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbe:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc6:	a3 34 50 80 00       	mov    %eax,0x805034
  802fcb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fd9:	40                   	inc    %eax
  802fda:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fdf:	eb 6e                	jmp    80304f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe5:	74 06                	je     802fed <alloc_block_BF+0x341>
  802fe7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802feb:	75 17                	jne    803004 <alloc_block_BF+0x358>
  802fed:	83 ec 04             	sub    $0x4,%esp
  802ff0:	68 90 4a 80 00       	push   $0x804a90
  802ff5:	68 4f 01 00 00       	push   $0x14f
  802ffa:	68 1d 4a 80 00       	push   $0x804a1d
  802fff:	e8 cc d7 ff ff       	call   8007d0 <_panic>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 10                	mov    (%eax),%edx
  803009:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0b                	je     803022 <alloc_block_BF+0x376>
  803017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803025:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803030:	89 50 04             	mov    %edx,0x4(%eax)
  803033:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	75 08                	jne    803044 <alloc_block_BF+0x398>
  80303c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303f:	a3 34 50 80 00       	mov    %eax,0x805034
  803044:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803049:	40                   	inc    %eax
  80304a:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80304f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803053:	75 17                	jne    80306c <alloc_block_BF+0x3c0>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 ff 49 80 00       	push   $0x8049ff
  80305d:	68 51 01 00 00       	push   $0x151
  803062:	68 1d 4a 80 00       	push   $0x804a1d
  803067:	e8 64 d7 ff ff       	call   8007d0 <_panic>
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 10                	je     803085 <alloc_block_BF+0x3d9>
  803075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307d:	8b 52 04             	mov    0x4(%edx),%edx
  803080:	89 50 04             	mov    %edx,0x4(%eax)
  803083:	eb 0b                	jmp    803090 <alloc_block_BF+0x3e4>
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	8b 40 04             	mov    0x4(%eax),%eax
  80308b:	a3 34 50 80 00       	mov    %eax,0x805034
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	74 0f                	je     8030a9 <alloc_block_BF+0x3fd>
  80309a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a3:	8b 12                	mov    (%edx),%edx
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	eb 0a                	jmp    8030b3 <alloc_block_BF+0x407>
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030cb:	48                   	dec    %eax
  8030cc:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	6a 00                	push   $0x0
  8030d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8030d9:	ff 75 cc             	pushl  -0x34(%ebp)
  8030dc:	e8 e0 f6 ff ff       	call   8027c1 <set_block_data>
  8030e1:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	e9 a3 01 00 00       	jmp    80328f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8030ec:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8030f0:	0f 85 9d 00 00 00    	jne    803193 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	6a 01                	push   $0x1
  8030fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8030fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803101:	e8 bb f6 ff ff       	call   8027c1 <set_block_data>
  803106:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310d:	75 17                	jne    803126 <alloc_block_BF+0x47a>
  80310f:	83 ec 04             	sub    $0x4,%esp
  803112:	68 ff 49 80 00       	push   $0x8049ff
  803117:	68 58 01 00 00       	push   $0x158
  80311c:	68 1d 4a 80 00       	push   $0x804a1d
  803121:	e8 aa d6 ff ff       	call   8007d0 <_panic>
  803126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 10                	je     80313f <alloc_block_BF+0x493>
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803137:	8b 52 04             	mov    0x4(%edx),%edx
  80313a:	89 50 04             	mov    %edx,0x4(%eax)
  80313d:	eb 0b                	jmp    80314a <alloc_block_BF+0x49e>
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	a3 34 50 80 00       	mov    %eax,0x805034
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0f                	je     803163 <alloc_block_BF+0x4b7>
  803154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315d:	8b 12                	mov    (%edx),%edx
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	eb 0a                	jmp    80316d <alloc_block_BF+0x4c1>
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	a3 30 50 80 00       	mov    %eax,0x805030
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803180:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803185:	48                   	dec    %eax
  803186:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	e9 fc 00 00 00       	jmp    80328f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	83 c0 08             	add    $0x8,%eax
  803199:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80319c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031a9:	01 d0                	add    %edx,%eax
  8031ab:	48                   	dec    %eax
  8031ac:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8031b7:	f7 75 c4             	divl   -0x3c(%ebp)
  8031ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031bd:	29 d0                	sub    %edx,%eax
  8031bf:	c1 e8 0c             	shr    $0xc,%eax
  8031c2:	83 ec 0c             	sub    $0xc,%esp
  8031c5:	50                   	push   %eax
  8031c6:	e8 5c e6 ff ff       	call   801827 <sbrk>
  8031cb:	83 c4 10             	add    $0x10,%esp
  8031ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031d1:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8031d5:	75 0a                	jne    8031e1 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8031d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031dc:	e9 ae 00 00 00       	jmp    80328f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8031e1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8031e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031ee:	01 d0                	add    %edx,%eax
  8031f0:	48                   	dec    %eax
  8031f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8031fc:	f7 75 b8             	divl   -0x48(%ebp)
  8031ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803202:	29 d0                	sub    %edx,%eax
  803204:	8d 50 fc             	lea    -0x4(%eax),%edx
  803207:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80320a:	01 d0                	add    %edx,%eax
  80320c:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803211:	a1 44 50 80 00       	mov    0x805044,%eax
  803216:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80321c:	83 ec 0c             	sub    $0xc,%esp
  80321f:	68 c4 4a 80 00       	push   $0x804ac4
  803224:	e8 64 d8 ff ff       	call   800a8d <cprintf>
  803229:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80322c:	83 ec 08             	sub    $0x8,%esp
  80322f:	ff 75 bc             	pushl  -0x44(%ebp)
  803232:	68 c9 4a 80 00       	push   $0x804ac9
  803237:	e8 51 d8 ff ff       	call   800a8d <cprintf>
  80323c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80323f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803246:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803249:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80324c:	01 d0                	add    %edx,%eax
  80324e:	48                   	dec    %eax
  80324f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803252:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803255:	ba 00 00 00 00       	mov    $0x0,%edx
  80325a:	f7 75 b0             	divl   -0x50(%ebp)
  80325d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803260:	29 d0                	sub    %edx,%eax
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	6a 01                	push   $0x1
  803267:	50                   	push   %eax
  803268:	ff 75 bc             	pushl  -0x44(%ebp)
  80326b:	e8 51 f5 ff ff       	call   8027c1 <set_block_data>
  803270:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803273:	83 ec 0c             	sub    $0xc,%esp
  803276:	ff 75 bc             	pushl  -0x44(%ebp)
  803279:	e8 36 04 00 00       	call   8036b4 <free_block>
  80327e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803281:	83 ec 0c             	sub    $0xc,%esp
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	e8 20 fa ff ff       	call   802cac <alloc_block_BF>
  80328c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80328f:	c9                   	leave  
  803290:	c3                   	ret    

00803291 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803291:	55                   	push   %ebp
  803292:	89 e5                	mov    %esp,%ebp
  803294:	53                   	push   %ebx
  803295:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80329f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032aa:	74 1e                	je     8032ca <merging+0x39>
  8032ac:	ff 75 08             	pushl  0x8(%ebp)
  8032af:	e8 bc f1 ff ff       	call   802470 <get_block_size>
  8032b4:	83 c4 04             	add    $0x4,%esp
  8032b7:	89 c2                	mov    %eax,%edx
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	01 d0                	add    %edx,%eax
  8032be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8032c1:	75 07                	jne    8032ca <merging+0x39>
		prev_is_free = 1;
  8032c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8032ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032ce:	74 1e                	je     8032ee <merging+0x5d>
  8032d0:	ff 75 10             	pushl  0x10(%ebp)
  8032d3:	e8 98 f1 ff ff       	call   802470 <get_block_size>
  8032d8:	83 c4 04             	add    $0x4,%esp
  8032db:	89 c2                	mov    %eax,%edx
  8032dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032e5:	75 07                	jne    8032ee <merging+0x5d>
		next_is_free = 1;
  8032e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8032ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f2:	0f 84 cc 00 00 00    	je     8033c4 <merging+0x133>
  8032f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032fc:	0f 84 c2 00 00 00    	je     8033c4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803302:	ff 75 08             	pushl  0x8(%ebp)
  803305:	e8 66 f1 ff ff       	call   802470 <get_block_size>
  80330a:	83 c4 04             	add    $0x4,%esp
  80330d:	89 c3                	mov    %eax,%ebx
  80330f:	ff 75 10             	pushl  0x10(%ebp)
  803312:	e8 59 f1 ff ff       	call   802470 <get_block_size>
  803317:	83 c4 04             	add    $0x4,%esp
  80331a:	01 c3                	add    %eax,%ebx
  80331c:	ff 75 0c             	pushl  0xc(%ebp)
  80331f:	e8 4c f1 ff ff       	call   802470 <get_block_size>
  803324:	83 c4 04             	add    $0x4,%esp
  803327:	01 d8                	add    %ebx,%eax
  803329:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80332c:	6a 00                	push   $0x0
  80332e:	ff 75 ec             	pushl  -0x14(%ebp)
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	e8 88 f4 ff ff       	call   8027c1 <set_block_data>
  803339:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80333c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803340:	75 17                	jne    803359 <merging+0xc8>
  803342:	83 ec 04             	sub    $0x4,%esp
  803345:	68 ff 49 80 00       	push   $0x8049ff
  80334a:	68 7d 01 00 00       	push   $0x17d
  80334f:	68 1d 4a 80 00       	push   $0x804a1d
  803354:	e8 77 d4 ff ff       	call   8007d0 <_panic>
  803359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	74 10                	je     803372 <merging+0xe1>
  803362:	8b 45 0c             	mov    0xc(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80336a:	8b 52 04             	mov    0x4(%edx),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	eb 0b                	jmp    80337d <merging+0xec>
  803372:	8b 45 0c             	mov    0xc(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	a3 34 50 80 00       	mov    %eax,0x805034
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	74 0f                	je     803396 <merging+0x105>
  803387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338a:	8b 40 04             	mov    0x4(%eax),%eax
  80338d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803390:	8b 12                	mov    (%edx),%edx
  803392:	89 10                	mov    %edx,(%eax)
  803394:	eb 0a                	jmp    8033a0 <merging+0x10f>
  803396:	8b 45 0c             	mov    0xc(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033b8:	48                   	dec    %eax
  8033b9:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8033be:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033bf:	e9 ea 02 00 00       	jmp    8036ae <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8033c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c8:	74 3b                	je     803405 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8033ca:	83 ec 0c             	sub    $0xc,%esp
  8033cd:	ff 75 08             	pushl  0x8(%ebp)
  8033d0:	e8 9b f0 ff ff       	call   802470 <get_block_size>
  8033d5:	83 c4 10             	add    $0x10,%esp
  8033d8:	89 c3                	mov    %eax,%ebx
  8033da:	83 ec 0c             	sub    $0xc,%esp
  8033dd:	ff 75 10             	pushl  0x10(%ebp)
  8033e0:	e8 8b f0 ff ff       	call   802470 <get_block_size>
  8033e5:	83 c4 10             	add    $0x10,%esp
  8033e8:	01 d8                	add    %ebx,%eax
  8033ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033ed:	83 ec 04             	sub    $0x4,%esp
  8033f0:	6a 00                	push   $0x0
  8033f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8033f5:	ff 75 08             	pushl  0x8(%ebp)
  8033f8:	e8 c4 f3 ff ff       	call   8027c1 <set_block_data>
  8033fd:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803400:	e9 a9 02 00 00       	jmp    8036ae <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803409:	0f 84 2d 01 00 00    	je     80353c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80340f:	83 ec 0c             	sub    $0xc,%esp
  803412:	ff 75 10             	pushl  0x10(%ebp)
  803415:	e8 56 f0 ff ff       	call   802470 <get_block_size>
  80341a:	83 c4 10             	add    $0x10,%esp
  80341d:	89 c3                	mov    %eax,%ebx
  80341f:	83 ec 0c             	sub    $0xc,%esp
  803422:	ff 75 0c             	pushl  0xc(%ebp)
  803425:	e8 46 f0 ff ff       	call   802470 <get_block_size>
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	01 d8                	add    %ebx,%eax
  80342f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	6a 00                	push   $0x0
  803437:	ff 75 e4             	pushl  -0x1c(%ebp)
  80343a:	ff 75 10             	pushl  0x10(%ebp)
  80343d:	e8 7f f3 ff ff       	call   8027c1 <set_block_data>
  803442:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803445:	8b 45 10             	mov    0x10(%ebp),%eax
  803448:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80344b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344f:	74 06                	je     803457 <merging+0x1c6>
  803451:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803455:	75 17                	jne    80346e <merging+0x1dd>
  803457:	83 ec 04             	sub    $0x4,%esp
  80345a:	68 d8 4a 80 00       	push   $0x804ad8
  80345f:	68 8d 01 00 00       	push   $0x18d
  803464:	68 1d 4a 80 00       	push   $0x804a1d
  803469:	e8 62 d3 ff ff       	call   8007d0 <_panic>
  80346e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803471:	8b 50 04             	mov    0x4(%eax),%edx
  803474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803477:	89 50 04             	mov    %edx,0x4(%eax)
  80347a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803480:	89 10                	mov    %edx,(%eax)
  803482:	8b 45 0c             	mov    0xc(%ebp),%eax
  803485:	8b 40 04             	mov    0x4(%eax),%eax
  803488:	85 c0                	test   %eax,%eax
  80348a:	74 0d                	je     803499 <merging+0x208>
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803495:	89 10                	mov    %edx,(%eax)
  803497:	eb 08                	jmp    8034a1 <merging+0x210>
  803499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349c:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b9:	75 17                	jne    8034d2 <merging+0x241>
  8034bb:	83 ec 04             	sub    $0x4,%esp
  8034be:	68 ff 49 80 00       	push   $0x8049ff
  8034c3:	68 8e 01 00 00       	push   $0x18e
  8034c8:	68 1d 4a 80 00       	push   $0x804a1d
  8034cd:	e8 fe d2 ff ff       	call   8007d0 <_panic>
  8034d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 10                	je     8034eb <merging+0x25a>
  8034db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034de:	8b 00                	mov    (%eax),%eax
  8034e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e3:	8b 52 04             	mov    0x4(%edx),%edx
  8034e6:	89 50 04             	mov    %edx,0x4(%eax)
  8034e9:	eb 0b                	jmp    8034f6 <merging+0x265>
  8034eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ee:	8b 40 04             	mov    0x4(%eax),%eax
  8034f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8034f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f9:	8b 40 04             	mov    0x4(%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 0f                	je     80350f <merging+0x27e>
  803500:	8b 45 0c             	mov    0xc(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	8b 55 0c             	mov    0xc(%ebp),%edx
  803509:	8b 12                	mov    (%edx),%edx
  80350b:	89 10                	mov    %edx,(%eax)
  80350d:	eb 0a                	jmp    803519 <merging+0x288>
  80350f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	a3 30 50 80 00       	mov    %eax,0x805030
  803519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803531:	48                   	dec    %eax
  803532:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803537:	e9 72 01 00 00       	jmp    8036ae <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80353c:	8b 45 10             	mov    0x10(%ebp),%eax
  80353f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803546:	74 79                	je     8035c1 <merging+0x330>
  803548:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80354c:	74 73                	je     8035c1 <merging+0x330>
  80354e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803552:	74 06                	je     80355a <merging+0x2c9>
  803554:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803558:	75 17                	jne    803571 <merging+0x2e0>
  80355a:	83 ec 04             	sub    $0x4,%esp
  80355d:	68 90 4a 80 00       	push   $0x804a90
  803562:	68 94 01 00 00       	push   $0x194
  803567:	68 1d 4a 80 00       	push   $0x804a1d
  80356c:	e8 5f d2 ff ff       	call   8007d0 <_panic>
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	8b 10                	mov    (%eax),%edx
  803576:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803579:	89 10                	mov    %edx,(%eax)
  80357b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	85 c0                	test   %eax,%eax
  803582:	74 0b                	je     80358f <merging+0x2fe>
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80358c:	89 50 04             	mov    %edx,0x4(%eax)
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803595:	89 10                	mov    %edx,(%eax)
  803597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359a:	8b 55 08             	mov    0x8(%ebp),%edx
  80359d:	89 50 04             	mov    %edx,0x4(%eax)
  8035a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	75 08                	jne    8035b1 <merging+0x320>
  8035a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ac:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035b6:	40                   	inc    %eax
  8035b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035bc:	e9 ce 00 00 00       	jmp    80368f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8035c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c5:	74 65                	je     80362c <merging+0x39b>
  8035c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035cb:	75 17                	jne    8035e4 <merging+0x353>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 6c 4a 80 00       	push   $0x804a6c
  8035d5:	68 95 01 00 00       	push   $0x195
  8035da:	68 1d 4a 80 00       	push   $0x804a1d
  8035df:	e8 ec d1 ff ff       	call   8007d0 <_panic>
  8035e4:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8035ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ed:	89 50 04             	mov    %edx,0x4(%eax)
  8035f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f3:	8b 40 04             	mov    0x4(%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 0c                	je     803606 <merging+0x375>
  8035fa:	a1 34 50 80 00       	mov    0x805034,%eax
  8035ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803602:	89 10                	mov    %edx,(%eax)
  803604:	eb 08                	jmp    80360e <merging+0x37d>
  803606:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803609:	a3 30 50 80 00       	mov    %eax,0x805030
  80360e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803611:	a3 34 50 80 00       	mov    %eax,0x805034
  803616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803624:	40                   	inc    %eax
  803625:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80362a:	eb 63                	jmp    80368f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80362c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803630:	75 17                	jne    803649 <merging+0x3b8>
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	68 38 4a 80 00       	push   $0x804a38
  80363a:	68 98 01 00 00       	push   $0x198
  80363f:	68 1d 4a 80 00       	push   $0x804a1d
  803644:	e8 87 d1 ff ff       	call   8007d0 <_panic>
  803649:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80364f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803652:	89 10                	mov    %edx,(%eax)
  803654:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	74 0d                	je     80366a <merging+0x3d9>
  80365d:	a1 30 50 80 00       	mov    0x805030,%eax
  803662:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	eb 08                	jmp    803672 <merging+0x3e1>
  80366a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80366d:	a3 34 50 80 00       	mov    %eax,0x805034
  803672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803675:	a3 30 50 80 00       	mov    %eax,0x805030
  80367a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803684:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803689:	40                   	inc    %eax
  80368a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80368f:	83 ec 0c             	sub    $0xc,%esp
  803692:	ff 75 10             	pushl  0x10(%ebp)
  803695:	e8 d6 ed ff ff       	call   802470 <get_block_size>
  80369a:	83 c4 10             	add    $0x10,%esp
  80369d:	83 ec 04             	sub    $0x4,%esp
  8036a0:	6a 00                	push   $0x0
  8036a2:	50                   	push   %eax
  8036a3:	ff 75 10             	pushl  0x10(%ebp)
  8036a6:	e8 16 f1 ff ff       	call   8027c1 <set_block_data>
  8036ab:	83 c4 10             	add    $0x10,%esp
	}
}
  8036ae:	90                   	nop
  8036af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036b2:	c9                   	leave  
  8036b3:	c3                   	ret    

008036b4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036b4:	55                   	push   %ebp
  8036b5:	89 e5                	mov    %esp,%ebp
  8036b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036ba:	a1 30 50 80 00       	mov    0x805030,%eax
  8036bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8036c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ca:	73 1b                	jae    8036e7 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8036cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d1:	83 ec 04             	sub    $0x4,%esp
  8036d4:	ff 75 08             	pushl  0x8(%ebp)
  8036d7:	6a 00                	push   $0x0
  8036d9:	50                   	push   %eax
  8036da:	e8 b2 fb ff ff       	call   803291 <merging>
  8036df:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036e2:	e9 8b 00 00 00       	jmp    803772 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8036e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ef:	76 18                	jbe    803709 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8036f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	ff 75 08             	pushl  0x8(%ebp)
  8036fc:	50                   	push   %eax
  8036fd:	6a 00                	push   $0x0
  8036ff:	e8 8d fb ff ff       	call   803291 <merging>
  803704:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803707:	eb 69                	jmp    803772 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803709:	a1 30 50 80 00       	mov    0x805030,%eax
  80370e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803711:	eb 39                	jmp    80374c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	3b 45 08             	cmp    0x8(%ebp),%eax
  803719:	73 29                	jae    803744 <free_block+0x90>
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 00                	mov    (%eax),%eax
  803720:	3b 45 08             	cmp    0x8(%ebp),%eax
  803723:	76 1f                	jbe    803744 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	ff 75 08             	pushl  0x8(%ebp)
  803733:	ff 75 f0             	pushl  -0x10(%ebp)
  803736:	ff 75 f4             	pushl  -0xc(%ebp)
  803739:	e8 53 fb ff ff       	call   803291 <merging>
  80373e:	83 c4 10             	add    $0x10,%esp
			break;
  803741:	90                   	nop
		}
	}
}
  803742:	eb 2e                	jmp    803772 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803744:	a1 38 50 80 00       	mov    0x805038,%eax
  803749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803750:	74 07                	je     803759 <free_block+0xa5>
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	eb 05                	jmp    80375e <free_block+0xaa>
  803759:	b8 00 00 00 00       	mov    $0x0,%eax
  80375e:	a3 38 50 80 00       	mov    %eax,0x805038
  803763:	a1 38 50 80 00       	mov    0x805038,%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	75 a7                	jne    803713 <free_block+0x5f>
  80376c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803770:	75 a1                	jne    803713 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803772:	90                   	nop
  803773:	c9                   	leave  
  803774:	c3                   	ret    

00803775 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80377b:	ff 75 08             	pushl  0x8(%ebp)
  80377e:	e8 ed ec ff ff       	call   802470 <get_block_size>
  803783:	83 c4 04             	add    $0x4,%esp
  803786:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803789:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803790:	eb 17                	jmp    8037a9 <copy_data+0x34>
  803792:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803795:	8b 45 0c             	mov    0xc(%ebp),%eax
  803798:	01 c2                	add    %eax,%edx
  80379a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	01 c8                	add    %ecx,%eax
  8037a2:	8a 00                	mov    (%eax),%al
  8037a4:	88 02                	mov    %al,(%edx)
  8037a6:	ff 45 fc             	incl   -0x4(%ebp)
  8037a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037af:	72 e1                	jb     803792 <copy_data+0x1d>
}
  8037b1:	90                   	nop
  8037b2:	c9                   	leave  
  8037b3:	c3                   	ret    

008037b4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037b4:	55                   	push   %ebp
  8037b5:	89 e5                	mov    %esp,%ebp
  8037b7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037be:	75 23                	jne    8037e3 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8037c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037c4:	74 13                	je     8037d9 <realloc_block_FF+0x25>
  8037c6:	83 ec 0c             	sub    $0xc,%esp
  8037c9:	ff 75 0c             	pushl  0xc(%ebp)
  8037cc:	e8 1f f0 ff ff       	call   8027f0 <alloc_block_FF>
  8037d1:	83 c4 10             	add    $0x10,%esp
  8037d4:	e9 f4 06 00 00       	jmp    803ecd <realloc_block_FF+0x719>
		return NULL;
  8037d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037de:	e9 ea 06 00 00       	jmp    803ecd <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8037e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037e7:	75 18                	jne    803801 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8037e9:	83 ec 0c             	sub    $0xc,%esp
  8037ec:	ff 75 08             	pushl  0x8(%ebp)
  8037ef:	e8 c0 fe ff ff       	call   8036b4 <free_block>
  8037f4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fc:	e9 cc 06 00 00       	jmp    803ecd <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803801:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803805:	77 07                	ja     80380e <realloc_block_FF+0x5a>
  803807:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80380e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803811:	83 e0 01             	and    $0x1,%eax
  803814:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381a:	83 c0 08             	add    $0x8,%eax
  80381d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803820:	83 ec 0c             	sub    $0xc,%esp
  803823:	ff 75 08             	pushl  0x8(%ebp)
  803826:	e8 45 ec ff ff       	call   802470 <get_block_size>
  80382b:	83 c4 10             	add    $0x10,%esp
  80382e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803834:	83 e8 08             	sub    $0x8,%eax
  803837:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	83 e8 04             	sub    $0x4,%eax
  803840:	8b 00                	mov    (%eax),%eax
  803842:	83 e0 fe             	and    $0xfffffffe,%eax
  803845:	89 c2                	mov    %eax,%edx
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	01 d0                	add    %edx,%eax
  80384c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80384f:	83 ec 0c             	sub    $0xc,%esp
  803852:	ff 75 e4             	pushl  -0x1c(%ebp)
  803855:	e8 16 ec ff ff       	call   802470 <get_block_size>
  80385a:	83 c4 10             	add    $0x10,%esp
  80385d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803863:	83 e8 08             	sub    $0x8,%eax
  803866:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80386f:	75 08                	jne    803879 <realloc_block_FF+0xc5>
	{
		 return va;
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	e9 54 06 00 00       	jmp    803ecd <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80387f:	0f 83 e5 03 00 00    	jae    803c6a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803888:	2b 45 0c             	sub    0xc(%ebp),%eax
  80388b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80388e:	83 ec 0c             	sub    $0xc,%esp
  803891:	ff 75 e4             	pushl  -0x1c(%ebp)
  803894:	e8 f0 eb ff ff       	call   802489 <is_free_block>
  803899:	83 c4 10             	add    $0x10,%esp
  80389c:	84 c0                	test   %al,%al
  80389e:	0f 84 3b 01 00 00    	je     8039df <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038aa:	01 d0                	add    %edx,%eax
  8038ac:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	6a 01                	push   $0x1
  8038b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b7:	ff 75 08             	pushl  0x8(%ebp)
  8038ba:	e8 02 ef ff ff       	call   8027c1 <set_block_data>
  8038bf:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	83 e8 04             	sub    $0x4,%eax
  8038c8:	8b 00                	mov    (%eax),%eax
  8038ca:	83 e0 fe             	and    $0xfffffffe,%eax
  8038cd:	89 c2                	mov    %eax,%edx
  8038cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d2:	01 d0                	add    %edx,%eax
  8038d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	6a 00                	push   $0x0
  8038dc:	ff 75 cc             	pushl  -0x34(%ebp)
  8038df:	ff 75 c8             	pushl  -0x38(%ebp)
  8038e2:	e8 da ee ff ff       	call   8027c1 <set_block_data>
  8038e7:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ee:	74 06                	je     8038f6 <realloc_block_FF+0x142>
  8038f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8038f4:	75 17                	jne    80390d <realloc_block_FF+0x159>
  8038f6:	83 ec 04             	sub    $0x4,%esp
  8038f9:	68 90 4a 80 00       	push   $0x804a90
  8038fe:	68 f6 01 00 00       	push   $0x1f6
  803903:	68 1d 4a 80 00       	push   $0x804a1d
  803908:	e8 c3 ce ff ff       	call   8007d0 <_panic>
  80390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803910:	8b 10                	mov    (%eax),%edx
  803912:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803915:	89 10                	mov    %edx,(%eax)
  803917:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 0b                	je     80392b <realloc_block_FF+0x177>
  803920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803928:	89 50 04             	mov    %edx,0x4(%eax)
  80392b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803931:	89 10                	mov    %edx,(%eax)
  803933:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803936:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803939:	89 50 04             	mov    %edx,0x4(%eax)
  80393c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	75 08                	jne    80394d <realloc_block_FF+0x199>
  803945:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803948:	a3 34 50 80 00       	mov    %eax,0x805034
  80394d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803952:	40                   	inc    %eax
  803953:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80395c:	75 17                	jne    803975 <realloc_block_FF+0x1c1>
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	68 ff 49 80 00       	push   $0x8049ff
  803966:	68 f7 01 00 00       	push   $0x1f7
  80396b:	68 1d 4a 80 00       	push   $0x804a1d
  803970:	e8 5b ce ff ff       	call   8007d0 <_panic>
  803975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	74 10                	je     80398e <realloc_block_FF+0x1da>
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803986:	8b 52 04             	mov    0x4(%edx),%edx
  803989:	89 50 04             	mov    %edx,0x4(%eax)
  80398c:	eb 0b                	jmp    803999 <realloc_block_FF+0x1e5>
  80398e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803991:	8b 40 04             	mov    0x4(%eax),%eax
  803994:	a3 34 50 80 00       	mov    %eax,0x805034
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	8b 40 04             	mov    0x4(%eax),%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	74 0f                	je     8039b2 <realloc_block_FF+0x1fe>
  8039a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a6:	8b 40 04             	mov    0x4(%eax),%eax
  8039a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ac:	8b 12                	mov    (%edx),%edx
  8039ae:	89 10                	mov    %edx,(%eax)
  8039b0:	eb 0a                	jmp    8039bc <realloc_block_FF+0x208>
  8039b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b5:	8b 00                	mov    (%eax),%eax
  8039b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8039bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039d4:	48                   	dec    %eax
  8039d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8039da:	e9 83 02 00 00       	jmp    803c62 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8039df:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8039e3:	0f 86 69 02 00 00    	jbe    803c52 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8039e9:	83 ec 04             	sub    $0x4,%esp
  8039ec:	6a 01                	push   $0x1
  8039ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8039f1:	ff 75 08             	pushl  0x8(%ebp)
  8039f4:	e8 c8 ed ff ff       	call   8027c1 <set_block_data>
  8039f9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	83 e8 04             	sub    $0x4,%eax
  803a02:	8b 00                	mov    (%eax),%eax
  803a04:	83 e0 fe             	and    $0xfffffffe,%eax
  803a07:	89 c2                	mov    %eax,%edx
  803a09:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0c:	01 d0                	add    %edx,%eax
  803a0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a11:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a16:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a1d:	75 68                	jne    803a87 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a1f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a23:	75 17                	jne    803a3c <realloc_block_FF+0x288>
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 38 4a 80 00       	push   $0x804a38
  803a2d:	68 06 02 00 00       	push   $0x206
  803a32:	68 1d 4a 80 00       	push   $0x804a1d
  803a37:	e8 94 cd ff ff       	call   8007d0 <_panic>
  803a3c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a45:	89 10                	mov    %edx,(%eax)
  803a47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	74 0d                	je     803a5d <realloc_block_FF+0x2a9>
  803a50:	a1 30 50 80 00       	mov    0x805030,%eax
  803a55:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a58:	89 50 04             	mov    %edx,0x4(%eax)
  803a5b:	eb 08                	jmp    803a65 <realloc_block_FF+0x2b1>
  803a5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a60:	a3 34 50 80 00       	mov    %eax,0x805034
  803a65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a68:	a3 30 50 80 00       	mov    %eax,0x805030
  803a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a77:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a7c:	40                   	inc    %eax
  803a7d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a82:	e9 b0 01 00 00       	jmp    803c37 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a87:	a1 30 50 80 00       	mov    0x805030,%eax
  803a8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a8f:	76 68                	jbe    803af9 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a95:	75 17                	jne    803aae <realloc_block_FF+0x2fa>
  803a97:	83 ec 04             	sub    $0x4,%esp
  803a9a:	68 38 4a 80 00       	push   $0x804a38
  803a9f:	68 0b 02 00 00       	push   $0x20b
  803aa4:	68 1d 4a 80 00       	push   $0x804a1d
  803aa9:	e8 22 cd ff ff       	call   8007d0 <_panic>
  803aae:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ab4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab7:	89 10                	mov    %edx,(%eax)
  803ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abc:	8b 00                	mov    (%eax),%eax
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	74 0d                	je     803acf <realloc_block_FF+0x31b>
  803ac2:	a1 30 50 80 00       	mov    0x805030,%eax
  803ac7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aca:	89 50 04             	mov    %edx,0x4(%eax)
  803acd:	eb 08                	jmp    803ad7 <realloc_block_FF+0x323>
  803acf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad2:	a3 34 50 80 00       	mov    %eax,0x805034
  803ad7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ada:	a3 30 50 80 00       	mov    %eax,0x805030
  803adf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aee:	40                   	inc    %eax
  803aef:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803af4:	e9 3e 01 00 00       	jmp    803c37 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803af9:	a1 30 50 80 00       	mov    0x805030,%eax
  803afe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b01:	73 68                	jae    803b6b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b07:	75 17                	jne    803b20 <realloc_block_FF+0x36c>
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	68 6c 4a 80 00       	push   $0x804a6c
  803b11:	68 10 02 00 00       	push   $0x210
  803b16:	68 1d 4a 80 00       	push   $0x804a1d
  803b1b:	e8 b0 cc ff ff       	call   8007d0 <_panic>
  803b20:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b29:	89 50 04             	mov    %edx,0x4(%eax)
  803b2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2f:	8b 40 04             	mov    0x4(%eax),%eax
  803b32:	85 c0                	test   %eax,%eax
  803b34:	74 0c                	je     803b42 <realloc_block_FF+0x38e>
  803b36:	a1 34 50 80 00       	mov    0x805034,%eax
  803b3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b3e:	89 10                	mov    %edx,(%eax)
  803b40:	eb 08                	jmp    803b4a <realloc_block_FF+0x396>
  803b42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b45:	a3 30 50 80 00       	mov    %eax,0x805030
  803b4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4d:	a3 34 50 80 00       	mov    %eax,0x805034
  803b52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b5b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b60:	40                   	inc    %eax
  803b61:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b66:	e9 cc 00 00 00       	jmp    803c37 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b72:	a1 30 50 80 00       	mov    0x805030,%eax
  803b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b7a:	e9 8a 00 00 00       	jmp    803c09 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b82:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b85:	73 7a                	jae    803c01 <realloc_block_FF+0x44d>
  803b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8a:	8b 00                	mov    (%eax),%eax
  803b8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b8f:	73 70                	jae    803c01 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b95:	74 06                	je     803b9d <realloc_block_FF+0x3e9>
  803b97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b9b:	75 17                	jne    803bb4 <realloc_block_FF+0x400>
  803b9d:	83 ec 04             	sub    $0x4,%esp
  803ba0:	68 90 4a 80 00       	push   $0x804a90
  803ba5:	68 1a 02 00 00       	push   $0x21a
  803baa:	68 1d 4a 80 00       	push   $0x804a1d
  803baf:	e8 1c cc ff ff       	call   8007d0 <_panic>
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 10                	mov    (%eax),%edx
  803bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbc:	89 10                	mov    %edx,(%eax)
  803bbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc1:	8b 00                	mov    (%eax),%eax
  803bc3:	85 c0                	test   %eax,%eax
  803bc5:	74 0b                	je     803bd2 <realloc_block_FF+0x41e>
  803bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bca:	8b 00                	mov    (%eax),%eax
  803bcc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bcf:	89 50 04             	mov    %edx,0x4(%eax)
  803bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bd8:	89 10                	mov    %edx,(%eax)
  803bda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803be0:	89 50 04             	mov    %edx,0x4(%eax)
  803be3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	75 08                	jne    803bf4 <realloc_block_FF+0x440>
  803bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bef:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bf9:	40                   	inc    %eax
  803bfa:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803bff:	eb 36                	jmp    803c37 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c01:	a1 38 50 80 00       	mov    0x805038,%eax
  803c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0d:	74 07                	je     803c16 <realloc_block_FF+0x462>
  803c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c12:	8b 00                	mov    (%eax),%eax
  803c14:	eb 05                	jmp    803c1b <realloc_block_FF+0x467>
  803c16:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1b:	a3 38 50 80 00       	mov    %eax,0x805038
  803c20:	a1 38 50 80 00       	mov    0x805038,%eax
  803c25:	85 c0                	test   %eax,%eax
  803c27:	0f 85 52 ff ff ff    	jne    803b7f <realloc_block_FF+0x3cb>
  803c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c31:	0f 85 48 ff ff ff    	jne    803b7f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c37:	83 ec 04             	sub    $0x4,%esp
  803c3a:	6a 00                	push   $0x0
  803c3c:	ff 75 d8             	pushl  -0x28(%ebp)
  803c3f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c42:	e8 7a eb ff ff       	call   8027c1 <set_block_data>
  803c47:	83 c4 10             	add    $0x10,%esp
				return va;
  803c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4d:	e9 7b 02 00 00       	jmp    803ecd <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c52:	83 ec 0c             	sub    $0xc,%esp
  803c55:	68 0d 4b 80 00       	push   $0x804b0d
  803c5a:	e8 2e ce ff ff       	call   800a8d <cprintf>
  803c5f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c62:	8b 45 08             	mov    0x8(%ebp),%eax
  803c65:	e9 63 02 00 00       	jmp    803ecd <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c70:	0f 86 4d 02 00 00    	jbe    803ec3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803c76:	83 ec 0c             	sub    $0xc,%esp
  803c79:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c7c:	e8 08 e8 ff ff       	call   802489 <is_free_block>
  803c81:	83 c4 10             	add    $0x10,%esp
  803c84:	84 c0                	test   %al,%al
  803c86:	0f 84 37 02 00 00    	je     803ec3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c9b:	76 38                	jbe    803cd5 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803c9d:	83 ec 0c             	sub    $0xc,%esp
  803ca0:	ff 75 08             	pushl  0x8(%ebp)
  803ca3:	e8 0c fa ff ff       	call   8036b4 <free_block>
  803ca8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803cab:	83 ec 0c             	sub    $0xc,%esp
  803cae:	ff 75 0c             	pushl  0xc(%ebp)
  803cb1:	e8 3a eb ff ff       	call   8027f0 <alloc_block_FF>
  803cb6:	83 c4 10             	add    $0x10,%esp
  803cb9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803cbc:	83 ec 08             	sub    $0x8,%esp
  803cbf:	ff 75 c0             	pushl  -0x40(%ebp)
  803cc2:	ff 75 08             	pushl  0x8(%ebp)
  803cc5:	e8 ab fa ff ff       	call   803775 <copy_data>
  803cca:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ccd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803cd0:	e9 f8 01 00 00       	jmp    803ecd <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803cdb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803cde:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ce2:	0f 87 a0 00 00 00    	ja     803d88 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ce8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cec:	75 17                	jne    803d05 <realloc_block_FF+0x551>
  803cee:	83 ec 04             	sub    $0x4,%esp
  803cf1:	68 ff 49 80 00       	push   $0x8049ff
  803cf6:	68 38 02 00 00       	push   $0x238
  803cfb:	68 1d 4a 80 00       	push   $0x804a1d
  803d00:	e8 cb ca ff ff       	call   8007d0 <_panic>
  803d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d08:	8b 00                	mov    (%eax),%eax
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	74 10                	je     803d1e <realloc_block_FF+0x56a>
  803d0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d11:	8b 00                	mov    (%eax),%eax
  803d13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d16:	8b 52 04             	mov    0x4(%edx),%edx
  803d19:	89 50 04             	mov    %edx,0x4(%eax)
  803d1c:	eb 0b                	jmp    803d29 <realloc_block_FF+0x575>
  803d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d21:	8b 40 04             	mov    0x4(%eax),%eax
  803d24:	a3 34 50 80 00       	mov    %eax,0x805034
  803d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2c:	8b 40 04             	mov    0x4(%eax),%eax
  803d2f:	85 c0                	test   %eax,%eax
  803d31:	74 0f                	je     803d42 <realloc_block_FF+0x58e>
  803d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d36:	8b 40 04             	mov    0x4(%eax),%eax
  803d39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d3c:	8b 12                	mov    (%edx),%edx
  803d3e:	89 10                	mov    %edx,(%eax)
  803d40:	eb 0a                	jmp    803d4c <realloc_block_FF+0x598>
  803d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	a3 30 50 80 00       	mov    %eax,0x805030
  803d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d5f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d64:	48                   	dec    %eax
  803d65:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d70:	01 d0                	add    %edx,%eax
  803d72:	83 ec 04             	sub    $0x4,%esp
  803d75:	6a 01                	push   $0x1
  803d77:	50                   	push   %eax
  803d78:	ff 75 08             	pushl  0x8(%ebp)
  803d7b:	e8 41 ea ff ff       	call   8027c1 <set_block_data>
  803d80:	83 c4 10             	add    $0x10,%esp
  803d83:	e9 36 01 00 00       	jmp    803ebe <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d8b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d8e:	01 d0                	add    %edx,%eax
  803d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d93:	83 ec 04             	sub    $0x4,%esp
  803d96:	6a 01                	push   $0x1
  803d98:	ff 75 f0             	pushl  -0x10(%ebp)
  803d9b:	ff 75 08             	pushl  0x8(%ebp)
  803d9e:	e8 1e ea ff ff       	call   8027c1 <set_block_data>
  803da3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803da6:	8b 45 08             	mov    0x8(%ebp),%eax
  803da9:	83 e8 04             	sub    $0x4,%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	83 e0 fe             	and    $0xfffffffe,%eax
  803db1:	89 c2                	mov    %eax,%edx
  803db3:	8b 45 08             	mov    0x8(%ebp),%eax
  803db6:	01 d0                	add    %edx,%eax
  803db8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803dbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dbf:	74 06                	je     803dc7 <realloc_block_FF+0x613>
  803dc1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803dc5:	75 17                	jne    803dde <realloc_block_FF+0x62a>
  803dc7:	83 ec 04             	sub    $0x4,%esp
  803dca:	68 90 4a 80 00       	push   $0x804a90
  803dcf:	68 44 02 00 00       	push   $0x244
  803dd4:	68 1d 4a 80 00       	push   $0x804a1d
  803dd9:	e8 f2 c9 ff ff       	call   8007d0 <_panic>
  803dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de1:	8b 10                	mov    (%eax),%edx
  803de3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803de6:	89 10                	mov    %edx,(%eax)
  803de8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803deb:	8b 00                	mov    (%eax),%eax
  803ded:	85 c0                	test   %eax,%eax
  803def:	74 0b                	je     803dfc <realloc_block_FF+0x648>
  803df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df4:	8b 00                	mov    (%eax),%eax
  803df6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803df9:	89 50 04             	mov    %edx,0x4(%eax)
  803dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dff:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e02:	89 10                	mov    %edx,(%eax)
  803e04:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e0a:	89 50 04             	mov    %edx,0x4(%eax)
  803e0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e10:	8b 00                	mov    (%eax),%eax
  803e12:	85 c0                	test   %eax,%eax
  803e14:	75 08                	jne    803e1e <realloc_block_FF+0x66a>
  803e16:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e19:	a3 34 50 80 00       	mov    %eax,0x805034
  803e1e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e23:	40                   	inc    %eax
  803e24:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e2d:	75 17                	jne    803e46 <realloc_block_FF+0x692>
  803e2f:	83 ec 04             	sub    $0x4,%esp
  803e32:	68 ff 49 80 00       	push   $0x8049ff
  803e37:	68 45 02 00 00       	push   $0x245
  803e3c:	68 1d 4a 80 00       	push   $0x804a1d
  803e41:	e8 8a c9 ff ff       	call   8007d0 <_panic>
  803e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e49:	8b 00                	mov    (%eax),%eax
  803e4b:	85 c0                	test   %eax,%eax
  803e4d:	74 10                	je     803e5f <realloc_block_FF+0x6ab>
  803e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e52:	8b 00                	mov    (%eax),%eax
  803e54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e57:	8b 52 04             	mov    0x4(%edx),%edx
  803e5a:	89 50 04             	mov    %edx,0x4(%eax)
  803e5d:	eb 0b                	jmp    803e6a <realloc_block_FF+0x6b6>
  803e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e62:	8b 40 04             	mov    0x4(%eax),%eax
  803e65:	a3 34 50 80 00       	mov    %eax,0x805034
  803e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6d:	8b 40 04             	mov    0x4(%eax),%eax
  803e70:	85 c0                	test   %eax,%eax
  803e72:	74 0f                	je     803e83 <realloc_block_FF+0x6cf>
  803e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e77:	8b 40 04             	mov    0x4(%eax),%eax
  803e7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e7d:	8b 12                	mov    (%edx),%edx
  803e7f:	89 10                	mov    %edx,(%eax)
  803e81:	eb 0a                	jmp    803e8d <realloc_block_FF+0x6d9>
  803e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e86:	8b 00                	mov    (%eax),%eax
  803e88:	a3 30 50 80 00       	mov    %eax,0x805030
  803e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ea5:	48                   	dec    %eax
  803ea6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803eab:	83 ec 04             	sub    $0x4,%esp
  803eae:	6a 00                	push   $0x0
  803eb0:	ff 75 bc             	pushl  -0x44(%ebp)
  803eb3:	ff 75 b8             	pushl  -0x48(%ebp)
  803eb6:	e8 06 e9 ff ff       	call   8027c1 <set_block_data>
  803ebb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec1:	eb 0a                	jmp    803ecd <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ec3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803eca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ecd:	c9                   	leave  
  803ece:	c3                   	ret    

00803ecf <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ecf:	55                   	push   %ebp
  803ed0:	89 e5                	mov    %esp,%ebp
  803ed2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ed5:	83 ec 04             	sub    $0x4,%esp
  803ed8:	68 14 4b 80 00       	push   $0x804b14
  803edd:	68 58 02 00 00       	push   $0x258
  803ee2:	68 1d 4a 80 00       	push   $0x804a1d
  803ee7:	e8 e4 c8 ff ff       	call   8007d0 <_panic>

00803eec <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803eec:	55                   	push   %ebp
  803eed:	89 e5                	mov    %esp,%ebp
  803eef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ef2:	83 ec 04             	sub    $0x4,%esp
  803ef5:	68 3c 4b 80 00       	push   $0x804b3c
  803efa:	68 61 02 00 00       	push   $0x261
  803eff:	68 1d 4a 80 00       	push   $0x804a1d
  803f04:	e8 c7 c8 ff ff       	call   8007d0 <_panic>

00803f09 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803f09:	55                   	push   %ebp
  803f0a:	89 e5                	mov    %esp,%ebp
  803f0c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803f0f:	83 ec 04             	sub    $0x4,%esp
  803f12:	68 64 4b 80 00       	push   $0x804b64
  803f17:	6a 09                	push   $0x9
  803f19:	68 8c 4b 80 00       	push   $0x804b8c
  803f1e:	e8 ad c8 ff ff       	call   8007d0 <_panic>

00803f23 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803f23:	55                   	push   %ebp
  803f24:	89 e5                	mov    %esp,%ebp
  803f26:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803f29:	83 ec 04             	sub    $0x4,%esp
  803f2c:	68 9c 4b 80 00       	push   $0x804b9c
  803f31:	6a 10                	push   $0x10
  803f33:	68 8c 4b 80 00       	push   $0x804b8c
  803f38:	e8 93 c8 ff ff       	call   8007d0 <_panic>

00803f3d <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803f3d:	55                   	push   %ebp
  803f3e:	89 e5                	mov    %esp,%ebp
  803f40:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803f43:	83 ec 04             	sub    $0x4,%esp
  803f46:	68 c4 4b 80 00       	push   $0x804bc4
  803f4b:	6a 18                	push   $0x18
  803f4d:	68 8c 4b 80 00       	push   $0x804b8c
  803f52:	e8 79 c8 ff ff       	call   8007d0 <_panic>

00803f57 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803f57:	55                   	push   %ebp
  803f58:	89 e5                	mov    %esp,%ebp
  803f5a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803f5d:	83 ec 04             	sub    $0x4,%esp
  803f60:	68 ec 4b 80 00       	push   $0x804bec
  803f65:	6a 20                	push   $0x20
  803f67:	68 8c 4b 80 00       	push   $0x804b8c
  803f6c:	e8 5f c8 ff ff       	call   8007d0 <_panic>

00803f71 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803f71:	55                   	push   %ebp
  803f72:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803f74:	8b 45 08             	mov    0x8(%ebp),%eax
  803f77:	8b 40 10             	mov    0x10(%eax),%eax
}
  803f7a:	5d                   	pop    %ebp
  803f7b:	c3                   	ret    

00803f7c <__udivdi3>:
  803f7c:	55                   	push   %ebp
  803f7d:	57                   	push   %edi
  803f7e:	56                   	push   %esi
  803f7f:	53                   	push   %ebx
  803f80:	83 ec 1c             	sub    $0x1c,%esp
  803f83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f93:	89 ca                	mov    %ecx,%edx
  803f95:	89 f8                	mov    %edi,%eax
  803f97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f9b:	85 f6                	test   %esi,%esi
  803f9d:	75 2d                	jne    803fcc <__udivdi3+0x50>
  803f9f:	39 cf                	cmp    %ecx,%edi
  803fa1:	77 65                	ja     804008 <__udivdi3+0x8c>
  803fa3:	89 fd                	mov    %edi,%ebp
  803fa5:	85 ff                	test   %edi,%edi
  803fa7:	75 0b                	jne    803fb4 <__udivdi3+0x38>
  803fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  803fae:	31 d2                	xor    %edx,%edx
  803fb0:	f7 f7                	div    %edi
  803fb2:	89 c5                	mov    %eax,%ebp
  803fb4:	31 d2                	xor    %edx,%edx
  803fb6:	89 c8                	mov    %ecx,%eax
  803fb8:	f7 f5                	div    %ebp
  803fba:	89 c1                	mov    %eax,%ecx
  803fbc:	89 d8                	mov    %ebx,%eax
  803fbe:	f7 f5                	div    %ebp
  803fc0:	89 cf                	mov    %ecx,%edi
  803fc2:	89 fa                	mov    %edi,%edx
  803fc4:	83 c4 1c             	add    $0x1c,%esp
  803fc7:	5b                   	pop    %ebx
  803fc8:	5e                   	pop    %esi
  803fc9:	5f                   	pop    %edi
  803fca:	5d                   	pop    %ebp
  803fcb:	c3                   	ret    
  803fcc:	39 ce                	cmp    %ecx,%esi
  803fce:	77 28                	ja     803ff8 <__udivdi3+0x7c>
  803fd0:	0f bd fe             	bsr    %esi,%edi
  803fd3:	83 f7 1f             	xor    $0x1f,%edi
  803fd6:	75 40                	jne    804018 <__udivdi3+0x9c>
  803fd8:	39 ce                	cmp    %ecx,%esi
  803fda:	72 0a                	jb     803fe6 <__udivdi3+0x6a>
  803fdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fe0:	0f 87 9e 00 00 00    	ja     804084 <__udivdi3+0x108>
  803fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  803feb:	89 fa                	mov    %edi,%edx
  803fed:	83 c4 1c             	add    $0x1c,%esp
  803ff0:	5b                   	pop    %ebx
  803ff1:	5e                   	pop    %esi
  803ff2:	5f                   	pop    %edi
  803ff3:	5d                   	pop    %ebp
  803ff4:	c3                   	ret    
  803ff5:	8d 76 00             	lea    0x0(%esi),%esi
  803ff8:	31 ff                	xor    %edi,%edi
  803ffa:	31 c0                	xor    %eax,%eax
  803ffc:	89 fa                	mov    %edi,%edx
  803ffe:	83 c4 1c             	add    $0x1c,%esp
  804001:	5b                   	pop    %ebx
  804002:	5e                   	pop    %esi
  804003:	5f                   	pop    %edi
  804004:	5d                   	pop    %ebp
  804005:	c3                   	ret    
  804006:	66 90                	xchg   %ax,%ax
  804008:	89 d8                	mov    %ebx,%eax
  80400a:	f7 f7                	div    %edi
  80400c:	31 ff                	xor    %edi,%edi
  80400e:	89 fa                	mov    %edi,%edx
  804010:	83 c4 1c             	add    $0x1c,%esp
  804013:	5b                   	pop    %ebx
  804014:	5e                   	pop    %esi
  804015:	5f                   	pop    %edi
  804016:	5d                   	pop    %ebp
  804017:	c3                   	ret    
  804018:	bd 20 00 00 00       	mov    $0x20,%ebp
  80401d:	89 eb                	mov    %ebp,%ebx
  80401f:	29 fb                	sub    %edi,%ebx
  804021:	89 f9                	mov    %edi,%ecx
  804023:	d3 e6                	shl    %cl,%esi
  804025:	89 c5                	mov    %eax,%ebp
  804027:	88 d9                	mov    %bl,%cl
  804029:	d3 ed                	shr    %cl,%ebp
  80402b:	89 e9                	mov    %ebp,%ecx
  80402d:	09 f1                	or     %esi,%ecx
  80402f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804033:	89 f9                	mov    %edi,%ecx
  804035:	d3 e0                	shl    %cl,%eax
  804037:	89 c5                	mov    %eax,%ebp
  804039:	89 d6                	mov    %edx,%esi
  80403b:	88 d9                	mov    %bl,%cl
  80403d:	d3 ee                	shr    %cl,%esi
  80403f:	89 f9                	mov    %edi,%ecx
  804041:	d3 e2                	shl    %cl,%edx
  804043:	8b 44 24 08          	mov    0x8(%esp),%eax
  804047:	88 d9                	mov    %bl,%cl
  804049:	d3 e8                	shr    %cl,%eax
  80404b:	09 c2                	or     %eax,%edx
  80404d:	89 d0                	mov    %edx,%eax
  80404f:	89 f2                	mov    %esi,%edx
  804051:	f7 74 24 0c          	divl   0xc(%esp)
  804055:	89 d6                	mov    %edx,%esi
  804057:	89 c3                	mov    %eax,%ebx
  804059:	f7 e5                	mul    %ebp
  80405b:	39 d6                	cmp    %edx,%esi
  80405d:	72 19                	jb     804078 <__udivdi3+0xfc>
  80405f:	74 0b                	je     80406c <__udivdi3+0xf0>
  804061:	89 d8                	mov    %ebx,%eax
  804063:	31 ff                	xor    %edi,%edi
  804065:	e9 58 ff ff ff       	jmp    803fc2 <__udivdi3+0x46>
  80406a:	66 90                	xchg   %ax,%ax
  80406c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804070:	89 f9                	mov    %edi,%ecx
  804072:	d3 e2                	shl    %cl,%edx
  804074:	39 c2                	cmp    %eax,%edx
  804076:	73 e9                	jae    804061 <__udivdi3+0xe5>
  804078:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80407b:	31 ff                	xor    %edi,%edi
  80407d:	e9 40 ff ff ff       	jmp    803fc2 <__udivdi3+0x46>
  804082:	66 90                	xchg   %ax,%ax
  804084:	31 c0                	xor    %eax,%eax
  804086:	e9 37 ff ff ff       	jmp    803fc2 <__udivdi3+0x46>
  80408b:	90                   	nop

0080408c <__umoddi3>:
  80408c:	55                   	push   %ebp
  80408d:	57                   	push   %edi
  80408e:	56                   	push   %esi
  80408f:	53                   	push   %ebx
  804090:	83 ec 1c             	sub    $0x1c,%esp
  804093:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804097:	8b 74 24 34          	mov    0x34(%esp),%esi
  80409b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80409f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040ab:	89 f3                	mov    %esi,%ebx
  8040ad:	89 fa                	mov    %edi,%edx
  8040af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040b3:	89 34 24             	mov    %esi,(%esp)
  8040b6:	85 c0                	test   %eax,%eax
  8040b8:	75 1a                	jne    8040d4 <__umoddi3+0x48>
  8040ba:	39 f7                	cmp    %esi,%edi
  8040bc:	0f 86 a2 00 00 00    	jbe    804164 <__umoddi3+0xd8>
  8040c2:	89 c8                	mov    %ecx,%eax
  8040c4:	89 f2                	mov    %esi,%edx
  8040c6:	f7 f7                	div    %edi
  8040c8:	89 d0                	mov    %edx,%eax
  8040ca:	31 d2                	xor    %edx,%edx
  8040cc:	83 c4 1c             	add    $0x1c,%esp
  8040cf:	5b                   	pop    %ebx
  8040d0:	5e                   	pop    %esi
  8040d1:	5f                   	pop    %edi
  8040d2:	5d                   	pop    %ebp
  8040d3:	c3                   	ret    
  8040d4:	39 f0                	cmp    %esi,%eax
  8040d6:	0f 87 ac 00 00 00    	ja     804188 <__umoddi3+0xfc>
  8040dc:	0f bd e8             	bsr    %eax,%ebp
  8040df:	83 f5 1f             	xor    $0x1f,%ebp
  8040e2:	0f 84 ac 00 00 00    	je     804194 <__umoddi3+0x108>
  8040e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8040ed:	29 ef                	sub    %ebp,%edi
  8040ef:	89 fe                	mov    %edi,%esi
  8040f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040f5:	89 e9                	mov    %ebp,%ecx
  8040f7:	d3 e0                	shl    %cl,%eax
  8040f9:	89 d7                	mov    %edx,%edi
  8040fb:	89 f1                	mov    %esi,%ecx
  8040fd:	d3 ef                	shr    %cl,%edi
  8040ff:	09 c7                	or     %eax,%edi
  804101:	89 e9                	mov    %ebp,%ecx
  804103:	d3 e2                	shl    %cl,%edx
  804105:	89 14 24             	mov    %edx,(%esp)
  804108:	89 d8                	mov    %ebx,%eax
  80410a:	d3 e0                	shl    %cl,%eax
  80410c:	89 c2                	mov    %eax,%edx
  80410e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804112:	d3 e0                	shl    %cl,%eax
  804114:	89 44 24 04          	mov    %eax,0x4(%esp)
  804118:	8b 44 24 08          	mov    0x8(%esp),%eax
  80411c:	89 f1                	mov    %esi,%ecx
  80411e:	d3 e8                	shr    %cl,%eax
  804120:	09 d0                	or     %edx,%eax
  804122:	d3 eb                	shr    %cl,%ebx
  804124:	89 da                	mov    %ebx,%edx
  804126:	f7 f7                	div    %edi
  804128:	89 d3                	mov    %edx,%ebx
  80412a:	f7 24 24             	mull   (%esp)
  80412d:	89 c6                	mov    %eax,%esi
  80412f:	89 d1                	mov    %edx,%ecx
  804131:	39 d3                	cmp    %edx,%ebx
  804133:	0f 82 87 00 00 00    	jb     8041c0 <__umoddi3+0x134>
  804139:	0f 84 91 00 00 00    	je     8041d0 <__umoddi3+0x144>
  80413f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804143:	29 f2                	sub    %esi,%edx
  804145:	19 cb                	sbb    %ecx,%ebx
  804147:	89 d8                	mov    %ebx,%eax
  804149:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80414d:	d3 e0                	shl    %cl,%eax
  80414f:	89 e9                	mov    %ebp,%ecx
  804151:	d3 ea                	shr    %cl,%edx
  804153:	09 d0                	or     %edx,%eax
  804155:	89 e9                	mov    %ebp,%ecx
  804157:	d3 eb                	shr    %cl,%ebx
  804159:	89 da                	mov    %ebx,%edx
  80415b:	83 c4 1c             	add    $0x1c,%esp
  80415e:	5b                   	pop    %ebx
  80415f:	5e                   	pop    %esi
  804160:	5f                   	pop    %edi
  804161:	5d                   	pop    %ebp
  804162:	c3                   	ret    
  804163:	90                   	nop
  804164:	89 fd                	mov    %edi,%ebp
  804166:	85 ff                	test   %edi,%edi
  804168:	75 0b                	jne    804175 <__umoddi3+0xe9>
  80416a:	b8 01 00 00 00       	mov    $0x1,%eax
  80416f:	31 d2                	xor    %edx,%edx
  804171:	f7 f7                	div    %edi
  804173:	89 c5                	mov    %eax,%ebp
  804175:	89 f0                	mov    %esi,%eax
  804177:	31 d2                	xor    %edx,%edx
  804179:	f7 f5                	div    %ebp
  80417b:	89 c8                	mov    %ecx,%eax
  80417d:	f7 f5                	div    %ebp
  80417f:	89 d0                	mov    %edx,%eax
  804181:	e9 44 ff ff ff       	jmp    8040ca <__umoddi3+0x3e>
  804186:	66 90                	xchg   %ax,%ax
  804188:	89 c8                	mov    %ecx,%eax
  80418a:	89 f2                	mov    %esi,%edx
  80418c:	83 c4 1c             	add    $0x1c,%esp
  80418f:	5b                   	pop    %ebx
  804190:	5e                   	pop    %esi
  804191:	5f                   	pop    %edi
  804192:	5d                   	pop    %ebp
  804193:	c3                   	ret    
  804194:	3b 04 24             	cmp    (%esp),%eax
  804197:	72 06                	jb     80419f <__umoddi3+0x113>
  804199:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80419d:	77 0f                	ja     8041ae <__umoddi3+0x122>
  80419f:	89 f2                	mov    %esi,%edx
  8041a1:	29 f9                	sub    %edi,%ecx
  8041a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041a7:	89 14 24             	mov    %edx,(%esp)
  8041aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041b2:	8b 14 24             	mov    (%esp),%edx
  8041b5:	83 c4 1c             	add    $0x1c,%esp
  8041b8:	5b                   	pop    %ebx
  8041b9:	5e                   	pop    %esi
  8041ba:	5f                   	pop    %edi
  8041bb:	5d                   	pop    %ebp
  8041bc:	c3                   	ret    
  8041bd:	8d 76 00             	lea    0x0(%esi),%esi
  8041c0:	2b 04 24             	sub    (%esp),%eax
  8041c3:	19 fa                	sbb    %edi,%edx
  8041c5:	89 d1                	mov    %edx,%ecx
  8041c7:	89 c6                	mov    %eax,%esi
  8041c9:	e9 71 ff ff ff       	jmp    80413f <__umoddi3+0xb3>
  8041ce:	66 90                	xchg   %ax,%ax
  8041d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041d4:	72 ea                	jb     8041c0 <__umoddi3+0x134>
  8041d6:	89 d9                	mov    %ebx,%ecx
  8041d8:	e9 62 ff ff ff       	jmp    80413f <__umoddi3+0xb3>

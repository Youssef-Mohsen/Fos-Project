
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
  800044:	e8 13 20 00 00       	call   80205c <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb f5 42 80 00       	mov    $0x8042f5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb ff 42 80 00       	mov    $0x8042ff,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 0b 43 80 00       	mov    $0x80430b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 1a 43 80 00       	mov    $0x80431a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 29 43 80 00       	mov    $0x804329,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 3e 43 80 00       	mov    $0x80433e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 53 43 80 00       	mov    $0x804353,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 64 43 80 00       	mov    $0x804364,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 75 43 80 00       	mov    $0x804375,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 86 43 80 00       	mov    $0x804386,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 8f 43 80 00       	mov    $0x80438f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 99 43 80 00       	mov    $0x804399,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb a4 43 80 00       	mov    $0x8043a4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb b0 43 80 00       	mov    $0x8043b0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb ba 43 80 00       	mov    $0x8043ba,%ebx
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
  8001c1:	bb c4 43 80 00       	mov    $0x8043c4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb d2 43 80 00       	mov    $0x8043d2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb e1 43 80 00       	mov    $0x8043e1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb e8 43 80 00       	mov    $0x8043e8,%ebx
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
  800225:	e8 d6 19 00 00       	call   801c00 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 c1 19 00 00       	call   801c00 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 ac 19 00 00       	call   801c00 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 94 19 00 00       	call   801c00 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 7c 19 00 00       	call   801c00 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 64 19 00 00       	call   801c00 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 4c 19 00 00       	call   801c00 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 34 19 00 00       	call   801c00 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 1c 19 00 00       	call   801c00 <sget>
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
  8002fe:	e8 f6 3b 00 00       	call   803ef9 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 da 3b 00 00       	call   803ef9 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 be 3b 00 00       	call   803ef9 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 a2 3b 00 00       	call   803ef9 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 86 3b 00 00       	call   803ef9 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 c0 3b 00 00       	call   803f44 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 af 3b 00 00       	call   803f44 <wait_semaphore>
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
  8003c4:	e8 fd 3b 00 00       	call   803fc6 <signal_semaphore>
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
  800407:	e8 38 3b 00 00       	call   803f44 <wait_semaphore>
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
  800467:	e8 5a 3b 00 00       	call   803fc6 <signal_semaphore>
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
  80047d:	e8 c2 3a 00 00       	call   803f44 <wait_semaphore>
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
  8004dd:	e8 e4 3a 00 00       	call   803fc6 <signal_semaphore>
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
  8004f3:	e8 4c 3a 00 00       	call   803f44 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 3b 3a 00 00       	call   803f44 <wait_semaphore>
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
  8005bb:	e8 06 3a 00 00       	call   803fc6 <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 f5 39 00 00       	call   803fc6 <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 c0 42 80 00       	push   $0x8042c0
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 e0 42 80 00       	push   $0x8042e0
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb ef 43 80 00       	mov    $0x8043ef,%ebx
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
  800662:	e8 92 38 00 00       	call   803ef9 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 4e 39 00 00       	call   803fc6 <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 3d 39 00 00       	call   803fc6 <signal_semaphore>
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
  800697:	e8 a7 19 00 00       	call   802043 <sys_getenvindex>
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
  800705:	e8 bd 16 00 00       	call   801dc7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 28 44 80 00       	push   $0x804428
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
  800735:	68 50 44 80 00       	push   $0x804450
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
  800766:	68 78 44 80 00       	push   $0x804478
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 d0 44 80 00       	push   $0x8044d0
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 28 44 80 00       	push   $0x804428
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 3d 16 00 00       	call   801de1 <sys_unlock_cons>
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
  8007b7:	e8 53 18 00 00       	call   80200f <sys_destroy_env>
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
  8007c8:	e8 a8 18 00 00       	call   802075 <sys_exit_env>
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
  8007f1:	68 e4 44 80 00       	push   $0x8044e4
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 e9 44 80 00       	push   $0x8044e9
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
  80082e:	68 05 45 80 00       	push   $0x804505
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
  80085d:	68 08 45 80 00       	push   $0x804508
  800862:	6a 26                	push   $0x26
  800864:	68 54 45 80 00       	push   $0x804554
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
  800932:	68 60 45 80 00       	push   $0x804560
  800937:	6a 3a                	push   $0x3a
  800939:	68 54 45 80 00       	push   $0x804554
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
  8009a5:	68 b4 45 80 00       	push   $0x8045b4
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 54 45 80 00       	push   $0x804554
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
  8009ff:	e8 81 13 00 00       	call   801d85 <sys_cputs>
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
  800a76:	e8 0a 13 00 00       	call   801d85 <sys_cputs>
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
  800ac0:	e8 02 13 00 00       	call   801dc7 <sys_lock_cons>
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
  800ae0:	e8 fc 12 00 00       	call   801de1 <sys_unlock_cons>
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
  800b2a:	e8 15 35 00 00       	call   804044 <__udivdi3>
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
  800b7a:	e8 d5 35 00 00       	call   804154 <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 14 48 80 00       	add    $0x804814,%eax
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
  800cd5:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
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
  800db6:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 25 48 80 00       	push   $0x804825
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
  800ddb:	68 2e 48 80 00       	push   $0x80482e
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
  800e08:	be 31 48 80 00       	mov    $0x804831,%esi
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
  801813:	68 a8 49 80 00       	push   $0x8049a8
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 ca 49 80 00       	push   $0x8049ca
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
  801833:	e8 f8 0a 00 00       	call   802330 <sys_sbrk>
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
  8018ae:	e8 01 09 00 00       	call   8021b4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 dd 0e 00 00       	call   80279f <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 13 09 00 00       	call   8021e5 <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 76 13 00 00       	call   802c5b <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	05 00 10 00 00       	add    $0x1000,%eax
  801947:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80194a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  8019ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ee:	75 16                	jne    801a06 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8019f0:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8019f7:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8019fe:	0f 86 15 ff ff ff    	jbe    801919 <malloc+0xdc>
  801a04:	eb 01                	jmp    801a07 <malloc+0x1ca>
				}
				

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
  801a46:	e8 1c 09 00 00       	call   802367 <sys_allocate_user_mem>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	eb 07                	jmp    801a57 <malloc+0x21a>
		
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
  801a8e:	e8 8c 09 00 00       	call   80241f <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 9c 1b 00 00       	call   803640 <free_block>
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
  801ad9:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801b16:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801b1d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	e8 1a 08 00 00       	call   80234b <sys_free_user_mem>
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
  801b44:	68 d8 49 80 00       	push   $0x8049d8
  801b49:	68 87 00 00 00       	push   $0x87
  801b4e:	68 02 4a 80 00       	push   $0x804a02
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
  801b72:	e9 87 00 00 00       	jmp    801bfe <smalloc+0xa3>
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
  801ba3:	75 07                	jne    801bac <smalloc+0x51>
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  801baa:	eb 52                	jmp    801bfe <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801bac:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bb0:	ff 75 ec             	pushl  -0x14(%ebp)
  801bb3:	50                   	push   %eax
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	e8 93 03 00 00       	call   801f52 <sys_createSharedObject>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801bc5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801bc9:	74 06                	je     801bd1 <smalloc+0x76>
  801bcb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bcf:	75 07                	jne    801bd8 <smalloc+0x7d>
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	eb 26                	jmp    801bfe <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801bd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bdb:	a1 20 50 80 00       	mov    0x805020,%eax
  801be0:	8b 40 78             	mov    0x78(%eax),%eax
  801be3:	29 c2                	sub    %eax,%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bec:	c1 e8 0c             	shr    $0xc,%eax
  801bef:	89 c2                	mov    %eax,%edx
  801bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	e8 68 03 00 00       	call   801f7c <sys_getSizeOfSharedObject>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c1a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c1e:	75 07                	jne    801c27 <sget+0x27>
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	eb 7f                	jmp    801ca6 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c2d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3a:	39 d0                	cmp    %edx,%eax
  801c3c:	73 02                	jae    801c40 <sget+0x40>
  801c3e:	89 d0                	mov    %edx,%eax
  801c40:	83 ec 0c             	sub    $0xc,%esp
  801c43:	50                   	push   %eax
  801c44:	e8 f4 fb ff ff       	call   80183d <malloc>
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801c4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c53:	75 07                	jne    801c5c <sget+0x5c>
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	eb 4a                	jmp    801ca6 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	ff 75 e8             	pushl  -0x18(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	e8 2c 03 00 00       	call   801f99 <sys_getSharedObject>
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801c73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c76:	a1 20 50 80 00       	mov    0x805020,%eax
  801c7b:	8b 40 78             	mov    0x78(%eax),%eax
  801c7e:	29 c2                	sub    %eax,%edx
  801c80:	89 d0                	mov    %edx,%eax
  801c82:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c87:	c1 e8 0c             	shr    $0xc,%eax
  801c8a:	89 c2                	mov    %eax,%edx
  801c8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c8f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c96:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c9a:	75 07                	jne    801ca3 <sget+0xa3>
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca1:	eb 03                	jmp    801ca6 <sget+0xa6>
	return ptr;
  801ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801cae:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb1:	a1 20 50 80 00       	mov    0x805020,%eax
  801cb6:	8b 40 78             	mov    0x78(%eax),%eax
  801cb9:	29 c2                	sub    %eax,%edx
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cc2:	c1 e8 0c             	shr    $0xc,%eax
  801cc5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801ccf:	83 ec 08             	sub    $0x8,%esp
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd8:	e8 db 02 00 00       	call   801fb8 <sys_freeSharedObject>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801ce3:	90                   	nop
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 10 4a 80 00       	push   $0x804a10
  801cf4:	68 e4 00 00 00       	push   $0xe4
  801cf9:	68 02 4a 80 00       	push   $0x804a02
  801cfe:	e8 cd ea ff ff       	call   8007d0 <_panic>

00801d03 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 36 4a 80 00       	push   $0x804a36
  801d11:	68 f0 00 00 00       	push   $0xf0
  801d16:	68 02 4a 80 00       	push   $0x804a02
  801d1b:	e8 b0 ea ff ff       	call   8007d0 <_panic>

00801d20 <shrink>:

}
void shrink(uint32 newSize)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 36 4a 80 00       	push   $0x804a36
  801d2e:	68 f5 00 00 00       	push   $0xf5
  801d33:	68 02 4a 80 00       	push   $0x804a02
  801d38:	e8 93 ea ff ff       	call   8007d0 <_panic>

00801d3d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	68 36 4a 80 00       	push   $0x804a36
  801d4b:	68 fa 00 00 00       	push   $0xfa
  801d50:	68 02 4a 80 00       	push   $0x804a02
  801d55:	e8 76 ea ff ff       	call   8007d0 <_panic>

00801d5a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	57                   	push   %edi
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d72:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d75:	cd 30                	int    $0x30
  801d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    

00801d85 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	ff 75 0c             	pushl  0xc(%ebp)
  801da0:	50                   	push   %eax
  801da1:	6a 00                	push   $0x0
  801da3:	e8 b2 ff ff ff       	call   801d5a <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	90                   	nop
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_cgetc>:

int
sys_cgetc(void)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 02                	push   $0x2
  801dbd:	e8 98 ff ff ff       	call   801d5a <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 03                	push   $0x3
  801dd6:	e8 7f ff ff ff       	call   801d5a <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	90                   	nop
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 04                	push   $0x4
  801df0:	e8 65 ff ff ff       	call   801d5a <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	90                   	nop
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 08                	push   $0x8
  801e0e:	e8 47 ff ff ff       	call   801d5a <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e1d:	8b 75 18             	mov    0x18(%ebp),%esi
  801e20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	51                   	push   %ecx
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	6a 09                	push   $0x9
  801e33:	e8 22 ff ff ff       	call   801d5a <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 0a                	push   $0xa
  801e55:	e8 00 ff ff ff       	call   801d5a <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	ff 75 0c             	pushl  0xc(%ebp)
  801e6b:	ff 75 08             	pushl  0x8(%ebp)
  801e6e:	6a 0b                	push   $0xb
  801e70:	e8 e5 fe ff ff       	call   801d5a <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 0c                	push   $0xc
  801e89:	e8 cc fe ff ff       	call   801d5a <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 0d                	push   $0xd
  801ea2:	e8 b3 fe ff ff       	call   801d5a <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 0e                	push   $0xe
  801ebb:	e8 9a fe ff ff       	call   801d5a <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 0f                	push   $0xf
  801ed4:	e8 81 fe ff ff       	call   801d5a <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	6a 10                	push   $0x10
  801eee:	e8 67 fe ff ff       	call   801d5a <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 11                	push   $0x11
  801f07:	e8 4e fe ff ff       	call   801d5a <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	90                   	nop
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	50                   	push   %eax
  801f2b:	6a 01                	push   $0x1
  801f2d:	e8 28 fe ff ff       	call   801d5a <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
}
  801f35:	90                   	nop
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 14                	push   $0x14
  801f47:	e8 0e fe ff ff       	call   801d5a <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	90                   	nop
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f61:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	51                   	push   %ecx
  801f6b:	52                   	push   %edx
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	50                   	push   %eax
  801f70:	6a 15                	push   $0x15
  801f72:	e8 e3 fd ff ff       	call   801d5a <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 16                	push   $0x16
  801f8f:	e8 c6 fd ff ff       	call   801d5a <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	51                   	push   %ecx
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	6a 17                	push   $0x17
  801fae:	e8 a7 fd ff ff       	call   801d5a <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	6a 18                	push   $0x18
  801fcb:	e8 8a fd ff ff       	call   801d5a <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	ff 75 14             	pushl  0x14(%ebp)
  801fe0:	ff 75 10             	pushl  0x10(%ebp)
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	50                   	push   %eax
  801fe7:	6a 19                	push   $0x19
  801fe9:	e8 6c fd ff ff       	call   801d5a <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	50                   	push   %eax
  802002:	6a 1a                	push   $0x1a
  802004:	e8 51 fd ff ff       	call   801d5a <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	90                   	nop
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	50                   	push   %eax
  80201e:	6a 1b                	push   $0x1b
  802020:	e8 35 fd ff ff       	call   801d5a <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 05                	push   $0x5
  802039:	e8 1c fd ff ff       	call   801d5a <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 06                	push   $0x6
  802052:	e8 03 fd ff ff       	call   801d5a <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 07                	push   $0x7
  80206b:	e8 ea fc ff ff       	call   801d5a <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_exit_env>:


void sys_exit_env(void)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 1c                	push   $0x1c
  802084:	e8 d1 fc ff ff       	call   801d5a <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	90                   	nop
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802095:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802098:	8d 50 04             	lea    0x4(%eax),%edx
  80209b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	52                   	push   %edx
  8020a5:	50                   	push   %eax
  8020a6:	6a 1d                	push   $0x1d
  8020a8:	e8 ad fc ff ff       	call   801d5a <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
	return result;
  8020b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020b9:	89 01                	mov    %eax,(%ecx)
  8020bb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	c9                   	leave  
  8020c2:	c2 04 00             	ret    $0x4

008020c5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	ff 75 10             	pushl  0x10(%ebp)
  8020cf:	ff 75 0c             	pushl  0xc(%ebp)
  8020d2:	ff 75 08             	pushl  0x8(%ebp)
  8020d5:	6a 13                	push   $0x13
  8020d7:	e8 7e fc ff ff       	call   801d5a <syscall>
  8020dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8020df:	90                   	nop
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 1e                	push   $0x1e
  8020f1:	e8 64 fc ff ff       	call   801d5a <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802107:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	50                   	push   %eax
  802114:	6a 1f                	push   $0x1f
  802116:	e8 3f fc ff ff       	call   801d5a <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
	return ;
  80211e:	90                   	nop
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <rsttst>:
void rsttst()
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 21                	push   $0x21
  802130:	e8 25 fc ff ff       	call   801d5a <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
	return ;
  802138:	90                   	nop
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	8b 45 14             	mov    0x14(%ebp),%eax
  802144:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802147:	8b 55 18             	mov    0x18(%ebp),%edx
  80214a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80214e:	52                   	push   %edx
  80214f:	50                   	push   %eax
  802150:	ff 75 10             	pushl  0x10(%ebp)
  802153:	ff 75 0c             	pushl  0xc(%ebp)
  802156:	ff 75 08             	pushl  0x8(%ebp)
  802159:	6a 20                	push   $0x20
  80215b:	e8 fa fb ff ff       	call   801d5a <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
	return ;
  802163:	90                   	nop
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <chktst>:
void chktst(uint32 n)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	ff 75 08             	pushl  0x8(%ebp)
  802174:	6a 22                	push   $0x22
  802176:	e8 df fb ff ff       	call   801d5a <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
	return ;
  80217e:	90                   	nop
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <inctst>:

void inctst()
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 23                	push   $0x23
  802190:	e8 c5 fb ff ff       	call   801d5a <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
	return ;
  802198:	90                   	nop
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <gettst>:
uint32 gettst()
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 24                	push   $0x24
  8021aa:	e8 ab fb ff ff       	call   801d5a <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 25                	push   $0x25
  8021c6:	e8 8f fb ff ff       	call   801d5a <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
  8021ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021d1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021d5:	75 07                	jne    8021de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021dc:	eb 05                	jmp    8021e3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 25                	push   $0x25
  8021f7:	e8 5e fb ff ff       	call   801d5a <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
  8021ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802202:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802206:	75 07                	jne    80220f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802208:	b8 01 00 00 00       	mov    $0x1,%eax
  80220d:	eb 05                	jmp    802214 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 25                	push   $0x25
  802228:	e8 2d fb ff ff       	call   801d5a <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
  802230:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802233:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802237:	75 07                	jne    802240 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802239:	b8 01 00 00 00       	mov    $0x1,%eax
  80223e:	eb 05                	jmp    802245 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 25                	push   $0x25
  802259:	e8 fc fa ff ff       	call   801d5a <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
  802261:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802264:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802268:	75 07                	jne    802271 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80226a:	b8 01 00 00 00       	mov    $0x1,%eax
  80226f:	eb 05                	jmp    802276 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	6a 26                	push   $0x26
  802288:	e8 cd fa ff ff       	call   801d5a <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return ;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802297:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80229a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	53                   	push   %ebx
  8022a6:	51                   	push   %ecx
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	6a 27                	push   $0x27
  8022ab:	e8 aa fa ff ff       	call   801d5a <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	52                   	push   %edx
  8022c8:	50                   	push   %eax
  8022c9:	6a 28                	push   $0x28
  8022cb:	e8 8a fa ff ff       	call   801d5a <syscall>
  8022d0:	83 c4 18             	add    $0x18,%esp
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8022d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	51                   	push   %ecx
  8022e4:	ff 75 10             	pushl  0x10(%ebp)
  8022e7:	52                   	push   %edx
  8022e8:	50                   	push   %eax
  8022e9:	6a 29                	push   $0x29
  8022eb:	e8 6a fa ff ff       	call   801d5a <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	ff 75 10             	pushl  0x10(%ebp)
  8022ff:	ff 75 0c             	pushl  0xc(%ebp)
  802302:	ff 75 08             	pushl  0x8(%ebp)
  802305:	6a 12                	push   $0x12
  802307:	e8 4e fa ff ff       	call   801d5a <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
	return ;
  80230f:	90                   	nop
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802315:	8b 55 0c             	mov    0xc(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	6a 2a                	push   $0x2a
  802325:	e8 30 fa ff ff       	call   801d5a <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
	return;
  80232d:	90                   	nop
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	50                   	push   %eax
  80233f:	6a 2b                	push   $0x2b
  802341:	e8 14 fa ff ff       	call   801d5a <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	ff 75 0c             	pushl  0xc(%ebp)
  802357:	ff 75 08             	pushl  0x8(%ebp)
  80235a:	6a 2c                	push   $0x2c
  80235c:	e8 f9 f9 ff ff       	call   801d5a <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
	return;
  802364:	90                   	nop
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	ff 75 0c             	pushl  0xc(%ebp)
  802373:	ff 75 08             	pushl  0x8(%ebp)
  802376:	6a 2d                	push   $0x2d
  802378:	e8 dd f9 ff ff       	call   801d5a <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 2e                	push   $0x2e
  802395:	e8 c0 f9 ff ff       	call   801d5a <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
  80239d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8023a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	50                   	push   %eax
  8023b4:	6a 2f                	push   $0x2f
  8023b6:	e8 9f f9 ff ff       	call   801d5a <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
	return;
  8023be:	90                   	nop
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8023c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	52                   	push   %edx
  8023d1:	50                   	push   %eax
  8023d2:	6a 30                	push   $0x30
  8023d4:	e8 81 f9 ff ff       	call   801d5a <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 31                	push   $0x31
  8023f3:	e8 62 f9 ff ff       	call   801d5a <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
  8023fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8023fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	50                   	push   %eax
  802412:	6a 32                	push   $0x32
  802414:	e8 41 f9 ff ff       	call   801d5a <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
	return;
  80241c:	90                   	nop
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	83 e8 04             	sub    $0x4,%eax
  80242b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80242e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	83 e8 04             	sub    $0x4,%eax
  802444:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802447:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	83 e0 01             	and    $0x1,%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	0f 94 c0             	sete   %al
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80245c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802463:	8b 45 0c             	mov    0xc(%ebp),%eax
  802466:	83 f8 02             	cmp    $0x2,%eax
  802469:	74 2b                	je     802496 <alloc_block+0x40>
  80246b:	83 f8 02             	cmp    $0x2,%eax
  80246e:	7f 07                	jg     802477 <alloc_block+0x21>
  802470:	83 f8 01             	cmp    $0x1,%eax
  802473:	74 0e                	je     802483 <alloc_block+0x2d>
  802475:	eb 58                	jmp    8024cf <alloc_block+0x79>
  802477:	83 f8 03             	cmp    $0x3,%eax
  80247a:	74 2d                	je     8024a9 <alloc_block+0x53>
  80247c:	83 f8 04             	cmp    $0x4,%eax
  80247f:	74 3b                	je     8024bc <alloc_block+0x66>
  802481:	eb 4c                	jmp    8024cf <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802483:	83 ec 0c             	sub    $0xc,%esp
  802486:	ff 75 08             	pushl  0x8(%ebp)
  802489:	e8 11 03 00 00       	call   80279f <alloc_block_FF>
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802494:	eb 4a                	jmp    8024e0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	ff 75 08             	pushl  0x8(%ebp)
  80249c:	e8 c7 19 00 00       	call   803e68 <alloc_block_NF>
  8024a1:	83 c4 10             	add    $0x10,%esp
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024a7:	eb 37                	jmp    8024e0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024a9:	83 ec 0c             	sub    $0xc,%esp
  8024ac:	ff 75 08             	pushl  0x8(%ebp)
  8024af:	e8 a7 07 00 00       	call   802c5b <alloc_block_BF>
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024ba:	eb 24                	jmp    8024e0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	ff 75 08             	pushl  0x8(%ebp)
  8024c2:	e8 84 19 00 00       	call   803e4b <alloc_block_WF>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024cd:	eb 11                	jmp    8024e0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	68 48 4a 80 00       	push   $0x804a48
  8024d7:	e8 b1 e5 ff ff       	call   800a8d <cprintf>
  8024dc:	83 c4 10             	add    $0x10,%esp
		break;
  8024df:	90                   	nop
	}
	return va;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	53                   	push   %ebx
  8024e9:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	68 68 4a 80 00       	push   $0x804a68
  8024f4:	e8 94 e5 ff ff       	call   800a8d <cprintf>
  8024f9:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8024fc:	83 ec 0c             	sub    $0xc,%esp
  8024ff:	68 93 4a 80 00       	push   $0x804a93
  802504:	e8 84 e5 ff ff       	call   800a8d <cprintf>
  802509:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802512:	eb 37                	jmp    80254b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	ff 75 f4             	pushl  -0xc(%ebp)
  80251a:	e8 19 ff ff ff       	call   802438 <is_free_block>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	0f be d8             	movsbl %al,%ebx
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	ff 75 f4             	pushl  -0xc(%ebp)
  80252b:	e8 ef fe ff ff       	call   80241f <get_block_size>
  802530:	83 c4 10             	add    $0x10,%esp
  802533:	83 ec 04             	sub    $0x4,%esp
  802536:	53                   	push   %ebx
  802537:	50                   	push   %eax
  802538:	68 ab 4a 80 00       	push   $0x804aab
  80253d:	e8 4b e5 ff ff       	call   800a8d <cprintf>
  802542:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802545:	8b 45 10             	mov    0x10(%ebp),%eax
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	74 07                	je     802558 <print_blocks_list+0x73>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	eb 05                	jmp    80255d <print_blocks_list+0x78>
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	89 45 10             	mov    %eax,0x10(%ebp)
  802560:	8b 45 10             	mov    0x10(%ebp),%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	75 ad                	jne    802514 <print_blocks_list+0x2f>
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	75 a7                	jne    802514 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80256d:	83 ec 0c             	sub    $0xc,%esp
  802570:	68 68 4a 80 00       	push   $0x804a68
  802575:	e8 13 e5 ff ff       	call   800a8d <cprintf>
  80257a:	83 c4 10             	add    $0x10,%esp

}
  80257d:	90                   	nop
  80257e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258c:	83 e0 01             	and    $0x1,%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	74 03                	je     802596 <initialize_dynamic_allocator+0x13>
  802593:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80259a:	0f 84 c7 01 00 00    	je     802767 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025a0:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8025a7:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	01 d0                	add    %edx,%eax
  8025b2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8025b7:	0f 87 ad 01 00 00    	ja     80276a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	0f 89 a5 01 00 00    	jns    80276d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8025c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ce:	01 d0                	add    %edx,%eax
  8025d0:	83 e8 04             	sub    $0x4,%eax
  8025d3:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8025d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8025df:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e7:	e9 87 00 00 00       	jmp    802673 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	75 14                	jne    802606 <initialize_dynamic_allocator+0x83>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 c3 4a 80 00       	push   $0x804ac3
  8025fa:	6a 79                	push   $0x79
  8025fc:	68 e1 4a 80 00       	push   $0x804ae1
  802601:	e8 ca e1 ff ff       	call   8007d0 <_panic>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 10                	je     80261f <initialize_dynamic_allocator+0x9c>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802617:	8b 52 04             	mov    0x4(%edx),%edx
  80261a:	89 50 04             	mov    %edx,0x4(%eax)
  80261d:	eb 0b                	jmp    80262a <initialize_dynamic_allocator+0xa7>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	a3 30 50 80 00       	mov    %eax,0x805030
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	74 0f                	je     802643 <initialize_dynamic_allocator+0xc0>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 04             	mov    0x4(%eax),%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	8b 12                	mov    (%edx),%edx
  80263f:	89 10                	mov    %edx,(%eax)
  802641:	eb 0a                	jmp    80264d <initialize_dynamic_allocator+0xca>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802660:	a1 38 50 80 00       	mov    0x805038,%eax
  802665:	48                   	dec    %eax
  802666:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80266b:	a1 34 50 80 00       	mov    0x805034,%eax
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802677:	74 07                	je     802680 <initialize_dynamic_allocator+0xfd>
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	eb 05                	jmp    802685 <initialize_dynamic_allocator+0x102>
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	a3 34 50 80 00       	mov    %eax,0x805034
  80268a:	a1 34 50 80 00       	mov    0x805034,%eax
  80268f:	85 c0                	test   %eax,%eax
  802691:	0f 85 55 ff ff ff    	jne    8025ec <initialize_dynamic_allocator+0x69>
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	0f 85 4b ff ff ff    	jne    8025ec <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026aa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8026b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b5:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8026ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8026bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	83 c0 08             	add    $0x8,%eax
  8026cb:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	83 c0 04             	add    $0x4,%eax
  8026d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d7:	83 ea 08             	sub    $0x8,%edx
  8026da:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	83 e8 08             	sub    $0x8,%eax
  8026e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ea:	83 ea 08             	sub    $0x8,%edx
  8026ed:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8026ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802706:	75 17                	jne    80271f <initialize_dynamic_allocator+0x19c>
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 fc 4a 80 00       	push   $0x804afc
  802710:	68 90 00 00 00       	push   $0x90
  802715:	68 e1 4a 80 00       	push   $0x804ae1
  80271a:	e8 b1 e0 ff ff       	call   8007d0 <_panic>
  80271f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	89 10                	mov    %edx,(%eax)
  80272a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 0d                	je     802740 <initialize_dynamic_allocator+0x1bd>
  802733:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802738:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80273b:	89 50 04             	mov    %edx,0x4(%eax)
  80273e:	eb 08                	jmp    802748 <initialize_dynamic_allocator+0x1c5>
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	a3 30 50 80 00       	mov    %eax,0x805030
  802748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802753:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275a:	a1 38 50 80 00       	mov    0x805038,%eax
  80275f:	40                   	inc    %eax
  802760:	a3 38 50 80 00       	mov    %eax,0x805038
  802765:	eb 07                	jmp    80276e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802767:	90                   	nop
  802768:	eb 04                	jmp    80276e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80276a:	90                   	nop
  80276b:	eb 01                	jmp    80276e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80276d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802773:	8b 45 10             	mov    0x10(%ebp),%eax
  802776:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80277f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802782:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	83 e8 04             	sub    $0x4,%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	83 e0 fe             	and    $0xfffffffe,%eax
  80278f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	01 c2                	add    %eax,%edx
  802797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279a:	89 02                	mov    %eax,(%edx)
}
  80279c:	90                   	nop
  80279d:	5d                   	pop    %ebp
  80279e:	c3                   	ret    

0080279f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
  8027a2:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	83 e0 01             	and    $0x1,%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 03                	je     8027b2 <alloc_block_FF+0x13>
  8027af:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027b2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027b6:	77 07                	ja     8027bf <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027b8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027bf:	a1 24 50 80 00       	mov    0x805024,%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	75 73                	jne    80283b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	83 c0 10             	add    $0x10,%eax
  8027ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027d1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	01 d0                	add    %edx,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ec:	f7 75 ec             	divl   -0x14(%ebp)
  8027ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f2:	29 d0                	sub    %edx,%eax
  8027f4:	c1 e8 0c             	shr    $0xc,%eax
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	50                   	push   %eax
  8027fb:	e8 27 f0 ff ff       	call   801827 <sbrk>
  802800:	83 c4 10             	add    $0x10,%esp
  802803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802806:	83 ec 0c             	sub    $0xc,%esp
  802809:	6a 00                	push   $0x0
  80280b:	e8 17 f0 ff ff       	call   801827 <sbrk>
  802810:	83 c4 10             	add    $0x10,%esp
  802813:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80281c:	83 ec 08             	sub    $0x8,%esp
  80281f:	50                   	push   %eax
  802820:	ff 75 e4             	pushl  -0x1c(%ebp)
  802823:	e8 5b fd ff ff       	call   802583 <initialize_dynamic_allocator>
  802828:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	68 1f 4b 80 00       	push   $0x804b1f
  802833:	e8 55 e2 ff ff       	call   800a8d <cprintf>
  802838:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80283b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283f:	75 0a                	jne    80284b <alloc_block_FF+0xac>
	        return NULL;
  802841:	b8 00 00 00 00       	mov    $0x0,%eax
  802846:	e9 0e 04 00 00       	jmp    802c59 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80284b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802852:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	e9 f3 02 00 00       	jmp    802b52 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	ff 75 bc             	pushl  -0x44(%ebp)
  80286b:	e8 af fb ff ff       	call   80241f <get_block_size>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	83 c0 08             	add    $0x8,%eax
  80287c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80287f:	0f 87 c5 02 00 00    	ja     802b4a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	83 c0 18             	add    $0x18,%eax
  80288b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80288e:	0f 87 19 02 00 00    	ja     802aad <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802894:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802897:	2b 45 08             	sub    0x8(%ebp),%eax
  80289a:	83 e8 08             	sub    $0x8,%eax
  80289d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	8d 50 08             	lea    0x8(%eax),%edx
  8028a6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	83 c0 08             	add    $0x8,%eax
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	6a 01                	push   $0x1
  8028b9:	50                   	push   %eax
  8028ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8028bd:	e8 ae fe ff ff       	call   802770 <set_block_data>
  8028c2:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	75 68                	jne    802937 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028cf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028d3:	75 17                	jne    8028ec <alloc_block_FF+0x14d>
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	68 fc 4a 80 00       	push   $0x804afc
  8028dd:	68 d7 00 00 00       	push   $0xd7
  8028e2:	68 e1 4a 80 00       	push   $0x804ae1
  8028e7:	e8 e4 de ff ff       	call   8007d0 <_panic>
  8028ec:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0d                	je     80290d <alloc_block_FF+0x16e>
  802900:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802905:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	eb 08                	jmp    802915 <alloc_block_FF+0x176>
  80290d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802910:	a3 30 50 80 00       	mov    %eax,0x805030
  802915:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802918:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80291d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802927:	a1 38 50 80 00       	mov    0x805038,%eax
  80292c:	40                   	inc    %eax
  80292d:	a3 38 50 80 00       	mov    %eax,0x805038
  802932:	e9 dc 00 00 00       	jmp    802a13 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	75 65                	jne    8029a5 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802940:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802944:	75 17                	jne    80295d <alloc_block_FF+0x1be>
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 30 4b 80 00       	push   $0x804b30
  80294e:	68 db 00 00 00       	push   $0xdb
  802953:	68 e1 4a 80 00       	push   $0x804ae1
  802958:	e8 73 de ff ff       	call   8007d0 <_panic>
  80295d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802963:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0c                	je     80297f <alloc_block_FF+0x1e0>
  802973:	a1 30 50 80 00       	mov    0x805030,%eax
  802978:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80297b:	89 10                	mov    %edx,(%eax)
  80297d:	eb 08                	jmp    802987 <alloc_block_FF+0x1e8>
  80297f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802982:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802987:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298a:	a3 30 50 80 00       	mov    %eax,0x805030
  80298f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802998:	a1 38 50 80 00       	mov    0x805038,%eax
  80299d:	40                   	inc    %eax
  80299e:	a3 38 50 80 00       	mov    %eax,0x805038
  8029a3:	eb 6e                	jmp    802a13 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a9:	74 06                	je     8029b1 <alloc_block_FF+0x212>
  8029ab:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029af:	75 17                	jne    8029c8 <alloc_block_FF+0x229>
  8029b1:	83 ec 04             	sub    $0x4,%esp
  8029b4:	68 54 4b 80 00       	push   $0x804b54
  8029b9:	68 df 00 00 00       	push   $0xdf
  8029be:	68 e1 4a 80 00       	push   $0x804ae1
  8029c3:	e8 08 de ff ff       	call   8007d0 <_panic>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 10                	mov    (%eax),%edx
  8029cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d0:	89 10                	mov    %edx,(%eax)
  8029d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 0b                	je     8029e6 <alloc_block_FF+0x247>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029e3:	89 50 04             	mov    %edx,0x4(%eax)
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029ec:	89 10                	mov    %edx,(%eax)
  8029ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f4:	89 50 04             	mov    %edx,0x4(%eax)
  8029f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	75 08                	jne    802a08 <alloc_block_FF+0x269>
  802a00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a03:	a3 30 50 80 00       	mov    %eax,0x805030
  802a08:	a1 38 50 80 00       	mov    0x805038,%eax
  802a0d:	40                   	inc    %eax
  802a0e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a17:	75 17                	jne    802a30 <alloc_block_FF+0x291>
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 c3 4a 80 00       	push   $0x804ac3
  802a21:	68 e1 00 00 00       	push   $0xe1
  802a26:	68 e1 4a 80 00       	push   $0x804ae1
  802a2b:	e8 a0 dd ff ff       	call   8007d0 <_panic>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 10                	je     802a49 <alloc_block_FF+0x2aa>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a41:	8b 52 04             	mov    0x4(%edx),%edx
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	eb 0b                	jmp    802a54 <alloc_block_FF+0x2b5>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 40 04             	mov    0x4(%eax),%eax
  802a4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0f                	je     802a6d <alloc_block_FF+0x2ce>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 40 04             	mov    0x4(%eax),%eax
  802a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a67:	8b 12                	mov    (%edx),%edx
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	eb 0a                	jmp    802a77 <alloc_block_FF+0x2d8>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8f:	48                   	dec    %eax
  802a90:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	6a 00                	push   $0x0
  802a9a:	ff 75 b4             	pushl  -0x4c(%ebp)
  802a9d:	ff 75 b0             	pushl  -0x50(%ebp)
  802aa0:	e8 cb fc ff ff       	call   802770 <set_block_data>
  802aa5:	83 c4 10             	add    $0x10,%esp
  802aa8:	e9 95 00 00 00       	jmp    802b42 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802aad:	83 ec 04             	sub    $0x4,%esp
  802ab0:	6a 01                	push   $0x1
  802ab2:	ff 75 b8             	pushl  -0x48(%ebp)
  802ab5:	ff 75 bc             	pushl  -0x44(%ebp)
  802ab8:	e8 b3 fc ff ff       	call   802770 <set_block_data>
  802abd:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_FF+0x33e>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 c3 4a 80 00       	push   $0x804ac3
  802ace:	68 e8 00 00 00       	push   $0xe8
  802ad3:	68 e1 4a 80 00       	push   $0x804ae1
  802ad8:	e8 f3 dc ff ff       	call   8007d0 <_panic>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 10                	je     802af6 <alloc_block_FF+0x357>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	8b 52 04             	mov    0x4(%edx),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	eb 0b                	jmp    802b01 <alloc_block_FF+0x362>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	a3 30 50 80 00       	mov    %eax,0x805030
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0f                	je     802b1a <alloc_block_FF+0x37b>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b14:	8b 12                	mov    (%edx),%edx
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	eb 0a                	jmp    802b24 <alloc_block_FF+0x385>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3c:	48                   	dec    %eax
  802b3d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802b42:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b45:	e9 0f 01 00 00       	jmp    802c59 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b4a:	a1 34 50 80 00       	mov    0x805034,%eax
  802b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b56:	74 07                	je     802b5f <alloc_block_FF+0x3c0>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	eb 05                	jmp    802b64 <alloc_block_FF+0x3c5>
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b64:	a3 34 50 80 00       	mov    %eax,0x805034
  802b69:	a1 34 50 80 00       	mov    0x805034,%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	0f 85 e9 fc ff ff    	jne    80285f <alloc_block_FF+0xc0>
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	0f 85 df fc ff ff    	jne    80285f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	83 c0 08             	add    $0x8,%eax
  802b86:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b89:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b93:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b96:	01 d0                	add    %edx,%eax
  802b98:	48                   	dec    %eax
  802b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802b9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba4:	f7 75 d8             	divl   -0x28(%ebp)
  802ba7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802baa:	29 d0                	sub    %edx,%eax
  802bac:	c1 e8 0c             	shr    $0xc,%eax
  802baf:	83 ec 0c             	sub    $0xc,%esp
  802bb2:	50                   	push   %eax
  802bb3:	e8 6f ec ff ff       	call   801827 <sbrk>
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802bbe:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802bc2:	75 0a                	jne    802bce <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc9:	e9 8b 00 00 00       	jmp    802c59 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bce:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802bd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bd8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bdb:	01 d0                	add    %edx,%eax
  802bdd:	48                   	dec    %eax
  802bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802be1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802be4:	ba 00 00 00 00       	mov    $0x0,%edx
  802be9:	f7 75 cc             	divl   -0x34(%ebp)
  802bec:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bef:	29 d0                	sub    %edx,%eax
  802bf1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bf4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bf7:	01 d0                	add    %edx,%eax
  802bf9:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802bfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802c03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c09:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c16:	01 d0                	add    %edx,%eax
  802c18:	48                   	dec    %eax
  802c19:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c24:	f7 75 c4             	divl   -0x3c(%ebp)
  802c27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c2a:	29 d0                	sub    %edx,%eax
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	6a 01                	push   $0x1
  802c31:	50                   	push   %eax
  802c32:	ff 75 d0             	pushl  -0x30(%ebp)
  802c35:	e8 36 fb ff ff       	call   802770 <set_block_data>
  802c3a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	ff 75 d0             	pushl  -0x30(%ebp)
  802c43:	e8 f8 09 00 00       	call   803640 <free_block>
  802c48:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c4b:	83 ec 0c             	sub    $0xc,%esp
  802c4e:	ff 75 08             	pushl  0x8(%ebp)
  802c51:	e8 49 fb ff ff       	call   80279f <alloc_block_FF>
  802c56:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    

00802c5b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
  802c5e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	83 e0 01             	and    $0x1,%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 03                	je     802c6e <alloc_block_BF+0x13>
  802c6b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c6e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c72:	77 07                	ja     802c7b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c74:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c7b:	a1 24 50 80 00       	mov    0x805024,%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	75 73                	jne    802cf7 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	83 c0 10             	add    $0x10,%eax
  802c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c8d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9a:	01 d0                	add    %edx,%eax
  802c9c:	48                   	dec    %eax
  802c9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ca0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca8:	f7 75 e0             	divl   -0x20(%ebp)
  802cab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cae:	29 d0                	sub    %edx,%eax
  802cb0:	c1 e8 0c             	shr    $0xc,%eax
  802cb3:	83 ec 0c             	sub    $0xc,%esp
  802cb6:	50                   	push   %eax
  802cb7:	e8 6b eb ff ff       	call   801827 <sbrk>
  802cbc:	83 c4 10             	add    $0x10,%esp
  802cbf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802cc2:	83 ec 0c             	sub    $0xc,%esp
  802cc5:	6a 00                	push   $0x0
  802cc7:	e8 5b eb ff ff       	call   801827 <sbrk>
  802ccc:	83 c4 10             	add    $0x10,%esp
  802ccf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802cd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cd5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802cd8:	83 ec 08             	sub    $0x8,%esp
  802cdb:	50                   	push   %eax
  802cdc:	ff 75 d8             	pushl  -0x28(%ebp)
  802cdf:	e8 9f f8 ff ff       	call   802583 <initialize_dynamic_allocator>
  802ce4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ce7:	83 ec 0c             	sub    $0xc,%esp
  802cea:	68 1f 4b 80 00       	push   $0x804b1f
  802cef:	e8 99 dd ff ff       	call   800a8d <cprintf>
  802cf4:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802cfe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d05:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d0c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1b:	e9 1d 01 00 00       	jmp    802e3d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d26:	83 ec 0c             	sub    $0xc,%esp
  802d29:	ff 75 a8             	pushl  -0x58(%ebp)
  802d2c:	e8 ee f6 ff ff       	call   80241f <get_block_size>
  802d31:	83 c4 10             	add    $0x10,%esp
  802d34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	83 c0 08             	add    $0x8,%eax
  802d3d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d40:	0f 87 ef 00 00 00    	ja     802e35 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	83 c0 18             	add    $0x18,%eax
  802d4c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d4f:	77 1d                	ja     802d6e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d57:	0f 86 d8 00 00 00    	jbe    802e35 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d5d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d63:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d69:	e9 c7 00 00 00       	jmp    802e35 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	83 c0 08             	add    $0x8,%eax
  802d74:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d77:	0f 85 9d 00 00 00    	jne    802e1a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	6a 01                	push   $0x1
  802d82:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d85:	ff 75 a8             	pushl  -0x58(%ebp)
  802d88:	e8 e3 f9 ff ff       	call   802770 <set_block_data>
  802d8d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d94:	75 17                	jne    802dad <alloc_block_BF+0x152>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 c3 4a 80 00       	push   $0x804ac3
  802d9e:	68 2c 01 00 00       	push   $0x12c
  802da3:	68 e1 4a 80 00       	push   $0x804ae1
  802da8:	e8 23 da ff ff       	call   8007d0 <_panic>
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 10                	je     802dc6 <alloc_block_BF+0x16b>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	8b 52 04             	mov    0x4(%edx),%edx
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
  802dc4:	eb 0b                	jmp    802dd1 <alloc_block_BF+0x176>
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0f                	je     802dea <alloc_block_BF+0x18f>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de4:	8b 12                	mov    (%edx),%edx
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	eb 0a                	jmp    802df4 <alloc_block_BF+0x199>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e07:	a1 38 50 80 00       	mov    0x805038,%eax
  802e0c:	48                   	dec    %eax
  802e0d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802e12:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e15:	e9 01 04 00 00       	jmp    80321b <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e20:	76 13                	jbe    802e35 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e22:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e29:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e2f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e32:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e35:	a1 34 50 80 00       	mov    0x805034,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	74 07                	je     802e4a <alloc_block_BF+0x1ef>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	eb 05                	jmp    802e4f <alloc_block_BF+0x1f4>
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	a3 34 50 80 00       	mov    %eax,0x805034
  802e54:	a1 34 50 80 00       	mov    0x805034,%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	0f 85 bf fe ff ff    	jne    802d20 <alloc_block_BF+0xc5>
  802e61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e65:	0f 85 b5 fe ff ff    	jne    802d20 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6f:	0f 84 26 02 00 00    	je     80309b <alloc_block_BF+0x440>
  802e75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e79:	0f 85 1c 02 00 00    	jne    80309b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e82:	2b 45 08             	sub    0x8(%ebp),%eax
  802e85:	83 e8 08             	sub    $0x8,%eax
  802e88:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8d 50 08             	lea    0x8(%eax),%edx
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	01 d0                	add    %edx,%eax
  802e96:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	83 c0 08             	add    $0x8,%eax
  802e9f:	83 ec 04             	sub    $0x4,%esp
  802ea2:	6a 01                	push   $0x1
  802ea4:	50                   	push   %eax
  802ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  802ea8:	e8 c3 f8 ff ff       	call   802770 <set_block_data>
  802ead:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 40 04             	mov    0x4(%eax),%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	75 68                	jne    802f22 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802eba:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ebe:	75 17                	jne    802ed7 <alloc_block_BF+0x27c>
  802ec0:	83 ec 04             	sub    $0x4,%esp
  802ec3:	68 fc 4a 80 00       	push   $0x804afc
  802ec8:	68 45 01 00 00       	push   $0x145
  802ecd:	68 e1 4a 80 00       	push   $0x804ae1
  802ed2:	e8 f9 d8 ff ff       	call   8007d0 <_panic>
  802ed7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802edd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 0d                	je     802ef8 <alloc_block_BF+0x29d>
  802eeb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ef3:	89 50 04             	mov    %edx,0x4(%eax)
  802ef6:	eb 08                	jmp    802f00 <alloc_block_BF+0x2a5>
  802ef8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efb:	a3 30 50 80 00       	mov    %eax,0x805030
  802f00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f12:	a1 38 50 80 00       	mov    0x805038,%eax
  802f17:	40                   	inc    %eax
  802f18:	a3 38 50 80 00       	mov    %eax,0x805038
  802f1d:	e9 dc 00 00 00       	jmp    802ffe <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	75 65                	jne    802f90 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f2b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f2f:	75 17                	jne    802f48 <alloc_block_BF+0x2ed>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 30 4b 80 00       	push   $0x804b30
  802f39:	68 4a 01 00 00       	push   $0x14a
  802f3e:	68 e1 4a 80 00       	push   $0x804ae1
  802f43:	e8 88 d8 ff ff       	call   8007d0 <_panic>
  802f48:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 0c                	je     802f6a <alloc_block_BF+0x30f>
  802f5e:	a1 30 50 80 00       	mov    0x805030,%eax
  802f63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f66:	89 10                	mov    %edx,(%eax)
  802f68:	eb 08                	jmp    802f72 <alloc_block_BF+0x317>
  802f6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f6d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f75:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f83:	a1 38 50 80 00       	mov    0x805038,%eax
  802f88:	40                   	inc    %eax
  802f89:	a3 38 50 80 00       	mov    %eax,0x805038
  802f8e:	eb 6e                	jmp    802ffe <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f94:	74 06                	je     802f9c <alloc_block_BF+0x341>
  802f96:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f9a:	75 17                	jne    802fb3 <alloc_block_BF+0x358>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 54 4b 80 00       	push   $0x804b54
  802fa4:	68 4f 01 00 00       	push   $0x14f
  802fa9:	68 e1 4a 80 00       	push   $0x804ae1
  802fae:	e8 1d d8 ff ff       	call   8007d0 <_panic>
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 10                	mov    (%eax),%edx
  802fb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbb:	89 10                	mov    %edx,(%eax)
  802fbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0b                	je     802fd1 <alloc_block_BF+0x376>
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fd7:	89 10                	mov    %edx,(%eax)
  802fd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	75 08                	jne    802ff3 <alloc_block_BF+0x398>
  802feb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fee:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803002:	75 17                	jne    80301b <alloc_block_BF+0x3c0>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 c3 4a 80 00       	push   $0x804ac3
  80300c:	68 51 01 00 00       	push   $0x151
  803011:	68 e1 4a 80 00       	push   $0x804ae1
  803016:	e8 b5 d7 ff ff       	call   8007d0 <_panic>
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 10                	je     803034 <alloc_block_BF+0x3d9>
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302c:	8b 52 04             	mov    0x4(%edx),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 0b                	jmp    80303f <alloc_block_BF+0x3e4>
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	a3 30 50 80 00       	mov    %eax,0x805030
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0f                	je     803058 <alloc_block_BF+0x3fd>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803052:	8b 12                	mov    (%edx),%edx
  803054:	89 10                	mov    %edx,(%eax)
  803056:	eb 0a                	jmp    803062 <alloc_block_BF+0x407>
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803075:	a1 38 50 80 00       	mov    0x805038,%eax
  80307a:	48                   	dec    %eax
  80307b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	6a 00                	push   $0x0
  803085:	ff 75 d0             	pushl  -0x30(%ebp)
  803088:	ff 75 cc             	pushl  -0x34(%ebp)
  80308b:	e8 e0 f6 ff ff       	call   802770 <set_block_data>
  803090:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	e9 80 01 00 00       	jmp    80321b <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80309b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80309f:	0f 85 9d 00 00 00    	jne    803142 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	6a 01                	push   $0x1
  8030aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8030ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8030b0:	e8 bb f6 ff ff       	call   802770 <set_block_data>
  8030b5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8030b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030bc:	75 17                	jne    8030d5 <alloc_block_BF+0x47a>
  8030be:	83 ec 04             	sub    $0x4,%esp
  8030c1:	68 c3 4a 80 00       	push   $0x804ac3
  8030c6:	68 58 01 00 00       	push   $0x158
  8030cb:	68 e1 4a 80 00       	push   $0x804ae1
  8030d0:	e8 fb d6 ff ff       	call   8007d0 <_panic>
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 10                	je     8030ee <alloc_block_BF+0x493>
  8030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e6:	8b 52 04             	mov    0x4(%edx),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 0b                	jmp    8030f9 <alloc_block_BF+0x49e>
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0f                	je     803112 <alloc_block_BF+0x4b7>
  803103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310c:	8b 12                	mov    (%edx),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	eb 0a                	jmp    80311c <alloc_block_BF+0x4c1>
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803128:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312f:	a1 38 50 80 00       	mov    0x805038,%eax
  803134:	48                   	dec    %eax
  803135:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313d:	e9 d9 00 00 00       	jmp    80321b <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	83 c0 08             	add    $0x8,%eax
  803148:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80314b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803152:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803155:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803158:	01 d0                	add    %edx,%eax
  80315a:	48                   	dec    %eax
  80315b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80315e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803161:	ba 00 00 00 00       	mov    $0x0,%edx
  803166:	f7 75 c4             	divl   -0x3c(%ebp)
  803169:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80316c:	29 d0                	sub    %edx,%eax
  80316e:	c1 e8 0c             	shr    $0xc,%eax
  803171:	83 ec 0c             	sub    $0xc,%esp
  803174:	50                   	push   %eax
  803175:	e8 ad e6 ff ff       	call   801827 <sbrk>
  80317a:	83 c4 10             	add    $0x10,%esp
  80317d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803180:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803184:	75 0a                	jne    803190 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803186:	b8 00 00 00 00       	mov    $0x0,%eax
  80318b:	e9 8b 00 00 00       	jmp    80321b <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803190:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803197:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80319a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80319d:	01 d0                	add    %edx,%eax
  80319f:	48                   	dec    %eax
  8031a0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031a3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ab:	f7 75 b8             	divl   -0x48(%ebp)
  8031ae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031b1:	29 d0                	sub    %edx,%eax
  8031b3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8031b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8031c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8031c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8031cb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8031d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d8:	01 d0                	add    %edx,%eax
  8031da:	48                   	dec    %eax
  8031db:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8031de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e6:	f7 75 b0             	divl   -0x50(%ebp)
  8031e9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031ec:	29 d0                	sub    %edx,%eax
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	6a 01                	push   $0x1
  8031f3:	50                   	push   %eax
  8031f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8031f7:	e8 74 f5 ff ff       	call   802770 <set_block_data>
  8031fc:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8031ff:	83 ec 0c             	sub    $0xc,%esp
  803202:	ff 75 bc             	pushl  -0x44(%ebp)
  803205:	e8 36 04 00 00       	call   803640 <free_block>
  80320a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80320d:	83 ec 0c             	sub    $0xc,%esp
  803210:	ff 75 08             	pushl  0x8(%ebp)
  803213:	e8 43 fa ff ff       	call   802c5b <alloc_block_BF>
  803218:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
  803220:	53                   	push   %ebx
  803221:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80322b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803232:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803236:	74 1e                	je     803256 <merging+0x39>
  803238:	ff 75 08             	pushl  0x8(%ebp)
  80323b:	e8 df f1 ff ff       	call   80241f <get_block_size>
  803240:	83 c4 04             	add    $0x4,%esp
  803243:	89 c2                	mov    %eax,%edx
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	01 d0                	add    %edx,%eax
  80324a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80324d:	75 07                	jne    803256 <merging+0x39>
		prev_is_free = 1;
  80324f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803256:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80325a:	74 1e                	je     80327a <merging+0x5d>
  80325c:	ff 75 10             	pushl  0x10(%ebp)
  80325f:	e8 bb f1 ff ff       	call   80241f <get_block_size>
  803264:	83 c4 04             	add    $0x4,%esp
  803267:	89 c2                	mov    %eax,%edx
  803269:	8b 45 10             	mov    0x10(%ebp),%eax
  80326c:	01 d0                	add    %edx,%eax
  80326e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803271:	75 07                	jne    80327a <merging+0x5d>
		next_is_free = 1;
  803273:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80327a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327e:	0f 84 cc 00 00 00    	je     803350 <merging+0x133>
  803284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803288:	0f 84 c2 00 00 00    	je     803350 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80328e:	ff 75 08             	pushl  0x8(%ebp)
  803291:	e8 89 f1 ff ff       	call   80241f <get_block_size>
  803296:	83 c4 04             	add    $0x4,%esp
  803299:	89 c3                	mov    %eax,%ebx
  80329b:	ff 75 10             	pushl  0x10(%ebp)
  80329e:	e8 7c f1 ff ff       	call   80241f <get_block_size>
  8032a3:	83 c4 04             	add    $0x4,%esp
  8032a6:	01 c3                	add    %eax,%ebx
  8032a8:	ff 75 0c             	pushl  0xc(%ebp)
  8032ab:	e8 6f f1 ff ff       	call   80241f <get_block_size>
  8032b0:	83 c4 04             	add    $0x4,%esp
  8032b3:	01 d8                	add    %ebx,%eax
  8032b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032b8:	6a 00                	push   $0x0
  8032ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8032bd:	ff 75 08             	pushl  0x8(%ebp)
  8032c0:	e8 ab f4 ff ff       	call   802770 <set_block_data>
  8032c5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8032c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032cc:	75 17                	jne    8032e5 <merging+0xc8>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 c3 4a 80 00       	push   $0x804ac3
  8032d6:	68 7d 01 00 00       	push   $0x17d
  8032db:	68 e1 4a 80 00       	push   $0x804ae1
  8032e0:	e8 eb d4 ff ff       	call   8007d0 <_panic>
  8032e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	74 10                	je     8032fe <merging+0xe1>
  8032ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f6:	8b 52 04             	mov    0x4(%edx),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	eb 0b                	jmp    803309 <merging+0xec>
  8032fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	a3 30 50 80 00       	mov    %eax,0x805030
  803309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0f                	je     803322 <merging+0x105>
  803313:	8b 45 0c             	mov    0xc(%ebp),%eax
  803316:	8b 40 04             	mov    0x4(%eax),%eax
  803319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80331c:	8b 12                	mov    (%edx),%edx
  80331e:	89 10                	mov    %edx,(%eax)
  803320:	eb 0a                	jmp    80332c <merging+0x10f>
  803322:	8b 45 0c             	mov    0xc(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803335:	8b 45 0c             	mov    0xc(%ebp),%eax
  803338:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333f:	a1 38 50 80 00       	mov    0x805038,%eax
  803344:	48                   	dec    %eax
  803345:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80334a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80334b:	e9 ea 02 00 00       	jmp    80363a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803354:	74 3b                	je     803391 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803356:	83 ec 0c             	sub    $0xc,%esp
  803359:	ff 75 08             	pushl  0x8(%ebp)
  80335c:	e8 be f0 ff ff       	call   80241f <get_block_size>
  803361:	83 c4 10             	add    $0x10,%esp
  803364:	89 c3                	mov    %eax,%ebx
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	ff 75 10             	pushl  0x10(%ebp)
  80336c:	e8 ae f0 ff ff       	call   80241f <get_block_size>
  803371:	83 c4 10             	add    $0x10,%esp
  803374:	01 d8                	add    %ebx,%eax
  803376:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	6a 00                	push   $0x0
  80337e:	ff 75 e8             	pushl  -0x18(%ebp)
  803381:	ff 75 08             	pushl  0x8(%ebp)
  803384:	e8 e7 f3 ff ff       	call   802770 <set_block_data>
  803389:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80338c:	e9 a9 02 00 00       	jmp    80363a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803395:	0f 84 2d 01 00 00    	je     8034c8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	ff 75 10             	pushl  0x10(%ebp)
  8033a1:	e8 79 f0 ff ff       	call   80241f <get_block_size>
  8033a6:	83 c4 10             	add    $0x10,%esp
  8033a9:	89 c3                	mov    %eax,%ebx
  8033ab:	83 ec 0c             	sub    $0xc,%esp
  8033ae:	ff 75 0c             	pushl  0xc(%ebp)
  8033b1:	e8 69 f0 ff ff       	call   80241f <get_block_size>
  8033b6:	83 c4 10             	add    $0x10,%esp
  8033b9:	01 d8                	add    %ebx,%eax
  8033bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	6a 00                	push   $0x0
  8033c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033c6:	ff 75 10             	pushl  0x10(%ebp)
  8033c9:	e8 a2 f3 ff ff       	call   802770 <set_block_data>
  8033ce:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8033d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8033d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8033d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033db:	74 06                	je     8033e3 <merging+0x1c6>
  8033dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033e1:	75 17                	jne    8033fa <merging+0x1dd>
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 88 4b 80 00       	push   $0x804b88
  8033eb:	68 8d 01 00 00       	push   $0x18d
  8033f0:	68 e1 4a 80 00       	push   $0x804ae1
  8033f5:	e8 d6 d3 ff ff       	call   8007d0 <_panic>
  8033fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fd:	8b 50 04             	mov    0x4(%eax),%edx
  803400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803403:	89 50 04             	mov    %edx,0x4(%eax)
  803406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340c:	89 10                	mov    %edx,(%eax)
  80340e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	85 c0                	test   %eax,%eax
  803416:	74 0d                	je     803425 <merging+0x208>
  803418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803421:	89 10                	mov    %edx,(%eax)
  803423:	eb 08                	jmp    80342d <merging+0x210>
  803425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803428:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803430:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	a1 38 50 80 00       	mov    0x805038,%eax
  80343b:	40                   	inc    %eax
  80343c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803441:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803445:	75 17                	jne    80345e <merging+0x241>
  803447:	83 ec 04             	sub    $0x4,%esp
  80344a:	68 c3 4a 80 00       	push   $0x804ac3
  80344f:	68 8e 01 00 00       	push   $0x18e
  803454:	68 e1 4a 80 00       	push   $0x804ae1
  803459:	e8 72 d3 ff ff       	call   8007d0 <_panic>
  80345e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	85 c0                	test   %eax,%eax
  803465:	74 10                	je     803477 <merging+0x25a>
  803467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346a:	8b 00                	mov    (%eax),%eax
  80346c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346f:	8b 52 04             	mov    0x4(%edx),%edx
  803472:	89 50 04             	mov    %edx,0x4(%eax)
  803475:	eb 0b                	jmp    803482 <merging+0x265>
  803477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347a:	8b 40 04             	mov    0x4(%eax),%eax
  80347d:	a3 30 50 80 00       	mov    %eax,0x805030
  803482:	8b 45 0c             	mov    0xc(%ebp),%eax
  803485:	8b 40 04             	mov    0x4(%eax),%eax
  803488:	85 c0                	test   %eax,%eax
  80348a:	74 0f                	je     80349b <merging+0x27e>
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	8b 55 0c             	mov    0xc(%ebp),%edx
  803495:	8b 12                	mov    (%edx),%edx
  803497:	89 10                	mov    %edx,(%eax)
  803499:	eb 0a                	jmp    8034a5 <merging+0x288>
  80349b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034bd:	48                   	dec    %eax
  8034be:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034c3:	e9 72 01 00 00       	jmp    80363a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8034c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8034ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d2:	74 79                	je     80354d <merging+0x330>
  8034d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d8:	74 73                	je     80354d <merging+0x330>
  8034da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034de:	74 06                	je     8034e6 <merging+0x2c9>
  8034e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034e4:	75 17                	jne    8034fd <merging+0x2e0>
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 54 4b 80 00       	push   $0x804b54
  8034ee:	68 94 01 00 00       	push   $0x194
  8034f3:	68 e1 4a 80 00       	push   $0x804ae1
  8034f8:	e8 d3 d2 ff ff       	call   8007d0 <_panic>
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	8b 10                	mov    (%eax),%edx
  803502:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803505:	89 10                	mov    %edx,(%eax)
  803507:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	74 0b                	je     80351b <merging+0x2fe>
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803518:	89 50 04             	mov    %edx,0x4(%eax)
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803526:	8b 55 08             	mov    0x8(%ebp),%edx
  803529:	89 50 04             	mov    %edx,0x4(%eax)
  80352c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	75 08                	jne    80353d <merging+0x320>
  803535:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803538:	a3 30 50 80 00       	mov    %eax,0x805030
  80353d:	a1 38 50 80 00       	mov    0x805038,%eax
  803542:	40                   	inc    %eax
  803543:	a3 38 50 80 00       	mov    %eax,0x805038
  803548:	e9 ce 00 00 00       	jmp    80361b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80354d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803551:	74 65                	je     8035b8 <merging+0x39b>
  803553:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803557:	75 17                	jne    803570 <merging+0x353>
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	68 30 4b 80 00       	push   $0x804b30
  803561:	68 95 01 00 00       	push   $0x195
  803566:	68 e1 4a 80 00       	push   $0x804ae1
  80356b:	e8 60 d2 ff ff       	call   8007d0 <_panic>
  803570:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803576:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803579:	89 50 04             	mov    %edx,0x4(%eax)
  80357c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357f:	8b 40 04             	mov    0x4(%eax),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 0c                	je     803592 <merging+0x375>
  803586:	a1 30 50 80 00       	mov    0x805030,%eax
  80358b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	eb 08                	jmp    80359a <merging+0x37d>
  803592:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803595:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80359a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359d:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b0:	40                   	inc    %eax
  8035b1:	a3 38 50 80 00       	mov    %eax,0x805038
  8035b6:	eb 63                	jmp    80361b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8035b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035bc:	75 17                	jne    8035d5 <merging+0x3b8>
  8035be:	83 ec 04             	sub    $0x4,%esp
  8035c1:	68 fc 4a 80 00       	push   $0x804afc
  8035c6:	68 98 01 00 00       	push   $0x198
  8035cb:	68 e1 4a 80 00       	push   $0x804ae1
  8035d0:	e8 fb d1 ff ff       	call   8007d0 <_panic>
  8035d5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035de:	89 10                	mov    %edx,(%eax)
  8035e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e3:	8b 00                	mov    (%eax),%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 0d                	je     8035f6 <merging+0x3d9>
  8035e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035f1:	89 50 04             	mov    %edx,0x4(%eax)
  8035f4:	eb 08                	jmp    8035fe <merging+0x3e1>
  8035f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803601:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803606:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803609:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803610:	a1 38 50 80 00       	mov    0x805038,%eax
  803615:	40                   	inc    %eax
  803616:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80361b:	83 ec 0c             	sub    $0xc,%esp
  80361e:	ff 75 10             	pushl  0x10(%ebp)
  803621:	e8 f9 ed ff ff       	call   80241f <get_block_size>
  803626:	83 c4 10             	add    $0x10,%esp
  803629:	83 ec 04             	sub    $0x4,%esp
  80362c:	6a 00                	push   $0x0
  80362e:	50                   	push   %eax
  80362f:	ff 75 10             	pushl  0x10(%ebp)
  803632:	e8 39 f1 ff ff       	call   802770 <set_block_data>
  803637:	83 c4 10             	add    $0x10,%esp
	}
}
  80363a:	90                   	nop
  80363b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80363e:	c9                   	leave  
  80363f:	c3                   	ret    

00803640 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803640:	55                   	push   %ebp
  803641:	89 e5                	mov    %esp,%ebp
  803643:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803646:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80364b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80364e:	a1 30 50 80 00       	mov    0x805030,%eax
  803653:	3b 45 08             	cmp    0x8(%ebp),%eax
  803656:	73 1b                	jae    803673 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803658:	a1 30 50 80 00       	mov    0x805030,%eax
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	ff 75 08             	pushl  0x8(%ebp)
  803663:	6a 00                	push   $0x0
  803665:	50                   	push   %eax
  803666:	e8 b2 fb ff ff       	call   80321d <merging>
  80366b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80366e:	e9 8b 00 00 00       	jmp    8036fe <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803673:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803678:	3b 45 08             	cmp    0x8(%ebp),%eax
  80367b:	76 18                	jbe    803695 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80367d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	ff 75 08             	pushl  0x8(%ebp)
  803688:	50                   	push   %eax
  803689:	6a 00                	push   $0x0
  80368b:	e8 8d fb ff ff       	call   80321d <merging>
  803690:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803693:	eb 69                	jmp    8036fe <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803695:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369d:	eb 39                	jmp    8036d8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80369f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036a5:	73 29                	jae    8036d0 <free_block+0x90>
  8036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036af:	76 1f                	jbe    8036d0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8036b9:	83 ec 04             	sub    $0x4,%esp
  8036bc:	ff 75 08             	pushl  0x8(%ebp)
  8036bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8036c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c5:	e8 53 fb ff ff       	call   80321d <merging>
  8036ca:	83 c4 10             	add    $0x10,%esp
			break;
  8036cd:	90                   	nop
		}
	}
}
  8036ce:	eb 2e                	jmp    8036fe <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036d0:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036dc:	74 07                	je     8036e5 <free_block+0xa5>
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	eb 05                	jmp    8036ea <free_block+0xaa>
  8036e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8036ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	75 a7                	jne    80369f <free_block+0x5f>
  8036f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fc:	75 a1                	jne    80369f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036fe:	90                   	nop
  8036ff:	c9                   	leave  
  803700:	c3                   	ret    

00803701 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803701:	55                   	push   %ebp
  803702:	89 e5                	mov    %esp,%ebp
  803704:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803707:	ff 75 08             	pushl  0x8(%ebp)
  80370a:	e8 10 ed ff ff       	call   80241f <get_block_size>
  80370f:	83 c4 04             	add    $0x4,%esp
  803712:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803715:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80371c:	eb 17                	jmp    803735 <copy_data+0x34>
  80371e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803721:	8b 45 0c             	mov    0xc(%ebp),%eax
  803724:	01 c2                	add    %eax,%edx
  803726:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	01 c8                	add    %ecx,%eax
  80372e:	8a 00                	mov    (%eax),%al
  803730:	88 02                	mov    %al,(%edx)
  803732:	ff 45 fc             	incl   -0x4(%ebp)
  803735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803738:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80373b:	72 e1                	jb     80371e <copy_data+0x1d>
}
  80373d:	90                   	nop
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    

00803740 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803740:	55                   	push   %ebp
  803741:	89 e5                	mov    %esp,%ebp
  803743:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803746:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374a:	75 23                	jne    80376f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80374c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803750:	74 13                	je     803765 <realloc_block_FF+0x25>
  803752:	83 ec 0c             	sub    $0xc,%esp
  803755:	ff 75 0c             	pushl  0xc(%ebp)
  803758:	e8 42 f0 ff ff       	call   80279f <alloc_block_FF>
  80375d:	83 c4 10             	add    $0x10,%esp
  803760:	e9 e4 06 00 00       	jmp    803e49 <realloc_block_FF+0x709>
		return NULL;
  803765:	b8 00 00 00 00       	mov    $0x0,%eax
  80376a:	e9 da 06 00 00       	jmp    803e49 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80376f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803773:	75 18                	jne    80378d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803775:	83 ec 0c             	sub    $0xc,%esp
  803778:	ff 75 08             	pushl  0x8(%ebp)
  80377b:	e8 c0 fe ff ff       	call   803640 <free_block>
  803780:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803783:	b8 00 00 00 00       	mov    $0x0,%eax
  803788:	e9 bc 06 00 00       	jmp    803e49 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80378d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803791:	77 07                	ja     80379a <realloc_block_FF+0x5a>
  803793:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80379a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379d:	83 e0 01             	and    $0x1,%eax
  8037a0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8037a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a6:	83 c0 08             	add    $0x8,%eax
  8037a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8037ac:	83 ec 0c             	sub    $0xc,%esp
  8037af:	ff 75 08             	pushl  0x8(%ebp)
  8037b2:	e8 68 ec ff ff       	call   80241f <get_block_size>
  8037b7:	83 c4 10             	add    $0x10,%esp
  8037ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c0:	83 e8 08             	sub    $0x8,%eax
  8037c3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8037c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c9:	83 e8 04             	sub    $0x4,%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	83 e0 fe             	and    $0xfffffffe,%eax
  8037d1:	89 c2                	mov    %eax,%edx
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	01 d0                	add    %edx,%eax
  8037d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8037db:	83 ec 0c             	sub    $0xc,%esp
  8037de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037e1:	e8 39 ec ff ff       	call   80241f <get_block_size>
  8037e6:	83 c4 10             	add    $0x10,%esp
  8037e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ef:	83 e8 08             	sub    $0x8,%eax
  8037f2:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8037f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037fb:	75 08                	jne    803805 <realloc_block_FF+0xc5>
	{
		 return va;
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	e9 44 06 00 00       	jmp    803e49 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803805:	8b 45 0c             	mov    0xc(%ebp),%eax
  803808:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80380b:	0f 83 d5 03 00 00    	jae    803be6 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	2b 45 0c             	sub    0xc(%ebp),%eax
  803817:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80381a:	83 ec 0c             	sub    $0xc,%esp
  80381d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803820:	e8 13 ec ff ff       	call   802438 <is_free_block>
  803825:	83 c4 10             	add    $0x10,%esp
  803828:	84 c0                	test   %al,%al
  80382a:	0f 84 3b 01 00 00    	je     80396b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803830:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803833:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803836:	01 d0                	add    %edx,%eax
  803838:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	6a 01                	push   $0x1
  803840:	ff 75 f0             	pushl  -0x10(%ebp)
  803843:	ff 75 08             	pushl  0x8(%ebp)
  803846:	e8 25 ef ff ff       	call   802770 <set_block_data>
  80384b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	83 e8 04             	sub    $0x4,%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	83 e0 fe             	and    $0xfffffffe,%eax
  803859:	89 c2                	mov    %eax,%edx
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	01 d0                	add    %edx,%eax
  803860:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803863:	83 ec 04             	sub    $0x4,%esp
  803866:	6a 00                	push   $0x0
  803868:	ff 75 cc             	pushl  -0x34(%ebp)
  80386b:	ff 75 c8             	pushl  -0x38(%ebp)
  80386e:	e8 fd ee ff ff       	call   802770 <set_block_data>
  803873:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803876:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80387a:	74 06                	je     803882 <realloc_block_FF+0x142>
  80387c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803880:	75 17                	jne    803899 <realloc_block_FF+0x159>
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	68 54 4b 80 00       	push   $0x804b54
  80388a:	68 f6 01 00 00       	push   $0x1f6
  80388f:	68 e1 4a 80 00       	push   $0x804ae1
  803894:	e8 37 cf ff ff       	call   8007d0 <_panic>
  803899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389c:	8b 10                	mov    (%eax),%edx
  80389e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038a1:	89 10                	mov    %edx,(%eax)
  8038a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038a6:	8b 00                	mov    (%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	74 0b                	je     8038b7 <realloc_block_FF+0x177>
  8038ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038bd:	89 10                	mov    %edx,(%eax)
  8038bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c5:	89 50 04             	mov    %edx,0x4(%eax)
  8038c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038cb:	8b 00                	mov    (%eax),%eax
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	75 08                	jne    8038d9 <realloc_block_FF+0x199>
  8038d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8038d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038de:	40                   	inc    %eax
  8038df:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e8:	75 17                	jne    803901 <realloc_block_FF+0x1c1>
  8038ea:	83 ec 04             	sub    $0x4,%esp
  8038ed:	68 c3 4a 80 00       	push   $0x804ac3
  8038f2:	68 f7 01 00 00       	push   $0x1f7
  8038f7:	68 e1 4a 80 00       	push   $0x804ae1
  8038fc:	e8 cf ce ff ff       	call   8007d0 <_panic>
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 10                	je     80391a <realloc_block_FF+0x1da>
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803912:	8b 52 04             	mov    0x4(%edx),%edx
  803915:	89 50 04             	mov    %edx,0x4(%eax)
  803918:	eb 0b                	jmp    803925 <realloc_block_FF+0x1e5>
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	8b 40 04             	mov    0x4(%eax),%eax
  803920:	a3 30 50 80 00       	mov    %eax,0x805030
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	8b 40 04             	mov    0x4(%eax),%eax
  80392b:	85 c0                	test   %eax,%eax
  80392d:	74 0f                	je     80393e <realloc_block_FF+0x1fe>
  80392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803932:	8b 40 04             	mov    0x4(%eax),%eax
  803935:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803938:	8b 12                	mov    (%edx),%edx
  80393a:	89 10                	mov    %edx,(%eax)
  80393c:	eb 0a                	jmp    803948 <realloc_block_FF+0x208>
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395b:	a1 38 50 80 00       	mov    0x805038,%eax
  803960:	48                   	dec    %eax
  803961:	a3 38 50 80 00       	mov    %eax,0x805038
  803966:	e9 73 02 00 00       	jmp    803bde <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80396b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80396f:	0f 86 69 02 00 00    	jbe    803bde <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803975:	83 ec 04             	sub    $0x4,%esp
  803978:	6a 01                	push   $0x1
  80397a:	ff 75 f0             	pushl  -0x10(%ebp)
  80397d:	ff 75 08             	pushl  0x8(%ebp)
  803980:	e8 eb ed ff ff       	call   802770 <set_block_data>
  803985:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	83 e8 04             	sub    $0x4,%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	83 e0 fe             	and    $0xfffffffe,%eax
  803993:	89 c2                	mov    %eax,%edx
  803995:	8b 45 08             	mov    0x8(%ebp),%eax
  803998:	01 d0                	add    %edx,%eax
  80399a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80399d:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8039a5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039a9:	75 68                	jne    803a13 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039af:	75 17                	jne    8039c8 <realloc_block_FF+0x288>
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 fc 4a 80 00       	push   $0x804afc
  8039b9:	68 06 02 00 00       	push   $0x206
  8039be:	68 e1 4a 80 00       	push   $0x804ae1
  8039c3:	e8 08 ce ff ff       	call   8007d0 <_panic>
  8039c8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d1:	89 10                	mov    %edx,(%eax)
  8039d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 0d                	je     8039e9 <realloc_block_FF+0x2a9>
  8039dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%eax)
  8039e7:	eb 08                	jmp    8039f1 <realloc_block_FF+0x2b1>
  8039e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a03:	a1 38 50 80 00       	mov    0x805038,%eax
  803a08:	40                   	inc    %eax
  803a09:	a3 38 50 80 00       	mov    %eax,0x805038
  803a0e:	e9 b0 01 00 00       	jmp    803bc3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a18:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a1b:	76 68                	jbe    803a85 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a21:	75 17                	jne    803a3a <realloc_block_FF+0x2fa>
  803a23:	83 ec 04             	sub    $0x4,%esp
  803a26:	68 fc 4a 80 00       	push   $0x804afc
  803a2b:	68 0b 02 00 00       	push   $0x20b
  803a30:	68 e1 4a 80 00       	push   $0x804ae1
  803a35:	e8 96 cd ff ff       	call   8007d0 <_panic>
  803a3a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803a40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a43:	89 10                	mov    %edx,(%eax)
  803a45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	85 c0                	test   %eax,%eax
  803a4c:	74 0d                	je     803a5b <realloc_block_FF+0x31b>
  803a4e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a56:	89 50 04             	mov    %edx,0x4(%eax)
  803a59:	eb 08                	jmp    803a63 <realloc_block_FF+0x323>
  803a5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a5e:	a3 30 50 80 00       	mov    %eax,0x805030
  803a63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a66:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a75:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7a:	40                   	inc    %eax
  803a7b:	a3 38 50 80 00       	mov    %eax,0x805038
  803a80:	e9 3e 01 00 00       	jmp    803bc3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a85:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a8a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a8d:	73 68                	jae    803af7 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a8f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a93:	75 17                	jne    803aac <realloc_block_FF+0x36c>
  803a95:	83 ec 04             	sub    $0x4,%esp
  803a98:	68 30 4b 80 00       	push   $0x804b30
  803a9d:	68 10 02 00 00       	push   $0x210
  803aa2:	68 e1 4a 80 00       	push   $0x804ae1
  803aa7:	e8 24 cd ff ff       	call   8007d0 <_panic>
  803aac:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab5:	89 50 04             	mov    %edx,0x4(%eax)
  803ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abb:	8b 40 04             	mov    0x4(%eax),%eax
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	74 0c                	je     803ace <realloc_block_FF+0x38e>
  803ac2:	a1 30 50 80 00       	mov    0x805030,%eax
  803ac7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803aca:	89 10                	mov    %edx,(%eax)
  803acc:	eb 08                	jmp    803ad6 <realloc_block_FF+0x396>
  803ace:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ad6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad9:	a3 30 50 80 00       	mov    %eax,0x805030
  803ade:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae7:	a1 38 50 80 00       	mov    0x805038,%eax
  803aec:	40                   	inc    %eax
  803aed:	a3 38 50 80 00       	mov    %eax,0x805038
  803af2:	e9 cc 00 00 00       	jmp    803bc3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803afe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b06:	e9 8a 00 00 00       	jmp    803b95 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b11:	73 7a                	jae    803b8d <realloc_block_FF+0x44d>
  803b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b1b:	73 70                	jae    803b8d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b21:	74 06                	je     803b29 <realloc_block_FF+0x3e9>
  803b23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b27:	75 17                	jne    803b40 <realloc_block_FF+0x400>
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	68 54 4b 80 00       	push   $0x804b54
  803b31:	68 1a 02 00 00       	push   $0x21a
  803b36:	68 e1 4a 80 00       	push   $0x804ae1
  803b3b:	e8 90 cc ff ff       	call   8007d0 <_panic>
  803b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b43:	8b 10                	mov    (%eax),%edx
  803b45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b48:	89 10                	mov    %edx,(%eax)
  803b4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4d:	8b 00                	mov    (%eax),%eax
  803b4f:	85 c0                	test   %eax,%eax
  803b51:	74 0b                	je     803b5e <realloc_block_FF+0x41e>
  803b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b56:	8b 00                	mov    (%eax),%eax
  803b58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b5b:	89 50 04             	mov    %edx,0x4(%eax)
  803b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b64:	89 10                	mov    %edx,(%eax)
  803b66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b6c:	89 50 04             	mov    %edx,0x4(%eax)
  803b6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b72:	8b 00                	mov    (%eax),%eax
  803b74:	85 c0                	test   %eax,%eax
  803b76:	75 08                	jne    803b80 <realloc_block_FF+0x440>
  803b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7b:	a3 30 50 80 00       	mov    %eax,0x805030
  803b80:	a1 38 50 80 00       	mov    0x805038,%eax
  803b85:	40                   	inc    %eax
  803b86:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b8b:	eb 36                	jmp    803bc3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b8d:	a1 34 50 80 00       	mov    0x805034,%eax
  803b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b99:	74 07                	je     803ba2 <realloc_block_FF+0x462>
  803b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9e:	8b 00                	mov    (%eax),%eax
  803ba0:	eb 05                	jmp    803ba7 <realloc_block_FF+0x467>
  803ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba7:	a3 34 50 80 00       	mov    %eax,0x805034
  803bac:	a1 34 50 80 00       	mov    0x805034,%eax
  803bb1:	85 c0                	test   %eax,%eax
  803bb3:	0f 85 52 ff ff ff    	jne    803b0b <realloc_block_FF+0x3cb>
  803bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bbd:	0f 85 48 ff ff ff    	jne    803b0b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803bc3:	83 ec 04             	sub    $0x4,%esp
  803bc6:	6a 00                	push   $0x0
  803bc8:	ff 75 d8             	pushl  -0x28(%ebp)
  803bcb:	ff 75 d4             	pushl  -0x2c(%ebp)
  803bce:	e8 9d eb ff ff       	call   802770 <set_block_data>
  803bd3:	83 c4 10             	add    $0x10,%esp
				return va;
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	e9 6b 02 00 00       	jmp    803e49 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803bde:	8b 45 08             	mov    0x8(%ebp),%eax
  803be1:	e9 63 02 00 00       	jmp    803e49 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bec:	0f 86 4d 02 00 00    	jbe    803e3f <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803bf2:	83 ec 0c             	sub    $0xc,%esp
  803bf5:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bf8:	e8 3b e8 ff ff       	call   802438 <is_free_block>
  803bfd:	83 c4 10             	add    $0x10,%esp
  803c00:	84 c0                	test   %al,%al
  803c02:	0f 84 37 02 00 00    	je     803e3f <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c0b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c14:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c17:	76 38                	jbe    803c51 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c19:	83 ec 0c             	sub    $0xc,%esp
  803c1c:	ff 75 0c             	pushl  0xc(%ebp)
  803c1f:	e8 7b eb ff ff       	call   80279f <alloc_block_FF>
  803c24:	83 c4 10             	add    $0x10,%esp
  803c27:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c2a:	83 ec 08             	sub    $0x8,%esp
  803c2d:	ff 75 c0             	pushl  -0x40(%ebp)
  803c30:	ff 75 08             	pushl  0x8(%ebp)
  803c33:	e8 c9 fa ff ff       	call   803701 <copy_data>
  803c38:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803c3b:	83 ec 0c             	sub    $0xc,%esp
  803c3e:	ff 75 08             	pushl  0x8(%ebp)
  803c41:	e8 fa f9 ff ff       	call   803640 <free_block>
  803c46:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c49:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c4c:	e9 f8 01 00 00       	jmp    803e49 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c54:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c57:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c5a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c5e:	0f 87 a0 00 00 00    	ja     803d04 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c68:	75 17                	jne    803c81 <realloc_block_FF+0x541>
  803c6a:	83 ec 04             	sub    $0x4,%esp
  803c6d:	68 c3 4a 80 00       	push   $0x804ac3
  803c72:	68 38 02 00 00       	push   $0x238
  803c77:	68 e1 4a 80 00       	push   $0x804ae1
  803c7c:	e8 4f cb ff ff       	call   8007d0 <_panic>
  803c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c84:	8b 00                	mov    (%eax),%eax
  803c86:	85 c0                	test   %eax,%eax
  803c88:	74 10                	je     803c9a <realloc_block_FF+0x55a>
  803c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8d:	8b 00                	mov    (%eax),%eax
  803c8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c92:	8b 52 04             	mov    0x4(%edx),%edx
  803c95:	89 50 04             	mov    %edx,0x4(%eax)
  803c98:	eb 0b                	jmp    803ca5 <realloc_block_FF+0x565>
  803c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9d:	8b 40 04             	mov    0x4(%eax),%eax
  803ca0:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca8:	8b 40 04             	mov    0x4(%eax),%eax
  803cab:	85 c0                	test   %eax,%eax
  803cad:	74 0f                	je     803cbe <realloc_block_FF+0x57e>
  803caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb2:	8b 40 04             	mov    0x4(%eax),%eax
  803cb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cb8:	8b 12                	mov    (%edx),%edx
  803cba:	89 10                	mov    %edx,(%eax)
  803cbc:	eb 0a                	jmp    803cc8 <realloc_block_FF+0x588>
  803cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc1:	8b 00                	mov    (%eax),%eax
  803cc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdb:	a1 38 50 80 00       	mov    0x805038,%eax
  803ce0:	48                   	dec    %eax
  803ce1:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ce6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cec:	01 d0                	add    %edx,%eax
  803cee:	83 ec 04             	sub    $0x4,%esp
  803cf1:	6a 01                	push   $0x1
  803cf3:	50                   	push   %eax
  803cf4:	ff 75 08             	pushl  0x8(%ebp)
  803cf7:	e8 74 ea ff ff       	call   802770 <set_block_data>
  803cfc:	83 c4 10             	add    $0x10,%esp
  803cff:	e9 36 01 00 00       	jmp    803e3a <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d0a:	01 d0                	add    %edx,%eax
  803d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d0f:	83 ec 04             	sub    $0x4,%esp
  803d12:	6a 01                	push   $0x1
  803d14:	ff 75 f0             	pushl  -0x10(%ebp)
  803d17:	ff 75 08             	pushl  0x8(%ebp)
  803d1a:	e8 51 ea ff ff       	call   802770 <set_block_data>
  803d1f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d22:	8b 45 08             	mov    0x8(%ebp),%eax
  803d25:	83 e8 04             	sub    $0x4,%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	83 e0 fe             	and    $0xfffffffe,%eax
  803d2d:	89 c2                	mov    %eax,%edx
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	01 d0                	add    %edx,%eax
  803d34:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d3b:	74 06                	je     803d43 <realloc_block_FF+0x603>
  803d3d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d41:	75 17                	jne    803d5a <realloc_block_FF+0x61a>
  803d43:	83 ec 04             	sub    $0x4,%esp
  803d46:	68 54 4b 80 00       	push   $0x804b54
  803d4b:	68 44 02 00 00       	push   $0x244
  803d50:	68 e1 4a 80 00       	push   $0x804ae1
  803d55:	e8 76 ca ff ff       	call   8007d0 <_panic>
  803d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5d:	8b 10                	mov    (%eax),%edx
  803d5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d62:	89 10                	mov    %edx,(%eax)
  803d64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d67:	8b 00                	mov    (%eax),%eax
  803d69:	85 c0                	test   %eax,%eax
  803d6b:	74 0b                	je     803d78 <realloc_block_FF+0x638>
  803d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d75:	89 50 04             	mov    %edx,0x4(%eax)
  803d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d7e:	89 10                	mov    %edx,(%eax)
  803d80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d86:	89 50 04             	mov    %edx,0x4(%eax)
  803d89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d8c:	8b 00                	mov    (%eax),%eax
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	75 08                	jne    803d9a <realloc_block_FF+0x65a>
  803d92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d95:	a3 30 50 80 00       	mov    %eax,0x805030
  803d9a:	a1 38 50 80 00       	mov    0x805038,%eax
  803d9f:	40                   	inc    %eax
  803da0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803da5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803da9:	75 17                	jne    803dc2 <realloc_block_FF+0x682>
  803dab:	83 ec 04             	sub    $0x4,%esp
  803dae:	68 c3 4a 80 00       	push   $0x804ac3
  803db3:	68 45 02 00 00       	push   $0x245
  803db8:	68 e1 4a 80 00       	push   $0x804ae1
  803dbd:	e8 0e ca ff ff       	call   8007d0 <_panic>
  803dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc5:	8b 00                	mov    (%eax),%eax
  803dc7:	85 c0                	test   %eax,%eax
  803dc9:	74 10                	je     803ddb <realloc_block_FF+0x69b>
  803dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dd3:	8b 52 04             	mov    0x4(%edx),%edx
  803dd6:	89 50 04             	mov    %edx,0x4(%eax)
  803dd9:	eb 0b                	jmp    803de6 <realloc_block_FF+0x6a6>
  803ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dde:	8b 40 04             	mov    0x4(%eax),%eax
  803de1:	a3 30 50 80 00       	mov    %eax,0x805030
  803de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de9:	8b 40 04             	mov    0x4(%eax),%eax
  803dec:	85 c0                	test   %eax,%eax
  803dee:	74 0f                	je     803dff <realloc_block_FF+0x6bf>
  803df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df3:	8b 40 04             	mov    0x4(%eax),%eax
  803df6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803df9:	8b 12                	mov    (%edx),%edx
  803dfb:	89 10                	mov    %edx,(%eax)
  803dfd:	eb 0a                	jmp    803e09 <realloc_block_FF+0x6c9>
  803dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e02:	8b 00                	mov    (%eax),%eax
  803e04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e1c:	a1 38 50 80 00       	mov    0x805038,%eax
  803e21:	48                   	dec    %eax
  803e22:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803e27:	83 ec 04             	sub    $0x4,%esp
  803e2a:	6a 00                	push   $0x0
  803e2c:	ff 75 bc             	pushl  -0x44(%ebp)
  803e2f:	ff 75 b8             	pushl  -0x48(%ebp)
  803e32:	e8 39 e9 ff ff       	call   802770 <set_block_data>
  803e37:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3d:	eb 0a                	jmp    803e49 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e3f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e49:	c9                   	leave  
  803e4a:	c3                   	ret    

00803e4b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e4b:	55                   	push   %ebp
  803e4c:	89 e5                	mov    %esp,%ebp
  803e4e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e51:	83 ec 04             	sub    $0x4,%esp
  803e54:	68 c0 4b 80 00       	push   $0x804bc0
  803e59:	68 58 02 00 00       	push   $0x258
  803e5e:	68 e1 4a 80 00       	push   $0x804ae1
  803e63:	e8 68 c9 ff ff       	call   8007d0 <_panic>

00803e68 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e68:	55                   	push   %ebp
  803e69:	89 e5                	mov    %esp,%ebp
  803e6b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e6e:	83 ec 04             	sub    $0x4,%esp
  803e71:	68 e8 4b 80 00       	push   $0x804be8
  803e76:	68 61 02 00 00       	push   $0x261
  803e7b:	68 e1 4a 80 00       	push   $0x804ae1
  803e80:	e8 4b c9 ff ff       	call   8007d0 <_panic>

00803e85 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803e85:	55                   	push   %ebp
  803e86:	89 e5                	mov    %esp,%ebp
  803e88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803e8b:	83 ec 04             	sub    $0x4,%esp
  803e8e:	6a 01                	push   $0x1
  803e90:	6a 04                	push   $0x4
  803e92:	ff 75 0c             	pushl  0xc(%ebp)
  803e95:	e8 c1 dc ff ff       	call   801b5b <smalloc>
  803e9a:	83 c4 10             	add    $0x10,%esp
  803e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  803ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea4:	75 14                	jne    803eba <create_semaphore+0x35>
  803ea6:	83 ec 04             	sub    $0x4,%esp
  803ea9:	68 0e 4c 80 00       	push   $0x804c0e
  803eae:	6a 0d                	push   $0xd
  803eb0:	68 2b 4c 80 00       	push   $0x804c2b
  803eb5:	e8 16 c9 ff ff       	call   8007d0 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  803ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec3:	8b 00                	mov    (%eax),%eax
  803ec5:	8b 55 10             	mov    0x10(%ebp),%edx
  803ec8:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  803ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	83 ec 0c             	sub    $0xc,%esp
  803ed3:	50                   	push   %eax
  803ed4:	e8 cc e4 ff ff       	call   8023a5 <sys_init_queue>
  803ed9:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  803edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803edf:	8b 00                	mov    (%eax),%eax
  803ee1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eee:	8b 12                	mov    (%edx),%edx
  803ef0:	89 10                	mov    %edx,(%eax)
}
  803ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef5:	c9                   	leave  
  803ef6:	c2 04 00             	ret    $0x4

00803ef9 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803ef9:	55                   	push   %ebp
  803efa:	89 e5                	mov    %esp,%ebp
  803efc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803eff:	83 ec 08             	sub    $0x8,%esp
  803f02:	ff 75 10             	pushl  0x10(%ebp)
  803f05:	ff 75 0c             	pushl  0xc(%ebp)
  803f08:	e8 f3 dc ff ff       	call   801c00 <sget>
  803f0d:	83 c4 10             	add    $0x10,%esp
  803f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f17:	75 14                	jne    803f2d <get_semaphore+0x34>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 3b 4c 80 00       	push   $0x804c3b
  803f21:	6a 1f                	push   $0x1f
  803f23:	68 2b 4c 80 00       	push   $0x804c2b
  803f28:	e8 a3 c8 ff ff       	call   8007d0 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f39:	8b 12                	mov    (%edx),%edx
  803f3b:	89 10                	mov    %edx,(%eax)
}
  803f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f40:	c9                   	leave  
  803f41:	c2 04 00             	ret    $0x4

00803f44 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803f44:	55                   	push   %ebp
  803f45:	89 e5                	mov    %esp,%ebp
  803f47:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  803f4a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803f51:	8b 45 08             	mov    0x8(%ebp),%eax
  803f54:	83 c0 14             	add    $0x14,%eax
  803f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803f60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f66:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803f69:	f0 87 02             	lock xchg %eax,(%edx)
  803f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f73:	75 dc                	jne    803f51 <wait_semaphore+0xd>

		    sem.semdata->count--;
  803f75:	8b 45 08             	mov    0x8(%ebp),%eax
  803f78:	8b 50 10             	mov    0x10(%eax),%edx
  803f7b:	4a                   	dec    %edx
  803f7c:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f82:	8b 40 10             	mov    0x10(%eax),%eax
  803f85:	85 c0                	test   %eax,%eax
  803f87:	79 30                	jns    803fb9 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  803f89:	e8 f5 e3 ff ff       	call   802383 <sys_get_cpu_process>
  803f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803f91:	8b 45 08             	mov    0x8(%ebp),%eax
  803f94:	83 ec 08             	sub    $0x8,%esp
  803f97:	ff 75 f0             	pushl  -0x10(%ebp)
  803f9a:	50                   	push   %eax
  803f9b:	e8 21 e4 ff ff       	call   8023c1 <sys_enqueue>
  803fa0:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa6:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803fad:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  803fb7:	eb 0a                	jmp    803fc3 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  803fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803fc3:	90                   	nop
  803fc4:	c9                   	leave  
  803fc5:	c3                   	ret    

00803fc6 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  803fc6:	55                   	push   %ebp
  803fc7:	89 e5                	mov    %esp,%ebp
  803fc9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803fcc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd6:	83 c0 14             	add    $0x14,%eax
  803fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803fe2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803feb:	f0 87 02             	lock xchg %eax,(%edx)
  803fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff5:	75 dc                	jne    803fd3 <signal_semaphore+0xd>
	    sem.semdata->count++;
  803ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffa:	8b 50 10             	mov    0x10(%eax),%edx
  803ffd:	42                   	inc    %edx
  803ffe:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  804001:	8b 45 08             	mov    0x8(%ebp),%eax
  804004:	8b 40 10             	mov    0x10(%eax),%eax
  804007:	85 c0                	test   %eax,%eax
  804009:	7f 20                	jg     80402b <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  80400b:	8b 45 08             	mov    0x8(%ebp),%eax
  80400e:	83 ec 0c             	sub    $0xc,%esp
  804011:	50                   	push   %eax
  804012:	e8 c8 e3 ff ff       	call   8023df <sys_dequeue>
  804017:	83 c4 10             	add    $0x10,%esp
  80401a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  80401d:	83 ec 0c             	sub    $0xc,%esp
  804020:	ff 75 f0             	pushl  -0x10(%ebp)
  804023:	e8 db e3 ff ff       	call   802403 <sys_sched_insert_ready>
  804028:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  80402b:	8b 45 08             	mov    0x8(%ebp),%eax
  80402e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  804035:	90                   	nop
  804036:	c9                   	leave  
  804037:	c3                   	ret    

00804038 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  804038:	55                   	push   %ebp
  804039:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80403b:	8b 45 08             	mov    0x8(%ebp),%eax
  80403e:	8b 40 10             	mov    0x10(%eax),%eax
}
  804041:	5d                   	pop    %ebp
  804042:	c3                   	ret    
  804043:	90                   	nop

00804044 <__udivdi3>:
  804044:	55                   	push   %ebp
  804045:	57                   	push   %edi
  804046:	56                   	push   %esi
  804047:	53                   	push   %ebx
  804048:	83 ec 1c             	sub    $0x1c,%esp
  80404b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80404f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804053:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804057:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80405b:	89 ca                	mov    %ecx,%edx
  80405d:	89 f8                	mov    %edi,%eax
  80405f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804063:	85 f6                	test   %esi,%esi
  804065:	75 2d                	jne    804094 <__udivdi3+0x50>
  804067:	39 cf                	cmp    %ecx,%edi
  804069:	77 65                	ja     8040d0 <__udivdi3+0x8c>
  80406b:	89 fd                	mov    %edi,%ebp
  80406d:	85 ff                	test   %edi,%edi
  80406f:	75 0b                	jne    80407c <__udivdi3+0x38>
  804071:	b8 01 00 00 00       	mov    $0x1,%eax
  804076:	31 d2                	xor    %edx,%edx
  804078:	f7 f7                	div    %edi
  80407a:	89 c5                	mov    %eax,%ebp
  80407c:	31 d2                	xor    %edx,%edx
  80407e:	89 c8                	mov    %ecx,%eax
  804080:	f7 f5                	div    %ebp
  804082:	89 c1                	mov    %eax,%ecx
  804084:	89 d8                	mov    %ebx,%eax
  804086:	f7 f5                	div    %ebp
  804088:	89 cf                	mov    %ecx,%edi
  80408a:	89 fa                	mov    %edi,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	39 ce                	cmp    %ecx,%esi
  804096:	77 28                	ja     8040c0 <__udivdi3+0x7c>
  804098:	0f bd fe             	bsr    %esi,%edi
  80409b:	83 f7 1f             	xor    $0x1f,%edi
  80409e:	75 40                	jne    8040e0 <__udivdi3+0x9c>
  8040a0:	39 ce                	cmp    %ecx,%esi
  8040a2:	72 0a                	jb     8040ae <__udivdi3+0x6a>
  8040a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040a8:	0f 87 9e 00 00 00    	ja     80414c <__udivdi3+0x108>
  8040ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8040b3:	89 fa                	mov    %edi,%edx
  8040b5:	83 c4 1c             	add    $0x1c,%esp
  8040b8:	5b                   	pop    %ebx
  8040b9:	5e                   	pop    %esi
  8040ba:	5f                   	pop    %edi
  8040bb:	5d                   	pop    %ebp
  8040bc:	c3                   	ret    
  8040bd:	8d 76 00             	lea    0x0(%esi),%esi
  8040c0:	31 ff                	xor    %edi,%edi
  8040c2:	31 c0                	xor    %eax,%eax
  8040c4:	89 fa                	mov    %edi,%edx
  8040c6:	83 c4 1c             	add    $0x1c,%esp
  8040c9:	5b                   	pop    %ebx
  8040ca:	5e                   	pop    %esi
  8040cb:	5f                   	pop    %edi
  8040cc:	5d                   	pop    %ebp
  8040cd:	c3                   	ret    
  8040ce:	66 90                	xchg   %ax,%ax
  8040d0:	89 d8                	mov    %ebx,%eax
  8040d2:	f7 f7                	div    %edi
  8040d4:	31 ff                	xor    %edi,%edi
  8040d6:	89 fa                	mov    %edi,%edx
  8040d8:	83 c4 1c             	add    $0x1c,%esp
  8040db:	5b                   	pop    %ebx
  8040dc:	5e                   	pop    %esi
  8040dd:	5f                   	pop    %edi
  8040de:	5d                   	pop    %ebp
  8040df:	c3                   	ret    
  8040e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040e5:	89 eb                	mov    %ebp,%ebx
  8040e7:	29 fb                	sub    %edi,%ebx
  8040e9:	89 f9                	mov    %edi,%ecx
  8040eb:	d3 e6                	shl    %cl,%esi
  8040ed:	89 c5                	mov    %eax,%ebp
  8040ef:	88 d9                	mov    %bl,%cl
  8040f1:	d3 ed                	shr    %cl,%ebp
  8040f3:	89 e9                	mov    %ebp,%ecx
  8040f5:	09 f1                	or     %esi,%ecx
  8040f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040fb:	89 f9                	mov    %edi,%ecx
  8040fd:	d3 e0                	shl    %cl,%eax
  8040ff:	89 c5                	mov    %eax,%ebp
  804101:	89 d6                	mov    %edx,%esi
  804103:	88 d9                	mov    %bl,%cl
  804105:	d3 ee                	shr    %cl,%esi
  804107:	89 f9                	mov    %edi,%ecx
  804109:	d3 e2                	shl    %cl,%edx
  80410b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80410f:	88 d9                	mov    %bl,%cl
  804111:	d3 e8                	shr    %cl,%eax
  804113:	09 c2                	or     %eax,%edx
  804115:	89 d0                	mov    %edx,%eax
  804117:	89 f2                	mov    %esi,%edx
  804119:	f7 74 24 0c          	divl   0xc(%esp)
  80411d:	89 d6                	mov    %edx,%esi
  80411f:	89 c3                	mov    %eax,%ebx
  804121:	f7 e5                	mul    %ebp
  804123:	39 d6                	cmp    %edx,%esi
  804125:	72 19                	jb     804140 <__udivdi3+0xfc>
  804127:	74 0b                	je     804134 <__udivdi3+0xf0>
  804129:	89 d8                	mov    %ebx,%eax
  80412b:	31 ff                	xor    %edi,%edi
  80412d:	e9 58 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  804132:	66 90                	xchg   %ax,%ax
  804134:	8b 54 24 08          	mov    0x8(%esp),%edx
  804138:	89 f9                	mov    %edi,%ecx
  80413a:	d3 e2                	shl    %cl,%edx
  80413c:	39 c2                	cmp    %eax,%edx
  80413e:	73 e9                	jae    804129 <__udivdi3+0xe5>
  804140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804143:	31 ff                	xor    %edi,%edi
  804145:	e9 40 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	31 c0                	xor    %eax,%eax
  80414e:	e9 37 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  804153:	90                   	nop

00804154 <__umoddi3>:
  804154:	55                   	push   %ebp
  804155:	57                   	push   %edi
  804156:	56                   	push   %esi
  804157:	53                   	push   %ebx
  804158:	83 ec 1c             	sub    $0x1c,%esp
  80415b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80415f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804167:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80416b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80416f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804173:	89 f3                	mov    %esi,%ebx
  804175:	89 fa                	mov    %edi,%edx
  804177:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80417b:	89 34 24             	mov    %esi,(%esp)
  80417e:	85 c0                	test   %eax,%eax
  804180:	75 1a                	jne    80419c <__umoddi3+0x48>
  804182:	39 f7                	cmp    %esi,%edi
  804184:	0f 86 a2 00 00 00    	jbe    80422c <__umoddi3+0xd8>
  80418a:	89 c8                	mov    %ecx,%eax
  80418c:	89 f2                	mov    %esi,%edx
  80418e:	f7 f7                	div    %edi
  804190:	89 d0                	mov    %edx,%eax
  804192:	31 d2                	xor    %edx,%edx
  804194:	83 c4 1c             	add    $0x1c,%esp
  804197:	5b                   	pop    %ebx
  804198:	5e                   	pop    %esi
  804199:	5f                   	pop    %edi
  80419a:	5d                   	pop    %ebp
  80419b:	c3                   	ret    
  80419c:	39 f0                	cmp    %esi,%eax
  80419e:	0f 87 ac 00 00 00    	ja     804250 <__umoddi3+0xfc>
  8041a4:	0f bd e8             	bsr    %eax,%ebp
  8041a7:	83 f5 1f             	xor    $0x1f,%ebp
  8041aa:	0f 84 ac 00 00 00    	je     80425c <__umoddi3+0x108>
  8041b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8041b5:	29 ef                	sub    %ebp,%edi
  8041b7:	89 fe                	mov    %edi,%esi
  8041b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041bd:	89 e9                	mov    %ebp,%ecx
  8041bf:	d3 e0                	shl    %cl,%eax
  8041c1:	89 d7                	mov    %edx,%edi
  8041c3:	89 f1                	mov    %esi,%ecx
  8041c5:	d3 ef                	shr    %cl,%edi
  8041c7:	09 c7                	or     %eax,%edi
  8041c9:	89 e9                	mov    %ebp,%ecx
  8041cb:	d3 e2                	shl    %cl,%edx
  8041cd:	89 14 24             	mov    %edx,(%esp)
  8041d0:	89 d8                	mov    %ebx,%eax
  8041d2:	d3 e0                	shl    %cl,%eax
  8041d4:	89 c2                	mov    %eax,%edx
  8041d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041da:	d3 e0                	shl    %cl,%eax
  8041dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041e4:	89 f1                	mov    %esi,%ecx
  8041e6:	d3 e8                	shr    %cl,%eax
  8041e8:	09 d0                	or     %edx,%eax
  8041ea:	d3 eb                	shr    %cl,%ebx
  8041ec:	89 da                	mov    %ebx,%edx
  8041ee:	f7 f7                	div    %edi
  8041f0:	89 d3                	mov    %edx,%ebx
  8041f2:	f7 24 24             	mull   (%esp)
  8041f5:	89 c6                	mov    %eax,%esi
  8041f7:	89 d1                	mov    %edx,%ecx
  8041f9:	39 d3                	cmp    %edx,%ebx
  8041fb:	0f 82 87 00 00 00    	jb     804288 <__umoddi3+0x134>
  804201:	0f 84 91 00 00 00    	je     804298 <__umoddi3+0x144>
  804207:	8b 54 24 04          	mov    0x4(%esp),%edx
  80420b:	29 f2                	sub    %esi,%edx
  80420d:	19 cb                	sbb    %ecx,%ebx
  80420f:	89 d8                	mov    %ebx,%eax
  804211:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804215:	d3 e0                	shl    %cl,%eax
  804217:	89 e9                	mov    %ebp,%ecx
  804219:	d3 ea                	shr    %cl,%edx
  80421b:	09 d0                	or     %edx,%eax
  80421d:	89 e9                	mov    %ebp,%ecx
  80421f:	d3 eb                	shr    %cl,%ebx
  804221:	89 da                	mov    %ebx,%edx
  804223:	83 c4 1c             	add    $0x1c,%esp
  804226:	5b                   	pop    %ebx
  804227:	5e                   	pop    %esi
  804228:	5f                   	pop    %edi
  804229:	5d                   	pop    %ebp
  80422a:	c3                   	ret    
  80422b:	90                   	nop
  80422c:	89 fd                	mov    %edi,%ebp
  80422e:	85 ff                	test   %edi,%edi
  804230:	75 0b                	jne    80423d <__umoddi3+0xe9>
  804232:	b8 01 00 00 00       	mov    $0x1,%eax
  804237:	31 d2                	xor    %edx,%edx
  804239:	f7 f7                	div    %edi
  80423b:	89 c5                	mov    %eax,%ebp
  80423d:	89 f0                	mov    %esi,%eax
  80423f:	31 d2                	xor    %edx,%edx
  804241:	f7 f5                	div    %ebp
  804243:	89 c8                	mov    %ecx,%eax
  804245:	f7 f5                	div    %ebp
  804247:	89 d0                	mov    %edx,%eax
  804249:	e9 44 ff ff ff       	jmp    804192 <__umoddi3+0x3e>
  80424e:	66 90                	xchg   %ax,%ax
  804250:	89 c8                	mov    %ecx,%eax
  804252:	89 f2                	mov    %esi,%edx
  804254:	83 c4 1c             	add    $0x1c,%esp
  804257:	5b                   	pop    %ebx
  804258:	5e                   	pop    %esi
  804259:	5f                   	pop    %edi
  80425a:	5d                   	pop    %ebp
  80425b:	c3                   	ret    
  80425c:	3b 04 24             	cmp    (%esp),%eax
  80425f:	72 06                	jb     804267 <__umoddi3+0x113>
  804261:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804265:	77 0f                	ja     804276 <__umoddi3+0x122>
  804267:	89 f2                	mov    %esi,%edx
  804269:	29 f9                	sub    %edi,%ecx
  80426b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80426f:	89 14 24             	mov    %edx,(%esp)
  804272:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804276:	8b 44 24 04          	mov    0x4(%esp),%eax
  80427a:	8b 14 24             	mov    (%esp),%edx
  80427d:	83 c4 1c             	add    $0x1c,%esp
  804280:	5b                   	pop    %ebx
  804281:	5e                   	pop    %esi
  804282:	5f                   	pop    %edi
  804283:	5d                   	pop    %ebp
  804284:	c3                   	ret    
  804285:	8d 76 00             	lea    0x0(%esi),%esi
  804288:	2b 04 24             	sub    (%esp),%eax
  80428b:	19 fa                	sbb    %edi,%edx
  80428d:	89 d1                	mov    %edx,%ecx
  80428f:	89 c6                	mov    %eax,%esi
  804291:	e9 71 ff ff ff       	jmp    804207 <__umoddi3+0xb3>
  804296:	66 90                	xchg   %ax,%ax
  804298:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80429c:	72 ea                	jb     804288 <__umoddi3+0x134>
  80429e:	89 d9                	mov    %ebx,%ecx
  8042a0:	e9 62 ff ff ff       	jmp    804207 <__umoddi3+0xb3>

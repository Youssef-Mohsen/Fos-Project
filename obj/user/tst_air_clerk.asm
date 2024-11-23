
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
  800044:	e8 02 20 00 00       	call   80204b <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 35 41 80 00       	mov    $0x804135,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 3f 41 80 00       	mov    $0x80413f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 4b 41 80 00       	mov    $0x80414b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 5a 41 80 00       	mov    $0x80415a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 69 41 80 00       	mov    $0x804169,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 7e 41 80 00       	mov    $0x80417e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 93 41 80 00       	mov    $0x804193,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb a4 41 80 00       	mov    $0x8041a4,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb b5 41 80 00       	mov    $0x8041b5,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb c6 41 80 00       	mov    $0x8041c6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb cf 41 80 00       	mov    $0x8041cf,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb d9 41 80 00       	mov    $0x8041d9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb e4 41 80 00       	mov    $0x8041e4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb f0 41 80 00       	mov    $0x8041f0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb fa 41 80 00       	mov    $0x8041fa,%ebx
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
  8001c1:	bb 04 42 80 00       	mov    $0x804204,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 12 42 80 00       	mov    $0x804212,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 21 42 80 00       	mov    $0x804221,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 28 42 80 00       	mov    $0x804228,%ebx
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
  8002fe:	e8 22 3b 00 00       	call   803e25 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 06 3b 00 00       	call   803e25 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 ea 3a 00 00       	call   803e25 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 ce 3a 00 00       	call   803e25 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 b2 3a 00 00       	call   803e25 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 bb 3a 00 00       	call   803e3f <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 aa 3a 00 00       	call   803e3f <wait_semaphore>
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
  8003c4:	e8 90 3a 00 00       	call   803e59 <signal_semaphore>
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
  800407:	e8 33 3a 00 00       	call   803e3f <wait_semaphore>
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
  800467:	e8 ed 39 00 00       	call   803e59 <signal_semaphore>
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
  80047d:	e8 bd 39 00 00       	call   803e3f <wait_semaphore>
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
  8004dd:	e8 77 39 00 00       	call   803e59 <signal_semaphore>
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
  8004f3:	e8 47 39 00 00       	call   803e3f <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 36 39 00 00       	call   803e3f <wait_semaphore>
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
  8005bb:	e8 99 38 00 00       	call   803e59 <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 88 38 00 00       	call   803e59 <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 00 41 80 00       	push   $0x804100
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 20 41 80 00       	push   $0x804120
  8005e8:	e8 e3 01 00 00       	call   8007d0 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 2f 42 80 00       	mov    $0x80422f,%ebx
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
  800662:	e8 be 37 00 00       	call   803e25 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 e1 37 00 00       	call   803e59 <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 d0 37 00 00       	call   803e59 <signal_semaphore>
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
  800697:	e8 96 19 00 00       	call   802032 <sys_getenvindex>
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
  800705:	e8 ac 16 00 00       	call   801db6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 68 42 80 00       	push   $0x804268
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
  800735:	68 90 42 80 00       	push   $0x804290
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
  800766:	68 b8 42 80 00       	push   $0x8042b8
  80076b:	e8 1d 03 00 00       	call   800a8d <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800773:	a1 20 50 80 00       	mov    0x805020,%eax
  800778:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	50                   	push   %eax
  800782:	68 10 43 80 00       	push   $0x804310
  800787:	e8 01 03 00 00       	call   800a8d <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	68 68 42 80 00       	push   $0x804268
  800797:	e8 f1 02 00 00       	call   800a8d <cprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80079f:	e8 2c 16 00 00       	call   801dd0 <sys_unlock_cons>
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
  8007b7:	e8 42 18 00 00       	call   801ffe <sys_destroy_env>
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
  8007c8:	e8 97 18 00 00       	call   802064 <sys_exit_env>
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
  8007f1:	68 24 43 80 00       	push   $0x804324
  8007f6:	e8 92 02 00 00       	call   800a8d <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007fe:	a1 00 50 80 00       	mov    0x805000,%eax
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	ff 75 08             	pushl  0x8(%ebp)
  800809:	50                   	push   %eax
  80080a:	68 29 43 80 00       	push   $0x804329
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
  80082e:	68 45 43 80 00       	push   $0x804345
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
  80085d:	68 48 43 80 00       	push   $0x804348
  800862:	6a 26                	push   $0x26
  800864:	68 94 43 80 00       	push   $0x804394
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
  800932:	68 a0 43 80 00       	push   $0x8043a0
  800937:	6a 3a                	push   $0x3a
  800939:	68 94 43 80 00       	push   $0x804394
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
  8009a5:	68 f4 43 80 00       	push   $0x8043f4
  8009aa:	6a 44                	push   $0x44
  8009ac:	68 94 43 80 00       	push   $0x804394
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
  8009ff:	e8 70 13 00 00       	call   801d74 <sys_cputs>
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
  800a76:	e8 f9 12 00 00       	call   801d74 <sys_cputs>
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
  800ac0:	e8 f1 12 00 00       	call   801db6 <sys_lock_cons>
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
  800ae0:	e8 eb 12 00 00       	call   801dd0 <sys_unlock_cons>
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
  800b2a:	e8 51 33 00 00       	call   803e80 <__udivdi3>
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
  800b7a:	e8 11 34 00 00       	call   803f90 <__umoddi3>
  800b7f:	83 c4 10             	add    $0x10,%esp
  800b82:	05 54 46 80 00       	add    $0x804654,%eax
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
  800cd5:	8b 04 85 78 46 80 00 	mov    0x804678(,%eax,4),%eax
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
  800db6:	8b 34 9d c0 44 80 00 	mov    0x8044c0(,%ebx,4),%esi
  800dbd:	85 f6                	test   %esi,%esi
  800dbf:	75 19                	jne    800dda <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dc1:	53                   	push   %ebx
  800dc2:	68 65 46 80 00       	push   $0x804665
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
  800ddb:	68 6e 46 80 00       	push   $0x80466e
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
  800e08:	be 71 46 80 00       	mov    $0x804671,%esi
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
  801813:	68 e8 47 80 00       	push   $0x8047e8
  801818:	68 3f 01 00 00       	push   $0x13f
  80181d:	68 0a 48 80 00       	push   $0x80480a
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
  801833:	e8 e7 0a 00 00       	call   80231f <sys_sbrk>
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
  8018ae:	e8 f0 08 00 00       	call   8021a3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	74 16                	je     8018cd <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	e8 30 0e 00 00       	call   8026f2 <alloc_block_FF>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018c8:	e9 8a 01 00 00       	jmp    801a57 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8018cd:	e8 02 09 00 00       	call   8021d4 <sys_isUHeapPlacementStrategyBESTFIT>
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	0f 84 7d 01 00 00    	je     801a57 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 c9 12 00 00       	call   802bae <alloc_block_BF>
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
  801a46:	e8 0b 09 00 00       	call   802356 <sys_allocate_user_mem>
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
  801a8e:	e8 df 08 00 00       	call   802372 <get_block_size>
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 12 1b 00 00       	call   8035b6 <free_block>
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
  801b36:	e8 ff 07 00 00       	call   80233a <sys_free_user_mem>
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
  801b44:	68 18 48 80 00       	push   $0x804818
  801b49:	68 85 00 00 00       	push   $0x85
  801b4e:	68 42 48 80 00       	push   $0x804842
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
  801bb9:	e8 83 03 00 00       	call   801f41 <sys_createSharedObject>
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
  801bdd:	68 4e 48 80 00       	push   $0x80484e
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
  801c21:	e8 45 03 00 00       	call   801f6b <sys_getSizeOfSharedObject>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801c2c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c30:	75 07                	jne    801c39 <sget+0x27>
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 5c                	jmp    801c95 <sget+0x83>
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
  801c6c:	eb 27                	jmp    801c95 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	ff 75 e8             	pushl  -0x18(%ebp)
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	e8 09 03 00 00       	call   801f88 <sys_getSharedObject>
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801c85:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c89:	75 07                	jne    801c92 <sget+0x80>
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c90:	eb 03                	jmp    801c95 <sget+0x83>
	return ptr;
  801c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca0:	a1 20 50 80 00       	mov    0x805020,%eax
  801ca5:	8b 40 78             	mov    0x78(%eax),%eax
  801ca8:	29 c2                	sub    %eax,%edx
  801caa:	89 d0                	mov    %edx,%eax
  801cac:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cb1:	c1 e8 0c             	shr    $0xc,%eax
  801cb4:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801cbe:	83 ec 08             	sub    $0x8,%esp
  801cc1:	ff 75 08             	pushl  0x8(%ebp)
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	e8 db 02 00 00       	call   801fa7 <sys_freeSharedObject>
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801cd2:	90                   	nop
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	68 60 48 80 00       	push   $0x804860
  801ce3:	68 dd 00 00 00       	push   $0xdd
  801ce8:	68 42 48 80 00       	push   $0x804842
  801ced:	e8 de ea ff ff       	call   8007d0 <_panic>

00801cf2 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	68 86 48 80 00       	push   $0x804886
  801d00:	68 e9 00 00 00       	push   $0xe9
  801d05:	68 42 48 80 00       	push   $0x804842
  801d0a:	e8 c1 ea ff ff       	call   8007d0 <_panic>

00801d0f <shrink>:

}
void shrink(uint32 newSize)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	68 86 48 80 00       	push   $0x804886
  801d1d:	68 ee 00 00 00       	push   $0xee
  801d22:	68 42 48 80 00       	push   $0x804842
  801d27:	e8 a4 ea ff ff       	call   8007d0 <_panic>

00801d2c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	68 86 48 80 00       	push   $0x804886
  801d3a:	68 f3 00 00 00       	push   $0xf3
  801d3f:	68 42 48 80 00       	push   $0x804842
  801d44:	e8 87 ea ff ff       	call   8007d0 <_panic>

00801d49 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	57                   	push   %edi
  801d4d:	56                   	push   %esi
  801d4e:	53                   	push   %ebx
  801d4f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d61:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d64:	cd 30                	int    $0x30
  801d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d80:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	50                   	push   %eax
  801d90:	6a 00                	push   $0x0
  801d92:	e8 b2 ff ff ff       	call   801d49 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 02                	push   $0x2
  801dac:	e8 98 ff ff ff       	call   801d49 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 03                	push   $0x3
  801dc5:	e8 7f ff ff ff       	call   801d49 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	90                   	nop
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 04                	push   $0x4
  801ddf:	e8 65 ff ff ff       	call   801d49 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	90                   	nop
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	52                   	push   %edx
  801dfa:	50                   	push   %eax
  801dfb:	6a 08                	push   $0x8
  801dfd:	e8 47 ff ff ff       	call   801d49 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e0c:	8b 75 18             	mov    0x18(%ebp),%esi
  801e0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	51                   	push   %ecx
  801e1e:	52                   	push   %edx
  801e1f:	50                   	push   %eax
  801e20:	6a 09                	push   $0x9
  801e22:	e8 22 ff ff ff       	call   801d49 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2d:	5b                   	pop    %ebx
  801e2e:	5e                   	pop    %esi
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    

00801e31 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 0a                	push   $0xa
  801e44:	e8 00 ff ff ff       	call   801d49 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 0b                	push   $0xb
  801e5f:	e8 e5 fe ff ff       	call   801d49 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 0c                	push   $0xc
  801e78:	e8 cc fe ff ff       	call   801d49 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 0d                	push   $0xd
  801e91:	e8 b3 fe ff ff       	call   801d49 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 0e                	push   $0xe
  801eaa:	e8 9a fe ff ff       	call   801d49 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 0f                	push   $0xf
  801ec3:	e8 81 fe ff ff       	call   801d49 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	6a 10                	push   $0x10
  801edd:	e8 67 fe ff ff       	call   801d49 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 11                	push   $0x11
  801ef6:	e8 4e fe ff ff       	call   801d49 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	50                   	push   %eax
  801f1a:	6a 01                	push   $0x1
  801f1c:	e8 28 fe ff ff       	call   801d49 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	90                   	nop
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 14                	push   $0x14
  801f36:	e8 0e fe ff ff       	call   801d49 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	90                   	nop
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	51                   	push   %ecx
  801f5a:	52                   	push   %edx
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	50                   	push   %eax
  801f5f:	6a 15                	push   $0x15
  801f61:	e8 e3 fd ff ff       	call   801d49 <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	6a 16                	push   $0x16
  801f7e:	e8 c6 fd ff ff       	call   801d49 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	51                   	push   %ecx
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 17                	push   $0x17
  801f9d:	e8 a7 fd ff ff       	call   801d49 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	52                   	push   %edx
  801fb7:	50                   	push   %eax
  801fb8:	6a 18                	push   $0x18
  801fba:	e8 8a fd ff ff       	call   801d49 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 14             	pushl  0x14(%ebp)
  801fcf:	ff 75 10             	pushl  0x10(%ebp)
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	50                   	push   %eax
  801fd6:	6a 19                	push   $0x19
  801fd8:	e8 6c fd ff ff       	call   801d49 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	50                   	push   %eax
  801ff1:	6a 1a                	push   $0x1a
  801ff3:	e8 51 fd ff ff       	call   801d49 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	50                   	push   %eax
  80200d:	6a 1b                	push   $0x1b
  80200f:	e8 35 fd ff ff       	call   801d49 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 05                	push   $0x5
  802028:	e8 1c fd ff ff       	call   801d49 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 06                	push   $0x6
  802041:	e8 03 fd ff ff       	call   801d49 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 07                	push   $0x7
  80205a:	e8 ea fc ff ff       	call   801d49 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_exit_env>:


void sys_exit_env(void)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 1c                	push   $0x1c
  802073:	e8 d1 fc ff ff       	call   801d49 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	90                   	nop
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802084:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802087:	8d 50 04             	lea    0x4(%eax),%edx
  80208a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	52                   	push   %edx
  802094:	50                   	push   %eax
  802095:	6a 1d                	push   $0x1d
  802097:	e8 ad fc ff ff       	call   801d49 <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return result;
  80209f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a8:	89 01                	mov    %eax,(%ecx)
  8020aa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	c9                   	leave  
  8020b1:	c2 04 00             	ret    $0x4

008020b4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	ff 75 10             	pushl  0x10(%ebp)
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	6a 13                	push   $0x13
  8020c6:	e8 7e fc ff ff       	call   801d49 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ce:	90                   	nop
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 1e                	push   $0x1e
  8020e0:	e8 64 fc ff ff       	call   801d49 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020f6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	50                   	push   %eax
  802103:	6a 1f                	push   $0x1f
  802105:	e8 3f fc ff ff       	call   801d49 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
	return ;
  80210d:	90                   	nop
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <rsttst>:
void rsttst()
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 21                	push   $0x21
  80211f:	e8 25 fc ff ff       	call   801d49 <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return ;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	8b 45 14             	mov    0x14(%ebp),%eax
  802133:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802136:	8b 55 18             	mov    0x18(%ebp),%edx
  802139:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80213d:	52                   	push   %edx
  80213e:	50                   	push   %eax
  80213f:	ff 75 10             	pushl  0x10(%ebp)
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	6a 20                	push   $0x20
  80214a:	e8 fa fb ff ff       	call   801d49 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
	return ;
  802152:	90                   	nop
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <chktst>:
void chktst(uint32 n)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	6a 22                	push   $0x22
  802165:	e8 df fb ff ff       	call   801d49 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
	return ;
  80216d:	90                   	nop
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <inctst>:

void inctst()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 23                	push   $0x23
  80217f:	e8 c5 fb ff ff       	call   801d49 <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
	return ;
  802187:	90                   	nop
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <gettst>:
uint32 gettst()
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 24                	push   $0x24
  802199:	e8 ab fb ff ff       	call   801d49 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 25                	push   $0x25
  8021b5:	e8 8f fb ff ff       	call   801d49 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
  8021bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021c0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021c4:	75 07                	jne    8021cd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cb:	eb 05                	jmp    8021d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 25                	push   $0x25
  8021e6:	e8 5e fb ff ff       	call   801d49 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
  8021ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021f1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021f5:	75 07                	jne    8021fe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fc:	eb 05                	jmp    802203 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 25                	push   $0x25
  802217:	e8 2d fb ff ff       	call   801d49 <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
  80221f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802222:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802226:	75 07                	jne    80222f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802228:	b8 01 00 00 00       	mov    $0x1,%eax
  80222d:	eb 05                	jmp    802234 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 25                	push   $0x25
  802248:	e8 fc fa ff ff       	call   801d49 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
  802250:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802253:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802257:	75 07                	jne    802260 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802259:	b8 01 00 00 00       	mov    $0x1,%eax
  80225e:	eb 05                	jmp    802265 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	ff 75 08             	pushl  0x8(%ebp)
  802275:	6a 26                	push   $0x26
  802277:	e8 cd fa ff ff       	call   801d49 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
	return ;
  80227f:	90                   	nop
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802286:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802289:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80228c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	6a 00                	push   $0x0
  802294:	53                   	push   %ebx
  802295:	51                   	push   %ecx
  802296:	52                   	push   %edx
  802297:	50                   	push   %eax
  802298:	6a 27                	push   $0x27
  80229a:	e8 aa fa ff ff       	call   801d49 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
}
  8022a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	52                   	push   %edx
  8022b7:	50                   	push   %eax
  8022b8:	6a 28                	push   $0x28
  8022ba:	e8 8a fa ff ff       	call   801d49 <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8022c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	51                   	push   %ecx
  8022d3:	ff 75 10             	pushl  0x10(%ebp)
  8022d6:	52                   	push   %edx
  8022d7:	50                   	push   %eax
  8022d8:	6a 29                	push   $0x29
  8022da:	e8 6a fa ff ff       	call   801d49 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	ff 75 10             	pushl  0x10(%ebp)
  8022ee:	ff 75 0c             	pushl  0xc(%ebp)
  8022f1:	ff 75 08             	pushl  0x8(%ebp)
  8022f4:	6a 12                	push   $0x12
  8022f6:	e8 4e fa ff ff       	call   801d49 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fe:	90                   	nop
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802304:	8b 55 0c             	mov    0xc(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	52                   	push   %edx
  802311:	50                   	push   %eax
  802312:	6a 2a                	push   $0x2a
  802314:	e8 30 fa ff ff       	call   801d49 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
	return;
  80231c:	90                   	nop
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	50                   	push   %eax
  80232e:	6a 2b                	push   $0x2b
  802330:	e8 14 fa ff ff       	call   801d49 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	ff 75 0c             	pushl  0xc(%ebp)
  802346:	ff 75 08             	pushl  0x8(%ebp)
  802349:	6a 2c                	push   $0x2c
  80234b:	e8 f9 f9 ff ff       	call   801d49 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
	return;
  802353:	90                   	nop
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	ff 75 0c             	pushl  0xc(%ebp)
  802362:	ff 75 08             	pushl  0x8(%ebp)
  802365:	6a 2d                	push   $0x2d
  802367:	e8 dd f9 ff ff       	call   801d49 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	83 e8 04             	sub    $0x4,%eax
  80237e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	83 e8 04             	sub    $0x4,%eax
  802397:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80239a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	83 e0 01             	and    $0x1,%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 94 c0             	sete   %al
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8023af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8023b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b9:	83 f8 02             	cmp    $0x2,%eax
  8023bc:	74 2b                	je     8023e9 <alloc_block+0x40>
  8023be:	83 f8 02             	cmp    $0x2,%eax
  8023c1:	7f 07                	jg     8023ca <alloc_block+0x21>
  8023c3:	83 f8 01             	cmp    $0x1,%eax
  8023c6:	74 0e                	je     8023d6 <alloc_block+0x2d>
  8023c8:	eb 58                	jmp    802422 <alloc_block+0x79>
  8023ca:	83 f8 03             	cmp    $0x3,%eax
  8023cd:	74 2d                	je     8023fc <alloc_block+0x53>
  8023cf:	83 f8 04             	cmp    $0x4,%eax
  8023d2:	74 3b                	je     80240f <alloc_block+0x66>
  8023d4:	eb 4c                	jmp    802422 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8023d6:	83 ec 0c             	sub    $0xc,%esp
  8023d9:	ff 75 08             	pushl  0x8(%ebp)
  8023dc:	e8 11 03 00 00       	call   8026f2 <alloc_block_FF>
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023e7:	eb 4a                	jmp    802433 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	ff 75 08             	pushl  0x8(%ebp)
  8023ef:	e8 fa 19 00 00       	call   803dee <alloc_block_NF>
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8023fa:	eb 37                	jmp    802433 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8023fc:	83 ec 0c             	sub    $0xc,%esp
  8023ff:	ff 75 08             	pushl  0x8(%ebp)
  802402:	e8 a7 07 00 00       	call   802bae <alloc_block_BF>
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80240d:	eb 24                	jmp    802433 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80240f:	83 ec 0c             	sub    $0xc,%esp
  802412:	ff 75 08             	pushl  0x8(%ebp)
  802415:	e8 b7 19 00 00       	call   803dd1 <alloc_block_WF>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802420:	eb 11                	jmp    802433 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	68 98 48 80 00       	push   $0x804898
  80242a:	e8 5e e6 ff ff       	call   800a8d <cprintf>
  80242f:	83 c4 10             	add    $0x10,%esp
		break;
  802432:	90                   	nop
	}
	return va;
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	53                   	push   %ebx
  80243c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80243f:	83 ec 0c             	sub    $0xc,%esp
  802442:	68 b8 48 80 00       	push   $0x8048b8
  802447:	e8 41 e6 ff ff       	call   800a8d <cprintf>
  80244c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	68 e3 48 80 00       	push   $0x8048e3
  802457:	e8 31 e6 ff ff       	call   800a8d <cprintf>
  80245c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802465:	eb 37                	jmp    80249e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	ff 75 f4             	pushl  -0xc(%ebp)
  80246d:	e8 19 ff ff ff       	call   80238b <is_free_block>
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	0f be d8             	movsbl %al,%ebx
  802478:	83 ec 0c             	sub    $0xc,%esp
  80247b:	ff 75 f4             	pushl  -0xc(%ebp)
  80247e:	e8 ef fe ff ff       	call   802372 <get_block_size>
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	83 ec 04             	sub    $0x4,%esp
  802489:	53                   	push   %ebx
  80248a:	50                   	push   %eax
  80248b:	68 fb 48 80 00       	push   $0x8048fb
  802490:	e8 f8 e5 ff ff       	call   800a8d <cprintf>
  802495:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a2:	74 07                	je     8024ab <print_blocks_list+0x73>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	eb 05                	jmp    8024b0 <print_blocks_list+0x78>
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b0:	89 45 10             	mov    %eax,0x10(%ebp)
  8024b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	75 ad                	jne    802467 <print_blocks_list+0x2f>
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	75 a7                	jne    802467 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	68 b8 48 80 00       	push   $0x8048b8
  8024c8:	e8 c0 e5 ff ff       	call   800a8d <cprintf>
  8024cd:	83 c4 10             	add    $0x10,%esp

}
  8024d0:	90                   	nop
  8024d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8024dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024df:	83 e0 01             	and    $0x1,%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	74 03                	je     8024e9 <initialize_dynamic_allocator+0x13>
  8024e6:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8024e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024ed:	0f 84 c7 01 00 00    	je     8026ba <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8024f3:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8024fa:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8024fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802500:	8b 45 0c             	mov    0xc(%ebp),%eax
  802503:	01 d0                	add    %edx,%eax
  802505:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80250a:	0f 87 ad 01 00 00    	ja     8026bd <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	0f 89 a5 01 00 00    	jns    8026c0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80251b:	8b 55 08             	mov    0x8(%ebp),%edx
  80251e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802521:	01 d0                	add    %edx,%eax
  802523:	83 e8 04             	sub    $0x4,%eax
  802526:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80252b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802532:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253a:	e9 87 00 00 00       	jmp    8025c6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80253f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802543:	75 14                	jne    802559 <initialize_dynamic_allocator+0x83>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 13 49 80 00       	push   $0x804913
  80254d:	6a 79                	push   $0x79
  80254f:	68 31 49 80 00       	push   $0x804931
  802554:	e8 77 e2 ff ff       	call   8007d0 <_panic>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 10                	je     802572 <initialize_dynamic_allocator+0x9c>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 52 04             	mov    0x4(%edx),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	eb 0b                	jmp    80257d <initialize_dynamic_allocator+0xa7>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	a3 30 50 80 00       	mov    %eax,0x805030
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 0f                	je     802596 <initialize_dynamic_allocator+0xc0>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802590:	8b 12                	mov    (%edx),%edx
  802592:	89 10                	mov    %edx,(%eax)
  802594:	eb 0a                	jmp    8025a0 <initialize_dynamic_allocator+0xca>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b8:	48                   	dec    %eax
  8025b9:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8025be:	a1 34 50 80 00       	mov    0x805034,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ca:	74 07                	je     8025d3 <initialize_dynamic_allocator+0xfd>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	eb 05                	jmp    8025d8 <initialize_dynamic_allocator+0x102>
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8025dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	0f 85 55 ff ff ff    	jne    80253f <initialize_dynamic_allocator+0x69>
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	0f 85 4b ff ff ff    	jne    80253f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802603:	a1 44 50 80 00       	mov    0x805044,%eax
  802608:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80260d:	a1 40 50 80 00       	mov    0x805040,%eax
  802612:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	83 c0 08             	add    $0x8,%eax
  80261e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	83 c0 04             	add    $0x4,%eax
  802627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262a:	83 ea 08             	sub    $0x8,%edx
  80262d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80262f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	01 d0                	add    %edx,%eax
  802637:	83 e8 08             	sub    $0x8,%eax
  80263a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263d:	83 ea 08             	sub    $0x8,%edx
  802640:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80264b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802655:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802659:	75 17                	jne    802672 <initialize_dynamic_allocator+0x19c>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 4c 49 80 00       	push   $0x80494c
  802663:	68 90 00 00 00       	push   $0x90
  802668:	68 31 49 80 00       	push   $0x804931
  80266d:	e8 5e e1 ff ff       	call   8007d0 <_panic>
  802672:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	89 10                	mov    %edx,(%eax)
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0d                	je     802693 <initialize_dynamic_allocator+0x1bd>
  802686:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80268b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	eb 08                	jmp    80269b <initialize_dynamic_allocator+0x1c5>
  802693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802696:	a3 30 50 80 00       	mov    %eax,0x805030
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b2:	40                   	inc    %eax
  8026b3:	a3 38 50 80 00       	mov    %eax,0x805038
  8026b8:	eb 07                	jmp    8026c1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8026ba:	90                   	nop
  8026bb:	eb 04                	jmp    8026c1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8026bd:	90                   	nop
  8026be:	eb 01                	jmp    8026c1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8026c0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8026c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8026cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cf:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d5:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	83 e8 04             	sub    $0x4,%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	83 e0 fe             	and    $0xfffffffe,%eax
  8026e2:	8d 50 f8             	lea    -0x8(%eax),%edx
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e8:	01 c2                	add    %eax,%edx
  8026ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ed:	89 02                	mov    %eax,(%edx)
}
  8026ef:	90                   	nop
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	83 e0 01             	and    $0x1,%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 03                	je     802705 <alloc_block_FF+0x13>
  802702:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802705:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802709:	77 07                	ja     802712 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80270b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802712:	a1 24 50 80 00       	mov    0x805024,%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	75 73                	jne    80278e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	83 c0 10             	add    $0x10,%eax
  802721:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802724:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80272b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	01 d0                	add    %edx,%eax
  802733:	48                   	dec    %eax
  802734:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802737:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273a:	ba 00 00 00 00       	mov    $0x0,%edx
  80273f:	f7 75 ec             	divl   -0x14(%ebp)
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	29 d0                	sub    %edx,%eax
  802747:	c1 e8 0c             	shr    $0xc,%eax
  80274a:	83 ec 0c             	sub    $0xc,%esp
  80274d:	50                   	push   %eax
  80274e:	e8 d4 f0 ff ff       	call   801827 <sbrk>
  802753:	83 c4 10             	add    $0x10,%esp
  802756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802759:	83 ec 0c             	sub    $0xc,%esp
  80275c:	6a 00                	push   $0x0
  80275e:	e8 c4 f0 ff ff       	call   801827 <sbrk>
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80276f:	83 ec 08             	sub    $0x8,%esp
  802772:	50                   	push   %eax
  802773:	ff 75 e4             	pushl  -0x1c(%ebp)
  802776:	e8 5b fd ff ff       	call   8024d6 <initialize_dynamic_allocator>
  80277b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80277e:	83 ec 0c             	sub    $0xc,%esp
  802781:	68 6f 49 80 00       	push   $0x80496f
  802786:	e8 02 e3 ff ff       	call   800a8d <cprintf>
  80278b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80278e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802792:	75 0a                	jne    80279e <alloc_block_FF+0xac>
	        return NULL;
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	e9 0e 04 00 00       	jmp    802bac <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80279e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	e9 f3 02 00 00       	jmp    802aa5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8027b8:	83 ec 0c             	sub    $0xc,%esp
  8027bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8027be:	e8 af fb ff ff       	call   802372 <get_block_size>
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	83 c0 08             	add    $0x8,%eax
  8027cf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027d2:	0f 87 c5 02 00 00    	ja     802a9d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	83 c0 18             	add    $0x18,%eax
  8027de:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8027e1:	0f 87 19 02 00 00    	ja     802a00 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8027e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ed:	83 e8 08             	sub    $0x8,%eax
  8027f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	8d 50 08             	lea    0x8(%eax),%edx
  8027f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027fc:	01 d0                	add    %edx,%eax
  8027fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	83 c0 08             	add    $0x8,%eax
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	6a 01                	push   $0x1
  80280c:	50                   	push   %eax
  80280d:	ff 75 bc             	pushl  -0x44(%ebp)
  802810:	e8 ae fe ff ff       	call   8026c3 <set_block_data>
  802815:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	75 68                	jne    80288a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802822:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802826:	75 17                	jne    80283f <alloc_block_FF+0x14d>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 4c 49 80 00       	push   $0x80494c
  802830:	68 d7 00 00 00       	push   $0xd7
  802835:	68 31 49 80 00       	push   $0x804931
  80283a:	e8 91 df ff ff       	call   8007d0 <_panic>
  80283f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802845:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0d                	je     802860 <alloc_block_FF+0x16e>
  802853:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802858:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80285b:	89 50 04             	mov    %edx,0x4(%eax)
  80285e:	eb 08                	jmp    802868 <alloc_block_FF+0x176>
  802860:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802863:	a3 30 50 80 00       	mov    %eax,0x805030
  802868:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80286b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802870:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287a:	a1 38 50 80 00       	mov    0x805038,%eax
  80287f:	40                   	inc    %eax
  802880:	a3 38 50 80 00       	mov    %eax,0x805038
  802885:	e9 dc 00 00 00       	jmp    802966 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	75 65                	jne    8028f8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802893:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802897:	75 17                	jne    8028b0 <alloc_block_FF+0x1be>
  802899:	83 ec 04             	sub    $0x4,%esp
  80289c:	68 80 49 80 00       	push   $0x804980
  8028a1:	68 db 00 00 00       	push   $0xdb
  8028a6:	68 31 49 80 00       	push   $0x804931
  8028ab:	e8 20 df ff ff       	call   8007d0 <_panic>
  8028b0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	74 0c                	je     8028d2 <alloc_block_FF+0x1e0>
  8028c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8028cb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 08                	jmp    8028da <alloc_block_FF+0x1e8>
  8028d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8028e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8028f0:	40                   	inc    %eax
  8028f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8028f6:	eb 6e                	jmp    802966 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8028f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fc:	74 06                	je     802904 <alloc_block_FF+0x212>
  8028fe:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802902:	75 17                	jne    80291b <alloc_block_FF+0x229>
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 a4 49 80 00       	push   $0x8049a4
  80290c:	68 df 00 00 00       	push   $0xdf
  802911:	68 31 49 80 00       	push   $0x804931
  802916:	e8 b5 de ff ff       	call   8007d0 <_panic>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 10                	mov    (%eax),%edx
  802920:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802923:	89 10                	mov    %edx,(%eax)
  802925:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 0b                	je     802939 <alloc_block_FF+0x247>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802947:	89 50 04             	mov    %edx,0x4(%eax)
  80294a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	75 08                	jne    80295b <alloc_block_FF+0x269>
  802953:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802956:	a3 30 50 80 00       	mov    %eax,0x805030
  80295b:	a1 38 50 80 00       	mov    0x805038,%eax
  802960:	40                   	inc    %eax
  802961:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	75 17                	jne    802983 <alloc_block_FF+0x291>
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	68 13 49 80 00       	push   $0x804913
  802974:	68 e1 00 00 00       	push   $0xe1
  802979:	68 31 49 80 00       	push   $0x804931
  80297e:	e8 4d de ff ff       	call   8007d0 <_panic>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 10                	je     80299c <alloc_block_FF+0x2aa>
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802994:	8b 52 04             	mov    0x4(%edx),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	eb 0b                	jmp    8029a7 <alloc_block_FF+0x2b5>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 40 04             	mov    0x4(%eax),%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	74 0f                	je     8029c0 <alloc_block_FF+0x2ce>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	8b 12                	mov    (%edx),%edx
  8029bc:	89 10                	mov    %edx,(%eax)
  8029be:	eb 0a                	jmp    8029ca <alloc_block_FF+0x2d8>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e2:	48                   	dec    %eax
  8029e3:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	6a 00                	push   $0x0
  8029ed:	ff 75 b4             	pushl  -0x4c(%ebp)
  8029f0:	ff 75 b0             	pushl  -0x50(%ebp)
  8029f3:	e8 cb fc ff ff       	call   8026c3 <set_block_data>
  8029f8:	83 c4 10             	add    $0x10,%esp
  8029fb:	e9 95 00 00 00       	jmp    802a95 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	6a 01                	push   $0x1
  802a05:	ff 75 b8             	pushl  -0x48(%ebp)
  802a08:	ff 75 bc             	pushl  -0x44(%ebp)
  802a0b:	e8 b3 fc ff ff       	call   8026c3 <set_block_data>
  802a10:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a17:	75 17                	jne    802a30 <alloc_block_FF+0x33e>
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 13 49 80 00       	push   $0x804913
  802a21:	68 e8 00 00 00       	push   $0xe8
  802a26:	68 31 49 80 00       	push   $0x804931
  802a2b:	e8 a0 dd ff ff       	call   8007d0 <_panic>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 10                	je     802a49 <alloc_block_FF+0x357>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a41:	8b 52 04             	mov    0x4(%edx),%edx
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	eb 0b                	jmp    802a54 <alloc_block_FF+0x362>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 40 04             	mov    0x4(%eax),%eax
  802a4f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0f                	je     802a6d <alloc_block_FF+0x37b>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 40 04             	mov    0x4(%eax),%eax
  802a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a67:	8b 12                	mov    (%edx),%edx
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	eb 0a                	jmp    802a77 <alloc_block_FF+0x385>
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
	            }
	            return va;
  802a95:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a98:	e9 0f 01 00 00       	jmp    802bac <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a9d:	a1 34 50 80 00       	mov    0x805034,%eax
  802aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa9:	74 07                	je     802ab2 <alloc_block_FF+0x3c0>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	eb 05                	jmp    802ab7 <alloc_block_FF+0x3c5>
  802ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab7:	a3 34 50 80 00       	mov    %eax,0x805034
  802abc:	a1 34 50 80 00       	mov    0x805034,%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	0f 85 e9 fc ff ff    	jne    8027b2 <alloc_block_FF+0xc0>
  802ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acd:	0f 85 df fc ff ff    	jne    8027b2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	83 c0 08             	add    $0x8,%eax
  802ad9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802adc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ae3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ae6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ae9:	01 d0                	add    %edx,%eax
  802aeb:	48                   	dec    %eax
  802aec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802aef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802af2:	ba 00 00 00 00       	mov    $0x0,%edx
  802af7:	f7 75 d8             	divl   -0x28(%ebp)
  802afa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802afd:	29 d0                	sub    %edx,%eax
  802aff:	c1 e8 0c             	shr    $0xc,%eax
  802b02:	83 ec 0c             	sub    $0xc,%esp
  802b05:	50                   	push   %eax
  802b06:	e8 1c ed ff ff       	call   801827 <sbrk>
  802b0b:	83 c4 10             	add    $0x10,%esp
  802b0e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802b11:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802b15:	75 0a                	jne    802b21 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1c:	e9 8b 00 00 00       	jmp    802bac <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b21:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802b28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2e:	01 d0                	add    %edx,%eax
  802b30:	48                   	dec    %eax
  802b31:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802b34:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b37:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3c:	f7 75 cc             	divl   -0x34(%ebp)
  802b3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b42:	29 d0                	sub    %edx,%eax
  802b44:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b4a:	01 d0                	add    %edx,%eax
  802b4c:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802b51:	a1 40 50 80 00       	mov    0x805040,%eax
  802b56:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b5c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b63:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b66:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b69:	01 d0                	add    %edx,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b6f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b72:	ba 00 00 00 00       	mov    $0x0,%edx
  802b77:	f7 75 c4             	divl   -0x3c(%ebp)
  802b7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b7d:	29 d0                	sub    %edx,%eax
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	6a 01                	push   $0x1
  802b84:	50                   	push   %eax
  802b85:	ff 75 d0             	pushl  -0x30(%ebp)
  802b88:	e8 36 fb ff ff       	call   8026c3 <set_block_data>
  802b8d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802b90:	83 ec 0c             	sub    $0xc,%esp
  802b93:	ff 75 d0             	pushl  -0x30(%ebp)
  802b96:	e8 1b 0a 00 00       	call   8035b6 <free_block>
  802b9b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802b9e:	83 ec 0c             	sub    $0xc,%esp
  802ba1:	ff 75 08             	pushl  0x8(%ebp)
  802ba4:	e8 49 fb ff ff       	call   8026f2 <alloc_block_FF>
  802ba9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802bac:	c9                   	leave  
  802bad:	c3                   	ret    

00802bae <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	83 e0 01             	and    $0x1,%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	74 03                	je     802bc1 <alloc_block_BF+0x13>
  802bbe:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802bc1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bc5:	77 07                	ja     802bce <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bc7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bce:	a1 24 50 80 00       	mov    0x805024,%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	75 73                	jne    802c4a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	83 c0 10             	add    $0x10,%eax
  802bdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802be0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802be7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bed:	01 d0                	add    %edx,%eax
  802bef:	48                   	dec    %eax
  802bf0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bf6:	ba 00 00 00 00       	mov    $0x0,%edx
  802bfb:	f7 75 e0             	divl   -0x20(%ebp)
  802bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c01:	29 d0                	sub    %edx,%eax
  802c03:	c1 e8 0c             	shr    $0xc,%eax
  802c06:	83 ec 0c             	sub    $0xc,%esp
  802c09:	50                   	push   %eax
  802c0a:	e8 18 ec ff ff       	call   801827 <sbrk>
  802c0f:	83 c4 10             	add    $0x10,%esp
  802c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c15:	83 ec 0c             	sub    $0xc,%esp
  802c18:	6a 00                	push   $0x0
  802c1a:	e8 08 ec ff ff       	call   801827 <sbrk>
  802c1f:	83 c4 10             	add    $0x10,%esp
  802c22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c28:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c2b:	83 ec 08             	sub    $0x8,%esp
  802c2e:	50                   	push   %eax
  802c2f:	ff 75 d8             	pushl  -0x28(%ebp)
  802c32:	e8 9f f8 ff ff       	call   8024d6 <initialize_dynamic_allocator>
  802c37:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c3a:	83 ec 0c             	sub    $0xc,%esp
  802c3d:	68 6f 49 80 00       	push   $0x80496f
  802c42:	e8 46 de ff ff       	call   800a8d <cprintf>
  802c47:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802c51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802c58:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802c5f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802c66:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6e:	e9 1d 01 00 00       	jmp    802d90 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802c79:	83 ec 0c             	sub    $0xc,%esp
  802c7c:	ff 75 a8             	pushl  -0x58(%ebp)
  802c7f:	e8 ee f6 ff ff       	call   802372 <get_block_size>
  802c84:	83 c4 10             	add    $0x10,%esp
  802c87:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	83 c0 08             	add    $0x8,%eax
  802c90:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c93:	0f 87 ef 00 00 00    	ja     802d88 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	83 c0 18             	add    $0x18,%eax
  802c9f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ca2:	77 1d                	ja     802cc1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802caa:	0f 86 d8 00 00 00    	jbe    802d88 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802cb0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802cb6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802cbc:	e9 c7 00 00 00       	jmp    802d88 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	83 c0 08             	add    $0x8,%eax
  802cc7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802cca:	0f 85 9d 00 00 00    	jne    802d6d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	6a 01                	push   $0x1
  802cd5:	ff 75 a4             	pushl  -0x5c(%ebp)
  802cd8:	ff 75 a8             	pushl  -0x58(%ebp)
  802cdb:	e8 e3 f9 ff ff       	call   8026c3 <set_block_data>
  802ce0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce7:	75 17                	jne    802d00 <alloc_block_BF+0x152>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 13 49 80 00       	push   $0x804913
  802cf1:	68 2c 01 00 00       	push   $0x12c
  802cf6:	68 31 49 80 00       	push   $0x804931
  802cfb:	e8 d0 da ff ff       	call   8007d0 <_panic>
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 10                	je     802d19 <alloc_block_BF+0x16b>
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d11:	8b 52 04             	mov    0x4(%edx),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 0b                	jmp    802d24 <alloc_block_BF+0x176>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0f                	je     802d3d <alloc_block_BF+0x18f>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d37:	8b 12                	mov    (%edx),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 0a                	jmp    802d47 <alloc_block_BF+0x199>
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5f:	48                   	dec    %eax
  802d60:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802d65:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d68:	e9 24 04 00 00       	jmp    803191 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d70:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d73:	76 13                	jbe    802d88 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802d75:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802d7c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802d82:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d85:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802d88:	a1 34 50 80 00       	mov    0x805034,%eax
  802d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d94:	74 07                	je     802d9d <alloc_block_BF+0x1ef>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	eb 05                	jmp    802da2 <alloc_block_BF+0x1f4>
  802d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802da2:	a3 34 50 80 00       	mov    %eax,0x805034
  802da7:	a1 34 50 80 00       	mov    0x805034,%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	0f 85 bf fe ff ff    	jne    802c73 <alloc_block_BF+0xc5>
  802db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db8:	0f 85 b5 fe ff ff    	jne    802c73 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802dbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc2:	0f 84 26 02 00 00    	je     802fee <alloc_block_BF+0x440>
  802dc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dcc:	0f 85 1c 02 00 00    	jne    802fee <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd5:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd8:	83 e8 08             	sub    $0x8,%eax
  802ddb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8d 50 08             	lea    0x8(%eax),%edx
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	01 d0                	add    %edx,%eax
  802de9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	83 c0 08             	add    $0x8,%eax
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	6a 01                	push   $0x1
  802df7:	50                   	push   %eax
  802df8:	ff 75 f0             	pushl  -0x10(%ebp)
  802dfb:	e8 c3 f8 ff ff       	call   8026c3 <set_block_data>
  802e00:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	75 68                	jne    802e75 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e11:	75 17                	jne    802e2a <alloc_block_BF+0x27c>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 4c 49 80 00       	push   $0x80494c
  802e1b:	68 45 01 00 00       	push   $0x145
  802e20:	68 31 49 80 00       	push   $0x804931
  802e25:	e8 a6 d9 ff ff       	call   8007d0 <_panic>
  802e2a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 0d                	je     802e4b <alloc_block_BF+0x29d>
  802e3e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e43:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%eax)
  802e49:	eb 08                	jmp    802e53 <alloc_block_BF+0x2a5>
  802e4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e4e:	a3 30 50 80 00       	mov    %eax,0x805030
  802e53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e56:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e65:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6a:	40                   	inc    %eax
  802e6b:	a3 38 50 80 00       	mov    %eax,0x805038
  802e70:	e9 dc 00 00 00       	jmp    802f51 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	75 65                	jne    802ee3 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802e7e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802e82:	75 17                	jne    802e9b <alloc_block_BF+0x2ed>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 80 49 80 00       	push   $0x804980
  802e8c:	68 4a 01 00 00       	push   $0x14a
  802e91:	68 31 49 80 00       	push   $0x804931
  802e96:	e8 35 d9 ff ff       	call   8007d0 <_panic>
  802e9b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ea1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	74 0c                	je     802ebd <alloc_block_BF+0x30f>
  802eb1:	a1 30 50 80 00       	mov    0x805030,%eax
  802eb6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	eb 08                	jmp    802ec5 <alloc_block_BF+0x317>
  802ebd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ec8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ecd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	a1 38 50 80 00       	mov    0x805038,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 38 50 80 00       	mov    %eax,0x805038
  802ee1:	eb 6e                	jmp    802f51 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee7:	74 06                	je     802eef <alloc_block_BF+0x341>
  802ee9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802eed:	75 17                	jne    802f06 <alloc_block_BF+0x358>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 a4 49 80 00       	push   $0x8049a4
  802ef7:	68 4f 01 00 00       	push   $0x14f
  802efc:	68 31 49 80 00       	push   $0x804931
  802f01:	e8 ca d8 ff ff       	call   8007d0 <_panic>
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 10                	mov    (%eax),%edx
  802f0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 0b                	je     802f24 <alloc_block_BF+0x376>
  802f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f21:	89 50 04             	mov    %edx,0x4(%eax)
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	75 08                	jne    802f46 <alloc_block_BF+0x398>
  802f3e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f41:	a3 30 50 80 00       	mov    %eax,0x805030
  802f46:	a1 38 50 80 00       	mov    0x805038,%eax
  802f4b:	40                   	inc    %eax
  802f4c:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f55:	75 17                	jne    802f6e <alloc_block_BF+0x3c0>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 13 49 80 00       	push   $0x804913
  802f5f:	68 51 01 00 00       	push   $0x151
  802f64:	68 31 49 80 00       	push   $0x804931
  802f69:	e8 62 d8 ff ff       	call   8007d0 <_panic>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 10                	je     802f87 <alloc_block_BF+0x3d9>
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7f:	8b 52 04             	mov    0x4(%edx),%edx
  802f82:	89 50 04             	mov    %edx,0x4(%eax)
  802f85:	eb 0b                	jmp    802f92 <alloc_block_BF+0x3e4>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0f                	je     802fab <alloc_block_BF+0x3fd>
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa5:	8b 12                	mov    (%edx),%edx
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	eb 0a                	jmp    802fb5 <alloc_block_BF+0x407>
  802fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fcd:	48                   	dec    %eax
  802fce:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	6a 00                	push   $0x0
  802fd8:	ff 75 d0             	pushl  -0x30(%ebp)
  802fdb:	ff 75 cc             	pushl  -0x34(%ebp)
  802fde:	e8 e0 f6 ff ff       	call   8026c3 <set_block_data>
  802fe3:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	e9 a3 01 00 00       	jmp    803191 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802fee:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ff2:	0f 85 9d 00 00 00    	jne    803095 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	6a 01                	push   $0x1
  802ffd:	ff 75 ec             	pushl  -0x14(%ebp)
  803000:	ff 75 f0             	pushl  -0x10(%ebp)
  803003:	e8 bb f6 ff ff       	call   8026c3 <set_block_data>
  803008:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80300b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80300f:	75 17                	jne    803028 <alloc_block_BF+0x47a>
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	68 13 49 80 00       	push   $0x804913
  803019:	68 58 01 00 00       	push   $0x158
  80301e:	68 31 49 80 00       	push   $0x804931
  803023:	e8 a8 d7 ff ff       	call   8007d0 <_panic>
  803028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 10                	je     803041 <alloc_block_BF+0x493>
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803039:	8b 52 04             	mov    0x4(%edx),%edx
  80303c:	89 50 04             	mov    %edx,0x4(%eax)
  80303f:	eb 0b                	jmp    80304c <alloc_block_BF+0x49e>
  803041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	a3 30 50 80 00       	mov    %eax,0x805030
  80304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304f:	8b 40 04             	mov    0x4(%eax),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 0f                	je     803065 <alloc_block_BF+0x4b7>
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305f:	8b 12                	mov    (%edx),%edx
  803061:	89 10                	mov    %edx,(%eax)
  803063:	eb 0a                	jmp    80306f <alloc_block_BF+0x4c1>
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803082:	a1 38 50 80 00       	mov    0x805038,%eax
  803087:	48                   	dec    %eax
  803088:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	e9 fc 00 00 00       	jmp    803191 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	83 c0 08             	add    $0x8,%eax
  80309b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80309e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030a5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030ab:	01 d0                	add    %edx,%eax
  8030ad:	48                   	dec    %eax
  8030ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8030b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030b9:	f7 75 c4             	divl   -0x3c(%ebp)
  8030bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030bf:	29 d0                	sub    %edx,%eax
  8030c1:	c1 e8 0c             	shr    $0xc,%eax
  8030c4:	83 ec 0c             	sub    $0xc,%esp
  8030c7:	50                   	push   %eax
  8030c8:	e8 5a e7 ff ff       	call   801827 <sbrk>
  8030cd:	83 c4 10             	add    $0x10,%esp
  8030d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8030d3:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8030d7:	75 0a                	jne    8030e3 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8030d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030de:	e9 ae 00 00 00       	jmp    803191 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8030e3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8030ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030f0:	01 d0                	add    %edx,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8030f6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8030f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8030fe:	f7 75 b8             	divl   -0x48(%ebp)
  803101:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803104:	29 d0                	sub    %edx,%eax
  803106:	8d 50 fc             	lea    -0x4(%eax),%edx
  803109:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80310c:	01 d0                	add    %edx,%eax
  80310e:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803113:	a1 40 50 80 00       	mov    0x805040,%eax
  803118:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80311e:	83 ec 0c             	sub    $0xc,%esp
  803121:	68 d8 49 80 00       	push   $0x8049d8
  803126:	e8 62 d9 ff ff       	call   800a8d <cprintf>
  80312b:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80312e:	83 ec 08             	sub    $0x8,%esp
  803131:	ff 75 bc             	pushl  -0x44(%ebp)
  803134:	68 dd 49 80 00       	push   $0x8049dd
  803139:	e8 4f d9 ff ff       	call   800a8d <cprintf>
  80313e:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803141:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803148:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80314b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	48                   	dec    %eax
  803151:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803154:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803157:	ba 00 00 00 00       	mov    $0x0,%edx
  80315c:	f7 75 b0             	divl   -0x50(%ebp)
  80315f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803162:	29 d0                	sub    %edx,%eax
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	6a 01                	push   $0x1
  803169:	50                   	push   %eax
  80316a:	ff 75 bc             	pushl  -0x44(%ebp)
  80316d:	e8 51 f5 ff ff       	call   8026c3 <set_block_data>
  803172:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	ff 75 bc             	pushl  -0x44(%ebp)
  80317b:	e8 36 04 00 00       	call   8035b6 <free_block>
  803180:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803183:	83 ec 0c             	sub    $0xc,%esp
  803186:	ff 75 08             	pushl  0x8(%ebp)
  803189:	e8 20 fa ff ff       	call   802bae <alloc_block_BF>
  80318e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803191:	c9                   	leave  
  803192:	c3                   	ret    

00803193 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
  803196:	53                   	push   %ebx
  803197:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80319a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8031a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ac:	74 1e                	je     8031cc <merging+0x39>
  8031ae:	ff 75 08             	pushl  0x8(%ebp)
  8031b1:	e8 bc f1 ff ff       	call   802372 <get_block_size>
  8031b6:	83 c4 04             	add    $0x4,%esp
  8031b9:	89 c2                	mov    %eax,%edx
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	01 d0                	add    %edx,%eax
  8031c0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8031c3:	75 07                	jne    8031cc <merging+0x39>
		prev_is_free = 1;
  8031c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8031cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031d0:	74 1e                	je     8031f0 <merging+0x5d>
  8031d2:	ff 75 10             	pushl  0x10(%ebp)
  8031d5:	e8 98 f1 ff ff       	call   802372 <get_block_size>
  8031da:	83 c4 04             	add    $0x4,%esp
  8031dd:	89 c2                	mov    %eax,%edx
  8031df:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031e7:	75 07                	jne    8031f0 <merging+0x5d>
		next_is_free = 1;
  8031e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8031f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f4:	0f 84 cc 00 00 00    	je     8032c6 <merging+0x133>
  8031fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031fe:	0f 84 c2 00 00 00    	je     8032c6 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803204:	ff 75 08             	pushl  0x8(%ebp)
  803207:	e8 66 f1 ff ff       	call   802372 <get_block_size>
  80320c:	83 c4 04             	add    $0x4,%esp
  80320f:	89 c3                	mov    %eax,%ebx
  803211:	ff 75 10             	pushl  0x10(%ebp)
  803214:	e8 59 f1 ff ff       	call   802372 <get_block_size>
  803219:	83 c4 04             	add    $0x4,%esp
  80321c:	01 c3                	add    %eax,%ebx
  80321e:	ff 75 0c             	pushl  0xc(%ebp)
  803221:	e8 4c f1 ff ff       	call   802372 <get_block_size>
  803226:	83 c4 04             	add    $0x4,%esp
  803229:	01 d8                	add    %ebx,%eax
  80322b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80322e:	6a 00                	push   $0x0
  803230:	ff 75 ec             	pushl  -0x14(%ebp)
  803233:	ff 75 08             	pushl  0x8(%ebp)
  803236:	e8 88 f4 ff ff       	call   8026c3 <set_block_data>
  80323b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80323e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803242:	75 17                	jne    80325b <merging+0xc8>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 13 49 80 00       	push   $0x804913
  80324c:	68 7d 01 00 00       	push   $0x17d
  803251:	68 31 49 80 00       	push   $0x804931
  803256:	e8 75 d5 ff ff       	call   8007d0 <_panic>
  80325b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 10                	je     803274 <merging+0xe1>
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80326c:	8b 52 04             	mov    0x4(%edx),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 0b                	jmp    80327f <merging+0xec>
  803274:	8b 45 0c             	mov    0xc(%ebp),%eax
  803277:	8b 40 04             	mov    0x4(%eax),%eax
  80327a:	a3 30 50 80 00       	mov    %eax,0x805030
  80327f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0f                	je     803298 <merging+0x105>
  803289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803292:	8b 12                	mov    (%edx),%edx
  803294:	89 10                	mov    %edx,(%eax)
  803296:	eb 0a                	jmp    8032a2 <merging+0x10f>
  803298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ba:	48                   	dec    %eax
  8032bb:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8032c0:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032c1:	e9 ea 02 00 00       	jmp    8035b0 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8032c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ca:	74 3b                	je     803307 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8032cc:	83 ec 0c             	sub    $0xc,%esp
  8032cf:	ff 75 08             	pushl  0x8(%ebp)
  8032d2:	e8 9b f0 ff ff       	call   802372 <get_block_size>
  8032d7:	83 c4 10             	add    $0x10,%esp
  8032da:	89 c3                	mov    %eax,%ebx
  8032dc:	83 ec 0c             	sub    $0xc,%esp
  8032df:	ff 75 10             	pushl  0x10(%ebp)
  8032e2:	e8 8b f0 ff ff       	call   802372 <get_block_size>
  8032e7:	83 c4 10             	add    $0x10,%esp
  8032ea:	01 d8                	add    %ebx,%eax
  8032ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	6a 00                	push   $0x0
  8032f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8032f7:	ff 75 08             	pushl  0x8(%ebp)
  8032fa:	e8 c4 f3 ff ff       	call   8026c3 <set_block_data>
  8032ff:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803302:	e9 a9 02 00 00       	jmp    8035b0 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80330b:	0f 84 2d 01 00 00    	je     80343e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803311:	83 ec 0c             	sub    $0xc,%esp
  803314:	ff 75 10             	pushl  0x10(%ebp)
  803317:	e8 56 f0 ff ff       	call   802372 <get_block_size>
  80331c:	83 c4 10             	add    $0x10,%esp
  80331f:	89 c3                	mov    %eax,%ebx
  803321:	83 ec 0c             	sub    $0xc,%esp
  803324:	ff 75 0c             	pushl  0xc(%ebp)
  803327:	e8 46 f0 ff ff       	call   802372 <get_block_size>
  80332c:	83 c4 10             	add    $0x10,%esp
  80332f:	01 d8                	add    %ebx,%eax
  803331:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	6a 00                	push   $0x0
  803339:	ff 75 e4             	pushl  -0x1c(%ebp)
  80333c:	ff 75 10             	pushl  0x10(%ebp)
  80333f:	e8 7f f3 ff ff       	call   8026c3 <set_block_data>
  803344:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803347:	8b 45 10             	mov    0x10(%ebp),%eax
  80334a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80334d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803351:	74 06                	je     803359 <merging+0x1c6>
  803353:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803357:	75 17                	jne    803370 <merging+0x1dd>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 ec 49 80 00       	push   $0x8049ec
  803361:	68 8d 01 00 00       	push   $0x18d
  803366:	68 31 49 80 00       	push   $0x804931
  80336b:	e8 60 d4 ff ff       	call   8007d0 <_panic>
  803370:	8b 45 0c             	mov    0xc(%ebp),%eax
  803373:	8b 50 04             	mov    0x4(%eax),%edx
  803376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80337f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 0c             	mov    0xc(%ebp),%eax
  803387:	8b 40 04             	mov    0x4(%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0d                	je     80339b <merging+0x208>
  80338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803397:	89 10                	mov    %edx,(%eax)
  803399:	eb 08                	jmp    8033a3 <merging+0x210>
  80339b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80339e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8033b1:	40                   	inc    %eax
  8033b2:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8033b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033bb:	75 17                	jne    8033d4 <merging+0x241>
  8033bd:	83 ec 04             	sub    $0x4,%esp
  8033c0:	68 13 49 80 00       	push   $0x804913
  8033c5:	68 8e 01 00 00       	push   $0x18e
  8033ca:	68 31 49 80 00       	push   $0x804931
  8033cf:	e8 fc d3 ff ff       	call   8007d0 <_panic>
  8033d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 10                	je     8033ed <merging+0x25a>
  8033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e5:	8b 52 04             	mov    0x4(%edx),%edx
  8033e8:	89 50 04             	mov    %edx,0x4(%eax)
  8033eb:	eb 0b                	jmp    8033f8 <merging+0x265>
  8033ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f0:	8b 40 04             	mov    0x4(%eax),%eax
  8033f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fb:	8b 40 04             	mov    0x4(%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 0f                	je     803411 <merging+0x27e>
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340b:	8b 12                	mov    (%edx),%edx
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	eb 0a                	jmp    80341b <merging+0x288>
  803411:	8b 45 0c             	mov    0xc(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803424:	8b 45 0c             	mov    0xc(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 38 50 80 00       	mov    0x805038,%eax
  803433:	48                   	dec    %eax
  803434:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803439:	e9 72 01 00 00       	jmp    8035b0 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80343e:	8b 45 10             	mov    0x10(%ebp),%eax
  803441:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803444:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803448:	74 79                	je     8034c3 <merging+0x330>
  80344a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344e:	74 73                	je     8034c3 <merging+0x330>
  803450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803454:	74 06                	je     80345c <merging+0x2c9>
  803456:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80345a:	75 17                	jne    803473 <merging+0x2e0>
  80345c:	83 ec 04             	sub    $0x4,%esp
  80345f:	68 a4 49 80 00       	push   $0x8049a4
  803464:	68 94 01 00 00       	push   $0x194
  803469:	68 31 49 80 00       	push   $0x804931
  80346e:	e8 5d d3 ff ff       	call   8007d0 <_panic>
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	8b 10                	mov    (%eax),%edx
  803478:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80347b:	89 10                	mov    %edx,(%eax)
  80347d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0b                	je     803491 <merging+0x2fe>
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 00                	mov    (%eax),%eax
  80348b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80348e:	89 50 04             	mov    %edx,0x4(%eax)
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803497:	89 10                	mov    %edx,(%eax)
  803499:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80349c:	8b 55 08             	mov    0x8(%ebp),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%eax)
  8034a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	75 08                	jne    8034b3 <merging+0x320>
  8034ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b8:	40                   	inc    %eax
  8034b9:	a3 38 50 80 00       	mov    %eax,0x805038
  8034be:	e9 ce 00 00 00       	jmp    803591 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8034c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c7:	74 65                	je     80352e <merging+0x39b>
  8034c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034cd:	75 17                	jne    8034e6 <merging+0x353>
  8034cf:	83 ec 04             	sub    $0x4,%esp
  8034d2:	68 80 49 80 00       	push   $0x804980
  8034d7:	68 95 01 00 00       	push   $0x195
  8034dc:	68 31 49 80 00       	push   $0x804931
  8034e1:	e8 ea d2 ff ff       	call   8007d0 <_panic>
  8034e6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ef:	89 50 04             	mov    %edx,0x4(%eax)
  8034f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f5:	8b 40 04             	mov    0x4(%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 0c                	je     803508 <merging+0x375>
  8034fc:	a1 30 50 80 00       	mov    0x805030,%eax
  803501:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803504:	89 10                	mov    %edx,(%eax)
  803506:	eb 08                	jmp    803510 <merging+0x37d>
  803508:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803513:	a3 30 50 80 00       	mov    %eax,0x805030
  803518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80351b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803521:	a1 38 50 80 00       	mov    0x805038,%eax
  803526:	40                   	inc    %eax
  803527:	a3 38 50 80 00       	mov    %eax,0x805038
  80352c:	eb 63                	jmp    803591 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80352e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803532:	75 17                	jne    80354b <merging+0x3b8>
  803534:	83 ec 04             	sub    $0x4,%esp
  803537:	68 4c 49 80 00       	push   $0x80494c
  80353c:	68 98 01 00 00       	push   $0x198
  803541:	68 31 49 80 00       	push   $0x804931
  803546:	e8 85 d2 ff ff       	call   8007d0 <_panic>
  80354b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803551:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803554:	89 10                	mov    %edx,(%eax)
  803556:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	85 c0                	test   %eax,%eax
  80355d:	74 0d                	je     80356c <merging+0x3d9>
  80355f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803564:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 08                	jmp    803574 <merging+0x3e1>
  80356c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80356f:	a3 30 50 80 00       	mov    %eax,0x805030
  803574:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803577:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803586:	a1 38 50 80 00       	mov    0x805038,%eax
  80358b:	40                   	inc    %eax
  80358c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803591:	83 ec 0c             	sub    $0xc,%esp
  803594:	ff 75 10             	pushl  0x10(%ebp)
  803597:	e8 d6 ed ff ff       	call   802372 <get_block_size>
  80359c:	83 c4 10             	add    $0x10,%esp
  80359f:	83 ec 04             	sub    $0x4,%esp
  8035a2:	6a 00                	push   $0x0
  8035a4:	50                   	push   %eax
  8035a5:	ff 75 10             	pushl  0x10(%ebp)
  8035a8:	e8 16 f1 ff ff       	call   8026c3 <set_block_data>
  8035ad:	83 c4 10             	add    $0x10,%esp
	}
}
  8035b0:	90                   	nop
  8035b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035b4:	c9                   	leave  
  8035b5:	c3                   	ret    

008035b6 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8035b6:	55                   	push   %ebp
  8035b7:	89 e5                	mov    %esp,%ebp
  8035b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8035bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8035c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8035c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035cc:	73 1b                	jae    8035e9 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8035ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8035d3:	83 ec 04             	sub    $0x4,%esp
  8035d6:	ff 75 08             	pushl  0x8(%ebp)
  8035d9:	6a 00                	push   $0x0
  8035db:	50                   	push   %eax
  8035dc:	e8 b2 fb ff ff       	call   803193 <merging>
  8035e1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8035e4:	e9 8b 00 00 00       	jmp    803674 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8035e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035f1:	76 18                	jbe    80360b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8035f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f8:	83 ec 04             	sub    $0x4,%esp
  8035fb:	ff 75 08             	pushl  0x8(%ebp)
  8035fe:	50                   	push   %eax
  8035ff:	6a 00                	push   $0x0
  803601:	e8 8d fb ff ff       	call   803193 <merging>
  803606:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803609:	eb 69                	jmp    803674 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80360b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803613:	eb 39                	jmp    80364e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803618:	3b 45 08             	cmp    0x8(%ebp),%eax
  80361b:	73 29                	jae    803646 <free_block+0x90>
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 00                	mov    (%eax),%eax
  803622:	3b 45 08             	cmp    0x8(%ebp),%eax
  803625:	76 1f                	jbe    803646 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80362f:	83 ec 04             	sub    $0x4,%esp
  803632:	ff 75 08             	pushl  0x8(%ebp)
  803635:	ff 75 f0             	pushl  -0x10(%ebp)
  803638:	ff 75 f4             	pushl  -0xc(%ebp)
  80363b:	e8 53 fb ff ff       	call   803193 <merging>
  803640:	83 c4 10             	add    $0x10,%esp
			break;
  803643:	90                   	nop
		}
	}
}
  803644:	eb 2e                	jmp    803674 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803646:	a1 34 50 80 00       	mov    0x805034,%eax
  80364b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80364e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803652:	74 07                	je     80365b <free_block+0xa5>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	eb 05                	jmp    803660 <free_block+0xaa>
  80365b:	b8 00 00 00 00       	mov    $0x0,%eax
  803660:	a3 34 50 80 00       	mov    %eax,0x805034
  803665:	a1 34 50 80 00       	mov    0x805034,%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	75 a7                	jne    803615 <free_block+0x5f>
  80366e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803672:	75 a1                	jne    803615 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803674:	90                   	nop
  803675:	c9                   	leave  
  803676:	c3                   	ret    

00803677 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80367d:	ff 75 08             	pushl  0x8(%ebp)
  803680:	e8 ed ec ff ff       	call   802372 <get_block_size>
  803685:	83 c4 04             	add    $0x4,%esp
  803688:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80368b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803692:	eb 17                	jmp    8036ab <copy_data+0x34>
  803694:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369a:	01 c2                	add    %eax,%edx
  80369c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80369f:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a2:	01 c8                	add    %ecx,%eax
  8036a4:	8a 00                	mov    (%eax),%al
  8036a6:	88 02                	mov    %al,(%edx)
  8036a8:	ff 45 fc             	incl   -0x4(%ebp)
  8036ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8036b1:	72 e1                	jb     803694 <copy_data+0x1d>
}
  8036b3:	90                   	nop
  8036b4:	c9                   	leave  
  8036b5:	c3                   	ret    

008036b6 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
  8036b9:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8036bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c0:	75 23                	jne    8036e5 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8036c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036c6:	74 13                	je     8036db <realloc_block_FF+0x25>
  8036c8:	83 ec 0c             	sub    $0xc,%esp
  8036cb:	ff 75 0c             	pushl  0xc(%ebp)
  8036ce:	e8 1f f0 ff ff       	call   8026f2 <alloc_block_FF>
  8036d3:	83 c4 10             	add    $0x10,%esp
  8036d6:	e9 f4 06 00 00       	jmp    803dcf <realloc_block_FF+0x719>
		return NULL;
  8036db:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e0:	e9 ea 06 00 00       	jmp    803dcf <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8036e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036e9:	75 18                	jne    803703 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8036eb:	83 ec 0c             	sub    $0xc,%esp
  8036ee:	ff 75 08             	pushl  0x8(%ebp)
  8036f1:	e8 c0 fe ff ff       	call   8035b6 <free_block>
  8036f6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8036f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fe:	e9 cc 06 00 00       	jmp    803dcf <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803703:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803707:	77 07                	ja     803710 <realloc_block_FF+0x5a>
  803709:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803710:	8b 45 0c             	mov    0xc(%ebp),%eax
  803713:	83 e0 01             	and    $0x1,%eax
  803716:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371c:	83 c0 08             	add    $0x8,%eax
  80371f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	ff 75 08             	pushl  0x8(%ebp)
  803728:	e8 45 ec ff ff       	call   802372 <get_block_size>
  80372d:	83 c4 10             	add    $0x10,%esp
  803730:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803736:	83 e8 08             	sub    $0x8,%eax
  803739:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	83 e8 04             	sub    $0x4,%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	83 e0 fe             	and    $0xfffffffe,%eax
  803747:	89 c2                	mov    %eax,%edx
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	01 d0                	add    %edx,%eax
  80374e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803751:	83 ec 0c             	sub    $0xc,%esp
  803754:	ff 75 e4             	pushl  -0x1c(%ebp)
  803757:	e8 16 ec ff ff       	call   802372 <get_block_size>
  80375c:	83 c4 10             	add    $0x10,%esp
  80375f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803765:	83 e8 08             	sub    $0x8,%eax
  803768:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80376b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803771:	75 08                	jne    80377b <realloc_block_FF+0xc5>
	{
		 return va;
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	e9 54 06 00 00       	jmp    803dcf <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80377b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803781:	0f 83 e5 03 00 00    	jae    803b6c <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80378d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803790:	83 ec 0c             	sub    $0xc,%esp
  803793:	ff 75 e4             	pushl  -0x1c(%ebp)
  803796:	e8 f0 eb ff ff       	call   80238b <is_free_block>
  80379b:	83 c4 10             	add    $0x10,%esp
  80379e:	84 c0                	test   %al,%al
  8037a0:	0f 84 3b 01 00 00    	je     8038e1 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8037a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037ac:	01 d0                	add    %edx,%eax
  8037ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8037b1:	83 ec 04             	sub    $0x4,%esp
  8037b4:	6a 01                	push   $0x1
  8037b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b9:	ff 75 08             	pushl  0x8(%ebp)
  8037bc:	e8 02 ef ff ff       	call   8026c3 <set_block_data>
  8037c1:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8037c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c7:	83 e8 04             	sub    $0x4,%eax
  8037ca:	8b 00                	mov    (%eax),%eax
  8037cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8037cf:	89 c2                	mov    %eax,%edx
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	01 d0                	add    %edx,%eax
  8037d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	6a 00                	push   $0x0
  8037de:	ff 75 cc             	pushl  -0x34(%ebp)
  8037e1:	ff 75 c8             	pushl  -0x38(%ebp)
  8037e4:	e8 da ee ff ff       	call   8026c3 <set_block_data>
  8037e9:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f0:	74 06                	je     8037f8 <realloc_block_FF+0x142>
  8037f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8037f6:	75 17                	jne    80380f <realloc_block_FF+0x159>
  8037f8:	83 ec 04             	sub    $0x4,%esp
  8037fb:	68 a4 49 80 00       	push   $0x8049a4
  803800:	68 f6 01 00 00       	push   $0x1f6
  803805:	68 31 49 80 00       	push   $0x804931
  80380a:	e8 c1 cf ff ff       	call   8007d0 <_panic>
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	8b 10                	mov    (%eax),%edx
  803814:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803817:	89 10                	mov    %edx,(%eax)
  803819:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	85 c0                	test   %eax,%eax
  803820:	74 0b                	je     80382d <realloc_block_FF+0x177>
  803822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803833:	89 10                	mov    %edx,(%eax)
  803835:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803838:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383b:	89 50 04             	mov    %edx,0x4(%eax)
  80383e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803841:	8b 00                	mov    (%eax),%eax
  803843:	85 c0                	test   %eax,%eax
  803845:	75 08                	jne    80384f <realloc_block_FF+0x199>
  803847:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80384a:	a3 30 50 80 00       	mov    %eax,0x805030
  80384f:	a1 38 50 80 00       	mov    0x805038,%eax
  803854:	40                   	inc    %eax
  803855:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80385a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80385e:	75 17                	jne    803877 <realloc_block_FF+0x1c1>
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 13 49 80 00       	push   $0x804913
  803868:	68 f7 01 00 00       	push   $0x1f7
  80386d:	68 31 49 80 00       	push   $0x804931
  803872:	e8 59 cf ff ff       	call   8007d0 <_panic>
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 10                	je     803890 <realloc_block_FF+0x1da>
  803880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803888:	8b 52 04             	mov    0x4(%edx),%edx
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	eb 0b                	jmp    80389b <realloc_block_FF+0x1e5>
  803890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803893:	8b 40 04             	mov    0x4(%eax),%eax
  803896:	a3 30 50 80 00       	mov    %eax,0x805030
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 0f                	je     8038b4 <realloc_block_FF+0x1fe>
  8038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a8:	8b 40 04             	mov    0x4(%eax),%eax
  8038ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ae:	8b 12                	mov    (%edx),%edx
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	eb 0a                	jmp    8038be <realloc_block_FF+0x208>
  8038b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8038d6:	48                   	dec    %eax
  8038d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8038dc:	e9 83 02 00 00       	jmp    803b64 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8038e1:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8038e5:	0f 86 69 02 00 00    	jbe    803b54 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	6a 01                	push   $0x1
  8038f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f3:	ff 75 08             	pushl  0x8(%ebp)
  8038f6:	e8 c8 ed ff ff       	call   8026c3 <set_block_data>
  8038fb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803901:	83 e8 04             	sub    $0x4,%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	83 e0 fe             	and    $0xfffffffe,%eax
  803909:	89 c2                	mov    %eax,%edx
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	01 d0                	add    %edx,%eax
  803910:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803913:	a1 38 50 80 00       	mov    0x805038,%eax
  803918:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80391b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80391f:	75 68                	jne    803989 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803921:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803925:	75 17                	jne    80393e <realloc_block_FF+0x288>
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	68 4c 49 80 00       	push   $0x80494c
  80392f:	68 06 02 00 00       	push   $0x206
  803934:	68 31 49 80 00       	push   $0x804931
  803939:	e8 92 ce ff ff       	call   8007d0 <_panic>
  80393e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803947:	89 10                	mov    %edx,(%eax)
  803949:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 0d                	je     80395f <realloc_block_FF+0x2a9>
  803952:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803957:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	eb 08                	jmp    803967 <realloc_block_FF+0x2b1>
  80395f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803962:	a3 30 50 80 00       	mov    %eax,0x805030
  803967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80396f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803979:	a1 38 50 80 00       	mov    0x805038,%eax
  80397e:	40                   	inc    %eax
  80397f:	a3 38 50 80 00       	mov    %eax,0x805038
  803984:	e9 b0 01 00 00       	jmp    803b39 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803989:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80398e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803991:	76 68                	jbe    8039fb <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803993:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803997:	75 17                	jne    8039b0 <realloc_block_FF+0x2fa>
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 4c 49 80 00       	push   $0x80494c
  8039a1:	68 0b 02 00 00       	push   $0x20b
  8039a6:	68 31 49 80 00       	push   $0x804931
  8039ab:	e8 20 ce ff ff       	call   8007d0 <_panic>
  8039b0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b9:	89 10                	mov    %edx,(%eax)
  8039bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	74 0d                	je     8039d1 <realloc_block_FF+0x31b>
  8039c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039cc:	89 50 04             	mov    %edx,0x4(%eax)
  8039cf:	eb 08                	jmp    8039d9 <realloc_block_FF+0x323>
  8039d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8039f0:	40                   	inc    %eax
  8039f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8039f6:	e9 3e 01 00 00       	jmp    803b39 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8039fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a00:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a03:	73 68                	jae    803a6d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a05:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a09:	75 17                	jne    803a22 <realloc_block_FF+0x36c>
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	68 80 49 80 00       	push   $0x804980
  803a13:	68 10 02 00 00       	push   $0x210
  803a18:	68 31 49 80 00       	push   $0x804931
  803a1d:	e8 ae cd ff ff       	call   8007d0 <_panic>
  803a22:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2b:	89 50 04             	mov    %edx,0x4(%eax)
  803a2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a31:	8b 40 04             	mov    0x4(%eax),%eax
  803a34:	85 c0                	test   %eax,%eax
  803a36:	74 0c                	je     803a44 <realloc_block_FF+0x38e>
  803a38:	a1 30 50 80 00       	mov    0x805030,%eax
  803a3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a40:	89 10                	mov    %edx,(%eax)
  803a42:	eb 08                	jmp    803a4c <realloc_block_FF+0x396>
  803a44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4f:	a3 30 50 80 00       	mov    %eax,0x805030
  803a54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5d:	a1 38 50 80 00       	mov    0x805038,%eax
  803a62:	40                   	inc    %eax
  803a63:	a3 38 50 80 00       	mov    %eax,0x805038
  803a68:	e9 cc 00 00 00       	jmp    803b39 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803a6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803a74:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a7c:	e9 8a 00 00 00       	jmp    803b0b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a84:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a87:	73 7a                	jae    803b03 <realloc_block_FF+0x44d>
  803a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a91:	73 70                	jae    803b03 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a97:	74 06                	je     803a9f <realloc_block_FF+0x3e9>
  803a99:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a9d:	75 17                	jne    803ab6 <realloc_block_FF+0x400>
  803a9f:	83 ec 04             	sub    $0x4,%esp
  803aa2:	68 a4 49 80 00       	push   $0x8049a4
  803aa7:	68 1a 02 00 00       	push   $0x21a
  803aac:	68 31 49 80 00       	push   $0x804931
  803ab1:	e8 1a cd ff ff       	call   8007d0 <_panic>
  803ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab9:	8b 10                	mov    (%eax),%edx
  803abb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abe:	89 10                	mov    %edx,(%eax)
  803ac0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	85 c0                	test   %eax,%eax
  803ac7:	74 0b                	je     803ad4 <realloc_block_FF+0x41e>
  803ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ad1:	89 50 04             	mov    %edx,0x4(%eax)
  803ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ada:	89 10                	mov    %edx,(%eax)
  803adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803adf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ae2:	89 50 04             	mov    %edx,0x4(%eax)
  803ae5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae8:	8b 00                	mov    (%eax),%eax
  803aea:	85 c0                	test   %eax,%eax
  803aec:	75 08                	jne    803af6 <realloc_block_FF+0x440>
  803aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af1:	a3 30 50 80 00       	mov    %eax,0x805030
  803af6:	a1 38 50 80 00       	mov    0x805038,%eax
  803afb:	40                   	inc    %eax
  803afc:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b01:	eb 36                	jmp    803b39 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b03:	a1 34 50 80 00       	mov    0x805034,%eax
  803b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0f:	74 07                	je     803b18 <realloc_block_FF+0x462>
  803b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b14:	8b 00                	mov    (%eax),%eax
  803b16:	eb 05                	jmp    803b1d <realloc_block_FF+0x467>
  803b18:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1d:	a3 34 50 80 00       	mov    %eax,0x805034
  803b22:	a1 34 50 80 00       	mov    0x805034,%eax
  803b27:	85 c0                	test   %eax,%eax
  803b29:	0f 85 52 ff ff ff    	jne    803a81 <realloc_block_FF+0x3cb>
  803b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b33:	0f 85 48 ff ff ff    	jne    803a81 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803b39:	83 ec 04             	sub    $0x4,%esp
  803b3c:	6a 00                	push   $0x0
  803b3e:	ff 75 d8             	pushl  -0x28(%ebp)
  803b41:	ff 75 d4             	pushl  -0x2c(%ebp)
  803b44:	e8 7a eb ff ff       	call   8026c3 <set_block_data>
  803b49:	83 c4 10             	add    $0x10,%esp
				return va;
  803b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4f:	e9 7b 02 00 00       	jmp    803dcf <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803b54:	83 ec 0c             	sub    $0xc,%esp
  803b57:	68 21 4a 80 00       	push   $0x804a21
  803b5c:	e8 2c cf ff ff       	call   800a8d <cprintf>
  803b61:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803b64:	8b 45 08             	mov    0x8(%ebp),%eax
  803b67:	e9 63 02 00 00       	jmp    803dcf <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b72:	0f 86 4d 02 00 00    	jbe    803dc5 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803b78:	83 ec 0c             	sub    $0xc,%esp
  803b7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b7e:	e8 08 e8 ff ff       	call   80238b <is_free_block>
  803b83:	83 c4 10             	add    $0x10,%esp
  803b86:	84 c0                	test   %al,%al
  803b88:	0f 84 37 02 00 00    	je     803dc5 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b91:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803b94:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803b97:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b9a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b9d:	76 38                	jbe    803bd7 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803b9f:	83 ec 0c             	sub    $0xc,%esp
  803ba2:	ff 75 08             	pushl  0x8(%ebp)
  803ba5:	e8 0c fa ff ff       	call   8035b6 <free_block>
  803baa:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803bad:	83 ec 0c             	sub    $0xc,%esp
  803bb0:	ff 75 0c             	pushl  0xc(%ebp)
  803bb3:	e8 3a eb ff ff       	call   8026f2 <alloc_block_FF>
  803bb8:	83 c4 10             	add    $0x10,%esp
  803bbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803bbe:	83 ec 08             	sub    $0x8,%esp
  803bc1:	ff 75 c0             	pushl  -0x40(%ebp)
  803bc4:	ff 75 08             	pushl  0x8(%ebp)
  803bc7:	e8 ab fa ff ff       	call   803677 <copy_data>
  803bcc:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803bcf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803bd2:	e9 f8 01 00 00       	jmp    803dcf <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bda:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803bdd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803be0:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803be4:	0f 87 a0 00 00 00    	ja     803c8a <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803bea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bee:	75 17                	jne    803c07 <realloc_block_FF+0x551>
  803bf0:	83 ec 04             	sub    $0x4,%esp
  803bf3:	68 13 49 80 00       	push   $0x804913
  803bf8:	68 38 02 00 00       	push   $0x238
  803bfd:	68 31 49 80 00       	push   $0x804931
  803c02:	e8 c9 cb ff ff       	call   8007d0 <_panic>
  803c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0a:	8b 00                	mov    (%eax),%eax
  803c0c:	85 c0                	test   %eax,%eax
  803c0e:	74 10                	je     803c20 <realloc_block_FF+0x56a>
  803c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c13:	8b 00                	mov    (%eax),%eax
  803c15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c18:	8b 52 04             	mov    0x4(%edx),%edx
  803c1b:	89 50 04             	mov    %edx,0x4(%eax)
  803c1e:	eb 0b                	jmp    803c2b <realloc_block_FF+0x575>
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	8b 40 04             	mov    0x4(%eax),%eax
  803c26:	a3 30 50 80 00       	mov    %eax,0x805030
  803c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2e:	8b 40 04             	mov    0x4(%eax),%eax
  803c31:	85 c0                	test   %eax,%eax
  803c33:	74 0f                	je     803c44 <realloc_block_FF+0x58e>
  803c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c38:	8b 40 04             	mov    0x4(%eax),%eax
  803c3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c3e:	8b 12                	mov    (%edx),%edx
  803c40:	89 10                	mov    %edx,(%eax)
  803c42:	eb 0a                	jmp    803c4e <realloc_block_FF+0x598>
  803c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c61:	a1 38 50 80 00       	mov    0x805038,%eax
  803c66:	48                   	dec    %eax
  803c67:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803c6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c72:	01 d0                	add    %edx,%eax
  803c74:	83 ec 04             	sub    $0x4,%esp
  803c77:	6a 01                	push   $0x1
  803c79:	50                   	push   %eax
  803c7a:	ff 75 08             	pushl  0x8(%ebp)
  803c7d:	e8 41 ea ff ff       	call   8026c3 <set_block_data>
  803c82:	83 c4 10             	add    $0x10,%esp
  803c85:	e9 36 01 00 00       	jmp    803dc0 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803c8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c90:	01 d0                	add    %edx,%eax
  803c92:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803c95:	83 ec 04             	sub    $0x4,%esp
  803c98:	6a 01                	push   $0x1
  803c9a:	ff 75 f0             	pushl  -0x10(%ebp)
  803c9d:	ff 75 08             	pushl  0x8(%ebp)
  803ca0:	e8 1e ea ff ff       	call   8026c3 <set_block_data>
  803ca5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cab:	83 e8 04             	sub    $0x4,%eax
  803cae:	8b 00                	mov    (%eax),%eax
  803cb0:	83 e0 fe             	and    $0xfffffffe,%eax
  803cb3:	89 c2                	mov    %eax,%edx
  803cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb8:	01 d0                	add    %edx,%eax
  803cba:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803cbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cc1:	74 06                	je     803cc9 <realloc_block_FF+0x613>
  803cc3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803cc7:	75 17                	jne    803ce0 <realloc_block_FF+0x62a>
  803cc9:	83 ec 04             	sub    $0x4,%esp
  803ccc:	68 a4 49 80 00       	push   $0x8049a4
  803cd1:	68 44 02 00 00       	push   $0x244
  803cd6:	68 31 49 80 00       	push   $0x804931
  803cdb:	e8 f0 ca ff ff       	call   8007d0 <_panic>
  803ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce3:	8b 10                	mov    (%eax),%edx
  803ce5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ce8:	89 10                	mov    %edx,(%eax)
  803cea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ced:	8b 00                	mov    (%eax),%eax
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	74 0b                	je     803cfe <realloc_block_FF+0x648>
  803cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf6:	8b 00                	mov    (%eax),%eax
  803cf8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803cfb:	89 50 04             	mov    %edx,0x4(%eax)
  803cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d01:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d04:	89 10                	mov    %edx,(%eax)
  803d06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d0c:	89 50 04             	mov    %edx,0x4(%eax)
  803d0f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d12:	8b 00                	mov    (%eax),%eax
  803d14:	85 c0                	test   %eax,%eax
  803d16:	75 08                	jne    803d20 <realloc_block_FF+0x66a>
  803d18:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d1b:	a3 30 50 80 00       	mov    %eax,0x805030
  803d20:	a1 38 50 80 00       	mov    0x805038,%eax
  803d25:	40                   	inc    %eax
  803d26:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d2f:	75 17                	jne    803d48 <realloc_block_FF+0x692>
  803d31:	83 ec 04             	sub    $0x4,%esp
  803d34:	68 13 49 80 00       	push   $0x804913
  803d39:	68 45 02 00 00       	push   $0x245
  803d3e:	68 31 49 80 00       	push   $0x804931
  803d43:	e8 88 ca ff ff       	call   8007d0 <_panic>
  803d48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4b:	8b 00                	mov    (%eax),%eax
  803d4d:	85 c0                	test   %eax,%eax
  803d4f:	74 10                	je     803d61 <realloc_block_FF+0x6ab>
  803d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d54:	8b 00                	mov    (%eax),%eax
  803d56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d59:	8b 52 04             	mov    0x4(%edx),%edx
  803d5c:	89 50 04             	mov    %edx,0x4(%eax)
  803d5f:	eb 0b                	jmp    803d6c <realloc_block_FF+0x6b6>
  803d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d64:	8b 40 04             	mov    0x4(%eax),%eax
  803d67:	a3 30 50 80 00       	mov    %eax,0x805030
  803d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6f:	8b 40 04             	mov    0x4(%eax),%eax
  803d72:	85 c0                	test   %eax,%eax
  803d74:	74 0f                	je     803d85 <realloc_block_FF+0x6cf>
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d79:	8b 40 04             	mov    0x4(%eax),%eax
  803d7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d7f:	8b 12                	mov    (%edx),%edx
  803d81:	89 10                	mov    %edx,(%eax)
  803d83:	eb 0a                	jmp    803d8f <realloc_block_FF+0x6d9>
  803d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d88:	8b 00                	mov    (%eax),%eax
  803d8a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da2:	a1 38 50 80 00       	mov    0x805038,%eax
  803da7:	48                   	dec    %eax
  803da8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803dad:	83 ec 04             	sub    $0x4,%esp
  803db0:	6a 00                	push   $0x0
  803db2:	ff 75 bc             	pushl  -0x44(%ebp)
  803db5:	ff 75 b8             	pushl  -0x48(%ebp)
  803db8:	e8 06 e9 ff ff       	call   8026c3 <set_block_data>
  803dbd:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc3:	eb 0a                	jmp    803dcf <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803dc5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803dcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803dcf:	c9                   	leave  
  803dd0:	c3                   	ret    

00803dd1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803dd1:	55                   	push   %ebp
  803dd2:	89 e5                	mov    %esp,%ebp
  803dd4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803dd7:	83 ec 04             	sub    $0x4,%esp
  803dda:	68 28 4a 80 00       	push   $0x804a28
  803ddf:	68 58 02 00 00       	push   $0x258
  803de4:	68 31 49 80 00       	push   $0x804931
  803de9:	e8 e2 c9 ff ff       	call   8007d0 <_panic>

00803dee <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803dee:	55                   	push   %ebp
  803def:	89 e5                	mov    %esp,%ebp
  803df1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803df4:	83 ec 04             	sub    $0x4,%esp
  803df7:	68 50 4a 80 00       	push   $0x804a50
  803dfc:	68 61 02 00 00       	push   $0x261
  803e01:	68 31 49 80 00       	push   $0x804931
  803e06:	e8 c5 c9 ff ff       	call   8007d0 <_panic>

00803e0b <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803e0b:	55                   	push   %ebp
  803e0c:	89 e5                	mov    %esp,%ebp
  803e0e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803e11:	83 ec 04             	sub    $0x4,%esp
  803e14:	68 78 4a 80 00       	push   $0x804a78
  803e19:	6a 09                	push   $0x9
  803e1b:	68 a0 4a 80 00       	push   $0x804aa0
  803e20:	e8 ab c9 ff ff       	call   8007d0 <_panic>

00803e25 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803e25:	55                   	push   %ebp
  803e26:	89 e5                	mov    %esp,%ebp
  803e28:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803e2b:	83 ec 04             	sub    $0x4,%esp
  803e2e:	68 b0 4a 80 00       	push   $0x804ab0
  803e33:	6a 10                	push   $0x10
  803e35:	68 a0 4a 80 00       	push   $0x804aa0
  803e3a:	e8 91 c9 ff ff       	call   8007d0 <_panic>

00803e3f <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803e3f:	55                   	push   %ebp
  803e40:	89 e5                	mov    %esp,%ebp
  803e42:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803e45:	83 ec 04             	sub    $0x4,%esp
  803e48:	68 d8 4a 80 00       	push   $0x804ad8
  803e4d:	6a 18                	push   $0x18
  803e4f:	68 a0 4a 80 00       	push   $0x804aa0
  803e54:	e8 77 c9 ff ff       	call   8007d0 <_panic>

00803e59 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803e59:	55                   	push   %ebp
  803e5a:	89 e5                	mov    %esp,%ebp
  803e5c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803e5f:	83 ec 04             	sub    $0x4,%esp
  803e62:	68 00 4b 80 00       	push   $0x804b00
  803e67:	6a 20                	push   $0x20
  803e69:	68 a0 4a 80 00       	push   $0x804aa0
  803e6e:	e8 5d c9 ff ff       	call   8007d0 <_panic>

00803e73 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803e73:	55                   	push   %ebp
  803e74:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e76:	8b 45 08             	mov    0x8(%ebp),%eax
  803e79:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e7c:	5d                   	pop    %ebp
  803e7d:	c3                   	ret    
  803e7e:	66 90                	xchg   %ax,%ax

00803e80 <__udivdi3>:
  803e80:	55                   	push   %ebp
  803e81:	57                   	push   %edi
  803e82:	56                   	push   %esi
  803e83:	53                   	push   %ebx
  803e84:	83 ec 1c             	sub    $0x1c,%esp
  803e87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e97:	89 ca                	mov    %ecx,%edx
  803e99:	89 f8                	mov    %edi,%eax
  803e9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e9f:	85 f6                	test   %esi,%esi
  803ea1:	75 2d                	jne    803ed0 <__udivdi3+0x50>
  803ea3:	39 cf                	cmp    %ecx,%edi
  803ea5:	77 65                	ja     803f0c <__udivdi3+0x8c>
  803ea7:	89 fd                	mov    %edi,%ebp
  803ea9:	85 ff                	test   %edi,%edi
  803eab:	75 0b                	jne    803eb8 <__udivdi3+0x38>
  803ead:	b8 01 00 00 00       	mov    $0x1,%eax
  803eb2:	31 d2                	xor    %edx,%edx
  803eb4:	f7 f7                	div    %edi
  803eb6:	89 c5                	mov    %eax,%ebp
  803eb8:	31 d2                	xor    %edx,%edx
  803eba:	89 c8                	mov    %ecx,%eax
  803ebc:	f7 f5                	div    %ebp
  803ebe:	89 c1                	mov    %eax,%ecx
  803ec0:	89 d8                	mov    %ebx,%eax
  803ec2:	f7 f5                	div    %ebp
  803ec4:	89 cf                	mov    %ecx,%edi
  803ec6:	89 fa                	mov    %edi,%edx
  803ec8:	83 c4 1c             	add    $0x1c,%esp
  803ecb:	5b                   	pop    %ebx
  803ecc:	5e                   	pop    %esi
  803ecd:	5f                   	pop    %edi
  803ece:	5d                   	pop    %ebp
  803ecf:	c3                   	ret    
  803ed0:	39 ce                	cmp    %ecx,%esi
  803ed2:	77 28                	ja     803efc <__udivdi3+0x7c>
  803ed4:	0f bd fe             	bsr    %esi,%edi
  803ed7:	83 f7 1f             	xor    $0x1f,%edi
  803eda:	75 40                	jne    803f1c <__udivdi3+0x9c>
  803edc:	39 ce                	cmp    %ecx,%esi
  803ede:	72 0a                	jb     803eea <__udivdi3+0x6a>
  803ee0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ee4:	0f 87 9e 00 00 00    	ja     803f88 <__udivdi3+0x108>
  803eea:	b8 01 00 00 00       	mov    $0x1,%eax
  803eef:	89 fa                	mov    %edi,%edx
  803ef1:	83 c4 1c             	add    $0x1c,%esp
  803ef4:	5b                   	pop    %ebx
  803ef5:	5e                   	pop    %esi
  803ef6:	5f                   	pop    %edi
  803ef7:	5d                   	pop    %ebp
  803ef8:	c3                   	ret    
  803ef9:	8d 76 00             	lea    0x0(%esi),%esi
  803efc:	31 ff                	xor    %edi,%edi
  803efe:	31 c0                	xor    %eax,%eax
  803f00:	89 fa                	mov    %edi,%edx
  803f02:	83 c4 1c             	add    $0x1c,%esp
  803f05:	5b                   	pop    %ebx
  803f06:	5e                   	pop    %esi
  803f07:	5f                   	pop    %edi
  803f08:	5d                   	pop    %ebp
  803f09:	c3                   	ret    
  803f0a:	66 90                	xchg   %ax,%ax
  803f0c:	89 d8                	mov    %ebx,%eax
  803f0e:	f7 f7                	div    %edi
  803f10:	31 ff                	xor    %edi,%edi
  803f12:	89 fa                	mov    %edi,%edx
  803f14:	83 c4 1c             	add    $0x1c,%esp
  803f17:	5b                   	pop    %ebx
  803f18:	5e                   	pop    %esi
  803f19:	5f                   	pop    %edi
  803f1a:	5d                   	pop    %ebp
  803f1b:	c3                   	ret    
  803f1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f21:	89 eb                	mov    %ebp,%ebx
  803f23:	29 fb                	sub    %edi,%ebx
  803f25:	89 f9                	mov    %edi,%ecx
  803f27:	d3 e6                	shl    %cl,%esi
  803f29:	89 c5                	mov    %eax,%ebp
  803f2b:	88 d9                	mov    %bl,%cl
  803f2d:	d3 ed                	shr    %cl,%ebp
  803f2f:	89 e9                	mov    %ebp,%ecx
  803f31:	09 f1                	or     %esi,%ecx
  803f33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f37:	89 f9                	mov    %edi,%ecx
  803f39:	d3 e0                	shl    %cl,%eax
  803f3b:	89 c5                	mov    %eax,%ebp
  803f3d:	89 d6                	mov    %edx,%esi
  803f3f:	88 d9                	mov    %bl,%cl
  803f41:	d3 ee                	shr    %cl,%esi
  803f43:	89 f9                	mov    %edi,%ecx
  803f45:	d3 e2                	shl    %cl,%edx
  803f47:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f4b:	88 d9                	mov    %bl,%cl
  803f4d:	d3 e8                	shr    %cl,%eax
  803f4f:	09 c2                	or     %eax,%edx
  803f51:	89 d0                	mov    %edx,%eax
  803f53:	89 f2                	mov    %esi,%edx
  803f55:	f7 74 24 0c          	divl   0xc(%esp)
  803f59:	89 d6                	mov    %edx,%esi
  803f5b:	89 c3                	mov    %eax,%ebx
  803f5d:	f7 e5                	mul    %ebp
  803f5f:	39 d6                	cmp    %edx,%esi
  803f61:	72 19                	jb     803f7c <__udivdi3+0xfc>
  803f63:	74 0b                	je     803f70 <__udivdi3+0xf0>
  803f65:	89 d8                	mov    %ebx,%eax
  803f67:	31 ff                	xor    %edi,%edi
  803f69:	e9 58 ff ff ff       	jmp    803ec6 <__udivdi3+0x46>
  803f6e:	66 90                	xchg   %ax,%ax
  803f70:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f74:	89 f9                	mov    %edi,%ecx
  803f76:	d3 e2                	shl    %cl,%edx
  803f78:	39 c2                	cmp    %eax,%edx
  803f7a:	73 e9                	jae    803f65 <__udivdi3+0xe5>
  803f7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f7f:	31 ff                	xor    %edi,%edi
  803f81:	e9 40 ff ff ff       	jmp    803ec6 <__udivdi3+0x46>
  803f86:	66 90                	xchg   %ax,%ax
  803f88:	31 c0                	xor    %eax,%eax
  803f8a:	e9 37 ff ff ff       	jmp    803ec6 <__udivdi3+0x46>
  803f8f:	90                   	nop

00803f90 <__umoddi3>:
  803f90:	55                   	push   %ebp
  803f91:	57                   	push   %edi
  803f92:	56                   	push   %esi
  803f93:	53                   	push   %ebx
  803f94:	83 ec 1c             	sub    $0x1c,%esp
  803f97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803faf:	89 f3                	mov    %esi,%ebx
  803fb1:	89 fa                	mov    %edi,%edx
  803fb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fb7:	89 34 24             	mov    %esi,(%esp)
  803fba:	85 c0                	test   %eax,%eax
  803fbc:	75 1a                	jne    803fd8 <__umoddi3+0x48>
  803fbe:	39 f7                	cmp    %esi,%edi
  803fc0:	0f 86 a2 00 00 00    	jbe    804068 <__umoddi3+0xd8>
  803fc6:	89 c8                	mov    %ecx,%eax
  803fc8:	89 f2                	mov    %esi,%edx
  803fca:	f7 f7                	div    %edi
  803fcc:	89 d0                	mov    %edx,%eax
  803fce:	31 d2                	xor    %edx,%edx
  803fd0:	83 c4 1c             	add    $0x1c,%esp
  803fd3:	5b                   	pop    %ebx
  803fd4:	5e                   	pop    %esi
  803fd5:	5f                   	pop    %edi
  803fd6:	5d                   	pop    %ebp
  803fd7:	c3                   	ret    
  803fd8:	39 f0                	cmp    %esi,%eax
  803fda:	0f 87 ac 00 00 00    	ja     80408c <__umoddi3+0xfc>
  803fe0:	0f bd e8             	bsr    %eax,%ebp
  803fe3:	83 f5 1f             	xor    $0x1f,%ebp
  803fe6:	0f 84 ac 00 00 00    	je     804098 <__umoddi3+0x108>
  803fec:	bf 20 00 00 00       	mov    $0x20,%edi
  803ff1:	29 ef                	sub    %ebp,%edi
  803ff3:	89 fe                	mov    %edi,%esi
  803ff5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ff9:	89 e9                	mov    %ebp,%ecx
  803ffb:	d3 e0                	shl    %cl,%eax
  803ffd:	89 d7                	mov    %edx,%edi
  803fff:	89 f1                	mov    %esi,%ecx
  804001:	d3 ef                	shr    %cl,%edi
  804003:	09 c7                	or     %eax,%edi
  804005:	89 e9                	mov    %ebp,%ecx
  804007:	d3 e2                	shl    %cl,%edx
  804009:	89 14 24             	mov    %edx,(%esp)
  80400c:	89 d8                	mov    %ebx,%eax
  80400e:	d3 e0                	shl    %cl,%eax
  804010:	89 c2                	mov    %eax,%edx
  804012:	8b 44 24 08          	mov    0x8(%esp),%eax
  804016:	d3 e0                	shl    %cl,%eax
  804018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80401c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804020:	89 f1                	mov    %esi,%ecx
  804022:	d3 e8                	shr    %cl,%eax
  804024:	09 d0                	or     %edx,%eax
  804026:	d3 eb                	shr    %cl,%ebx
  804028:	89 da                	mov    %ebx,%edx
  80402a:	f7 f7                	div    %edi
  80402c:	89 d3                	mov    %edx,%ebx
  80402e:	f7 24 24             	mull   (%esp)
  804031:	89 c6                	mov    %eax,%esi
  804033:	89 d1                	mov    %edx,%ecx
  804035:	39 d3                	cmp    %edx,%ebx
  804037:	0f 82 87 00 00 00    	jb     8040c4 <__umoddi3+0x134>
  80403d:	0f 84 91 00 00 00    	je     8040d4 <__umoddi3+0x144>
  804043:	8b 54 24 04          	mov    0x4(%esp),%edx
  804047:	29 f2                	sub    %esi,%edx
  804049:	19 cb                	sbb    %ecx,%ebx
  80404b:	89 d8                	mov    %ebx,%eax
  80404d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804051:	d3 e0                	shl    %cl,%eax
  804053:	89 e9                	mov    %ebp,%ecx
  804055:	d3 ea                	shr    %cl,%edx
  804057:	09 d0                	or     %edx,%eax
  804059:	89 e9                	mov    %ebp,%ecx
  80405b:	d3 eb                	shr    %cl,%ebx
  80405d:	89 da                	mov    %ebx,%edx
  80405f:	83 c4 1c             	add    $0x1c,%esp
  804062:	5b                   	pop    %ebx
  804063:	5e                   	pop    %esi
  804064:	5f                   	pop    %edi
  804065:	5d                   	pop    %ebp
  804066:	c3                   	ret    
  804067:	90                   	nop
  804068:	89 fd                	mov    %edi,%ebp
  80406a:	85 ff                	test   %edi,%edi
  80406c:	75 0b                	jne    804079 <__umoddi3+0xe9>
  80406e:	b8 01 00 00 00       	mov    $0x1,%eax
  804073:	31 d2                	xor    %edx,%edx
  804075:	f7 f7                	div    %edi
  804077:	89 c5                	mov    %eax,%ebp
  804079:	89 f0                	mov    %esi,%eax
  80407b:	31 d2                	xor    %edx,%edx
  80407d:	f7 f5                	div    %ebp
  80407f:	89 c8                	mov    %ecx,%eax
  804081:	f7 f5                	div    %ebp
  804083:	89 d0                	mov    %edx,%eax
  804085:	e9 44 ff ff ff       	jmp    803fce <__umoddi3+0x3e>
  80408a:	66 90                	xchg   %ax,%ax
  80408c:	89 c8                	mov    %ecx,%eax
  80408e:	89 f2                	mov    %esi,%edx
  804090:	83 c4 1c             	add    $0x1c,%esp
  804093:	5b                   	pop    %ebx
  804094:	5e                   	pop    %esi
  804095:	5f                   	pop    %edi
  804096:	5d                   	pop    %ebp
  804097:	c3                   	ret    
  804098:	3b 04 24             	cmp    (%esp),%eax
  80409b:	72 06                	jb     8040a3 <__umoddi3+0x113>
  80409d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040a1:	77 0f                	ja     8040b2 <__umoddi3+0x122>
  8040a3:	89 f2                	mov    %esi,%edx
  8040a5:	29 f9                	sub    %edi,%ecx
  8040a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040ab:	89 14 24             	mov    %edx,(%esp)
  8040ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040b6:	8b 14 24             	mov    (%esp),%edx
  8040b9:	83 c4 1c             	add    $0x1c,%esp
  8040bc:	5b                   	pop    %ebx
  8040bd:	5e                   	pop    %esi
  8040be:	5f                   	pop    %edi
  8040bf:	5d                   	pop    %ebp
  8040c0:	c3                   	ret    
  8040c1:	8d 76 00             	lea    0x0(%esi),%esi
  8040c4:	2b 04 24             	sub    (%esp),%eax
  8040c7:	19 fa                	sbb    %edi,%edx
  8040c9:	89 d1                	mov    %edx,%ecx
  8040cb:	89 c6                	mov    %eax,%esi
  8040cd:	e9 71 ff ff ff       	jmp    804043 <__umoddi3+0xb3>
  8040d2:	66 90                	xchg   %ax,%ax
  8040d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040d8:	72 ea                	jb     8040c4 <__umoddi3+0x134>
  8040da:	89 d9                	mov    %ebx,%ecx
  8040dc:	e9 62 ff ff ff       	jmp    804043 <__umoddi3+0xb3>

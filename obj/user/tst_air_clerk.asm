
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
  800044:	e8 02 1c 00 00       	call   801c4b <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 95 22 80 00       	mov    $0x802295,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 9f 22 80 00       	mov    $0x80229f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb ab 22 80 00       	mov    $0x8022ab,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb ba 22 80 00       	mov    $0x8022ba,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb c9 22 80 00       	mov    $0x8022c9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb de 22 80 00       	mov    $0x8022de,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb f3 22 80 00       	mov    $0x8022f3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 04 23 80 00       	mov    $0x802304,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 15 23 80 00       	mov    $0x802315,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 26 23 80 00       	mov    $0x802326,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 2f 23 80 00       	mov    $0x80232f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 39 23 80 00       	mov    $0x802339,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 44 23 80 00       	mov    $0x802344,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 50 23 80 00       	mov    $0x802350,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 5a 23 80 00       	mov    $0x80235a,%ebx
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
  8001c1:	bb 64 23 80 00       	mov    $0x802364,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 72 23 80 00       	mov    $0x802372,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 81 23 80 00       	mov    $0x802381,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 88 23 80 00       	mov    $0x802388,%ebx
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
  800225:	e8 7d 16 00 00       	call   8018a7 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 68 16 00 00       	call   8018a7 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 53 16 00 00       	call   8018a7 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 3b 16 00 00       	call   8018a7 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 23 16 00 00       	call   8018a7 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 0b 16 00 00       	call   8018a7 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 f3 15 00 00       	call   8018a7 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 db 15 00 00       	call   8018a7 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 c3 15 00 00       	call   8018a7 <sget>
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
  8002fe:	e8 89 1c 00 00       	call   801f8c <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 6d 1c 00 00       	call   801f8c <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 51 1c 00 00       	call   801f8c <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 35 1c 00 00       	call   801f8c <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 19 1c 00 00       	call   801f8c <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 22 1c 00 00       	call   801fa6 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 11 1c 00 00       	call   801fa6 <wait_semaphore>
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
  8003c4:	e8 f7 1b 00 00       	call   801fc0 <signal_semaphore>
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
  800407:	e8 9a 1b 00 00       	call   801fa6 <wait_semaphore>
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
  800467:	e8 54 1b 00 00       	call   801fc0 <signal_semaphore>
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
  80047d:	e8 24 1b 00 00       	call   801fa6 <wait_semaphore>
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
  8004dd:	e8 de 1a 00 00       	call   801fc0 <signal_semaphore>
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
  8004f3:	e8 ae 1a 00 00       	call   801fa6 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 9d 1a 00 00       	call   801fa6 <wait_semaphore>
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
  8005bb:	e8 00 1a 00 00       	call   801fc0 <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 ef 19 00 00       	call   801fc0 <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 60 22 80 00       	push   $0x802260
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 80 22 80 00       	push   $0x802280
  8005e8:	e8 db 01 00 00       	call   8007c8 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb 8f 23 80 00       	mov    $0x80238f,%ebx
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
  800626:	e8 94 0f 00 00       	call   8015bf <ltostr>
  80062b:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	8d 85 4a fe ff ff    	lea    -0x1b6(%ebp),%eax
  800637:	50                   	push   %eax
  800638:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  80063e:	50                   	push   %eax
  80063f:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  800645:	50                   	push   %eax
  800646:	e8 4d 10 00 00       	call   801698 <strcconcat>
  80064b:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80064e:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	8d 95 4a fe ff ff    	lea    -0x1b6(%ebp),%edx
  80065d:	52                   	push   %edx
  80065e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800661:	50                   	push   %eax
  800662:	e8 25 19 00 00       	call   801f8c <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 48 19 00 00       	call   801fc0 <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 37 19 00 00       	call   801fc0 <signal_semaphore>
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
  800697:	e8 96 15 00 00       	call   801c32 <sys_getenvindex>
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80069f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a2:	89 d0                	mov    %edx,%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	01 c0                	add    %eax,%eax
  8006ab:	01 d0                	add    %edx,%eax
  8006ad:	c1 e0 02             	shl    $0x2,%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	01 c0                	add    %eax,%eax
  8006b4:	01 d0                	add    %edx,%eax
  8006b6:	c1 e0 04             	shl    $0x4,%eax
  8006b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006be:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8006c8:	8a 40 20             	mov    0x20(%eax),%al
  8006cb:	84 c0                	test   %al,%al
  8006cd:	74 0d                	je     8006dc <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8006cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8006d4:	83 c0 20             	add    $0x20,%eax
  8006d7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006e0:	7e 0a                	jle    8006ec <libmain+0x5b>
		binaryname = argv[0];
  8006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	e8 3e f9 ff ff       	call   800038 <_main>
  8006fa:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8006fd:	e8 b4 12 00 00       	call   8019b6 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	68 c8 23 80 00       	push   $0x8023c8
  80070a:	e8 76 03 00 00       	call   800a85 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800712:	a1 04 30 80 00       	mov    0x803004,%eax
  800717:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80071d:	a1 04 30 80 00       	mov    0x803004,%eax
  800722:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	52                   	push   %edx
  80072c:	50                   	push   %eax
  80072d:	68 f0 23 80 00       	push   $0x8023f0
  800732:	e8 4e 03 00 00       	call   800a85 <cprintf>
  800737:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80073a:	a1 04 30 80 00       	mov    0x803004,%eax
  80073f:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800745:	a1 04 30 80 00       	mov    0x803004,%eax
  80074a:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800750:	a1 04 30 80 00       	mov    0x803004,%eax
  800755:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80075b:	51                   	push   %ecx
  80075c:	52                   	push   %edx
  80075d:	50                   	push   %eax
  80075e:	68 18 24 80 00       	push   $0x802418
  800763:	e8 1d 03 00 00       	call   800a85 <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80076b:	a1 04 30 80 00       	mov    0x803004,%eax
  800770:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 70 24 80 00       	push   $0x802470
  80077f:	e8 01 03 00 00       	call   800a85 <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800787:	83 ec 0c             	sub    $0xc,%esp
  80078a:	68 c8 23 80 00       	push   $0x8023c8
  80078f:	e8 f1 02 00 00       	call   800a85 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800797:	e8 34 12 00 00       	call   8019d0 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80079c:	e8 19 00 00 00       	call   8007ba <exit>
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007aa:	83 ec 0c             	sub    $0xc,%esp
  8007ad:	6a 00                	push   $0x0
  8007af:	e8 4a 14 00 00       	call   801bfe <sys_destroy_env>
  8007b4:	83 c4 10             	add    $0x10,%esp
}
  8007b7:	90                   	nop
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <exit>:

void
exit(void)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007c0:	e8 9f 14 00 00       	call   801c64 <sys_exit_env>
}
  8007c5:	90                   	nop
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007ce:	8d 45 10             	lea    0x10(%ebp),%eax
  8007d1:	83 c0 04             	add    $0x4,%eax
  8007d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007d7:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8007dc:	85 c0                	test   %eax,%eax
  8007de:	74 16                	je     8007f6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007e0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	50                   	push   %eax
  8007e9:	68 84 24 80 00       	push   $0x802484
  8007ee:	e8 92 02 00 00       	call   800a85 <cprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007f6:	a1 00 30 80 00       	mov    0x803000,%eax
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	ff 75 08             	pushl  0x8(%ebp)
  800801:	50                   	push   %eax
  800802:	68 89 24 80 00       	push   $0x802489
  800807:	e8 79 02 00 00       	call   800a85 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80080f:	8b 45 10             	mov    0x10(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 f4             	pushl  -0xc(%ebp)
  800818:	50                   	push   %eax
  800819:	e8 fc 01 00 00       	call   800a1a <vcprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	6a 00                	push   $0x0
  800826:	68 a5 24 80 00       	push   $0x8024a5
  80082b:	e8 ea 01 00 00       	call   800a1a <vcprintf>
  800830:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800833:	e8 82 ff ff ff       	call   8007ba <exit>

	// should not return here
	while (1) ;
  800838:	eb fe                	jmp    800838 <_panic+0x70>

0080083a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800840:	a1 04 30 80 00       	mov    0x803004,%eax
  800845:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80084b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084e:	39 c2                	cmp    %eax,%edx
  800850:	74 14                	je     800866 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	68 a8 24 80 00       	push   $0x8024a8
  80085a:	6a 26                	push   $0x26
  80085c:	68 f4 24 80 00       	push   $0x8024f4
  800861:	e8 62 ff ff ff       	call   8007c8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80086d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800874:	e9 c5 00 00 00       	jmp    80093e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	01 d0                	add    %edx,%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	85 c0                	test   %eax,%eax
  80088c:	75 08                	jne    800896 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80088e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800891:	e9 a5 00 00 00       	jmp    80093b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800896:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008a4:	eb 69                	jmp    80090f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8008ab:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b4:	89 d0                	mov    %edx,%eax
  8008b6:	01 c0                	add    %eax,%eax
  8008b8:	01 d0                	add    %edx,%eax
  8008ba:	c1 e0 03             	shl    $0x3,%eax
  8008bd:	01 c8                	add    %ecx,%eax
  8008bf:	8a 40 04             	mov    0x4(%eax),%al
  8008c2:	84 c0                	test   %al,%al
  8008c4:	75 46                	jne    80090c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8008cb:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008d4:	89 d0                	mov    %edx,%eax
  8008d6:	01 c0                	add    %eax,%eax
  8008d8:	01 d0                	add    %edx,%eax
  8008da:	c1 e0 03             	shl    $0x3,%eax
  8008dd:	01 c8                	add    %ecx,%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ec:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	01 c8                	add    %ecx,%eax
  8008fd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ff:	39 c2                	cmp    %eax,%edx
  800901:	75 09                	jne    80090c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800903:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80090a:	eb 15                	jmp    800921 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090c:	ff 45 e8             	incl   -0x18(%ebp)
  80090f:	a1 04 30 80 00       	mov    0x803004,%eax
  800914:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80091a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091d:	39 c2                	cmp    %eax,%edx
  80091f:	77 85                	ja     8008a6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800921:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800925:	75 14                	jne    80093b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800927:	83 ec 04             	sub    $0x4,%esp
  80092a:	68 00 25 80 00       	push   $0x802500
  80092f:	6a 3a                	push   $0x3a
  800931:	68 f4 24 80 00       	push   $0x8024f4
  800936:	e8 8d fe ff ff       	call   8007c8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80093b:	ff 45 f0             	incl   -0x10(%ebp)
  80093e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800941:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800944:	0f 8c 2f ff ff ff    	jl     800879 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80094a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800951:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800958:	eb 26                	jmp    800980 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80095a:	a1 04 30 80 00       	mov    0x803004,%eax
  80095f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800968:	89 d0                	mov    %edx,%eax
  80096a:	01 c0                	add    %eax,%eax
  80096c:	01 d0                	add    %edx,%eax
  80096e:	c1 e0 03             	shl    $0x3,%eax
  800971:	01 c8                	add    %ecx,%eax
  800973:	8a 40 04             	mov    0x4(%eax),%al
  800976:	3c 01                	cmp    $0x1,%al
  800978:	75 03                	jne    80097d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80097a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80097d:	ff 45 e0             	incl   -0x20(%ebp)
  800980:	a1 04 30 80 00       	mov    0x803004,%eax
  800985:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098e:	39 c2                	cmp    %eax,%edx
  800990:	77 c8                	ja     80095a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800995:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800998:	74 14                	je     8009ae <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80099a:	83 ec 04             	sub    $0x4,%esp
  80099d:	68 54 25 80 00       	push   $0x802554
  8009a2:	6a 44                	push   $0x44
  8009a4:	68 f4 24 80 00       	push   $0x8024f4
  8009a9:	e8 1a fe ff ff       	call   8007c8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009ae:	90                   	nop
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c2:	89 0a                	mov    %ecx,(%edx)
  8009c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c7:	88 d1                	mov    %dl,%cl
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009da:	75 2c                	jne    800a08 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009dc:	a0 08 30 80 00       	mov    0x803008,%al
  8009e1:	0f b6 c0             	movzbl %al,%eax
  8009e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e7:	8b 12                	mov    (%edx),%edx
  8009e9:	89 d1                	mov    %edx,%ecx
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	83 c2 08             	add    $0x8,%edx
  8009f1:	83 ec 04             	sub    $0x4,%esp
  8009f4:	50                   	push   %eax
  8009f5:	51                   	push   %ecx
  8009f6:	52                   	push   %edx
  8009f7:	e8 78 0f 00 00       	call   801974 <sys_cputs>
  8009fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0b:	8b 40 04             	mov    0x4(%eax),%eax
  800a0e:	8d 50 01             	lea    0x1(%eax),%edx
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a17:	90                   	nop
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a23:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a2a:	00 00 00 
	b.cnt = 0;
  800a2d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a34:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	68 b1 09 80 00       	push   $0x8009b1
  800a49:	e8 11 02 00 00       	call   800c5f <vprintfmt>
  800a4e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a51:	a0 08 30 80 00       	mov    0x803008,%al
  800a56:	0f b6 c0             	movzbl %al,%eax
  800a59:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a5f:	83 ec 04             	sub    $0x4,%esp
  800a62:	50                   	push   %eax
  800a63:	52                   	push   %edx
  800a64:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6a:	83 c0 08             	add    $0x8,%eax
  800a6d:	50                   	push   %eax
  800a6e:	e8 01 0f 00 00       	call   801974 <sys_cputs>
  800a73:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a76:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800a7d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a8b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800a92:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa1:	50                   	push   %eax
  800aa2:	e8 73 ff ff ff       	call   800a1a <vcprintf>
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ab8:	e8 f9 0e 00 00       	call   8019b6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800abd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  800acc:	50                   	push   %eax
  800acd:	e8 48 ff ff ff       	call   800a1a <vcprintf>
  800ad2:	83 c4 10             	add    $0x10,%esp
  800ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ad8:	e8 f3 0e 00 00       	call   8019d0 <sys_unlock_cons>
	return cnt;
  800add:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	53                   	push   %ebx
  800ae6:	83 ec 14             	sub    $0x14,%esp
  800ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800af5:	8b 45 18             	mov    0x18(%ebp),%eax
  800af8:	ba 00 00 00 00       	mov    $0x0,%edx
  800afd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b00:	77 55                	ja     800b57 <printnum+0x75>
  800b02:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b05:	72 05                	jb     800b0c <printnum+0x2a>
  800b07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b0a:	77 4b                	ja     800b57 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b0c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b0f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b12:	8b 45 18             	mov    0x18(%ebp),%eax
  800b15:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1a:	52                   	push   %edx
  800b1b:	50                   	push   %eax
  800b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b22:	e8 c1 14 00 00       	call   801fe8 <__udivdi3>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	83 ec 04             	sub    $0x4,%esp
  800b2d:	ff 75 20             	pushl  0x20(%ebp)
  800b30:	53                   	push   %ebx
  800b31:	ff 75 18             	pushl  0x18(%ebp)
  800b34:	52                   	push   %edx
  800b35:	50                   	push   %eax
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	ff 75 08             	pushl  0x8(%ebp)
  800b3c:	e8 a1 ff ff ff       	call   800ae2 <printnum>
  800b41:	83 c4 20             	add    $0x20,%esp
  800b44:	eb 1a                	jmp    800b60 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	ff 75 20             	pushl  0x20(%ebp)
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b57:	ff 4d 1c             	decl   0x1c(%ebp)
  800b5a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b5e:	7f e6                	jg     800b46 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b60:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6e:	53                   	push   %ebx
  800b6f:	51                   	push   %ecx
  800b70:	52                   	push   %edx
  800b71:	50                   	push   %eax
  800b72:	e8 81 15 00 00       	call   8020f8 <__umoddi3>
  800b77:	83 c4 10             	add    $0x10,%esp
  800b7a:	05 b4 27 80 00       	add    $0x8027b4,%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	0f be c0             	movsbl %al,%eax
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
}
  800b93:	90                   	nop
  800b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b9c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ba0:	7e 1c                	jle    800bbe <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 08             	lea    0x8(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 08             	sub    $0x8,%eax
  800bb7:	8b 50 04             	mov    0x4(%eax),%edx
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	eb 40                	jmp    800bfe <getuint+0x65>
	else if (lflag)
  800bbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc2:	74 1e                	je     800be2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	8d 50 04             	lea    0x4(%eax),%edx
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 10                	mov    %edx,(%eax)
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 00                	mov    (%eax),%eax
  800bd6:	83 e8 04             	sub    $0x4,%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	eb 1c                	jmp    800bfe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	8d 50 04             	lea    0x4(%eax),%edx
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 10                	mov    %edx,(%eax)
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	83 e8 04             	sub    $0x4,%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c03:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c07:	7e 1c                	jle    800c25 <getint+0x25>
		return va_arg(*ap, long long);
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 50 08             	lea    0x8(%eax),%edx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	89 10                	mov    %edx,(%eax)
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	83 e8 08             	sub    $0x8,%eax
  800c1e:	8b 50 04             	mov    0x4(%eax),%edx
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	eb 38                	jmp    800c5d <getint+0x5d>
	else if (lflag)
  800c25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c29:	74 1a                	je     800c45 <getint+0x45>
		return va_arg(*ap, long);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	8d 50 04             	lea    0x4(%eax),%edx
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 10                	mov    %edx,(%eax)
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 00                	mov    (%eax),%eax
  800c3d:	83 e8 04             	sub    $0x4,%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	99                   	cltd   
  800c43:	eb 18                	jmp    800c5d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8b 00                	mov    (%eax),%eax
  800c4a:	8d 50 04             	lea    0x4(%eax),%edx
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	89 10                	mov    %edx,(%eax)
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	83 e8 04             	sub    $0x4,%eax
  800c5a:	8b 00                	mov    (%eax),%eax
  800c5c:	99                   	cltd   
}
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c67:	eb 17                	jmp    800c80 <vprintfmt+0x21>
			if (ch == '\0')
  800c69:	85 db                	test   %ebx,%ebx
  800c6b:	0f 84 c1 03 00 00    	je     801032 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	53                   	push   %ebx
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	ff d0                	call   *%eax
  800c7d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	89 55 10             	mov    %edx,0x10(%ebp)
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f b6 d8             	movzbl %al,%ebx
  800c8e:	83 fb 25             	cmp    $0x25,%ebx
  800c91:	75 d6                	jne    800c69 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c93:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c97:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c9e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ca5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb6:	8d 50 01             	lea    0x1(%eax),%edx
  800cb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	0f b6 d8             	movzbl %al,%ebx
  800cc1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cc4:	83 f8 5b             	cmp    $0x5b,%eax
  800cc7:	0f 87 3d 03 00 00    	ja     80100a <vprintfmt+0x3ab>
  800ccd:	8b 04 85 d8 27 80 00 	mov    0x8027d8(,%eax,4),%eax
  800cd4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cd6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cda:	eb d7                	jmp    800cb3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cdc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ce0:	eb d1                	jmp    800cb3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ce9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cec:	89 d0                	mov    %edx,%eax
  800cee:	c1 e0 02             	shl    $0x2,%eax
  800cf1:	01 d0                	add    %edx,%eax
  800cf3:	01 c0                	add    %eax,%eax
  800cf5:	01 d8                	add    %ebx,%eax
  800cf7:	83 e8 30             	sub    $0x30,%eax
  800cfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d05:	83 fb 2f             	cmp    $0x2f,%ebx
  800d08:	7e 3e                	jle    800d48 <vprintfmt+0xe9>
  800d0a:	83 fb 39             	cmp    $0x39,%ebx
  800d0d:	7f 39                	jg     800d48 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d0f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d12:	eb d5                	jmp    800ce9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d14:	8b 45 14             	mov    0x14(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d20:	83 e8 04             	sub    $0x4,%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d28:	eb 1f                	jmp    800d49 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2e:	79 83                	jns    800cb3 <vprintfmt+0x54>
				width = 0;
  800d30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d37:	e9 77 ff ff ff       	jmp    800cb3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d3c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d43:	e9 6b ff ff ff       	jmp    800cb3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d48:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d4d:	0f 89 60 ff ff ff    	jns    800cb3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d59:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d60:	e9 4e ff ff ff       	jmp    800cb3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d65:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d68:	e9 46 ff ff ff       	jmp    800cb3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d70:	83 c0 04             	add    $0x4,%eax
  800d73:	89 45 14             	mov    %eax,0x14(%ebp)
  800d76:	8b 45 14             	mov    0x14(%ebp),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	83 ec 08             	sub    $0x8,%esp
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	50                   	push   %eax
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	ff d0                	call   *%eax
  800d8a:	83 c4 10             	add    $0x10,%esp
			break;
  800d8d:	e9 9b 02 00 00       	jmp    80102d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d92:	8b 45 14             	mov    0x14(%ebp),%eax
  800d95:	83 c0 04             	add    $0x4,%eax
  800d98:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9e:	83 e8 04             	sub    $0x4,%eax
  800da1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	79 02                	jns    800da9 <vprintfmt+0x14a>
				err = -err;
  800da7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800da9:	83 fb 64             	cmp    $0x64,%ebx
  800dac:	7f 0b                	jg     800db9 <vprintfmt+0x15a>
  800dae:	8b 34 9d 20 26 80 00 	mov    0x802620(,%ebx,4),%esi
  800db5:	85 f6                	test   %esi,%esi
  800db7:	75 19                	jne    800dd2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800db9:	53                   	push   %ebx
  800dba:	68 c5 27 80 00       	push   $0x8027c5
  800dbf:	ff 75 0c             	pushl  0xc(%ebp)
  800dc2:	ff 75 08             	pushl  0x8(%ebp)
  800dc5:	e8 70 02 00 00       	call   80103a <printfmt>
  800dca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dcd:	e9 5b 02 00 00       	jmp    80102d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd2:	56                   	push   %esi
  800dd3:	68 ce 27 80 00       	push   $0x8027ce
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	ff 75 08             	pushl  0x8(%ebp)
  800dde:	e8 57 02 00 00       	call   80103a <printfmt>
  800de3:	83 c4 10             	add    $0x10,%esp
			break;
  800de6:	e9 42 02 00 00       	jmp    80102d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	83 c0 04             	add    $0x4,%eax
  800df1:	89 45 14             	mov    %eax,0x14(%ebp)
  800df4:	8b 45 14             	mov    0x14(%ebp),%eax
  800df7:	83 e8 04             	sub    $0x4,%eax
  800dfa:	8b 30                	mov    (%eax),%esi
  800dfc:	85 f6                	test   %esi,%esi
  800dfe:	75 05                	jne    800e05 <vprintfmt+0x1a6>
				p = "(null)";
  800e00:	be d1 27 80 00       	mov    $0x8027d1,%esi
			if (width > 0 && padc != '-')
  800e05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e09:	7e 6d                	jle    800e78 <vprintfmt+0x219>
  800e0b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e0f:	74 67                	je     800e78 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	50                   	push   %eax
  800e18:	56                   	push   %esi
  800e19:	e8 1e 03 00 00       	call   80113c <strnlen>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e24:	eb 16                	jmp    800e3c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e26:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	50                   	push   %eax
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	ff d0                	call   *%eax
  800e36:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e39:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e40:	7f e4                	jg     800e26 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e42:	eb 34                	jmp    800e78 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e44:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e48:	74 1c                	je     800e66 <vprintfmt+0x207>
  800e4a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e4d:	7e 05                	jle    800e54 <vprintfmt+0x1f5>
  800e4f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e52:	7e 12                	jle    800e66 <vprintfmt+0x207>
					putch('?', putdat);
  800e54:	83 ec 08             	sub    $0x8,%esp
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	6a 3f                	push   $0x3f
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	ff d0                	call   *%eax
  800e61:	83 c4 10             	add    $0x10,%esp
  800e64:	eb 0f                	jmp    800e75 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 0c             	pushl  0xc(%ebp)
  800e6c:	53                   	push   %ebx
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	ff d0                	call   *%eax
  800e72:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e75:	ff 4d e4             	decl   -0x1c(%ebp)
  800e78:	89 f0                	mov    %esi,%eax
  800e7a:	8d 70 01             	lea    0x1(%eax),%esi
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f be d8             	movsbl %al,%ebx
  800e82:	85 db                	test   %ebx,%ebx
  800e84:	74 24                	je     800eaa <vprintfmt+0x24b>
  800e86:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e8a:	78 b8                	js     800e44 <vprintfmt+0x1e5>
  800e8c:	ff 4d e0             	decl   -0x20(%ebp)
  800e8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e93:	79 af                	jns    800e44 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e95:	eb 13                	jmp    800eaa <vprintfmt+0x24b>
				putch(' ', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 20                	push   $0x20
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ea7:	ff 4d e4             	decl   -0x1c(%ebp)
  800eaa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eae:	7f e7                	jg     800e97 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800eb0:	e9 78 01 00 00       	jmp    80102d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 3c fd ff ff       	call   800c00 <getint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed3:	85 d2                	test   %edx,%edx
  800ed5:	79 23                	jns    800efa <vprintfmt+0x29b>
				putch('-', putdat);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 0c             	pushl  0xc(%ebp)
  800edd:	6a 2d                	push   $0x2d
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	ff d0                	call   *%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eed:	f7 d8                	neg    %eax
  800eef:	83 d2 00             	adc    $0x0,%edx
  800ef2:	f7 da                	neg    %edx
  800ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800efa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f01:	e9 bc 00 00 00       	jmp    800fc2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f06:	83 ec 08             	sub    $0x8,%esp
  800f09:	ff 75 e8             	pushl  -0x18(%ebp)
  800f0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f0f:	50                   	push   %eax
  800f10:	e8 84 fc ff ff       	call   800b99 <getuint>
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f25:	e9 98 00 00 00       	jmp    800fc2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	6a 58                	push   $0x58
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	ff d0                	call   *%eax
  800f37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	ff 75 0c             	pushl  0xc(%ebp)
  800f40:	6a 58                	push   $0x58
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	ff d0                	call   *%eax
  800f47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 58                	push   $0x58
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			break;
  800f5a:	e9 ce 00 00 00       	jmp    80102d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	6a 30                	push   $0x30
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	ff d0                	call   *%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	6a 78                	push   $0x78
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	ff d0                	call   *%eax
  800f7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f82:	83 c0 04             	add    $0x4,%eax
  800f85:	89 45 14             	mov    %eax,0x14(%ebp)
  800f88:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8b:	83 e8 04             	sub    $0x4,%eax
  800f8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fa1:	eb 1f                	jmp    800fc2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800fa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800fac:	50                   	push   %eax
  800fad:	e8 e7 fb ff ff       	call   800b99 <getuint>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fc2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	52                   	push   %edx
  800fcd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd0:	50                   	push   %eax
  800fd1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd4:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	ff 75 08             	pushl  0x8(%ebp)
  800fdd:	e8 00 fb ff ff       	call   800ae2 <printnum>
  800fe2:	83 c4 20             	add    $0x20,%esp
			break;
  800fe5:	eb 46                	jmp    80102d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	ff 75 0c             	pushl  0xc(%ebp)
  800fed:	53                   	push   %ebx
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	ff d0                	call   *%eax
  800ff3:	83 c4 10             	add    $0x10,%esp
			break;
  800ff6:	eb 35                	jmp    80102d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ff8:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800fff:	eb 2c                	jmp    80102d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801001:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  801008:	eb 23                	jmp    80102d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80100a:	83 ec 08             	sub    $0x8,%esp
  80100d:	ff 75 0c             	pushl  0xc(%ebp)
  801010:	6a 25                	push   $0x25
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	ff d0                	call   *%eax
  801017:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80101a:	ff 4d 10             	decl   0x10(%ebp)
  80101d:	eb 03                	jmp    801022 <vprintfmt+0x3c3>
  80101f:	ff 4d 10             	decl   0x10(%ebp)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	48                   	dec    %eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 25                	cmp    $0x25,%al
  80102a:	75 f3                	jne    80101f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80102c:	90                   	nop
		}
	}
  80102d:	e9 35 fc ff ff       	jmp    800c67 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801032:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801033:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801040:	8d 45 10             	lea    0x10(%ebp),%eax
  801043:	83 c0 04             	add    $0x4,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	ff 75 f4             	pushl  -0xc(%ebp)
  80104f:	50                   	push   %eax
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	ff 75 08             	pushl  0x8(%ebp)
  801056:	e8 04 fc ff ff       	call   800c5f <vprintfmt>
  80105b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80105e:	90                   	nop
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	8b 40 08             	mov    0x8(%eax),%eax
  80106a:	8d 50 01             	lea    0x1(%eax),%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	8b 10                	mov    (%eax),%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 40 04             	mov    0x4(%eax),%eax
  80107e:	39 c2                	cmp    %eax,%edx
  801080:	73 12                	jae    801094 <sprintputch+0x33>
		*b->buf++ = ch;
  801082:	8b 45 0c             	mov    0xc(%ebp),%eax
  801085:	8b 00                	mov    (%eax),%eax
  801087:	8d 48 01             	lea    0x1(%eax),%ecx
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	89 0a                	mov    %ecx,(%edx)
  80108f:	8b 55 08             	mov    0x8(%ebp),%edx
  801092:	88 10                	mov    %dl,(%eax)
}
  801094:	90                   	nop
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	01 d0                	add    %edx,%eax
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bc:	74 06                	je     8010c4 <vsnprintf+0x2d>
  8010be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010c2:	7f 07                	jg     8010cb <vsnprintf+0x34>
		return -E_INVAL;
  8010c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010c9:	eb 20                	jmp    8010eb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010cb:	ff 75 14             	pushl  0x14(%ebp)
  8010ce:	ff 75 10             	pushl  0x10(%ebp)
  8010d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010d4:	50                   	push   %eax
  8010d5:	68 61 10 80 00       	push   $0x801061
  8010da:	e8 80 fb ff ff       	call   800c5f <vprintfmt>
  8010df:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    

008010ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010f3:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f6:	83 c0 04             	add    $0x4,%eax
  8010f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801102:	50                   	push   %eax
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	ff 75 08             	pushl  0x8(%ebp)
  801109:	e8 89 ff ff ff       	call   801097 <vsnprintf>
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801114:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80111f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801126:	eb 06                	jmp    80112e <strlen+0x15>
		n++;
  801128:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80112b:	ff 45 08             	incl   0x8(%ebp)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	75 f1                	jne    801128 <strlen+0xf>
		n++;
	return n;
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801149:	eb 09                	jmp    801154 <strnlen+0x18>
		n++;
  80114b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114e:	ff 45 08             	incl   0x8(%ebp)
  801151:	ff 4d 0c             	decl   0xc(%ebp)
  801154:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801158:	74 09                	je     801163 <strnlen+0x27>
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	84 c0                	test   %al,%al
  801161:	75 e8                	jne    80114b <strnlen+0xf>
		n++;
	return n;
  801163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801174:	90                   	nop
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8d 50 01             	lea    0x1(%eax),%edx
  80117b:	89 55 08             	mov    %edx,0x8(%ebp)
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	8d 4a 01             	lea    0x1(%edx),%ecx
  801184:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801187:	8a 12                	mov    (%edx),%dl
  801189:	88 10                	mov    %dl,(%eax)
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	84 c0                	test   %al,%al
  80118f:	75 e4                	jne    801175 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a9:	eb 1f                	jmp    8011ca <strncpy+0x34>
		*dst++ = *src;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8d 50 01             	lea    0x1(%eax),%edx
  8011b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b7:	8a 12                	mov    (%edx),%dl
  8011b9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	74 03                	je     8011c7 <strncpy+0x31>
			src++;
  8011c4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011d0:	72 d9                	jb     8011ab <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e7:	74 30                	je     801219 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011e9:	eb 16                	jmp    801201 <strlcpy+0x2a>
			*dst++ = *src++;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011fd:	8a 12                	mov    (%edx),%dl
  8011ff:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801201:	ff 4d 10             	decl   0x10(%ebp)
  801204:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801208:	74 09                	je     801213 <strlcpy+0x3c>
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	84 c0                	test   %al,%al
  801211:	75 d8                	jne    8011eb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801219:	8b 55 08             	mov    0x8(%ebp),%edx
  80121c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121f:	29 c2                	sub    %eax,%edx
  801221:	89 d0                	mov    %edx,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801228:	eb 06                	jmp    801230 <strcmp+0xb>
		p++, q++;
  80122a:	ff 45 08             	incl   0x8(%ebp)
  80122d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	84 c0                	test   %al,%al
  801237:	74 0e                	je     801247 <strcmp+0x22>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 10                	mov    (%eax),%dl
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	38 c2                	cmp    %al,%dl
  801245:	74 e3                	je     80122a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f b6 d0             	movzbl %al,%edx
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	0f b6 c0             	movzbl %al,%eax
  801257:	29 c2                	sub    %eax,%edx
  801259:	89 d0                	mov    %edx,%eax
}
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801260:	eb 09                	jmp    80126b <strncmp+0xe>
		n--, p++, q++;
  801262:	ff 4d 10             	decl   0x10(%ebp)
  801265:	ff 45 08             	incl   0x8(%ebp)
  801268:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80126b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126f:	74 17                	je     801288 <strncmp+0x2b>
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	84 c0                	test   %al,%al
  801278:	74 0e                	je     801288 <strncmp+0x2b>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 10                	mov    (%eax),%dl
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	38 c2                	cmp    %al,%dl
  801286:	74 da                	je     801262 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801288:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128c:	75 07                	jne    801295 <strncmp+0x38>
		return 0;
  80128e:	b8 00 00 00 00       	mov    $0x0,%eax
  801293:	eb 14                	jmp    8012a9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	0f b6 d0             	movzbl %al,%edx
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	0f b6 c0             	movzbl %al,%eax
  8012a5:	29 c2                	sub    %eax,%edx
  8012a7:	89 d0                	mov    %edx,%eax
}
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012b7:	eb 12                	jmp    8012cb <strchr+0x20>
		if (*s == c)
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012c1:	75 05                	jne    8012c8 <strchr+0x1d>
			return (char *) s;
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	eb 11                	jmp    8012d9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c8:	ff 45 08             	incl   0x8(%ebp)
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	75 e5                	jne    8012b9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012e7:	eb 0d                	jmp    8012f6 <strfind+0x1b>
		if (*s == c)
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012f1:	74 0e                	je     801301 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f3:	ff 45 08             	incl   0x8(%ebp)
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	84 c0                	test   %al,%al
  8012fd:	75 ea                	jne    8012e9 <strfind+0xe>
  8012ff:	eb 01                	jmp    801302 <strfind+0x27>
		if (*s == c)
			break;
  801301:	90                   	nop
	return (char *) s;
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801319:	eb 0e                	jmp    801329 <memset+0x22>
		*p++ = c;
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	8d 50 01             	lea    0x1(%eax),%edx
  801321:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801324:	8b 55 0c             	mov    0xc(%ebp),%edx
  801327:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801329:	ff 4d f8             	decl   -0x8(%ebp)
  80132c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801330:	79 e9                	jns    80131b <memset+0x14>
		*p++ = c;

	return v;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80133d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801349:	eb 16                	jmp    801361 <memcpy+0x2a>
		*d++ = *s++;
  80134b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134e:	8d 50 01             	lea    0x1(%eax),%edx
  801351:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801354:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801357:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80135d:	8a 12                	mov    (%edx),%dl
  80135f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	8d 50 ff             	lea    -0x1(%eax),%edx
  801367:	89 55 10             	mov    %edx,0x10(%ebp)
  80136a:	85 c0                	test   %eax,%eax
  80136c:	75 dd                	jne    80134b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801385:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801388:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80138b:	73 50                	jae    8013dd <memmove+0x6a>
  80138d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801390:	8b 45 10             	mov    0x10(%ebp),%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801398:	76 43                	jbe    8013dd <memmove+0x6a>
		s += n;
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013a6:	eb 10                	jmp    8013b8 <memmove+0x45>
			*--d = *--s;
  8013a8:	ff 4d f8             	decl   -0x8(%ebp)
  8013ab:	ff 4d fc             	decl   -0x4(%ebp)
  8013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b1:	8a 10                	mov    (%eax),%dl
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013be:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 e3                	jne    8013a8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013c5:	eb 23                	jmp    8013ea <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ca:	8d 50 01             	lea    0x1(%eax),%edx
  8013cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013d9:	8a 12                	mov    (%edx),%dl
  8013db:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	75 dd                	jne    8013c7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801401:	eb 2a                	jmp    80142d <memcmp+0x3e>
		if (*s1 != *s2)
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801406:	8a 10                	mov    (%eax),%dl
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	38 c2                	cmp    %al,%dl
  80140f:	74 16                	je     801427 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	0f b6 d0             	movzbl %al,%edx
  801419:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	0f b6 c0             	movzbl %al,%eax
  801421:	29 c2                	sub    %eax,%edx
  801423:	89 d0                	mov    %edx,%eax
  801425:	eb 18                	jmp    80143f <memcmp+0x50>
		s1++, s2++;
  801427:	ff 45 fc             	incl   -0x4(%ebp)
  80142a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80142d:	8b 45 10             	mov    0x10(%ebp),%eax
  801430:	8d 50 ff             	lea    -0x1(%eax),%edx
  801433:	89 55 10             	mov    %edx,0x10(%ebp)
  801436:	85 c0                	test   %eax,%eax
  801438:	75 c9                	jne    801403 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80143a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801447:	8b 55 08             	mov    0x8(%ebp),%edx
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801452:	eb 15                	jmp    801469 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	0f b6 d0             	movzbl %al,%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	0f b6 c0             	movzbl %al,%eax
  801462:	39 c2                	cmp    %eax,%edx
  801464:	74 0d                	je     801473 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801466:	ff 45 08             	incl   0x8(%ebp)
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80146f:	72 e3                	jb     801454 <memfind+0x13>
  801471:	eb 01                	jmp    801474 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801473:	90                   	nop
	return (void *) s;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80147f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801486:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148d:	eb 03                	jmp    801492 <strtol+0x19>
		s++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	3c 20                	cmp    $0x20,%al
  801499:	74 f4                	je     80148f <strtol+0x16>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	3c 09                	cmp    $0x9,%al
  8014a2:	74 eb                	je     80148f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 2b                	cmp    $0x2b,%al
  8014ab:	75 05                	jne    8014b2 <strtol+0x39>
		s++;
  8014ad:	ff 45 08             	incl   0x8(%ebp)
  8014b0:	eb 13                	jmp    8014c5 <strtol+0x4c>
	else if (*s == '-')
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	3c 2d                	cmp    $0x2d,%al
  8014b9:	75 0a                	jne    8014c5 <strtol+0x4c>
		s++, neg = 1;
  8014bb:	ff 45 08             	incl   0x8(%ebp)
  8014be:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c9:	74 06                	je     8014d1 <strtol+0x58>
  8014cb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014cf:	75 20                	jne    8014f1 <strtol+0x78>
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 30                	cmp    $0x30,%al
  8014d8:	75 17                	jne    8014f1 <strtol+0x78>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	40                   	inc    %eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	3c 78                	cmp    $0x78,%al
  8014e2:	75 0d                	jne    8014f1 <strtol+0x78>
		s += 2, base = 16;
  8014e4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014e8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014ef:	eb 28                	jmp    801519 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f5:	75 15                	jne    80150c <strtol+0x93>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	3c 30                	cmp    $0x30,%al
  8014fe:	75 0c                	jne    80150c <strtol+0x93>
		s++, base = 8;
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80150a:	eb 0d                	jmp    801519 <strtol+0xa0>
	else if (base == 0)
  80150c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801510:	75 07                	jne    801519 <strtol+0xa0>
		base = 10;
  801512:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	3c 2f                	cmp    $0x2f,%al
  801520:	7e 19                	jle    80153b <strtol+0xc2>
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	3c 39                	cmp    $0x39,%al
  801529:	7f 10                	jg     80153b <strtol+0xc2>
			dig = *s - '0';
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f be c0             	movsbl %al,%eax
  801533:	83 e8 30             	sub    $0x30,%eax
  801536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801539:	eb 42                	jmp    80157d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	3c 60                	cmp    $0x60,%al
  801542:	7e 19                	jle    80155d <strtol+0xe4>
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	3c 7a                	cmp    $0x7a,%al
  80154b:	7f 10                	jg     80155d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	0f be c0             	movsbl %al,%eax
  801555:	83 e8 57             	sub    $0x57,%eax
  801558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80155b:	eb 20                	jmp    80157d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	3c 40                	cmp    $0x40,%al
  801564:	7e 39                	jle    80159f <strtol+0x126>
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	3c 5a                	cmp    $0x5a,%al
  80156d:	7f 30                	jg     80159f <strtol+0x126>
			dig = *s - 'A' + 10;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f be c0             	movsbl %al,%eax
  801577:	83 e8 37             	sub    $0x37,%eax
  80157a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	3b 45 10             	cmp    0x10(%ebp),%eax
  801583:	7d 19                	jge    80159e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801585:	ff 45 08             	incl   0x8(%ebp)
  801588:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80158f:	89 c2                	mov    %eax,%edx
  801591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801599:	e9 7b ff ff ff       	jmp    801519 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80159e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	74 08                	je     8015ad <strtol+0x134>
		*endptr = (char *) s;
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ab:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b1:	74 07                	je     8015ba <strtol+0x141>
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b6:	f7 d8                	neg    %eax
  8015b8:	eb 03                	jmp    8015bd <strtol+0x144>
  8015ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <ltostr>:

void
ltostr(long value, char *str)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d7:	79 13                	jns    8015ec <ltostr+0x2d>
	{
		neg = 1;
  8015d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015e6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015e9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015f4:	99                   	cltd   
  8015f5:	f7 f9                	idiv   %ecx
  8015f7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fd:	8d 50 01             	lea    0x1(%eax),%edx
  801600:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801603:	89 c2                	mov    %eax,%edx
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	01 d0                	add    %edx,%eax
  80160a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80160d:	83 c2 30             	add    $0x30,%edx
  801610:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801612:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801615:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80161a:	f7 e9                	imul   %ecx
  80161c:	c1 fa 02             	sar    $0x2,%edx
  80161f:	89 c8                	mov    %ecx,%eax
  801621:	c1 f8 1f             	sar    $0x1f,%eax
  801624:	29 c2                	sub    %eax,%edx
  801626:	89 d0                	mov    %edx,%eax
  801628:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80162b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80162f:	75 bb                	jne    8015ec <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801638:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163b:	48                   	dec    %eax
  80163c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80163f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801643:	74 3d                	je     801682 <ltostr+0xc3>
		start = 1 ;
  801645:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80164c:	eb 34                	jmp    801682 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80164e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801651:	8b 45 0c             	mov    0xc(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80165b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80166f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801672:	8b 45 0c             	mov    0xc(%ebp),%eax
  801675:	01 c2                	add    %eax,%edx
  801677:	8a 45 eb             	mov    -0x15(%ebp),%al
  80167a:	88 02                	mov    %al,(%edx)
		start++ ;
  80167c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80167f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801688:	7c c4                	jl     80164e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80168a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	01 d0                	add    %edx,%eax
  801692:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80169e:	ff 75 08             	pushl  0x8(%ebp)
  8016a1:	e8 73 fa ff ff       	call   801119 <strlen>
  8016a6:	83 c4 04             	add    $0x4,%esp
  8016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016ac:	ff 75 0c             	pushl  0xc(%ebp)
  8016af:	e8 65 fa ff ff       	call   801119 <strlen>
  8016b4:	83 c4 04             	add    $0x4,%esp
  8016b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c8:	eb 17                	jmp    8016e1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d0:	01 c2                	add    %eax,%edx
  8016d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	01 c8                	add    %ecx,%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016de:	ff 45 fc             	incl   -0x4(%ebp)
  8016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e7:	7c e1                	jl     8016ca <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016f7:	eb 1f                	jmp    801718 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fc:	8d 50 01             	lea    0x1(%eax),%edx
  8016ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801702:	89 c2                	mov    %eax,%edx
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	01 c2                	add    %eax,%edx
  801709:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80170c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170f:	01 c8                	add    %ecx,%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801715:	ff 45 f8             	incl   -0x8(%ebp)
  801718:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80171e:	7c d9                	jl     8016f9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801720:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801723:	8b 45 10             	mov    0x10(%ebp),%eax
  801726:	01 d0                	add    %edx,%eax
  801728:	c6 00 00             	movb   $0x0,(%eax)
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801731:	8b 45 14             	mov    0x14(%ebp),%eax
  801734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80173a:	8b 45 14             	mov    0x14(%ebp),%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801751:	eb 0c                	jmp    80175f <strsplit+0x31>
			*string++ = 0;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8d 50 01             	lea    0x1(%eax),%edx
  801759:	89 55 08             	mov    %edx,0x8(%ebp)
  80175c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8a 00                	mov    (%eax),%al
  801764:	84 c0                	test   %al,%al
  801766:	74 18                	je     801780 <strsplit+0x52>
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	0f be c0             	movsbl %al,%eax
  801770:	50                   	push   %eax
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	e8 32 fb ff ff       	call   8012ab <strchr>
  801779:	83 c4 08             	add    $0x8,%esp
  80177c:	85 c0                	test   %eax,%eax
  80177e:	75 d3                	jne    801753 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	84 c0                	test   %al,%al
  801787:	74 5a                	je     8017e3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801789:	8b 45 14             	mov    0x14(%ebp),%eax
  80178c:	8b 00                	mov    (%eax),%eax
  80178e:	83 f8 0f             	cmp    $0xf,%eax
  801791:	75 07                	jne    80179a <strsplit+0x6c>
		{
			return 0;
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
  801798:	eb 66                	jmp    801800 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80179a:	8b 45 14             	mov    0x14(%ebp),%eax
  80179d:	8b 00                	mov    (%eax),%eax
  80179f:	8d 48 01             	lea    0x1(%eax),%ecx
  8017a2:	8b 55 14             	mov    0x14(%ebp),%edx
  8017a5:	89 0a                	mov    %ecx,(%edx)
  8017a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	01 c2                	add    %eax,%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b8:	eb 03                	jmp    8017bd <strsplit+0x8f>
			string++;
  8017ba:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	74 8b                	je     801751 <strsplit+0x23>
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8a 00                	mov    (%eax),%al
  8017cb:	0f be c0             	movsbl %al,%eax
  8017ce:	50                   	push   %eax
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	e8 d4 fa ff ff       	call   8012ab <strchr>
  8017d7:	83 c4 08             	add    $0x8,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	74 dc                	je     8017ba <strsplit+0x8c>
			string++;
	}
  8017de:	e9 6e ff ff ff       	jmp    801751 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017e3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e7:	8b 00                	mov    (%eax),%eax
  8017e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017fb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	68 48 29 80 00       	push   $0x802948
  801810:	68 3f 01 00 00       	push   $0x13f
  801815:	68 6a 29 80 00       	push   $0x80296a
  80181a:	e8 a9 ef ff ff       	call   8007c8 <_panic>

0080181f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	e8 ef 06 00 00       	call   801f1f <sys_sbrk>
  801830:	83 c4 10             	add    $0x10,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80183b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80183f:	75 07                	jne    801848 <malloc+0x13>
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	eb 14                	jmp    80185c <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 78 29 80 00       	push   $0x802978
  801850:	6a 1b                	push   $0x1b
  801852:	68 9d 29 80 00       	push   $0x80299d
  801857:	e8 6c ef ff ff       	call   8007c8 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 ac 29 80 00       	push   $0x8029ac
  80186c:	6a 29                	push   $0x29
  80186e:	68 9d 29 80 00       	push   $0x80299d
  801873:	e8 50 ef ff ff       	call   8007c8 <_panic>

00801878 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 18             	sub    $0x18,%esp
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801884:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801888:	75 07                	jne    801891 <smalloc+0x19>
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	eb 14                	jmp    8018a5 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	68 d0 29 80 00       	push   $0x8029d0
  801899:	6a 38                	push   $0x38
  80189b:	68 9d 29 80 00       	push   $0x80299d
  8018a0:	e8 23 ef ff ff       	call   8007c8 <_panic>
	return NULL;
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018ad:	83 ec 04             	sub    $0x4,%esp
  8018b0:	68 f8 29 80 00       	push   $0x8029f8
  8018b5:	6a 43                	push   $0x43
  8018b7:	68 9d 29 80 00       	push   $0x80299d
  8018bc:	e8 07 ef ff ff       	call   8007c8 <_panic>

008018c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 1c 2a 80 00       	push   $0x802a1c
  8018cf:	6a 5b                	push   $0x5b
  8018d1:	68 9d 29 80 00       	push   $0x80299d
  8018d6:	e8 ed ee ff ff       	call   8007c8 <_panic>

008018db <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 40 2a 80 00       	push   $0x802a40
  8018e9:	6a 72                	push   $0x72
  8018eb:	68 9d 29 80 00       	push   $0x80299d
  8018f0:	e8 d3 ee ff ff       	call   8007c8 <_panic>

008018f5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 66 2a 80 00       	push   $0x802a66
  801903:	6a 7e                	push   $0x7e
  801905:	68 9d 29 80 00       	push   $0x80299d
  80190a:	e8 b9 ee ff ff       	call   8007c8 <_panic>

0080190f <shrink>:

}
void shrink(uint32 newSize)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 66 2a 80 00       	push   $0x802a66
  80191d:	68 83 00 00 00       	push   $0x83
  801922:	68 9d 29 80 00       	push   $0x80299d
  801927:	e8 9c ee ff ff       	call   8007c8 <_panic>

0080192c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	68 66 2a 80 00       	push   $0x802a66
  80193a:	68 88 00 00 00       	push   $0x88
  80193f:	68 9d 29 80 00       	push   $0x80299d
  801944:	e8 7f ee ff ff       	call   8007c8 <_panic>

00801949 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	57                   	push   %edi
  80194d:	56                   	push   %esi
  80194e:	53                   	push   %ebx
  80194f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	8b 55 0c             	mov    0xc(%ebp),%edx
  801958:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801961:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801964:	cd 30                	int    $0x30
  801966:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5f                   	pop    %edi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 45 10             	mov    0x10(%ebp),%eax
  80197d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801980:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	52                   	push   %edx
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	50                   	push   %eax
  801990:	6a 00                	push   $0x0
  801992:	e8 b2 ff ff ff       	call   801949 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	90                   	nop
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_cgetc>:

int
sys_cgetc(void)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 02                	push   $0x2
  8019ac:	e8 98 ff ff ff       	call   801949 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 03                	push   $0x3
  8019c5:	e8 7f ff ff ff       	call   801949 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 04                	push   $0x4
  8019df:	e8 65 ff ff ff       	call   801949 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 08                	push   $0x8
  8019fd:	e8 47 ff ff ff       	call   801949 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a0c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	56                   	push   %esi
  801a1c:	53                   	push   %ebx
  801a1d:	51                   	push   %ecx
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 09                	push   $0x9
  801a22:	e8 22 ff ff ff       	call   801949 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5e                   	pop    %esi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 0a                	push   $0xa
  801a44:	e8 00 ff ff ff       	call   801949 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 0b                	push   $0xb
  801a5f:	e8 e5 fe ff ff       	call   801949 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 0c                	push   $0xc
  801a78:	e8 cc fe ff ff       	call   801949 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 0d                	push   $0xd
  801a91:	e8 b3 fe ff ff       	call   801949 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 0e                	push   $0xe
  801aaa:	e8 9a fe ff ff       	call   801949 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 0f                	push   $0xf
  801ac3:	e8 81 fe ff ff       	call   801949 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	ff 75 08             	pushl  0x8(%ebp)
  801adb:	6a 10                	push   $0x10
  801add:	e8 67 fe ff ff       	call   801949 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 11                	push   $0x11
  801af6:	e8 4e fe ff ff       	call   801949 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	50                   	push   %eax
  801b1a:	6a 01                	push   $0x1
  801b1c:	e8 28 fe ff ff       	call   801949 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 14                	push   $0x14
  801b36:	e8 0e fe ff ff       	call   801949 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b4d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	50                   	push   %eax
  801b5f:	6a 15                	push   $0x15
  801b61:	e8 e3 fd ff ff       	call   801949 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	6a 16                	push   $0x16
  801b7e:	e8 c6 fd ff ff       	call   801949 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	51                   	push   %ecx
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 17                	push   $0x17
  801b9d:	e8 a7 fd ff ff       	call   801949 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 18                	push   $0x18
  801bba:	e8 8a fd ff ff       	call   801949 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 14             	pushl  0x14(%ebp)
  801bcf:	ff 75 10             	pushl  0x10(%ebp)
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	50                   	push   %eax
  801bd6:	6a 19                	push   $0x19
  801bd8:	e8 6c fd ff ff       	call   801949 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	50                   	push   %eax
  801bf1:	6a 1a                	push   $0x1a
  801bf3:	e8 51 fd ff ff       	call   801949 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	50                   	push   %eax
  801c0d:	6a 1b                	push   $0x1b
  801c0f:	e8 35 fd ff ff       	call   801949 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 05                	push   $0x5
  801c28:	e8 1c fd ff ff       	call   801949 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 06                	push   $0x6
  801c41:	e8 03 fd ff ff       	call   801949 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 07                	push   $0x7
  801c5a:	e8 ea fc ff ff       	call   801949 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_exit_env>:


void sys_exit_env(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 1c                	push   $0x1c
  801c73:	e8 d1 fc ff ff       	call   801949 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	90                   	nop
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c87:	8d 50 04             	lea    0x4(%eax),%edx
  801c8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	52                   	push   %edx
  801c94:	50                   	push   %eax
  801c95:	6a 1d                	push   $0x1d
  801c97:	e8 ad fc ff ff       	call   801949 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca8:	89 01                	mov    %eax,(%ecx)
  801caa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	c9                   	leave  
  801cb1:	c2 04 00             	ret    $0x4

00801cb4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 10             	pushl  0x10(%ebp)
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	ff 75 08             	pushl  0x8(%ebp)
  801cc4:	6a 13                	push   $0x13
  801cc6:	e8 7e fc ff ff       	call   801949 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cce:	90                   	nop
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 1e                	push   $0x1e
  801ce0:	e8 64 fc ff ff       	call   801949 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	50                   	push   %eax
  801d03:	6a 1f                	push   $0x1f
  801d05:	e8 3f fc ff ff       	call   801949 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <rsttst>:
void rsttst()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 21                	push   $0x21
  801d1f:	e8 25 fc ff ff       	call   801949 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	8b 45 14             	mov    0x14(%ebp),%eax
  801d33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d36:	8b 55 18             	mov    0x18(%ebp),%edx
  801d39:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 20                	push   $0x20
  801d4a:	e8 fa fb ff ff       	call   801949 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <chktst>:
void chktst(uint32 n)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	ff 75 08             	pushl  0x8(%ebp)
  801d63:	6a 22                	push   $0x22
  801d65:	e8 df fb ff ff       	call   801949 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6d:	90                   	nop
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <inctst>:

void inctst()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 23                	push   $0x23
  801d7f:	e8 c5 fb ff ff       	call   801949 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <gettst>:
uint32 gettst()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 24                	push   $0x24
  801d99:	e8 ab fb ff ff       	call   801949 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 25                	push   $0x25
  801db5:	e8 8f fb ff ff       	call   801949 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
  801dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc4:	75 07                	jne    801dcd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	eb 05                	jmp    801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801de6:	e8 5e fb ff ff       	call   801949 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df5:	75 07                	jne    801dfe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfc:	eb 05                	jmp    801e03 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801e17:	e8 2d fb ff ff       	call   801949 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
  801e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e22:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e26:	75 07                	jne    801e2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb 05                	jmp    801e34 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801e48:	e8 fc fa ff ff       	call   801949 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
  801e50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e53:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e57:	75 07                	jne    801e60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5e:	eb 05                	jmp    801e65 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	ff 75 08             	pushl  0x8(%ebp)
  801e75:	6a 26                	push   $0x26
  801e77:	e8 cd fa ff ff       	call   801949 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7f:	90                   	nop
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	53                   	push   %ebx
  801e95:	51                   	push   %ecx
  801e96:	52                   	push   %edx
  801e97:	50                   	push   %eax
  801e98:	6a 27                	push   $0x27
  801e9a:	e8 aa fa ff ff       	call   801949 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 28                	push   $0x28
  801eba:	e8 8a fa ff ff       	call   801949 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ec7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	51                   	push   %ecx
  801ed3:	ff 75 10             	pushl  0x10(%ebp)
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	6a 29                	push   $0x29
  801eda:	e8 6a fa ff ff       	call   801949 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	ff 75 10             	pushl  0x10(%ebp)
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	6a 12                	push   $0x12
  801ef6:	e8 4e fa ff ff       	call   801949 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
	return ;
  801efe:	90                   	nop
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 2a                	push   $0x2a
  801f14:	e8 30 fa ff ff       	call   801949 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
	return;
  801f1c:	90                   	nop
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	50                   	push   %eax
  801f2e:	6a 2b                	push   $0x2b
  801f30:	e8 14 fa ff ff       	call   801949 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	ff 75 0c             	pushl  0xc(%ebp)
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	6a 2c                	push   $0x2c
  801f4b:	e8 f9 f9 ff ff       	call   801949 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
	return;
  801f53:	90                   	nop
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	ff 75 08             	pushl  0x8(%ebp)
  801f65:	6a 2d                	push   $0x2d
  801f67:	e8 dd f9 ff ff       	call   801949 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
	return;
  801f6f:	90                   	nop
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 78 2a 80 00       	push   $0x802a78
  801f80:	6a 09                	push   $0x9
  801f82:	68 a0 2a 80 00       	push   $0x802aa0
  801f87:	e8 3c e8 ff ff       	call   8007c8 <_panic>

00801f8c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 b0 2a 80 00       	push   $0x802ab0
  801f9a:	6a 10                	push   $0x10
  801f9c:	68 a0 2a 80 00       	push   $0x802aa0
  801fa1:	e8 22 e8 ff ff       	call   8007c8 <_panic>

00801fa6 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 d8 2a 80 00       	push   $0x802ad8
  801fb4:	6a 18                	push   $0x18
  801fb6:	68 a0 2a 80 00       	push   $0x802aa0
  801fbb:	e8 08 e8 ff ff       	call   8007c8 <_panic>

00801fc0 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 00 2b 80 00       	push   $0x802b00
  801fce:	6a 20                	push   $0x20
  801fd0:	68 a0 2a 80 00       	push   $0x802aa0
  801fd5:	e8 ee e7 ff ff       	call   8007c8 <_panic>

00801fda <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8b 40 10             	mov    0x10(%eax),%eax
}
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    
  801fe5:	66 90                	xchg   %ax,%ax
  801fe7:	90                   	nop

00801fe8 <__udivdi3>:
  801fe8:	55                   	push   %ebp
  801fe9:	57                   	push   %edi
  801fea:	56                   	push   %esi
  801feb:	53                   	push   %ebx
  801fec:	83 ec 1c             	sub    $0x1c,%esp
  801fef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ff3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ff7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ffb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fff:	89 ca                	mov    %ecx,%edx
  802001:	89 f8                	mov    %edi,%eax
  802003:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802007:	85 f6                	test   %esi,%esi
  802009:	75 2d                	jne    802038 <__udivdi3+0x50>
  80200b:	39 cf                	cmp    %ecx,%edi
  80200d:	77 65                	ja     802074 <__udivdi3+0x8c>
  80200f:	89 fd                	mov    %edi,%ebp
  802011:	85 ff                	test   %edi,%edi
  802013:	75 0b                	jne    802020 <__udivdi3+0x38>
  802015:	b8 01 00 00 00       	mov    $0x1,%eax
  80201a:	31 d2                	xor    %edx,%edx
  80201c:	f7 f7                	div    %edi
  80201e:	89 c5                	mov    %eax,%ebp
  802020:	31 d2                	xor    %edx,%edx
  802022:	89 c8                	mov    %ecx,%eax
  802024:	f7 f5                	div    %ebp
  802026:	89 c1                	mov    %eax,%ecx
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	f7 f5                	div    %ebp
  80202c:	89 cf                	mov    %ecx,%edi
  80202e:	89 fa                	mov    %edi,%edx
  802030:	83 c4 1c             	add    $0x1c,%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5f                   	pop    %edi
  802036:	5d                   	pop    %ebp
  802037:	c3                   	ret    
  802038:	39 ce                	cmp    %ecx,%esi
  80203a:	77 28                	ja     802064 <__udivdi3+0x7c>
  80203c:	0f bd fe             	bsr    %esi,%edi
  80203f:	83 f7 1f             	xor    $0x1f,%edi
  802042:	75 40                	jne    802084 <__udivdi3+0x9c>
  802044:	39 ce                	cmp    %ecx,%esi
  802046:	72 0a                	jb     802052 <__udivdi3+0x6a>
  802048:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80204c:	0f 87 9e 00 00 00    	ja     8020f0 <__udivdi3+0x108>
  802052:	b8 01 00 00 00       	mov    $0x1,%eax
  802057:	89 fa                	mov    %edi,%edx
  802059:	83 c4 1c             	add    $0x1c,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    
  802061:	8d 76 00             	lea    0x0(%esi),%esi
  802064:	31 ff                	xor    %edi,%edi
  802066:	31 c0                	xor    %eax,%eax
  802068:	89 fa                	mov    %edi,%edx
  80206a:	83 c4 1c             	add    $0x1c,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
  802072:	66 90                	xchg   %ax,%ax
  802074:	89 d8                	mov    %ebx,%eax
  802076:	f7 f7                	div    %edi
  802078:	31 ff                	xor    %edi,%edi
  80207a:	89 fa                	mov    %edi,%edx
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
  802084:	bd 20 00 00 00       	mov    $0x20,%ebp
  802089:	89 eb                	mov    %ebp,%ebx
  80208b:	29 fb                	sub    %edi,%ebx
  80208d:	89 f9                	mov    %edi,%ecx
  80208f:	d3 e6                	shl    %cl,%esi
  802091:	89 c5                	mov    %eax,%ebp
  802093:	88 d9                	mov    %bl,%cl
  802095:	d3 ed                	shr    %cl,%ebp
  802097:	89 e9                	mov    %ebp,%ecx
  802099:	09 f1                	or     %esi,%ecx
  80209b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80209f:	89 f9                	mov    %edi,%ecx
  8020a1:	d3 e0                	shl    %cl,%eax
  8020a3:	89 c5                	mov    %eax,%ebp
  8020a5:	89 d6                	mov    %edx,%esi
  8020a7:	88 d9                	mov    %bl,%cl
  8020a9:	d3 ee                	shr    %cl,%esi
  8020ab:	89 f9                	mov    %edi,%ecx
  8020ad:	d3 e2                	shl    %cl,%edx
  8020af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020b3:	88 d9                	mov    %bl,%cl
  8020b5:	d3 e8                	shr    %cl,%eax
  8020b7:	09 c2                	or     %eax,%edx
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	89 f2                	mov    %esi,%edx
  8020bd:	f7 74 24 0c          	divl   0xc(%esp)
  8020c1:	89 d6                	mov    %edx,%esi
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	f7 e5                	mul    %ebp
  8020c7:	39 d6                	cmp    %edx,%esi
  8020c9:	72 19                	jb     8020e4 <__udivdi3+0xfc>
  8020cb:	74 0b                	je     8020d8 <__udivdi3+0xf0>
  8020cd:	89 d8                	mov    %ebx,%eax
  8020cf:	31 ff                	xor    %edi,%edi
  8020d1:	e9 58 ff ff ff       	jmp    80202e <__udivdi3+0x46>
  8020d6:	66 90                	xchg   %ax,%ax
  8020d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020dc:	89 f9                	mov    %edi,%ecx
  8020de:	d3 e2                	shl    %cl,%edx
  8020e0:	39 c2                	cmp    %eax,%edx
  8020e2:	73 e9                	jae    8020cd <__udivdi3+0xe5>
  8020e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020e7:	31 ff                	xor    %edi,%edi
  8020e9:	e9 40 ff ff ff       	jmp    80202e <__udivdi3+0x46>
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	31 c0                	xor    %eax,%eax
  8020f2:	e9 37 ff ff ff       	jmp    80202e <__udivdi3+0x46>
  8020f7:	90                   	nop

008020f8 <__umoddi3>:
  8020f8:	55                   	push   %ebp
  8020f9:	57                   	push   %edi
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 1c             	sub    $0x1c,%esp
  8020ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802103:	8b 74 24 34          	mov    0x34(%esp),%esi
  802107:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80210b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80210f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802113:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802117:	89 f3                	mov    %esi,%ebx
  802119:	89 fa                	mov    %edi,%edx
  80211b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80211f:	89 34 24             	mov    %esi,(%esp)
  802122:	85 c0                	test   %eax,%eax
  802124:	75 1a                	jne    802140 <__umoddi3+0x48>
  802126:	39 f7                	cmp    %esi,%edi
  802128:	0f 86 a2 00 00 00    	jbe    8021d0 <__umoddi3+0xd8>
  80212e:	89 c8                	mov    %ecx,%eax
  802130:	89 f2                	mov    %esi,%edx
  802132:	f7 f7                	div    %edi
  802134:	89 d0                	mov    %edx,%eax
  802136:	31 d2                	xor    %edx,%edx
  802138:	83 c4 1c             	add    $0x1c,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5e                   	pop    %esi
  80213d:	5f                   	pop    %edi
  80213e:	5d                   	pop    %ebp
  80213f:	c3                   	ret    
  802140:	39 f0                	cmp    %esi,%eax
  802142:	0f 87 ac 00 00 00    	ja     8021f4 <__umoddi3+0xfc>
  802148:	0f bd e8             	bsr    %eax,%ebp
  80214b:	83 f5 1f             	xor    $0x1f,%ebp
  80214e:	0f 84 ac 00 00 00    	je     802200 <__umoddi3+0x108>
  802154:	bf 20 00 00 00       	mov    $0x20,%edi
  802159:	29 ef                	sub    %ebp,%edi
  80215b:	89 fe                	mov    %edi,%esi
  80215d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802161:	89 e9                	mov    %ebp,%ecx
  802163:	d3 e0                	shl    %cl,%eax
  802165:	89 d7                	mov    %edx,%edi
  802167:	89 f1                	mov    %esi,%ecx
  802169:	d3 ef                	shr    %cl,%edi
  80216b:	09 c7                	or     %eax,%edi
  80216d:	89 e9                	mov    %ebp,%ecx
  80216f:	d3 e2                	shl    %cl,%edx
  802171:	89 14 24             	mov    %edx,(%esp)
  802174:	89 d8                	mov    %ebx,%eax
  802176:	d3 e0                	shl    %cl,%eax
  802178:	89 c2                	mov    %eax,%edx
  80217a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80217e:	d3 e0                	shl    %cl,%eax
  802180:	89 44 24 04          	mov    %eax,0x4(%esp)
  802184:	8b 44 24 08          	mov    0x8(%esp),%eax
  802188:	89 f1                	mov    %esi,%ecx
  80218a:	d3 e8                	shr    %cl,%eax
  80218c:	09 d0                	or     %edx,%eax
  80218e:	d3 eb                	shr    %cl,%ebx
  802190:	89 da                	mov    %ebx,%edx
  802192:	f7 f7                	div    %edi
  802194:	89 d3                	mov    %edx,%ebx
  802196:	f7 24 24             	mull   (%esp)
  802199:	89 c6                	mov    %eax,%esi
  80219b:	89 d1                	mov    %edx,%ecx
  80219d:	39 d3                	cmp    %edx,%ebx
  80219f:	0f 82 87 00 00 00    	jb     80222c <__umoddi3+0x134>
  8021a5:	0f 84 91 00 00 00    	je     80223c <__umoddi3+0x144>
  8021ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021af:	29 f2                	sub    %esi,%edx
  8021b1:	19 cb                	sbb    %ecx,%ebx
  8021b3:	89 d8                	mov    %ebx,%eax
  8021b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021b9:	d3 e0                	shl    %cl,%eax
  8021bb:	89 e9                	mov    %ebp,%ecx
  8021bd:	d3 ea                	shr    %cl,%edx
  8021bf:	09 d0                	or     %edx,%eax
  8021c1:	89 e9                	mov    %ebp,%ecx
  8021c3:	d3 eb                	shr    %cl,%ebx
  8021c5:	89 da                	mov    %ebx,%edx
  8021c7:	83 c4 1c             	add    $0x1c,%esp
  8021ca:	5b                   	pop    %ebx
  8021cb:	5e                   	pop    %esi
  8021cc:	5f                   	pop    %edi
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    
  8021cf:	90                   	nop
  8021d0:	89 fd                	mov    %edi,%ebp
  8021d2:	85 ff                	test   %edi,%edi
  8021d4:	75 0b                	jne    8021e1 <__umoddi3+0xe9>
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021db:	31 d2                	xor    %edx,%edx
  8021dd:	f7 f7                	div    %edi
  8021df:	89 c5                	mov    %eax,%ebp
  8021e1:	89 f0                	mov    %esi,%eax
  8021e3:	31 d2                	xor    %edx,%edx
  8021e5:	f7 f5                	div    %ebp
  8021e7:	89 c8                	mov    %ecx,%eax
  8021e9:	f7 f5                	div    %ebp
  8021eb:	89 d0                	mov    %edx,%eax
  8021ed:	e9 44 ff ff ff       	jmp    802136 <__umoddi3+0x3e>
  8021f2:	66 90                	xchg   %ax,%ax
  8021f4:	89 c8                	mov    %ecx,%eax
  8021f6:	89 f2                	mov    %esi,%edx
  8021f8:	83 c4 1c             	add    $0x1c,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5f                   	pop    %edi
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    
  802200:	3b 04 24             	cmp    (%esp),%eax
  802203:	72 06                	jb     80220b <__umoddi3+0x113>
  802205:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802209:	77 0f                	ja     80221a <__umoddi3+0x122>
  80220b:	89 f2                	mov    %esi,%edx
  80220d:	29 f9                	sub    %edi,%ecx
  80220f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802213:	89 14 24             	mov    %edx,(%esp)
  802216:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80221a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80221e:	8b 14 24             	mov    (%esp),%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d 76 00             	lea    0x0(%esi),%esi
  80222c:	2b 04 24             	sub    (%esp),%eax
  80222f:	19 fa                	sbb    %edi,%edx
  802231:	89 d1                	mov    %edx,%ecx
  802233:	89 c6                	mov    %eax,%esi
  802235:	e9 71 ff ff ff       	jmp    8021ab <__umoddi3+0xb3>
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802240:	72 ea                	jb     80222c <__umoddi3+0x134>
  802242:	89 d9                	mov    %ebx,%ecx
  802244:	e9 62 ff ff ff       	jmp    8021ab <__umoddi3+0xb3>

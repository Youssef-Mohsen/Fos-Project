
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
  800044:	e8 18 1c 00 00       	call   801c61 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb b5 22 80 00       	mov    $0x8022b5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb bf 22 80 00       	mov    $0x8022bf,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb cb 22 80 00       	mov    $0x8022cb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb da 22 80 00       	mov    $0x8022da,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb e9 22 80 00       	mov    $0x8022e9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb fe 22 80 00       	mov    $0x8022fe,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 13 23 80 00       	mov    $0x802313,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 24 23 80 00       	mov    $0x802324,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 35 23 80 00       	mov    $0x802335,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 46 23 80 00       	mov    $0x802346,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 4f 23 80 00       	mov    $0x80234f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 59 23 80 00       	mov    $0x802359,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 64 23 80 00       	mov    $0x802364,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 70 23 80 00       	mov    $0x802370,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 7a 23 80 00       	mov    $0x80237a,%ebx
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
  8001c1:	bb 84 23 80 00       	mov    $0x802384,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 92 23 80 00       	mov    $0x802392,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb a1 23 80 00       	mov    $0x8023a1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb a8 23 80 00       	mov    $0x8023a8,%ebx
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
  800225:	e8 93 16 00 00       	call   8018bd <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 7e 16 00 00       	call   8018bd <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 69 16 00 00       	call   8018bd <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 51 16 00 00       	call   8018bd <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 39 16 00 00       	call   8018bd <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 21 16 00 00       	call   8018bd <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 09 16 00 00       	call   8018bd <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 f1 15 00 00       	call   8018bd <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 d9 15 00 00       	call   8018bd <sget>
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
  8002fe:	e8 a3 1c 00 00       	call   801fa6 <get_semaphore>
  800303:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800306:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	8d 95 fd fe ff ff    	lea    -0x103(%ebp),%edx
  800315:	52                   	push   %edx
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	50                   	push   %eax
  80031a:	e8 87 1c 00 00       	call   801fa6 <get_semaphore>
  80031f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800322:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  800328:	83 ec 04             	sub    $0x4,%esp
  80032b:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  800331:	52                   	push   %edx
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 6b 1c 00 00       	call   801fa6 <get_semaphore>
  80033b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  80033e:	8d 85 a8 fe ff ff    	lea    -0x158(%ebp),%eax
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8d 95 e9 fe ff ff    	lea    -0x117(%ebp),%edx
  80034d:	52                   	push   %edx
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	50                   	push   %eax
  800352:	e8 4f 1c 00 00       	call   801fa6 <get_semaphore>
  800357:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035a:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	8d 95 e3 fe ff ff    	lea    -0x11d(%ebp),%edx
  800369:	52                   	push   %edx
  80036a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 33 1c 00 00       	call   801fa6 <get_semaphore>
  800373:	83 c4 0c             	add    $0xc,%esp

	while(1==1)
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff b5 b4 fe ff ff    	pushl  -0x14c(%ebp)
  80037f:	e8 3c 1c 00 00       	call   801fc0 <wait_semaphore>
  800384:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff b5 b0 fe ff ff    	pushl  -0x150(%ebp)
  800390:	e8 2b 1c 00 00       	call   801fc0 <wait_semaphore>
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
  8003c4:	e8 11 1c 00 00       	call   801fda <signal_semaphore>
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
  800407:	e8 b4 1b 00 00       	call   801fc0 <wait_semaphore>
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
  800467:	e8 6e 1b 00 00       	call   801fda <signal_semaphore>
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
  80047d:	e8 3e 1b 00 00       	call   801fc0 <wait_semaphore>
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
  8004dd:	e8 f8 1a 00 00       	call   801fda <signal_semaphore>
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
  8004f3:	e8 c8 1a 00 00       	call   801fc0 <wait_semaphore>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  800504:	e8 b7 1a 00 00       	call   801fc0 <wait_semaphore>
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
  8005bb:	e8 1a 1a 00 00       	call   801fda <signal_semaphore>
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	ff b5 a8 fe ff ff    	pushl  -0x158(%ebp)
  8005cc:	e8 09 1a 00 00       	call   801fda <signal_semaphore>
  8005d1:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8005d4:	eb 17                	jmp    8005ed <_main+0x5b5>
		default:
			panic("customer must have flight type\n");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 80 22 80 00       	push   $0x802280
  8005de:	68 95 00 00 00       	push   $0x95
  8005e3:	68 a0 22 80 00       	push   $0x8022a0
  8005e8:	e8 f1 01 00 00       	call   8007de <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8005ed:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  8005f3:	bb af 23 80 00       	mov    $0x8023af,%ebx
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
  800626:	e8 aa 0f 00 00       	call   8015d5 <ltostr>
  80062b:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80062e:	83 ec 04             	sub    $0x4,%esp
  800631:	8d 85 4a fe ff ff    	lea    -0x1b6(%ebp),%eax
  800637:	50                   	push   %eax
  800638:	8d 85 81 fe ff ff    	lea    -0x17f(%ebp),%eax
  80063e:	50                   	push   %eax
  80063f:	8d 85 86 fe ff ff    	lea    -0x17a(%ebp),%eax
  800645:	50                   	push   %eax
  800646:	e8 63 10 00 00       	call   8016ae <strcconcat>
  80064b:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80064e:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	8d 95 4a fe ff ff    	lea    -0x1b6(%ebp),%edx
  80065d:	52                   	push   %edx
  80065e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800661:	50                   	push   %eax
  800662:	e8 3f 19 00 00       	call   801fa6 <get_semaphore>
  800667:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  80066a:	83 ec 0c             	sub    $0xc,%esp
  80066d:	ff b5 7c fe ff ff    	pushl  -0x184(%ebp)
  800673:	e8 62 19 00 00       	call   801fda <signal_semaphore>
  800678:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	ff b5 a4 fe ff ff    	pushl  -0x15c(%ebp)
  800684:	e8 51 19 00 00       	call   801fda <signal_semaphore>
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
  800697:	e8 ac 15 00 00       	call   801c48 <sys_getenvindex>
  80069c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80069f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a2:	89 d0                	mov    %edx,%eax
  8006a4:	c1 e0 06             	shl    $0x6,%eax
  8006a7:	29 d0                	sub    %edx,%eax
  8006a9:	c1 e0 02             	shl    $0x2,%eax
  8006ac:	01 d0                	add    %edx,%eax
  8006ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006b5:	01 c8                	add    %ecx,%eax
  8006b7:	c1 e0 03             	shl    $0x3,%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c3:	29 c2                	sub    %eax,%edx
  8006c5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006cc:	89 c2                	mov    %eax,%edx
  8006ce:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006d4:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006d9:	a1 04 30 80 00       	mov    0x803004,%eax
  8006de:	8a 40 20             	mov    0x20(%eax),%al
  8006e1:	84 c0                	test   %al,%al
  8006e3:	74 0d                	je     8006f2 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8006e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8006ea:	83 c0 20             	add    $0x20,%eax
  8006ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006f6:	7e 0a                	jle    800702 <libmain+0x71>
		binaryname = argv[0];
  8006f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	e8 28 f9 ff ff       	call   800038 <_main>
  800710:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800713:	e8 b4 12 00 00       	call   8019cc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 e8 23 80 00       	push   $0x8023e8
  800720:	e8 76 03 00 00       	call   800a9b <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800728:	a1 04 30 80 00       	mov    0x803004,%eax
  80072d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800733:	a1 04 30 80 00       	mov    0x803004,%eax
  800738:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	52                   	push   %edx
  800742:	50                   	push   %eax
  800743:	68 10 24 80 00       	push   $0x802410
  800748:	e8 4e 03 00 00       	call   800a9b <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800750:	a1 04 30 80 00       	mov    0x803004,%eax
  800755:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80075b:	a1 04 30 80 00       	mov    0x803004,%eax
  800760:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800766:	a1 04 30 80 00       	mov    0x803004,%eax
  80076b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800771:	51                   	push   %ecx
  800772:	52                   	push   %edx
  800773:	50                   	push   %eax
  800774:	68 38 24 80 00       	push   $0x802438
  800779:	e8 1d 03 00 00       	call   800a9b <cprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800781:	a1 04 30 80 00       	mov    0x803004,%eax
  800786:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	50                   	push   %eax
  800790:	68 90 24 80 00       	push   $0x802490
  800795:	e8 01 03 00 00       	call   800a9b <cprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80079d:	83 ec 0c             	sub    $0xc,%esp
  8007a0:	68 e8 23 80 00       	push   $0x8023e8
  8007a5:	e8 f1 02 00 00       	call   800a9b <cprintf>
  8007aa:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8007ad:	e8 34 12 00 00       	call   8019e6 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8007b2:	e8 19 00 00 00       	call   8007d0 <exit>
}
  8007b7:	90                   	nop
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007c0:	83 ec 0c             	sub    $0xc,%esp
  8007c3:	6a 00                	push   $0x0
  8007c5:	e8 4a 14 00 00       	call   801c14 <sys_destroy_env>
  8007ca:	83 c4 10             	add    $0x10,%esp
}
  8007cd:	90                   	nop
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <exit>:

void
exit(void)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007d6:	e8 9f 14 00 00       	call   801c7a <sys_exit_env>
}
  8007db:	90                   	nop
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007ed:	a1 24 30 80 00       	mov    0x803024,%eax
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	74 16                	je     80080c <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007f6:	a1 24 30 80 00       	mov    0x803024,%eax
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	50                   	push   %eax
  8007ff:	68 a4 24 80 00       	push   $0x8024a4
  800804:	e8 92 02 00 00       	call   800a9b <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80080c:	a1 00 30 80 00       	mov    0x803000,%eax
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 08             	pushl  0x8(%ebp)
  800817:	50                   	push   %eax
  800818:	68 a9 24 80 00       	push   $0x8024a9
  80081d:	e8 79 02 00 00       	call   800a9b <cprintf>
  800822:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 f4             	pushl  -0xc(%ebp)
  80082e:	50                   	push   %eax
  80082f:	e8 fc 01 00 00       	call   800a30 <vcprintf>
  800834:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	6a 00                	push   $0x0
  80083c:	68 c5 24 80 00       	push   $0x8024c5
  800841:	e8 ea 01 00 00       	call   800a30 <vcprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800849:	e8 82 ff ff ff       	call   8007d0 <exit>

	// should not return here
	while (1) ;
  80084e:	eb fe                	jmp    80084e <_panic+0x70>

00800850 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800856:	a1 04 30 80 00       	mov    0x803004,%eax
  80085b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800861:	8b 45 0c             	mov    0xc(%ebp),%eax
  800864:	39 c2                	cmp    %eax,%edx
  800866:	74 14                	je     80087c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800868:	83 ec 04             	sub    $0x4,%esp
  80086b:	68 c8 24 80 00       	push   $0x8024c8
  800870:	6a 26                	push   $0x26
  800872:	68 14 25 80 00       	push   $0x802514
  800877:	e8 62 ff ff ff       	call   8007de <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80087c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800883:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80088a:	e9 c5 00 00 00       	jmp    800954 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80088f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800892:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	01 d0                	add    %edx,%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	85 c0                	test   %eax,%eax
  8008a2:	75 08                	jne    8008ac <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8008a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008a7:	e9 a5 00 00 00       	jmp    800951 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8008ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8008ba:	eb 69                	jmp    800925 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8008bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8008c1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ca:	89 d0                	mov    %edx,%eax
  8008cc:	01 c0                	add    %eax,%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	c1 e0 03             	shl    $0x3,%eax
  8008d3:	01 c8                	add    %ecx,%eax
  8008d5:	8a 40 04             	mov    0x4(%eax),%al
  8008d8:	84 c0                	test   %al,%al
  8008da:	75 46                	jne    800922 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8008e1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	01 c0                	add    %eax,%eax
  8008ee:	01 d0                	add    %edx,%eax
  8008f0:	c1 e0 03             	shl    $0x3,%eax
  8008f3:	01 c8                	add    %ecx,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800902:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800907:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	01 c8                	add    %ecx,%eax
  800913:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800915:	39 c2                	cmp    %eax,%edx
  800917:	75 09                	jne    800922 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800919:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800920:	eb 15                	jmp    800937 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800922:	ff 45 e8             	incl   -0x18(%ebp)
  800925:	a1 04 30 80 00       	mov    0x803004,%eax
  80092a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800933:	39 c2                	cmp    %eax,%edx
  800935:	77 85                	ja     8008bc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800937:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80093b:	75 14                	jne    800951 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 20 25 80 00       	push   $0x802520
  800945:	6a 3a                	push   $0x3a
  800947:	68 14 25 80 00       	push   $0x802514
  80094c:	e8 8d fe ff ff       	call   8007de <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800951:	ff 45 f0             	incl   -0x10(%ebp)
  800954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800957:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80095a:	0f 8c 2f ff ff ff    	jl     80088f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800960:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800967:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80096e:	eb 26                	jmp    800996 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800970:	a1 04 30 80 00       	mov    0x803004,%eax
  800975:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80097b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	c1 e0 03             	shl    $0x3,%eax
  800987:	01 c8                	add    %ecx,%eax
  800989:	8a 40 04             	mov    0x4(%eax),%al
  80098c:	3c 01                	cmp    $0x1,%al
  80098e:	75 03                	jne    800993 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800990:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800993:	ff 45 e0             	incl   -0x20(%ebp)
  800996:	a1 04 30 80 00       	mov    0x803004,%eax
  80099b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	77 c8                	ja     800970 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ae:	74 14                	je     8009c4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8009b0:	83 ec 04             	sub    $0x4,%esp
  8009b3:	68 74 25 80 00       	push   $0x802574
  8009b8:	6a 44                	push   $0x44
  8009ba:	68 14 25 80 00       	push   $0x802514
  8009bf:	e8 1a fe ff ff       	call   8007de <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009c4:	90                   	nop
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	8d 48 01             	lea    0x1(%eax),%ecx
  8009d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d8:	89 0a                	mov    %ecx,(%edx)
  8009da:	8b 55 08             	mov    0x8(%ebp),%edx
  8009dd:	88 d1                	mov    %dl,%cl
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e9:	8b 00                	mov    (%eax),%eax
  8009eb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009f0:	75 2c                	jne    800a1e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009f2:	a0 08 30 80 00       	mov    0x803008,%al
  8009f7:	0f b6 c0             	movzbl %al,%eax
  8009fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fd:	8b 12                	mov    (%edx),%edx
  8009ff:	89 d1                	mov    %edx,%ecx
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	83 c2 08             	add    $0x8,%edx
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	50                   	push   %eax
  800a0b:	51                   	push   %ecx
  800a0c:	52                   	push   %edx
  800a0d:	e8 78 0f 00 00       	call   80198a <sys_cputs>
  800a12:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	8b 40 04             	mov    0x4(%eax),%eax
  800a24:	8d 50 01             	lea    0x1(%eax),%edx
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a2d:	90                   	nop
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a39:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a40:	00 00 00 
	b.cnt = 0;
  800a43:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a4a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a59:	50                   	push   %eax
  800a5a:	68 c7 09 80 00       	push   $0x8009c7
  800a5f:	e8 11 02 00 00       	call   800c75 <vprintfmt>
  800a64:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a67:	a0 08 30 80 00       	mov    0x803008,%al
  800a6c:	0f b6 c0             	movzbl %al,%eax
  800a6f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	50                   	push   %eax
  800a79:	52                   	push   %edx
  800a7a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a80:	83 c0 08             	add    $0x8,%eax
  800a83:	50                   	push   %eax
  800a84:	e8 01 0f 00 00       	call   80198a <sys_cputs>
  800a89:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a8c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800a93:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a99:	c9                   	leave  
  800a9a:	c3                   	ret    

00800a9b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800aa1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 73 ff ff ff       	call   800a30 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800ace:	e8 f9 0e 00 00       	call   8019cc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ad3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae2:	50                   	push   %eax
  800ae3:	e8 48 ff ff ff       	call   800a30 <vcprintf>
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800aee:	e8 f3 0e 00 00       	call   8019e6 <sys_unlock_cons>
	return cnt;
  800af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	53                   	push   %ebx
  800afc:	83 ec 14             	sub    $0x14,%esp
  800aff:	8b 45 10             	mov    0x10(%ebp),%eax
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b05:	8b 45 14             	mov    0x14(%ebp),%eax
  800b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b0b:	8b 45 18             	mov    0x18(%ebp),%eax
  800b0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b13:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b16:	77 55                	ja     800b6d <printnum+0x75>
  800b18:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b1b:	72 05                	jb     800b22 <printnum+0x2a>
  800b1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b20:	77 4b                	ja     800b6d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b22:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b25:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b28:	8b 45 18             	mov    0x18(%ebp),%eax
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	ff 75 f4             	pushl  -0xc(%ebp)
  800b35:	ff 75 f0             	pushl  -0x10(%ebp)
  800b38:	e8 c3 14 00 00       	call   802000 <__udivdi3>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	83 ec 04             	sub    $0x4,%esp
  800b43:	ff 75 20             	pushl  0x20(%ebp)
  800b46:	53                   	push   %ebx
  800b47:	ff 75 18             	pushl  0x18(%ebp)
  800b4a:	52                   	push   %edx
  800b4b:	50                   	push   %eax
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	ff 75 08             	pushl  0x8(%ebp)
  800b52:	e8 a1 ff ff ff       	call   800af8 <printnum>
  800b57:	83 c4 20             	add    $0x20,%esp
  800b5a:	eb 1a                	jmp    800b76 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	ff 75 20             	pushl  0x20(%ebp)
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b6d:	ff 4d 1c             	decl   0x1c(%ebp)
  800b70:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b74:	7f e6                	jg     800b5c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b76:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	53                   	push   %ebx
  800b85:	51                   	push   %ecx
  800b86:	52                   	push   %edx
  800b87:	50                   	push   %eax
  800b88:	e8 83 15 00 00       	call   802110 <__umoddi3>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	05 d4 27 80 00       	add    $0x8027d4,%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	0f be c0             	movsbl %al,%eax
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	50                   	push   %eax
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
}
  800ba9:	90                   	nop
  800baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 40                	jmp    800c14 <getuint+0x65>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1e                	je     800bf8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	eb 1c                	jmp    800c14 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 50 04             	lea    0x4(%eax),%edx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	89 10                	mov    %edx,(%eax)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	83 e8 04             	sub    $0x4,%eax
  800c0d:	8b 00                	mov    (%eax),%eax
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c19:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1d:	7e 1c                	jle    800c3b <getint+0x25>
		return va_arg(*ap, long long);
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 00                	mov    (%eax),%eax
  800c24:	8d 50 08             	lea    0x8(%eax),%edx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 10                	mov    %edx,(%eax)
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	83 e8 08             	sub    $0x8,%eax
  800c34:	8b 50 04             	mov    0x4(%eax),%edx
  800c37:	8b 00                	mov    (%eax),%eax
  800c39:	eb 38                	jmp    800c73 <getint+0x5d>
	else if (lflag)
  800c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3f:	74 1a                	je     800c5b <getint+0x45>
		return va_arg(*ap, long);
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	8d 50 04             	lea    0x4(%eax),%edx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 10                	mov    %edx,(%eax)
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	99                   	cltd   
  800c59:	eb 18                	jmp    800c73 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	8d 50 04             	lea    0x4(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 10                	mov    %edx,(%eax)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	99                   	cltd   
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c7d:	eb 17                	jmp    800c96 <vprintfmt+0x21>
			if (ch == '\0')
  800c7f:	85 db                	test   %ebx,%ebx
  800c81:	0f 84 c1 03 00 00    	je     801048 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	53                   	push   %ebx
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c96:	8b 45 10             	mov    0x10(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	0f b6 d8             	movzbl %al,%ebx
  800ca4:	83 fb 25             	cmp    $0x25,%ebx
  800ca7:	75 d6                	jne    800c7f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ca9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cb4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cbb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800cc2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	8d 50 01             	lea    0x1(%eax),%edx
  800ccf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d8             	movzbl %al,%ebx
  800cd7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cda:	83 f8 5b             	cmp    $0x5b,%eax
  800cdd:	0f 87 3d 03 00 00    	ja     801020 <vprintfmt+0x3ab>
  800ce3:	8b 04 85 f8 27 80 00 	mov    0x8027f8(,%eax,4),%eax
  800cea:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cec:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cf0:	eb d7                	jmp    800cc9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cf2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cf6:	eb d1                	jmp    800cc9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	c1 e0 02             	shl    $0x2,%eax
  800d07:	01 d0                	add    %edx,%eax
  800d09:	01 c0                	add    %eax,%eax
  800d0b:	01 d8                	add    %ebx,%eax
  800d0d:	83 e8 30             	sub    $0x30,%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d1b:	83 fb 2f             	cmp    $0x2f,%ebx
  800d1e:	7e 3e                	jle    800d5e <vprintfmt+0xe9>
  800d20:	83 fb 39             	cmp    $0x39,%ebx
  800d23:	7f 39                	jg     800d5e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d25:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d28:	eb d5                	jmp    800cff <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2d:	83 c0 04             	add    $0x4,%eax
  800d30:	89 45 14             	mov    %eax,0x14(%ebp)
  800d33:	8b 45 14             	mov    0x14(%ebp),%eax
  800d36:	83 e8 04             	sub    $0x4,%eax
  800d39:	8b 00                	mov    (%eax),%eax
  800d3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d3e:	eb 1f                	jmp    800d5f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d44:	79 83                	jns    800cc9 <vprintfmt+0x54>
				width = 0;
  800d46:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d4d:	e9 77 ff ff ff       	jmp    800cc9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d52:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d59:	e9 6b ff ff ff       	jmp    800cc9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d5e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d63:	0f 89 60 ff ff ff    	jns    800cc9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d76:	e9 4e ff ff ff       	jmp    800cc9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d7b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d7e:	e9 46 ff ff ff       	jmp    800cc9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d83:	8b 45 14             	mov    0x14(%ebp),%eax
  800d86:	83 c0 04             	add    $0x4,%eax
  800d89:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8f:	83 e8 04             	sub    $0x4,%eax
  800d92:	8b 00                	mov    (%eax),%eax
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	ff 75 0c             	pushl  0xc(%ebp)
  800d9a:	50                   	push   %eax
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	ff d0                	call   *%eax
  800da0:	83 c4 10             	add    $0x10,%esp
			break;
  800da3:	e9 9b 02 00 00       	jmp    801043 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	83 c0 04             	add    $0x4,%eax
  800dae:	89 45 14             	mov    %eax,0x14(%ebp)
  800db1:	8b 45 14             	mov    0x14(%ebp),%eax
  800db4:	83 e8 04             	sub    $0x4,%eax
  800db7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800db9:	85 db                	test   %ebx,%ebx
  800dbb:	79 02                	jns    800dbf <vprintfmt+0x14a>
				err = -err;
  800dbd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dbf:	83 fb 64             	cmp    $0x64,%ebx
  800dc2:	7f 0b                	jg     800dcf <vprintfmt+0x15a>
  800dc4:	8b 34 9d 40 26 80 00 	mov    0x802640(,%ebx,4),%esi
  800dcb:	85 f6                	test   %esi,%esi
  800dcd:	75 19                	jne    800de8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800dcf:	53                   	push   %ebx
  800dd0:	68 e5 27 80 00       	push   $0x8027e5
  800dd5:	ff 75 0c             	pushl  0xc(%ebp)
  800dd8:	ff 75 08             	pushl  0x8(%ebp)
  800ddb:	e8 70 02 00 00       	call   801050 <printfmt>
  800de0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de3:	e9 5b 02 00 00       	jmp    801043 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de8:	56                   	push   %esi
  800de9:	68 ee 27 80 00       	push   $0x8027ee
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 57 02 00 00       	call   801050 <printfmt>
  800df9:	83 c4 10             	add    $0x10,%esp
			break;
  800dfc:	e9 42 02 00 00       	jmp    801043 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e01:	8b 45 14             	mov    0x14(%ebp),%eax
  800e04:	83 c0 04             	add    $0x4,%eax
  800e07:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0d:	83 e8 04             	sub    $0x4,%eax
  800e10:	8b 30                	mov    (%eax),%esi
  800e12:	85 f6                	test   %esi,%esi
  800e14:	75 05                	jne    800e1b <vprintfmt+0x1a6>
				p = "(null)";
  800e16:	be f1 27 80 00       	mov    $0x8027f1,%esi
			if (width > 0 && padc != '-')
  800e1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1f:	7e 6d                	jle    800e8e <vprintfmt+0x219>
  800e21:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e25:	74 67                	je     800e8e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	50                   	push   %eax
  800e2e:	56                   	push   %esi
  800e2f:	e8 1e 03 00 00       	call   801152 <strnlen>
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e3a:	eb 16                	jmp    800e52 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e3c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	50                   	push   %eax
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e56:	7f e4                	jg     800e3c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e58:	eb 34                	jmp    800e8e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e5e:	74 1c                	je     800e7c <vprintfmt+0x207>
  800e60:	83 fb 1f             	cmp    $0x1f,%ebx
  800e63:	7e 05                	jle    800e6a <vprintfmt+0x1f5>
  800e65:	83 fb 7e             	cmp    $0x7e,%ebx
  800e68:	7e 12                	jle    800e7c <vprintfmt+0x207>
					putch('?', putdat);
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	6a 3f                	push   $0x3f
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	ff d0                	call   *%eax
  800e77:	83 c4 10             	add    $0x10,%esp
  800e7a:	eb 0f                	jmp    800e8b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	ff 75 0c             	pushl  0xc(%ebp)
  800e82:	53                   	push   %ebx
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	ff d0                	call   *%eax
  800e88:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e8b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8e:	89 f0                	mov    %esi,%eax
  800e90:	8d 70 01             	lea    0x1(%eax),%esi
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	0f be d8             	movsbl %al,%ebx
  800e98:	85 db                	test   %ebx,%ebx
  800e9a:	74 24                	je     800ec0 <vprintfmt+0x24b>
  800e9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea0:	78 b8                	js     800e5a <vprintfmt+0x1e5>
  800ea2:	ff 4d e0             	decl   -0x20(%ebp)
  800ea5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ea9:	79 af                	jns    800e5a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eab:	eb 13                	jmp    800ec0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	6a 20                	push   $0x20
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ebd:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec4:	7f e7                	jg     800ead <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ec6:	e9 78 01 00 00       	jmp    801043 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ecb:	83 ec 08             	sub    $0x8,%esp
  800ece:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed4:	50                   	push   %eax
  800ed5:	e8 3c fd ff ff       	call   800c16 <getint>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	85 d2                	test   %edx,%edx
  800eeb:	79 23                	jns    800f10 <vprintfmt+0x29b>
				putch('-', putdat);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 0c             	pushl  0xc(%ebp)
  800ef3:	6a 2d                	push   $0x2d
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	ff d0                	call   *%eax
  800efa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f03:	f7 d8                	neg    %eax
  800f05:	83 d2 00             	adc    $0x0,%edx
  800f08:	f7 da                	neg    %edx
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f17:	e9 bc 00 00 00       	jmp    800fd8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f1c:	83 ec 08             	sub    $0x8,%esp
  800f1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800f22:	8d 45 14             	lea    0x14(%ebp),%eax
  800f25:	50                   	push   %eax
  800f26:	e8 84 fc ff ff       	call   800baf <getuint>
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f3b:	e9 98 00 00 00       	jmp    800fd8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	6a 58                	push   $0x58
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	6a 58                	push   $0x58
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	ff d0                	call   *%eax
  800f5d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	6a 58                	push   $0x58
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	ff d0                	call   *%eax
  800f6d:	83 c4 10             	add    $0x10,%esp
			break;
  800f70:	e9 ce 00 00 00       	jmp    801043 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f75:	83 ec 08             	sub    $0x8,%esp
  800f78:	ff 75 0c             	pushl  0xc(%ebp)
  800f7b:	6a 30                	push   $0x30
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	ff d0                	call   *%eax
  800f82:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	ff 75 0c             	pushl  0xc(%ebp)
  800f8b:	6a 78                	push   $0x78
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	ff d0                	call   *%eax
  800f92:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	83 c0 04             	add    $0x4,%eax
  800f9b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	83 e8 04             	sub    $0x4,%eax
  800fa4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fb0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800fb7:	eb 1f                	jmp    800fd8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 e8             	pushl  -0x18(%ebp)
  800fbf:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc2:	50                   	push   %eax
  800fc3:	e8 e7 fb ff ff       	call   800baf <getuint>
  800fc8:	83 c4 10             	add    $0x10,%esp
  800fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fdf:	83 ec 04             	sub    $0x4,%esp
  800fe2:	52                   	push   %edx
  800fe3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe6:	50                   	push   %eax
  800fe7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fea:	ff 75 f0             	pushl  -0x10(%ebp)
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 00 fb ff ff       	call   800af8 <printnum>
  800ff8:	83 c4 20             	add    $0x20,%esp
			break;
  800ffb:	eb 46                	jmp    801043 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	ff 75 0c             	pushl  0xc(%ebp)
  801003:	53                   	push   %ebx
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	ff d0                	call   *%eax
  801009:	83 c4 10             	add    $0x10,%esp
			break;
  80100c:	eb 35                	jmp    801043 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80100e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  801015:	eb 2c                	jmp    801043 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801017:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80101e:	eb 23                	jmp    801043 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	6a 25                	push   $0x25
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801030:	ff 4d 10             	decl   0x10(%ebp)
  801033:	eb 03                	jmp    801038 <vprintfmt+0x3c3>
  801035:	ff 4d 10             	decl   0x10(%ebp)
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	48                   	dec    %eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 25                	cmp    $0x25,%al
  801040:	75 f3                	jne    801035 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801042:	90                   	nop
		}
	}
  801043:	e9 35 fc ff ff       	jmp    800c7d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801048:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801049:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801056:	8d 45 10             	lea    0x10(%ebp),%eax
  801059:	83 c0 04             	add    $0x4,%eax
  80105c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80105f:	8b 45 10             	mov    0x10(%ebp),%eax
  801062:	ff 75 f4             	pushl  -0xc(%ebp)
  801065:	50                   	push   %eax
  801066:	ff 75 0c             	pushl  0xc(%ebp)
  801069:	ff 75 08             	pushl  0x8(%ebp)
  80106c:	e8 04 fc ff ff       	call   800c75 <vprintfmt>
  801071:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801074:	90                   	nop
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	8b 40 08             	mov    0x8(%eax),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108c:	8b 10                	mov    (%eax),%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	8b 40 04             	mov    0x4(%eax),%eax
  801094:	39 c2                	cmp    %eax,%edx
  801096:	73 12                	jae    8010aa <sprintputch+0x33>
		*b->buf++ = ch;
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	89 0a                	mov    %ecx,(%edx)
  8010a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a8:	88 10                	mov    %dl,(%eax)
}
  8010aa:	90                   	nop
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	01 d0                	add    %edx,%eax
  8010c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d2:	74 06                	je     8010da <vsnprintf+0x2d>
  8010d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d8:	7f 07                	jg     8010e1 <vsnprintf+0x34>
		return -E_INVAL;
  8010da:	b8 03 00 00 00       	mov    $0x3,%eax
  8010df:	eb 20                	jmp    801101 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e1:	ff 75 14             	pushl  0x14(%ebp)
  8010e4:	ff 75 10             	pushl  0x10(%ebp)
  8010e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ea:	50                   	push   %eax
  8010eb:	68 77 10 80 00       	push   $0x801077
  8010f0:	e8 80 fb ff ff       	call   800c75 <vprintfmt>
  8010f5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801109:	8d 45 10             	lea    0x10(%ebp),%eax
  80110c:	83 c0 04             	add    $0x4,%eax
  80110f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	ff 75 f4             	pushl  -0xc(%ebp)
  801118:	50                   	push   %eax
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	ff 75 08             	pushl  0x8(%ebp)
  80111f:	e8 89 ff ff ff       	call   8010ad <vsnprintf>
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80112a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113c:	eb 06                	jmp    801144 <strlen+0x15>
		n++;
  80113e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801141:	ff 45 08             	incl   0x8(%ebp)
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	84 c0                	test   %al,%al
  80114b:	75 f1                	jne    80113e <strlen+0xf>
		n++;
	return n;
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 09                	jmp    80116a <strnlen+0x18>
		n++;
  801161:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	ff 4d 0c             	decl   0xc(%ebp)
  80116a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116e:	74 09                	je     801179 <strnlen+0x27>
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	84 c0                	test   %al,%al
  801177:	75 e8                	jne    801161 <strnlen+0xf>
		n++;
	return n;
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80118a:	90                   	nop
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8d 50 01             	lea    0x1(%eax),%edx
  801191:	89 55 08             	mov    %edx,0x8(%ebp)
  801194:	8b 55 0c             	mov    0xc(%ebp),%edx
  801197:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80119d:	8a 12                	mov    (%edx),%dl
  80119f:	88 10                	mov    %dl,(%eax)
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 e4                	jne    80118b <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011bf:	eb 1f                	jmp    8011e0 <strncpy+0x34>
		*dst++ = *src;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8d 50 01             	lea    0x1(%eax),%edx
  8011c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cd:	8a 12                	mov    (%edx),%dl
  8011cf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 03                	je     8011dd <strncpy+0x31>
			src++;
  8011da:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011dd:	ff 45 fc             	incl   -0x4(%ebp)
  8011e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e6:	72 d9                	jb     8011c1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fd:	74 30                	je     80122f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011ff:	eb 16                	jmp    801217 <strlcpy+0x2a>
			*dst++ = *src++;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8d 50 01             	lea    0x1(%eax),%edx
  801207:	89 55 08             	mov    %edx,0x8(%ebp)
  80120a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801210:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801213:	8a 12                	mov    (%edx),%dl
  801215:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801217:	ff 4d 10             	decl   0x10(%ebp)
  80121a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121e:	74 09                	je     801229 <strlcpy+0x3c>
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	84 c0                	test   %al,%al
  801227:	75 d8                	jne    801201 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80122f:	8b 55 08             	mov    0x8(%ebp),%edx
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80123e:	eb 06                	jmp    801246 <strcmp+0xb>
		p++, q++;
  801240:	ff 45 08             	incl   0x8(%ebp)
  801243:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	74 0e                	je     80125d <strcmp+0x22>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 10                	mov    (%eax),%dl
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	38 c2                	cmp    %al,%dl
  80125b:	74 e3                	je     801240 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f b6 d0             	movzbl %al,%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	0f b6 c0             	movzbl %al,%eax
  80126d:	29 c2                	sub    %eax,%edx
  80126f:	89 d0                	mov    %edx,%eax
}
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    

00801273 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801276:	eb 09                	jmp    801281 <strncmp+0xe>
		n--, p++, q++;
  801278:	ff 4d 10             	decl   0x10(%ebp)
  80127b:	ff 45 08             	incl   0x8(%ebp)
  80127e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801285:	74 17                	je     80129e <strncmp+0x2b>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	84 c0                	test   %al,%al
  80128e:	74 0e                	je     80129e <strncmp+0x2b>
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 10                	mov    (%eax),%dl
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	38 c2                	cmp    %al,%dl
  80129c:	74 da                	je     801278 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80129e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a2:	75 07                	jne    8012ab <strncmp+0x38>
		return 0;
  8012a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a9:	eb 14                	jmp    8012bf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f b6 d0             	movzbl %al,%edx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	0f b6 c0             	movzbl %al,%eax
  8012bb:	29 c2                	sub    %eax,%edx
  8012bd:	89 d0                	mov    %edx,%eax
}
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012cd:	eb 12                	jmp    8012e1 <strchr+0x20>
		if (*s == c)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012d7:	75 05                	jne    8012de <strchr+0x1d>
			return (char *) s;
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	eb 11                	jmp    8012ef <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012de:	ff 45 08             	incl   0x8(%ebp)
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	84 c0                	test   %al,%al
  8012e8:	75 e5                	jne    8012cf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fd:	eb 0d                	jmp    80130c <strfind+0x1b>
		if (*s == c)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801307:	74 0e                	je     801317 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801309:	ff 45 08             	incl   0x8(%ebp)
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8a 00                	mov    (%eax),%al
  801311:	84 c0                	test   %al,%al
  801313:	75 ea                	jne    8012ff <strfind+0xe>
  801315:	eb 01                	jmp    801318 <strfind+0x27>
		if (*s == c)
			break;
  801317:	90                   	nop
	return (char *) s;
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80132f:	eb 0e                	jmp    80133f <memset+0x22>
		*p++ = c;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80133f:	ff 4d f8             	decl   -0x8(%ebp)
  801342:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801346:	79 e9                	jns    801331 <memset+0x14>
		*p++ = c;

	return v;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80135f:	eb 16                	jmp    801377 <memcpy+0x2a>
		*d++ = *s++;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801370:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801373:	8a 12                	mov    (%edx),%dl
  801375:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137d:	89 55 10             	mov    %edx,0x10(%ebp)
  801380:	85 c0                	test   %eax,%eax
  801382:	75 dd                	jne    801361 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80139b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013a1:	73 50                	jae    8013f3 <memmove+0x6a>
  8013a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ae:	76 43                	jbe    8013f3 <memmove+0x6a>
		s += n;
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013bc:	eb 10                	jmp    8013ce <memmove+0x45>
			*--d = *--s;
  8013be:	ff 4d f8             	decl   -0x8(%ebp)
  8013c1:	ff 4d fc             	decl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	8a 10                	mov    (%eax),%dl
  8013c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	75 e3                	jne    8013be <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013db:	eb 23                	jmp    801400 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	8d 50 01             	lea    0x1(%eax),%edx
  8013e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ec:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013ef:	8a 12                	mov    (%edx),%dl
  8013f1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	75 dd                	jne    8013dd <memmove+0x54>
			*d++ = *s++;

	return dst;
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801417:	eb 2a                	jmp    801443 <memcmp+0x3e>
		if (*s1 != *s2)
  801419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141c:	8a 10                	mov    (%eax),%dl
  80141e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	38 c2                	cmp    %al,%dl
  801425:	74 16                	je     80143d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	0f b6 c0             	movzbl %al,%eax
  801437:	29 c2                	sub    %eax,%edx
  801439:	89 d0                	mov    %edx,%eax
  80143b:	eb 18                	jmp    801455 <memcmp+0x50>
		s1++, s2++;
  80143d:	ff 45 fc             	incl   -0x4(%ebp)
  801440:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801443:	8b 45 10             	mov    0x10(%ebp),%eax
  801446:	8d 50 ff             	lea    -0x1(%eax),%edx
  801449:	89 55 10             	mov    %edx,0x10(%ebp)
  80144c:	85 c0                	test   %eax,%eax
  80144e:	75 c9                	jne    801419 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801468:	eb 15                	jmp    80147f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	0f b6 d0             	movzbl %al,%edx
  801472:	8b 45 0c             	mov    0xc(%ebp),%eax
  801475:	0f b6 c0             	movzbl %al,%eax
  801478:	39 c2                	cmp    %eax,%edx
  80147a:	74 0d                	je     801489 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801485:	72 e3                	jb     80146a <memfind+0x13>
  801487:	eb 01                	jmp    80148a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801489:	90                   	nop
	return (void *) s;
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a3:	eb 03                	jmp    8014a8 <strtol+0x19>
		s++;
  8014a5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8a 00                	mov    (%eax),%al
  8014ad:	3c 20                	cmp    $0x20,%al
  8014af:	74 f4                	je     8014a5 <strtol+0x16>
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 09                	cmp    $0x9,%al
  8014b8:	74 eb                	je     8014a5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 2b                	cmp    $0x2b,%al
  8014c1:	75 05                	jne    8014c8 <strtol+0x39>
		s++;
  8014c3:	ff 45 08             	incl   0x8(%ebp)
  8014c6:	eb 13                	jmp    8014db <strtol+0x4c>
	else if (*s == '-')
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	3c 2d                	cmp    $0x2d,%al
  8014cf:	75 0a                	jne    8014db <strtol+0x4c>
		s++, neg = 1;
  8014d1:	ff 45 08             	incl   0x8(%ebp)
  8014d4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014df:	74 06                	je     8014e7 <strtol+0x58>
  8014e1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014e5:	75 20                	jne    801507 <strtol+0x78>
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3c 30                	cmp    $0x30,%al
  8014ee:	75 17                	jne    801507 <strtol+0x78>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	40                   	inc    %eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 78                	cmp    $0x78,%al
  8014f8:	75 0d                	jne    801507 <strtol+0x78>
		s += 2, base = 16;
  8014fa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014fe:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801505:	eb 28                	jmp    80152f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	75 15                	jne    801522 <strtol+0x93>
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 00                	mov    (%eax),%al
  801512:	3c 30                	cmp    $0x30,%al
  801514:	75 0c                	jne    801522 <strtol+0x93>
		s++, base = 8;
  801516:	ff 45 08             	incl   0x8(%ebp)
  801519:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801520:	eb 0d                	jmp    80152f <strtol+0xa0>
	else if (base == 0)
  801522:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801526:	75 07                	jne    80152f <strtol+0xa0>
		base = 10;
  801528:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	3c 2f                	cmp    $0x2f,%al
  801536:	7e 19                	jle    801551 <strtol+0xc2>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	3c 39                	cmp    $0x39,%al
  80153f:	7f 10                	jg     801551 <strtol+0xc2>
			dig = *s - '0';
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	83 e8 30             	sub    $0x30,%eax
  80154c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80154f:	eb 42                	jmp    801593 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	3c 60                	cmp    $0x60,%al
  801558:	7e 19                	jle    801573 <strtol+0xe4>
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	3c 7a                	cmp    $0x7a,%al
  801561:	7f 10                	jg     801573 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	0f be c0             	movsbl %al,%eax
  80156b:	83 e8 57             	sub    $0x57,%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801571:	eb 20                	jmp    801593 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	3c 40                	cmp    $0x40,%al
  80157a:	7e 39                	jle    8015b5 <strtol+0x126>
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	3c 5a                	cmp    $0x5a,%al
  801583:	7f 30                	jg     8015b5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	0f be c0             	movsbl %al,%eax
  80158d:	83 e8 37             	sub    $0x37,%eax
  801590:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	3b 45 10             	cmp    0x10(%ebp),%eax
  801599:	7d 19                	jge    8015b4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80159b:	ff 45 08             	incl   0x8(%ebp)
  80159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015af:	e9 7b ff ff ff       	jmp    80152f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015b4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 08                	je     8015c3 <strtol+0x134>
		*endptr = (char *) s;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015c7:	74 07                	je     8015d0 <strtol+0x141>
  8015c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cc:	f7 d8                	neg    %eax
  8015ce:	eb 03                	jmp    8015d3 <strtol+0x144>
  8015d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <ltostr>:

void
ltostr(long value, char *str)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ed:	79 13                	jns    801602 <ltostr+0x2d>
	{
		neg = 1;
  8015ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015fc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015ff:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80160a:	99                   	cltd   
  80160b:	f7 f9                	idiv   %ecx
  80160d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801613:	8d 50 01             	lea    0x1(%eax),%edx
  801616:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801619:	89 c2                	mov    %eax,%edx
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801623:	83 c2 30             	add    $0x30,%edx
  801626:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801628:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801630:	f7 e9                	imul   %ecx
  801632:	c1 fa 02             	sar    $0x2,%edx
  801635:	89 c8                	mov    %ecx,%eax
  801637:	c1 f8 1f             	sar    $0x1f,%eax
  80163a:	29 c2                	sub    %eax,%edx
  80163c:	89 d0                	mov    %edx,%eax
  80163e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801641:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801645:	75 bb                	jne    801602 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801647:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801651:	48                   	dec    %eax
  801652:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801655:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801659:	74 3d                	je     801698 <ltostr+0xc3>
		start = 1 ;
  80165b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801662:	eb 34                	jmp    801698 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166a:	01 d0                	add    %edx,%eax
  80166c:	8a 00                	mov    (%eax),%al
  80166e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	01 c2                	add    %eax,%edx
  801679:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	01 c8                	add    %ecx,%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801685:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	01 c2                	add    %eax,%edx
  80168d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801690:	88 02                	mov    %al,(%edx)
		start++ ;
  801692:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801695:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80169e:	7c c4                	jl     801664 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a6:	01 d0                	add    %edx,%eax
  8016a8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016ab:	90                   	nop
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	e8 73 fa ff ff       	call   80112f <strlen>
  8016bc:	83 c4 04             	add    $0x4,%esp
  8016bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	e8 65 fa ff ff       	call   80112f <strlen>
  8016ca:	83 c4 04             	add    $0x4,%esp
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016de:	eb 17                	jmp    8016f7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e6:	01 c2                	add    %eax,%edx
  8016e8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	01 c8                	add    %ecx,%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016f4:	ff 45 fc             	incl   -0x4(%ebp)
  8016f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016fd:	7c e1                	jl     8016e0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801706:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80170d:	eb 1f                	jmp    80172e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	8d 50 01             	lea    0x1(%eax),%edx
  801715:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801718:	89 c2                	mov    %eax,%edx
  80171a:	8b 45 10             	mov    0x10(%ebp),%eax
  80171d:	01 c2                	add    %eax,%edx
  80171f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801722:	8b 45 0c             	mov    0xc(%ebp),%eax
  801725:	01 c8                	add    %ecx,%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80172b:	ff 45 f8             	incl   -0x8(%ebp)
  80172e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801731:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801734:	7c d9                	jl     80170f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801736:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	01 d0                	add    %edx,%eax
  80173e:	c6 00 00             	movb   $0x0,(%eax)
}
  801741:	90                   	nop
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801750:	8b 45 14             	mov    0x14(%ebp),%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175c:	8b 45 10             	mov    0x10(%ebp),%eax
  80175f:	01 d0                	add    %edx,%eax
  801761:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801767:	eb 0c                	jmp    801775 <strsplit+0x31>
			*string++ = 0;
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8d 50 01             	lea    0x1(%eax),%edx
  80176f:	89 55 08             	mov    %edx,0x8(%ebp)
  801772:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 18                	je     801796 <strsplit+0x52>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	0f be c0             	movsbl %al,%eax
  801786:	50                   	push   %eax
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	e8 32 fb ff ff       	call   8012c1 <strchr>
  80178f:	83 c4 08             	add    $0x8,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	75 d3                	jne    801769 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	84 c0                	test   %al,%al
  80179d:	74 5a                	je     8017f9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80179f:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a2:	8b 00                	mov    (%eax),%eax
  8017a4:	83 f8 0f             	cmp    $0xf,%eax
  8017a7:	75 07                	jne    8017b0 <strsplit+0x6c>
		{
			return 0;
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ae:	eb 66                	jmp    801816 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	8b 00                	mov    (%eax),%eax
  8017b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8017b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8017bb:	89 0a                	mov    %ecx,(%edx)
  8017bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c7:	01 c2                	add    %eax,%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017ce:	eb 03                	jmp    8017d3 <strsplit+0x8f>
			string++;
  8017d0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	84 c0                	test   %al,%al
  8017da:	74 8b                	je     801767 <strsplit+0x23>
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8a 00                	mov    (%eax),%al
  8017e1:	0f be c0             	movsbl %al,%eax
  8017e4:	50                   	push   %eax
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	e8 d4 fa ff ff       	call   8012c1 <strchr>
  8017ed:	83 c4 08             	add    $0x8,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	74 dc                	je     8017d0 <strsplit+0x8c>
			string++;
	}
  8017f4:	e9 6e ff ff ff       	jmp    801767 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017f9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	01 d0                	add    %edx,%eax
  80180b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801811:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 68 29 80 00       	push   $0x802968
  801826:	68 3f 01 00 00       	push   $0x13f
  80182b:	68 8a 29 80 00       	push   $0x80298a
  801830:	e8 a9 ef ff ff       	call   8007de <_panic>

00801835 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	e8 ef 06 00 00       	call   801f35 <sys_sbrk>
  801846:	83 c4 10             	add    $0x10,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801855:	75 07                	jne    80185e <malloc+0x13>
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
  80185c:	eb 14                	jmp    801872 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 98 29 80 00       	push   $0x802998
  801866:	6a 1b                	push   $0x1b
  801868:	68 bd 29 80 00       	push   $0x8029bd
  80186d:	e8 6c ef ff ff       	call   8007de <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 cc 29 80 00       	push   $0x8029cc
  801882:	6a 29                	push   $0x29
  801884:	68 bd 29 80 00       	push   $0x8029bd
  801889:	e8 50 ef ff ff       	call   8007de <_panic>

0080188e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 18             	sub    $0x18,%esp
  801894:	8b 45 10             	mov    0x10(%ebp),%eax
  801897:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80189a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189e:	75 07                	jne    8018a7 <smalloc+0x19>
  8018a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a5:	eb 14                	jmp    8018bb <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 f0 29 80 00       	push   $0x8029f0
  8018af:	6a 38                	push   $0x38
  8018b1:	68 bd 29 80 00       	push   $0x8029bd
  8018b6:	e8 23 ef ff ff       	call   8007de <_panic>
	return NULL;
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	68 18 2a 80 00       	push   $0x802a18
  8018cb:	6a 43                	push   $0x43
  8018cd:	68 bd 29 80 00       	push   $0x8029bd
  8018d2:	e8 07 ef ff ff       	call   8007de <_panic>

008018d7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 3c 2a 80 00       	push   $0x802a3c
  8018e5:	6a 5b                	push   $0x5b
  8018e7:	68 bd 29 80 00       	push   $0x8029bd
  8018ec:	e8 ed ee ff ff       	call   8007de <_panic>

008018f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 60 2a 80 00       	push   $0x802a60
  8018ff:	6a 72                	push   $0x72
  801901:	68 bd 29 80 00       	push   $0x8029bd
  801906:	e8 d3 ee ff ff       	call   8007de <_panic>

0080190b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	68 86 2a 80 00       	push   $0x802a86
  801919:	6a 7e                	push   $0x7e
  80191b:	68 bd 29 80 00       	push   $0x8029bd
  801920:	e8 b9 ee ff ff       	call   8007de <_panic>

00801925 <shrink>:

}
void shrink(uint32 newSize)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 86 2a 80 00       	push   $0x802a86
  801933:	68 83 00 00 00       	push   $0x83
  801938:	68 bd 29 80 00       	push   $0x8029bd
  80193d:	e8 9c ee ff ff       	call   8007de <_panic>

00801942 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 86 2a 80 00       	push   $0x802a86
  801950:	68 88 00 00 00       	push   $0x88
  801955:	68 bd 29 80 00       	push   $0x8029bd
  80195a:	e8 7f ee ff ff       	call   8007de <_panic>

0080195f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	57                   	push   %edi
  801963:	56                   	push   %esi
  801964:	53                   	push   %ebx
  801965:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801971:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801974:	8b 7d 18             	mov    0x18(%ebp),%edi
  801977:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80197a:	cd 30                	int    $0x30
  80197c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5f                   	pop    %edi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 10             	mov    0x10(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801996:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	52                   	push   %edx
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	50                   	push   %eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	e8 b2 ff ff ff       	call   80195f <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	90                   	nop
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 02                	push   $0x2
  8019c2:	e8 98 ff ff ff       	call   80195f <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 03                	push   $0x3
  8019db:	e8 7f ff ff ff       	call   80195f <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 04                	push   $0x4
  8019f5:	e8 65 ff ff ff       	call   80195f <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	6a 08                	push   $0x8
  801a13:	e8 47 ff ff ff       	call   80195f <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a22:	8b 75 18             	mov    0x18(%ebp),%esi
  801a25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	51                   	push   %ecx
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 09                	push   $0x9
  801a38:	e8 22 ff ff ff       	call   80195f <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 0a                	push   $0xa
  801a5a:	e8 00 ff ff ff       	call   80195f <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	6a 0b                	push   $0xb
  801a75:	e8 e5 fe ff ff       	call   80195f <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 0c                	push   $0xc
  801a8e:	e8 cc fe ff ff       	call   80195f <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 0d                	push   $0xd
  801aa7:	e8 b3 fe ff ff       	call   80195f <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 0e                	push   $0xe
  801ac0:	e8 9a fe ff ff       	call   80195f <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 0f                	push   $0xf
  801ad9:	e8 81 fe ff ff       	call   80195f <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 10                	push   $0x10
  801af3:	e8 67 fe ff ff       	call   80195f <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 11                	push   $0x11
  801b0c:	e8 4e fe ff ff       	call   80195f <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	50                   	push   %eax
  801b30:	6a 01                	push   $0x1
  801b32:	e8 28 fe ff ff       	call   80195f <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 14                	push   $0x14
  801b4c:	e8 0e fe ff ff       	call   80195f <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 15                	push   $0x15
  801b77:	e8 e3 fd ff ff       	call   80195f <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 16                	push   $0x16
  801b94:	e8 c6 fd ff ff       	call   80195f <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	51                   	push   %ecx
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 17                	push   $0x17
  801bb3:	e8 a7 fd ff ff       	call   80195f <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 18                	push   $0x18
  801bd0:	e8 8a fd ff ff       	call   80195f <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 14             	pushl  0x14(%ebp)
  801be5:	ff 75 10             	pushl  0x10(%ebp)
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	50                   	push   %eax
  801bec:	6a 19                	push   $0x19
  801bee:	e8 6c fd ff ff       	call   80195f <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	50                   	push   %eax
  801c07:	6a 1a                	push   $0x1a
  801c09:	e8 51 fd ff ff       	call   80195f <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	50                   	push   %eax
  801c23:	6a 1b                	push   $0x1b
  801c25:	e8 35 fd ff ff       	call   80195f <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 05                	push   $0x5
  801c3e:	e8 1c fd ff ff       	call   80195f <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 06                	push   $0x6
  801c57:	e8 03 fd ff ff       	call   80195f <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 07                	push   $0x7
  801c70:	e8 ea fc ff ff       	call   80195f <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_exit_env>:


void sys_exit_env(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 1c                	push   $0x1c
  801c89:	e8 d1 fc ff ff       	call   80195f <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	90                   	nop
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9d:	8d 50 04             	lea    0x4(%eax),%edx
  801ca0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 1d                	push   $0x1d
  801cad:	e8 ad fc ff ff       	call   80195f <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbe:	89 01                	mov    %eax,(%ecx)
  801cc0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	c9                   	leave  
  801cc7:	c2 04 00             	ret    $0x4

00801cca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 10             	pushl  0x10(%ebp)
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 13                	push   $0x13
  801cdc:	e8 7e fc ff ff       	call   80195f <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 1e                	push   $0x1e
  801cf6:	e8 64 fc ff ff       	call   80195f <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	50                   	push   %eax
  801d19:	6a 1f                	push   $0x1f
  801d1b:	e8 3f fc ff ff       	call   80195f <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <rsttst>:
void rsttst()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 21                	push   $0x21
  801d35:	e8 25 fc ff ff       	call   80195f <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	ff 75 10             	pushl  0x10(%ebp)
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 20                	push   $0x20
  801d60:	e8 fa fb ff ff       	call   80195f <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <chktst>:
void chktst(uint32 n)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 22                	push   $0x22
  801d7b:	e8 df fb ff ff       	call   80195f <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <inctst>:

void inctst()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 23                	push   $0x23
  801d95:	e8 c5 fb ff ff       	call   80195f <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <gettst>:
uint32 gettst()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 24                	push   $0x24
  801daf:	e8 ab fb ff ff       	call   80195f <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 25                	push   $0x25
  801dcb:	e8 8f fb ff ff       	call   80195f <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
  801dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dda:	75 07                	jne    801de3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  801de1:	eb 05                	jmp    801de8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 25                	push   $0x25
  801dfc:	e8 5e fb ff ff       	call   80195f <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
  801e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e0b:	75 07                	jne    801e14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e12:	eb 05                	jmp    801e19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 25                	push   $0x25
  801e2d:	e8 2d fb ff ff       	call   80195f <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
  801e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e3c:	75 07                	jne    801e45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	eb 05                	jmp    801e4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 25                	push   $0x25
  801e5e:	e8 fc fa ff ff       	call   80195f <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
  801e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e6d:	75 07                	jne    801e76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e74:	eb 05                	jmp    801e7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 26                	push   $0x26
  801e8d:	e8 cd fa ff ff       	call   80195f <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	53                   	push   %ebx
  801eab:	51                   	push   %ecx
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	6a 27                	push   $0x27
  801eb0:	e8 aa fa ff ff       	call   80195f <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 28                	push   $0x28
  801ed0:	e8 8a fa ff ff       	call   80195f <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801edd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	51                   	push   %ecx
  801ee9:	ff 75 10             	pushl  0x10(%ebp)
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 29                	push   $0x29
  801ef0:	e8 6a fa ff ff       	call   80195f <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 12                	push   $0x12
  801f0c:	e8 4e fa ff ff       	call   80195f <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 2a                	push   $0x2a
  801f2a:	e8 30 fa ff ff       	call   80195f <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	68 96 2a 80 00       	push   $0x802a96
  801f43:	68 2e 01 00 00       	push   $0x12e
  801f48:	68 aa 2a 80 00       	push   $0x802aaa
  801f4d:	e8 8c e8 ff ff       	call   8007de <_panic>

00801f52 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	68 96 2a 80 00       	push   $0x802a96
  801f60:	68 35 01 00 00       	push   $0x135
  801f65:	68 aa 2a 80 00       	push   $0x802aaa
  801f6a:	e8 6f e8 ff ff       	call   8007de <_panic>

00801f6f <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	68 96 2a 80 00       	push   $0x802a96
  801f7d:	68 3b 01 00 00       	push   $0x13b
  801f82:	68 aa 2a 80 00       	push   $0x802aaa
  801f87:	e8 52 e8 ff ff       	call   8007de <_panic>

00801f8c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 b8 2a 80 00       	push   $0x802ab8
  801f9a:	6a 09                	push   $0x9
  801f9c:	68 e0 2a 80 00       	push   $0x802ae0
  801fa1:	e8 38 e8 ff ff       	call   8007de <_panic>

00801fa6 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 f0 2a 80 00       	push   $0x802af0
  801fb4:	6a 10                	push   $0x10
  801fb6:	68 e0 2a 80 00       	push   $0x802ae0
  801fbb:	e8 1e e8 ff ff       	call   8007de <_panic>

00801fc0 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 18 2b 80 00       	push   $0x802b18
  801fce:	6a 18                	push   $0x18
  801fd0:	68 e0 2a 80 00       	push   $0x802ae0
  801fd5:	e8 04 e8 ff ff       	call   8007de <_panic>

00801fda <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 40 2b 80 00       	push   $0x802b40
  801fe8:	6a 20                	push   $0x20
  801fea:	68 e0 2a 80 00       	push   $0x802ae0
  801fef:	e8 ea e7 ff ff       	call   8007de <_panic>

00801ff4 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ffd:	5d                   	pop    %ebp
  801ffe:	c3                   	ret    
  801fff:	90                   	nop

00802000 <__udivdi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80200b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80200f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802013:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802017:	89 ca                	mov    %ecx,%edx
  802019:	89 f8                	mov    %edi,%eax
  80201b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80201f:	85 f6                	test   %esi,%esi
  802021:	75 2d                	jne    802050 <__udivdi3+0x50>
  802023:	39 cf                	cmp    %ecx,%edi
  802025:	77 65                	ja     80208c <__udivdi3+0x8c>
  802027:	89 fd                	mov    %edi,%ebp
  802029:	85 ff                	test   %edi,%edi
  80202b:	75 0b                	jne    802038 <__udivdi3+0x38>
  80202d:	b8 01 00 00 00       	mov    $0x1,%eax
  802032:	31 d2                	xor    %edx,%edx
  802034:	f7 f7                	div    %edi
  802036:	89 c5                	mov    %eax,%ebp
  802038:	31 d2                	xor    %edx,%edx
  80203a:	89 c8                	mov    %ecx,%eax
  80203c:	f7 f5                	div    %ebp
  80203e:	89 c1                	mov    %eax,%ecx
  802040:	89 d8                	mov    %ebx,%eax
  802042:	f7 f5                	div    %ebp
  802044:	89 cf                	mov    %ecx,%edi
  802046:	89 fa                	mov    %edi,%edx
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	39 ce                	cmp    %ecx,%esi
  802052:	77 28                	ja     80207c <__udivdi3+0x7c>
  802054:	0f bd fe             	bsr    %esi,%edi
  802057:	83 f7 1f             	xor    $0x1f,%edi
  80205a:	75 40                	jne    80209c <__udivdi3+0x9c>
  80205c:	39 ce                	cmp    %ecx,%esi
  80205e:	72 0a                	jb     80206a <__udivdi3+0x6a>
  802060:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802064:	0f 87 9e 00 00 00    	ja     802108 <__udivdi3+0x108>
  80206a:	b8 01 00 00 00       	mov    $0x1,%eax
  80206f:	89 fa                	mov    %edi,%edx
  802071:	83 c4 1c             	add    $0x1c,%esp
  802074:	5b                   	pop    %ebx
  802075:	5e                   	pop    %esi
  802076:	5f                   	pop    %edi
  802077:	5d                   	pop    %ebp
  802078:	c3                   	ret    
  802079:	8d 76 00             	lea    0x0(%esi),%esi
  80207c:	31 ff                	xor    %edi,%edi
  80207e:	31 c0                	xor    %eax,%eax
  802080:	89 fa                	mov    %edi,%edx
  802082:	83 c4 1c             	add    $0x1c,%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    
  80208a:	66 90                	xchg   %ax,%ax
  80208c:	89 d8                	mov    %ebx,%eax
  80208e:	f7 f7                	div    %edi
  802090:	31 ff                	xor    %edi,%edi
  802092:	89 fa                	mov    %edi,%edx
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
  80209c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020a1:	89 eb                	mov    %ebp,%ebx
  8020a3:	29 fb                	sub    %edi,%ebx
  8020a5:	89 f9                	mov    %edi,%ecx
  8020a7:	d3 e6                	shl    %cl,%esi
  8020a9:	89 c5                	mov    %eax,%ebp
  8020ab:	88 d9                	mov    %bl,%cl
  8020ad:	d3 ed                	shr    %cl,%ebp
  8020af:	89 e9                	mov    %ebp,%ecx
  8020b1:	09 f1                	or     %esi,%ecx
  8020b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020b7:	89 f9                	mov    %edi,%ecx
  8020b9:	d3 e0                	shl    %cl,%eax
  8020bb:	89 c5                	mov    %eax,%ebp
  8020bd:	89 d6                	mov    %edx,%esi
  8020bf:	88 d9                	mov    %bl,%cl
  8020c1:	d3 ee                	shr    %cl,%esi
  8020c3:	89 f9                	mov    %edi,%ecx
  8020c5:	d3 e2                	shl    %cl,%edx
  8020c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020cb:	88 d9                	mov    %bl,%cl
  8020cd:	d3 e8                	shr    %cl,%eax
  8020cf:	09 c2                	or     %eax,%edx
  8020d1:	89 d0                	mov    %edx,%eax
  8020d3:	89 f2                	mov    %esi,%edx
  8020d5:	f7 74 24 0c          	divl   0xc(%esp)
  8020d9:	89 d6                	mov    %edx,%esi
  8020db:	89 c3                	mov    %eax,%ebx
  8020dd:	f7 e5                	mul    %ebp
  8020df:	39 d6                	cmp    %edx,%esi
  8020e1:	72 19                	jb     8020fc <__udivdi3+0xfc>
  8020e3:	74 0b                	je     8020f0 <__udivdi3+0xf0>
  8020e5:	89 d8                	mov    %ebx,%eax
  8020e7:	31 ff                	xor    %edi,%edi
  8020e9:	e9 58 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020f4:	89 f9                	mov    %edi,%ecx
  8020f6:	d3 e2                	shl    %cl,%edx
  8020f8:	39 c2                	cmp    %eax,%edx
  8020fa:	73 e9                	jae    8020e5 <__udivdi3+0xe5>
  8020fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ff:	31 ff                	xor    %edi,%edi
  802101:	e9 40 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  802106:	66 90                	xchg   %ax,%ax
  802108:	31 c0                	xor    %eax,%eax
  80210a:	e9 37 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  80210f:	90                   	nop

00802110 <__umoddi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80211b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80211f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802123:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802127:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80212b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80212f:	89 f3                	mov    %esi,%ebx
  802131:	89 fa                	mov    %edi,%edx
  802133:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802137:	89 34 24             	mov    %esi,(%esp)
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 1a                	jne    802158 <__umoddi3+0x48>
  80213e:	39 f7                	cmp    %esi,%edi
  802140:	0f 86 a2 00 00 00    	jbe    8021e8 <__umoddi3+0xd8>
  802146:	89 c8                	mov    %ecx,%eax
  802148:	89 f2                	mov    %esi,%edx
  80214a:	f7 f7                	div    %edi
  80214c:	89 d0                	mov    %edx,%eax
  80214e:	31 d2                	xor    %edx,%edx
  802150:	83 c4 1c             	add    $0x1c,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
  802158:	39 f0                	cmp    %esi,%eax
  80215a:	0f 87 ac 00 00 00    	ja     80220c <__umoddi3+0xfc>
  802160:	0f bd e8             	bsr    %eax,%ebp
  802163:	83 f5 1f             	xor    $0x1f,%ebp
  802166:	0f 84 ac 00 00 00    	je     802218 <__umoddi3+0x108>
  80216c:	bf 20 00 00 00       	mov    $0x20,%edi
  802171:	29 ef                	sub    %ebp,%edi
  802173:	89 fe                	mov    %edi,%esi
  802175:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802179:	89 e9                	mov    %ebp,%ecx
  80217b:	d3 e0                	shl    %cl,%eax
  80217d:	89 d7                	mov    %edx,%edi
  80217f:	89 f1                	mov    %esi,%ecx
  802181:	d3 ef                	shr    %cl,%edi
  802183:	09 c7                	or     %eax,%edi
  802185:	89 e9                	mov    %ebp,%ecx
  802187:	d3 e2                	shl    %cl,%edx
  802189:	89 14 24             	mov    %edx,(%esp)
  80218c:	89 d8                	mov    %ebx,%eax
  80218e:	d3 e0                	shl    %cl,%eax
  802190:	89 c2                	mov    %eax,%edx
  802192:	8b 44 24 08          	mov    0x8(%esp),%eax
  802196:	d3 e0                	shl    %cl,%eax
  802198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021a0:	89 f1                	mov    %esi,%ecx
  8021a2:	d3 e8                	shr    %cl,%eax
  8021a4:	09 d0                	or     %edx,%eax
  8021a6:	d3 eb                	shr    %cl,%ebx
  8021a8:	89 da                	mov    %ebx,%edx
  8021aa:	f7 f7                	div    %edi
  8021ac:	89 d3                	mov    %edx,%ebx
  8021ae:	f7 24 24             	mull   (%esp)
  8021b1:	89 c6                	mov    %eax,%esi
  8021b3:	89 d1                	mov    %edx,%ecx
  8021b5:	39 d3                	cmp    %edx,%ebx
  8021b7:	0f 82 87 00 00 00    	jb     802244 <__umoddi3+0x134>
  8021bd:	0f 84 91 00 00 00    	je     802254 <__umoddi3+0x144>
  8021c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021c7:	29 f2                	sub    %esi,%edx
  8021c9:	19 cb                	sbb    %ecx,%ebx
  8021cb:	89 d8                	mov    %ebx,%eax
  8021cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 e9                	mov    %ebp,%ecx
  8021d5:	d3 ea                	shr    %cl,%edx
  8021d7:	09 d0                	or     %edx,%eax
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	d3 eb                	shr    %cl,%ebx
  8021dd:	89 da                	mov    %ebx,%edx
  8021df:	83 c4 1c             	add    $0x1c,%esp
  8021e2:	5b                   	pop    %ebx
  8021e3:	5e                   	pop    %esi
  8021e4:	5f                   	pop    %edi
  8021e5:	5d                   	pop    %ebp
  8021e6:	c3                   	ret    
  8021e7:	90                   	nop
  8021e8:	89 fd                	mov    %edi,%ebp
  8021ea:	85 ff                	test   %edi,%edi
  8021ec:	75 0b                	jne    8021f9 <__umoddi3+0xe9>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	31 d2                	xor    %edx,%edx
  8021f5:	f7 f7                	div    %edi
  8021f7:	89 c5                	mov    %eax,%ebp
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	f7 f5                	div    %ebp
  8021ff:	89 c8                	mov    %ecx,%eax
  802201:	f7 f5                	div    %ebp
  802203:	89 d0                	mov    %edx,%eax
  802205:	e9 44 ff ff ff       	jmp    80214e <__umoddi3+0x3e>
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	89 c8                	mov    %ecx,%eax
  80220e:	89 f2                	mov    %esi,%edx
  802210:	83 c4 1c             	add    $0x1c,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    
  802218:	3b 04 24             	cmp    (%esp),%eax
  80221b:	72 06                	jb     802223 <__umoddi3+0x113>
  80221d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802221:	77 0f                	ja     802232 <__umoddi3+0x122>
  802223:	89 f2                	mov    %esi,%edx
  802225:	29 f9                	sub    %edi,%ecx
  802227:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80222b:	89 14 24             	mov    %edx,(%esp)
  80222e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802232:	8b 44 24 04          	mov    0x4(%esp),%eax
  802236:	8b 14 24             	mov    (%esp),%edx
  802239:	83 c4 1c             	add    $0x1c,%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5f                   	pop    %edi
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    
  802241:	8d 76 00             	lea    0x0(%esi),%esi
  802244:	2b 04 24             	sub    (%esp),%eax
  802247:	19 fa                	sbb    %edi,%edx
  802249:	89 d1                	mov    %edx,%ecx
  80224b:	89 c6                	mov    %eax,%esi
  80224d:	e9 71 ff ff ff       	jmp    8021c3 <__umoddi3+0xb3>
  802252:	66 90                	xchg   %ax,%ax
  802254:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802258:	72 ea                	jb     802244 <__umoddi3+0x134>
  80225a:	89 d9                	mov    %ebx,%ecx
  80225c:	e9 62 ff ff ff       	jmp    8021c3 <__umoddi3+0xb3>


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
  800044:	e8 20 1d 00 00       	call   801d69 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 49 40 80 00       	mov    $0x804049,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 53 40 80 00       	mov    $0x804053,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 5f 40 80 00       	mov    $0x80405f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 6e 40 80 00       	mov    $0x80406e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 7d 40 80 00       	mov    $0x80407d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 92 40 80 00       	mov    $0x804092,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb a7 40 80 00       	mov    $0x8040a7,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb b8 40 80 00       	mov    $0x8040b8,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb c9 40 80 00       	mov    $0x8040c9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb da 40 80 00       	mov    $0x8040da,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb e3 40 80 00       	mov    $0x8040e3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb ed 40 80 00       	mov    $0x8040ed,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb f8 40 80 00       	mov    $0x8040f8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 04 41 80 00       	mov    $0x804104,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 0e 41 80 00       	mov    $0x80410e,%ebx
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
  8001be:	bb 18 41 80 00       	mov    $0x804118,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 26 41 80 00       	mov    $0x804126,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 35 41 80 00       	mov    $0x804135,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 3c 41 80 00       	mov    $0x80413c,%ebx
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
  800222:	e8 5e 16 00 00       	call   801885 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 49 16 00 00       	call   801885 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 31 16 00 00       	call   801885 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 19 16 00 00       	call   801885 <sget>
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
  800286:	e8 b8 38 00 00       	call   803b43 <get_semaphore>
  80028b:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80028e:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	8d 95 f7 fe ff ff    	lea    -0x109(%ebp),%edx
  80029d:	52                   	push   %edx
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	50                   	push   %eax
  8002a2:	e8 9c 38 00 00       	call   803b43 <get_semaphore>
  8002a7:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  8002aa:	8d 85 c0 fe ff ff    	lea    -0x140(%ebp),%eax
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8d 95 11 ff ff ff    	lea    -0xef(%ebp),%edx
  8002b9:	52                   	push   %edx
  8002ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bd:	50                   	push   %eax
  8002be:	e8 80 38 00 00       	call   803b43 <get_semaphore>
  8002c3:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  8002c6:	8d 85 bc fe ff ff    	lea    -0x144(%ebp),%eax
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	8d 95 1d ff ff ff    	lea    -0xe3(%ebp),%edx
  8002d5:	52                   	push   %edx
  8002d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	e8 64 38 00 00       	call   803b43 <get_semaphore>
  8002df:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8002e2:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
  8002f1:	52                   	push   %edx
  8002f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	e8 48 38 00 00       	call   803b43 <get_semaphore>
  8002fb:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	ff b5 c8 fe ff ff    	pushl  -0x138(%ebp)
  800307:	e8 51 38 00 00       	call   803b5d <wait_semaphore>
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
  80032d:	e8 45 38 00 00       	call   803b77 <signal_semaphore>
  800332:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	wait_semaphore(clerk);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	ff b5 c4 fe ff ff    	pushl  -0x13c(%ebp)
  80033e:	e8 1a 38 00 00       	call   803b5d <wait_semaphore>
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
  800363:	e8 f5 37 00 00       	call   803b5d <wait_semaphore>
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
  800397:	e8 db 37 00 00       	call   803b77 <signal_semaphore>
  80039c:	83 c4 10             	add    $0x10,%esp

	//signal ready
	signal_semaphore(cust_ready);
  80039f:	83 ec 0c             	sub    $0xc,%esp
  8003a2:	ff b5 bc fe ff ff    	pushl  -0x144(%ebp)
  8003a8:	e8 ca 37 00 00       	call   803b77 <signal_semaphore>
  8003ad:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  8003b0:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8003b6:	bb 43 41 80 00       	mov    $0x804143,%ebx
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
  800425:	e8 19 37 00 00       	call   803b43 <get_semaphore>
  80042a:	83 c4 0c             	add    $0xc,%esp
	wait_semaphore(cust_finished);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800436:	e8 22 37 00 00       	call   803b5d <wait_semaphore>
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
  80045e:	68 00 40 80 00       	push   $0x804000
  800463:	e8 72 02 00 00       	call   8006da <atomic_cprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb 13                	jmp    800480 <_main+0x448>
	}
	else
	{
		atomic_cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  80046d:	83 ec 08             	sub    $0x8,%esp
  800470:	ff 75 d0             	pushl  -0x30(%ebp)
  800473:	68 28 40 80 00       	push   $0x804028
  800478:	e8 5d 02 00 00       	call   8006da <atomic_cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	signal_semaphore(custTerminated);
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff b5 b8 fe ff ff    	pushl  -0x148(%ebp)
  800489:	e8 e9 36 00 00       	call   803b77 <signal_semaphore>
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
  8004a0:	e8 ab 18 00 00       	call   801d50 <sys_getenvindex>
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
  80050e:	e8 c1 15 00 00       	call   801ad4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	68 7c 41 80 00       	push   $0x80417c
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
  80053e:	68 a4 41 80 00       	push   $0x8041a4
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
  80056f:	68 cc 41 80 00       	push   $0x8041cc
  800574:	e8 34 01 00 00       	call   8006ad <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80057c:	a1 20 50 80 00       	mov    0x805020,%eax
  800581:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	50                   	push   %eax
  80058b:	68 24 42 80 00       	push   $0x804224
  800590:	e8 18 01 00 00       	call   8006ad <cprintf>
  800595:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	68 7c 41 80 00       	push   $0x80417c
  8005a0:	e8 08 01 00 00       	call   8006ad <cprintf>
  8005a5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8005a8:	e8 41 15 00 00       	call   801aee <sys_unlock_cons>
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
  8005c0:	e8 57 17 00 00       	call   801d1c <sys_destroy_env>
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
  8005d1:	e8 ac 17 00 00       	call   801d82 <sys_exit_env>
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
  800604:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  80061f:	e8 6e 14 00 00       	call   801a92 <sys_cputs>
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
  800679:	a0 2c 50 80 00       	mov    0x80502c,%al
  80067e:	0f b6 c0             	movzbl %al,%eax
  800681:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800687:	83 ec 04             	sub    $0x4,%esp
  80068a:	50                   	push   %eax
  80068b:	52                   	push   %edx
  80068c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800692:	83 c0 08             	add    $0x8,%eax
  800695:	50                   	push   %eax
  800696:	e8 f7 13 00 00       	call   801a92 <sys_cputs>
  80069b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80069e:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  8006b3:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8006e0:	e8 ef 13 00 00       	call   801ad4 <sys_lock_cons>
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
  800700:	e8 e9 13 00 00       	call   801aee <sys_unlock_cons>
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
  80074a:	e8 39 36 00 00       	call   803d88 <__udivdi3>
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
  80079a:	e8 f9 36 00 00       	call   803e98 <__umoddi3>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	05 54 44 80 00       	add    $0x804454,%eax
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
  8008f5:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  8009d6:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	75 19                	jne    8009fa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e1:	53                   	push   %ebx
  8009e2:	68 65 44 80 00       	push   $0x804465
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
  8009fb:	68 6e 44 80 00       	push   $0x80446e
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
  800a28:	be 71 44 80 00       	mov    $0x804471,%esi
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
  800c20:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800c27:	eb 2c                	jmp    800c55 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c29:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801433:	68 e8 45 80 00       	push   $0x8045e8
  801438:	68 3f 01 00 00       	push   $0x13f
  80143d:	68 0a 46 80 00       	push   $0x80460a
  801442:	e8 55 27 00 00       	call   803b9c <_panic>

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
  801453:	e8 e5 0b 00 00       	call   80203d <sys_sbrk>
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
  8014ce:	e8 ee 09 00 00       	call   801ec1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 16                	je     8014ed <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 2e 0f 00 00       	call   802410 <alloc_block_FF>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e8:	e9 8a 01 00 00       	jmp    801677 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ed:	e8 00 0a 00 00       	call   801ef2 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	0f 84 7d 01 00 00    	je     801677 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 c7 13 00 00       	call   8028cc <alloc_block_BF>
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
  801550:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80159d:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8015f4:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801656:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	ff 75 f0             	pushl  -0x10(%ebp)
  801666:	e8 09 0a 00 00       	call   802074 <sys_allocate_user_mem>
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
  8016ae:	e8 dd 09 00 00       	call   802090 <get_block_size>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016b9:	83 ec 0c             	sub    $0xc,%esp
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 10 1c 00 00       	call   8032d4 <free_block>
  8016c4:	83 c4 10             	add    $0x10,%esp
		}

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
  8016f9:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801700:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801706:	c1 e0 0c             	shl    $0xc,%eax
  801709:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80170c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801713:	eb 42                	jmp    801757 <free+0xdb>
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
  801736:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  80173d:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	e8 07 09 00 00       	call   802058 <sys_free_user_mem>
  801751:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801754:	ff 45 f4             	incl   -0xc(%ebp)
  801757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80175d:	72 b6                	jb     801715 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80175f:	eb 17                	jmp    801778 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 18 46 80 00       	push   $0x804618
  801769:	68 88 00 00 00       	push   $0x88
  80176e:	68 42 46 80 00       	push   $0x804642
  801773:	e8 24 24 00 00       	call   803b9c <_panic>
	}
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 28             	sub    $0x28,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 0a                	jne    801797 <smalloc+0x1c>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	e9 ec 00 00 00       	jmp    801883 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	39 d0                	cmp    %edx,%eax
  8017ac:	73 02                	jae    8017b0 <smalloc+0x35>
  8017ae:	89 d0                	mov    %edx,%eax
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	50                   	push   %eax
  8017b4:	e8 a4 fc ff ff       	call   80145d <malloc>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c3:	75 0a                	jne    8017cf <smalloc+0x54>
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	e9 b4 00 00 00       	jmp    801883 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017cf:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d6:	50                   	push   %eax
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	e8 7d 04 00 00       	call   801c5f <sys_createSharedObject>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017ec:	74 06                	je     8017f4 <smalloc+0x79>
  8017ee:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017f2:	75 0a                	jne    8017fe <smalloc+0x83>
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	e9 85 00 00 00       	jmp    801883 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	ff 75 ec             	pushl  -0x14(%ebp)
  801804:	68 4e 46 80 00       	push   $0x80464e
  801809:	e8 9f ee ff ff       	call   8006ad <cprintf>
  80180e:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801811:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801814:	a1 20 50 80 00       	mov    0x805020,%eax
  801819:	8b 40 78             	mov    0x78(%eax),%eax
  80181c:	29 c2                	sub    %eax,%edx
  80181e:	89 d0                	mov    %edx,%eax
  801820:	2d 00 10 00 00       	sub    $0x1000,%eax
  801825:	c1 e8 0c             	shr    $0xc,%eax
  801828:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80182e:	42                   	inc    %edx
  80182f:	89 15 24 50 80 00    	mov    %edx,0x805024
  801835:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80183b:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801842:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801845:	a1 20 50 80 00       	mov    0x805020,%eax
  80184a:	8b 40 78             	mov    0x78(%eax),%eax
  80184d:	29 c2                	sub    %eax,%edx
  80184f:	89 d0                	mov    %edx,%eax
  801851:	2d 00 10 00 00       	sub    $0x1000,%eax
  801856:	c1 e8 0c             	shr    $0xc,%eax
  801859:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801860:	a1 20 50 80 00       	mov    0x805020,%eax
  801865:	8b 50 10             	mov    0x10(%eax),%edx
  801868:	89 c8                	mov    %ecx,%eax
  80186a:	c1 e0 02             	shl    $0x2,%eax
  80186d:	89 c1                	mov    %eax,%ecx
  80186f:	c1 e1 09             	shl    $0x9,%ecx
  801872:	01 c8                	add    %ecx,%eax
  801874:	01 c2                	add    %eax,%edx
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801880:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	e8 f0 03 00 00       	call   801c89 <sys_getSizeOfSharedObject>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80189f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018a3:	75 0a                	jne    8018af <sget+0x2a>
  8018a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018aa:	e9 e7 00 00 00       	jmp    801996 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c2:	39 d0                	cmp    %edx,%eax
  8018c4:	73 02                	jae    8018c8 <sget+0x43>
  8018c6:	89 d0                	mov    %edx,%eax
  8018c8:	83 ec 0c             	sub    $0xc,%esp
  8018cb:	50                   	push   %eax
  8018cc:	e8 8c fb ff ff       	call   80145d <malloc>
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018db:	75 0a                	jne    8018e7 <sget+0x62>
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	e9 af 00 00 00       	jmp    801996 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 ae 03 00 00       	call   801ca6 <sys_getSharedObject>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801901:	a1 20 50 80 00       	mov    0x805020,%eax
  801906:	8b 40 78             	mov    0x78(%eax),%eax
  801909:	29 c2                	sub    %eax,%edx
  80190b:	89 d0                	mov    %edx,%eax
  80190d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801912:	c1 e8 0c             	shr    $0xc,%eax
  801915:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80191b:	42                   	inc    %edx
  80191c:	89 15 24 50 80 00    	mov    %edx,0x805024
  801922:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801928:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80192f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801932:	a1 20 50 80 00       	mov    0x805020,%eax
  801937:	8b 40 78             	mov    0x78(%eax),%eax
  80193a:	29 c2                	sub    %eax,%edx
  80193c:	89 d0                	mov    %edx,%eax
  80193e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801943:	c1 e8 0c             	shr    $0xc,%eax
  801946:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80194d:	a1 20 50 80 00       	mov    0x805020,%eax
  801952:	8b 50 10             	mov    0x10(%eax),%edx
  801955:	89 c8                	mov    %ecx,%eax
  801957:	c1 e0 02             	shl    $0x2,%eax
  80195a:	89 c1                	mov    %eax,%ecx
  80195c:	c1 e1 09             	shl    $0x9,%ecx
  80195f:	01 c8                	add    %ecx,%eax
  801961:	01 c2                	add    %eax,%edx
  801963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801966:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80196d:	a1 20 50 80 00       	mov    0x805020,%eax
  801972:	8b 40 10             	mov    0x10(%eax),%eax
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	50                   	push   %eax
  801979:	68 5d 46 80 00       	push   $0x80465d
  80197e:	e8 2a ed ff ff       	call   8006ad <cprintf>
  801983:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801986:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80198a:	75 07                	jne    801993 <sget+0x10e>
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
  801991:	eb 03                	jmp    801996 <sget+0x111>
	return ptr;
  801993:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a6:	8b 40 78             	mov    0x78(%eax),%eax
  8019a9:	29 c2                	sub    %eax,%edx
  8019ab:	89 d0                	mov    %edx,%eax
  8019ad:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019b2:	c1 e8 0c             	shr    $0xc,%eax
  8019b5:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8019c1:	8b 50 10             	mov    0x10(%eax),%edx
  8019c4:	89 c8                	mov    %ecx,%eax
  8019c6:	c1 e0 02             	shl    $0x2,%eax
  8019c9:	89 c1                	mov    %eax,%ecx
  8019cb:	c1 e1 09             	shl    $0x9,%ecx
  8019ce:	01 c8                	add    %ecx,%eax
  8019d0:	01 d0                	add    %edx,%eax
  8019d2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e5:	e8 db 02 00 00       	call   801cc5 <sys_freeSharedObject>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	68 6c 46 80 00       	push   $0x80466c
  801a01:	68 e5 00 00 00       	push   $0xe5
  801a06:	68 42 46 80 00       	push   $0x804642
  801a0b:	e8 8c 21 00 00       	call   803b9c <_panic>

00801a10 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 92 46 80 00       	push   $0x804692
  801a1e:	68 f1 00 00 00       	push   $0xf1
  801a23:	68 42 46 80 00       	push   $0x804642
  801a28:	e8 6f 21 00 00       	call   803b9c <_panic>

00801a2d <shrink>:

}
void shrink(uint32 newSize)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	68 92 46 80 00       	push   $0x804692
  801a3b:	68 f6 00 00 00       	push   $0xf6
  801a40:	68 42 46 80 00       	push   $0x804642
  801a45:	e8 52 21 00 00       	call   803b9c <_panic>

00801a4a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	68 92 46 80 00       	push   $0x804692
  801a58:	68 fb 00 00 00       	push   $0xfb
  801a5d:	68 42 46 80 00       	push   $0x804642
  801a62:	e8 35 21 00 00       	call   803b9c <_panic>

00801a67 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	57                   	push   %edi
  801a6b:	56                   	push   %esi
  801a6c:	53                   	push   %ebx
  801a6d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a79:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a7f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a82:	cd 30                	int    $0x30
  801a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5f                   	pop    %edi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    

00801a92 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a9e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	52                   	push   %edx
  801aaa:	ff 75 0c             	pushl  0xc(%ebp)
  801aad:	50                   	push   %eax
  801aae:	6a 00                	push   $0x0
  801ab0:	e8 b2 ff ff ff       	call   801a67 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_cgetc>:

int
sys_cgetc(void)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 02                	push   $0x2
  801aca:	e8 98 ff ff ff       	call   801a67 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 03                	push   $0x3
  801ae3:	e8 7f ff ff ff       	call   801a67 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 04                	push   $0x4
  801afd:	e8 65 ff ff ff       	call   801a67 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	6a 08                	push   $0x8
  801b1b:	e8 47 ff ff ff       	call   801a67 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	56                   	push   %esi
  801b29:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b2a:	8b 75 18             	mov    0x18(%ebp),%esi
  801b2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	56                   	push   %esi
  801b3a:	53                   	push   %ebx
  801b3b:	51                   	push   %ecx
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 09                	push   $0x9
  801b40:	e8 22 ff ff ff       	call   801a67 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 0a                	push   $0xa
  801b62:	e8 00 ff ff ff       	call   801a67 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 0b                	push   $0xb
  801b7d:	e8 e5 fe ff ff       	call   801a67 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 0c                	push   $0xc
  801b96:	e8 cc fe ff ff       	call   801a67 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 0d                	push   $0xd
  801baf:	e8 b3 fe ff ff       	call   801a67 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 0e                	push   $0xe
  801bc8:	e8 9a fe ff ff       	call   801a67 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 0f                	push   $0xf
  801be1:	e8 81 fe ff ff       	call   801a67 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	6a 10                	push   $0x10
  801bfb:	e8 67 fe ff ff       	call   801a67 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 11                	push   $0x11
  801c14:	e8 4e fe ff ff       	call   801a67 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	90                   	nop
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_cputc>:

void
sys_cputc(const char c)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	50                   	push   %eax
  801c38:	6a 01                	push   $0x1
  801c3a:	e8 28 fe ff ff       	call   801a67 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 14                	push   $0x14
  801c54:	e8 0e fe ff ff       	call   801a67 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	8b 45 10             	mov    0x10(%ebp),%eax
  801c68:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c6b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c6e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	51                   	push   %ecx
  801c78:	52                   	push   %edx
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	50                   	push   %eax
  801c7d:	6a 15                	push   $0x15
  801c7f:	e8 e3 fd ff ff       	call   801a67 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 16                	push   $0x16
  801c9c:	e8 c6 fd ff ff       	call   801a67 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ca9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	51                   	push   %ecx
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 17                	push   $0x17
  801cbb:	e8 a7 fd ff ff       	call   801a67 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 18                	push   $0x18
  801cd8:	e8 8a fd ff ff       	call   801a67 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 14             	pushl  0x14(%ebp)
  801ced:	ff 75 10             	pushl  0x10(%ebp)
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	6a 19                	push   $0x19
  801cf6:	e8 6c fd ff ff       	call   801a67 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	50                   	push   %eax
  801d0f:	6a 1a                	push   $0x1a
  801d11:	e8 51 fd ff ff       	call   801a67 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	90                   	nop
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	50                   	push   %eax
  801d2b:	6a 1b                	push   $0x1b
  801d2d:	e8 35 fd ff ff       	call   801a67 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 05                	push   $0x5
  801d46:	e8 1c fd ff ff       	call   801a67 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 06                	push   $0x6
  801d5f:	e8 03 fd ff ff       	call   801a67 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 07                	push   $0x7
  801d78:	e8 ea fc ff ff       	call   801a67 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_exit_env>:


void sys_exit_env(void)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 1c                	push   $0x1c
  801d91:	e8 d1 fc ff ff       	call   801a67 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	90                   	nop
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da5:	8d 50 04             	lea    0x4(%eax),%edx
  801da8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	52                   	push   %edx
  801db2:	50                   	push   %eax
  801db3:	6a 1d                	push   $0x1d
  801db5:	e8 ad fc ff ff       	call   801a67 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
	return result;
  801dbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc6:	89 01                	mov    %eax,(%ecx)
  801dc8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	c9                   	leave  
  801dcf:	c2 04 00             	ret    $0x4

00801dd2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	ff 75 10             	pushl  0x10(%ebp)
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	6a 13                	push   $0x13
  801de4:	e8 7e fc ff ff       	call   801a67 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_rcr2>:
uint32 sys_rcr2()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 1e                	push   $0x1e
  801dfe:	e8 64 fc ff ff       	call   801a67 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e14:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	50                   	push   %eax
  801e21:	6a 1f                	push   $0x1f
  801e23:	e8 3f fc ff ff       	call   801a67 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2b:	90                   	nop
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <rsttst>:
void rsttst()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 21                	push   $0x21
  801e3d:	e8 25 fc ff ff       	call   801a67 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e54:	8b 55 18             	mov    0x18(%ebp),%edx
  801e57:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5b:	52                   	push   %edx
  801e5c:	50                   	push   %eax
  801e5d:	ff 75 10             	pushl  0x10(%ebp)
  801e60:	ff 75 0c             	pushl  0xc(%ebp)
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	6a 20                	push   $0x20
  801e68:	e8 fa fb ff ff       	call   801a67 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <chktst>:
void chktst(uint32 n)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 22                	push   $0x22
  801e83:	e8 df fb ff ff       	call   801a67 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <inctst>:

void inctst()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 23                	push   $0x23
  801e9d:	e8 c5 fb ff ff       	call   801a67 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea5:	90                   	nop
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <gettst>:
uint32 gettst()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 24                	push   $0x24
  801eb7:	e8 ab fb ff ff       	call   801a67 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 25                	push   $0x25
  801ed3:	e8 8f fb ff ff       	call   801a67 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
  801edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ede:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee2:	75 07                	jne    801eeb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee9:	eb 05                	jmp    801ef0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 25                	push   $0x25
  801f04:	e8 5e fb ff ff       	call   801a67 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
  801f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f0f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f13:	75 07                	jne    801f1c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f15:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1a:	eb 05                	jmp    801f21 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 25                	push   $0x25
  801f35:	e8 2d fb ff ff       	call   801a67 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
  801f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f40:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f44:	75 07                	jne    801f4d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	eb 05                	jmp    801f52 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 25                	push   $0x25
  801f66:	e8 fc fa ff ff       	call   801a67 <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
  801f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f71:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f75:	75 07                	jne    801f7e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f77:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7c:	eb 05                	jmp    801f83 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	ff 75 08             	pushl  0x8(%ebp)
  801f93:	6a 26                	push   $0x26
  801f95:	e8 cd fa ff ff       	call   801a67 <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9d:	90                   	nop
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	53                   	push   %ebx
  801fb3:	51                   	push   %ecx
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 27                	push   $0x27
  801fb8:	e8 aa fa ff ff       	call   801a67 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 28                	push   $0x28
  801fd8:	e8 8a fa ff ff       	call   801a67 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fe5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	51                   	push   %ecx
  801ff1:	ff 75 10             	pushl  0x10(%ebp)
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 29                	push   $0x29
  801ff8:	e8 6a fa ff ff       	call   801a67 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	6a 12                	push   $0x12
  802014:	e8 4e fa ff ff       	call   801a67 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
	return ;
  80201c:	90                   	nop
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	52                   	push   %edx
  80202f:	50                   	push   %eax
  802030:	6a 2a                	push   $0x2a
  802032:	e8 30 fa ff ff       	call   801a67 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
	return;
  80203a:	90                   	nop
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	50                   	push   %eax
  80204c:	6a 2b                	push   $0x2b
  80204e:	e8 14 fa ff ff       	call   801a67 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	6a 2c                	push   $0x2c
  802069:	e8 f9 f9 ff ff       	call   801a67 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
	return;
  802071:	90                   	nop
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	6a 2d                	push   $0x2d
  802085:	e8 dd f9 ff ff       	call   801a67 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
	return;
  80208d:	90                   	nop
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	83 e8 04             	sub    $0x4,%eax
  80209c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80209f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	83 e8 04             	sub    $0x4,%eax
  8020b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bb:	8b 00                	mov    (%eax),%eax
  8020bd:	83 e0 01             	and    $0x1,%eax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	0f 94 c0             	sete   %al
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	83 f8 02             	cmp    $0x2,%eax
  8020da:	74 2b                	je     802107 <alloc_block+0x40>
  8020dc:	83 f8 02             	cmp    $0x2,%eax
  8020df:	7f 07                	jg     8020e8 <alloc_block+0x21>
  8020e1:	83 f8 01             	cmp    $0x1,%eax
  8020e4:	74 0e                	je     8020f4 <alloc_block+0x2d>
  8020e6:	eb 58                	jmp    802140 <alloc_block+0x79>
  8020e8:	83 f8 03             	cmp    $0x3,%eax
  8020eb:	74 2d                	je     80211a <alloc_block+0x53>
  8020ed:	83 f8 04             	cmp    $0x4,%eax
  8020f0:	74 3b                	je     80212d <alloc_block+0x66>
  8020f2:	eb 4c                	jmp    802140 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	e8 11 03 00 00       	call   802410 <alloc_block_FF>
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802105:	eb 4a                	jmp    802151 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802107:	83 ec 0c             	sub    $0xc,%esp
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	e8 fa 19 00 00       	call   803b0c <alloc_block_NF>
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802118:	eb 37                	jmp    802151 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80211a:	83 ec 0c             	sub    $0xc,%esp
  80211d:	ff 75 08             	pushl  0x8(%ebp)
  802120:	e8 a7 07 00 00       	call   8028cc <alloc_block_BF>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80212b:	eb 24                	jmp    802151 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	ff 75 08             	pushl  0x8(%ebp)
  802133:	e8 b7 19 00 00       	call   803aef <alloc_block_WF>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80213e:	eb 11                	jmp    802151 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802140:	83 ec 0c             	sub    $0xc,%esp
  802143:	68 a4 46 80 00       	push   $0x8046a4
  802148:	e8 60 e5 ff ff       	call   8006ad <cprintf>
  80214d:	83 c4 10             	add    $0x10,%esp
		break;
  802150:	90                   	nop
	}
	return va;
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	53                   	push   %ebx
  80215a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80215d:	83 ec 0c             	sub    $0xc,%esp
  802160:	68 c4 46 80 00       	push   $0x8046c4
  802165:	e8 43 e5 ff ff       	call   8006ad <cprintf>
  80216a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	68 ef 46 80 00       	push   $0x8046ef
  802175:	e8 33 e5 ff ff       	call   8006ad <cprintf>
  80217a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802183:	eb 37                	jmp    8021bc <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802185:	83 ec 0c             	sub    $0xc,%esp
  802188:	ff 75 f4             	pushl  -0xc(%ebp)
  80218b:	e8 19 ff ff ff       	call   8020a9 <is_free_block>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	0f be d8             	movsbl %al,%ebx
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	ff 75 f4             	pushl  -0xc(%ebp)
  80219c:	e8 ef fe ff ff       	call   802090 <get_block_size>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	53                   	push   %ebx
  8021a8:	50                   	push   %eax
  8021a9:	68 07 47 80 00       	push   $0x804707
  8021ae:	e8 fa e4 ff ff       	call   8006ad <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c0:	74 07                	je     8021c9 <print_blocks_list+0x73>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	eb 05                	jmp    8021ce <print_blocks_list+0x78>
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	89 45 10             	mov    %eax,0x10(%ebp)
  8021d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	75 ad                	jne    802185 <print_blocks_list+0x2f>
  8021d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dc:	75 a7                	jne    802185 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	68 c4 46 80 00       	push   $0x8046c4
  8021e6:	e8 c2 e4 ff ff       	call   8006ad <cprintf>
  8021eb:	83 c4 10             	add    $0x10,%esp

}
  8021ee:	90                   	nop
  8021ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	83 e0 01             	and    $0x1,%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 03                	je     802207 <initialize_dynamic_allocator+0x13>
  802204:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802207:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80220b:	0f 84 c7 01 00 00    	je     8023d8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802211:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802218:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80221b:	8b 55 08             	mov    0x8(%ebp),%edx
  80221e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802221:	01 d0                	add    %edx,%eax
  802223:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802228:	0f 87 ad 01 00 00    	ja     8023db <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	0f 89 a5 01 00 00    	jns    8023de <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802239:	8b 55 08             	mov    0x8(%ebp),%edx
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	01 d0                	add    %edx,%eax
  802241:	83 e8 04             	sub    $0x4,%eax
  802244:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802250:	a1 30 50 80 00       	mov    0x805030,%eax
  802255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802258:	e9 87 00 00 00       	jmp    8022e4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80225d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802261:	75 14                	jne    802277 <initialize_dynamic_allocator+0x83>
  802263:	83 ec 04             	sub    $0x4,%esp
  802266:	68 1f 47 80 00       	push   $0x80471f
  80226b:	6a 79                	push   $0x79
  80226d:	68 3d 47 80 00       	push   $0x80473d
  802272:	e8 25 19 00 00       	call   803b9c <_panic>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 10                	je     802290 <initialize_dynamic_allocator+0x9c>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802288:	8b 52 04             	mov    0x4(%edx),%edx
  80228b:	89 50 04             	mov    %edx,0x4(%eax)
  80228e:	eb 0b                	jmp    80229b <initialize_dynamic_allocator+0xa7>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 40 04             	mov    0x4(%eax),%eax
  802296:	a3 34 50 80 00       	mov    %eax,0x805034
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 04             	mov    0x4(%eax),%eax
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	74 0f                	je     8022b4 <initialize_dynamic_allocator+0xc0>
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 04             	mov    0x4(%eax),%eax
  8022ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ae:	8b 12                	mov    (%edx),%edx
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	eb 0a                	jmp    8022be <initialize_dynamic_allocator+0xca>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022d6:	48                   	dec    %eax
  8022d7:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e8:	74 07                	je     8022f1 <initialize_dynamic_allocator+0xfd>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	eb 05                	jmp    8022f6 <initialize_dynamic_allocator+0x102>
  8022f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8022fb:	a1 38 50 80 00       	mov    0x805038,%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	0f 85 55 ff ff ff    	jne    80225d <initialize_dynamic_allocator+0x69>
  802308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230c:	0f 85 4b ff ff ff    	jne    80225d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802321:	a1 48 50 80 00       	mov    0x805048,%eax
  802326:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80232b:	a1 44 50 80 00       	mov    0x805044,%eax
  802330:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	83 c0 08             	add    $0x8,%eax
  80233c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	83 c0 04             	add    $0x4,%eax
  802345:	8b 55 0c             	mov    0xc(%ebp),%edx
  802348:	83 ea 08             	sub    $0x8,%edx
  80234b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80234d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	01 d0                	add    %edx,%eax
  802355:	83 e8 08             	sub    $0x8,%eax
  802358:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235b:	83 ea 08             	sub    $0x8,%edx
  80235e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802373:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802377:	75 17                	jne    802390 <initialize_dynamic_allocator+0x19c>
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 58 47 80 00       	push   $0x804758
  802381:	68 90 00 00 00       	push   $0x90
  802386:	68 3d 47 80 00       	push   $0x80473d
  80238b:	e8 0c 18 00 00       	call   803b9c <_panic>
  802390:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802399:	89 10                	mov    %edx,(%eax)
  80239b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 0d                	je     8023b1 <initialize_dynamic_allocator+0x1bd>
  8023a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8023a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	eb 08                	jmp    8023b9 <initialize_dynamic_allocator+0x1c5>
  8023b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b4:	a3 34 50 80 00       	mov    %eax,0x805034
  8023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023d0:	40                   	inc    %eax
  8023d1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8023d6:	eb 07                	jmp    8023df <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023d8:	90                   	nop
  8023d9:	eb 04                	jmp    8023df <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023db:	90                   	nop
  8023dc:	eb 01                	jmp    8023df <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023de:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f3:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	83 e8 04             	sub    $0x4,%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	83 e0 fe             	and    $0xfffffffe,%eax
  802400:	8d 50 f8             	lea    -0x8(%eax),%edx
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	01 c2                	add    %eax,%edx
  802408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240b:	89 02                	mov    %eax,(%edx)
}
  80240d:	90                   	nop
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	83 e0 01             	and    $0x1,%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 03                	je     802423 <alloc_block_FF+0x13>
  802420:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802423:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802427:	77 07                	ja     802430 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802429:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802430:	a1 28 50 80 00       	mov    0x805028,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 73                	jne    8024ac <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	83 c0 10             	add    $0x10,%eax
  80243f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802442:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80244c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	48                   	dec    %eax
  802452:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802458:	ba 00 00 00 00       	mov    $0x0,%edx
  80245d:	f7 75 ec             	divl   -0x14(%ebp)
  802460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802463:	29 d0                	sub    %edx,%eax
  802465:	c1 e8 0c             	shr    $0xc,%eax
  802468:	83 ec 0c             	sub    $0xc,%esp
  80246b:	50                   	push   %eax
  80246c:	e8 d6 ef ff ff       	call   801447 <sbrk>
  802471:	83 c4 10             	add    $0x10,%esp
  802474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802477:	83 ec 0c             	sub    $0xc,%esp
  80247a:	6a 00                	push   $0x0
  80247c:	e8 c6 ef ff ff       	call   801447 <sbrk>
  802481:	83 c4 10             	add    $0x10,%esp
  802484:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80248d:	83 ec 08             	sub    $0x8,%esp
  802490:	50                   	push   %eax
  802491:	ff 75 e4             	pushl  -0x1c(%ebp)
  802494:	e8 5b fd ff ff       	call   8021f4 <initialize_dynamic_allocator>
  802499:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	68 7b 47 80 00       	push   $0x80477b
  8024a4:	e8 04 e2 ff ff       	call   8006ad <cprintf>
  8024a9:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b0:	75 0a                	jne    8024bc <alloc_block_FF+0xac>
	        return NULL;
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	e9 0e 04 00 00       	jmp    8028ca <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c3:	a1 30 50 80 00       	mov    0x805030,%eax
  8024c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cb:	e9 f3 02 00 00       	jmp    8027c3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	ff 75 bc             	pushl  -0x44(%ebp)
  8024dc:	e8 af fb ff ff       	call   802090 <get_block_size>
  8024e1:	83 c4 10             	add    $0x10,%esp
  8024e4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ea:	83 c0 08             	add    $0x8,%eax
  8024ed:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024f0:	0f 87 c5 02 00 00    	ja     8027bb <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	83 c0 18             	add    $0x18,%eax
  8024fc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ff:	0f 87 19 02 00 00    	ja     80271e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802505:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802508:	2b 45 08             	sub    0x8(%ebp),%eax
  80250b:	83 e8 08             	sub    $0x8,%eax
  80250e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	8d 50 08             	lea    0x8(%eax),%edx
  802517:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251a:	01 d0                	add    %edx,%eax
  80251c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	83 c0 08             	add    $0x8,%eax
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	6a 01                	push   $0x1
  80252a:	50                   	push   %eax
  80252b:	ff 75 bc             	pushl  -0x44(%ebp)
  80252e:	e8 ae fe ff ff       	call   8023e1 <set_block_data>
  802533:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	75 68                	jne    8025a8 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802540:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802544:	75 17                	jne    80255d <alloc_block_FF+0x14d>
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	68 58 47 80 00       	push   $0x804758
  80254e:	68 d7 00 00 00       	push   $0xd7
  802553:	68 3d 47 80 00       	push   $0x80473d
  802558:	e8 3f 16 00 00       	call   803b9c <_panic>
  80255d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802563:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802566:	89 10                	mov    %edx,(%eax)
  802568:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 0d                	je     80257e <alloc_block_FF+0x16e>
  802571:	a1 30 50 80 00       	mov    0x805030,%eax
  802576:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802579:	89 50 04             	mov    %edx,0x4(%eax)
  80257c:	eb 08                	jmp    802586 <alloc_block_FF+0x176>
  80257e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802581:	a3 34 50 80 00       	mov    %eax,0x805034
  802586:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802589:	a3 30 50 80 00       	mov    %eax,0x805030
  80258e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802591:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802598:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80259d:	40                   	inc    %eax
  80259e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025a3:	e9 dc 00 00 00       	jmp    802684 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	75 65                	jne    802616 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025b1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025b5:	75 17                	jne    8025ce <alloc_block_FF+0x1be>
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 8c 47 80 00       	push   $0x80478c
  8025bf:	68 db 00 00 00       	push   $0xdb
  8025c4:	68 3d 47 80 00       	push   $0x80473d
  8025c9:	e8 ce 15 00 00       	call   803b9c <_panic>
  8025ce:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8025d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d7:	89 50 04             	mov    %edx,0x4(%eax)
  8025da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 0c                	je     8025f0 <alloc_block_FF+0x1e0>
  8025e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	eb 08                	jmp    8025f8 <alloc_block_FF+0x1e8>
  8025f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802600:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802609:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80260e:	40                   	inc    %eax
  80260f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802614:	eb 6e                	jmp    802684 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	74 06                	je     802622 <alloc_block_FF+0x212>
  80261c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802620:	75 17                	jne    802639 <alloc_block_FF+0x229>
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	68 b0 47 80 00       	push   $0x8047b0
  80262a:	68 df 00 00 00       	push   $0xdf
  80262f:	68 3d 47 80 00       	push   $0x80473d
  802634:	e8 63 15 00 00       	call   803b9c <_panic>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 10                	mov    (%eax),%edx
  80263e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802641:	89 10                	mov    %edx,(%eax)
  802643:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 0b                	je     802657 <alloc_block_FF+0x247>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802654:	89 50 04             	mov    %edx,0x4(%eax)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80265d:	89 10                	mov    %edx,(%eax)
  80265f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802665:	89 50 04             	mov    %edx,0x4(%eax)
  802668:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	75 08                	jne    802679 <alloc_block_FF+0x269>
  802671:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802674:	a3 34 50 80 00       	mov    %eax,0x805034
  802679:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80267e:	40                   	inc    %eax
  80267f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802688:	75 17                	jne    8026a1 <alloc_block_FF+0x291>
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 1f 47 80 00       	push   $0x80471f
  802692:	68 e1 00 00 00       	push   $0xe1
  802697:	68 3d 47 80 00       	push   $0x80473d
  80269c:	e8 fb 14 00 00       	call   803b9c <_panic>
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 10                	je     8026ba <alloc_block_FF+0x2aa>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b2:	8b 52 04             	mov    0x4(%edx),%edx
  8026b5:	89 50 04             	mov    %edx,0x4(%eax)
  8026b8:	eb 0b                	jmp    8026c5 <alloc_block_FF+0x2b5>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	74 0f                	je     8026de <alloc_block_FF+0x2ce>
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 04             	mov    0x4(%eax),%eax
  8026d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d8:	8b 12                	mov    (%edx),%edx
  8026da:	89 10                	mov    %edx,(%eax)
  8026dc:	eb 0a                	jmp    8026e8 <alloc_block_FF+0x2d8>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802700:	48                   	dec    %eax
  802701:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	6a 00                	push   $0x0
  80270b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80270e:	ff 75 b0             	pushl  -0x50(%ebp)
  802711:	e8 cb fc ff ff       	call   8023e1 <set_block_data>
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	e9 95 00 00 00       	jmp    8027b3 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	6a 01                	push   $0x1
  802723:	ff 75 b8             	pushl  -0x48(%ebp)
  802726:	ff 75 bc             	pushl  -0x44(%ebp)
  802729:	e8 b3 fc ff ff       	call   8023e1 <set_block_data>
  80272e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	75 17                	jne    80274e <alloc_block_FF+0x33e>
  802737:	83 ec 04             	sub    $0x4,%esp
  80273a:	68 1f 47 80 00       	push   $0x80471f
  80273f:	68 e8 00 00 00       	push   $0xe8
  802744:	68 3d 47 80 00       	push   $0x80473d
  802749:	e8 4e 14 00 00       	call   803b9c <_panic>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 10                	je     802767 <alloc_block_FF+0x357>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275f:	8b 52 04             	mov    0x4(%edx),%edx
  802762:	89 50 04             	mov    %edx,0x4(%eax)
  802765:	eb 0b                	jmp    802772 <alloc_block_FF+0x362>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	a3 34 50 80 00       	mov    %eax,0x805034
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	74 0f                	je     80278b <alloc_block_FF+0x37b>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802785:	8b 12                	mov    (%edx),%edx
  802787:	89 10                	mov    %edx,(%eax)
  802789:	eb 0a                	jmp    802795 <alloc_block_FF+0x385>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	a3 30 50 80 00       	mov    %eax,0x805030
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027ad:	48                   	dec    %eax
  8027ae:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  8027b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027b6:	e9 0f 01 00 00       	jmp    8028ca <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8027c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c7:	74 07                	je     8027d0 <alloc_block_FF+0x3c0>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	eb 05                	jmp    8027d5 <alloc_block_FF+0x3c5>
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8027da:	a1 38 50 80 00       	mov    0x805038,%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	0f 85 e9 fc ff ff    	jne    8024d0 <alloc_block_FF+0xc0>
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	0f 85 df fc ff ff    	jne    8024d0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	83 c0 08             	add    $0x8,%eax
  8027f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027fa:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802801:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802804:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802807:	01 d0                	add    %edx,%eax
  802809:	48                   	dec    %eax
  80280a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80280d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802810:	ba 00 00 00 00       	mov    $0x0,%edx
  802815:	f7 75 d8             	divl   -0x28(%ebp)
  802818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281b:	29 d0                	sub    %edx,%eax
  80281d:	c1 e8 0c             	shr    $0xc,%eax
  802820:	83 ec 0c             	sub    $0xc,%esp
  802823:	50                   	push   %eax
  802824:	e8 1e ec ff ff       	call   801447 <sbrk>
  802829:	83 c4 10             	add    $0x10,%esp
  80282c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80282f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802833:	75 0a                	jne    80283f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
  80283a:	e9 8b 00 00 00       	jmp    8028ca <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80283f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802846:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802849:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284c:	01 d0                	add    %edx,%eax
  80284e:	48                   	dec    %eax
  80284f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802852:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802855:	ba 00 00 00 00       	mov    $0x0,%edx
  80285a:	f7 75 cc             	divl   -0x34(%ebp)
  80285d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802860:	29 d0                	sub    %edx,%eax
  802862:	8d 50 fc             	lea    -0x4(%eax),%edx
  802865:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802868:	01 d0                	add    %edx,%eax
  80286a:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  80286f:	a1 44 50 80 00       	mov    0x805044,%eax
  802874:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80287a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802881:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802884:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802887:	01 d0                	add    %edx,%eax
  802889:	48                   	dec    %eax
  80288a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80288d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802890:	ba 00 00 00 00       	mov    $0x0,%edx
  802895:	f7 75 c4             	divl   -0x3c(%ebp)
  802898:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80289b:	29 d0                	sub    %edx,%eax
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	6a 01                	push   $0x1
  8028a2:	50                   	push   %eax
  8028a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8028a6:	e8 36 fb ff ff       	call   8023e1 <set_block_data>
  8028ab:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028ae:	83 ec 0c             	sub    $0xc,%esp
  8028b1:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b4:	e8 1b 0a 00 00       	call   8032d4 <free_block>
  8028b9:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028bc:	83 ec 0c             	sub    $0xc,%esp
  8028bf:	ff 75 08             	pushl  0x8(%ebp)
  8028c2:	e8 49 fb ff ff       	call   802410 <alloc_block_FF>
  8028c7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028ca:	c9                   	leave  
  8028cb:	c3                   	ret    

008028cc <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	83 e0 01             	and    $0x1,%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 03                	je     8028df <alloc_block_BF+0x13>
  8028dc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028df:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028e3:	77 07                	ja     8028ec <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028e5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028ec:	a1 28 50 80 00       	mov    0x805028,%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	75 73                	jne    802968 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	83 c0 10             	add    $0x10,%eax
  8028fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028fe:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802905:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290b:	01 d0                	add    %edx,%eax
  80290d:	48                   	dec    %eax
  80290e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802911:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802914:	ba 00 00 00 00       	mov    $0x0,%edx
  802919:	f7 75 e0             	divl   -0x20(%ebp)
  80291c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291f:	29 d0                	sub    %edx,%eax
  802921:	c1 e8 0c             	shr    $0xc,%eax
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	50                   	push   %eax
  802928:	e8 1a eb ff ff       	call   801447 <sbrk>
  80292d:	83 c4 10             	add    $0x10,%esp
  802930:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	6a 00                	push   $0x0
  802938:	e8 0a eb ff ff       	call   801447 <sbrk>
  80293d:	83 c4 10             	add    $0x10,%esp
  802940:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802943:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802946:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802949:	83 ec 08             	sub    $0x8,%esp
  80294c:	50                   	push   %eax
  80294d:	ff 75 d8             	pushl  -0x28(%ebp)
  802950:	e8 9f f8 ff ff       	call   8021f4 <initialize_dynamic_allocator>
  802955:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802958:	83 ec 0c             	sub    $0xc,%esp
  80295b:	68 7b 47 80 00       	push   $0x80477b
  802960:	e8 48 dd ff ff       	call   8006ad <cprintf>
  802965:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80296f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802976:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80297d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802984:	a1 30 50 80 00       	mov    0x805030,%eax
  802989:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298c:	e9 1d 01 00 00       	jmp    802aae <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802997:	83 ec 0c             	sub    $0xc,%esp
  80299a:	ff 75 a8             	pushl  -0x58(%ebp)
  80299d:	e8 ee f6 ff ff       	call   802090 <get_block_size>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	83 c0 08             	add    $0x8,%eax
  8029ae:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b1:	0f 87 ef 00 00 00    	ja     802aa6 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	83 c0 18             	add    $0x18,%eax
  8029bd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c0:	77 1d                	ja     8029df <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c8:	0f 86 d8 00 00 00    	jbe    802aa6 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029da:	e9 c7 00 00 00       	jmp    802aa6 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	83 c0 08             	add    $0x8,%eax
  8029e5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e8:	0f 85 9d 00 00 00    	jne    802a8b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	6a 01                	push   $0x1
  8029f3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f9:	e8 e3 f9 ff ff       	call   8023e1 <set_block_data>
  8029fe:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a05:	75 17                	jne    802a1e <alloc_block_BF+0x152>
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 1f 47 80 00       	push   $0x80471f
  802a0f:	68 2c 01 00 00       	push   $0x12c
  802a14:	68 3d 47 80 00       	push   $0x80473d
  802a19:	e8 7e 11 00 00       	call   803b9c <_panic>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 10                	je     802a37 <alloc_block_BF+0x16b>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2f:	8b 52 04             	mov    0x4(%edx),%edx
  802a32:	89 50 04             	mov    %edx,0x4(%eax)
  802a35:	eb 0b                	jmp    802a42 <alloc_block_BF+0x176>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	a3 34 50 80 00       	mov    %eax,0x805034
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0f                	je     802a5b <alloc_block_BF+0x18f>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a55:	8b 12                	mov    (%edx),%edx
  802a57:	89 10                	mov    %edx,(%eax)
  802a59:	eb 0a                	jmp    802a65 <alloc_block_BF+0x199>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	a3 30 50 80 00       	mov    %eax,0x805030
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a78:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a7d:	48                   	dec    %eax
  802a7e:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802a83:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a86:	e9 24 04 00 00       	jmp    802eaf <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a91:	76 13                	jbe    802aa6 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a93:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a9a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802aa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aa6:	a1 38 50 80 00       	mov    0x805038,%eax
  802aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab2:	74 07                	je     802abb <alloc_block_BF+0x1ef>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	eb 05                	jmp    802ac0 <alloc_block_BF+0x1f4>
  802abb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac0:	a3 38 50 80 00       	mov    %eax,0x805038
  802ac5:	a1 38 50 80 00       	mov    0x805038,%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	0f 85 bf fe ff ff    	jne    802991 <alloc_block_BF+0xc5>
  802ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad6:	0f 85 b5 fe ff ff    	jne    802991 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae0:	0f 84 26 02 00 00    	je     802d0c <alloc_block_BF+0x440>
  802ae6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aea:	0f 85 1c 02 00 00    	jne    802d0c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	2b 45 08             	sub    0x8(%ebp),%eax
  802af6:	83 e8 08             	sub    $0x8,%eax
  802af9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8d 50 08             	lea    0x8(%eax),%edx
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	01 d0                	add    %edx,%eax
  802b07:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	83 c0 08             	add    $0x8,%eax
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	6a 01                	push   $0x1
  802b15:	50                   	push   %eax
  802b16:	ff 75 f0             	pushl  -0x10(%ebp)
  802b19:	e8 c3 f8 ff ff       	call   8023e1 <set_block_data>
  802b1e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 40 04             	mov    0x4(%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	75 68                	jne    802b93 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_BF+0x27c>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 58 47 80 00       	push   $0x804758
  802b39:	68 45 01 00 00       	push   $0x145
  802b3e:	68 3d 47 80 00       	push   $0x80473d
  802b43:	e8 54 10 00 00       	call   803b9c <_panic>
  802b48:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0d                	je     802b69 <alloc_block_BF+0x29d>
  802b5c:	a1 30 50 80 00       	mov    0x805030,%eax
  802b61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 08                	jmp    802b71 <alloc_block_BF+0x2a5>
  802b69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6c:	a3 34 50 80 00       	mov    %eax,0x805034
  802b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b74:	a3 30 50 80 00       	mov    %eax,0x805030
  802b79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b88:	40                   	inc    %eax
  802b89:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b8e:	e9 dc 00 00 00       	jmp    802c6f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	75 65                	jne    802c01 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_BF+0x2ed>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 8c 47 80 00       	push   $0x80478c
  802baa:	68 4a 01 00 00       	push   $0x14a
  802baf:	68 3d 47 80 00       	push   $0x80473d
  802bb4:	e8 e3 0f 00 00       	call   803b9c <_panic>
  802bb9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802bbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc2:	89 50 04             	mov    %edx,0x4(%eax)
  802bc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0c                	je     802bdb <alloc_block_BF+0x30f>
  802bcf:	a1 34 50 80 00       	mov    0x805034,%eax
  802bd4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bd7:	89 10                	mov    %edx,(%eax)
  802bd9:	eb 08                	jmp    802be3 <alloc_block_BF+0x317>
  802bdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bde:	a3 30 50 80 00       	mov    %eax,0x805030
  802be3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be6:	a3 34 50 80 00       	mov    %eax,0x805034
  802beb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bf9:	40                   	inc    %eax
  802bfa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bff:	eb 6e                	jmp    802c6f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c05:	74 06                	je     802c0d <alloc_block_BF+0x341>
  802c07:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c0b:	75 17                	jne    802c24 <alloc_block_BF+0x358>
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 b0 47 80 00       	push   $0x8047b0
  802c15:	68 4f 01 00 00       	push   $0x14f
  802c1a:	68 3d 47 80 00       	push   $0x80473d
  802c1f:	e8 78 0f 00 00       	call   803b9c <_panic>
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 10                	mov    (%eax),%edx
  802c29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2c:	89 10                	mov    %edx,(%eax)
  802c2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 0b                	je     802c42 <alloc_block_BF+0x376>
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c3f:	89 50 04             	mov    %edx,0x4(%eax)
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c48:	89 10                	mov    %edx,(%eax)
  802c4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c50:	89 50 04             	mov    %edx,0x4(%eax)
  802c53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	75 08                	jne    802c64 <alloc_block_BF+0x398>
  802c5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5f:	a3 34 50 80 00       	mov    %eax,0x805034
  802c64:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c69:	40                   	inc    %eax
  802c6a:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c73:	75 17                	jne    802c8c <alloc_block_BF+0x3c0>
  802c75:	83 ec 04             	sub    $0x4,%esp
  802c78:	68 1f 47 80 00       	push   $0x80471f
  802c7d:	68 51 01 00 00       	push   $0x151
  802c82:	68 3d 47 80 00       	push   $0x80473d
  802c87:	e8 10 0f 00 00       	call   803b9c <_panic>
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	74 10                	je     802ca5 <alloc_block_BF+0x3d9>
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9d:	8b 52 04             	mov    0x4(%edx),%edx
  802ca0:	89 50 04             	mov    %edx,0x4(%eax)
  802ca3:	eb 0b                	jmp    802cb0 <alloc_block_BF+0x3e4>
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 40 04             	mov    0x4(%eax),%eax
  802cab:	a3 34 50 80 00       	mov    %eax,0x805034
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 0f                	je     802cc9 <alloc_block_BF+0x3fd>
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc3:	8b 12                	mov    (%edx),%edx
  802cc5:	89 10                	mov    %edx,(%eax)
  802cc7:	eb 0a                	jmp    802cd3 <alloc_block_BF+0x407>
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ceb:	48                   	dec    %eax
  802cec:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	6a 00                	push   $0x0
  802cf6:	ff 75 d0             	pushl  -0x30(%ebp)
  802cf9:	ff 75 cc             	pushl  -0x34(%ebp)
  802cfc:	e8 e0 f6 ff ff       	call   8023e1 <set_block_data>
  802d01:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	e9 a3 01 00 00       	jmp    802eaf <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d0c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d10:	0f 85 9d 00 00 00    	jne    802db3 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	6a 01                	push   $0x1
  802d1b:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1e:	ff 75 f0             	pushl  -0x10(%ebp)
  802d21:	e8 bb f6 ff ff       	call   8023e1 <set_block_data>
  802d26:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2d:	75 17                	jne    802d46 <alloc_block_BF+0x47a>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 1f 47 80 00       	push   $0x80471f
  802d37:	68 58 01 00 00       	push   $0x158
  802d3c:	68 3d 47 80 00       	push   $0x80473d
  802d41:	e8 56 0e 00 00       	call   803b9c <_panic>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 10                	je     802d5f <alloc_block_BF+0x493>
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d57:	8b 52 04             	mov    0x4(%edx),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 0b                	jmp    802d6a <alloc_block_BF+0x49e>
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	a3 34 50 80 00       	mov    %eax,0x805034
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0f                	je     802d83 <alloc_block_BF+0x4b7>
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7d:	8b 12                	mov    (%edx),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	eb 0a                	jmp    802d8d <alloc_block_BF+0x4c1>
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	a3 30 50 80 00       	mov    %eax,0x805030
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802da5:	48                   	dec    %eax
  802da6:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	e9 fc 00 00 00       	jmp    802eaf <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	83 c0 08             	add    $0x8,%eax
  802db9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dbc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dc3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dc6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dc9:	01 d0                	add    %edx,%eax
  802dcb:	48                   	dec    %eax
  802dcc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dcf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd7:	f7 75 c4             	divl   -0x3c(%ebp)
  802dda:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ddd:	29 d0                	sub    %edx,%eax
  802ddf:	c1 e8 0c             	shr    $0xc,%eax
  802de2:	83 ec 0c             	sub    $0xc,%esp
  802de5:	50                   	push   %eax
  802de6:	e8 5c e6 ff ff       	call   801447 <sbrk>
  802deb:	83 c4 10             	add    $0x10,%esp
  802dee:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802df1:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802df5:	75 0a                	jne    802e01 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802df7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfc:	e9 ae 00 00 00       	jmp    802eaf <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e01:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e08:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e0b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e0e:	01 d0                	add    %edx,%eax
  802e10:	48                   	dec    %eax
  802e11:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e14:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e17:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1c:	f7 75 b8             	divl   -0x48(%ebp)
  802e1f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e22:	29 d0                	sub    %edx,%eax
  802e24:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e27:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e2a:	01 d0                	add    %edx,%eax
  802e2c:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802e31:	a1 44 50 80 00       	mov    0x805044,%eax
  802e36:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e3c:	83 ec 0c             	sub    $0xc,%esp
  802e3f:	68 e4 47 80 00       	push   $0x8047e4
  802e44:	e8 64 d8 ff ff       	call   8006ad <cprintf>
  802e49:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e4c:	83 ec 08             	sub    $0x8,%esp
  802e4f:	ff 75 bc             	pushl  -0x44(%ebp)
  802e52:	68 e9 47 80 00       	push   $0x8047e9
  802e57:	e8 51 d8 ff ff       	call   8006ad <cprintf>
  802e5c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e5f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e66:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	48                   	dec    %eax
  802e6f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e72:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e75:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7a:	f7 75 b0             	divl   -0x50(%ebp)
  802e7d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e80:	29 d0                	sub    %edx,%eax
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	6a 01                	push   $0x1
  802e87:	50                   	push   %eax
  802e88:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8b:	e8 51 f5 ff ff       	call   8023e1 <set_block_data>
  802e90:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 bc             	pushl  -0x44(%ebp)
  802e99:	e8 36 04 00 00       	call   8032d4 <free_block>
  802e9e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ea1:	83 ec 0c             	sub    $0xc,%esp
  802ea4:	ff 75 08             	pushl  0x8(%ebp)
  802ea7:	e8 20 fa ff ff       	call   8028cc <alloc_block_BF>
  802eac:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eaf:	c9                   	leave  
  802eb0:	c3                   	ret    

00802eb1 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802eb1:	55                   	push   %ebp
  802eb2:	89 e5                	mov    %esp,%ebp
  802eb4:	53                   	push   %ebx
  802eb5:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ebf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ec6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eca:	74 1e                	je     802eea <merging+0x39>
  802ecc:	ff 75 08             	pushl  0x8(%ebp)
  802ecf:	e8 bc f1 ff ff       	call   802090 <get_block_size>
  802ed4:	83 c4 04             	add    $0x4,%esp
  802ed7:	89 c2                	mov    %eax,%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	01 d0                	add    %edx,%eax
  802ede:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ee1:	75 07                	jne    802eea <merging+0x39>
		prev_is_free = 1;
  802ee3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eee:	74 1e                	je     802f0e <merging+0x5d>
  802ef0:	ff 75 10             	pushl  0x10(%ebp)
  802ef3:	e8 98 f1 ff ff       	call   802090 <get_block_size>
  802ef8:	83 c4 04             	add    $0x4,%esp
  802efb:	89 c2                	mov    %eax,%edx
  802efd:	8b 45 10             	mov    0x10(%ebp),%eax
  802f00:	01 d0                	add    %edx,%eax
  802f02:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f05:	75 07                	jne    802f0e <merging+0x5d>
		next_is_free = 1;
  802f07:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f12:	0f 84 cc 00 00 00    	je     802fe4 <merging+0x133>
  802f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1c:	0f 84 c2 00 00 00    	je     802fe4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f22:	ff 75 08             	pushl  0x8(%ebp)
  802f25:	e8 66 f1 ff ff       	call   802090 <get_block_size>
  802f2a:	83 c4 04             	add    $0x4,%esp
  802f2d:	89 c3                	mov    %eax,%ebx
  802f2f:	ff 75 10             	pushl  0x10(%ebp)
  802f32:	e8 59 f1 ff ff       	call   802090 <get_block_size>
  802f37:	83 c4 04             	add    $0x4,%esp
  802f3a:	01 c3                	add    %eax,%ebx
  802f3c:	ff 75 0c             	pushl  0xc(%ebp)
  802f3f:	e8 4c f1 ff ff       	call   802090 <get_block_size>
  802f44:	83 c4 04             	add    $0x4,%esp
  802f47:	01 d8                	add    %ebx,%eax
  802f49:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f4c:	6a 00                	push   $0x0
  802f4e:	ff 75 ec             	pushl  -0x14(%ebp)
  802f51:	ff 75 08             	pushl  0x8(%ebp)
  802f54:	e8 88 f4 ff ff       	call   8023e1 <set_block_data>
  802f59:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f60:	75 17                	jne    802f79 <merging+0xc8>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 1f 47 80 00       	push   $0x80471f
  802f6a:	68 7d 01 00 00       	push   $0x17d
  802f6f:	68 3d 47 80 00       	push   $0x80473d
  802f74:	e8 23 0c 00 00       	call   803b9c <_panic>
  802f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 10                	je     802f92 <merging+0xe1>
  802f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8a:	8b 52 04             	mov    0x4(%edx),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 0b                	jmp    802f9d <merging+0xec>
  802f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	a3 34 50 80 00       	mov    %eax,0x805034
  802f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0f                	je     802fb6 <merging+0x105>
  802fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb0:	8b 12                	mov    (%edx),%edx
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	eb 0a                	jmp    802fc0 <merging+0x10f>
  802fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fd8:	48                   	dec    %eax
  802fd9:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fde:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fdf:	e9 ea 02 00 00       	jmp    8032ce <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	74 3b                	je     803025 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fea:	83 ec 0c             	sub    $0xc,%esp
  802fed:	ff 75 08             	pushl  0x8(%ebp)
  802ff0:	e8 9b f0 ff ff       	call   802090 <get_block_size>
  802ff5:	83 c4 10             	add    $0x10,%esp
  802ff8:	89 c3                	mov    %eax,%ebx
  802ffa:	83 ec 0c             	sub    $0xc,%esp
  802ffd:	ff 75 10             	pushl  0x10(%ebp)
  803000:	e8 8b f0 ff ff       	call   802090 <get_block_size>
  803005:	83 c4 10             	add    $0x10,%esp
  803008:	01 d8                	add    %ebx,%eax
  80300a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	6a 00                	push   $0x0
  803012:	ff 75 e8             	pushl  -0x18(%ebp)
  803015:	ff 75 08             	pushl  0x8(%ebp)
  803018:	e8 c4 f3 ff ff       	call   8023e1 <set_block_data>
  80301d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803020:	e9 a9 02 00 00       	jmp    8032ce <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803025:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803029:	0f 84 2d 01 00 00    	je     80315c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80302f:	83 ec 0c             	sub    $0xc,%esp
  803032:	ff 75 10             	pushl  0x10(%ebp)
  803035:	e8 56 f0 ff ff       	call   802090 <get_block_size>
  80303a:	83 c4 10             	add    $0x10,%esp
  80303d:	89 c3                	mov    %eax,%ebx
  80303f:	83 ec 0c             	sub    $0xc,%esp
  803042:	ff 75 0c             	pushl  0xc(%ebp)
  803045:	e8 46 f0 ff ff       	call   802090 <get_block_size>
  80304a:	83 c4 10             	add    $0x10,%esp
  80304d:	01 d8                	add    %ebx,%eax
  80304f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	6a 00                	push   $0x0
  803057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305a:	ff 75 10             	pushl  0x10(%ebp)
  80305d:	e8 7f f3 ff ff       	call   8023e1 <set_block_data>
  803062:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803065:	8b 45 10             	mov    0x10(%ebp),%eax
  803068:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80306b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306f:	74 06                	je     803077 <merging+0x1c6>
  803071:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803075:	75 17                	jne    80308e <merging+0x1dd>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 f8 47 80 00       	push   $0x8047f8
  80307f:	68 8d 01 00 00       	push   $0x18d
  803084:	68 3d 47 80 00       	push   $0x80473d
  803089:	e8 0e 0b 00 00       	call   803b9c <_panic>
  80308e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803091:	8b 50 04             	mov    0x4(%eax),%edx
  803094:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a0:	89 10                	mov    %edx,(%eax)
  8030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	74 0d                	je     8030b9 <merging+0x208>
  8030ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b5:	89 10                	mov    %edx,(%eax)
  8030b7:	eb 08                	jmp    8030c1 <merging+0x210>
  8030b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030cf:	40                   	inc    %eax
  8030d0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8030d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030d9:	75 17                	jne    8030f2 <merging+0x241>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 1f 47 80 00       	push   $0x80471f
  8030e3:	68 8e 01 00 00       	push   $0x18e
  8030e8:	68 3d 47 80 00       	push   $0x80473d
  8030ed:	e8 aa 0a 00 00       	call   803b9c <_panic>
  8030f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 10                	je     80310b <merging+0x25a>
  8030fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	8b 55 0c             	mov    0xc(%ebp),%edx
  803103:	8b 52 04             	mov    0x4(%edx),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 0b                	jmp    803116 <merging+0x265>
  80310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	a3 34 50 80 00       	mov    %eax,0x805034
  803116:	8b 45 0c             	mov    0xc(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0f                	je     80312f <merging+0x27e>
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 0c             	mov    0xc(%ebp),%edx
  803129:	8b 12                	mov    (%edx),%edx
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	eb 0a                	jmp    803139 <merging+0x288>
  80312f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	a3 30 50 80 00       	mov    %eax,0x805030
  803139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803151:	48                   	dec    %eax
  803152:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803157:	e9 72 01 00 00       	jmp    8032ce <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80315c:	8b 45 10             	mov    0x10(%ebp),%eax
  80315f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803166:	74 79                	je     8031e1 <merging+0x330>
  803168:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316c:	74 73                	je     8031e1 <merging+0x330>
  80316e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803172:	74 06                	je     80317a <merging+0x2c9>
  803174:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803178:	75 17                	jne    803191 <merging+0x2e0>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 b0 47 80 00       	push   $0x8047b0
  803182:	68 94 01 00 00       	push   $0x194
  803187:	68 3d 47 80 00       	push   $0x80473d
  80318c:	e8 0b 0a 00 00       	call   803b9c <_panic>
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 10                	mov    (%eax),%edx
  803196:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803199:	89 10                	mov    %edx,(%eax)
  80319b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	85 c0                	test   %eax,%eax
  8031a2:	74 0b                	je     8031af <merging+0x2fe>
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ac:	89 50 04             	mov    %edx,0x4(%eax)
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b5:	89 10                	mov    %edx,(%eax)
  8031b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	75 08                	jne    8031d1 <merging+0x320>
  8031c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8031d1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031d6:	40                   	inc    %eax
  8031d7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031dc:	e9 ce 00 00 00       	jmp    8032af <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e5:	74 65                	je     80324c <merging+0x39b>
  8031e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031eb:	75 17                	jne    803204 <merging+0x353>
  8031ed:	83 ec 04             	sub    $0x4,%esp
  8031f0:	68 8c 47 80 00       	push   $0x80478c
  8031f5:	68 95 01 00 00       	push   $0x195
  8031fa:	68 3d 47 80 00       	push   $0x80473d
  8031ff:	e8 98 09 00 00       	call   803b9c <_panic>
  803204:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80320a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0c                	je     803226 <merging+0x375>
  80321a:	a1 34 50 80 00       	mov    0x805034,%eax
  80321f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803222:	89 10                	mov    %edx,(%eax)
  803224:	eb 08                	jmp    80322e <merging+0x37d>
  803226:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803229:	a3 30 50 80 00       	mov    %eax,0x805030
  80322e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803231:	a3 34 50 80 00       	mov    %eax,0x805034
  803236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803244:	40                   	inc    %eax
  803245:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80324a:	eb 63                	jmp    8032af <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80324c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803250:	75 17                	jne    803269 <merging+0x3b8>
  803252:	83 ec 04             	sub    $0x4,%esp
  803255:	68 58 47 80 00       	push   $0x804758
  80325a:	68 98 01 00 00       	push   $0x198
  80325f:	68 3d 47 80 00       	push   $0x80473d
  803264:	e8 33 09 00 00       	call   803b9c <_panic>
  803269:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80326f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803272:	89 10                	mov    %edx,(%eax)
  803274:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	85 c0                	test   %eax,%eax
  80327b:	74 0d                	je     80328a <merging+0x3d9>
  80327d:	a1 30 50 80 00       	mov    0x805030,%eax
  803282:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	eb 08                	jmp    803292 <merging+0x3e1>
  80328a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328d:	a3 34 50 80 00       	mov    %eax,0x805034
  803292:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803295:	a3 30 50 80 00       	mov    %eax,0x805030
  80329a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032a9:	40                   	inc    %eax
  8032aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8032af:	83 ec 0c             	sub    $0xc,%esp
  8032b2:	ff 75 10             	pushl  0x10(%ebp)
  8032b5:	e8 d6 ed ff ff       	call   802090 <get_block_size>
  8032ba:	83 c4 10             	add    $0x10,%esp
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	6a 00                	push   $0x0
  8032c2:	50                   	push   %eax
  8032c3:	ff 75 10             	pushl  0x10(%ebp)
  8032c6:	e8 16 f1 ff ff       	call   8023e1 <set_block_data>
  8032cb:	83 c4 10             	add    $0x10,%esp
	}
}
  8032ce:	90                   	nop
  8032cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d2:	c9                   	leave  
  8032d3:	c3                   	ret    

008032d4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032d4:	55                   	push   %ebp
  8032d5:	89 e5                	mov    %esp,%ebp
  8032d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032da:	a1 30 50 80 00       	mov    0x805030,%eax
  8032df:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032e2:	a1 34 50 80 00       	mov    0x805034,%eax
  8032e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ea:	73 1b                	jae    803307 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032ec:	a1 34 50 80 00       	mov    0x805034,%eax
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	6a 00                	push   $0x0
  8032f9:	50                   	push   %eax
  8032fa:	e8 b2 fb ff ff       	call   802eb1 <merging>
  8032ff:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803302:	e9 8b 00 00 00       	jmp    803392 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803307:	a1 30 50 80 00       	mov    0x805030,%eax
  80330c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330f:	76 18                	jbe    803329 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803311:	a1 30 50 80 00       	mov    0x805030,%eax
  803316:	83 ec 04             	sub    $0x4,%esp
  803319:	ff 75 08             	pushl  0x8(%ebp)
  80331c:	50                   	push   %eax
  80331d:	6a 00                	push   $0x0
  80331f:	e8 8d fb ff ff       	call   802eb1 <merging>
  803324:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803327:	eb 69                	jmp    803392 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803329:	a1 30 50 80 00       	mov    0x805030,%eax
  80332e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803331:	eb 39                	jmp    80336c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	3b 45 08             	cmp    0x8(%ebp),%eax
  803339:	73 29                	jae    803364 <free_block+0x90>
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	3b 45 08             	cmp    0x8(%ebp),%eax
  803343:	76 1f                	jbe    803364 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	ff 75 08             	pushl  0x8(%ebp)
  803353:	ff 75 f0             	pushl  -0x10(%ebp)
  803356:	ff 75 f4             	pushl  -0xc(%ebp)
  803359:	e8 53 fb ff ff       	call   802eb1 <merging>
  80335e:	83 c4 10             	add    $0x10,%esp
			break;
  803361:	90                   	nop
		}
	}
}
  803362:	eb 2e                	jmp    803392 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803364:	a1 38 50 80 00       	mov    0x805038,%eax
  803369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803370:	74 07                	je     803379 <free_block+0xa5>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 00                	mov    (%eax),%eax
  803377:	eb 05                	jmp    80337e <free_block+0xaa>
  803379:	b8 00 00 00 00       	mov    $0x0,%eax
  80337e:	a3 38 50 80 00       	mov    %eax,0x805038
  803383:	a1 38 50 80 00       	mov    0x805038,%eax
  803388:	85 c0                	test   %eax,%eax
  80338a:	75 a7                	jne    803333 <free_block+0x5f>
  80338c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803390:	75 a1                	jne    803333 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803392:	90                   	nop
  803393:	c9                   	leave  
  803394:	c3                   	ret    

00803395 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803395:	55                   	push   %ebp
  803396:	89 e5                	mov    %esp,%ebp
  803398:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80339b:	ff 75 08             	pushl  0x8(%ebp)
  80339e:	e8 ed ec ff ff       	call   802090 <get_block_size>
  8033a3:	83 c4 04             	add    $0x4,%esp
  8033a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033b0:	eb 17                	jmp    8033c9 <copy_data+0x34>
  8033b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b8:	01 c2                	add    %eax,%edx
  8033ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	01 c8                	add    %ecx,%eax
  8033c2:	8a 00                	mov    (%eax),%al
  8033c4:	88 02                	mov    %al,(%edx)
  8033c6:	ff 45 fc             	incl   -0x4(%ebp)
  8033c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033cf:	72 e1                	jb     8033b2 <copy_data+0x1d>
}
  8033d1:	90                   	nop
  8033d2:	c9                   	leave  
  8033d3:	c3                   	ret    

008033d4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033d4:	55                   	push   %ebp
  8033d5:	89 e5                	mov    %esp,%ebp
  8033d7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033de:	75 23                	jne    803403 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e4:	74 13                	je     8033f9 <realloc_block_FF+0x25>
  8033e6:	83 ec 0c             	sub    $0xc,%esp
  8033e9:	ff 75 0c             	pushl  0xc(%ebp)
  8033ec:	e8 1f f0 ff ff       	call   802410 <alloc_block_FF>
  8033f1:	83 c4 10             	add    $0x10,%esp
  8033f4:	e9 f4 06 00 00       	jmp    803aed <realloc_block_FF+0x719>
		return NULL;
  8033f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fe:	e9 ea 06 00 00       	jmp    803aed <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803403:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803407:	75 18                	jne    803421 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803409:	83 ec 0c             	sub    $0xc,%esp
  80340c:	ff 75 08             	pushl  0x8(%ebp)
  80340f:	e8 c0 fe ff ff       	call   8032d4 <free_block>
  803414:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803417:	b8 00 00 00 00       	mov    $0x0,%eax
  80341c:	e9 cc 06 00 00       	jmp    803aed <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803421:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803425:	77 07                	ja     80342e <realloc_block_FF+0x5a>
  803427:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80342e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803431:	83 e0 01             	and    $0x1,%eax
  803434:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343a:	83 c0 08             	add    $0x8,%eax
  80343d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803440:	83 ec 0c             	sub    $0xc,%esp
  803443:	ff 75 08             	pushl  0x8(%ebp)
  803446:	e8 45 ec ff ff       	call   802090 <get_block_size>
  80344b:	83 c4 10             	add    $0x10,%esp
  80344e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803454:	83 e8 08             	sub    $0x8,%eax
  803457:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	83 e8 04             	sub    $0x4,%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	83 e0 fe             	and    $0xfffffffe,%eax
  803465:	89 c2                	mov    %eax,%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	01 d0                	add    %edx,%eax
  80346c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80346f:	83 ec 0c             	sub    $0xc,%esp
  803472:	ff 75 e4             	pushl  -0x1c(%ebp)
  803475:	e8 16 ec ff ff       	call   802090 <get_block_size>
  80347a:	83 c4 10             	add    $0x10,%esp
  80347d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803483:	83 e8 08             	sub    $0x8,%eax
  803486:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80348f:	75 08                	jne    803499 <realloc_block_FF+0xc5>
	{
		 return va;
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	e9 54 06 00 00       	jmp    803aed <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80349f:	0f 83 e5 03 00 00    	jae    80388a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034ae:	83 ec 0c             	sub    $0xc,%esp
  8034b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b4:	e8 f0 eb ff ff       	call   8020a9 <is_free_block>
  8034b9:	83 c4 10             	add    $0x10,%esp
  8034bc:	84 c0                	test   %al,%al
  8034be:	0f 84 3b 01 00 00    	je     8035ff <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ca:	01 d0                	add    %edx,%eax
  8034cc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034cf:	83 ec 04             	sub    $0x4,%esp
  8034d2:	6a 01                	push   $0x1
  8034d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8034d7:	ff 75 08             	pushl  0x8(%ebp)
  8034da:	e8 02 ef ff ff       	call   8023e1 <set_block_data>
  8034df:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	83 e8 04             	sub    $0x4,%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8034ed:	89 c2                	mov    %eax,%edx
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	01 d0                	add    %edx,%eax
  8034f4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	6a 00                	push   $0x0
  8034fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8034ff:	ff 75 c8             	pushl  -0x38(%ebp)
  803502:	e8 da ee ff ff       	call   8023e1 <set_block_data>
  803507:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80350a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80350e:	74 06                	je     803516 <realloc_block_FF+0x142>
  803510:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803514:	75 17                	jne    80352d <realloc_block_FF+0x159>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 b0 47 80 00       	push   $0x8047b0
  80351e:	68 f6 01 00 00       	push   $0x1f6
  803523:	68 3d 47 80 00       	push   $0x80473d
  803528:	e8 6f 06 00 00       	call   803b9c <_panic>
  80352d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803530:	8b 10                	mov    (%eax),%edx
  803532:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803535:	89 10                	mov    %edx,(%eax)
  803537:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 0b                	je     80354b <realloc_block_FF+0x177>
  803540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803543:	8b 00                	mov    (%eax),%eax
  803545:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803548:	89 50 04             	mov    %edx,0x4(%eax)
  80354b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803551:	89 10                	mov    %edx,(%eax)
  803553:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803556:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803559:	89 50 04             	mov    %edx,0x4(%eax)
  80355c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80355f:	8b 00                	mov    (%eax),%eax
  803561:	85 c0                	test   %eax,%eax
  803563:	75 08                	jne    80356d <realloc_block_FF+0x199>
  803565:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803568:	a3 34 50 80 00       	mov    %eax,0x805034
  80356d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803572:	40                   	inc    %eax
  803573:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803578:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357c:	75 17                	jne    803595 <realloc_block_FF+0x1c1>
  80357e:	83 ec 04             	sub    $0x4,%esp
  803581:	68 1f 47 80 00       	push   $0x80471f
  803586:	68 f7 01 00 00       	push   $0x1f7
  80358b:	68 3d 47 80 00       	push   $0x80473d
  803590:	e8 07 06 00 00       	call   803b9c <_panic>
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 10                	je     8035ae <realloc_block_FF+0x1da>
  80359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a6:	8b 52 04             	mov    0x4(%edx),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	eb 0b                	jmp    8035b9 <realloc_block_FF+0x1e5>
  8035ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b1:	8b 40 04             	mov    0x4(%eax),%eax
  8035b4:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bc:	8b 40 04             	mov    0x4(%eax),%eax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	74 0f                	je     8035d2 <realloc_block_FF+0x1fe>
  8035c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cc:	8b 12                	mov    (%edx),%edx
  8035ce:	89 10                	mov    %edx,(%eax)
  8035d0:	eb 0a                	jmp    8035dc <realloc_block_FF+0x208>
  8035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8035dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035f4:	48                   	dec    %eax
  8035f5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035fa:	e9 83 02 00 00       	jmp    803882 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035ff:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803603:	0f 86 69 02 00 00    	jbe    803872 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803609:	83 ec 04             	sub    $0x4,%esp
  80360c:	6a 01                	push   $0x1
  80360e:	ff 75 f0             	pushl  -0x10(%ebp)
  803611:	ff 75 08             	pushl  0x8(%ebp)
  803614:	e8 c8 ed ff ff       	call   8023e1 <set_block_data>
  803619:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	83 e8 04             	sub    $0x4,%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	83 e0 fe             	and    $0xfffffffe,%eax
  803627:	89 c2                	mov    %eax,%edx
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	01 d0                	add    %edx,%eax
  80362e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803631:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803636:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803639:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80363d:	75 68                	jne    8036a7 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80363f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803643:	75 17                	jne    80365c <realloc_block_FF+0x288>
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	68 58 47 80 00       	push   $0x804758
  80364d:	68 06 02 00 00       	push   $0x206
  803652:	68 3d 47 80 00       	push   $0x80473d
  803657:	e8 40 05 00 00       	call   803b9c <_panic>
  80365c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803662:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803665:	89 10                	mov    %edx,(%eax)
  803667:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	74 0d                	je     80367d <realloc_block_FF+0x2a9>
  803670:	a1 30 50 80 00       	mov    0x805030,%eax
  803675:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803678:	89 50 04             	mov    %edx,0x4(%eax)
  80367b:	eb 08                	jmp    803685 <realloc_block_FF+0x2b1>
  80367d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803680:	a3 34 50 80 00       	mov    %eax,0x805034
  803685:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803688:	a3 30 50 80 00       	mov    %eax,0x805030
  80368d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803690:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803697:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80369c:	40                   	inc    %eax
  80369d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036a2:	e9 b0 01 00 00       	jmp    803857 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036af:	76 68                	jbe    803719 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b5:	75 17                	jne    8036ce <realloc_block_FF+0x2fa>
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	68 58 47 80 00       	push   $0x804758
  8036bf:	68 0b 02 00 00       	push   $0x20b
  8036c4:	68 3d 47 80 00       	push   $0x80473d
  8036c9:	e8 ce 04 00 00       	call   803b9c <_panic>
  8036ce:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d7:	89 10                	mov    %edx,(%eax)
  8036d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 0d                	je     8036ef <realloc_block_FF+0x31b>
  8036e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ea:	89 50 04             	mov    %edx,0x4(%eax)
  8036ed:	eb 08                	jmp    8036f7 <realloc_block_FF+0x323>
  8036ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803702:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803709:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80370e:	40                   	inc    %eax
  80370f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803714:	e9 3e 01 00 00       	jmp    803857 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803719:	a1 30 50 80 00       	mov    0x805030,%eax
  80371e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803721:	73 68                	jae    80378b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803723:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803727:	75 17                	jne    803740 <realloc_block_FF+0x36c>
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	68 8c 47 80 00       	push   $0x80478c
  803731:	68 10 02 00 00       	push   $0x210
  803736:	68 3d 47 80 00       	push   $0x80473d
  80373b:	e8 5c 04 00 00       	call   803b9c <_panic>
  803740:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803749:	89 50 04             	mov    %edx,0x4(%eax)
  80374c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 0c                	je     803762 <realloc_block_FF+0x38e>
  803756:	a1 34 50 80 00       	mov    0x805034,%eax
  80375b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80375e:	89 10                	mov    %edx,(%eax)
  803760:	eb 08                	jmp    80376a <realloc_block_FF+0x396>
  803762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803765:	a3 30 50 80 00       	mov    %eax,0x805030
  80376a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376d:	a3 34 50 80 00       	mov    %eax,0x805034
  803772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803780:	40                   	inc    %eax
  803781:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803786:	e9 cc 00 00 00       	jmp    803857 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80378b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803792:	a1 30 50 80 00       	mov    0x805030,%eax
  803797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80379a:	e9 8a 00 00 00       	jmp    803829 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80379f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a5:	73 7a                	jae    803821 <realloc_block_FF+0x44d>
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037af:	73 70                	jae    803821 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b5:	74 06                	je     8037bd <realloc_block_FF+0x3e9>
  8037b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037bb:	75 17                	jne    8037d4 <realloc_block_FF+0x400>
  8037bd:	83 ec 04             	sub    $0x4,%esp
  8037c0:	68 b0 47 80 00       	push   $0x8047b0
  8037c5:	68 1a 02 00 00       	push   $0x21a
  8037ca:	68 3d 47 80 00       	push   $0x80473d
  8037cf:	e8 c8 03 00 00       	call   803b9c <_panic>
  8037d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d7:	8b 10                	mov    (%eax),%edx
  8037d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037dc:	89 10                	mov    %edx,(%eax)
  8037de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 0b                	je     8037f2 <realloc_block_FF+0x41e>
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	8b 00                	mov    (%eax),%eax
  8037ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037ef:	89 50 04             	mov    %edx,0x4(%eax)
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f8:	89 10                	mov    %edx,(%eax)
  8037fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	75 08                	jne    803814 <realloc_block_FF+0x440>
  80380c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380f:	a3 34 50 80 00       	mov    %eax,0x805034
  803814:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803819:	40                   	inc    %eax
  80381a:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  80381f:	eb 36                	jmp    803857 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803821:	a1 38 50 80 00       	mov    0x805038,%eax
  803826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382d:	74 07                	je     803836 <realloc_block_FF+0x462>
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	eb 05                	jmp    80383b <realloc_block_FF+0x467>
  803836:	b8 00 00 00 00       	mov    $0x0,%eax
  80383b:	a3 38 50 80 00       	mov    %eax,0x805038
  803840:	a1 38 50 80 00       	mov    0x805038,%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	0f 85 52 ff ff ff    	jne    80379f <realloc_block_FF+0x3cb>
  80384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803851:	0f 85 48 ff ff ff    	jne    80379f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	6a 00                	push   $0x0
  80385c:	ff 75 d8             	pushl  -0x28(%ebp)
  80385f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803862:	e8 7a eb ff ff       	call   8023e1 <set_block_data>
  803867:	83 c4 10             	add    $0x10,%esp
				return va;
  80386a:	8b 45 08             	mov    0x8(%ebp),%eax
  80386d:	e9 7b 02 00 00       	jmp    803aed <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803872:	83 ec 0c             	sub    $0xc,%esp
  803875:	68 2d 48 80 00       	push   $0x80482d
  80387a:	e8 2e ce ff ff       	call   8006ad <cprintf>
  80387f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	e9 63 02 00 00       	jmp    803aed <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80388a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803890:	0f 86 4d 02 00 00    	jbe    803ae3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803896:	83 ec 0c             	sub    $0xc,%esp
  803899:	ff 75 e4             	pushl  -0x1c(%ebp)
  80389c:	e8 08 e8 ff ff       	call   8020a9 <is_free_block>
  8038a1:	83 c4 10             	add    $0x10,%esp
  8038a4:	84 c0                	test   %al,%al
  8038a6:	0f 84 37 02 00 00    	je     803ae3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038af:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038bb:	76 38                	jbe    8038f5 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038bd:	83 ec 0c             	sub    $0xc,%esp
  8038c0:	ff 75 08             	pushl  0x8(%ebp)
  8038c3:	e8 0c fa ff ff       	call   8032d4 <free_block>
  8038c8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038cb:	83 ec 0c             	sub    $0xc,%esp
  8038ce:	ff 75 0c             	pushl  0xc(%ebp)
  8038d1:	e8 3a eb ff ff       	call   802410 <alloc_block_FF>
  8038d6:	83 c4 10             	add    $0x10,%esp
  8038d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038dc:	83 ec 08             	sub    $0x8,%esp
  8038df:	ff 75 c0             	pushl  -0x40(%ebp)
  8038e2:	ff 75 08             	pushl  0x8(%ebp)
  8038e5:	e8 ab fa ff ff       	call   803395 <copy_data>
  8038ea:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038f0:	e9 f8 01 00 00       	jmp    803aed <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038fb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038fe:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803902:	0f 87 a0 00 00 00    	ja     8039a8 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80390c:	75 17                	jne    803925 <realloc_block_FF+0x551>
  80390e:	83 ec 04             	sub    $0x4,%esp
  803911:	68 1f 47 80 00       	push   $0x80471f
  803916:	68 38 02 00 00       	push   $0x238
  80391b:	68 3d 47 80 00       	push   $0x80473d
  803920:	e8 77 02 00 00       	call   803b9c <_panic>
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	8b 00                	mov    (%eax),%eax
  80392a:	85 c0                	test   %eax,%eax
  80392c:	74 10                	je     80393e <realloc_block_FF+0x56a>
  80392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803936:	8b 52 04             	mov    0x4(%edx),%edx
  803939:	89 50 04             	mov    %edx,0x4(%eax)
  80393c:	eb 0b                	jmp    803949 <realloc_block_FF+0x575>
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	a3 34 50 80 00       	mov    %eax,0x805034
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 40 04             	mov    0x4(%eax),%eax
  80394f:	85 c0                	test   %eax,%eax
  803951:	74 0f                	je     803962 <realloc_block_FF+0x58e>
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395c:	8b 12                	mov    (%edx),%edx
  80395e:	89 10                	mov    %edx,(%eax)
  803960:	eb 0a                	jmp    80396c <realloc_block_FF+0x598>
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	a3 30 50 80 00       	mov    %eax,0x805030
  80396c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803984:	48                   	dec    %eax
  803985:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80398a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80398d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803990:	01 d0                	add    %edx,%eax
  803992:	83 ec 04             	sub    $0x4,%esp
  803995:	6a 01                	push   $0x1
  803997:	50                   	push   %eax
  803998:	ff 75 08             	pushl  0x8(%ebp)
  80399b:	e8 41 ea ff ff       	call   8023e1 <set_block_data>
  8039a0:	83 c4 10             	add    $0x10,%esp
  8039a3:	e9 36 01 00 00       	jmp    803ade <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039ae:	01 d0                	add    %edx,%eax
  8039b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039b3:	83 ec 04             	sub    $0x4,%esp
  8039b6:	6a 01                	push   $0x1
  8039b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8039bb:	ff 75 08             	pushl  0x8(%ebp)
  8039be:	e8 1e ea ff ff       	call   8023e1 <set_block_data>
  8039c3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	83 e8 04             	sub    $0x4,%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	83 e0 fe             	and    $0xfffffffe,%eax
  8039d1:	89 c2                	mov    %eax,%edx
  8039d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d6:	01 d0                	add    %edx,%eax
  8039d8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039df:	74 06                	je     8039e7 <realloc_block_FF+0x613>
  8039e1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039e5:	75 17                	jne    8039fe <realloc_block_FF+0x62a>
  8039e7:	83 ec 04             	sub    $0x4,%esp
  8039ea:	68 b0 47 80 00       	push   $0x8047b0
  8039ef:	68 44 02 00 00       	push   $0x244
  8039f4:	68 3d 47 80 00       	push   $0x80473d
  8039f9:	e8 9e 01 00 00       	call   803b9c <_panic>
  8039fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a01:	8b 10                	mov    (%eax),%edx
  803a03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a06:	89 10                	mov    %edx,(%eax)
  803a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a0b:	8b 00                	mov    (%eax),%eax
  803a0d:	85 c0                	test   %eax,%eax
  803a0f:	74 0b                	je     803a1c <realloc_block_FF+0x648>
  803a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a14:	8b 00                	mov    (%eax),%eax
  803a16:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a19:	89 50 04             	mov    %edx,0x4(%eax)
  803a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a22:	89 10                	mov    %edx,(%eax)
  803a24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2a:	89 50 04             	mov    %edx,0x4(%eax)
  803a2d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a30:	8b 00                	mov    (%eax),%eax
  803a32:	85 c0                	test   %eax,%eax
  803a34:	75 08                	jne    803a3e <realloc_block_FF+0x66a>
  803a36:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a39:	a3 34 50 80 00       	mov    %eax,0x805034
  803a3e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a43:	40                   	inc    %eax
  803a44:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a4d:	75 17                	jne    803a66 <realloc_block_FF+0x692>
  803a4f:	83 ec 04             	sub    $0x4,%esp
  803a52:	68 1f 47 80 00       	push   $0x80471f
  803a57:	68 45 02 00 00       	push   $0x245
  803a5c:	68 3d 47 80 00       	push   $0x80473d
  803a61:	e8 36 01 00 00       	call   803b9c <_panic>
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	8b 00                	mov    (%eax),%eax
  803a6b:	85 c0                	test   %eax,%eax
  803a6d:	74 10                	je     803a7f <realloc_block_FF+0x6ab>
  803a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a77:	8b 52 04             	mov    0x4(%edx),%edx
  803a7a:	89 50 04             	mov    %edx,0x4(%eax)
  803a7d:	eb 0b                	jmp    803a8a <realloc_block_FF+0x6b6>
  803a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a82:	8b 40 04             	mov    0x4(%eax),%eax
  803a85:	a3 34 50 80 00       	mov    %eax,0x805034
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	8b 40 04             	mov    0x4(%eax),%eax
  803a90:	85 c0                	test   %eax,%eax
  803a92:	74 0f                	je     803aa3 <realloc_block_FF+0x6cf>
  803a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a97:	8b 40 04             	mov    0x4(%eax),%eax
  803a9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a9d:	8b 12                	mov    (%edx),%edx
  803a9f:	89 10                	mov    %edx,(%eax)
  803aa1:	eb 0a                	jmp    803aad <realloc_block_FF+0x6d9>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 00                	mov    (%eax),%eax
  803aa8:	a3 30 50 80 00       	mov    %eax,0x805030
  803aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ac5:	48                   	dec    %eax
  803ac6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803acb:	83 ec 04             	sub    $0x4,%esp
  803ace:	6a 00                	push   $0x0
  803ad0:	ff 75 bc             	pushl  -0x44(%ebp)
  803ad3:	ff 75 b8             	pushl  -0x48(%ebp)
  803ad6:	e8 06 e9 ff ff       	call   8023e1 <set_block_data>
  803adb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ade:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae1:	eb 0a                	jmp    803aed <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ae3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aed:	c9                   	leave  
  803aee:	c3                   	ret    

00803aef <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803aef:	55                   	push   %ebp
  803af0:	89 e5                	mov    %esp,%ebp
  803af2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803af5:	83 ec 04             	sub    $0x4,%esp
  803af8:	68 34 48 80 00       	push   $0x804834
  803afd:	68 58 02 00 00       	push   $0x258
  803b02:	68 3d 47 80 00       	push   $0x80473d
  803b07:	e8 90 00 00 00       	call   803b9c <_panic>

00803b0c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b0c:	55                   	push   %ebp
  803b0d:	89 e5                	mov    %esp,%ebp
  803b0f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b12:	83 ec 04             	sub    $0x4,%esp
  803b15:	68 5c 48 80 00       	push   $0x80485c
  803b1a:	68 61 02 00 00       	push   $0x261
  803b1f:	68 3d 47 80 00       	push   $0x80473d
  803b24:	e8 73 00 00 00       	call   803b9c <_panic>

00803b29 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803b29:	55                   	push   %ebp
  803b2a:	89 e5                	mov    %esp,%ebp
  803b2c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803b2f:	83 ec 04             	sub    $0x4,%esp
  803b32:	68 84 48 80 00       	push   $0x804884
  803b37:	6a 09                	push   $0x9
  803b39:	68 ac 48 80 00       	push   $0x8048ac
  803b3e:	e8 59 00 00 00       	call   803b9c <_panic>

00803b43 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803b43:	55                   	push   %ebp
  803b44:	89 e5                	mov    %esp,%ebp
  803b46:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803b49:	83 ec 04             	sub    $0x4,%esp
  803b4c:	68 bc 48 80 00       	push   $0x8048bc
  803b51:	6a 10                	push   $0x10
  803b53:	68 ac 48 80 00       	push   $0x8048ac
  803b58:	e8 3f 00 00 00       	call   803b9c <_panic>

00803b5d <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803b5d:	55                   	push   %ebp
  803b5e:	89 e5                	mov    %esp,%ebp
  803b60:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	68 e4 48 80 00       	push   $0x8048e4
  803b6b:	6a 18                	push   $0x18
  803b6d:	68 ac 48 80 00       	push   $0x8048ac
  803b72:	e8 25 00 00 00       	call   803b9c <_panic>

00803b77 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803b77:	55                   	push   %ebp
  803b78:	89 e5                	mov    %esp,%ebp
  803b7a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803b7d:	83 ec 04             	sub    $0x4,%esp
  803b80:	68 0c 49 80 00       	push   $0x80490c
  803b85:	6a 20                	push   $0x20
  803b87:	68 ac 48 80 00       	push   $0x8048ac
  803b8c:	e8 0b 00 00 00       	call   803b9c <_panic>

00803b91 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803b91:	55                   	push   %ebp
  803b92:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803b94:	8b 45 08             	mov    0x8(%ebp),%eax
  803b97:	8b 40 10             	mov    0x10(%eax),%eax
}
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    

00803b9c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803b9c:	55                   	push   %ebp
  803b9d:	89 e5                	mov    %esp,%ebp
  803b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  803ba5:	83 c0 04             	add    $0x4,%eax
  803ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803bab:	a1 60 90 18 01       	mov    0x1189060,%eax
  803bb0:	85 c0                	test   %eax,%eax
  803bb2:	74 16                	je     803bca <_panic+0x2e>
		cprintf("%s: ", argv0);
  803bb4:	a1 60 90 18 01       	mov    0x1189060,%eax
  803bb9:	83 ec 08             	sub    $0x8,%esp
  803bbc:	50                   	push   %eax
  803bbd:	68 34 49 80 00       	push   $0x804934
  803bc2:	e8 e6 ca ff ff       	call   8006ad <cprintf>
  803bc7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803bca:	a1 00 50 80 00       	mov    0x805000,%eax
  803bcf:	ff 75 0c             	pushl  0xc(%ebp)
  803bd2:	ff 75 08             	pushl  0x8(%ebp)
  803bd5:	50                   	push   %eax
  803bd6:	68 39 49 80 00       	push   $0x804939
  803bdb:	e8 cd ca ff ff       	call   8006ad <cprintf>
  803be0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803be3:	8b 45 10             	mov    0x10(%ebp),%eax
  803be6:	83 ec 08             	sub    $0x8,%esp
  803be9:	ff 75 f4             	pushl  -0xc(%ebp)
  803bec:	50                   	push   %eax
  803bed:	e8 50 ca ff ff       	call   800642 <vcprintf>
  803bf2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803bf5:	83 ec 08             	sub    $0x8,%esp
  803bf8:	6a 00                	push   $0x0
  803bfa:	68 55 49 80 00       	push   $0x804955
  803bff:	e8 3e ca ff ff       	call   800642 <vcprintf>
  803c04:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803c07:	e8 bf c9 ff ff       	call   8005cb <exit>

	// should not return here
	while (1) ;
  803c0c:	eb fe                	jmp    803c0c <_panic+0x70>

00803c0e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803c0e:	55                   	push   %ebp
  803c0f:	89 e5                	mov    %esp,%ebp
  803c11:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803c14:	a1 20 50 80 00       	mov    0x805020,%eax
  803c19:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c22:	39 c2                	cmp    %eax,%edx
  803c24:	74 14                	je     803c3a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803c26:	83 ec 04             	sub    $0x4,%esp
  803c29:	68 58 49 80 00       	push   $0x804958
  803c2e:	6a 26                	push   $0x26
  803c30:	68 a4 49 80 00       	push   $0x8049a4
  803c35:	e8 62 ff ff ff       	call   803b9c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803c3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803c41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c48:	e9 c5 00 00 00       	jmp    803d12 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c57:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5a:	01 d0                	add    %edx,%eax
  803c5c:	8b 00                	mov    (%eax),%eax
  803c5e:	85 c0                	test   %eax,%eax
  803c60:	75 08                	jne    803c6a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803c62:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803c65:	e9 a5 00 00 00       	jmp    803d0f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803c6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c78:	eb 69                	jmp    803ce3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c7a:	a1 20 50 80 00       	mov    0x805020,%eax
  803c7f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c88:	89 d0                	mov    %edx,%eax
  803c8a:	01 c0                	add    %eax,%eax
  803c8c:	01 d0                	add    %edx,%eax
  803c8e:	c1 e0 03             	shl    $0x3,%eax
  803c91:	01 c8                	add    %ecx,%eax
  803c93:	8a 40 04             	mov    0x4(%eax),%al
  803c96:	84 c0                	test   %al,%al
  803c98:	75 46                	jne    803ce0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  803c9f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ca5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ca8:	89 d0                	mov    %edx,%eax
  803caa:	01 c0                	add    %eax,%eax
  803cac:	01 d0                	add    %edx,%eax
  803cae:	c1 e0 03             	shl    $0x3,%eax
  803cb1:	01 c8                	add    %ecx,%eax
  803cb3:	8b 00                	mov    (%eax),%eax
  803cb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803cb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803cc0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccf:	01 c8                	add    %ecx,%eax
  803cd1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803cd3:	39 c2                	cmp    %eax,%edx
  803cd5:	75 09                	jne    803ce0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803cd7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803cde:	eb 15                	jmp    803cf5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ce0:	ff 45 e8             	incl   -0x18(%ebp)
  803ce3:	a1 20 50 80 00       	mov    0x805020,%eax
  803ce8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf1:	39 c2                	cmp    %eax,%edx
  803cf3:	77 85                	ja     803c7a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803cf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cf9:	75 14                	jne    803d0f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803cfb:	83 ec 04             	sub    $0x4,%esp
  803cfe:	68 b0 49 80 00       	push   $0x8049b0
  803d03:	6a 3a                	push   $0x3a
  803d05:	68 a4 49 80 00       	push   $0x8049a4
  803d0a:	e8 8d fe ff ff       	call   803b9c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803d0f:	ff 45 f0             	incl   -0x10(%ebp)
  803d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803d18:	0f 8c 2f ff ff ff    	jl     803c4d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803d1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803d2c:	eb 26                	jmp    803d54 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803d2e:	a1 20 50 80 00       	mov    0x805020,%eax
  803d33:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803d39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d3c:	89 d0                	mov    %edx,%eax
  803d3e:	01 c0                	add    %eax,%eax
  803d40:	01 d0                	add    %edx,%eax
  803d42:	c1 e0 03             	shl    $0x3,%eax
  803d45:	01 c8                	add    %ecx,%eax
  803d47:	8a 40 04             	mov    0x4(%eax),%al
  803d4a:	3c 01                	cmp    $0x1,%al
  803d4c:	75 03                	jne    803d51 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803d4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d51:	ff 45 e0             	incl   -0x20(%ebp)
  803d54:	a1 20 50 80 00       	mov    0x805020,%eax
  803d59:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803d5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d62:	39 c2                	cmp    %eax,%edx
  803d64:	77 c8                	ja     803d2e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d6c:	74 14                	je     803d82 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d6e:	83 ec 04             	sub    $0x4,%esp
  803d71:	68 04 4a 80 00       	push   $0x804a04
  803d76:	6a 44                	push   $0x44
  803d78:	68 a4 49 80 00       	push   $0x8049a4
  803d7d:	e8 1a fe ff ff       	call   803b9c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803d82:	90                   	nop
  803d83:	c9                   	leave  
  803d84:	c3                   	ret    
  803d85:	66 90                	xchg   %ax,%ax
  803d87:	90                   	nop

00803d88 <__udivdi3>:
  803d88:	55                   	push   %ebp
  803d89:	57                   	push   %edi
  803d8a:	56                   	push   %esi
  803d8b:	53                   	push   %ebx
  803d8c:	83 ec 1c             	sub    $0x1c,%esp
  803d8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d9f:	89 ca                	mov    %ecx,%edx
  803da1:	89 f8                	mov    %edi,%eax
  803da3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803da7:	85 f6                	test   %esi,%esi
  803da9:	75 2d                	jne    803dd8 <__udivdi3+0x50>
  803dab:	39 cf                	cmp    %ecx,%edi
  803dad:	77 65                	ja     803e14 <__udivdi3+0x8c>
  803daf:	89 fd                	mov    %edi,%ebp
  803db1:	85 ff                	test   %edi,%edi
  803db3:	75 0b                	jne    803dc0 <__udivdi3+0x38>
  803db5:	b8 01 00 00 00       	mov    $0x1,%eax
  803dba:	31 d2                	xor    %edx,%edx
  803dbc:	f7 f7                	div    %edi
  803dbe:	89 c5                	mov    %eax,%ebp
  803dc0:	31 d2                	xor    %edx,%edx
  803dc2:	89 c8                	mov    %ecx,%eax
  803dc4:	f7 f5                	div    %ebp
  803dc6:	89 c1                	mov    %eax,%ecx
  803dc8:	89 d8                	mov    %ebx,%eax
  803dca:	f7 f5                	div    %ebp
  803dcc:	89 cf                	mov    %ecx,%edi
  803dce:	89 fa                	mov    %edi,%edx
  803dd0:	83 c4 1c             	add    $0x1c,%esp
  803dd3:	5b                   	pop    %ebx
  803dd4:	5e                   	pop    %esi
  803dd5:	5f                   	pop    %edi
  803dd6:	5d                   	pop    %ebp
  803dd7:	c3                   	ret    
  803dd8:	39 ce                	cmp    %ecx,%esi
  803dda:	77 28                	ja     803e04 <__udivdi3+0x7c>
  803ddc:	0f bd fe             	bsr    %esi,%edi
  803ddf:	83 f7 1f             	xor    $0x1f,%edi
  803de2:	75 40                	jne    803e24 <__udivdi3+0x9c>
  803de4:	39 ce                	cmp    %ecx,%esi
  803de6:	72 0a                	jb     803df2 <__udivdi3+0x6a>
  803de8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dec:	0f 87 9e 00 00 00    	ja     803e90 <__udivdi3+0x108>
  803df2:	b8 01 00 00 00       	mov    $0x1,%eax
  803df7:	89 fa                	mov    %edi,%edx
  803df9:	83 c4 1c             	add    $0x1c,%esp
  803dfc:	5b                   	pop    %ebx
  803dfd:	5e                   	pop    %esi
  803dfe:	5f                   	pop    %edi
  803dff:	5d                   	pop    %ebp
  803e00:	c3                   	ret    
  803e01:	8d 76 00             	lea    0x0(%esi),%esi
  803e04:	31 ff                	xor    %edi,%edi
  803e06:	31 c0                	xor    %eax,%eax
  803e08:	89 fa                	mov    %edi,%edx
  803e0a:	83 c4 1c             	add    $0x1c,%esp
  803e0d:	5b                   	pop    %ebx
  803e0e:	5e                   	pop    %esi
  803e0f:	5f                   	pop    %edi
  803e10:	5d                   	pop    %ebp
  803e11:	c3                   	ret    
  803e12:	66 90                	xchg   %ax,%ax
  803e14:	89 d8                	mov    %ebx,%eax
  803e16:	f7 f7                	div    %edi
  803e18:	31 ff                	xor    %edi,%edi
  803e1a:	89 fa                	mov    %edi,%edx
  803e1c:	83 c4 1c             	add    $0x1c,%esp
  803e1f:	5b                   	pop    %ebx
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e29:	89 eb                	mov    %ebp,%ebx
  803e2b:	29 fb                	sub    %edi,%ebx
  803e2d:	89 f9                	mov    %edi,%ecx
  803e2f:	d3 e6                	shl    %cl,%esi
  803e31:	89 c5                	mov    %eax,%ebp
  803e33:	88 d9                	mov    %bl,%cl
  803e35:	d3 ed                	shr    %cl,%ebp
  803e37:	89 e9                	mov    %ebp,%ecx
  803e39:	09 f1                	or     %esi,%ecx
  803e3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e3f:	89 f9                	mov    %edi,%ecx
  803e41:	d3 e0                	shl    %cl,%eax
  803e43:	89 c5                	mov    %eax,%ebp
  803e45:	89 d6                	mov    %edx,%esi
  803e47:	88 d9                	mov    %bl,%cl
  803e49:	d3 ee                	shr    %cl,%esi
  803e4b:	89 f9                	mov    %edi,%ecx
  803e4d:	d3 e2                	shl    %cl,%edx
  803e4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e53:	88 d9                	mov    %bl,%cl
  803e55:	d3 e8                	shr    %cl,%eax
  803e57:	09 c2                	or     %eax,%edx
  803e59:	89 d0                	mov    %edx,%eax
  803e5b:	89 f2                	mov    %esi,%edx
  803e5d:	f7 74 24 0c          	divl   0xc(%esp)
  803e61:	89 d6                	mov    %edx,%esi
  803e63:	89 c3                	mov    %eax,%ebx
  803e65:	f7 e5                	mul    %ebp
  803e67:	39 d6                	cmp    %edx,%esi
  803e69:	72 19                	jb     803e84 <__udivdi3+0xfc>
  803e6b:	74 0b                	je     803e78 <__udivdi3+0xf0>
  803e6d:	89 d8                	mov    %ebx,%eax
  803e6f:	31 ff                	xor    %edi,%edi
  803e71:	e9 58 ff ff ff       	jmp    803dce <__udivdi3+0x46>
  803e76:	66 90                	xchg   %ax,%ax
  803e78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e7c:	89 f9                	mov    %edi,%ecx
  803e7e:	d3 e2                	shl    %cl,%edx
  803e80:	39 c2                	cmp    %eax,%edx
  803e82:	73 e9                	jae    803e6d <__udivdi3+0xe5>
  803e84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e87:	31 ff                	xor    %edi,%edi
  803e89:	e9 40 ff ff ff       	jmp    803dce <__udivdi3+0x46>
  803e8e:	66 90                	xchg   %ax,%ax
  803e90:	31 c0                	xor    %eax,%eax
  803e92:	e9 37 ff ff ff       	jmp    803dce <__udivdi3+0x46>
  803e97:	90                   	nop

00803e98 <__umoddi3>:
  803e98:	55                   	push   %ebp
  803e99:	57                   	push   %edi
  803e9a:	56                   	push   %esi
  803e9b:	53                   	push   %ebx
  803e9c:	83 ec 1c             	sub    $0x1c,%esp
  803e9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ea3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ea7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803eaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803eb7:	89 f3                	mov    %esi,%ebx
  803eb9:	89 fa                	mov    %edi,%edx
  803ebb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ebf:	89 34 24             	mov    %esi,(%esp)
  803ec2:	85 c0                	test   %eax,%eax
  803ec4:	75 1a                	jne    803ee0 <__umoddi3+0x48>
  803ec6:	39 f7                	cmp    %esi,%edi
  803ec8:	0f 86 a2 00 00 00    	jbe    803f70 <__umoddi3+0xd8>
  803ece:	89 c8                	mov    %ecx,%eax
  803ed0:	89 f2                	mov    %esi,%edx
  803ed2:	f7 f7                	div    %edi
  803ed4:	89 d0                	mov    %edx,%eax
  803ed6:	31 d2                	xor    %edx,%edx
  803ed8:	83 c4 1c             	add    $0x1c,%esp
  803edb:	5b                   	pop    %ebx
  803edc:	5e                   	pop    %esi
  803edd:	5f                   	pop    %edi
  803ede:	5d                   	pop    %ebp
  803edf:	c3                   	ret    
  803ee0:	39 f0                	cmp    %esi,%eax
  803ee2:	0f 87 ac 00 00 00    	ja     803f94 <__umoddi3+0xfc>
  803ee8:	0f bd e8             	bsr    %eax,%ebp
  803eeb:	83 f5 1f             	xor    $0x1f,%ebp
  803eee:	0f 84 ac 00 00 00    	je     803fa0 <__umoddi3+0x108>
  803ef4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ef9:	29 ef                	sub    %ebp,%edi
  803efb:	89 fe                	mov    %edi,%esi
  803efd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f01:	89 e9                	mov    %ebp,%ecx
  803f03:	d3 e0                	shl    %cl,%eax
  803f05:	89 d7                	mov    %edx,%edi
  803f07:	89 f1                	mov    %esi,%ecx
  803f09:	d3 ef                	shr    %cl,%edi
  803f0b:	09 c7                	or     %eax,%edi
  803f0d:	89 e9                	mov    %ebp,%ecx
  803f0f:	d3 e2                	shl    %cl,%edx
  803f11:	89 14 24             	mov    %edx,(%esp)
  803f14:	89 d8                	mov    %ebx,%eax
  803f16:	d3 e0                	shl    %cl,%eax
  803f18:	89 c2                	mov    %eax,%edx
  803f1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f1e:	d3 e0                	shl    %cl,%eax
  803f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f28:	89 f1                	mov    %esi,%ecx
  803f2a:	d3 e8                	shr    %cl,%eax
  803f2c:	09 d0                	or     %edx,%eax
  803f2e:	d3 eb                	shr    %cl,%ebx
  803f30:	89 da                	mov    %ebx,%edx
  803f32:	f7 f7                	div    %edi
  803f34:	89 d3                	mov    %edx,%ebx
  803f36:	f7 24 24             	mull   (%esp)
  803f39:	89 c6                	mov    %eax,%esi
  803f3b:	89 d1                	mov    %edx,%ecx
  803f3d:	39 d3                	cmp    %edx,%ebx
  803f3f:	0f 82 87 00 00 00    	jb     803fcc <__umoddi3+0x134>
  803f45:	0f 84 91 00 00 00    	je     803fdc <__umoddi3+0x144>
  803f4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f4f:	29 f2                	sub    %esi,%edx
  803f51:	19 cb                	sbb    %ecx,%ebx
  803f53:	89 d8                	mov    %ebx,%eax
  803f55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f59:	d3 e0                	shl    %cl,%eax
  803f5b:	89 e9                	mov    %ebp,%ecx
  803f5d:	d3 ea                	shr    %cl,%edx
  803f5f:	09 d0                	or     %edx,%eax
  803f61:	89 e9                	mov    %ebp,%ecx
  803f63:	d3 eb                	shr    %cl,%ebx
  803f65:	89 da                	mov    %ebx,%edx
  803f67:	83 c4 1c             	add    $0x1c,%esp
  803f6a:	5b                   	pop    %ebx
  803f6b:	5e                   	pop    %esi
  803f6c:	5f                   	pop    %edi
  803f6d:	5d                   	pop    %ebp
  803f6e:	c3                   	ret    
  803f6f:	90                   	nop
  803f70:	89 fd                	mov    %edi,%ebp
  803f72:	85 ff                	test   %edi,%edi
  803f74:	75 0b                	jne    803f81 <__umoddi3+0xe9>
  803f76:	b8 01 00 00 00       	mov    $0x1,%eax
  803f7b:	31 d2                	xor    %edx,%edx
  803f7d:	f7 f7                	div    %edi
  803f7f:	89 c5                	mov    %eax,%ebp
  803f81:	89 f0                	mov    %esi,%eax
  803f83:	31 d2                	xor    %edx,%edx
  803f85:	f7 f5                	div    %ebp
  803f87:	89 c8                	mov    %ecx,%eax
  803f89:	f7 f5                	div    %ebp
  803f8b:	89 d0                	mov    %edx,%eax
  803f8d:	e9 44 ff ff ff       	jmp    803ed6 <__umoddi3+0x3e>
  803f92:	66 90                	xchg   %ax,%ax
  803f94:	89 c8                	mov    %ecx,%eax
  803f96:	89 f2                	mov    %esi,%edx
  803f98:	83 c4 1c             	add    $0x1c,%esp
  803f9b:	5b                   	pop    %ebx
  803f9c:	5e                   	pop    %esi
  803f9d:	5f                   	pop    %edi
  803f9e:	5d                   	pop    %ebp
  803f9f:	c3                   	ret    
  803fa0:	3b 04 24             	cmp    (%esp),%eax
  803fa3:	72 06                	jb     803fab <__umoddi3+0x113>
  803fa5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fa9:	77 0f                	ja     803fba <__umoddi3+0x122>
  803fab:	89 f2                	mov    %esi,%edx
  803fad:	29 f9                	sub    %edi,%ecx
  803faf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fb3:	89 14 24             	mov    %edx,(%esp)
  803fb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fbe:	8b 14 24             	mov    (%esp),%edx
  803fc1:	83 c4 1c             	add    $0x1c,%esp
  803fc4:	5b                   	pop    %ebx
  803fc5:	5e                   	pop    %esi
  803fc6:	5f                   	pop    %edi
  803fc7:	5d                   	pop    %ebp
  803fc8:	c3                   	ret    
  803fc9:	8d 76 00             	lea    0x0(%esi),%esi
  803fcc:	2b 04 24             	sub    (%esp),%eax
  803fcf:	19 fa                	sbb    %edi,%edx
  803fd1:	89 d1                	mov    %edx,%ecx
  803fd3:	89 c6                	mov    %eax,%esi
  803fd5:	e9 71 ff ff ff       	jmp    803f4b <__umoddi3+0xb3>
  803fda:	66 90                	xchg   %ax,%ax
  803fdc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fe0:	72 ea                	jb     803fcc <__umoddi3+0x134>
  803fe2:	89 d9                	mov    %ebx,%ecx
  803fe4:	e9 62 ff ff ff       	jmp    803f4b <__umoddi3+0xb3>

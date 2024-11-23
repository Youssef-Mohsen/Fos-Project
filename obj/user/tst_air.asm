
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 1c 0b 00 00       	call   800b52 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	int envID = sys_getenvid();
  800044:	e8 91 24 00 00       	call   8024da <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  80007c:	bb d2 48 80 00       	mov    $0x8048d2,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb dc 48 80 00       	mov    $0x8048dc,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb e8 48 80 00       	mov    $0x8048e8,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb f7 48 80 00       	mov    $0x8048f7,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 06 49 80 00       	mov    $0x804906,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 1b 49 80 00       	mov    $0x80491b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 30 49 80 00       	mov    $0x804930,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 41 49 80 00       	mov    $0x804941,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 52 49 80 00       	mov    $0x804952,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 63 49 80 00       	mov    $0x804963,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 6c 49 80 00       	mov    $0x80496c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 76 49 80 00       	mov    $0x804976,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 81 49 80 00       	mov    $0x804981,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 8d 49 80 00       	mov    $0x80498d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 97 49 80 00       	mov    $0x804997,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9b fe ff ff 63 	movl   $0x72656c63,-0x165(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 9f fe ff ff 	movw   $0x6b,-0x161(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 8d fe ff ff    	lea    -0x173(%ebp),%eax
  8001f7:	bb a1 49 80 00       	mov    $0x8049a1,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb af 49 80 00       	mov    $0x8049af,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb be 49 80 00       	mov    $0x8049be,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb c5 49 80 00       	mov    $0x8049c5,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 66 ff ff ff    	lea    -0x9a(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 b2 1d 00 00       	call   80201b <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 d4 1c 00 00       	call   80201b <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 b2 1c 00 00       	call   80201b <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 91 1c 00 00       	call   80201b <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 70 1c 00 00       	call   80201b <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 4e 1c 00 00       	call   80201b <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 27 1c 00 00       	call   80201b <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 09 1c 00 00       	call   80201b <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 eb 1b 00 00       	call   80201b <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 d2 1b 00 00       	call   80201b <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 aa 1b 00 00       	call   80201b <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800486:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  80048c:	83 ec 04             	sub    $0x4,%esp
  80048f:	6a 01                	push   $0x1
  800491:	8d 95 ab fe ff ff    	lea    -0x155(%ebp),%edx
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	e8 2e 3e 00 00       	call   8042cc <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 13 3e 00 00       	call   8042cc <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 f8 3d 00 00       	call   8042cc <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 dd 3d 00 00       	call   8042cc <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 c2 3d 00 00       	call   8042cc <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 a7 3d 00 00       	call   8042cc <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 8c 3d 00 00       	call   8042cc <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 60 46 80 00       	push   $0x804660
  800554:	e8 c2 1a 00 00       	call   80201b <smalloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	int s=0;
  800562:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800569:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800570:	e9 9a 00 00 00       	jmp    80060f <_main+0x5d7>
	{
		char prefix[30]="cust_finished";
  800575:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  80057b:	bb cc 49 80 00       	mov    $0x8049cc,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 44 fe ff ff    	lea    -0x1bc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ae:	e8 d5 14 00 00       	call   801a88 <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ff fd ff ff    	lea    -0x201(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 31 fe ff ff    	lea    -0x1cf(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 36 fe ff ff    	lea    -0x1ca(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 8e 15 00 00       	call   801b61 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  8005d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8005e9:	8d 85 f4 fd ff ff    	lea    -0x20c(%ebp),%eax
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	6a 00                	push   $0x0
  8005f4:	8d 95 ff fd ff ff    	lea    -0x201(%ebp),%edx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 cb 3c 00 00       	call   8042cc <create_semaphore>
  800601:	83 c4 0c             	add    $0xc,%esp
  800604:	8b 85 f4 fd ff ff    	mov    -0x20c(%ebp),%eax
  80060a:	89 03                	mov    %eax,(%ebx)
	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  80060c:	ff 45 d8             	incl   -0x28(%ebp)
  80060f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800612:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800615:	0f 8c 5a ff ff ff    	jl     800575 <_main+0x53d>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80061b:	a1 20 60 80 00       	mov    0x806020,%eax
  800620:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800626:	a1 20 60 80 00       	mov    0x806020,%eax
  80062b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	a1 20 60 80 00       	mov    0x806020,%eax
  800638:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80063e:	52                   	push   %edx
  80063f:	51                   	push   %ecx
  800640:	50                   	push   %eax
  800641:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800647:	50                   	push   %eax
  800648:	e8 38 1e 00 00       	call   802485 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 3e 1e 00 00       	call   8024a3 <sys_run_env>
  800665:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800668:	a1 20 60 80 00       	mov    0x806020,%eax
  80066d:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800673:	a1 20 60 80 00       	mov    0x806020,%eax
  800678:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	a1 20 60 80 00       	mov    0x806020,%eax
  800685:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80068b:	52                   	push   %edx
  80068c:	51                   	push   %ecx
  80068d:	50                   	push   %eax
  80068e:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	e8 eb 1d 00 00       	call   802485 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 f1 1d 00 00       	call   8024a3 <sys_run_env>
  8006b2:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8006b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8006ba:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8006c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006c5:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8006d2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8006d8:	52                   	push   %edx
  8006d9:	51                   	push   %ecx
  8006da:	50                   	push   %eax
  8006db:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 9e 1d 00 00       	call   802485 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 a4 1d 00 00       	call   8024a3 <sys_run_env>
  8006ff:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800702:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800709:	eb 70                	jmp    80077b <_main+0x743>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80070b:	a1 20 60 80 00       	mov    0x806020,%eax
  800710:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800716:	a1 20 60 80 00       	mov    0x806020,%eax
  80071b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	a1 20 60 80 00       	mov    0x806020,%eax
  800728:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80072e:	52                   	push   %edx
  80072f:	51                   	push   %ecx
  800730:	50                   	push   %eax
  800731:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  800737:	50                   	push   %eax
  800738:	e8 48 1d 00 00       	call   802485 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 74 46 80 00       	push   $0x804674
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 ba 46 80 00       	push   $0x8046ba
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 2e 1d 00 00       	call   8024a3 <sys_run_env>
  800775:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800778:	ff 45 d4             	incl   -0x2c(%ebp)
  80077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800781:	7c 88                	jl     80070b <_main+0x6d3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  800783:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80078a:	eb 14                	jmp    8007a0 <_main+0x768>
	{
		wait_semaphore(custTerminated);
  80078c:	83 ec 0c             	sub    $0xc,%esp
  80078f:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800795:	e8 66 3b 00 00       	call   804300 <wait_semaphore>
  80079a:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80079d:	ff 45 d4             	incl   -0x2c(%ebp)
  8007a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007a3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8007a6:	7c e4                	jl     80078c <_main+0x754>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	68 dc 05 00 00       	push   $0x5dc
  8007b0:	e8 8a 3b 00 00       	call   80433f <env_sleep>
  8007b5:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  8007b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8007bf:	eb 45                	jmp    800806 <_main+0x7ce>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8007c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007cb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007ea:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ed:	01 c8                	add    %ecx,%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	52                   	push   %edx
  8007f5:	50                   	push   %eax
  8007f6:	68 cc 46 80 00       	push   $0x8046cc
  8007fb:	e8 4e 07 00 00       	call   800f4e <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800803:	ff 45 d0             	incl   -0x30(%ebp)
  800806:	8b 45 90             	mov    -0x70(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80080e:	7f b1                	jg     8007c1 <_main+0x789>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800810:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800817:	eb 45                	jmp    80085e <_main+0x826>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800823:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800831:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800834:	01 d0                	add    %edx,%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80083b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800842:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800845:	01 c8                	add    %ecx,%eax
  800847:	8b 00                	mov    (%eax),%eax
  800849:	83 ec 04             	sub    $0x4,%esp
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	68 fc 46 80 00       	push   $0x8046fc
  800853:	e8 f6 06 00 00       	call   800f4e <cprintf>
  800858:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80085b:	ff 45 d0             	incl   -0x30(%ebp)
  80085e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800866:	7f b1                	jg     800819 <_main+0x7e1>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  800868:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  80086f:	eb 33                	jmp    8008a4 <_main+0x86c>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	ff 75 cc             	pushl  -0x34(%ebp)
  800877:	ff 75 a8             	pushl  -0x58(%ebp)
  80087a:	ff 75 88             	pushl  -0x78(%ebp)
  80087d:	e8 8b 02 00 00       	call   800b0d <find>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	83 f8 01             	cmp    $0x1,%eax
  800888:	74 17                	je     8008a1 <_main+0x869>
			{
				panic("Error, wrong booking for user %d\n", f1);
  80088a:	ff 75 cc             	pushl  -0x34(%ebp)
  80088d:	68 2c 47 80 00       	push   $0x80472c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 ba 46 80 00       	push   $0x8046ba
  80089c:	e8 f0 03 00 00       	call   800c91 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8008a1:	ff 45 cc             	incl   -0x34(%ebp)
  8008a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008a7:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8008aa:	7c c5                	jl     800871 <_main+0x839>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  8008ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8008af:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8008b2:	eb 33                	jmp    8008e7 <_main+0x8af>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8008ba:	ff 75 a4             	pushl  -0x5c(%ebp)
  8008bd:	ff 75 84             	pushl  -0x7c(%ebp)
  8008c0:	e8 48 02 00 00       	call   800b0d <find>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	83 f8 01             	cmp    $0x1,%eax
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
			{
				panic("Error, wrong booking for user %d\n", f2);
  8008cd:	ff 75 c8             	pushl  -0x38(%ebp)
  8008d0:	68 2c 47 80 00       	push   $0x80472c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 ba 46 80 00       	push   $0x8046ba
  8008df:	e8 ad 03 00 00       	call   800c91 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8008e4:	ff 45 c8             	incl   -0x38(%ebp)
  8008e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8008ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008ed:	01 d0                	add    %edx,%eax
  8008ef:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8008f2:	7f c0                	jg     8008b4 <_main+0x87c>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  8008f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8008f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8008fa:	eb 4c                	jmp    800948 <_main+0x910>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  8008fc:	83 ec 04             	sub    $0x4,%esp
  8008ff:	ff 75 c4             	pushl  -0x3c(%ebp)
  800902:	ff 75 a8             	pushl  -0x58(%ebp)
  800905:	ff 75 88             	pushl  -0x78(%ebp)
  800908:	e8 00 02 00 00       	call   800b0d <find>
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	83 f8 01             	cmp    $0x1,%eax
  800913:	75 19                	jne    80092e <_main+0x8f6>
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	ff 75 c4             	pushl  -0x3c(%ebp)
  80091b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80091e:	ff 75 84             	pushl  -0x7c(%ebp)
  800921:	e8 e7 01 00 00       	call   800b0d <find>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	83 f8 01             	cmp    $0x1,%eax
  80092c:	74 17                	je     800945 <_main+0x90d>
			{
				panic("Error, wrong booking for user %d\n", f3);
  80092e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800931:	68 2c 47 80 00       	push   $0x80472c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 ba 46 80 00       	push   $0x8046ba
  800940:	e8 4c 03 00 00       	call   800c91 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800945:	ff 45 c4             	incl   -0x3c(%ebp)
  800948:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80094b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80094e:	01 d0                	add    %edx,%eax
  800950:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800953:	7f a7                	jg     8008fc <_main+0x8c4>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(semaphore_count(flight1CS) == 1);
  800955:	83 ec 0c             	sub    $0xc,%esp
  800958:	ff b5 6c fe ff ff    	pushl  -0x194(%ebp)
  80095e:	e8 d1 39 00 00       	call   804334 <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 50 47 80 00       	push   $0x804750
  800970:	68 70 47 80 00       	push   $0x804770
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 ba 46 80 00       	push   $0x8046ba
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 a2 39 00 00       	call   804334 <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 88 47 80 00       	push   $0x804788
  80099f:	68 70 47 80 00       	push   $0x804770
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 ba 46 80 00       	push   $0x8046ba
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 73 39 00 00       	call   804334 <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 a8 47 80 00       	push   $0x8047a8
  8009ce:	68 70 47 80 00       	push   $0x804770
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 ba 46 80 00       	push   $0x8046ba
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 44 39 00 00       	call   804334 <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 cc 47 80 00       	push   $0x8047cc
  8009fd:	68 70 47 80 00       	push   $0x804770
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 ba 46 80 00       	push   $0x8046ba
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 15 39 00 00       	call   804334 <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 ee 47 80 00       	push   $0x8047ee
  800a2c:	68 70 47 80 00       	push   $0x804770
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 ba 46 80 00       	push   $0x8046ba
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 e6 38 00 00       	call   804334 <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 0c 48 80 00       	push   $0x80480c
  800a5b:	68 70 47 80 00       	push   $0x804770
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 ba 46 80 00       	push   $0x8046ba
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 b7 38 00 00       	call   804334 <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 30 48 80 00       	push   $0x804830
  800a89:	68 70 47 80 00       	push   $0x804770
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 ba 46 80 00       	push   $0x8046ba
  800a98:	e8 f4 01 00 00       	call   800c91 <_panic>

		int s=0;
  800a9d:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800aa4:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800aab:	eb 3f                	jmp    800aec <_main+0xab4>
//			char prefix[30]="cust_finished";
//			char id[5]; char cust_finishedSemaphoreName[50];
//			ltostr(s, id);
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
  800aad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ab0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ab7:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
  800abf:	83 ec 0c             	sub    $0xc,%esp
  800ac2:	ff 30                	pushl  (%eax)
  800ac4:	e8 6b 38 00 00       	call   804334 <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 58 48 80 00       	push   $0x804858
  800ad5:	68 70 47 80 00       	push   $0x804770
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 ba 46 80 00       	push   $0x8046ba
  800ae4:	e8 a8 01 00 00       	call   800c91 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ae9:	ff 45 c0             	incl   -0x40(%ebp)
  800aec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aef:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800af2:	7c b9                	jl     800aad <_main+0xa75>
//			strcconcat(prefix, id, cust_finishedSemaphoreName);
//			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800af4:	83 ec 0c             	sub    $0xc,%esp
  800af7:	68 80 48 80 00       	push   $0x804880
  800afc:	e8 4d 04 00 00       	call   800f4e <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	}

}
  800b04:	90                   	nop
  800b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <find>:


int find(int* arr, int size, int val)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b21:	eb 22                	jmp    800b45 <find+0x38>
	{
		if(arr[i] == val)
  800b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	01 d0                	add    %edx,%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b37:	75 09                	jne    800b42 <find+0x35>
		{
			result = 1;
  800b39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b40:	eb 0b                	jmp    800b4d <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b42:	ff 45 f8             	incl   -0x8(%ebp)
  800b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b4b:	7c d6                	jl     800b23 <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b58:	e8 96 19 00 00       	call   8024f3 <sys_getenvindex>
  800b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	89 d0                	mov    %edx,%eax
  800b65:	c1 e0 03             	shl    $0x3,%eax
  800b68:	01 d0                	add    %edx,%eax
  800b6a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b71:	01 c8                	add    %ecx,%eax
  800b73:	01 c0                	add    %eax,%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b7e:	01 c8                	add    %ecx,%eax
  800b80:	01 d0                	add    %edx,%eax
  800b82:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b87:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b8c:	a1 20 60 80 00       	mov    0x806020,%eax
  800b91:	8a 40 20             	mov    0x20(%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	74 0d                	je     800ba5 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800b98:	a1 20 60 80 00       	mov    0x806020,%eax
  800b9d:	83 c0 20             	add    $0x20,%eax
  800ba0:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ba5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba9:	7e 0a                	jle    800bb5 <libmain+0x63>
		binaryname = argv[0];
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	8b 00                	mov    (%eax),%eax
  800bb0:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	ff 75 08             	pushl  0x8(%ebp)
  800bbe:	e8 75 f4 ff ff       	call   800038 <_main>
  800bc3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800bc6:	e8 ac 16 00 00       	call   802277 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 04 4a 80 00       	push   $0x804a04
  800bd3:	e8 76 03 00 00       	call   800f4e <cprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bdb:	a1 20 60 80 00       	mov    0x806020,%eax
  800be0:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800be6:	a1 20 60 80 00       	mov    0x806020,%eax
  800beb:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	68 2c 4a 80 00       	push   $0x804a2c
  800bfb:	e8 4e 03 00 00       	call   800f4e <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c03:	a1 20 60 80 00       	mov    0x806020,%eax
  800c08:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800c0e:	a1 20 60 80 00       	mov    0x806020,%eax
  800c13:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800c19:	a1 20 60 80 00       	mov    0x806020,%eax
  800c1e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800c24:	51                   	push   %ecx
  800c25:	52                   	push   %edx
  800c26:	50                   	push   %eax
  800c27:	68 54 4a 80 00       	push   $0x804a54
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 ac 4a 80 00       	push   $0x804aac
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 04 4a 80 00       	push   $0x804a04
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 2c 16 00 00       	call   802291 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800c65:	e8 19 00 00 00       	call   800c83 <exit>
}
  800c6a:	90                   	nop
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	6a 00                	push   $0x0
  800c78:	e8 42 18 00 00       	call   8024bf <sys_destroy_env>
  800c7d:	83 c4 10             	add    $0x10,%esp
}
  800c80:	90                   	nop
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <exit>:

void
exit(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c89:	e8 97 18 00 00       	call   802525 <sys_exit_env>
}
  800c8e:	90                   	nop
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c97:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ca0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	74 16                	je     800cbf <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ca9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	50                   	push   %eax
  800cb2:	68 c0 4a 80 00       	push   $0x804ac0
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 c5 4a 80 00       	push   $0x804ac5
  800cd0:	e8 79 02 00 00       	call   800f4e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce1:	50                   	push   %eax
  800ce2:	e8 fc 01 00 00       	call   800ee3 <vcprintf>
  800ce7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	6a 00                	push   $0x0
  800cef:	68 e1 4a 80 00       	push   $0x804ae1
  800cf4:	e8 ea 01 00 00       	call   800ee3 <vcprintf>
  800cf9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cfc:	e8 82 ff ff ff       	call   800c83 <exit>

	// should not return here
	while (1) ;
  800d01:	eb fe                	jmp    800d01 <_panic+0x70>

00800d03 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d09:	a1 20 60 80 00       	mov    0x806020,%eax
  800d0e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	39 c2                	cmp    %eax,%edx
  800d19:	74 14                	je     800d2f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d1b:	83 ec 04             	sub    $0x4,%esp
  800d1e:	68 e4 4a 80 00       	push   $0x804ae4
  800d23:	6a 26                	push   $0x26
  800d25:	68 30 4b 80 00       	push   $0x804b30
  800d2a:	e8 62 ff ff ff       	call   800c91 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d3d:	e9 c5 00 00 00       	jmp    800e07 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	85 c0                	test   %eax,%eax
  800d55:	75 08                	jne    800d5f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800d57:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d5a:	e9 a5 00 00 00       	jmp    800e04 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800d5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d6d:	eb 69                	jmp    800dd8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d6f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d74:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d7d:	89 d0                	mov    %edx,%eax
  800d7f:	01 c0                	add    %eax,%eax
  800d81:	01 d0                	add    %edx,%eax
  800d83:	c1 e0 03             	shl    $0x3,%eax
  800d86:	01 c8                	add    %ecx,%eax
  800d88:	8a 40 04             	mov    0x4(%eax),%al
  800d8b:	84 c0                	test   %al,%al
  800d8d:	75 46                	jne    800dd5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d8f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d94:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d9d:	89 d0                	mov    %edx,%eax
  800d9f:	01 c0                	add    %eax,%eax
  800da1:	01 d0                	add    %edx,%eax
  800da3:	c1 e0 03             	shl    $0x3,%eax
  800da6:	01 c8                	add    %ecx,%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	01 c8                	add    %ecx,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	75 09                	jne    800dd5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800dcc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dd3:	eb 15                	jmp    800dea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dd5:	ff 45 e8             	incl   -0x18(%ebp)
  800dd8:	a1 20 60 80 00       	mov    0x806020,%eax
  800ddd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800de6:	39 c2                	cmp    %eax,%edx
  800de8:	77 85                	ja     800d6f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dee:	75 14                	jne    800e04 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800df0:	83 ec 04             	sub    $0x4,%esp
  800df3:	68 3c 4b 80 00       	push   $0x804b3c
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 30 4b 80 00       	push   $0x804b30
  800dff:	e8 8d fe ff ff       	call   800c91 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e04:	ff 45 f0             	incl   -0x10(%ebp)
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e0d:	0f 8c 2f ff ff ff    	jl     800d42 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e21:	eb 26                	jmp    800e49 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e23:	a1 20 60 80 00       	mov    0x806020,%eax
  800e28:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800e2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8a 40 04             	mov    0x4(%eax),%al
  800e3f:	3c 01                	cmp    $0x1,%al
  800e41:	75 03                	jne    800e46 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800e43:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e46:	ff 45 e0             	incl   -0x20(%ebp)
  800e49:	a1 20 60 80 00       	mov    0x806020,%eax
  800e4e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e57:	39 c2                	cmp    %eax,%edx
  800e59:	77 c8                	ja     800e23 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e61:	74 14                	je     800e77 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	68 90 4b 80 00       	push   $0x804b90
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 30 4b 80 00       	push   $0x804b30
  800e72:	e8 1a fe ff ff       	call   800c91 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e77:	90                   	nop
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	8d 48 01             	lea    0x1(%eax),%ecx
  800e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8b:	89 0a                	mov    %ecx,(%edx)
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	88 d1                	mov    %dl,%cl
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	8b 00                	mov    (%eax),%eax
  800e9e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ea3:	75 2c                	jne    800ed1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ea5:	a0 28 60 80 00       	mov    0x806028,%al
  800eaa:	0f b6 c0             	movzbl %al,%eax
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	8b 12                	mov    (%edx),%edx
  800eb2:	89 d1                	mov    %edx,%ecx
  800eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb7:	83 c2 08             	add    $0x8,%edx
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	50                   	push   %eax
  800ebe:	51                   	push   %ecx
  800ebf:	52                   	push   %edx
  800ec0:	e8 70 13 00 00       	call   802235 <sys_cputs>
  800ec5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8b 40 04             	mov    0x4(%eax),%eax
  800ed7:	8d 50 01             	lea    0x1(%eax),%edx
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ee0:	90                   	nop
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800eec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ef3:	00 00 00 
	b.cnt = 0;
  800ef6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800efd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f00:	ff 75 0c             	pushl  0xc(%ebp)
  800f03:	ff 75 08             	pushl  0x8(%ebp)
  800f06:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f0c:	50                   	push   %eax
  800f0d:	68 7a 0e 80 00       	push   $0x800e7a
  800f12:	e8 11 02 00 00       	call   801128 <vprintfmt>
  800f17:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f1a:	a0 28 60 80 00       	mov    0x806028,%al
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f28:	83 ec 04             	sub    $0x4,%esp
  800f2b:	50                   	push   %eax
  800f2c:	52                   	push   %edx
  800f2d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f33:	83 c0 08             	add    $0x8,%eax
  800f36:	50                   	push   %eax
  800f37:	e8 f9 12 00 00       	call   802235 <sys_cputs>
  800f3c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f3f:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  800f46:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f54:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  800f5b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	83 ec 08             	sub    $0x8,%esp
  800f67:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6a:	50                   	push   %eax
  800f6b:	e8 73 ff ff ff       	call   800ee3 <vcprintf>
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f81:	e8 f1 12 00 00       	call   802277 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f86:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 f4             	pushl  -0xc(%ebp)
  800f95:	50                   	push   %eax
  800f96:	e8 48 ff ff ff       	call   800ee3 <vcprintf>
  800f9b:	83 c4 10             	add    $0x10,%esp
  800f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800fa1:	e8 eb 12 00 00       	call   802291 <sys_unlock_cons>
	return cnt;
  800fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	53                   	push   %ebx
  800faf:	83 ec 14             	sub    $0x14,%esp
  800fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fbe:	8b 45 18             	mov    0x18(%ebp),%eax
  800fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fc9:	77 55                	ja     801020 <printnum+0x75>
  800fcb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fce:	72 05                	jb     800fd5 <printnum+0x2a>
  800fd0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd3:	77 4b                	ja     801020 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fd5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fd8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fdb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fde:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe8:	ff 75 f0             	pushl  -0x10(%ebp)
  800feb:	e8 04 34 00 00       	call   8043f4 <__udivdi3>
  800ff0:	83 c4 10             	add    $0x10,%esp
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	ff 75 20             	pushl  0x20(%ebp)
  800ff9:	53                   	push   %ebx
  800ffa:	ff 75 18             	pushl  0x18(%ebp)
  800ffd:	52                   	push   %edx
  800ffe:	50                   	push   %eax
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 08             	pushl  0x8(%ebp)
  801005:	e8 a1 ff ff ff       	call   800fab <printnum>
  80100a:	83 c4 20             	add    $0x20,%esp
  80100d:	eb 1a                	jmp    801029 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80100f:	83 ec 08             	sub    $0x8,%esp
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	ff 75 20             	pushl  0x20(%ebp)
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801020:	ff 4d 1c             	decl   0x1c(%ebp)
  801023:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801027:	7f e6                	jg     80100f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801029:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80102c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801037:	53                   	push   %ebx
  801038:	51                   	push   %ecx
  801039:	52                   	push   %edx
  80103a:	50                   	push   %eax
  80103b:	e8 c4 34 00 00       	call   804504 <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 f4 4d 80 00       	add    $0x804df4,%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	0f be c0             	movsbl %al,%eax
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	50                   	push   %eax
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
}
  80105c:	90                   	nop
  80105d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801065:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801069:	7e 1c                	jle    801087 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8b 00                	mov    (%eax),%eax
  801070:	8d 50 08             	lea    0x8(%eax),%edx
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 10                	mov    %edx,(%eax)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	83 e8 08             	sub    $0x8,%eax
  801080:	8b 50 04             	mov    0x4(%eax),%edx
  801083:	8b 00                	mov    (%eax),%eax
  801085:	eb 40                	jmp    8010c7 <getuint+0x65>
	else if (lflag)
  801087:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108b:	74 1e                	je     8010ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	8d 50 04             	lea    0x4(%eax),%edx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	89 10                	mov    %edx,(%eax)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	83 e8 04             	sub    $0x4,%eax
  8010a2:	8b 00                	mov    (%eax),%eax
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	eb 1c                	jmp    8010c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	8d 50 04             	lea    0x4(%eax),%edx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 10                	mov    %edx,(%eax)
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	83 e8 04             	sub    $0x4,%eax
  8010c0:	8b 00                	mov    (%eax),%eax
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010d0:	7e 1c                	jle    8010ee <getint+0x25>
		return va_arg(*ap, long long);
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8b 00                	mov    (%eax),%eax
  8010d7:	8d 50 08             	lea    0x8(%eax),%edx
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	89 10                	mov    %edx,(%eax)
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8b 00                	mov    (%eax),%eax
  8010e4:	83 e8 08             	sub    $0x8,%eax
  8010e7:	8b 50 04             	mov    0x4(%eax),%edx
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	eb 38                	jmp    801126 <getint+0x5d>
	else if (lflag)
  8010ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f2:	74 1a                	je     80110e <getint+0x45>
		return va_arg(*ap, long);
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8b 00                	mov    (%eax),%eax
  8010f9:	8d 50 04             	lea    0x4(%eax),%edx
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 10                	mov    %edx,(%eax)
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8b 00                	mov    (%eax),%eax
  801106:	83 e8 04             	sub    $0x4,%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	99                   	cltd   
  80110c:	eb 18                	jmp    801126 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8b 00                	mov    (%eax),%eax
  801113:	8d 50 04             	lea    0x4(%eax),%edx
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	89 10                	mov    %edx,(%eax)
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	83 e8 04             	sub    $0x4,%eax
  801123:	8b 00                	mov    (%eax),%eax
  801125:	99                   	cltd   
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
  80112d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801130:	eb 17                	jmp    801149 <vprintfmt+0x21>
			if (ch == '\0')
  801132:	85 db                	test   %ebx,%ebx
  801134:	0f 84 c1 03 00 00    	je     8014fb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	53                   	push   %ebx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	ff d0                	call   *%eax
  801146:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	8d 50 01             	lea    0x1(%eax),%edx
  80114f:	89 55 10             	mov    %edx,0x10(%ebp)
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f b6 d8             	movzbl %al,%ebx
  801157:	83 fb 25             	cmp    $0x25,%ebx
  80115a:	75 d6                	jne    801132 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80115c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801160:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801167:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80116e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801175:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d8             	movzbl %al,%ebx
  80118a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80118d:	83 f8 5b             	cmp    $0x5b,%eax
  801190:	0f 87 3d 03 00 00    	ja     8014d3 <vprintfmt+0x3ab>
  801196:	8b 04 85 18 4e 80 00 	mov    0x804e18(,%eax,4),%eax
  80119d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80119f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011a3:	eb d7                	jmp    80117c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011a9:	eb d1                	jmp    80117c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011b5:	89 d0                	mov    %edx,%eax
  8011b7:	c1 e0 02             	shl    $0x2,%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	01 c0                	add    %eax,%eax
  8011be:	01 d8                	add    %ebx,%eax
  8011c0:	83 e8 30             	sub    $0x30,%eax
  8011c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8011d1:	7e 3e                	jle    801211 <vprintfmt+0xe9>
  8011d3:	83 fb 39             	cmp    $0x39,%ebx
  8011d6:	7f 39                	jg     801211 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011db:	eb d5                	jmp    8011b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	83 c0 04             	add    $0x4,%eax
  8011e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	83 e8 04             	sub    $0x4,%eax
  8011ec:	8b 00                	mov    (%eax),%eax
  8011ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011f1:	eb 1f                	jmp    801212 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011f7:	79 83                	jns    80117c <vprintfmt+0x54>
				width = 0;
  8011f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801200:	e9 77 ff ff ff       	jmp    80117c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801205:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80120c:	e9 6b ff ff ff       	jmp    80117c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801211:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801212:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801216:	0f 89 60 ff ff ff    	jns    80117c <vprintfmt+0x54>
				width = precision, precision = -1;
  80121c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801222:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801229:	e9 4e ff ff ff       	jmp    80117c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80122e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801231:	e9 46 ff ff ff       	jmp    80117c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	83 c0 04             	add    $0x4,%eax
  80123c:	89 45 14             	mov    %eax,0x14(%ebp)
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	83 e8 04             	sub    $0x4,%eax
  801245:	8b 00                	mov    (%eax),%eax
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	50                   	push   %eax
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	ff d0                	call   *%eax
  801253:	83 c4 10             	add    $0x10,%esp
			break;
  801256:	e9 9b 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80125b:	8b 45 14             	mov    0x14(%ebp),%eax
  80125e:	83 c0 04             	add    $0x4,%eax
  801261:	89 45 14             	mov    %eax,0x14(%ebp)
  801264:	8b 45 14             	mov    0x14(%ebp),%eax
  801267:	83 e8 04             	sub    $0x4,%eax
  80126a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80126c:	85 db                	test   %ebx,%ebx
  80126e:	79 02                	jns    801272 <vprintfmt+0x14a>
				err = -err;
  801270:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801272:	83 fb 64             	cmp    $0x64,%ebx
  801275:	7f 0b                	jg     801282 <vprintfmt+0x15a>
  801277:	8b 34 9d 60 4c 80 00 	mov    0x804c60(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 05 4e 80 00       	push   $0x804e05
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	ff 75 08             	pushl  0x8(%ebp)
  80128e:	e8 70 02 00 00       	call   801503 <printfmt>
  801293:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801296:	e9 5b 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80129b:	56                   	push   %esi
  80129c:	68 0e 4e 80 00       	push   $0x804e0e
  8012a1:	ff 75 0c             	pushl  0xc(%ebp)
  8012a4:	ff 75 08             	pushl  0x8(%ebp)
  8012a7:	e8 57 02 00 00       	call   801503 <printfmt>
  8012ac:	83 c4 10             	add    $0x10,%esp
			break;
  8012af:	e9 42 02 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b7:	83 c0 04             	add    $0x4,%eax
  8012ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8012bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c0:	83 e8 04             	sub    $0x4,%eax
  8012c3:	8b 30                	mov    (%eax),%esi
  8012c5:	85 f6                	test   %esi,%esi
  8012c7:	75 05                	jne    8012ce <vprintfmt+0x1a6>
				p = "(null)";
  8012c9:	be 11 4e 80 00       	mov    $0x804e11,%esi
			if (width > 0 && padc != '-')
  8012ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012d2:	7e 6d                	jle    801341 <vprintfmt+0x219>
  8012d4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012d8:	74 67                	je     801341 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	50                   	push   %eax
  8012e1:	56                   	push   %esi
  8012e2:	e8 1e 03 00 00       	call   801605 <strnlen>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012ed:	eb 16                	jmp    801305 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012f3:	83 ec 08             	sub    $0x8,%esp
  8012f6:	ff 75 0c             	pushl  0xc(%ebp)
  8012f9:	50                   	push   %eax
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	ff d0                	call   *%eax
  8012ff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801302:	ff 4d e4             	decl   -0x1c(%ebp)
  801305:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801309:	7f e4                	jg     8012ef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80130b:	eb 34                	jmp    801341 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80130d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801311:	74 1c                	je     80132f <vprintfmt+0x207>
  801313:	83 fb 1f             	cmp    $0x1f,%ebx
  801316:	7e 05                	jle    80131d <vprintfmt+0x1f5>
  801318:	83 fb 7e             	cmp    $0x7e,%ebx
  80131b:	7e 12                	jle    80132f <vprintfmt+0x207>
					putch('?', putdat);
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	6a 3f                	push   $0x3f
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	ff d0                	call   *%eax
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	eb 0f                	jmp    80133e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	53                   	push   %ebx
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	ff d0                	call   *%eax
  80133b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80133e:	ff 4d e4             	decl   -0x1c(%ebp)
  801341:	89 f0                	mov    %esi,%eax
  801343:	8d 70 01             	lea    0x1(%eax),%esi
  801346:	8a 00                	mov    (%eax),%al
  801348:	0f be d8             	movsbl %al,%ebx
  80134b:	85 db                	test   %ebx,%ebx
  80134d:	74 24                	je     801373 <vprintfmt+0x24b>
  80134f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801353:	78 b8                	js     80130d <vprintfmt+0x1e5>
  801355:	ff 4d e0             	decl   -0x20(%ebp)
  801358:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80135c:	79 af                	jns    80130d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135e:	eb 13                	jmp    801373 <vprintfmt+0x24b>
				putch(' ', putdat);
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	6a 20                	push   $0x20
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	ff d0                	call   *%eax
  80136d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801370:	ff 4d e4             	decl   -0x1c(%ebp)
  801373:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801377:	7f e7                	jg     801360 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801379:	e9 78 01 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	ff 75 e8             	pushl  -0x18(%ebp)
  801384:	8d 45 14             	lea    0x14(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	e8 3c fd ff ff       	call   8010c9 <getint>
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801393:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139c:	85 d2                	test   %edx,%edx
  80139e:	79 23                	jns    8013c3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	6a 2d                	push   $0x2d
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	ff d0                	call   *%eax
  8013ad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	f7 d8                	neg    %eax
  8013b8:	83 d2 00             	adc    $0x0,%edx
  8013bb:	f7 da                	neg    %edx
  8013bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ca:	e9 bc 00 00 00       	jmp    80148b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	e8 84 fc ff ff       	call   801062 <getuint>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013ee:	e9 98 00 00 00       	jmp    80148b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	6a 58                	push   $0x58
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	ff d0                	call   *%eax
  801400:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			break;
  801423:	e9 ce 00 00 00       	jmp    8014f6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	6a 30                	push   $0x30
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	ff d0                	call   *%eax
  801435:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 78                	push   $0x78
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	83 c0 04             	add    $0x4,%eax
  80144e:	89 45 14             	mov    %eax,0x14(%ebp)
  801451:	8b 45 14             	mov    0x14(%ebp),%eax
  801454:	83 e8 04             	sub    $0x4,%eax
  801457:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801459:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80145c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801463:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80146a:	eb 1f                	jmp    80148b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	ff 75 e8             	pushl  -0x18(%ebp)
  801472:	8d 45 14             	lea    0x14(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	e8 e7 fb ff ff       	call   801062 <getuint>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801481:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801484:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80148b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80148f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	52                   	push   %edx
  801496:	ff 75 e4             	pushl  -0x1c(%ebp)
  801499:	50                   	push   %eax
  80149a:	ff 75 f4             	pushl  -0xc(%ebp)
  80149d:	ff 75 f0             	pushl  -0x10(%ebp)
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 00 fb ff ff       	call   800fab <printnum>
  8014ab:	83 c4 20             	add    $0x20,%esp
			break;
  8014ae:	eb 46                	jmp    8014f6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	53                   	push   %ebx
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	ff d0                	call   *%eax
  8014bc:	83 c4 10             	add    $0x10,%esp
			break;
  8014bf:	eb 35                	jmp    8014f6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8014c1:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  8014c8:	eb 2c                	jmp    8014f6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8014ca:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  8014d1:	eb 23                	jmp    8014f6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	6a 25                	push   $0x25
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	ff d0                	call   *%eax
  8014e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e3:	ff 4d 10             	decl   0x10(%ebp)
  8014e6:	eb 03                	jmp    8014eb <vprintfmt+0x3c3>
  8014e8:	ff 4d 10             	decl   0x10(%ebp)
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	48                   	dec    %eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 25                	cmp    $0x25,%al
  8014f3:	75 f3                	jne    8014e8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8014f5:	90                   	nop
		}
	}
  8014f6:	e9 35 fc ff ff       	jmp    801130 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    

00801503 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801509:	8d 45 10             	lea    0x10(%ebp),%eax
  80150c:	83 c0 04             	add    $0x4,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	ff 75 f4             	pushl  -0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 04 fc ff ff       	call   801128 <vprintfmt>
  801524:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	8b 40 08             	mov    0x8(%eax),%eax
  801533:	8d 50 01             	lea    0x1(%eax),%edx
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	8b 10                	mov    (%eax),%edx
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	8b 40 04             	mov    0x4(%eax),%eax
  801547:	39 c2                	cmp    %eax,%edx
  801549:	73 12                	jae    80155d <sprintputch+0x33>
		*b->buf++ = ch;
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	8d 48 01             	lea    0x1(%eax),%ecx
  801553:	8b 55 0c             	mov    0xc(%ebp),%edx
  801556:	89 0a                	mov    %ecx,(%edx)
  801558:	8b 55 08             	mov    0x8(%ebp),%edx
  80155b:	88 10                	mov    %dl,(%eax)
}
  80155d:	90                   	nop
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	01 d0                	add    %edx,%eax
  801577:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80157a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801581:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801585:	74 06                	je     80158d <vsnprintf+0x2d>
  801587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80158b:	7f 07                	jg     801594 <vsnprintf+0x34>
		return -E_INVAL;
  80158d:	b8 03 00 00 00       	mov    $0x3,%eax
  801592:	eb 20                	jmp    8015b4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801594:	ff 75 14             	pushl  0x14(%ebp)
  801597:	ff 75 10             	pushl  0x10(%ebp)
  80159a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159d:	50                   	push   %eax
  80159e:	68 2a 15 80 00       	push   $0x80152a
  8015a3:	e8 80 fb ff ff       	call   801128 <vprintfmt>
  8015a8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bf:	83 c0 04             	add    $0x4,%eax
  8015c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	ff 75 08             	pushl  0x8(%ebp)
  8015d2:	e8 89 ff ff ff       	call   801560 <vsnprintf>
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ef:	eb 06                	jmp    8015f7 <strlen+0x15>
		n++;
  8015f1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f4:	ff 45 08             	incl   0x8(%ebp)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	84 c0                	test   %al,%al
  8015fe:	75 f1                	jne    8015f1 <strlen+0xf>
		n++;
	return n;
  801600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801612:	eb 09                	jmp    80161d <strnlen+0x18>
		n++;
  801614:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	ff 4d 0c             	decl   0xc(%ebp)
  80161d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801621:	74 09                	je     80162c <strnlen+0x27>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8a 00                	mov    (%eax),%al
  801628:	84 c0                	test   %al,%al
  80162a:	75 e8                	jne    801614 <strnlen+0xf>
		n++;
	return n;
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163d:	90                   	nop
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8d 50 01             	lea    0x1(%eax),%edx
  801644:	89 55 08             	mov    %edx,0x8(%ebp)
  801647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801650:	8a 12                	mov    (%edx),%dl
  801652:	88 10                	mov    %dl,(%eax)
  801654:	8a 00                	mov    (%eax),%al
  801656:	84 c0                	test   %al,%al
  801658:	75 e4                	jne    80163e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80165a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80166b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801672:	eb 1f                	jmp    801693 <strncpy+0x34>
		*dst++ = *src;
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8d 50 01             	lea    0x1(%eax),%edx
  80167a:	89 55 08             	mov    %edx,0x8(%ebp)
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8a 12                	mov    (%edx),%dl
  801682:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801684:	8b 45 0c             	mov    0xc(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	84 c0                	test   %al,%al
  80168b:	74 03                	je     801690 <strncpy+0x31>
			src++;
  80168d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801690:	ff 45 fc             	incl   -0x4(%ebp)
  801693:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801696:	3b 45 10             	cmp    0x10(%ebp),%eax
  801699:	72 d9                	jb     801674 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b0:	74 30                	je     8016e2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b2:	eb 16                	jmp    8016ca <strlcpy+0x2a>
			*dst++ = *src++;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8d 50 01             	lea    0x1(%eax),%edx
  8016ba:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c6:	8a 12                	mov    (%edx),%dl
  8016c8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016ca:	ff 4d 10             	decl   0x10(%ebp)
  8016cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d1:	74 09                	je     8016dc <strlcpy+0x3c>
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	84 c0                	test   %al,%al
  8016da:	75 d8                	jne    8016b4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e8:	29 c2                	sub    %eax,%edx
  8016ea:	89 d0                	mov    %edx,%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016f1:	eb 06                	jmp    8016f9 <strcmp+0xb>
		p++, q++;
  8016f3:	ff 45 08             	incl   0x8(%ebp)
  8016f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8a 00                	mov    (%eax),%al
  8016fe:	84 c0                	test   %al,%al
  801700:	74 0e                	je     801710 <strcmp+0x22>
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 10                	mov    (%eax),%dl
  801707:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	38 c2                	cmp    %al,%dl
  80170e:	74 e3                	je     8016f3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	0f b6 d0             	movzbl %al,%edx
  801718:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	0f b6 c0             	movzbl %al,%eax
  801720:	29 c2                	sub    %eax,%edx
  801722:	89 d0                	mov    %edx,%eax
}
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801729:	eb 09                	jmp    801734 <strncmp+0xe>
		n--, p++, q++;
  80172b:	ff 4d 10             	decl   0x10(%ebp)
  80172e:	ff 45 08             	incl   0x8(%ebp)
  801731:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801734:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801738:	74 17                	je     801751 <strncmp+0x2b>
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	84 c0                	test   %al,%al
  801741:	74 0e                	je     801751 <strncmp+0x2b>
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8a 10                	mov    (%eax),%dl
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	38 c2                	cmp    %al,%dl
  80174f:	74 da                	je     80172b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801751:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801755:	75 07                	jne    80175e <strncmp+0x38>
		return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	eb 14                	jmp    801772 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	0f b6 d0             	movzbl %al,%edx
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	0f b6 c0             	movzbl %al,%eax
  80176e:	29 c2                	sub    %eax,%edx
  801770:	89 d0                	mov    %edx,%eax
}
  801772:	5d                   	pop    %ebp
  801773:	c3                   	ret    

00801774 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801780:	eb 12                	jmp    801794 <strchr+0x20>
		if (*s == c)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80178a:	75 05                	jne    801791 <strchr+0x1d>
			return (char *) s;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	eb 11                	jmp    8017a2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801791:	ff 45 08             	incl   0x8(%ebp)
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	75 e5                	jne    801782 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017b0:	eb 0d                	jmp    8017bf <strfind+0x1b>
		if (*s == c)
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017ba:	74 0e                	je     8017ca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017bc:	ff 45 08             	incl   0x8(%ebp)
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	84 c0                	test   %al,%al
  8017c6:	75 ea                	jne    8017b2 <strfind+0xe>
  8017c8:	eb 01                	jmp    8017cb <strfind+0x27>
		if (*s == c)
			break;
  8017ca:	90                   	nop
	return (char *) s;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e2:	eb 0e                	jmp    8017f2 <memset+0x22>
		*p++ = c;
  8017e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e7:	8d 50 01             	lea    0x1(%eax),%edx
  8017ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f2:	ff 4d f8             	decl   -0x8(%ebp)
  8017f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f9:	79 e9                	jns    8017e4 <memset+0x14>
		*p++ = c;

	return v;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801806:	8b 45 0c             	mov    0xc(%ebp),%eax
  801809:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801812:	eb 16                	jmp    80182a <memcpy+0x2a>
		*d++ = *s++;
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	8d 50 01             	lea    0x1(%eax),%edx
  80181a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801820:	8d 4a 01             	lea    0x1(%edx),%ecx
  801823:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801826:	8a 12                	mov    (%edx),%dl
  801828:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801830:	89 55 10             	mov    %edx,0x10(%ebp)
  801833:	85 c0                	test   %eax,%eax
  801835:	75 dd                	jne    801814 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801851:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801854:	73 50                	jae    8018a6 <memmove+0x6a>
  801856:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801859:	8b 45 10             	mov    0x10(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801861:	76 43                	jbe    8018a6 <memmove+0x6a>
		s += n;
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801869:	8b 45 10             	mov    0x10(%ebp),%eax
  80186c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186f:	eb 10                	jmp    801881 <memmove+0x45>
			*--d = *--s;
  801871:	ff 4d f8             	decl   -0x8(%ebp)
  801874:	ff 4d fc             	decl   -0x4(%ebp)
  801877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187a:	8a 10                	mov    (%eax),%dl
  80187c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 e3                	jne    801871 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188e:	eb 23                	jmp    8018b3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018ca:	eb 2a                	jmp    8018f6 <memcmp+0x3e>
		if (*s1 != *s2)
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8a 10                	mov    (%eax),%dl
  8018d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	38 c2                	cmp    %al,%dl
  8018d8:	74 16                	je     8018f0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	0f b6 d0             	movzbl %al,%edx
  8018e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	0f b6 c0             	movzbl %al,%eax
  8018ea:	29 c2                	sub    %eax,%edx
  8018ec:	89 d0                	mov    %edx,%eax
  8018ee:	eb 18                	jmp    801908 <memcmp+0x50>
		s1++, s2++;
  8018f0:	ff 45 fc             	incl   -0x4(%ebp)
  8018f3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ff:	85 c0                	test   %eax,%eax
  801901:	75 c9                	jne    8018cc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801910:	8b 55 08             	mov    0x8(%ebp),%edx
  801913:	8b 45 10             	mov    0x10(%ebp),%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80191b:	eb 15                	jmp    801932 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	0f b6 d0             	movzbl %al,%edx
  801925:	8b 45 0c             	mov    0xc(%ebp),%eax
  801928:	0f b6 c0             	movzbl %al,%eax
  80192b:	39 c2                	cmp    %eax,%edx
  80192d:	74 0d                	je     80193c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192f:	ff 45 08             	incl   0x8(%ebp)
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801938:	72 e3                	jb     80191d <memfind+0x13>
  80193a:	eb 01                	jmp    80193d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193c:	90                   	nop
	return (void *) s;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801948:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801956:	eb 03                	jmp    80195b <strtol+0x19>
		s++;
  801958:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	8a 00                	mov    (%eax),%al
  801960:	3c 20                	cmp    $0x20,%al
  801962:	74 f4                	je     801958 <strtol+0x16>
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8a 00                	mov    (%eax),%al
  801969:	3c 09                	cmp    $0x9,%al
  80196b:	74 eb                	je     801958 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8a 00                	mov    (%eax),%al
  801972:	3c 2b                	cmp    $0x2b,%al
  801974:	75 05                	jne    80197b <strtol+0x39>
		s++;
  801976:	ff 45 08             	incl   0x8(%ebp)
  801979:	eb 13                	jmp    80198e <strtol+0x4c>
	else if (*s == '-')
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	8a 00                	mov    (%eax),%al
  801980:	3c 2d                	cmp    $0x2d,%al
  801982:	75 0a                	jne    80198e <strtol+0x4c>
		s++, neg = 1;
  801984:	ff 45 08             	incl   0x8(%ebp)
  801987:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801992:	74 06                	je     80199a <strtol+0x58>
  801994:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801998:	75 20                	jne    8019ba <strtol+0x78>
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	8a 00                	mov    (%eax),%al
  80199f:	3c 30                	cmp    $0x30,%al
  8019a1:	75 17                	jne    8019ba <strtol+0x78>
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	40                   	inc    %eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	3c 78                	cmp    $0x78,%al
  8019ab:	75 0d                	jne    8019ba <strtol+0x78>
		s += 2, base = 16;
  8019ad:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019b1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b8:	eb 28                	jmp    8019e2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019be:	75 15                	jne    8019d5 <strtol+0x93>
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	8a 00                	mov    (%eax),%al
  8019c5:	3c 30                	cmp    $0x30,%al
  8019c7:	75 0c                	jne    8019d5 <strtol+0x93>
		s++, base = 8;
  8019c9:	ff 45 08             	incl   0x8(%ebp)
  8019cc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d3:	eb 0d                	jmp    8019e2 <strtol+0xa0>
	else if (base == 0)
  8019d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d9:	75 07                	jne    8019e2 <strtol+0xa0>
		base = 10;
  8019db:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	3c 2f                	cmp    $0x2f,%al
  8019e9:	7e 19                	jle    801a04 <strtol+0xc2>
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	3c 39                	cmp    $0x39,%al
  8019f2:	7f 10                	jg     801a04 <strtol+0xc2>
			dig = *s - '0';
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8a 00                	mov    (%eax),%al
  8019f9:	0f be c0             	movsbl %al,%eax
  8019fc:	83 e8 30             	sub    $0x30,%eax
  8019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a02:	eb 42                	jmp    801a46 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	3c 60                	cmp    $0x60,%al
  801a0b:	7e 19                	jle    801a26 <strtol+0xe4>
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	3c 7a                	cmp    $0x7a,%al
  801a14:	7f 10                	jg     801a26 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	0f be c0             	movsbl %al,%eax
  801a1e:	83 e8 57             	sub    $0x57,%eax
  801a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a24:	eb 20                	jmp    801a46 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8a 00                	mov    (%eax),%al
  801a2b:	3c 40                	cmp    $0x40,%al
  801a2d:	7e 39                	jle    801a68 <strtol+0x126>
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8a 00                	mov    (%eax),%al
  801a34:	3c 5a                	cmp    $0x5a,%al
  801a36:	7f 30                	jg     801a68 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	8a 00                	mov    (%eax),%al
  801a3d:	0f be c0             	movsbl %al,%eax
  801a40:	83 e8 37             	sub    $0x37,%eax
  801a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a49:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4c:	7d 19                	jge    801a67 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4e:	ff 45 08             	incl   0x8(%ebp)
  801a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a54:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a58:	89 c2                	mov    %eax,%edx
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a62:	e9 7b ff ff ff       	jmp    8019e2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a67:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6c:	74 08                	je     801a76 <strtol+0x134>
		*endptr = (char *) s;
  801a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a71:	8b 55 08             	mov    0x8(%ebp),%edx
  801a74:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a7a:	74 07                	je     801a83 <strtol+0x141>
  801a7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7f:	f7 d8                	neg    %eax
  801a81:	eb 03                	jmp    801a86 <strtol+0x144>
  801a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <ltostr>:

void
ltostr(long value, char *str)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aa0:	79 13                	jns    801ab5 <ltostr+0x2d>
	{
		neg = 1;
  801aa2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aaf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abd:	99                   	cltd   
  801abe:	f7 f9                	idiv   %ecx
  801ac0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac6:	8d 50 01             	lea    0x1(%eax),%edx
  801ac9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801acc:	89 c2                	mov    %eax,%edx
  801ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad6:	83 c2 30             	add    $0x30,%edx
  801ad9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ade:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae3:	f7 e9                	imul   %ecx
  801ae5:	c1 fa 02             	sar    $0x2,%edx
  801ae8:	89 c8                	mov    %ecx,%eax
  801aea:	c1 f8 1f             	sar    $0x1f,%eax
  801aed:	29 c2                	sub    %eax,%edx
  801aef:	89 d0                	mov    %edx,%eax
  801af1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801af4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af8:	75 bb                	jne    801ab5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b04:	48                   	dec    %eax
  801b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b0c:	74 3d                	je     801b4b <ltostr+0xc3>
		start = 1 ;
  801b0e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b15:	eb 34                	jmp    801b4b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	01 c2                	add    %eax,%edx
  801b2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b32:	01 c8                	add    %ecx,%eax
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	01 c2                	add    %eax,%edx
  801b40:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b43:	88 02                	mov    %al,(%edx)
		start++ ;
  801b45:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b48:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b51:	7c c4                	jl     801b17 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b53:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	01 d0                	add    %edx,%eax
  801b5b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	e8 73 fa ff ff       	call   8015e2 <strlen>
  801b6f:	83 c4 04             	add    $0x4,%esp
  801b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	e8 65 fa ff ff       	call   8015e2 <strlen>
  801b7d:	83 c4 04             	add    $0x4,%esp
  801b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b91:	eb 17                	jmp    801baa <strcconcat+0x49>
		final[s] = str1[s] ;
  801b93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
  801b99:	01 c2                	add    %eax,%edx
  801b9b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	01 c8                	add    %ecx,%eax
  801ba3:	8a 00                	mov    (%eax),%al
  801ba5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba7:	ff 45 fc             	incl   -0x4(%ebp)
  801baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bb0:	7c e1                	jl     801b93 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bc0:	eb 1f                	jmp    801be1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc5:	8d 50 01             	lea    0x1(%eax),%edx
  801bc8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bcb:	89 c2                	mov    %eax,%edx
  801bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd0:	01 c2                	add    %eax,%edx
  801bd2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	01 c8                	add    %ecx,%eax
  801bda:	8a 00                	mov    (%eax),%al
  801bdc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bde:	ff 45 f8             	incl   -0x8(%ebp)
  801be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be7:	7c d9                	jl     801bc2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bec:	8b 45 10             	mov    0x10(%ebp),%eax
  801bef:	01 d0                	add    %edx,%eax
  801bf1:	c6 00 00             	movb   $0x0,(%eax)
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	8b 00                	mov    (%eax),%eax
  801c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	01 d0                	add    %edx,%eax
  801c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c1a:	eb 0c                	jmp    801c28 <strsplit+0x31>
			*string++ = 0;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	8d 50 01             	lea    0x1(%eax),%edx
  801c22:	89 55 08             	mov    %edx,0x8(%ebp)
  801c25:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	8a 00                	mov    (%eax),%al
  801c2d:	84 c0                	test   %al,%al
  801c2f:	74 18                	je     801c49 <strsplit+0x52>
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	8a 00                	mov    (%eax),%al
  801c36:	0f be c0             	movsbl %al,%eax
  801c39:	50                   	push   %eax
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	e8 32 fb ff ff       	call   801774 <strchr>
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	75 d3                	jne    801c1c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8a 00                	mov    (%eax),%al
  801c4e:	84 c0                	test   %al,%al
  801c50:	74 5a                	je     801cac <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c52:	8b 45 14             	mov    0x14(%ebp),%eax
  801c55:	8b 00                	mov    (%eax),%eax
  801c57:	83 f8 0f             	cmp    $0xf,%eax
  801c5a:	75 07                	jne    801c63 <strsplit+0x6c>
		{
			return 0;
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c61:	eb 66                	jmp    801cc9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c63:	8b 45 14             	mov    0x14(%ebp),%eax
  801c66:	8b 00                	mov    (%eax),%eax
  801c68:	8d 48 01             	lea    0x1(%eax),%ecx
  801c6b:	8b 55 14             	mov    0x14(%ebp),%edx
  801c6e:	89 0a                	mov    %ecx,(%edx)
  801c70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c77:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7a:	01 c2                	add    %eax,%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c81:	eb 03                	jmp    801c86 <strsplit+0x8f>
			string++;
  801c83:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	8a 00                	mov    (%eax),%al
  801c8b:	84 c0                	test   %al,%al
  801c8d:	74 8b                	je     801c1a <strsplit+0x23>
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	0f be c0             	movsbl %al,%eax
  801c97:	50                   	push   %eax
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	e8 d4 fa ff ff       	call   801774 <strchr>
  801ca0:	83 c4 08             	add    $0x8,%esp
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	74 dc                	je     801c83 <strsplit+0x8c>
			string++;
	}
  801ca7:	e9 6e ff ff ff       	jmp    801c1a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cac:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cad:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	01 d0                	add    %edx,%eax
  801cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cc4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 88 4f 80 00       	push   $0x804f88
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 aa 4f 80 00       	push   $0x804faa
  801ce3:	e8 a9 ef ff ff       	call   800c91 <_panic>

00801ce8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	e8 e7 0a 00 00       	call   8027e0 <sys_sbrk>
  801cf9:	83 c4 10             	add    $0x10,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d08:	75 0a                	jne    801d14 <malloc+0x16>
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0f:	e9 07 02 00 00       	jmp    801f1b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801d14:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d21:	01 d0                	add    %edx,%eax
  801d23:	48                   	dec    %eax
  801d24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2f:	f7 75 dc             	divl   -0x24(%ebp)
  801d32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d35:	29 d0                	sub    %edx,%eax
  801d37:	c1 e8 0c             	shr    $0xc,%eax
  801d3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801d3d:	a1 20 60 80 00       	mov    0x806020,%eax
  801d42:	8b 40 78             	mov    0x78(%eax),%eax
  801d45:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801d4a:	29 c2                	sub    %eax,%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d59:	c1 e8 0c             	shr    $0xc,%eax
  801d5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801d66:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d6d:	77 42                	ja     801db1 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d6f:	e8 f0 08 00 00       	call   802664 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 30 0e 00 00       	call   802bb3 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 02 09 00 00       	call   802695 <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 c9 12 00 00       	call   80306f <alloc_block_BF>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dac:	e9 67 01 00 00       	jmp    801f18 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801db4:	48                   	dec    %eax
  801db5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801db8:	0f 86 53 01 00 00    	jbe    801f11 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801dbe:	a1 20 60 80 00       	mov    0x806020,%eax
  801dc3:	8b 40 78             	mov    0x78(%eax),%eax
  801dc6:	05 00 10 00 00       	add    $0x1000,%eax
  801dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801dce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801dd5:	e9 de 00 00 00       	jmp    801eb8 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801dda:	a1 20 60 80 00       	mov    0x806020,%eax
  801ddf:	8b 40 78             	mov    0x78(%eax),%eax
  801de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801de5:	29 c2                	sub    %eax,%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dee:	c1 e8 0c             	shr    $0xc,%eax
  801df1:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	0f 85 ab 00 00 00    	jne    801eab <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	05 00 10 00 00       	add    $0x1000,%eax
  801e08:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801e0b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801e12:	eb 47                	jmp    801e5b <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801e14:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801e1b:	76 0a                	jbe    801e27 <malloc+0x129>
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e22:	e9 f4 00 00 00       	jmp    801f1b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801e27:	a1 20 60 80 00       	mov    0x806020,%eax
  801e2c:	8b 40 78             	mov    0x78(%eax),%eax
  801e2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e32:	29 c2                	sub    %eax,%edx
  801e34:	89 d0                	mov    %edx,%eax
  801e36:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e3b:	c1 e8 0c             	shr    $0xc,%eax
  801e3e:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	74 08                	je     801e51 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801e4f:	eb 5a                	jmp    801eab <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801e51:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801e58:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e5e:	48                   	dec    %eax
  801e5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801e62:	77 b0                	ja     801e14 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801e64:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801e6b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e72:	eb 2f                	jmp    801ea3 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e77:	c1 e0 0c             	shl    $0xc,%eax
  801e7a:	89 c2                	mov    %eax,%edx
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	01 c2                	add    %eax,%edx
  801e81:	a1 20 60 80 00       	mov    0x806020,%eax
  801e86:	8b 40 78             	mov    0x78(%eax),%eax
  801e89:	29 c2                	sub    %eax,%edx
  801e8b:	89 d0                	mov    %edx,%eax
  801e8d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e92:	c1 e8 0c             	shr    $0xc,%eax
  801e95:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
  801e9c:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801ea0:	ff 45 e0             	incl   -0x20(%ebp)
  801ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ea9:	72 c9                	jb     801e74 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	75 16                	jne    801ec7 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801eb1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801eb8:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ebf:	0f 86 15 ff ff ff    	jbe    801dda <malloc+0xdc>
  801ec5:	eb 01                	jmp    801ec8 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801ec7:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ecc:	75 07                	jne    801ed5 <malloc+0x1d7>
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	eb 46                	jmp    801f1b <malloc+0x21d>
		ptr = (void*)i;
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801edb:	a1 20 60 80 00       	mov    0x806020,%eax
  801ee0:	8b 40 78             	mov    0x78(%eax),%eax
  801ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee6:	29 c2                	sub    %eax,%edx
  801ee8:	89 d0                	mov    %edx,%eax
  801eea:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eef:	c1 e8 0c             	shr    $0xc,%eax
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef7:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	e8 0b 09 00 00       	call   802817 <sys_allocate_user_mem>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	eb 07                	jmp    801f18 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	eb 03                	jmp    801f1b <malloc+0x21d>
	}
	return ptr;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801f23:	a1 20 60 80 00       	mov    0x806020,%eax
  801f28:	8b 40 78             	mov    0x78(%eax),%eax
  801f2b:	05 00 10 00 00       	add    $0x1000,%eax
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801f33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801f3a:	a1 20 60 80 00       	mov    0x806020,%eax
  801f3f:	8b 50 78             	mov    0x78(%eax),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	39 c2                	cmp    %eax,%edx
  801f47:	76 24                	jbe    801f6d <free+0x50>
		size = get_block_size(va);
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	ff 75 08             	pushl  0x8(%ebp)
  801f4f:	e8 df 08 00 00       	call   802833 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 12 1b 00 00       	call   803a77 <free_block>
  801f65:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801f68:	e9 ac 00 00 00       	jmp    802019 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f73:	0f 82 89 00 00 00    	jb     802002 <free+0xe5>
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801f81:	77 7f                	ja     802002 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801f83:	8b 55 08             	mov    0x8(%ebp),%edx
  801f86:	a1 20 60 80 00       	mov    0x806020,%eax
  801f8b:	8b 40 78             	mov    0x78(%eax),%eax
  801f8e:	29 c2                	sub    %eax,%edx
  801f90:	89 d0                	mov    %edx,%eax
  801f92:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f97:	c1 e8 0c             	shr    $0xc,%eax
  801f9a:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  801fa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa7:	c1 e0 0c             	shl    $0xc,%eax
  801faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801fad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb4:	eb 2f                	jmp    801fe5 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	c1 e0 0c             	shl    $0xc,%eax
  801fbc:	89 c2                	mov    %eax,%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	01 c2                	add    %eax,%edx
  801fc3:	a1 20 60 80 00       	mov    0x806020,%eax
  801fc8:	8b 40 78             	mov    0x78(%eax),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
  801fcf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd4:	c1 e8 0c             	shr    $0xc,%eax
  801fd7:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  801fde:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801fe2:	ff 45 f4             	incl   -0xc(%ebp)
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801feb:	72 c9                	jb     801fb6 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 ec             	pushl  -0x14(%ebp)
  801ff6:	50                   	push   %eax
  801ff7:	e8 ff 07 00 00       	call   8027fb <sys_free_user_mem>
  801ffc:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801fff:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802000:	eb 17                	jmp    802019 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 b8 4f 80 00       	push   $0x804fb8
  80200a:	68 85 00 00 00       	push   $0x85
  80200f:	68 e2 4f 80 00       	push   $0x804fe2
  802014:	e8 78 ec ff ff       	call   800c91 <_panic>
	}
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 28             	sub    $0x28,%esp
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80202b:	75 0a                	jne    802037 <smalloc+0x1c>
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
  802032:	e9 9a 00 00 00       	jmp    8020d1 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802044:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204a:	39 d0                	cmp    %edx,%eax
  80204c:	73 02                	jae    802050 <smalloc+0x35>
  80204e:	89 d0                	mov    %edx,%eax
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	50                   	push   %eax
  802054:	e8 a5 fc ff ff       	call   801cfe <malloc>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80205f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802063:	75 07                	jne    80206c <smalloc+0x51>
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	eb 65                	jmp    8020d1 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80206c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802070:	ff 75 ec             	pushl  -0x14(%ebp)
  802073:	50                   	push   %eax
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	ff 75 08             	pushl  0x8(%ebp)
  80207a:	e8 83 03 00 00       	call   802402 <sys_createSharedObject>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802085:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802089:	74 06                	je     802091 <smalloc+0x76>
  80208b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80208f:	75 07                	jne    802098 <smalloc+0x7d>
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	eb 39                	jmp    8020d1 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  802098:	83 ec 08             	sub    $0x8,%esp
  80209b:	ff 75 ec             	pushl  -0x14(%ebp)
  80209e:	68 ee 4f 80 00       	push   $0x804fee
  8020a3:	e8 a6 ee ff ff       	call   800f4e <cprintf>
  8020a8:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8020ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8020b3:	8b 40 78             	mov    0x78(%eax),%eax
  8020b6:	29 c2                	sub    %eax,%edx
  8020b8:	89 d0                	mov    %edx,%eax
  8020ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020bf:	c1 e8 0c             	shr    $0xc,%eax
  8020c2:	89 c2                	mov    %eax,%edx
  8020c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c7:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8020ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 45 03 00 00       	call   80242c <sys_getSizeOfSharedObject>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020f1:	75 07                	jne    8020fa <sget+0x27>
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	eb 5c                	jmp    802156 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802100:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802107:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	39 d0                	cmp    %edx,%eax
  80210f:	7d 02                	jge    802113 <sget+0x40>
  802111:	89 d0                	mov    %edx,%eax
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	50                   	push   %eax
  802117:	e8 e2 fb ff ff       	call   801cfe <malloc>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802122:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802126:	75 07                	jne    80212f <sget+0x5c>
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
  80212d:	eb 27                	jmp    802156 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	ff 75 e8             	pushl  -0x18(%ebp)
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	ff 75 08             	pushl  0x8(%ebp)
  80213b:	e8 09 03 00 00       	call   802449 <sys_getSharedObject>
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802146:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80214a:	75 07                	jne    802153 <sget+0x80>
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	eb 03                	jmp    802156 <sget+0x83>
	return ptr;
  802153:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	a1 20 60 80 00       	mov    0x806020,%eax
  802166:	8b 40 78             	mov    0x78(%eax),%eax
  802169:	29 c2                	sub    %eax,%edx
  80216b:	89 d0                	mov    %edx,%eax
  80216d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802172:	c1 e8 0c             	shr    $0xc,%eax
  802175:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80217f:	83 ec 08             	sub    $0x8,%esp
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	ff 75 f4             	pushl  -0xc(%ebp)
  802188:	e8 db 02 00 00       	call   802468 <sys_freeSharedObject>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	68 00 50 80 00       	push   $0x805000
  8021a4:	68 dd 00 00 00       	push   $0xdd
  8021a9:	68 e2 4f 80 00       	push   $0x804fe2
  8021ae:	e8 de ea ff ff       	call   800c91 <_panic>

008021b3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 26 50 80 00       	push   $0x805026
  8021c1:	68 e9 00 00 00       	push   $0xe9
  8021c6:	68 e2 4f 80 00       	push   $0x804fe2
  8021cb:	e8 c1 ea ff ff       	call   800c91 <_panic>

008021d0 <shrink>:

}
void shrink(uint32 newSize)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 26 50 80 00       	push   $0x805026
  8021de:	68 ee 00 00 00       	push   $0xee
  8021e3:	68 e2 4f 80 00       	push   $0x804fe2
  8021e8:	e8 a4 ea ff ff       	call   800c91 <_panic>

008021ed <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f3:	83 ec 04             	sub    $0x4,%esp
  8021f6:	68 26 50 80 00       	push   $0x805026
  8021fb:	68 f3 00 00 00       	push   $0xf3
  802200:	68 e2 4f 80 00       	push   $0x804fe2
  802205:	e8 87 ea ff ff       	call   800c91 <_panic>

0080220a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8b 55 0c             	mov    0xc(%ebp),%edx
  802219:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80221c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80221f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802222:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802225:	cd 30                	int    $0x30
  802227:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 04             	sub    $0x4,%esp
  80223b:	8b 45 10             	mov    0x10(%ebp),%eax
  80223e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802241:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	52                   	push   %edx
  80224d:	ff 75 0c             	pushl  0xc(%ebp)
  802250:	50                   	push   %eax
  802251:	6a 00                	push   $0x0
  802253:	e8 b2 ff ff ff       	call   80220a <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	90                   	nop
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_cgetc>:

int
sys_cgetc(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 02                	push   $0x2
  80226d:	e8 98 ff ff ff       	call   80220a <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 03                	push   $0x3
  802286:	e8 7f ff ff ff       	call   80220a <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 04                	push   $0x4
  8022a0:	e8 65 ff ff ff       	call   80220a <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	90                   	nop
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	52                   	push   %edx
  8022bb:	50                   	push   %eax
  8022bc:	6a 08                	push   $0x8
  8022be:	e8 47 ff ff ff       	call   80220a <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	56                   	push   %esi
  8022cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8022d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	51                   	push   %ecx
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 09                	push   $0x9
  8022e3:	e8 22 ff ff ff       	call   80220a <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    

008022f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	52                   	push   %edx
  802302:	50                   	push   %eax
  802303:	6a 0a                	push   $0xa
  802305:	e8 00 ff ff ff       	call   80220a <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	ff 75 0c             	pushl  0xc(%ebp)
  80231b:	ff 75 08             	pushl  0x8(%ebp)
  80231e:	6a 0b                	push   $0xb
  802320:	e8 e5 fe ff ff       	call   80220a <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 0c                	push   $0xc
  802339:	e8 cc fe ff ff       	call   80220a <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 0d                	push   $0xd
  802352:	e8 b3 fe ff ff       	call   80220a <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 0e                	push   $0xe
  80236b:	e8 9a fe ff ff       	call   80220a <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 0f                	push   $0xf
  802384:	e8 81 fe ff ff       	call   80220a <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	ff 75 08             	pushl  0x8(%ebp)
  80239c:	6a 10                	push   $0x10
  80239e:	e8 67 fe ff ff       	call   80220a <syscall>
  8023a3:	83 c4 18             	add    $0x18,%esp
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 11                	push   $0x11
  8023b7:	e8 4e fe ff ff       	call   80220a <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
}
  8023bf:	90                   	nop
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	50                   	push   %eax
  8023db:	6a 01                	push   $0x1
  8023dd:	e8 28 fe ff ff       	call   80220a <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	90                   	nop
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 14                	push   $0x14
  8023f7:	e8 0e fe ff ff       	call   80220a <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	90                   	nop
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 04             	sub    $0x4,%esp
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80240e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802411:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	6a 00                	push   $0x0
  80241a:	51                   	push   %ecx
  80241b:	52                   	push   %edx
  80241c:	ff 75 0c             	pushl  0xc(%ebp)
  80241f:	50                   	push   %eax
  802420:	6a 15                	push   $0x15
  802422:	e8 e3 fd ff ff       	call   80220a <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80242f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	52                   	push   %edx
  80243c:	50                   	push   %eax
  80243d:	6a 16                	push   $0x16
  80243f:	e8 c6 fd ff ff       	call   80220a <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80244c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	51                   	push   %ecx
  80245a:	52                   	push   %edx
  80245b:	50                   	push   %eax
  80245c:	6a 17                	push   $0x17
  80245e:	e8 a7 fd ff ff       	call   80220a <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	52                   	push   %edx
  802478:	50                   	push   %eax
  802479:	6a 18                	push   $0x18
  80247b:	e8 8a fd ff ff       	call   80220a <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	6a 00                	push   $0x0
  80248d:	ff 75 14             	pushl  0x14(%ebp)
  802490:	ff 75 10             	pushl  0x10(%ebp)
  802493:	ff 75 0c             	pushl  0xc(%ebp)
  802496:	50                   	push   %eax
  802497:	6a 19                	push   $0x19
  802499:	e8 6c fd ff ff       	call   80220a <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	50                   	push   %eax
  8024b2:	6a 1a                	push   $0x1a
  8024b4:	e8 51 fd ff ff       	call   80220a <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	50                   	push   %eax
  8024ce:	6a 1b                	push   $0x1b
  8024d0:	e8 35 fd ff ff       	call   80220a <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 05                	push   $0x5
  8024e9:	e8 1c fd ff ff       	call   80220a <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 06                	push   $0x6
  802502:	e8 03 fd ff ff       	call   80220a <syscall>
  802507:	83 c4 18             	add    $0x18,%esp
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 07                	push   $0x7
  80251b:	e8 ea fc ff ff       	call   80220a <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <sys_exit_env>:


void sys_exit_env(void)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 1c                	push   $0x1c
  802534:	e8 d1 fc ff ff       	call   80220a <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
}
  80253c:	90                   	nop
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802545:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802548:	8d 50 04             	lea    0x4(%eax),%edx
  80254b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	52                   	push   %edx
  802555:	50                   	push   %eax
  802556:	6a 1d                	push   $0x1d
  802558:	e8 ad fc ff ff       	call   80220a <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
	return result;
  802560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802566:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802569:	89 01                	mov    %eax,(%ecx)
  80256b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	c9                   	leave  
  802572:	c2 04 00             	ret    $0x4

00802575 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	ff 75 10             	pushl  0x10(%ebp)
  80257f:	ff 75 0c             	pushl  0xc(%ebp)
  802582:	ff 75 08             	pushl  0x8(%ebp)
  802585:	6a 13                	push   $0x13
  802587:	e8 7e fc ff ff       	call   80220a <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
	return ;
  80258f:	90                   	nop
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sys_rcr2>:
uint32 sys_rcr2()
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 1e                	push   $0x1e
  8025a1:	e8 64 fc ff ff       	call   80220a <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	50                   	push   %eax
  8025c4:	6a 1f                	push   $0x1f
  8025c6:	e8 3f fc ff ff       	call   80220a <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ce:	90                   	nop
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <rsttst>:
void rsttst()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 21                	push   $0x21
  8025e0:	e8 25 fc ff ff       	call   80220a <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e8:	90                   	nop
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8025fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025fe:	52                   	push   %edx
  8025ff:	50                   	push   %eax
  802600:	ff 75 10             	pushl  0x10(%ebp)
  802603:	ff 75 0c             	pushl  0xc(%ebp)
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	6a 20                	push   $0x20
  80260b:	e8 fa fb ff ff       	call   80220a <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
	return ;
  802613:	90                   	nop
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <chktst>:
void chktst(uint32 n)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	6a 22                	push   $0x22
  802626:	e8 df fb ff ff       	call   80220a <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
	return ;
  80262e:	90                   	nop
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <inctst>:

void inctst()
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 23                	push   $0x23
  802640:	e8 c5 fb ff ff       	call   80220a <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
	return ;
  802648:	90                   	nop
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <gettst>:
uint32 gettst()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 24                	push   $0x24
  80265a:	e8 ab fb ff ff       	call   80220a <syscall>
  80265f:	83 c4 18             	add    $0x18,%esp
}
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 25                	push   $0x25
  802676:	e8 8f fb ff ff       	call   80220a <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
  80267e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802681:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802685:	75 07                	jne    80268e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802687:	b8 01 00 00 00       	mov    $0x1,%eax
  80268c:	eb 05                	jmp    802693 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 25                	push   $0x25
  8026a7:	e8 5e fb ff ff       	call   80220a <syscall>
  8026ac:	83 c4 18             	add    $0x18,%esp
  8026af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026b6:	75 07                	jne    8026bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bd:	eb 05                	jmp    8026c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 25                	push   $0x25
  8026d8:	e8 2d fb ff ff       	call   80220a <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
  8026e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026e7:	75 07                	jne    8026f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ee:	eb 05                	jmp    8026f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 25                	push   $0x25
  802709:	e8 fc fa ff ff       	call   80220a <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
  802711:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802714:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802718:	75 07                	jne    802721 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80271a:	b8 01 00 00 00       	mov    $0x1,%eax
  80271f:	eb 05                	jmp    802726 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	ff 75 08             	pushl  0x8(%ebp)
  802736:	6a 26                	push   $0x26
  802738:	e8 cd fa ff ff       	call   80220a <syscall>
  80273d:	83 c4 18             	add    $0x18,%esp
	return ;
  802740:	90                   	nop
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
  802746:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802747:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80274a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	53                   	push   %ebx
  802756:	51                   	push   %ecx
  802757:	52                   	push   %edx
  802758:	50                   	push   %eax
  802759:	6a 27                	push   $0x27
  80275b:	e8 aa fa ff ff       	call   80220a <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
}
  802763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80276b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	52                   	push   %edx
  802778:	50                   	push   %eax
  802779:	6a 28                	push   $0x28
  80277b:	e8 8a fa ff ff       	call   80220a <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802788:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80278b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	6a 00                	push   $0x0
  802793:	51                   	push   %ecx
  802794:	ff 75 10             	pushl  0x10(%ebp)
  802797:	52                   	push   %edx
  802798:	50                   	push   %eax
  802799:	6a 29                	push   $0x29
  80279b:	e8 6a fa ff ff       	call   80220a <syscall>
  8027a0:	83 c4 18             	add    $0x18,%esp
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	ff 75 10             	pushl  0x10(%ebp)
  8027af:	ff 75 0c             	pushl  0xc(%ebp)
  8027b2:	ff 75 08             	pushl  0x8(%ebp)
  8027b5:	6a 12                	push   $0x12
  8027b7:	e8 4e fa ff ff       	call   80220a <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8027bf:	90                   	nop
}
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	52                   	push   %edx
  8027d2:	50                   	push   %eax
  8027d3:	6a 2a                	push   $0x2a
  8027d5:	e8 30 fa ff ff       	call   80220a <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
	return;
  8027dd:	90                   	nop
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	50                   	push   %eax
  8027ef:	6a 2b                	push   $0x2b
  8027f1:	e8 14 fa ff ff       	call   80220a <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	ff 75 0c             	pushl  0xc(%ebp)
  802807:	ff 75 08             	pushl  0x8(%ebp)
  80280a:	6a 2c                	push   $0x2c
  80280c:	e8 f9 f9 ff ff       	call   80220a <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
	return;
  802814:	90                   	nop
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	ff 75 0c             	pushl  0xc(%ebp)
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	6a 2d                	push   $0x2d
  802828:	e8 dd f9 ff ff       	call   80220a <syscall>
  80282d:	83 c4 18             	add    $0x18,%esp
	return;
  802830:	90                   	nop
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	83 e8 04             	sub    $0x4,%eax
  80283f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	83 e8 04             	sub    $0x4,%eax
  802858:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80285b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	83 e0 01             	and    $0x1,%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	0f 94 c0             	sete   %al
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287a:	83 f8 02             	cmp    $0x2,%eax
  80287d:	74 2b                	je     8028aa <alloc_block+0x40>
  80287f:	83 f8 02             	cmp    $0x2,%eax
  802882:	7f 07                	jg     80288b <alloc_block+0x21>
  802884:	83 f8 01             	cmp    $0x1,%eax
  802887:	74 0e                	je     802897 <alloc_block+0x2d>
  802889:	eb 58                	jmp    8028e3 <alloc_block+0x79>
  80288b:	83 f8 03             	cmp    $0x3,%eax
  80288e:	74 2d                	je     8028bd <alloc_block+0x53>
  802890:	83 f8 04             	cmp    $0x4,%eax
  802893:	74 3b                	je     8028d0 <alloc_block+0x66>
  802895:	eb 4c                	jmp    8028e3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802897:	83 ec 0c             	sub    $0xc,%esp
  80289a:	ff 75 08             	pushl  0x8(%ebp)
  80289d:	e8 11 03 00 00       	call   802bb3 <alloc_block_FF>
  8028a2:	83 c4 10             	add    $0x10,%esp
  8028a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028a8:	eb 4a                	jmp    8028f4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028aa:	83 ec 0c             	sub    $0xc,%esp
  8028ad:	ff 75 08             	pushl  0x8(%ebp)
  8028b0:	e8 fa 19 00 00       	call   8042af <alloc_block_NF>
  8028b5:	83 c4 10             	add    $0x10,%esp
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028bb:	eb 37                	jmp    8028f4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028bd:	83 ec 0c             	sub    $0xc,%esp
  8028c0:	ff 75 08             	pushl  0x8(%ebp)
  8028c3:	e8 a7 07 00 00       	call   80306f <alloc_block_BF>
  8028c8:	83 c4 10             	add    $0x10,%esp
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028ce:	eb 24                	jmp    8028f4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	ff 75 08             	pushl  0x8(%ebp)
  8028d6:	e8 b7 19 00 00       	call   804292 <alloc_block_WF>
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028e1:	eb 11                	jmp    8028f4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8028e3:	83 ec 0c             	sub    $0xc,%esp
  8028e6:	68 38 50 80 00       	push   $0x805038
  8028eb:	e8 5e e6 ff ff       	call   800f4e <cprintf>
  8028f0:	83 c4 10             	add    $0x10,%esp
		break;
  8028f3:	90                   	nop
	}
	return va;
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	53                   	push   %ebx
  8028fd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802900:	83 ec 0c             	sub    $0xc,%esp
  802903:	68 58 50 80 00       	push   $0x805058
  802908:	e8 41 e6 ff ff       	call   800f4e <cprintf>
  80290d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802910:	83 ec 0c             	sub    $0xc,%esp
  802913:	68 83 50 80 00       	push   $0x805083
  802918:	e8 31 e6 ff ff       	call   800f4e <cprintf>
  80291d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802926:	eb 37                	jmp    80295f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	ff 75 f4             	pushl  -0xc(%ebp)
  80292e:	e8 19 ff ff ff       	call   80284c <is_free_block>
  802933:	83 c4 10             	add    $0x10,%esp
  802936:	0f be d8             	movsbl %al,%ebx
  802939:	83 ec 0c             	sub    $0xc,%esp
  80293c:	ff 75 f4             	pushl  -0xc(%ebp)
  80293f:	e8 ef fe ff ff       	call   802833 <get_block_size>
  802944:	83 c4 10             	add    $0x10,%esp
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	53                   	push   %ebx
  80294b:	50                   	push   %eax
  80294c:	68 9b 50 80 00       	push   $0x80509b
  802951:	e8 f8 e5 ff ff       	call   800f4e <cprintf>
  802956:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802959:	8b 45 10             	mov    0x10(%ebp),%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802963:	74 07                	je     80296c <print_blocks_list+0x73>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	eb 05                	jmp    802971 <print_blocks_list+0x78>
  80296c:	b8 00 00 00 00       	mov    $0x0,%eax
  802971:	89 45 10             	mov    %eax,0x10(%ebp)
  802974:	8b 45 10             	mov    0x10(%ebp),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	75 ad                	jne    802928 <print_blocks_list+0x2f>
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	75 a7                	jne    802928 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802981:	83 ec 0c             	sub    $0xc,%esp
  802984:	68 58 50 80 00       	push   $0x805058
  802989:	e8 c0 e5 ff ff       	call   800f4e <cprintf>
  80298e:	83 c4 10             	add    $0x10,%esp

}
  802991:	90                   	nop
  802992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80299d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a0:	83 e0 01             	and    $0x1,%eax
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	74 03                	je     8029aa <initialize_dynamic_allocator+0x13>
  8029a7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8029aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029ae:	0f 84 c7 01 00 00    	je     802b7b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8029b4:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8029bb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8029be:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c4:	01 d0                	add    %edx,%eax
  8029c6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8029cb:	0f 87 ad 01 00 00    	ja     802b7e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	0f 89 a5 01 00 00    	jns    802b81 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8029dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e2:	01 d0                	add    %edx,%eax
  8029e4:	83 e8 04             	sub    $0x4,%eax
  8029e7:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8029ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8029f3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8029f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fb:	e9 87 00 00 00       	jmp    802a87 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a04:	75 14                	jne    802a1a <initialize_dynamic_allocator+0x83>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 b3 50 80 00       	push   $0x8050b3
  802a0e:	6a 79                	push   $0x79
  802a10:	68 d1 50 80 00       	push   $0x8050d1
  802a15:	e8 77 e2 ff ff       	call   800c91 <_panic>
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	74 10                	je     802a33 <initialize_dynamic_allocator+0x9c>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2b:	8b 52 04             	mov    0x4(%edx),%edx
  802a2e:	89 50 04             	mov    %edx,0x4(%eax)
  802a31:	eb 0b                	jmp    802a3e <initialize_dynamic_allocator+0xa7>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	a3 30 60 80 00       	mov    %eax,0x806030
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 40 04             	mov    0x4(%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 0f                	je     802a57 <initialize_dynamic_allocator+0xc0>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a51:	8b 12                	mov    (%edx),%edx
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	eb 0a                	jmp    802a61 <initialize_dynamic_allocator+0xca>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a74:	a1 38 60 80 00       	mov    0x806038,%eax
  802a79:	48                   	dec    %eax
  802a7a:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a7f:	a1 34 60 80 00       	mov    0x806034,%eax
  802a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8b:	74 07                	je     802a94 <initialize_dynamic_allocator+0xfd>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	eb 05                	jmp    802a99 <initialize_dynamic_allocator+0x102>
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	a3 34 60 80 00       	mov    %eax,0x806034
  802a9e:	a1 34 60 80 00       	mov    0x806034,%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	0f 85 55 ff ff ff    	jne    802a00 <initialize_dynamic_allocator+0x69>
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	0f 85 4b ff ff ff    	jne    802a00 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ac4:	a1 44 60 80 00       	mov    0x806044,%eax
  802ac9:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802ace:	a1 40 60 80 00       	mov    0x806040,%eax
  802ad3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	83 c0 08             	add    $0x8,%eax
  802adf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	83 c0 04             	add    $0x4,%eax
  802ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aeb:	83 ea 08             	sub    $0x8,%edx
  802aee:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	01 d0                	add    %edx,%eax
  802af8:	83 e8 08             	sub    $0x8,%eax
  802afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802afe:	83 ea 08             	sub    $0x8,%edx
  802b01:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802b16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1a:	75 17                	jne    802b33 <initialize_dynamic_allocator+0x19c>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 ec 50 80 00       	push   $0x8050ec
  802b24:	68 90 00 00 00       	push   $0x90
  802b29:	68 d1 50 80 00       	push   $0x8050d1
  802b2e:	e8 5e e1 ff ff       	call   800c91 <_panic>
  802b33:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0d                	je     802b54 <initialize_dynamic_allocator+0x1bd>
  802b47:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 08                	jmp    802b5c <initialize_dynamic_allocator+0x1c5>
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	a3 30 60 80 00       	mov    %eax,0x806030
  802b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 38 60 80 00       	mov    0x806038,%eax
  802b73:	40                   	inc    %eax
  802b74:	a3 38 60 80 00       	mov    %eax,0x806038
  802b79:	eb 07                	jmp    802b82 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b7b:	90                   	nop
  802b7c:	eb 04                	jmp    802b82 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b7e:	90                   	nop
  802b7f:	eb 01                	jmp    802b82 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b81:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b82:	c9                   	leave  
  802b83:	c3                   	ret    

00802b84 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b84:	55                   	push   %ebp
  802b85:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b87:	8b 45 10             	mov    0x10(%ebp),%eax
  802b8a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b96:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	83 e8 04             	sub    $0x4,%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	83 e0 fe             	and    $0xfffffffe,%eax
  802ba3:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	01 c2                	add    %eax,%edx
  802bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bae:	89 02                	mov    %eax,(%edx)
}
  802bb0:	90                   	nop
  802bb1:	5d                   	pop    %ebp
  802bb2:	c3                   	ret    

00802bb3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802bb3:	55                   	push   %ebp
  802bb4:	89 e5                	mov    %esp,%ebp
  802bb6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	83 e0 01             	and    $0x1,%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 03                	je     802bc6 <alloc_block_FF+0x13>
  802bc3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802bc6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bca:	77 07                	ja     802bd3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bcc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bd3:	a1 24 60 80 00       	mov    0x806024,%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	75 73                	jne    802c4f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	83 c0 10             	add    $0x10,%eax
  802be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802be5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802bec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  802c00:	f7 75 ec             	divl   -0x14(%ebp)
  802c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c06:	29 d0                	sub    %edx,%eax
  802c08:	c1 e8 0c             	shr    $0xc,%eax
  802c0b:	83 ec 0c             	sub    $0xc,%esp
  802c0e:	50                   	push   %eax
  802c0f:	e8 d4 f0 ff ff       	call   801ce8 <sbrk>
  802c14:	83 c4 10             	add    $0x10,%esp
  802c17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c1a:	83 ec 0c             	sub    $0xc,%esp
  802c1d:	6a 00                	push   $0x0
  802c1f:	e8 c4 f0 ff ff       	call   801ce8 <sbrk>
  802c24:	83 c4 10             	add    $0x10,%esp
  802c27:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c30:	83 ec 08             	sub    $0x8,%esp
  802c33:	50                   	push   %eax
  802c34:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c37:	e8 5b fd ff ff       	call   802997 <initialize_dynamic_allocator>
  802c3c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c3f:	83 ec 0c             	sub    $0xc,%esp
  802c42:	68 0f 51 80 00       	push   $0x80510f
  802c47:	e8 02 e3 ff ff       	call   800f4e <cprintf>
  802c4c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c53:	75 0a                	jne    802c5f <alloc_block_FF+0xac>
	        return NULL;
  802c55:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5a:	e9 0e 04 00 00       	jmp    80306d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c66:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6e:	e9 f3 02 00 00       	jmp    802f66 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c79:	83 ec 0c             	sub    $0xc,%esp
  802c7c:	ff 75 bc             	pushl  -0x44(%ebp)
  802c7f:	e8 af fb ff ff       	call   802833 <get_block_size>
  802c84:	83 c4 10             	add    $0x10,%esp
  802c87:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	83 c0 08             	add    $0x8,%eax
  802c90:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c93:	0f 87 c5 02 00 00    	ja     802f5e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	83 c0 18             	add    $0x18,%eax
  802c9f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ca2:	0f 87 19 02 00 00    	ja     802ec1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ca8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cab:	2b 45 08             	sub    0x8(%ebp),%eax
  802cae:	83 e8 08             	sub    $0x8,%eax
  802cb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8d 50 08             	lea    0x8(%eax),%edx
  802cba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	83 c0 08             	add    $0x8,%eax
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	6a 01                	push   $0x1
  802ccd:	50                   	push   %eax
  802cce:	ff 75 bc             	pushl  -0x44(%ebp)
  802cd1:	e8 ae fe ff ff       	call   802b84 <set_block_data>
  802cd6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	75 68                	jne    802d4b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ce3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ce7:	75 17                	jne    802d00 <alloc_block_FF+0x14d>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 ec 50 80 00       	push   $0x8050ec
  802cf1:	68 d7 00 00 00       	push   $0xd7
  802cf6:	68 d1 50 80 00       	push   $0x8050d1
  802cfb:	e8 91 df ff ff       	call   800c91 <_panic>
  802d00:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802d06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d09:	89 10                	mov    %edx,(%eax)
  802d0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0d                	je     802d21 <alloc_block_FF+0x16e>
  802d14:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802d19:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	eb 08                	jmp    802d29 <alloc_block_FF+0x176>
  802d21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d24:	a3 30 60 80 00       	mov    %eax,0x806030
  802d29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d2c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3b:	a1 38 60 80 00       	mov    0x806038,%eax
  802d40:	40                   	inc    %eax
  802d41:	a3 38 60 80 00       	mov    %eax,0x806038
  802d46:	e9 dc 00 00 00       	jmp    802e27 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	75 65                	jne    802db9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d54:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d58:	75 17                	jne    802d71 <alloc_block_FF+0x1be>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 20 51 80 00       	push   $0x805120
  802d62:	68 db 00 00 00       	push   $0xdb
  802d67:	68 d1 50 80 00       	push   $0x8050d1
  802d6c:	e8 20 df ff ff       	call   800c91 <_panic>
  802d71:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 0c                	je     802d93 <alloc_block_FF+0x1e0>
  802d87:	a1 30 60 80 00       	mov    0x806030,%eax
  802d8c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	eb 08                	jmp    802d9b <alloc_block_FF+0x1e8>
  802d93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d96:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9e:	a3 30 60 80 00       	mov    %eax,0x806030
  802da3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dac:	a1 38 60 80 00       	mov    0x806038,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 38 60 80 00       	mov    %eax,0x806038
  802db7:	eb 6e                	jmp    802e27 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbd:	74 06                	je     802dc5 <alloc_block_FF+0x212>
  802dbf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802dc3:	75 17                	jne    802ddc <alloc_block_FF+0x229>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 44 51 80 00       	push   $0x805144
  802dcd:	68 df 00 00 00       	push   $0xdf
  802dd2:	68 d1 50 80 00       	push   $0x8050d1
  802dd7:	e8 b5 de ff ff       	call   800c91 <_panic>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 10                	mov    (%eax),%edx
  802de1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0b                	je     802dfa <alloc_block_FF+0x247>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	75 08                	jne    802e1c <alloc_block_FF+0x269>
  802e14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e17:	a3 30 60 80 00       	mov    %eax,0x806030
  802e1c:	a1 38 60 80 00       	mov    0x806038,%eax
  802e21:	40                   	inc    %eax
  802e22:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2b:	75 17                	jne    802e44 <alloc_block_FF+0x291>
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	68 b3 50 80 00       	push   $0x8050b3
  802e35:	68 e1 00 00 00       	push   $0xe1
  802e3a:	68 d1 50 80 00       	push   $0x8050d1
  802e3f:	e8 4d de ff ff       	call   800c91 <_panic>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 10                	je     802e5d <alloc_block_FF+0x2aa>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e55:	8b 52 04             	mov    0x4(%edx),%edx
  802e58:	89 50 04             	mov    %edx,0x4(%eax)
  802e5b:	eb 0b                	jmp    802e68 <alloc_block_FF+0x2b5>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	a3 30 60 80 00       	mov    %eax,0x806030
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0f                	je     802e81 <alloc_block_FF+0x2ce>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7b:	8b 12                	mov    (%edx),%edx
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	eb 0a                	jmp    802e8b <alloc_block_FF+0x2d8>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9e:	a1 38 60 80 00       	mov    0x806038,%eax
  802ea3:	48                   	dec    %eax
  802ea4:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	6a 00                	push   $0x0
  802eae:	ff 75 b4             	pushl  -0x4c(%ebp)
  802eb1:	ff 75 b0             	pushl  -0x50(%ebp)
  802eb4:	e8 cb fc ff ff       	call   802b84 <set_block_data>
  802eb9:	83 c4 10             	add    $0x10,%esp
  802ebc:	e9 95 00 00 00       	jmp    802f56 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	6a 01                	push   $0x1
  802ec6:	ff 75 b8             	pushl  -0x48(%ebp)
  802ec9:	ff 75 bc             	pushl  -0x44(%ebp)
  802ecc:	e8 b3 fc ff ff       	call   802b84 <set_block_data>
  802ed1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	75 17                	jne    802ef1 <alloc_block_FF+0x33e>
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	68 b3 50 80 00       	push   $0x8050b3
  802ee2:	68 e8 00 00 00       	push   $0xe8
  802ee7:	68 d1 50 80 00       	push   $0x8050d1
  802eec:	e8 a0 dd ff ff       	call   800c91 <_panic>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 10                	je     802f0a <alloc_block_FF+0x357>
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f02:	8b 52 04             	mov    0x4(%edx),%edx
  802f05:	89 50 04             	mov    %edx,0x4(%eax)
  802f08:	eb 0b                	jmp    802f15 <alloc_block_FF+0x362>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 04             	mov    0x4(%eax),%eax
  802f10:	a3 30 60 80 00       	mov    %eax,0x806030
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0f                	je     802f2e <alloc_block_FF+0x37b>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f28:	8b 12                	mov    (%edx),%edx
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	eb 0a                	jmp    802f38 <alloc_block_FF+0x385>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 38 60 80 00       	mov    0x806038,%eax
  802f50:	48                   	dec    %eax
  802f51:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802f56:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f59:	e9 0f 01 00 00       	jmp    80306d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f5e:	a1 34 60 80 00       	mov    0x806034,%eax
  802f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6a:	74 07                	je     802f73 <alloc_block_FF+0x3c0>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	eb 05                	jmp    802f78 <alloc_block_FF+0x3c5>
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
  802f78:	a3 34 60 80 00       	mov    %eax,0x806034
  802f7d:	a1 34 60 80 00       	mov    0x806034,%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	0f 85 e9 fc ff ff    	jne    802c73 <alloc_block_FF+0xc0>
  802f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8e:	0f 85 df fc ff ff    	jne    802c73 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	83 c0 08             	add    $0x8,%eax
  802f9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f9d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fa4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802faa:	01 d0                	add    %edx,%eax
  802fac:	48                   	dec    %eax
  802fad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb8:	f7 75 d8             	divl   -0x28(%ebp)
  802fbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fbe:	29 d0                	sub    %edx,%eax
  802fc0:	c1 e8 0c             	shr    $0xc,%eax
  802fc3:	83 ec 0c             	sub    $0xc,%esp
  802fc6:	50                   	push   %eax
  802fc7:	e8 1c ed ff ff       	call   801ce8 <sbrk>
  802fcc:	83 c4 10             	add    $0x10,%esp
  802fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802fd2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802fd6:	75 0a                	jne    802fe2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdd:	e9 8b 00 00 00       	jmp    80306d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802fe2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802fe9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fef:	01 d0                	add    %edx,%eax
  802ff1:	48                   	dec    %eax
  802ff2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ff5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffd:	f7 75 cc             	divl   -0x34(%ebp)
  803000:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803003:	29 d0                	sub    %edx,%eax
  803005:	8d 50 fc             	lea    -0x4(%eax),%edx
  803008:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80300b:	01 d0                	add    %edx,%eax
  80300d:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803012:	a1 40 60 80 00       	mov    0x806040,%eax
  803017:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80301d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803024:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803027:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80302a:	01 d0                	add    %edx,%eax
  80302c:	48                   	dec    %eax
  80302d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803030:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803033:	ba 00 00 00 00       	mov    $0x0,%edx
  803038:	f7 75 c4             	divl   -0x3c(%ebp)
  80303b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80303e:	29 d0                	sub    %edx,%eax
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	6a 01                	push   $0x1
  803045:	50                   	push   %eax
  803046:	ff 75 d0             	pushl  -0x30(%ebp)
  803049:	e8 36 fb ff ff       	call   802b84 <set_block_data>
  80304e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803051:	83 ec 0c             	sub    $0xc,%esp
  803054:	ff 75 d0             	pushl  -0x30(%ebp)
  803057:	e8 1b 0a 00 00       	call   803a77 <free_block>
  80305c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80305f:	83 ec 0c             	sub    $0xc,%esp
  803062:	ff 75 08             	pushl  0x8(%ebp)
  803065:	e8 49 fb ff ff       	call   802bb3 <alloc_block_FF>
  80306a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80306d:	c9                   	leave  
  80306e:	c3                   	ret    

0080306f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
  803072:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	83 e0 01             	and    $0x1,%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 03                	je     803082 <alloc_block_BF+0x13>
  80307f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803082:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803086:	77 07                	ja     80308f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803088:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80308f:	a1 24 60 80 00       	mov    0x806024,%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	75 73                	jne    80310b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	83 c0 10             	add    $0x10,%eax
  80309e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030a1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8030a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ae:	01 d0                	add    %edx,%eax
  8030b0:	48                   	dec    %eax
  8030b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8030bc:	f7 75 e0             	divl   -0x20(%ebp)
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	29 d0                	sub    %edx,%eax
  8030c4:	c1 e8 0c             	shr    $0xc,%eax
  8030c7:	83 ec 0c             	sub    $0xc,%esp
  8030ca:	50                   	push   %eax
  8030cb:	e8 18 ec ff ff       	call   801ce8 <sbrk>
  8030d0:	83 c4 10             	add    $0x10,%esp
  8030d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8030d6:	83 ec 0c             	sub    $0xc,%esp
  8030d9:	6a 00                	push   $0x0
  8030db:	e8 08 ec ff ff       	call   801ce8 <sbrk>
  8030e0:	83 c4 10             	add    $0x10,%esp
  8030e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8030e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8030e9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8030ec:	83 ec 08             	sub    $0x8,%esp
  8030ef:	50                   	push   %eax
  8030f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8030f3:	e8 9f f8 ff ff       	call   802997 <initialize_dynamic_allocator>
  8030f8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030fb:	83 ec 0c             	sub    $0xc,%esp
  8030fe:	68 0f 51 80 00       	push   $0x80510f
  803103:	e8 46 de ff ff       	call   800f4e <cprintf>
  803108:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80310b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803119:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803120:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803127:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80312c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312f:	e9 1d 01 00 00       	jmp    803251 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80313a:	83 ec 0c             	sub    $0xc,%esp
  80313d:	ff 75 a8             	pushl  -0x58(%ebp)
  803140:	e8 ee f6 ff ff       	call   802833 <get_block_size>
  803145:	83 c4 10             	add    $0x10,%esp
  803148:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	83 c0 08             	add    $0x8,%eax
  803151:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803154:	0f 87 ef 00 00 00    	ja     803249 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	83 c0 18             	add    $0x18,%eax
  803160:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803163:	77 1d                	ja     803182 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803168:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80316b:	0f 86 d8 00 00 00    	jbe    803249 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803171:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803174:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803177:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80317a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80317d:	e9 c7 00 00 00       	jmp    803249 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	83 c0 08             	add    $0x8,%eax
  803188:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80318b:	0f 85 9d 00 00 00    	jne    80322e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	6a 01                	push   $0x1
  803196:	ff 75 a4             	pushl  -0x5c(%ebp)
  803199:	ff 75 a8             	pushl  -0x58(%ebp)
  80319c:	e8 e3 f9 ff ff       	call   802b84 <set_block_data>
  8031a1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a8:	75 17                	jne    8031c1 <alloc_block_BF+0x152>
  8031aa:	83 ec 04             	sub    $0x4,%esp
  8031ad:	68 b3 50 80 00       	push   $0x8050b3
  8031b2:	68 2c 01 00 00       	push   $0x12c
  8031b7:	68 d1 50 80 00       	push   $0x8050d1
  8031bc:	e8 d0 da ff ff       	call   800c91 <_panic>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 10                	je     8031da <alloc_block_BF+0x16b>
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d2:	8b 52 04             	mov    0x4(%edx),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 0b                	jmp    8031e5 <alloc_block_BF+0x176>
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	a3 30 60 80 00       	mov    %eax,0x806030
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0f                	je     8031fe <alloc_block_BF+0x18f>
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f8:	8b 12                	mov    (%edx),%edx
  8031fa:	89 10                	mov    %edx,(%eax)
  8031fc:	eb 0a                	jmp    803208 <alloc_block_BF+0x199>
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321b:	a1 38 60 80 00       	mov    0x806038,%eax
  803220:	48                   	dec    %eax
  803221:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803226:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803229:	e9 24 04 00 00       	jmp    803652 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80322e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803231:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803234:	76 13                	jbe    803249 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803236:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80323d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803240:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803243:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803246:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803249:	a1 34 60 80 00       	mov    0x806034,%eax
  80324e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803255:	74 07                	je     80325e <alloc_block_BF+0x1ef>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	eb 05                	jmp    803263 <alloc_block_BF+0x1f4>
  80325e:	b8 00 00 00 00       	mov    $0x0,%eax
  803263:	a3 34 60 80 00       	mov    %eax,0x806034
  803268:	a1 34 60 80 00       	mov    0x806034,%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	0f 85 bf fe ff ff    	jne    803134 <alloc_block_BF+0xc5>
  803275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803279:	0f 85 b5 fe ff ff    	jne    803134 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80327f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803283:	0f 84 26 02 00 00    	je     8034af <alloc_block_BF+0x440>
  803289:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80328d:	0f 85 1c 02 00 00    	jne    8034af <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803296:	2b 45 08             	sub    0x8(%ebp),%eax
  803299:	83 e8 08             	sub    $0x8,%eax
  80329c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	8d 50 08             	lea    0x8(%eax),%edx
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	01 d0                	add    %edx,%eax
  8032aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	83 c0 08             	add    $0x8,%eax
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	6a 01                	push   $0x1
  8032b8:	50                   	push   %eax
  8032b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8032bc:	e8 c3 f8 ff ff       	call   802b84 <set_block_data>
  8032c1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8032c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	75 68                	jne    803336 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032d2:	75 17                	jne    8032eb <alloc_block_BF+0x27c>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 ec 50 80 00       	push   $0x8050ec
  8032dc:	68 45 01 00 00       	push   $0x145
  8032e1:	68 d1 50 80 00       	push   $0x8050d1
  8032e6:	e8 a6 d9 ff ff       	call   800c91 <_panic>
  8032eb:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8032f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f4:	89 10                	mov    %edx,(%eax)
  8032f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	85 c0                	test   %eax,%eax
  8032fd:	74 0d                	je     80330c <alloc_block_BF+0x29d>
  8032ff:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803304:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803307:	89 50 04             	mov    %edx,0x4(%eax)
  80330a:	eb 08                	jmp    803314 <alloc_block_BF+0x2a5>
  80330c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330f:	a3 30 60 80 00       	mov    %eax,0x806030
  803314:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803317:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80331c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80331f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803326:	a1 38 60 80 00       	mov    0x806038,%eax
  80332b:	40                   	inc    %eax
  80332c:	a3 38 60 80 00       	mov    %eax,0x806038
  803331:	e9 dc 00 00 00       	jmp    803412 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	75 65                	jne    8033a4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80333f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803343:	75 17                	jne    80335c <alloc_block_BF+0x2ed>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 20 51 80 00       	push   $0x805120
  80334d:	68 4a 01 00 00       	push   $0x14a
  803352:	68 d1 50 80 00       	push   $0x8050d1
  803357:	e8 35 d9 ff ff       	call   800c91 <_panic>
  80335c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803362:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0c                	je     80337e <alloc_block_BF+0x30f>
  803372:	a1 30 60 80 00       	mov    0x806030,%eax
  803377:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80337a:	89 10                	mov    %edx,(%eax)
  80337c:	eb 08                	jmp    803386 <alloc_block_BF+0x317>
  80337e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803381:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803386:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803389:	a3 30 60 80 00       	mov    %eax,0x806030
  80338e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803397:	a1 38 60 80 00       	mov    0x806038,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 38 60 80 00       	mov    %eax,0x806038
  8033a2:	eb 6e                	jmp    803412 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8033a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a8:	74 06                	je     8033b0 <alloc_block_BF+0x341>
  8033aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033ae:	75 17                	jne    8033c7 <alloc_block_BF+0x358>
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	68 44 51 80 00       	push   $0x805144
  8033b8:	68 4f 01 00 00       	push   $0x14f
  8033bd:	68 d1 50 80 00       	push   $0x8050d1
  8033c2:	e8 ca d8 ff ff       	call   800c91 <_panic>
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 10                	mov    (%eax),%edx
  8033cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033cf:	89 10                	mov    %edx,(%eax)
  8033d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	74 0b                	je     8033e5 <alloc_block_BF+0x376>
  8033da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033dd:	8b 00                	mov    (%eax),%eax
  8033df:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033e2:	89 50 04             	mov    %edx,0x4(%eax)
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033eb:	89 10                	mov    %edx,(%eax)
  8033ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f3:	89 50 04             	mov    %edx,0x4(%eax)
  8033f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f9:	8b 00                	mov    (%eax),%eax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	75 08                	jne    803407 <alloc_block_BF+0x398>
  8033ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803402:	a3 30 60 80 00       	mov    %eax,0x806030
  803407:	a1 38 60 80 00       	mov    0x806038,%eax
  80340c:	40                   	inc    %eax
  80340d:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803412:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803416:	75 17                	jne    80342f <alloc_block_BF+0x3c0>
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	68 b3 50 80 00       	push   $0x8050b3
  803420:	68 51 01 00 00       	push   $0x151
  803425:	68 d1 50 80 00       	push   $0x8050d1
  80342a:	e8 62 d8 ff ff       	call   800c91 <_panic>
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 10                	je     803448 <alloc_block_BF+0x3d9>
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803440:	8b 52 04             	mov    0x4(%edx),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	eb 0b                	jmp    803453 <alloc_block_BF+0x3e4>
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	8b 40 04             	mov    0x4(%eax),%eax
  80344e:	a3 30 60 80 00       	mov    %eax,0x806030
  803453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803456:	8b 40 04             	mov    0x4(%eax),%eax
  803459:	85 c0                	test   %eax,%eax
  80345b:	74 0f                	je     80346c <alloc_block_BF+0x3fd>
  80345d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803460:	8b 40 04             	mov    0x4(%eax),%eax
  803463:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803466:	8b 12                	mov    (%edx),%edx
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	eb 0a                	jmp    803476 <alloc_block_BF+0x407>
  80346c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803489:	a1 38 60 80 00       	mov    0x806038,%eax
  80348e:	48                   	dec    %eax
  80348f:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803494:	83 ec 04             	sub    $0x4,%esp
  803497:	6a 00                	push   $0x0
  803499:	ff 75 d0             	pushl  -0x30(%ebp)
  80349c:	ff 75 cc             	pushl  -0x34(%ebp)
  80349f:	e8 e0 f6 ff ff       	call   802b84 <set_block_data>
  8034a4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8034a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034aa:	e9 a3 01 00 00       	jmp    803652 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8034af:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8034b3:	0f 85 9d 00 00 00    	jne    803556 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	6a 01                	push   $0x1
  8034be:	ff 75 ec             	pushl  -0x14(%ebp)
  8034c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c4:	e8 bb f6 ff ff       	call   802b84 <set_block_data>
  8034c9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8034cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d0:	75 17                	jne    8034e9 <alloc_block_BF+0x47a>
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	68 b3 50 80 00       	push   $0x8050b3
  8034da:	68 58 01 00 00       	push   $0x158
  8034df:	68 d1 50 80 00       	push   $0x8050d1
  8034e4:	e8 a8 d7 ff ff       	call   800c91 <_panic>
  8034e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 10                	je     803502 <alloc_block_BF+0x493>
  8034f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034fa:	8b 52 04             	mov    0x4(%edx),%edx
  8034fd:	89 50 04             	mov    %edx,0x4(%eax)
  803500:	eb 0b                	jmp    80350d <alloc_block_BF+0x49e>
  803502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803505:	8b 40 04             	mov    0x4(%eax),%eax
  803508:	a3 30 60 80 00       	mov    %eax,0x806030
  80350d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803510:	8b 40 04             	mov    0x4(%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	74 0f                	je     803526 <alloc_block_BF+0x4b7>
  803517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351a:	8b 40 04             	mov    0x4(%eax),%eax
  80351d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803520:	8b 12                	mov    (%edx),%edx
  803522:	89 10                	mov    %edx,(%eax)
  803524:	eb 0a                	jmp    803530 <alloc_block_BF+0x4c1>
  803526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803543:	a1 38 60 80 00       	mov    0x806038,%eax
  803548:	48                   	dec    %eax
  803549:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  80354e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803551:	e9 fc 00 00 00       	jmp    803652 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	83 c0 08             	add    $0x8,%eax
  80355c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80355f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803566:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803569:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80356c:	01 d0                	add    %edx,%eax
  80356e:	48                   	dec    %eax
  80356f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803572:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803575:	ba 00 00 00 00       	mov    $0x0,%edx
  80357a:	f7 75 c4             	divl   -0x3c(%ebp)
  80357d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803580:	29 d0                	sub    %edx,%eax
  803582:	c1 e8 0c             	shr    $0xc,%eax
  803585:	83 ec 0c             	sub    $0xc,%esp
  803588:	50                   	push   %eax
  803589:	e8 5a e7 ff ff       	call   801ce8 <sbrk>
  80358e:	83 c4 10             	add    $0x10,%esp
  803591:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803594:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803598:	75 0a                	jne    8035a4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80359a:	b8 00 00 00 00       	mov    $0x0,%eax
  80359f:	e9 ae 00 00 00       	jmp    803652 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035a4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8035ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b1:	01 d0                	add    %edx,%eax
  8035b3:	48                   	dec    %eax
  8035b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8035b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8035bf:	f7 75 b8             	divl   -0x48(%ebp)
  8035c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035c5:	29 d0                	sub    %edx,%eax
  8035c7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8035cd:	01 d0                	add    %edx,%eax
  8035cf:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8035d4:	a1 40 60 80 00       	mov    0x806040,%eax
  8035d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8035df:	83 ec 0c             	sub    $0xc,%esp
  8035e2:	68 78 51 80 00       	push   $0x805178
  8035e7:	e8 62 d9 ff ff       	call   800f4e <cprintf>
  8035ec:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8035ef:	83 ec 08             	sub    $0x8,%esp
  8035f2:	ff 75 bc             	pushl  -0x44(%ebp)
  8035f5:	68 7d 51 80 00       	push   $0x80517d
  8035fa:	e8 4f d9 ff ff       	call   800f4e <cprintf>
  8035ff:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803602:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803609:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80360c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80360f:	01 d0                	add    %edx,%eax
  803611:	48                   	dec    %eax
  803612:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803615:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803618:	ba 00 00 00 00       	mov    $0x0,%edx
  80361d:	f7 75 b0             	divl   -0x50(%ebp)
  803620:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803623:	29 d0                	sub    %edx,%eax
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	6a 01                	push   $0x1
  80362a:	50                   	push   %eax
  80362b:	ff 75 bc             	pushl  -0x44(%ebp)
  80362e:	e8 51 f5 ff ff       	call   802b84 <set_block_data>
  803633:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803636:	83 ec 0c             	sub    $0xc,%esp
  803639:	ff 75 bc             	pushl  -0x44(%ebp)
  80363c:	e8 36 04 00 00       	call   803a77 <free_block>
  803641:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803644:	83 ec 0c             	sub    $0xc,%esp
  803647:	ff 75 08             	pushl  0x8(%ebp)
  80364a:	e8 20 fa ff ff       	call   80306f <alloc_block_BF>
  80364f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803652:	c9                   	leave  
  803653:	c3                   	ret    

00803654 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803654:	55                   	push   %ebp
  803655:	89 e5                	mov    %esp,%ebp
  803657:	53                   	push   %ebx
  803658:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80365b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803662:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803669:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366d:	74 1e                	je     80368d <merging+0x39>
  80366f:	ff 75 08             	pushl  0x8(%ebp)
  803672:	e8 bc f1 ff ff       	call   802833 <get_block_size>
  803677:	83 c4 04             	add    $0x4,%esp
  80367a:	89 c2                	mov    %eax,%edx
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	01 d0                	add    %edx,%eax
  803681:	3b 45 10             	cmp    0x10(%ebp),%eax
  803684:	75 07                	jne    80368d <merging+0x39>
		prev_is_free = 1;
  803686:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80368d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803691:	74 1e                	je     8036b1 <merging+0x5d>
  803693:	ff 75 10             	pushl  0x10(%ebp)
  803696:	e8 98 f1 ff ff       	call   802833 <get_block_size>
  80369b:	83 c4 04             	add    $0x4,%esp
  80369e:	89 c2                	mov    %eax,%edx
  8036a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8036a3:	01 d0                	add    %edx,%eax
  8036a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036a8:	75 07                	jne    8036b1 <merging+0x5d>
		next_is_free = 1;
  8036aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8036b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b5:	0f 84 cc 00 00 00    	je     803787 <merging+0x133>
  8036bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036bf:	0f 84 c2 00 00 00    	je     803787 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8036c5:	ff 75 08             	pushl  0x8(%ebp)
  8036c8:	e8 66 f1 ff ff       	call   802833 <get_block_size>
  8036cd:	83 c4 04             	add    $0x4,%esp
  8036d0:	89 c3                	mov    %eax,%ebx
  8036d2:	ff 75 10             	pushl  0x10(%ebp)
  8036d5:	e8 59 f1 ff ff       	call   802833 <get_block_size>
  8036da:	83 c4 04             	add    $0x4,%esp
  8036dd:	01 c3                	add    %eax,%ebx
  8036df:	ff 75 0c             	pushl  0xc(%ebp)
  8036e2:	e8 4c f1 ff ff       	call   802833 <get_block_size>
  8036e7:	83 c4 04             	add    $0x4,%esp
  8036ea:	01 d8                	add    %ebx,%eax
  8036ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036ef:	6a 00                	push   $0x0
  8036f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8036f4:	ff 75 08             	pushl  0x8(%ebp)
  8036f7:	e8 88 f4 ff ff       	call   802b84 <set_block_data>
  8036fc:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8036ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803703:	75 17                	jne    80371c <merging+0xc8>
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 b3 50 80 00       	push   $0x8050b3
  80370d:	68 7d 01 00 00       	push   $0x17d
  803712:	68 d1 50 80 00       	push   $0x8050d1
  803717:	e8 75 d5 ff ff       	call   800c91 <_panic>
  80371c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 10                	je     803735 <merging+0xe1>
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80372d:	8b 52 04             	mov    0x4(%edx),%edx
  803730:	89 50 04             	mov    %edx,0x4(%eax)
  803733:	eb 0b                	jmp    803740 <merging+0xec>
  803735:	8b 45 0c             	mov    0xc(%ebp),%eax
  803738:	8b 40 04             	mov    0x4(%eax),%eax
  80373b:	a3 30 60 80 00       	mov    %eax,0x806030
  803740:	8b 45 0c             	mov    0xc(%ebp),%eax
  803743:	8b 40 04             	mov    0x4(%eax),%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	74 0f                	je     803759 <merging+0x105>
  80374a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374d:	8b 40 04             	mov    0x4(%eax),%eax
  803750:	8b 55 0c             	mov    0xc(%ebp),%edx
  803753:	8b 12                	mov    (%edx),%edx
  803755:	89 10                	mov    %edx,(%eax)
  803757:	eb 0a                	jmp    803763 <merging+0x10f>
  803759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803763:	8b 45 0c             	mov    0xc(%ebp),%eax
  803766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803776:	a1 38 60 80 00       	mov    0x806038,%eax
  80377b:	48                   	dec    %eax
  80377c:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803781:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803782:	e9 ea 02 00 00       	jmp    803a71 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378b:	74 3b                	je     8037c8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80378d:	83 ec 0c             	sub    $0xc,%esp
  803790:	ff 75 08             	pushl  0x8(%ebp)
  803793:	e8 9b f0 ff ff       	call   802833 <get_block_size>
  803798:	83 c4 10             	add    $0x10,%esp
  80379b:	89 c3                	mov    %eax,%ebx
  80379d:	83 ec 0c             	sub    $0xc,%esp
  8037a0:	ff 75 10             	pushl  0x10(%ebp)
  8037a3:	e8 8b f0 ff ff       	call   802833 <get_block_size>
  8037a8:	83 c4 10             	add    $0x10,%esp
  8037ab:	01 d8                	add    %ebx,%eax
  8037ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	6a 00                	push   $0x0
  8037b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8037b8:	ff 75 08             	pushl  0x8(%ebp)
  8037bb:	e8 c4 f3 ff ff       	call   802b84 <set_block_data>
  8037c0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037c3:	e9 a9 02 00 00       	jmp    803a71 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8037c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cc:	0f 84 2d 01 00 00    	je     8038ff <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8037d2:	83 ec 0c             	sub    $0xc,%esp
  8037d5:	ff 75 10             	pushl  0x10(%ebp)
  8037d8:	e8 56 f0 ff ff       	call   802833 <get_block_size>
  8037dd:	83 c4 10             	add    $0x10,%esp
  8037e0:	89 c3                	mov    %eax,%ebx
  8037e2:	83 ec 0c             	sub    $0xc,%esp
  8037e5:	ff 75 0c             	pushl  0xc(%ebp)
  8037e8:	e8 46 f0 ff ff       	call   802833 <get_block_size>
  8037ed:	83 c4 10             	add    $0x10,%esp
  8037f0:	01 d8                	add    %ebx,%eax
  8037f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8037f5:	83 ec 04             	sub    $0x4,%esp
  8037f8:	6a 00                	push   $0x0
  8037fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037fd:	ff 75 10             	pushl  0x10(%ebp)
  803800:	e8 7f f3 ff ff       	call   802b84 <set_block_data>
  803805:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803808:	8b 45 10             	mov    0x10(%ebp),%eax
  80380b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80380e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803812:	74 06                	je     80381a <merging+0x1c6>
  803814:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803818:	75 17                	jne    803831 <merging+0x1dd>
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	68 8c 51 80 00       	push   $0x80518c
  803822:	68 8d 01 00 00       	push   $0x18d
  803827:	68 d1 50 80 00       	push   $0x8050d1
  80382c:	e8 60 d4 ff ff       	call   800c91 <_panic>
  803831:	8b 45 0c             	mov    0xc(%ebp),%eax
  803834:	8b 50 04             	mov    0x4(%eax),%edx
  803837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383a:	89 50 04             	mov    %edx,0x4(%eax)
  80383d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803840:	8b 55 0c             	mov    0xc(%ebp),%edx
  803843:	89 10                	mov    %edx,(%eax)
  803845:	8b 45 0c             	mov    0xc(%ebp),%eax
  803848:	8b 40 04             	mov    0x4(%eax),%eax
  80384b:	85 c0                	test   %eax,%eax
  80384d:	74 0d                	je     80385c <merging+0x208>
  80384f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803858:	89 10                	mov    %edx,(%eax)
  80385a:	eb 08                	jmp    803864 <merging+0x210>
  80385c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803864:	8b 45 0c             	mov    0xc(%ebp),%eax
  803867:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80386a:	89 50 04             	mov    %edx,0x4(%eax)
  80386d:	a1 38 60 80 00       	mov    0x806038,%eax
  803872:	40                   	inc    %eax
  803873:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803878:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80387c:	75 17                	jne    803895 <merging+0x241>
  80387e:	83 ec 04             	sub    $0x4,%esp
  803881:	68 b3 50 80 00       	push   $0x8050b3
  803886:	68 8e 01 00 00       	push   $0x18e
  80388b:	68 d1 50 80 00       	push   $0x8050d1
  803890:	e8 fc d3 ff ff       	call   800c91 <_panic>
  803895:	8b 45 0c             	mov    0xc(%ebp),%eax
  803898:	8b 00                	mov    (%eax),%eax
  80389a:	85 c0                	test   %eax,%eax
  80389c:	74 10                	je     8038ae <merging+0x25a>
  80389e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a1:	8b 00                	mov    (%eax),%eax
  8038a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038a6:	8b 52 04             	mov    0x4(%edx),%edx
  8038a9:	89 50 04             	mov    %edx,0x4(%eax)
  8038ac:	eb 0b                	jmp    8038b9 <merging+0x265>
  8038ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b1:	8b 40 04             	mov    0x4(%eax),%eax
  8038b4:	a3 30 60 80 00       	mov    %eax,0x806030
  8038b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bc:	8b 40 04             	mov    0x4(%eax),%eax
  8038bf:	85 c0                	test   %eax,%eax
  8038c1:	74 0f                	je     8038d2 <merging+0x27e>
  8038c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c6:	8b 40 04             	mov    0x4(%eax),%eax
  8038c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038cc:	8b 12                	mov    (%edx),%edx
  8038ce:	89 10                	mov    %edx,(%eax)
  8038d0:	eb 0a                	jmp    8038dc <merging+0x288>
  8038d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d5:	8b 00                	mov    (%eax),%eax
  8038d7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ef:	a1 38 60 80 00       	mov    0x806038,%eax
  8038f4:	48                   	dec    %eax
  8038f5:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038fa:	e9 72 01 00 00       	jmp    803a71 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8038ff:	8b 45 10             	mov    0x10(%ebp),%eax
  803902:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803909:	74 79                	je     803984 <merging+0x330>
  80390b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80390f:	74 73                	je     803984 <merging+0x330>
  803911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803915:	74 06                	je     80391d <merging+0x2c9>
  803917:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80391b:	75 17                	jne    803934 <merging+0x2e0>
  80391d:	83 ec 04             	sub    $0x4,%esp
  803920:	68 44 51 80 00       	push   $0x805144
  803925:	68 94 01 00 00       	push   $0x194
  80392a:	68 d1 50 80 00       	push   $0x8050d1
  80392f:	e8 5d d3 ff ff       	call   800c91 <_panic>
  803934:	8b 45 08             	mov    0x8(%ebp),%eax
  803937:	8b 10                	mov    (%eax),%edx
  803939:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393c:	89 10                	mov    %edx,(%eax)
  80393e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 0b                	je     803952 <merging+0x2fe>
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	8b 00                	mov    (%eax),%eax
  80394c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80394f:	89 50 04             	mov    %edx,0x4(%eax)
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395d:	8b 55 08             	mov    0x8(%ebp),%edx
  803960:	89 50 04             	mov    %edx,0x4(%eax)
  803963:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	85 c0                	test   %eax,%eax
  80396a:	75 08                	jne    803974 <merging+0x320>
  80396c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396f:	a3 30 60 80 00       	mov    %eax,0x806030
  803974:	a1 38 60 80 00       	mov    0x806038,%eax
  803979:	40                   	inc    %eax
  80397a:	a3 38 60 80 00       	mov    %eax,0x806038
  80397f:	e9 ce 00 00 00       	jmp    803a52 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803984:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803988:	74 65                	je     8039ef <merging+0x39b>
  80398a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80398e:	75 17                	jne    8039a7 <merging+0x353>
  803990:	83 ec 04             	sub    $0x4,%esp
  803993:	68 20 51 80 00       	push   $0x805120
  803998:	68 95 01 00 00       	push   $0x195
  80399d:	68 d1 50 80 00       	push   $0x8050d1
  8039a2:	e8 ea d2 ff ff       	call   800c91 <_panic>
  8039a7:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8039ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b0:	89 50 04             	mov    %edx,0x4(%eax)
  8039b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b6:	8b 40 04             	mov    0x4(%eax),%eax
  8039b9:	85 c0                	test   %eax,%eax
  8039bb:	74 0c                	je     8039c9 <merging+0x375>
  8039bd:	a1 30 60 80 00       	mov    0x806030,%eax
  8039c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039c5:	89 10                	mov    %edx,(%eax)
  8039c7:	eb 08                	jmp    8039d1 <merging+0x37d>
  8039c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cc:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d4:	a3 30 60 80 00       	mov    %eax,0x806030
  8039d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e2:	a1 38 60 80 00       	mov    0x806038,%eax
  8039e7:	40                   	inc    %eax
  8039e8:	a3 38 60 80 00       	mov    %eax,0x806038
  8039ed:	eb 63                	jmp    803a52 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8039ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039f3:	75 17                	jne    803a0c <merging+0x3b8>
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	68 ec 50 80 00       	push   $0x8050ec
  8039fd:	68 98 01 00 00       	push   $0x198
  803a02:	68 d1 50 80 00       	push   $0x8050d1
  803a07:	e8 85 d2 ff ff       	call   800c91 <_panic>
  803a0c:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803a12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a15:	89 10                	mov    %edx,(%eax)
  803a17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	85 c0                	test   %eax,%eax
  803a1e:	74 0d                	je     803a2d <merging+0x3d9>
  803a20:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a28:	89 50 04             	mov    %edx,0x4(%eax)
  803a2b:	eb 08                	jmp    803a35 <merging+0x3e1>
  803a2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a30:	a3 30 60 80 00       	mov    %eax,0x806030
  803a35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a38:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a47:	a1 38 60 80 00       	mov    0x806038,%eax
  803a4c:	40                   	inc    %eax
  803a4d:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803a52:	83 ec 0c             	sub    $0xc,%esp
  803a55:	ff 75 10             	pushl  0x10(%ebp)
  803a58:	e8 d6 ed ff ff       	call   802833 <get_block_size>
  803a5d:	83 c4 10             	add    $0x10,%esp
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	6a 00                	push   $0x0
  803a65:	50                   	push   %eax
  803a66:	ff 75 10             	pushl  0x10(%ebp)
  803a69:	e8 16 f1 ff ff       	call   802b84 <set_block_data>
  803a6e:	83 c4 10             	add    $0x10,%esp
	}
}
  803a71:	90                   	nop
  803a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a75:	c9                   	leave  
  803a76:	c3                   	ret    

00803a77 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a77:	55                   	push   %ebp
  803a78:	89 e5                	mov    %esp,%ebp
  803a7a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a7d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a82:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a85:	a1 30 60 80 00       	mov    0x806030,%eax
  803a8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a8d:	73 1b                	jae    803aaa <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a8f:	a1 30 60 80 00       	mov    0x806030,%eax
  803a94:	83 ec 04             	sub    $0x4,%esp
  803a97:	ff 75 08             	pushl  0x8(%ebp)
  803a9a:	6a 00                	push   $0x0
  803a9c:	50                   	push   %eax
  803a9d:	e8 b2 fb ff ff       	call   803654 <merging>
  803aa2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aa5:	e9 8b 00 00 00       	jmp    803b35 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803aaa:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803aaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab2:	76 18                	jbe    803acc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ab4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ab9:	83 ec 04             	sub    $0x4,%esp
  803abc:	ff 75 08             	pushl  0x8(%ebp)
  803abf:	50                   	push   %eax
  803ac0:	6a 00                	push   $0x0
  803ac2:	e8 8d fb ff ff       	call   803654 <merging>
  803ac7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aca:	eb 69                	jmp    803b35 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803acc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ad4:	eb 39                	jmp    803b0f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803adc:	73 29                	jae    803b07 <free_block+0x90>
  803ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae1:	8b 00                	mov    (%eax),%eax
  803ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ae6:	76 1f                	jbe    803b07 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803af0:	83 ec 04             	sub    $0x4,%esp
  803af3:	ff 75 08             	pushl  0x8(%ebp)
  803af6:	ff 75 f0             	pushl  -0x10(%ebp)
  803af9:	ff 75 f4             	pushl  -0xc(%ebp)
  803afc:	e8 53 fb ff ff       	call   803654 <merging>
  803b01:	83 c4 10             	add    $0x10,%esp
			break;
  803b04:	90                   	nop
		}
	}
}
  803b05:	eb 2e                	jmp    803b35 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803b07:	a1 34 60 80 00       	mov    0x806034,%eax
  803b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b13:	74 07                	je     803b1c <free_block+0xa5>
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	8b 00                	mov    (%eax),%eax
  803b1a:	eb 05                	jmp    803b21 <free_block+0xaa>
  803b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b21:	a3 34 60 80 00       	mov    %eax,0x806034
  803b26:	a1 34 60 80 00       	mov    0x806034,%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	75 a7                	jne    803ad6 <free_block+0x5f>
  803b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b33:	75 a1                	jne    803ad6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b35:	90                   	nop
  803b36:	c9                   	leave  
  803b37:	c3                   	ret    

00803b38 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803b38:	55                   	push   %ebp
  803b39:	89 e5                	mov    %esp,%ebp
  803b3b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803b3e:	ff 75 08             	pushl  0x8(%ebp)
  803b41:	e8 ed ec ff ff       	call   802833 <get_block_size>
  803b46:	83 c4 04             	add    $0x4,%esp
  803b49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b53:	eb 17                	jmp    803b6c <copy_data+0x34>
  803b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5b:	01 c2                	add    %eax,%edx
  803b5d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b60:	8b 45 08             	mov    0x8(%ebp),%eax
  803b63:	01 c8                	add    %ecx,%eax
  803b65:	8a 00                	mov    (%eax),%al
  803b67:	88 02                	mov    %al,(%edx)
  803b69:	ff 45 fc             	incl   -0x4(%ebp)
  803b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b72:	72 e1                	jb     803b55 <copy_data+0x1d>
}
  803b74:	90                   	nop
  803b75:	c9                   	leave  
  803b76:	c3                   	ret    

00803b77 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b77:	55                   	push   %ebp
  803b78:	89 e5                	mov    %esp,%ebp
  803b7a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b81:	75 23                	jne    803ba6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b87:	74 13                	je     803b9c <realloc_block_FF+0x25>
  803b89:	83 ec 0c             	sub    $0xc,%esp
  803b8c:	ff 75 0c             	pushl  0xc(%ebp)
  803b8f:	e8 1f f0 ff ff       	call   802bb3 <alloc_block_FF>
  803b94:	83 c4 10             	add    $0x10,%esp
  803b97:	e9 f4 06 00 00       	jmp    804290 <realloc_block_FF+0x719>
		return NULL;
  803b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba1:	e9 ea 06 00 00       	jmp    804290 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803ba6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803baa:	75 18                	jne    803bc4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803bac:	83 ec 0c             	sub    $0xc,%esp
  803baf:	ff 75 08             	pushl  0x8(%ebp)
  803bb2:	e8 c0 fe ff ff       	call   803a77 <free_block>
  803bb7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803bba:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbf:	e9 cc 06 00 00       	jmp    804290 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803bc4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803bc8:	77 07                	ja     803bd1 <realloc_block_FF+0x5a>
  803bca:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd4:	83 e0 01             	and    $0x1,%eax
  803bd7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bdd:	83 c0 08             	add    $0x8,%eax
  803be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803be3:	83 ec 0c             	sub    $0xc,%esp
  803be6:	ff 75 08             	pushl  0x8(%ebp)
  803be9:	e8 45 ec ff ff       	call   802833 <get_block_size>
  803bee:	83 c4 10             	add    $0x10,%esp
  803bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf7:	83 e8 08             	sub    $0x8,%eax
  803bfa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803c00:	83 e8 04             	sub    $0x4,%eax
  803c03:	8b 00                	mov    (%eax),%eax
  803c05:	83 e0 fe             	and    $0xfffffffe,%eax
  803c08:	89 c2                	mov    %eax,%edx
  803c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0d:	01 d0                	add    %edx,%eax
  803c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803c12:	83 ec 0c             	sub    $0xc,%esp
  803c15:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c18:	e8 16 ec ff ff       	call   802833 <get_block_size>
  803c1d:	83 c4 10             	add    $0x10,%esp
  803c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c26:	83 e8 08             	sub    $0x8,%eax
  803c29:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c32:	75 08                	jne    803c3c <realloc_block_FF+0xc5>
	{
		 return va;
  803c34:	8b 45 08             	mov    0x8(%ebp),%eax
  803c37:	e9 54 06 00 00       	jmp    804290 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c3f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c42:	0f 83 e5 03 00 00    	jae    80402d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4b:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c51:	83 ec 0c             	sub    $0xc,%esp
  803c54:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c57:	e8 f0 eb ff ff       	call   80284c <is_free_block>
  803c5c:	83 c4 10             	add    $0x10,%esp
  803c5f:	84 c0                	test   %al,%al
  803c61:	0f 84 3b 01 00 00    	je     803da2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c6d:	01 d0                	add    %edx,%eax
  803c6f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c72:	83 ec 04             	sub    $0x4,%esp
  803c75:	6a 01                	push   $0x1
  803c77:	ff 75 f0             	pushl  -0x10(%ebp)
  803c7a:	ff 75 08             	pushl  0x8(%ebp)
  803c7d:	e8 02 ef ff ff       	call   802b84 <set_block_data>
  803c82:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c85:	8b 45 08             	mov    0x8(%ebp),%eax
  803c88:	83 e8 04             	sub    $0x4,%eax
  803c8b:	8b 00                	mov    (%eax),%eax
  803c8d:	83 e0 fe             	and    $0xfffffffe,%eax
  803c90:	89 c2                	mov    %eax,%edx
  803c92:	8b 45 08             	mov    0x8(%ebp),%eax
  803c95:	01 d0                	add    %edx,%eax
  803c97:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c9a:	83 ec 04             	sub    $0x4,%esp
  803c9d:	6a 00                	push   $0x0
  803c9f:	ff 75 cc             	pushl  -0x34(%ebp)
  803ca2:	ff 75 c8             	pushl  -0x38(%ebp)
  803ca5:	e8 da ee ff ff       	call   802b84 <set_block_data>
  803caa:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803cad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cb1:	74 06                	je     803cb9 <realloc_block_FF+0x142>
  803cb3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803cb7:	75 17                	jne    803cd0 <realloc_block_FF+0x159>
  803cb9:	83 ec 04             	sub    $0x4,%esp
  803cbc:	68 44 51 80 00       	push   $0x805144
  803cc1:	68 f6 01 00 00       	push   $0x1f6
  803cc6:	68 d1 50 80 00       	push   $0x8050d1
  803ccb:	e8 c1 cf ff ff       	call   800c91 <_panic>
  803cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd3:	8b 10                	mov    (%eax),%edx
  803cd5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cd8:	89 10                	mov    %edx,(%eax)
  803cda:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	85 c0                	test   %eax,%eax
  803ce1:	74 0b                	je     803cee <realloc_block_FF+0x177>
  803ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce6:	8b 00                	mov    (%eax),%eax
  803ce8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ceb:	89 50 04             	mov    %edx,0x4(%eax)
  803cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803cf4:	89 10                	mov    %edx,(%eax)
  803cf6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cf9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cfc:	89 50 04             	mov    %edx,0x4(%eax)
  803cff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d02:	8b 00                	mov    (%eax),%eax
  803d04:	85 c0                	test   %eax,%eax
  803d06:	75 08                	jne    803d10 <realloc_block_FF+0x199>
  803d08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d0b:	a3 30 60 80 00       	mov    %eax,0x806030
  803d10:	a1 38 60 80 00       	mov    0x806038,%eax
  803d15:	40                   	inc    %eax
  803d16:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d1f:	75 17                	jne    803d38 <realloc_block_FF+0x1c1>
  803d21:	83 ec 04             	sub    $0x4,%esp
  803d24:	68 b3 50 80 00       	push   $0x8050b3
  803d29:	68 f7 01 00 00       	push   $0x1f7
  803d2e:	68 d1 50 80 00       	push   $0x8050d1
  803d33:	e8 59 cf ff ff       	call   800c91 <_panic>
  803d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3b:	8b 00                	mov    (%eax),%eax
  803d3d:	85 c0                	test   %eax,%eax
  803d3f:	74 10                	je     803d51 <realloc_block_FF+0x1da>
  803d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d44:	8b 00                	mov    (%eax),%eax
  803d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d49:	8b 52 04             	mov    0x4(%edx),%edx
  803d4c:	89 50 04             	mov    %edx,0x4(%eax)
  803d4f:	eb 0b                	jmp    803d5c <realloc_block_FF+0x1e5>
  803d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d54:	8b 40 04             	mov    0x4(%eax),%eax
  803d57:	a3 30 60 80 00       	mov    %eax,0x806030
  803d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5f:	8b 40 04             	mov    0x4(%eax),%eax
  803d62:	85 c0                	test   %eax,%eax
  803d64:	74 0f                	je     803d75 <realloc_block_FF+0x1fe>
  803d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d69:	8b 40 04             	mov    0x4(%eax),%eax
  803d6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d6f:	8b 12                	mov    (%edx),%edx
  803d71:	89 10                	mov    %edx,(%eax)
  803d73:	eb 0a                	jmp    803d7f <realloc_block_FF+0x208>
  803d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d78:	8b 00                	mov    (%eax),%eax
  803d7a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d92:	a1 38 60 80 00       	mov    0x806038,%eax
  803d97:	48                   	dec    %eax
  803d98:	a3 38 60 80 00       	mov    %eax,0x806038
  803d9d:	e9 83 02 00 00       	jmp    804025 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803da2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803da6:	0f 86 69 02 00 00    	jbe    804015 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803dac:	83 ec 04             	sub    $0x4,%esp
  803daf:	6a 01                	push   $0x1
  803db1:	ff 75 f0             	pushl  -0x10(%ebp)
  803db4:	ff 75 08             	pushl  0x8(%ebp)
  803db7:	e8 c8 ed ff ff       	call   802b84 <set_block_data>
  803dbc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc2:	83 e8 04             	sub    $0x4,%eax
  803dc5:	8b 00                	mov    (%eax),%eax
  803dc7:	83 e0 fe             	and    $0xfffffffe,%eax
  803dca:	89 c2                	mov    %eax,%edx
  803dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcf:	01 d0                	add    %edx,%eax
  803dd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803dd4:	a1 38 60 80 00       	mov    0x806038,%eax
  803dd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ddc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803de0:	75 68                	jne    803e4a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803de2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803de6:	75 17                	jne    803dff <realloc_block_FF+0x288>
  803de8:	83 ec 04             	sub    $0x4,%esp
  803deb:	68 ec 50 80 00       	push   $0x8050ec
  803df0:	68 06 02 00 00       	push   $0x206
  803df5:	68 d1 50 80 00       	push   $0x8050d1
  803dfa:	e8 92 ce ff ff       	call   800c91 <_panic>
  803dff:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e08:	89 10                	mov    %edx,(%eax)
  803e0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e0d:	8b 00                	mov    (%eax),%eax
  803e0f:	85 c0                	test   %eax,%eax
  803e11:	74 0d                	je     803e20 <realloc_block_FF+0x2a9>
  803e13:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e1b:	89 50 04             	mov    %edx,0x4(%eax)
  803e1e:	eb 08                	jmp    803e28 <realloc_block_FF+0x2b1>
  803e20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e23:	a3 30 60 80 00       	mov    %eax,0x806030
  803e28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e3a:	a1 38 60 80 00       	mov    0x806038,%eax
  803e3f:	40                   	inc    %eax
  803e40:	a3 38 60 80 00       	mov    %eax,0x806038
  803e45:	e9 b0 01 00 00       	jmp    803ffa <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e4a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e52:	76 68                	jbe    803ebc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e54:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e58:	75 17                	jne    803e71 <realloc_block_FF+0x2fa>
  803e5a:	83 ec 04             	sub    $0x4,%esp
  803e5d:	68 ec 50 80 00       	push   $0x8050ec
  803e62:	68 0b 02 00 00       	push   $0x20b
  803e67:	68 d1 50 80 00       	push   $0x8050d1
  803e6c:	e8 20 ce ff ff       	call   800c91 <_panic>
  803e71:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7a:	89 10                	mov    %edx,(%eax)
  803e7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e7f:	8b 00                	mov    (%eax),%eax
  803e81:	85 c0                	test   %eax,%eax
  803e83:	74 0d                	je     803e92 <realloc_block_FF+0x31b>
  803e85:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e8d:	89 50 04             	mov    %edx,0x4(%eax)
  803e90:	eb 08                	jmp    803e9a <realloc_block_FF+0x323>
  803e92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e95:	a3 30 60 80 00       	mov    %eax,0x806030
  803e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ea2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eac:	a1 38 60 80 00       	mov    0x806038,%eax
  803eb1:	40                   	inc    %eax
  803eb2:	a3 38 60 80 00       	mov    %eax,0x806038
  803eb7:	e9 3e 01 00 00       	jmp    803ffa <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ebc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ec1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ec4:	73 68                	jae    803f2e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ec6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eca:	75 17                	jne    803ee3 <realloc_block_FF+0x36c>
  803ecc:	83 ec 04             	sub    $0x4,%esp
  803ecf:	68 20 51 80 00       	push   $0x805120
  803ed4:	68 10 02 00 00       	push   $0x210
  803ed9:	68 d1 50 80 00       	push   $0x8050d1
  803ede:	e8 ae cd ff ff       	call   800c91 <_panic>
  803ee3:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803ee9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eec:	89 50 04             	mov    %edx,0x4(%eax)
  803eef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ef2:	8b 40 04             	mov    0x4(%eax),%eax
  803ef5:	85 c0                	test   %eax,%eax
  803ef7:	74 0c                	je     803f05 <realloc_block_FF+0x38e>
  803ef9:	a1 30 60 80 00       	mov    0x806030,%eax
  803efe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f01:	89 10                	mov    %edx,(%eax)
  803f03:	eb 08                	jmp    803f0d <realloc_block_FF+0x396>
  803f05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f08:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f10:	a3 30 60 80 00       	mov    %eax,0x806030
  803f15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f1e:	a1 38 60 80 00       	mov    0x806038,%eax
  803f23:	40                   	inc    %eax
  803f24:	a3 38 60 80 00       	mov    %eax,0x806038
  803f29:	e9 cc 00 00 00       	jmp    803ffa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803f2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803f35:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f3d:	e9 8a 00 00 00       	jmp    803fcc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f45:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f48:	73 7a                	jae    803fc4 <realloc_block_FF+0x44d>
  803f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4d:	8b 00                	mov    (%eax),%eax
  803f4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f52:	73 70                	jae    803fc4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f58:	74 06                	je     803f60 <realloc_block_FF+0x3e9>
  803f5a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f5e:	75 17                	jne    803f77 <realloc_block_FF+0x400>
  803f60:	83 ec 04             	sub    $0x4,%esp
  803f63:	68 44 51 80 00       	push   $0x805144
  803f68:	68 1a 02 00 00       	push   $0x21a
  803f6d:	68 d1 50 80 00       	push   $0x8050d1
  803f72:	e8 1a cd ff ff       	call   800c91 <_panic>
  803f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7a:	8b 10                	mov    (%eax),%edx
  803f7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f7f:	89 10                	mov    %edx,(%eax)
  803f81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f84:	8b 00                	mov    (%eax),%eax
  803f86:	85 c0                	test   %eax,%eax
  803f88:	74 0b                	je     803f95 <realloc_block_FF+0x41e>
  803f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8d:	8b 00                	mov    (%eax),%eax
  803f8f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f92:	89 50 04             	mov    %edx,0x4(%eax)
  803f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f98:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f9b:	89 10                	mov    %edx,(%eax)
  803f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fa3:	89 50 04             	mov    %edx,0x4(%eax)
  803fa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa9:	8b 00                	mov    (%eax),%eax
  803fab:	85 c0                	test   %eax,%eax
  803fad:	75 08                	jne    803fb7 <realloc_block_FF+0x440>
  803faf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fb2:	a3 30 60 80 00       	mov    %eax,0x806030
  803fb7:	a1 38 60 80 00       	mov    0x806038,%eax
  803fbc:	40                   	inc    %eax
  803fbd:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803fc2:	eb 36                	jmp    803ffa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803fc4:	a1 34 60 80 00       	mov    0x806034,%eax
  803fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fd0:	74 07                	je     803fd9 <realloc_block_FF+0x462>
  803fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd5:	8b 00                	mov    (%eax),%eax
  803fd7:	eb 05                	jmp    803fde <realloc_block_FF+0x467>
  803fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fde:	a3 34 60 80 00       	mov    %eax,0x806034
  803fe3:	a1 34 60 80 00       	mov    0x806034,%eax
  803fe8:	85 c0                	test   %eax,%eax
  803fea:	0f 85 52 ff ff ff    	jne    803f42 <realloc_block_FF+0x3cb>
  803ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff4:	0f 85 48 ff ff ff    	jne    803f42 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ffa:	83 ec 04             	sub    $0x4,%esp
  803ffd:	6a 00                	push   $0x0
  803fff:	ff 75 d8             	pushl  -0x28(%ebp)
  804002:	ff 75 d4             	pushl  -0x2c(%ebp)
  804005:	e8 7a eb ff ff       	call   802b84 <set_block_data>
  80400a:	83 c4 10             	add    $0x10,%esp
				return va;
  80400d:	8b 45 08             	mov    0x8(%ebp),%eax
  804010:	e9 7b 02 00 00       	jmp    804290 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804015:	83 ec 0c             	sub    $0xc,%esp
  804018:	68 c1 51 80 00       	push   $0x8051c1
  80401d:	e8 2c cf ff ff       	call   800f4e <cprintf>
  804022:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804025:	8b 45 08             	mov    0x8(%ebp),%eax
  804028:	e9 63 02 00 00       	jmp    804290 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80402d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804030:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804033:	0f 86 4d 02 00 00    	jbe    804286 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804039:	83 ec 0c             	sub    $0xc,%esp
  80403c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80403f:	e8 08 e8 ff ff       	call   80284c <is_free_block>
  804044:	83 c4 10             	add    $0x10,%esp
  804047:	84 c0                	test   %al,%al
  804049:	0f 84 37 02 00 00    	je     804286 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80404f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804052:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804055:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804058:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80405b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80405e:	76 38                	jbe    804098 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804060:	83 ec 0c             	sub    $0xc,%esp
  804063:	ff 75 08             	pushl  0x8(%ebp)
  804066:	e8 0c fa ff ff       	call   803a77 <free_block>
  80406b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80406e:	83 ec 0c             	sub    $0xc,%esp
  804071:	ff 75 0c             	pushl  0xc(%ebp)
  804074:	e8 3a eb ff ff       	call   802bb3 <alloc_block_FF>
  804079:	83 c4 10             	add    $0x10,%esp
  80407c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80407f:	83 ec 08             	sub    $0x8,%esp
  804082:	ff 75 c0             	pushl  -0x40(%ebp)
  804085:	ff 75 08             	pushl  0x8(%ebp)
  804088:	e8 ab fa ff ff       	call   803b38 <copy_data>
  80408d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804090:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804093:	e9 f8 01 00 00       	jmp    804290 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80409b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80409e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8040a1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8040a5:	0f 87 a0 00 00 00    	ja     80414b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8040ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040af:	75 17                	jne    8040c8 <realloc_block_FF+0x551>
  8040b1:	83 ec 04             	sub    $0x4,%esp
  8040b4:	68 b3 50 80 00       	push   $0x8050b3
  8040b9:	68 38 02 00 00       	push   $0x238
  8040be:	68 d1 50 80 00       	push   $0x8050d1
  8040c3:	e8 c9 cb ff ff       	call   800c91 <_panic>
  8040c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040cb:	8b 00                	mov    (%eax),%eax
  8040cd:	85 c0                	test   %eax,%eax
  8040cf:	74 10                	je     8040e1 <realloc_block_FF+0x56a>
  8040d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d4:	8b 00                	mov    (%eax),%eax
  8040d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d9:	8b 52 04             	mov    0x4(%edx),%edx
  8040dc:	89 50 04             	mov    %edx,0x4(%eax)
  8040df:	eb 0b                	jmp    8040ec <realloc_block_FF+0x575>
  8040e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e4:	8b 40 04             	mov    0x4(%eax),%eax
  8040e7:	a3 30 60 80 00       	mov    %eax,0x806030
  8040ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ef:	8b 40 04             	mov    0x4(%eax),%eax
  8040f2:	85 c0                	test   %eax,%eax
  8040f4:	74 0f                	je     804105 <realloc_block_FF+0x58e>
  8040f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f9:	8b 40 04             	mov    0x4(%eax),%eax
  8040fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ff:	8b 12                	mov    (%edx),%edx
  804101:	89 10                	mov    %edx,(%eax)
  804103:	eb 0a                	jmp    80410f <realloc_block_FF+0x598>
  804105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804108:	8b 00                	mov    (%eax),%eax
  80410a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804122:	a1 38 60 80 00       	mov    0x806038,%eax
  804127:	48                   	dec    %eax
  804128:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80412d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804133:	01 d0                	add    %edx,%eax
  804135:	83 ec 04             	sub    $0x4,%esp
  804138:	6a 01                	push   $0x1
  80413a:	50                   	push   %eax
  80413b:	ff 75 08             	pushl  0x8(%ebp)
  80413e:	e8 41 ea ff ff       	call   802b84 <set_block_data>
  804143:	83 c4 10             	add    $0x10,%esp
  804146:	e9 36 01 00 00       	jmp    804281 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80414b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80414e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804151:	01 d0                	add    %edx,%eax
  804153:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804156:	83 ec 04             	sub    $0x4,%esp
  804159:	6a 01                	push   $0x1
  80415b:	ff 75 f0             	pushl  -0x10(%ebp)
  80415e:	ff 75 08             	pushl  0x8(%ebp)
  804161:	e8 1e ea ff ff       	call   802b84 <set_block_data>
  804166:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804169:	8b 45 08             	mov    0x8(%ebp),%eax
  80416c:	83 e8 04             	sub    $0x4,%eax
  80416f:	8b 00                	mov    (%eax),%eax
  804171:	83 e0 fe             	and    $0xfffffffe,%eax
  804174:	89 c2                	mov    %eax,%edx
  804176:	8b 45 08             	mov    0x8(%ebp),%eax
  804179:	01 d0                	add    %edx,%eax
  80417b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80417e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804182:	74 06                	je     80418a <realloc_block_FF+0x613>
  804184:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804188:	75 17                	jne    8041a1 <realloc_block_FF+0x62a>
  80418a:	83 ec 04             	sub    $0x4,%esp
  80418d:	68 44 51 80 00       	push   $0x805144
  804192:	68 44 02 00 00       	push   $0x244
  804197:	68 d1 50 80 00       	push   $0x8050d1
  80419c:	e8 f0 ca ff ff       	call   800c91 <_panic>
  8041a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a4:	8b 10                	mov    (%eax),%edx
  8041a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041a9:	89 10                	mov    %edx,(%eax)
  8041ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ae:	8b 00                	mov    (%eax),%eax
  8041b0:	85 c0                	test   %eax,%eax
  8041b2:	74 0b                	je     8041bf <realloc_block_FF+0x648>
  8041b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b7:	8b 00                	mov    (%eax),%eax
  8041b9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041bc:	89 50 04             	mov    %edx,0x4(%eax)
  8041bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041c5:	89 10                	mov    %edx,(%eax)
  8041c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041cd:	89 50 04             	mov    %edx,0x4(%eax)
  8041d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041d3:	8b 00                	mov    (%eax),%eax
  8041d5:	85 c0                	test   %eax,%eax
  8041d7:	75 08                	jne    8041e1 <realloc_block_FF+0x66a>
  8041d9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041dc:	a3 30 60 80 00       	mov    %eax,0x806030
  8041e1:	a1 38 60 80 00       	mov    0x806038,%eax
  8041e6:	40                   	inc    %eax
  8041e7:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041f0:	75 17                	jne    804209 <realloc_block_FF+0x692>
  8041f2:	83 ec 04             	sub    $0x4,%esp
  8041f5:	68 b3 50 80 00       	push   $0x8050b3
  8041fa:	68 45 02 00 00       	push   $0x245
  8041ff:	68 d1 50 80 00       	push   $0x8050d1
  804204:	e8 88 ca ff ff       	call   800c91 <_panic>
  804209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80420c:	8b 00                	mov    (%eax),%eax
  80420e:	85 c0                	test   %eax,%eax
  804210:	74 10                	je     804222 <realloc_block_FF+0x6ab>
  804212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804215:	8b 00                	mov    (%eax),%eax
  804217:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80421a:	8b 52 04             	mov    0x4(%edx),%edx
  80421d:	89 50 04             	mov    %edx,0x4(%eax)
  804220:	eb 0b                	jmp    80422d <realloc_block_FF+0x6b6>
  804222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804225:	8b 40 04             	mov    0x4(%eax),%eax
  804228:	a3 30 60 80 00       	mov    %eax,0x806030
  80422d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804230:	8b 40 04             	mov    0x4(%eax),%eax
  804233:	85 c0                	test   %eax,%eax
  804235:	74 0f                	je     804246 <realloc_block_FF+0x6cf>
  804237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423a:	8b 40 04             	mov    0x4(%eax),%eax
  80423d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804240:	8b 12                	mov    (%edx),%edx
  804242:	89 10                	mov    %edx,(%eax)
  804244:	eb 0a                	jmp    804250 <realloc_block_FF+0x6d9>
  804246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804249:	8b 00                	mov    (%eax),%eax
  80424b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804263:	a1 38 60 80 00       	mov    0x806038,%eax
  804268:	48                   	dec    %eax
  804269:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80426e:	83 ec 04             	sub    $0x4,%esp
  804271:	6a 00                	push   $0x0
  804273:	ff 75 bc             	pushl  -0x44(%ebp)
  804276:	ff 75 b8             	pushl  -0x48(%ebp)
  804279:	e8 06 e9 ff ff       	call   802b84 <set_block_data>
  80427e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804281:	8b 45 08             	mov    0x8(%ebp),%eax
  804284:	eb 0a                	jmp    804290 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804286:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804290:	c9                   	leave  
  804291:	c3                   	ret    

00804292 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804292:	55                   	push   %ebp
  804293:	89 e5                	mov    %esp,%ebp
  804295:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804298:	83 ec 04             	sub    $0x4,%esp
  80429b:	68 c8 51 80 00       	push   $0x8051c8
  8042a0:	68 58 02 00 00       	push   $0x258
  8042a5:	68 d1 50 80 00       	push   $0x8050d1
  8042aa:	e8 e2 c9 ff ff       	call   800c91 <_panic>

008042af <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8042af:	55                   	push   %ebp
  8042b0:	89 e5                	mov    %esp,%ebp
  8042b2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8042b5:	83 ec 04             	sub    $0x4,%esp
  8042b8:	68 f0 51 80 00       	push   $0x8051f0
  8042bd:	68 61 02 00 00       	push   $0x261
  8042c2:	68 d1 50 80 00       	push   $0x8050d1
  8042c7:	e8 c5 c9 ff ff       	call   800c91 <_panic>

008042cc <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8042cc:	55                   	push   %ebp
  8042cd:	89 e5                	mov    %esp,%ebp
  8042cf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8042d2:	83 ec 04             	sub    $0x4,%esp
  8042d5:	68 18 52 80 00       	push   $0x805218
  8042da:	6a 09                	push   $0x9
  8042dc:	68 40 52 80 00       	push   $0x805240
  8042e1:	e8 ab c9 ff ff       	call   800c91 <_panic>

008042e6 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8042e6:	55                   	push   %ebp
  8042e7:	89 e5                	mov    %esp,%ebp
  8042e9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8042ec:	83 ec 04             	sub    $0x4,%esp
  8042ef:	68 50 52 80 00       	push   $0x805250
  8042f4:	6a 10                	push   $0x10
  8042f6:	68 40 52 80 00       	push   $0x805240
  8042fb:	e8 91 c9 ff ff       	call   800c91 <_panic>

00804300 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804300:	55                   	push   %ebp
  804301:	89 e5                	mov    %esp,%ebp
  804303:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  804306:	83 ec 04             	sub    $0x4,%esp
  804309:	68 78 52 80 00       	push   $0x805278
  80430e:	6a 18                	push   $0x18
  804310:	68 40 52 80 00       	push   $0x805240
  804315:	e8 77 c9 ff ff       	call   800c91 <_panic>

0080431a <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80431a:	55                   	push   %ebp
  80431b:	89 e5                	mov    %esp,%ebp
  80431d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804320:	83 ec 04             	sub    $0x4,%esp
  804323:	68 a0 52 80 00       	push   $0x8052a0
  804328:	6a 20                	push   $0x20
  80432a:	68 40 52 80 00       	push   $0x805240
  80432f:	e8 5d c9 ff ff       	call   800c91 <_panic>

00804334 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804334:	55                   	push   %ebp
  804335:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804337:	8b 45 08             	mov    0x8(%ebp),%eax
  80433a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80433d:	5d                   	pop    %ebp
  80433e:	c3                   	ret    

0080433f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80433f:	55                   	push   %ebp
  804340:	89 e5                	mov    %esp,%ebp
  804342:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804345:	8b 55 08             	mov    0x8(%ebp),%edx
  804348:	89 d0                	mov    %edx,%eax
  80434a:	c1 e0 02             	shl    $0x2,%eax
  80434d:	01 d0                	add    %edx,%eax
  80434f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804356:	01 d0                	add    %edx,%eax
  804358:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80435f:	01 d0                	add    %edx,%eax
  804361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804368:	01 d0                	add    %edx,%eax
  80436a:	c1 e0 04             	shl    $0x4,%eax
  80436d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  804377:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80437a:	83 ec 0c             	sub    $0xc,%esp
  80437d:	50                   	push   %eax
  80437e:	e8 bc e1 ff ff       	call   80253f <sys_get_virtual_time>
  804383:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  804386:	eb 41                	jmp    8043c9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804388:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80438b:	83 ec 0c             	sub    $0xc,%esp
  80438e:	50                   	push   %eax
  80438f:	e8 ab e1 ff ff       	call   80253f <sys_get_virtual_time>
  804394:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804397:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80439a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80439d:	29 c2                	sub    %eax,%edx
  80439f:	89 d0                	mov    %edx,%eax
  8043a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8043a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043aa:	89 d1                	mov    %edx,%ecx
  8043ac:	29 c1                	sub    %eax,%ecx
  8043ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8043b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043b4:	39 c2                	cmp    %eax,%edx
  8043b6:	0f 97 c0             	seta   %al
  8043b9:	0f b6 c0             	movzbl %al,%eax
  8043bc:	29 c1                	sub    %eax,%ecx
  8043be:	89 c8                	mov    %ecx,%eax
  8043c0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8043c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8043c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8043c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8043cf:	72 b7                	jb     804388 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8043d1:	90                   	nop
  8043d2:	c9                   	leave  
  8043d3:	c3                   	ret    

008043d4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8043d4:	55                   	push   %ebp
  8043d5:	89 e5                	mov    %esp,%ebp
  8043d7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8043da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8043e1:	eb 03                	jmp    8043e6 <busy_wait+0x12>
  8043e3:	ff 45 fc             	incl   -0x4(%ebp)
  8043e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8043e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043ec:	72 f5                	jb     8043e3 <busy_wait+0xf>
	return i;
  8043ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8043f1:	c9                   	leave  
  8043f2:	c3                   	ret    
  8043f3:	90                   	nop

008043f4 <__udivdi3>:
  8043f4:	55                   	push   %ebp
  8043f5:	57                   	push   %edi
  8043f6:	56                   	push   %esi
  8043f7:	53                   	push   %ebx
  8043f8:	83 ec 1c             	sub    $0x1c,%esp
  8043fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804403:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80440b:	89 ca                	mov    %ecx,%edx
  80440d:	89 f8                	mov    %edi,%eax
  80440f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804413:	85 f6                	test   %esi,%esi
  804415:	75 2d                	jne    804444 <__udivdi3+0x50>
  804417:	39 cf                	cmp    %ecx,%edi
  804419:	77 65                	ja     804480 <__udivdi3+0x8c>
  80441b:	89 fd                	mov    %edi,%ebp
  80441d:	85 ff                	test   %edi,%edi
  80441f:	75 0b                	jne    80442c <__udivdi3+0x38>
  804421:	b8 01 00 00 00       	mov    $0x1,%eax
  804426:	31 d2                	xor    %edx,%edx
  804428:	f7 f7                	div    %edi
  80442a:	89 c5                	mov    %eax,%ebp
  80442c:	31 d2                	xor    %edx,%edx
  80442e:	89 c8                	mov    %ecx,%eax
  804430:	f7 f5                	div    %ebp
  804432:	89 c1                	mov    %eax,%ecx
  804434:	89 d8                	mov    %ebx,%eax
  804436:	f7 f5                	div    %ebp
  804438:	89 cf                	mov    %ecx,%edi
  80443a:	89 fa                	mov    %edi,%edx
  80443c:	83 c4 1c             	add    $0x1c,%esp
  80443f:	5b                   	pop    %ebx
  804440:	5e                   	pop    %esi
  804441:	5f                   	pop    %edi
  804442:	5d                   	pop    %ebp
  804443:	c3                   	ret    
  804444:	39 ce                	cmp    %ecx,%esi
  804446:	77 28                	ja     804470 <__udivdi3+0x7c>
  804448:	0f bd fe             	bsr    %esi,%edi
  80444b:	83 f7 1f             	xor    $0x1f,%edi
  80444e:	75 40                	jne    804490 <__udivdi3+0x9c>
  804450:	39 ce                	cmp    %ecx,%esi
  804452:	72 0a                	jb     80445e <__udivdi3+0x6a>
  804454:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804458:	0f 87 9e 00 00 00    	ja     8044fc <__udivdi3+0x108>
  80445e:	b8 01 00 00 00       	mov    $0x1,%eax
  804463:	89 fa                	mov    %edi,%edx
  804465:	83 c4 1c             	add    $0x1c,%esp
  804468:	5b                   	pop    %ebx
  804469:	5e                   	pop    %esi
  80446a:	5f                   	pop    %edi
  80446b:	5d                   	pop    %ebp
  80446c:	c3                   	ret    
  80446d:	8d 76 00             	lea    0x0(%esi),%esi
  804470:	31 ff                	xor    %edi,%edi
  804472:	31 c0                	xor    %eax,%eax
  804474:	89 fa                	mov    %edi,%edx
  804476:	83 c4 1c             	add    $0x1c,%esp
  804479:	5b                   	pop    %ebx
  80447a:	5e                   	pop    %esi
  80447b:	5f                   	pop    %edi
  80447c:	5d                   	pop    %ebp
  80447d:	c3                   	ret    
  80447e:	66 90                	xchg   %ax,%ax
  804480:	89 d8                	mov    %ebx,%eax
  804482:	f7 f7                	div    %edi
  804484:	31 ff                	xor    %edi,%edi
  804486:	89 fa                	mov    %edi,%edx
  804488:	83 c4 1c             	add    $0x1c,%esp
  80448b:	5b                   	pop    %ebx
  80448c:	5e                   	pop    %esi
  80448d:	5f                   	pop    %edi
  80448e:	5d                   	pop    %ebp
  80448f:	c3                   	ret    
  804490:	bd 20 00 00 00       	mov    $0x20,%ebp
  804495:	89 eb                	mov    %ebp,%ebx
  804497:	29 fb                	sub    %edi,%ebx
  804499:	89 f9                	mov    %edi,%ecx
  80449b:	d3 e6                	shl    %cl,%esi
  80449d:	89 c5                	mov    %eax,%ebp
  80449f:	88 d9                	mov    %bl,%cl
  8044a1:	d3 ed                	shr    %cl,%ebp
  8044a3:	89 e9                	mov    %ebp,%ecx
  8044a5:	09 f1                	or     %esi,%ecx
  8044a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044ab:	89 f9                	mov    %edi,%ecx
  8044ad:	d3 e0                	shl    %cl,%eax
  8044af:	89 c5                	mov    %eax,%ebp
  8044b1:	89 d6                	mov    %edx,%esi
  8044b3:	88 d9                	mov    %bl,%cl
  8044b5:	d3 ee                	shr    %cl,%esi
  8044b7:	89 f9                	mov    %edi,%ecx
  8044b9:	d3 e2                	shl    %cl,%edx
  8044bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044bf:	88 d9                	mov    %bl,%cl
  8044c1:	d3 e8                	shr    %cl,%eax
  8044c3:	09 c2                	or     %eax,%edx
  8044c5:	89 d0                	mov    %edx,%eax
  8044c7:	89 f2                	mov    %esi,%edx
  8044c9:	f7 74 24 0c          	divl   0xc(%esp)
  8044cd:	89 d6                	mov    %edx,%esi
  8044cf:	89 c3                	mov    %eax,%ebx
  8044d1:	f7 e5                	mul    %ebp
  8044d3:	39 d6                	cmp    %edx,%esi
  8044d5:	72 19                	jb     8044f0 <__udivdi3+0xfc>
  8044d7:	74 0b                	je     8044e4 <__udivdi3+0xf0>
  8044d9:	89 d8                	mov    %ebx,%eax
  8044db:	31 ff                	xor    %edi,%edi
  8044dd:	e9 58 ff ff ff       	jmp    80443a <__udivdi3+0x46>
  8044e2:	66 90                	xchg   %ax,%ax
  8044e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044e8:	89 f9                	mov    %edi,%ecx
  8044ea:	d3 e2                	shl    %cl,%edx
  8044ec:	39 c2                	cmp    %eax,%edx
  8044ee:	73 e9                	jae    8044d9 <__udivdi3+0xe5>
  8044f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044f3:	31 ff                	xor    %edi,%edi
  8044f5:	e9 40 ff ff ff       	jmp    80443a <__udivdi3+0x46>
  8044fa:	66 90                	xchg   %ax,%ax
  8044fc:	31 c0                	xor    %eax,%eax
  8044fe:	e9 37 ff ff ff       	jmp    80443a <__udivdi3+0x46>
  804503:	90                   	nop

00804504 <__umoddi3>:
  804504:	55                   	push   %ebp
  804505:	57                   	push   %edi
  804506:	56                   	push   %esi
  804507:	53                   	push   %ebx
  804508:	83 ec 1c             	sub    $0x1c,%esp
  80450b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80450f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804517:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80451b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80451f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804523:	89 f3                	mov    %esi,%ebx
  804525:	89 fa                	mov    %edi,%edx
  804527:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80452b:	89 34 24             	mov    %esi,(%esp)
  80452e:	85 c0                	test   %eax,%eax
  804530:	75 1a                	jne    80454c <__umoddi3+0x48>
  804532:	39 f7                	cmp    %esi,%edi
  804534:	0f 86 a2 00 00 00    	jbe    8045dc <__umoddi3+0xd8>
  80453a:	89 c8                	mov    %ecx,%eax
  80453c:	89 f2                	mov    %esi,%edx
  80453e:	f7 f7                	div    %edi
  804540:	89 d0                	mov    %edx,%eax
  804542:	31 d2                	xor    %edx,%edx
  804544:	83 c4 1c             	add    $0x1c,%esp
  804547:	5b                   	pop    %ebx
  804548:	5e                   	pop    %esi
  804549:	5f                   	pop    %edi
  80454a:	5d                   	pop    %ebp
  80454b:	c3                   	ret    
  80454c:	39 f0                	cmp    %esi,%eax
  80454e:	0f 87 ac 00 00 00    	ja     804600 <__umoddi3+0xfc>
  804554:	0f bd e8             	bsr    %eax,%ebp
  804557:	83 f5 1f             	xor    $0x1f,%ebp
  80455a:	0f 84 ac 00 00 00    	je     80460c <__umoddi3+0x108>
  804560:	bf 20 00 00 00       	mov    $0x20,%edi
  804565:	29 ef                	sub    %ebp,%edi
  804567:	89 fe                	mov    %edi,%esi
  804569:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80456d:	89 e9                	mov    %ebp,%ecx
  80456f:	d3 e0                	shl    %cl,%eax
  804571:	89 d7                	mov    %edx,%edi
  804573:	89 f1                	mov    %esi,%ecx
  804575:	d3 ef                	shr    %cl,%edi
  804577:	09 c7                	or     %eax,%edi
  804579:	89 e9                	mov    %ebp,%ecx
  80457b:	d3 e2                	shl    %cl,%edx
  80457d:	89 14 24             	mov    %edx,(%esp)
  804580:	89 d8                	mov    %ebx,%eax
  804582:	d3 e0                	shl    %cl,%eax
  804584:	89 c2                	mov    %eax,%edx
  804586:	8b 44 24 08          	mov    0x8(%esp),%eax
  80458a:	d3 e0                	shl    %cl,%eax
  80458c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804590:	8b 44 24 08          	mov    0x8(%esp),%eax
  804594:	89 f1                	mov    %esi,%ecx
  804596:	d3 e8                	shr    %cl,%eax
  804598:	09 d0                	or     %edx,%eax
  80459a:	d3 eb                	shr    %cl,%ebx
  80459c:	89 da                	mov    %ebx,%edx
  80459e:	f7 f7                	div    %edi
  8045a0:	89 d3                	mov    %edx,%ebx
  8045a2:	f7 24 24             	mull   (%esp)
  8045a5:	89 c6                	mov    %eax,%esi
  8045a7:	89 d1                	mov    %edx,%ecx
  8045a9:	39 d3                	cmp    %edx,%ebx
  8045ab:	0f 82 87 00 00 00    	jb     804638 <__umoddi3+0x134>
  8045b1:	0f 84 91 00 00 00    	je     804648 <__umoddi3+0x144>
  8045b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045bb:	29 f2                	sub    %esi,%edx
  8045bd:	19 cb                	sbb    %ecx,%ebx
  8045bf:	89 d8                	mov    %ebx,%eax
  8045c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045c5:	d3 e0                	shl    %cl,%eax
  8045c7:	89 e9                	mov    %ebp,%ecx
  8045c9:	d3 ea                	shr    %cl,%edx
  8045cb:	09 d0                	or     %edx,%eax
  8045cd:	89 e9                	mov    %ebp,%ecx
  8045cf:	d3 eb                	shr    %cl,%ebx
  8045d1:	89 da                	mov    %ebx,%edx
  8045d3:	83 c4 1c             	add    $0x1c,%esp
  8045d6:	5b                   	pop    %ebx
  8045d7:	5e                   	pop    %esi
  8045d8:	5f                   	pop    %edi
  8045d9:	5d                   	pop    %ebp
  8045da:	c3                   	ret    
  8045db:	90                   	nop
  8045dc:	89 fd                	mov    %edi,%ebp
  8045de:	85 ff                	test   %edi,%edi
  8045e0:	75 0b                	jne    8045ed <__umoddi3+0xe9>
  8045e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8045e7:	31 d2                	xor    %edx,%edx
  8045e9:	f7 f7                	div    %edi
  8045eb:	89 c5                	mov    %eax,%ebp
  8045ed:	89 f0                	mov    %esi,%eax
  8045ef:	31 d2                	xor    %edx,%edx
  8045f1:	f7 f5                	div    %ebp
  8045f3:	89 c8                	mov    %ecx,%eax
  8045f5:	f7 f5                	div    %ebp
  8045f7:	89 d0                	mov    %edx,%eax
  8045f9:	e9 44 ff ff ff       	jmp    804542 <__umoddi3+0x3e>
  8045fe:	66 90                	xchg   %ax,%ax
  804600:	89 c8                	mov    %ecx,%eax
  804602:	89 f2                	mov    %esi,%edx
  804604:	83 c4 1c             	add    $0x1c,%esp
  804607:	5b                   	pop    %ebx
  804608:	5e                   	pop    %esi
  804609:	5f                   	pop    %edi
  80460a:	5d                   	pop    %ebp
  80460b:	c3                   	ret    
  80460c:	3b 04 24             	cmp    (%esp),%eax
  80460f:	72 06                	jb     804617 <__umoddi3+0x113>
  804611:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804615:	77 0f                	ja     804626 <__umoddi3+0x122>
  804617:	89 f2                	mov    %esi,%edx
  804619:	29 f9                	sub    %edi,%ecx
  80461b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80461f:	89 14 24             	mov    %edx,(%esp)
  804622:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804626:	8b 44 24 04          	mov    0x4(%esp),%eax
  80462a:	8b 14 24             	mov    (%esp),%edx
  80462d:	83 c4 1c             	add    $0x1c,%esp
  804630:	5b                   	pop    %ebx
  804631:	5e                   	pop    %esi
  804632:	5f                   	pop    %edi
  804633:	5d                   	pop    %ebp
  804634:	c3                   	ret    
  804635:	8d 76 00             	lea    0x0(%esi),%esi
  804638:	2b 04 24             	sub    (%esp),%eax
  80463b:	19 fa                	sbb    %edi,%edx
  80463d:	89 d1                	mov    %edx,%ecx
  80463f:	89 c6                	mov    %eax,%esi
  804641:	e9 71 ff ff ff       	jmp    8045b7 <__umoddi3+0xb3>
  804646:	66 90                	xchg   %ax,%ax
  804648:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80464c:	72 ea                	jb     804638 <__umoddi3+0x134>
  80464e:	89 d9                	mov    %ebx,%ecx
  804650:	e9 62 ff ff ff       	jmp    8045b7 <__umoddi3+0xb3>

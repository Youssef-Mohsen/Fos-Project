
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
  800044:	e8 37 24 00 00       	call   802480 <sys_getenvid>
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
  80007c:	bb 72 48 80 00       	mov    $0x804872,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb 7c 48 80 00       	mov    $0x80487c,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb 88 48 80 00       	mov    $0x804888,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb 97 48 80 00       	mov    $0x804897,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb a6 48 80 00       	mov    $0x8048a6,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb bb 48 80 00       	mov    $0x8048bb,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb d0 48 80 00       	mov    $0x8048d0,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb e1 48 80 00       	mov    $0x8048e1,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb f2 48 80 00       	mov    $0x8048f2,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 03 49 80 00       	mov    $0x804903,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 0c 49 80 00       	mov    $0x80490c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 16 49 80 00       	mov    $0x804916,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 21 49 80 00       	mov    $0x804921,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 2d 49 80 00       	mov    $0x80492d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 37 49 80 00       	mov    $0x804937,%ebx
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
  8001f7:	bb 41 49 80 00       	mov    $0x804941,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb 4f 49 80 00       	mov    $0x80494f,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb 5e 49 80 00       	mov    $0x80495e,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb 65 49 80 00       	mov    $0x804965,%ebx
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
  800499:	e8 d4 3d 00 00       	call   804272 <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 b9 3d 00 00       	call   804272 <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 9e 3d 00 00       	call   804272 <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 83 3d 00 00       	call   804272 <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 68 3d 00 00       	call   804272 <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 4d 3d 00 00       	call   804272 <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 32 3d 00 00       	call   804272 <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 00 46 80 00       	push   $0x804600
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
  80057b:	bb 6c 49 80 00       	mov    $0x80496c,%ebx
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
  8005fc:	e8 71 3c 00 00       	call   804272 <create_semaphore>
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
  800648:	e8 de 1d 00 00       	call   80242b <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 e4 1d 00 00       	call   802449 <sys_run_env>
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
  800695:	e8 91 1d 00 00       	call   80242b <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 97 1d 00 00       	call   802449 <sys_run_env>
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
  8006e2:	e8 44 1d 00 00       	call   80242b <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 4a 1d 00 00       	call   802449 <sys_run_env>
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
  800738:	e8 ee 1c 00 00       	call   80242b <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 14 46 80 00       	push   $0x804614
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 5a 46 80 00       	push   $0x80465a
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 d4 1c 00 00       	call   802449 <sys_run_env>
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
  800795:	e8 0c 3b 00 00       	call   8042a6 <wait_semaphore>
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
  8007b0:	e8 30 3b 00 00       	call   8042e5 <env_sleep>
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
  8007f6:	68 6c 46 80 00       	push   $0x80466c
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
  80084e:	68 9c 46 80 00       	push   $0x80469c
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
  80088d:	68 cc 46 80 00       	push   $0x8046cc
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 5a 46 80 00       	push   $0x80465a
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
  8008d0:	68 cc 46 80 00       	push   $0x8046cc
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 5a 46 80 00       	push   $0x80465a
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
  800931:	68 cc 46 80 00       	push   $0x8046cc
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 5a 46 80 00       	push   $0x80465a
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
  80095e:	e8 77 39 00 00       	call   8042da <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 f0 46 80 00       	push   $0x8046f0
  800970:	68 10 47 80 00       	push   $0x804710
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 5a 46 80 00       	push   $0x80465a
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 48 39 00 00       	call   8042da <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 28 47 80 00       	push   $0x804728
  80099f:	68 10 47 80 00       	push   $0x804710
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 5a 46 80 00       	push   $0x80465a
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 19 39 00 00       	call   8042da <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 48 47 80 00       	push   $0x804748
  8009ce:	68 10 47 80 00       	push   $0x804710
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 5a 46 80 00       	push   $0x80465a
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 ea 38 00 00       	call   8042da <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 6c 47 80 00       	push   $0x80476c
  8009fd:	68 10 47 80 00       	push   $0x804710
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 5a 46 80 00       	push   $0x80465a
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 bb 38 00 00       	call   8042da <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 8e 47 80 00       	push   $0x80478e
  800a2c:	68 10 47 80 00       	push   $0x804710
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 5a 46 80 00       	push   $0x80465a
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 8c 38 00 00       	call   8042da <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 ac 47 80 00       	push   $0x8047ac
  800a5b:	68 10 47 80 00       	push   $0x804710
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 5a 46 80 00       	push   $0x80465a
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 5d 38 00 00       	call   8042da <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 d0 47 80 00       	push   $0x8047d0
  800a89:	68 10 47 80 00       	push   $0x804710
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 5a 46 80 00       	push   $0x80465a
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
  800ac4:	e8 11 38 00 00       	call   8042da <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 f8 47 80 00       	push   $0x8047f8
  800ad5:	68 10 47 80 00       	push   $0x804710
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 5a 46 80 00       	push   $0x80465a
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
  800af7:	68 20 48 80 00       	push   $0x804820
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
  800b58:	e8 3c 19 00 00       	call   802499 <sys_getenvindex>
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
  800bc6:	e8 52 16 00 00       	call   80221d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 a4 49 80 00       	push   $0x8049a4
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
  800bf6:	68 cc 49 80 00       	push   $0x8049cc
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
  800c27:	68 f4 49 80 00       	push   $0x8049f4
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 4c 4a 80 00       	push   $0x804a4c
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 a4 49 80 00       	push   $0x8049a4
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 d2 15 00 00       	call   802237 <sys_unlock_cons>
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
  800c78:	e8 e8 17 00 00       	call   802465 <sys_destroy_env>
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
  800c89:	e8 3d 18 00 00       	call   8024cb <sys_exit_env>
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
  800cb2:	68 60 4a 80 00       	push   $0x804a60
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 65 4a 80 00       	push   $0x804a65
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
  800cef:	68 81 4a 80 00       	push   $0x804a81
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
  800d1e:	68 84 4a 80 00       	push   $0x804a84
  800d23:	6a 26                	push   $0x26
  800d25:	68 d0 4a 80 00       	push   $0x804ad0
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
  800df3:	68 dc 4a 80 00       	push   $0x804adc
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 d0 4a 80 00       	push   $0x804ad0
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
  800e66:	68 30 4b 80 00       	push   $0x804b30
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 d0 4a 80 00       	push   $0x804ad0
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
  800ec0:	e8 16 13 00 00       	call   8021db <sys_cputs>
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
  800f37:	e8 9f 12 00 00       	call   8021db <sys_cputs>
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
  800f81:	e8 97 12 00 00       	call   80221d <sys_lock_cons>
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
  800fa1:	e8 91 12 00 00       	call   802237 <sys_unlock_cons>
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
  800feb:	e8 ac 33 00 00       	call   80439c <__udivdi3>
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
  80103b:	e8 6c 34 00 00       	call   8044ac <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 94 4d 80 00       	add    $0x804d94,%eax
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
  801196:	8b 04 85 b8 4d 80 00 	mov    0x804db8(,%eax,4),%eax
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
  801277:	8b 34 9d 00 4c 80 00 	mov    0x804c00(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 a5 4d 80 00       	push   $0x804da5
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
  80129c:	68 ae 4d 80 00       	push   $0x804dae
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
  8012c9:	be b1 4d 80 00       	mov    $0x804db1,%esi
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
  801cd4:	68 28 4f 80 00       	push   $0x804f28
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 4a 4f 80 00       	push   $0x804f4a
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
  801cf4:	e8 8d 0a 00 00       	call   802786 <sys_sbrk>
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
  801d6f:	e8 96 08 00 00       	call   80260a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 d6 0d 00 00       	call   802b59 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 a8 08 00 00       	call   80263b <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 6f 12 00 00       	call   803015 <alloc_block_BF>
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
  801df1:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  801e3e:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  801e95:	c7 04 85 60 60 80 00 	movl   $0x1,0x806060(,%eax,4)
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
  801ef7:	89 04 95 60 60 88 00 	mov    %eax,0x886060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	e8 b1 08 00 00       	call   8027bd <sys_allocate_user_mem>
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
  801f4f:	e8 85 08 00 00       	call   8027d9 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 b8 1a 00 00       	call   803a1d <free_block>
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
  801f9a:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  801fd7:	c7 04 85 60 60 80 00 	movl   $0x0,0x806060(,%eax,4)
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
  801ff7:	e8 a5 07 00 00       	call   8027a1 <sys_free_user_mem>
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
  802005:	68 58 4f 80 00       	push   $0x804f58
  80200a:	68 84 00 00 00       	push   $0x84
  80200f:	68 82 4f 80 00       	push   $0x804f82
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
  80202b:	75 07                	jne    802034 <smalloc+0x19>
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
  802032:	eb 64                	jmp    802098 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802041:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	39 d0                	cmp    %edx,%eax
  802049:	73 02                	jae    80204d <smalloc+0x32>
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	50                   	push   %eax
  802051:	e8 a8 fc ff ff       	call   801cfe <malloc>
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80205c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802060:	75 07                	jne    802069 <smalloc+0x4e>
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
  802067:	eb 2f                	jmp    802098 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802069:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80206d:	ff 75 ec             	pushl  -0x14(%ebp)
  802070:	50                   	push   %eax
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 2c 03 00 00       	call   8023a8 <sys_createSharedObject>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802082:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802086:	74 06                	je     80208e <smalloc+0x73>
  802088:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80208c:	75 07                	jne    802095 <smalloc+0x7a>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 03                	jmp    802098 <smalloc+0x7d>
	 return ptr;
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020a0:	83 ec 08             	sub    $0x8,%esp
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	e8 24 03 00 00       	call   8023d2 <sys_getSizeOfSharedObject>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020b4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020b8:	75 07                	jne    8020c1 <sget+0x27>
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	eb 5c                	jmp    80211d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020c7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d4:	39 d0                	cmp    %edx,%eax
  8020d6:	7d 02                	jge    8020da <sget+0x40>
  8020d8:	89 d0                	mov    %edx,%eax
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	50                   	push   %eax
  8020de:	e8 1b fc ff ff       	call   801cfe <malloc>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8020e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020ed:	75 07                	jne    8020f6 <sget+0x5c>
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f4:	eb 27                	jmp    80211d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	e8 e8 02 00 00       	call   8023ef <sys_getSharedObject>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80210d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802111:	75 07                	jne    80211a <sget+0x80>
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	eb 03                	jmp    80211d <sget+0x83>
	return ptr;
  80211a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 90 4f 80 00       	push   $0x804f90
  80212d:	68 c1 00 00 00       	push   $0xc1
  802132:	68 82 4f 80 00       	push   $0x804f82
  802137:	e8 55 eb ff ff       	call   800c91 <_panic>

0080213c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 b4 4f 80 00       	push   $0x804fb4
  80214a:	68 d8 00 00 00       	push   $0xd8
  80214f:	68 82 4f 80 00       	push   $0x804f82
  802154:	e8 38 eb ff ff       	call   800c91 <_panic>

00802159 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	68 da 4f 80 00       	push   $0x804fda
  802167:	68 e4 00 00 00       	push   $0xe4
  80216c:	68 82 4f 80 00       	push   $0x804f82
  802171:	e8 1b eb ff ff       	call   800c91 <_panic>

00802176 <shrink>:

}
void shrink(uint32 newSize)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	68 da 4f 80 00       	push   $0x804fda
  802184:	68 e9 00 00 00       	push   $0xe9
  802189:	68 82 4f 80 00       	push   $0x804f82
  80218e:	e8 fe ea ff ff       	call   800c91 <_panic>

00802193 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 da 4f 80 00       	push   $0x804fda
  8021a1:	68 ee 00 00 00       	push   $0xee
  8021a6:	68 82 4f 80 00       	push   $0x804f82
  8021ab:	e8 e1 ea ff ff       	call   800c91 <_panic>

008021b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	57                   	push   %edi
  8021b4:	56                   	push   %esi
  8021b5:	53                   	push   %ebx
  8021b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021cb:	cd 30                	int    $0x30
  8021cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	5b                   	pop    %ebx
  8021d7:	5e                   	pop    %esi
  8021d8:	5f                   	pop    %edi
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	52                   	push   %edx
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	50                   	push   %eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	e8 b2 ff ff ff       	call   8021b0 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	90                   	nop
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_cgetc>:

int
sys_cgetc(void)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 02                	push   $0x2
  802213:	e8 98 ff ff ff       	call   8021b0 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 03                	push   $0x3
  80222c:	e8 7f ff ff ff       	call   8021b0 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	90                   	nop
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 04                	push   $0x4
  802246:	e8 65 ff ff ff       	call   8021b0 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	90                   	nop
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802254:	8b 55 0c             	mov    0xc(%ebp),%edx
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	52                   	push   %edx
  802261:	50                   	push   %eax
  802262:	6a 08                	push   $0x8
  802264:	e8 47 ff ff ff       	call   8021b0 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	56                   	push   %esi
  802272:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802273:	8b 75 18             	mov    0x18(%ebp),%esi
  802276:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802279:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	51                   	push   %ecx
  802285:	52                   	push   %edx
  802286:	50                   	push   %eax
  802287:	6a 09                	push   $0x9
  802289:	e8 22 ff ff ff       	call   8021b0 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    

00802298 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	6a 0a                	push   $0xa
  8022ab:	e8 00 ff ff ff       	call   8021b0 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	ff 75 0c             	pushl  0xc(%ebp)
  8022c1:	ff 75 08             	pushl  0x8(%ebp)
  8022c4:	6a 0b                	push   $0xb
  8022c6:	e8 e5 fe ff ff       	call   8021b0 <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 0c                	push   $0xc
  8022df:	e8 cc fe ff ff       	call   8021b0 <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 0d                	push   $0xd
  8022f8:	e8 b3 fe ff ff       	call   8021b0 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 0e                	push   $0xe
  802311:	e8 9a fe ff ff       	call   8021b0 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 0f                	push   $0xf
  80232a:	e8 81 fe ff ff       	call   8021b0 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	ff 75 08             	pushl  0x8(%ebp)
  802342:	6a 10                	push   $0x10
  802344:	e8 67 fe ff ff       	call   8021b0 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 11                	push   $0x11
  80235d:	e8 4e fe ff ff       	call   8021b0 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	90                   	nop
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_cputc>:

void
sys_cputc(const char c)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802374:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	50                   	push   %eax
  802381:	6a 01                	push   $0x1
  802383:	e8 28 fe ff ff       	call   8021b0 <syscall>
  802388:	83 c4 18             	add    $0x18,%esp
}
  80238b:	90                   	nop
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 14                	push   $0x14
  80239d:	e8 0e fe ff ff       	call   8021b0 <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
}
  8023a5:	90                   	nop
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	6a 00                	push   $0x0
  8023c0:	51                   	push   %ecx
  8023c1:	52                   	push   %edx
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	50                   	push   %eax
  8023c6:	6a 15                	push   $0x15
  8023c8:	e8 e3 fd ff ff       	call   8021b0 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 16                	push   $0x16
  8023e5:	e8 c6 fd ff ff       	call   8021b0 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	51                   	push   %ecx
  802400:	52                   	push   %edx
  802401:	50                   	push   %eax
  802402:	6a 17                	push   $0x17
  802404:	e8 a7 fd ff ff       	call   8021b0 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802411:	8b 55 0c             	mov    0xc(%ebp),%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	52                   	push   %edx
  80241e:	50                   	push   %eax
  80241f:	6a 18                	push   $0x18
  802421:	e8 8a fd ff ff       	call   8021b0 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	6a 00                	push   $0x0
  802433:	ff 75 14             	pushl  0x14(%ebp)
  802436:	ff 75 10             	pushl  0x10(%ebp)
  802439:	ff 75 0c             	pushl  0xc(%ebp)
  80243c:	50                   	push   %eax
  80243d:	6a 19                	push   $0x19
  80243f:	e8 6c fd ff ff       	call   8021b0 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	50                   	push   %eax
  802458:	6a 1a                	push   $0x1a
  80245a:	e8 51 fd ff ff       	call   8021b0 <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	50                   	push   %eax
  802474:	6a 1b                	push   $0x1b
  802476:	e8 35 fd ff ff       	call   8021b0 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 05                	push   $0x5
  80248f:	e8 1c fd ff ff       	call   8021b0 <syscall>
  802494:	83 c4 18             	add    $0x18,%esp
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 06                	push   $0x6
  8024a8:	e8 03 fd ff ff       	call   8021b0 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 07                	push   $0x7
  8024c1:	e8 ea fc ff ff       	call   8021b0 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_exit_env>:


void sys_exit_env(void)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 1c                	push   $0x1c
  8024da:	e8 d1 fc ff ff       	call   8021b0 <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
}
  8024e2:	90                   	nop
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ee:	8d 50 04             	lea    0x4(%eax),%edx
  8024f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	52                   	push   %edx
  8024fb:	50                   	push   %eax
  8024fc:	6a 1d                	push   $0x1d
  8024fe:	e8 ad fc ff ff       	call   8021b0 <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
	return result;
  802506:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802509:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250f:	89 01                	mov    %eax,(%ecx)
  802511:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	c9                   	leave  
  802518:	c2 04 00             	ret    $0x4

0080251b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	ff 75 10             	pushl  0x10(%ebp)
  802525:	ff 75 0c             	pushl  0xc(%ebp)
  802528:	ff 75 08             	pushl  0x8(%ebp)
  80252b:	6a 13                	push   $0x13
  80252d:	e8 7e fc ff ff       	call   8021b0 <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
	return ;
  802535:	90                   	nop
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_rcr2>:
uint32 sys_rcr2()
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 1e                	push   $0x1e
  802547:	e8 64 fc ff ff       	call   8021b0 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80255d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	50                   	push   %eax
  80256a:	6a 1f                	push   $0x1f
  80256c:	e8 3f fc ff ff       	call   8021b0 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
	return ;
  802574:	90                   	nop
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <rsttst>:
void rsttst()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 21                	push   $0x21
  802586:	e8 25 fc ff ff       	call   8021b0 <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
	return ;
  80258e:	90                   	nop
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	8b 45 14             	mov    0x14(%ebp),%eax
  80259a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80259d:	8b 55 18             	mov    0x18(%ebp),%edx
  8025a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025a4:	52                   	push   %edx
  8025a5:	50                   	push   %eax
  8025a6:	ff 75 10             	pushl  0x10(%ebp)
  8025a9:	ff 75 0c             	pushl  0xc(%ebp)
  8025ac:	ff 75 08             	pushl  0x8(%ebp)
  8025af:	6a 20                	push   $0x20
  8025b1:	e8 fa fb ff ff       	call   8021b0 <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b9:	90                   	nop
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <chktst>:
void chktst(uint32 n)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	ff 75 08             	pushl  0x8(%ebp)
  8025ca:	6a 22                	push   $0x22
  8025cc:	e8 df fb ff ff       	call   8021b0 <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d4:	90                   	nop
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <inctst>:

void inctst()
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 23                	push   $0x23
  8025e6:	e8 c5 fb ff ff       	call   8021b0 <syscall>
  8025eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ee:	90                   	nop
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <gettst>:
uint32 gettst()
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 24                	push   $0x24
  802600:	e8 ab fb ff ff       	call   8021b0 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 25                	push   $0x25
  80261c:	e8 8f fb ff ff       	call   8021b0 <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
  802624:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802627:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80262b:	75 07                	jne    802634 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80262d:	b8 01 00 00 00       	mov    $0x1,%eax
  802632:	eb 05                	jmp    802639 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802634:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 25                	push   $0x25
  80264d:	e8 5e fb ff ff       	call   8021b0 <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
  802655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802658:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80265c:	75 07                	jne    802665 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80265e:	b8 01 00 00 00       	mov    $0x1,%eax
  802663:	eb 05                	jmp    80266a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 25                	push   $0x25
  80267e:	e8 2d fb ff ff       	call   8021b0 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
  802686:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802689:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80268d:	75 07                	jne    802696 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80268f:	b8 01 00 00 00       	mov    $0x1,%eax
  802694:	eb 05                	jmp    80269b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 25                	push   $0x25
  8026af:	e8 fc fa ff ff       	call   8021b0 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
  8026b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ba:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026be:	75 07                	jne    8026c7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c5:	eb 05                	jmp    8026cc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	ff 75 08             	pushl  0x8(%ebp)
  8026dc:	6a 26                	push   $0x26
  8026de:	e8 cd fa ff ff       	call   8021b0 <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e6:	90                   	nop
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	6a 00                	push   $0x0
  8026fb:	53                   	push   %ebx
  8026fc:	51                   	push   %ecx
  8026fd:	52                   	push   %edx
  8026fe:	50                   	push   %eax
  8026ff:	6a 27                	push   $0x27
  802701:	e8 aa fa ff ff       	call   8021b0 <syscall>
  802706:	83 c4 18             	add    $0x18,%esp
}
  802709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802711:	8b 55 0c             	mov    0xc(%ebp),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	6a 00                	push   $0x0
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	52                   	push   %edx
  80271e:	50                   	push   %eax
  80271f:	6a 28                	push   $0x28
  802721:	e8 8a fa ff ff       	call   8021b0 <syscall>
  802726:	83 c4 18             	add    $0x18,%esp
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80272e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802731:	8b 55 0c             	mov    0xc(%ebp),%edx
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	6a 00                	push   $0x0
  802739:	51                   	push   %ecx
  80273a:	ff 75 10             	pushl  0x10(%ebp)
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	6a 29                	push   $0x29
  802741:	e8 6a fa ff ff       	call   8021b0 <syscall>
  802746:	83 c4 18             	add    $0x18,%esp
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	ff 75 10             	pushl  0x10(%ebp)
  802755:	ff 75 0c             	pushl  0xc(%ebp)
  802758:	ff 75 08             	pushl  0x8(%ebp)
  80275b:	6a 12                	push   $0x12
  80275d:	e8 4e fa ff ff       	call   8021b0 <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
	return ;
  802765:	90                   	nop
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80276b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	52                   	push   %edx
  802778:	50                   	push   %eax
  802779:	6a 2a                	push   $0x2a
  80277b:	e8 30 fa ff ff       	call   8021b0 <syscall>
  802780:	83 c4 18             	add    $0x18,%esp
	return;
  802783:	90                   	nop
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	50                   	push   %eax
  802795:	6a 2b                	push   $0x2b
  802797:	e8 14 fa ff ff       	call   8021b0 <syscall>
  80279c:	83 c4 18             	add    $0x18,%esp
}
  80279f:	c9                   	leave  
  8027a0:	c3                   	ret    

008027a1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027a1:	55                   	push   %ebp
  8027a2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	ff 75 08             	pushl  0x8(%ebp)
  8027b0:	6a 2c                	push   $0x2c
  8027b2:	e8 f9 f9 ff ff       	call   8021b0 <syscall>
  8027b7:	83 c4 18             	add    $0x18,%esp
	return;
  8027ba:	90                   	nop
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	ff 75 0c             	pushl  0xc(%ebp)
  8027c9:	ff 75 08             	pushl  0x8(%ebp)
  8027cc:	6a 2d                	push   $0x2d
  8027ce:	e8 dd f9 ff ff       	call   8021b0 <syscall>
  8027d3:	83 c4 18             	add    $0x18,%esp
	return;
  8027d6:	90                   	nop
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
  8027dc:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	83 e8 04             	sub    $0x4,%eax
  8027e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8027e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
  8027f5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	83 e8 04             	sub    $0x4,%eax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802801:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	83 e0 01             	and    $0x1,%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	0f 94 c0             	sete   %al
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80281d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802820:	83 f8 02             	cmp    $0x2,%eax
  802823:	74 2b                	je     802850 <alloc_block+0x40>
  802825:	83 f8 02             	cmp    $0x2,%eax
  802828:	7f 07                	jg     802831 <alloc_block+0x21>
  80282a:	83 f8 01             	cmp    $0x1,%eax
  80282d:	74 0e                	je     80283d <alloc_block+0x2d>
  80282f:	eb 58                	jmp    802889 <alloc_block+0x79>
  802831:	83 f8 03             	cmp    $0x3,%eax
  802834:	74 2d                	je     802863 <alloc_block+0x53>
  802836:	83 f8 04             	cmp    $0x4,%eax
  802839:	74 3b                	je     802876 <alloc_block+0x66>
  80283b:	eb 4c                	jmp    802889 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80283d:	83 ec 0c             	sub    $0xc,%esp
  802840:	ff 75 08             	pushl  0x8(%ebp)
  802843:	e8 11 03 00 00       	call   802b59 <alloc_block_FF>
  802848:	83 c4 10             	add    $0x10,%esp
  80284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80284e:	eb 4a                	jmp    80289a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802850:	83 ec 0c             	sub    $0xc,%esp
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	e8 fa 19 00 00       	call   804255 <alloc_block_NF>
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802861:	eb 37                	jmp    80289a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	ff 75 08             	pushl  0x8(%ebp)
  802869:	e8 a7 07 00 00       	call   803015 <alloc_block_BF>
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802874:	eb 24                	jmp    80289a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802876:	83 ec 0c             	sub    $0xc,%esp
  802879:	ff 75 08             	pushl  0x8(%ebp)
  80287c:	e8 b7 19 00 00       	call   804238 <alloc_block_WF>
  802881:	83 c4 10             	add    $0x10,%esp
  802884:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802887:	eb 11                	jmp    80289a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	68 ec 4f 80 00       	push   $0x804fec
  802891:	e8 b8 e6 ff ff       	call   800f4e <cprintf>
  802896:	83 c4 10             	add    $0x10,%esp
		break;
  802899:	90                   	nop
	}
	return va;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	53                   	push   %ebx
  8028a3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8028a6:	83 ec 0c             	sub    $0xc,%esp
  8028a9:	68 0c 50 80 00       	push   $0x80500c
  8028ae:	e8 9b e6 ff ff       	call   800f4e <cprintf>
  8028b3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8028b6:	83 ec 0c             	sub    $0xc,%esp
  8028b9:	68 37 50 80 00       	push   $0x805037
  8028be:	e8 8b e6 ff ff       	call   800f4e <cprintf>
  8028c3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cc:	eb 37                	jmp    802905 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d4:	e8 19 ff ff ff       	call   8027f2 <is_free_block>
  8028d9:	83 c4 10             	add    $0x10,%esp
  8028dc:	0f be d8             	movsbl %al,%ebx
  8028df:	83 ec 0c             	sub    $0xc,%esp
  8028e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8028e5:	e8 ef fe ff ff       	call   8027d9 <get_block_size>
  8028ea:	83 c4 10             	add    $0x10,%esp
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	53                   	push   %ebx
  8028f1:	50                   	push   %eax
  8028f2:	68 4f 50 80 00       	push   $0x80504f
  8028f7:	e8 52 e6 ff ff       	call   800f4e <cprintf>
  8028fc:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8028ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802909:	74 07                	je     802912 <print_blocks_list+0x73>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	eb 05                	jmp    802917 <print_blocks_list+0x78>
  802912:	b8 00 00 00 00       	mov    $0x0,%eax
  802917:	89 45 10             	mov    %eax,0x10(%ebp)
  80291a:	8b 45 10             	mov    0x10(%ebp),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 ad                	jne    8028ce <print_blocks_list+0x2f>
  802921:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802925:	75 a7                	jne    8028ce <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	68 0c 50 80 00       	push   $0x80500c
  80292f:	e8 1a e6 ff ff       	call   800f4e <cprintf>
  802934:	83 c4 10             	add    $0x10,%esp

}
  802937:	90                   	nop
  802938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802943:	8b 45 0c             	mov    0xc(%ebp),%eax
  802946:	83 e0 01             	and    $0x1,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 03                	je     802950 <initialize_dynamic_allocator+0x13>
  80294d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802950:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802954:	0f 84 c7 01 00 00    	je     802b21 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80295a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802961:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802964:	8b 55 08             	mov    0x8(%ebp),%edx
  802967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296a:	01 d0                	add    %edx,%eax
  80296c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802971:	0f 87 ad 01 00 00    	ja     802b24 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	0f 89 a5 01 00 00    	jns    802b27 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802982:	8b 55 08             	mov    0x8(%ebp),%edx
  802985:	8b 45 0c             	mov    0xc(%ebp),%eax
  802988:	01 d0                	add    %edx,%eax
  80298a:	83 e8 04             	sub    $0x4,%eax
  80298d:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802992:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802999:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80299e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a1:	e9 87 00 00 00       	jmp    802a2d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8029a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029aa:	75 14                	jne    8029c0 <initialize_dynamic_allocator+0x83>
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	68 67 50 80 00       	push   $0x805067
  8029b4:	6a 79                	push   $0x79
  8029b6:	68 85 50 80 00       	push   $0x805085
  8029bb:	e8 d1 e2 ff ff       	call   800c91 <_panic>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 10                	je     8029d9 <initialize_dynamic_allocator+0x9c>
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d1:	8b 52 04             	mov    0x4(%edx),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	eb 0b                	jmp    8029e4 <initialize_dynamic_allocator+0xa7>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	a3 30 60 80 00       	mov    %eax,0x806030
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	74 0f                	je     8029fd <initialize_dynamic_allocator+0xc0>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f7:	8b 12                	mov    (%edx),%edx
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	eb 0a                	jmp    802a07 <initialize_dynamic_allocator+0xca>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1a:	a1 38 60 80 00       	mov    0x806038,%eax
  802a1f:	48                   	dec    %eax
  802a20:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a25:	a1 34 60 80 00       	mov    0x806034,%eax
  802a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a31:	74 07                	je     802a3a <initialize_dynamic_allocator+0xfd>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	eb 05                	jmp    802a3f <initialize_dynamic_allocator+0x102>
  802a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3f:	a3 34 60 80 00       	mov    %eax,0x806034
  802a44:	a1 34 60 80 00       	mov    0x806034,%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	0f 85 55 ff ff ff    	jne    8029a6 <initialize_dynamic_allocator+0x69>
  802a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a55:	0f 85 4b ff ff ff    	jne    8029a6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a6a:	a1 44 60 80 00       	mov    0x806044,%eax
  802a6f:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802a74:	a1 40 60 80 00       	mov    0x806040,%eax
  802a79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	83 c0 08             	add    $0x8,%eax
  802a85:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	83 c0 04             	add    $0x4,%eax
  802a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a91:	83 ea 08             	sub    $0x8,%edx
  802a94:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	01 d0                	add    %edx,%eax
  802a9e:	83 e8 08             	sub    $0x8,%eax
  802aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa4:	83 ea 08             	sub    $0x8,%edx
  802aa7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ac0:	75 17                	jne    802ad9 <initialize_dynamic_allocator+0x19c>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 a0 50 80 00       	push   $0x8050a0
  802aca:	68 90 00 00 00       	push   $0x90
  802acf:	68 85 50 80 00       	push   $0x805085
  802ad4:	e8 b8 e1 ff ff       	call   800c91 <_panic>
  802ad9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae2:	89 10                	mov    %edx,(%eax)
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 0d                	je     802afa <initialize_dynamic_allocator+0x1bd>
  802aed:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802af2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af5:	89 50 04             	mov    %edx,0x4(%eax)
  802af8:	eb 08                	jmp    802b02 <initialize_dynamic_allocator+0x1c5>
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	a3 30 60 80 00       	mov    %eax,0x806030
  802b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b05:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b14:	a1 38 60 80 00       	mov    0x806038,%eax
  802b19:	40                   	inc    %eax
  802b1a:	a3 38 60 80 00       	mov    %eax,0x806038
  802b1f:	eb 07                	jmp    802b28 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b21:	90                   	nop
  802b22:	eb 04                	jmp    802b28 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b24:	90                   	nop
  802b25:	eb 01                	jmp    802b28 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b27:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  802b30:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	83 e8 04             	sub    $0x4,%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	83 e0 fe             	and    $0xfffffffe,%eax
  802b49:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	01 c2                	add    %eax,%edx
  802b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b54:	89 02                	mov    %eax,(%edx)
}
  802b56:	90                   	nop
  802b57:	5d                   	pop    %ebp
  802b58:	c3                   	ret    

00802b59 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
  802b5c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	83 e0 01             	and    $0x1,%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 03                	je     802b6c <alloc_block_FF+0x13>
  802b69:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b6c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b70:	77 07                	ja     802b79 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b72:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b79:	a1 24 60 80 00       	mov    0x806024,%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	75 73                	jne    802bf5 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	83 c0 10             	add    $0x10,%eax
  802b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b8b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	48                   	dec    %eax
  802b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba6:	f7 75 ec             	divl   -0x14(%ebp)
  802ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bac:	29 d0                	sub    %edx,%eax
  802bae:	c1 e8 0c             	shr    $0xc,%eax
  802bb1:	83 ec 0c             	sub    $0xc,%esp
  802bb4:	50                   	push   %eax
  802bb5:	e8 2e f1 ff ff       	call   801ce8 <sbrk>
  802bba:	83 c4 10             	add    $0x10,%esp
  802bbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bc0:	83 ec 0c             	sub    $0xc,%esp
  802bc3:	6a 00                	push   $0x0
  802bc5:	e8 1e f1 ff ff       	call   801ce8 <sbrk>
  802bca:	83 c4 10             	add    $0x10,%esp
  802bcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bd6:	83 ec 08             	sub    $0x8,%esp
  802bd9:	50                   	push   %eax
  802bda:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bdd:	e8 5b fd ff ff       	call   80293d <initialize_dynamic_allocator>
  802be2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802be5:	83 ec 0c             	sub    $0xc,%esp
  802be8:	68 c3 50 80 00       	push   $0x8050c3
  802bed:	e8 5c e3 ff ff       	call   800f4e <cprintf>
  802bf2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf9:	75 0a                	jne    802c05 <alloc_block_FF+0xac>
	        return NULL;
  802bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802c00:	e9 0e 04 00 00       	jmp    803013 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c0c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c14:	e9 f3 02 00 00       	jmp    802f0c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c1f:	83 ec 0c             	sub    $0xc,%esp
  802c22:	ff 75 bc             	pushl  -0x44(%ebp)
  802c25:	e8 af fb ff ff       	call   8027d9 <get_block_size>
  802c2a:	83 c4 10             	add    $0x10,%esp
  802c2d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	83 c0 08             	add    $0x8,%eax
  802c36:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c39:	0f 87 c5 02 00 00    	ja     802f04 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	83 c0 18             	add    $0x18,%eax
  802c45:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c48:	0f 87 19 02 00 00    	ja     802e67 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c4e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c51:	2b 45 08             	sub    0x8(%ebp),%eax
  802c54:	83 e8 08             	sub    $0x8,%eax
  802c57:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8d 50 08             	lea    0x8(%eax),%edx
  802c60:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c63:	01 d0                	add    %edx,%eax
  802c65:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	83 c0 08             	add    $0x8,%eax
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	6a 01                	push   $0x1
  802c73:	50                   	push   %eax
  802c74:	ff 75 bc             	pushl  -0x44(%ebp)
  802c77:	e8 ae fe ff ff       	call   802b2a <set_block_data>
  802c7c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 40 04             	mov    0x4(%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	75 68                	jne    802cf1 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c89:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c8d:	75 17                	jne    802ca6 <alloc_block_FF+0x14d>
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	68 a0 50 80 00       	push   $0x8050a0
  802c97:	68 d7 00 00 00       	push   $0xd7
  802c9c:	68 85 50 80 00       	push   $0x805085
  802ca1:	e8 eb df ff ff       	call   800c91 <_panic>
  802ca6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802cac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802caf:	89 10                	mov    %edx,(%eax)
  802cb1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 0d                	je     802cc7 <alloc_block_FF+0x16e>
  802cba:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802cbf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	eb 08                	jmp    802ccf <alloc_block_FF+0x176>
  802cc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cca:	a3 30 60 80 00       	mov    %eax,0x806030
  802ccf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802cd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 38 60 80 00       	mov    0x806038,%eax
  802ce6:	40                   	inc    %eax
  802ce7:	a3 38 60 80 00       	mov    %eax,0x806038
  802cec:	e9 dc 00 00 00       	jmp    802dcd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	75 65                	jne    802d5f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cfa:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cfe:	75 17                	jne    802d17 <alloc_block_FF+0x1be>
  802d00:	83 ec 04             	sub    $0x4,%esp
  802d03:	68 d4 50 80 00       	push   $0x8050d4
  802d08:	68 db 00 00 00       	push   $0xdb
  802d0d:	68 85 50 80 00       	push   $0x805085
  802d12:	e8 7a df ff ff       	call   800c91 <_panic>
  802d17:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d20:	89 50 04             	mov    %edx,0x4(%eax)
  802d23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0c                	je     802d39 <alloc_block_FF+0x1e0>
  802d2d:	a1 30 60 80 00       	mov    0x806030,%eax
  802d32:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d35:	89 10                	mov    %edx,(%eax)
  802d37:	eb 08                	jmp    802d41 <alloc_block_FF+0x1e8>
  802d39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d3c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d41:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d44:	a3 30 60 80 00       	mov    %eax,0x806030
  802d49:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d52:	a1 38 60 80 00       	mov    0x806038,%eax
  802d57:	40                   	inc    %eax
  802d58:	a3 38 60 80 00       	mov    %eax,0x806038
  802d5d:	eb 6e                	jmp    802dcd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d63:	74 06                	je     802d6b <alloc_block_FF+0x212>
  802d65:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d69:	75 17                	jne    802d82 <alloc_block_FF+0x229>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 f8 50 80 00       	push   $0x8050f8
  802d73:	68 df 00 00 00       	push   $0xdf
  802d78:	68 85 50 80 00       	push   $0x805085
  802d7d:	e8 0f df ff ff       	call   800c91 <_panic>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 10                	mov    (%eax),%edx
  802d87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8a:	89 10                	mov    %edx,(%eax)
  802d8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0b                	je     802da0 <alloc_block_FF+0x247>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	75 08                	jne    802dc2 <alloc_block_FF+0x269>
  802dba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dbd:	a3 30 60 80 00       	mov    %eax,0x806030
  802dc2:	a1 38 60 80 00       	mov    0x806038,%eax
  802dc7:	40                   	inc    %eax
  802dc8:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd1:	75 17                	jne    802dea <alloc_block_FF+0x291>
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	68 67 50 80 00       	push   $0x805067
  802ddb:	68 e1 00 00 00       	push   $0xe1
  802de0:	68 85 50 80 00       	push   $0x805085
  802de5:	e8 a7 de ff ff       	call   800c91 <_panic>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 10                	je     802e03 <alloc_block_FF+0x2aa>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfb:	8b 52 04             	mov    0x4(%edx),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 0b                	jmp    802e0e <alloc_block_FF+0x2b5>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	a3 30 60 80 00       	mov    %eax,0x806030
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0f                	je     802e27 <alloc_block_FF+0x2ce>
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e21:	8b 12                	mov    (%edx),%edx
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	eb 0a                	jmp    802e31 <alloc_block_FF+0x2d8>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 38 60 80 00       	mov    0x806038,%eax
  802e49:	48                   	dec    %eax
  802e4a:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	6a 00                	push   $0x0
  802e54:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e57:	ff 75 b0             	pushl  -0x50(%ebp)
  802e5a:	e8 cb fc ff ff       	call   802b2a <set_block_data>
  802e5f:	83 c4 10             	add    $0x10,%esp
  802e62:	e9 95 00 00 00       	jmp    802efc <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e67:	83 ec 04             	sub    $0x4,%esp
  802e6a:	6a 01                	push   $0x1
  802e6c:	ff 75 b8             	pushl  -0x48(%ebp)
  802e6f:	ff 75 bc             	pushl  -0x44(%ebp)
  802e72:	e8 b3 fc ff ff       	call   802b2a <set_block_data>
  802e77:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7e:	75 17                	jne    802e97 <alloc_block_FF+0x33e>
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	68 67 50 80 00       	push   $0x805067
  802e88:	68 e8 00 00 00       	push   $0xe8
  802e8d:	68 85 50 80 00       	push   $0x805085
  802e92:	e8 fa dd ff ff       	call   800c91 <_panic>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 10                	je     802eb0 <alloc_block_FF+0x357>
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea8:	8b 52 04             	mov    0x4(%edx),%edx
  802eab:	89 50 04             	mov    %edx,0x4(%eax)
  802eae:	eb 0b                	jmp    802ebb <alloc_block_FF+0x362>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 40 04             	mov    0x4(%eax),%eax
  802eb6:	a3 30 60 80 00       	mov    %eax,0x806030
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 0f                	je     802ed4 <alloc_block_FF+0x37b>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ece:	8b 12                	mov    (%edx),%edx
  802ed0:	89 10                	mov    %edx,(%eax)
  802ed2:	eb 0a                	jmp    802ede <alloc_block_FF+0x385>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef1:	a1 38 60 80 00       	mov    0x806038,%eax
  802ef6:	48                   	dec    %eax
  802ef7:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802efc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802eff:	e9 0f 01 00 00       	jmp    803013 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f04:	a1 34 60 80 00       	mov    0x806034,%eax
  802f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f10:	74 07                	je     802f19 <alloc_block_FF+0x3c0>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	eb 05                	jmp    802f1e <alloc_block_FF+0x3c5>
  802f19:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1e:	a3 34 60 80 00       	mov    %eax,0x806034
  802f23:	a1 34 60 80 00       	mov    0x806034,%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	0f 85 e9 fc ff ff    	jne    802c19 <alloc_block_FF+0xc0>
  802f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f34:	0f 85 df fc ff ff    	jne    802c19 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	83 c0 08             	add    $0x8,%eax
  802f40:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f43:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f50:	01 d0                	add    %edx,%eax
  802f52:	48                   	dec    %eax
  802f53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f59:	ba 00 00 00 00       	mov    $0x0,%edx
  802f5e:	f7 75 d8             	divl   -0x28(%ebp)
  802f61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f64:	29 d0                	sub    %edx,%eax
  802f66:	c1 e8 0c             	shr    $0xc,%eax
  802f69:	83 ec 0c             	sub    $0xc,%esp
  802f6c:	50                   	push   %eax
  802f6d:	e8 76 ed ff ff       	call   801ce8 <sbrk>
  802f72:	83 c4 10             	add    $0x10,%esp
  802f75:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f78:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f7c:	75 0a                	jne    802f88 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f83:	e9 8b 00 00 00       	jmp    803013 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f88:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f95:	01 d0                	add    %edx,%eax
  802f97:	48                   	dec    %eax
  802f98:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa3:	f7 75 cc             	divl   -0x34(%ebp)
  802fa6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fa9:	29 d0                	sub    %edx,%eax
  802fab:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fb1:	01 d0                	add    %edx,%eax
  802fb3:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  802fb8:	a1 40 60 80 00       	mov    0x806040,%eax
  802fbd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fc3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802fca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fd0:	01 d0                	add    %edx,%eax
  802fd2:	48                   	dec    %eax
  802fd3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fd6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  802fde:	f7 75 c4             	divl   -0x3c(%ebp)
  802fe1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fe4:	29 d0                	sub    %edx,%eax
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	6a 01                	push   $0x1
  802feb:	50                   	push   %eax
  802fec:	ff 75 d0             	pushl  -0x30(%ebp)
  802fef:	e8 36 fb ff ff       	call   802b2a <set_block_data>
  802ff4:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ff7:	83 ec 0c             	sub    $0xc,%esp
  802ffa:	ff 75 d0             	pushl  -0x30(%ebp)
  802ffd:	e8 1b 0a 00 00       	call   803a1d <free_block>
  803002:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803005:	83 ec 0c             	sub    $0xc,%esp
  803008:	ff 75 08             	pushl  0x8(%ebp)
  80300b:	e8 49 fb ff ff       	call   802b59 <alloc_block_FF>
  803010:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803013:	c9                   	leave  
  803014:	c3                   	ret    

00803015 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803015:	55                   	push   %ebp
  803016:	89 e5                	mov    %esp,%ebp
  803018:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	83 e0 01             	and    $0x1,%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 03                	je     803028 <alloc_block_BF+0x13>
  803025:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803028:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80302c:	77 07                	ja     803035 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80302e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803035:	a1 24 60 80 00       	mov    0x806024,%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	75 73                	jne    8030b1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	83 c0 10             	add    $0x10,%eax
  803044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803047:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80304e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803054:	01 d0                	add    %edx,%eax
  803056:	48                   	dec    %eax
  803057:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80305a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305d:	ba 00 00 00 00       	mov    $0x0,%edx
  803062:	f7 75 e0             	divl   -0x20(%ebp)
  803065:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803068:	29 d0                	sub    %edx,%eax
  80306a:	c1 e8 0c             	shr    $0xc,%eax
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	50                   	push   %eax
  803071:	e8 72 ec ff ff       	call   801ce8 <sbrk>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80307c:	83 ec 0c             	sub    $0xc,%esp
  80307f:	6a 00                	push   $0x0
  803081:	e8 62 ec ff ff       	call   801ce8 <sbrk>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80308c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80308f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803092:	83 ec 08             	sub    $0x8,%esp
  803095:	50                   	push   %eax
  803096:	ff 75 d8             	pushl  -0x28(%ebp)
  803099:	e8 9f f8 ff ff       	call   80293d <initialize_dynamic_allocator>
  80309e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030a1:	83 ec 0c             	sub    $0xc,%esp
  8030a4:	68 c3 50 80 00       	push   $0x8050c3
  8030a9:	e8 a0 de ff ff       	call   800f4e <cprintf>
  8030ae:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8030b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8030b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030bf:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8030cd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8030d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d5:	e9 1d 01 00 00       	jmp    8031f7 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8030e0:	83 ec 0c             	sub    $0xc,%esp
  8030e3:	ff 75 a8             	pushl  -0x58(%ebp)
  8030e6:	e8 ee f6 ff ff       	call   8027d9 <get_block_size>
  8030eb:	83 c4 10             	add    $0x10,%esp
  8030ee:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	83 c0 08             	add    $0x8,%eax
  8030f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030fa:	0f 87 ef 00 00 00    	ja     8031ef <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	83 c0 18             	add    $0x18,%eax
  803106:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803109:	77 1d                	ja     803128 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803111:	0f 86 d8 00 00 00    	jbe    8031ef <alloc_block_BF+0x1da>
				{
					best_va = va;
  803117:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80311a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80311d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803120:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803123:	e9 c7 00 00 00       	jmp    8031ef <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	83 c0 08             	add    $0x8,%eax
  80312e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803131:	0f 85 9d 00 00 00    	jne    8031d4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	6a 01                	push   $0x1
  80313c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80313f:	ff 75 a8             	pushl  -0x58(%ebp)
  803142:	e8 e3 f9 ff ff       	call   802b2a <set_block_data>
  803147:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80314a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314e:	75 17                	jne    803167 <alloc_block_BF+0x152>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 67 50 80 00       	push   $0x805067
  803158:	68 2c 01 00 00       	push   $0x12c
  80315d:	68 85 50 80 00       	push   $0x805085
  803162:	e8 2a db ff ff       	call   800c91 <_panic>
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 10                	je     803180 <alloc_block_BF+0x16b>
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803178:	8b 52 04             	mov    0x4(%edx),%edx
  80317b:	89 50 04             	mov    %edx,0x4(%eax)
  80317e:	eb 0b                	jmp    80318b <alloc_block_BF+0x176>
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	a3 30 60 80 00       	mov    %eax,0x806030
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0f                	je     8031a4 <alloc_block_BF+0x18f>
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319e:	8b 12                	mov    (%edx),%edx
  8031a0:	89 10                	mov    %edx,(%eax)
  8031a2:	eb 0a                	jmp    8031ae <alloc_block_BF+0x199>
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c1:	a1 38 60 80 00       	mov    0x806038,%eax
  8031c6:	48                   	dec    %eax
  8031c7:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  8031cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031cf:	e9 24 04 00 00       	jmp    8035f8 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031da:	76 13                	jbe    8031ef <alloc_block_BF+0x1da>
					{
						internal = 1;
  8031dc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8031e3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8031e9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031ec:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8031ef:	a1 34 60 80 00       	mov    0x806034,%eax
  8031f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fb:	74 07                	je     803204 <alloc_block_BF+0x1ef>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	eb 05                	jmp    803209 <alloc_block_BF+0x1f4>
  803204:	b8 00 00 00 00       	mov    $0x0,%eax
  803209:	a3 34 60 80 00       	mov    %eax,0x806034
  80320e:	a1 34 60 80 00       	mov    0x806034,%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	0f 85 bf fe ff ff    	jne    8030da <alloc_block_BF+0xc5>
  80321b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321f:	0f 85 b5 fe ff ff    	jne    8030da <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803229:	0f 84 26 02 00 00    	je     803455 <alloc_block_BF+0x440>
  80322f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803233:	0f 85 1c 02 00 00    	jne    803455 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323c:	2b 45 08             	sub    0x8(%ebp),%eax
  80323f:	83 e8 08             	sub    $0x8,%eax
  803242:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	8d 50 08             	lea    0x8(%eax),%edx
  80324b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324e:	01 d0                	add    %edx,%eax
  803250:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	83 c0 08             	add    $0x8,%eax
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	6a 01                	push   $0x1
  80325e:	50                   	push   %eax
  80325f:	ff 75 f0             	pushl  -0x10(%ebp)
  803262:	e8 c3 f8 ff ff       	call   802b2a <set_block_data>
  803267:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	75 68                	jne    8032dc <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803274:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803278:	75 17                	jne    803291 <alloc_block_BF+0x27c>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 a0 50 80 00       	push   $0x8050a0
  803282:	68 45 01 00 00       	push   $0x145
  803287:	68 85 50 80 00       	push   $0x805085
  80328c:	e8 00 da ff ff       	call   800c91 <_panic>
  803291:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803297:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80329a:	89 10                	mov    %edx,(%eax)
  80329c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0d                	je     8032b2 <alloc_block_BF+0x29d>
  8032a5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8032aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	eb 08                	jmp    8032ba <alloc_block_BF+0x2a5>
  8032b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b5:	a3 30 60 80 00       	mov    %eax,0x806030
  8032ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cc:	a1 38 60 80 00       	mov    0x806038,%eax
  8032d1:	40                   	inc    %eax
  8032d2:	a3 38 60 80 00       	mov    %eax,0x806038
  8032d7:	e9 dc 00 00 00       	jmp    8033b8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	75 65                	jne    80334a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032e9:	75 17                	jne    803302 <alloc_block_BF+0x2ed>
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 d4 50 80 00       	push   $0x8050d4
  8032f3:	68 4a 01 00 00       	push   $0x14a
  8032f8:	68 85 50 80 00       	push   $0x805085
  8032fd:	e8 8f d9 ff ff       	call   800c91 <_panic>
  803302:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803308:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330b:	89 50 04             	mov    %edx,0x4(%eax)
  80330e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803311:	8b 40 04             	mov    0x4(%eax),%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	74 0c                	je     803324 <alloc_block_BF+0x30f>
  803318:	a1 30 60 80 00       	mov    0x806030,%eax
  80331d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803320:	89 10                	mov    %edx,(%eax)
  803322:	eb 08                	jmp    80332c <alloc_block_BF+0x317>
  803324:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803327:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80332c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80332f:	a3 30 60 80 00       	mov    %eax,0x806030
  803334:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333d:	a1 38 60 80 00       	mov    0x806038,%eax
  803342:	40                   	inc    %eax
  803343:	a3 38 60 80 00       	mov    %eax,0x806038
  803348:	eb 6e                	jmp    8033b8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80334a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80334e:	74 06                	je     803356 <alloc_block_BF+0x341>
  803350:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803354:	75 17                	jne    80336d <alloc_block_BF+0x358>
  803356:	83 ec 04             	sub    $0x4,%esp
  803359:	68 f8 50 80 00       	push   $0x8050f8
  80335e:	68 4f 01 00 00       	push   $0x14f
  803363:	68 85 50 80 00       	push   $0x805085
  803368:	e8 24 d9 ff ff       	call   800c91 <_panic>
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 10                	mov    (%eax),%edx
  803372:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803375:	89 10                	mov    %edx,(%eax)
  803377:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0b                	je     80338b <alloc_block_BF+0x376>
  803380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803388:	89 50 04             	mov    %edx,0x4(%eax)
  80338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803391:	89 10                	mov    %edx,(%eax)
  803393:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803396:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803399:	89 50 04             	mov    %edx,0x4(%eax)
  80339c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	75 08                	jne    8033ad <alloc_block_BF+0x398>
  8033a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a8:	a3 30 60 80 00       	mov    %eax,0x806030
  8033ad:	a1 38 60 80 00       	mov    0x806038,%eax
  8033b2:	40                   	inc    %eax
  8033b3:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8033b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033bc:	75 17                	jne    8033d5 <alloc_block_BF+0x3c0>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 67 50 80 00       	push   $0x805067
  8033c6:	68 51 01 00 00       	push   $0x151
  8033cb:	68 85 50 80 00       	push   $0x805085
  8033d0:	e8 bc d8 ff ff       	call   800c91 <_panic>
  8033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	74 10                	je     8033ee <alloc_block_BF+0x3d9>
  8033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e6:	8b 52 04             	mov    0x4(%edx),%edx
  8033e9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ec:	eb 0b                	jmp    8033f9 <alloc_block_BF+0x3e4>
  8033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f1:	8b 40 04             	mov    0x4(%eax),%eax
  8033f4:	a3 30 60 80 00       	mov    %eax,0x806030
  8033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fc:	8b 40 04             	mov    0x4(%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0f                	je     803412 <alloc_block_BF+0x3fd>
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340c:	8b 12                	mov    (%edx),%edx
  80340e:	89 10                	mov    %edx,(%eax)
  803410:	eb 0a                	jmp    80341c <alloc_block_BF+0x407>
  803412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803415:	8b 00                	mov    (%eax),%eax
  803417:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803428:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342f:	a1 38 60 80 00       	mov    0x806038,%eax
  803434:	48                   	dec    %eax
  803435:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	6a 00                	push   $0x0
  80343f:	ff 75 d0             	pushl  -0x30(%ebp)
  803442:	ff 75 cc             	pushl  -0x34(%ebp)
  803445:	e8 e0 f6 ff ff       	call   802b2a <set_block_data>
  80344a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80344d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803450:	e9 a3 01 00 00       	jmp    8035f8 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803455:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803459:	0f 85 9d 00 00 00    	jne    8034fc <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	6a 01                	push   $0x1
  803464:	ff 75 ec             	pushl  -0x14(%ebp)
  803467:	ff 75 f0             	pushl  -0x10(%ebp)
  80346a:	e8 bb f6 ff ff       	call   802b2a <set_block_data>
  80346f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803476:	75 17                	jne    80348f <alloc_block_BF+0x47a>
  803478:	83 ec 04             	sub    $0x4,%esp
  80347b:	68 67 50 80 00       	push   $0x805067
  803480:	68 58 01 00 00       	push   $0x158
  803485:	68 85 50 80 00       	push   $0x805085
  80348a:	e8 02 d8 ff ff       	call   800c91 <_panic>
  80348f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	85 c0                	test   %eax,%eax
  803496:	74 10                	je     8034a8 <alloc_block_BF+0x493>
  803498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349b:	8b 00                	mov    (%eax),%eax
  80349d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a0:	8b 52 04             	mov    0x4(%edx),%edx
  8034a3:	89 50 04             	mov    %edx,0x4(%eax)
  8034a6:	eb 0b                	jmp    8034b3 <alloc_block_BF+0x49e>
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	a3 30 60 80 00       	mov    %eax,0x806030
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	8b 40 04             	mov    0x4(%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0f                	je     8034cc <alloc_block_BF+0x4b7>
  8034bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c0:	8b 40 04             	mov    0x4(%eax),%eax
  8034c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c6:	8b 12                	mov    (%edx),%edx
  8034c8:	89 10                	mov    %edx,(%eax)
  8034ca:	eb 0a                	jmp    8034d6 <alloc_block_BF+0x4c1>
  8034cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e9:	a1 38 60 80 00       	mov    0x806038,%eax
  8034ee:	48                   	dec    %eax
  8034ef:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  8034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f7:	e9 fc 00 00 00       	jmp    8035f8 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	83 c0 08             	add    $0x8,%eax
  803502:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803505:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80350c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80350f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803512:	01 d0                	add    %edx,%eax
  803514:	48                   	dec    %eax
  803515:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803518:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80351b:	ba 00 00 00 00       	mov    $0x0,%edx
  803520:	f7 75 c4             	divl   -0x3c(%ebp)
  803523:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803526:	29 d0                	sub    %edx,%eax
  803528:	c1 e8 0c             	shr    $0xc,%eax
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	50                   	push   %eax
  80352f:	e8 b4 e7 ff ff       	call   801ce8 <sbrk>
  803534:	83 c4 10             	add    $0x10,%esp
  803537:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80353a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80353e:	75 0a                	jne    80354a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803540:	b8 00 00 00 00       	mov    $0x0,%eax
  803545:	e9 ae 00 00 00       	jmp    8035f8 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80354a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803551:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803554:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803557:	01 d0                	add    %edx,%eax
  803559:	48                   	dec    %eax
  80355a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80355d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803560:	ba 00 00 00 00       	mov    $0x0,%edx
  803565:	f7 75 b8             	divl   -0x48(%ebp)
  803568:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80356b:	29 d0                	sub    %edx,%eax
  80356d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803570:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803573:	01 d0                	add    %edx,%eax
  803575:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  80357a:	a1 40 60 80 00       	mov    0x806040,%eax
  80357f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803585:	83 ec 0c             	sub    $0xc,%esp
  803588:	68 2c 51 80 00       	push   $0x80512c
  80358d:	e8 bc d9 ff ff       	call   800f4e <cprintf>
  803592:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803595:	83 ec 08             	sub    $0x8,%esp
  803598:	ff 75 bc             	pushl  -0x44(%ebp)
  80359b:	68 31 51 80 00       	push   $0x805131
  8035a0:	e8 a9 d9 ff ff       	call   800f4e <cprintf>
  8035a5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035a8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8035af:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	48                   	dec    %eax
  8035b8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8035bb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035be:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c3:	f7 75 b0             	divl   -0x50(%ebp)
  8035c6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035c9:	29 d0                	sub    %edx,%eax
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	6a 01                	push   $0x1
  8035d0:	50                   	push   %eax
  8035d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8035d4:	e8 51 f5 ff ff       	call   802b2a <set_block_data>
  8035d9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8035dc:	83 ec 0c             	sub    $0xc,%esp
  8035df:	ff 75 bc             	pushl  -0x44(%ebp)
  8035e2:	e8 36 04 00 00       	call   803a1d <free_block>
  8035e7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8035ea:	83 ec 0c             	sub    $0xc,%esp
  8035ed:	ff 75 08             	pushl  0x8(%ebp)
  8035f0:	e8 20 fa ff ff       	call   803015 <alloc_block_BF>
  8035f5:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8035f8:	c9                   	leave  
  8035f9:	c3                   	ret    

008035fa <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	53                   	push   %ebx
  8035fe:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803608:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80360f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803613:	74 1e                	je     803633 <merging+0x39>
  803615:	ff 75 08             	pushl  0x8(%ebp)
  803618:	e8 bc f1 ff ff       	call   8027d9 <get_block_size>
  80361d:	83 c4 04             	add    $0x4,%esp
  803620:	89 c2                	mov    %eax,%edx
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	01 d0                	add    %edx,%eax
  803627:	3b 45 10             	cmp    0x10(%ebp),%eax
  80362a:	75 07                	jne    803633 <merging+0x39>
		prev_is_free = 1;
  80362c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803637:	74 1e                	je     803657 <merging+0x5d>
  803639:	ff 75 10             	pushl  0x10(%ebp)
  80363c:	e8 98 f1 ff ff       	call   8027d9 <get_block_size>
  803641:	83 c4 04             	add    $0x4,%esp
  803644:	89 c2                	mov    %eax,%edx
  803646:	8b 45 10             	mov    0x10(%ebp),%eax
  803649:	01 d0                	add    %edx,%eax
  80364b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80364e:	75 07                	jne    803657 <merging+0x5d>
		next_is_free = 1;
  803650:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365b:	0f 84 cc 00 00 00    	je     80372d <merging+0x133>
  803661:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803665:	0f 84 c2 00 00 00    	je     80372d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80366b:	ff 75 08             	pushl  0x8(%ebp)
  80366e:	e8 66 f1 ff ff       	call   8027d9 <get_block_size>
  803673:	83 c4 04             	add    $0x4,%esp
  803676:	89 c3                	mov    %eax,%ebx
  803678:	ff 75 10             	pushl  0x10(%ebp)
  80367b:	e8 59 f1 ff ff       	call   8027d9 <get_block_size>
  803680:	83 c4 04             	add    $0x4,%esp
  803683:	01 c3                	add    %eax,%ebx
  803685:	ff 75 0c             	pushl  0xc(%ebp)
  803688:	e8 4c f1 ff ff       	call   8027d9 <get_block_size>
  80368d:	83 c4 04             	add    $0x4,%esp
  803690:	01 d8                	add    %ebx,%eax
  803692:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803695:	6a 00                	push   $0x0
  803697:	ff 75 ec             	pushl  -0x14(%ebp)
  80369a:	ff 75 08             	pushl  0x8(%ebp)
  80369d:	e8 88 f4 ff ff       	call   802b2a <set_block_data>
  8036a2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8036a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a9:	75 17                	jne    8036c2 <merging+0xc8>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 67 50 80 00       	push   $0x805067
  8036b3:	68 7d 01 00 00       	push   $0x17d
  8036b8:	68 85 50 80 00       	push   $0x805085
  8036bd:	e8 cf d5 ff ff       	call   800c91 <_panic>
  8036c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	74 10                	je     8036db <merging+0xe1>
  8036cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036d3:	8b 52 04             	mov    0x4(%edx),%edx
  8036d6:	89 50 04             	mov    %edx,0x4(%eax)
  8036d9:	eb 0b                	jmp    8036e6 <merging+0xec>
  8036db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036de:	8b 40 04             	mov    0x4(%eax),%eax
  8036e1:	a3 30 60 80 00       	mov    %eax,0x806030
  8036e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ec:	85 c0                	test   %eax,%eax
  8036ee:	74 0f                	je     8036ff <merging+0x105>
  8036f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f9:	8b 12                	mov    (%edx),%edx
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	eb 0a                	jmp    803709 <merging+0x10f>
  8036ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803712:	8b 45 0c             	mov    0xc(%ebp),%eax
  803715:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371c:	a1 38 60 80 00       	mov    0x806038,%eax
  803721:	48                   	dec    %eax
  803722:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803727:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803728:	e9 ea 02 00 00       	jmp    803a17 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80372d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803731:	74 3b                	je     80376e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803733:	83 ec 0c             	sub    $0xc,%esp
  803736:	ff 75 08             	pushl  0x8(%ebp)
  803739:	e8 9b f0 ff ff       	call   8027d9 <get_block_size>
  80373e:	83 c4 10             	add    $0x10,%esp
  803741:	89 c3                	mov    %eax,%ebx
  803743:	83 ec 0c             	sub    $0xc,%esp
  803746:	ff 75 10             	pushl  0x10(%ebp)
  803749:	e8 8b f0 ff ff       	call   8027d9 <get_block_size>
  80374e:	83 c4 10             	add    $0x10,%esp
  803751:	01 d8                	add    %ebx,%eax
  803753:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	6a 00                	push   $0x0
  80375b:	ff 75 e8             	pushl  -0x18(%ebp)
  80375e:	ff 75 08             	pushl  0x8(%ebp)
  803761:	e8 c4 f3 ff ff       	call   802b2a <set_block_data>
  803766:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803769:	e9 a9 02 00 00       	jmp    803a17 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80376e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803772:	0f 84 2d 01 00 00    	je     8038a5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803778:	83 ec 0c             	sub    $0xc,%esp
  80377b:	ff 75 10             	pushl  0x10(%ebp)
  80377e:	e8 56 f0 ff ff       	call   8027d9 <get_block_size>
  803783:	83 c4 10             	add    $0x10,%esp
  803786:	89 c3                	mov    %eax,%ebx
  803788:	83 ec 0c             	sub    $0xc,%esp
  80378b:	ff 75 0c             	pushl  0xc(%ebp)
  80378e:	e8 46 f0 ff ff       	call   8027d9 <get_block_size>
  803793:	83 c4 10             	add    $0x10,%esp
  803796:	01 d8                	add    %ebx,%eax
  803798:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80379b:	83 ec 04             	sub    $0x4,%esp
  80379e:	6a 00                	push   $0x0
  8037a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037a3:	ff 75 10             	pushl  0x10(%ebp)
  8037a6:	e8 7f f3 ff ff       	call   802b2a <set_block_data>
  8037ab:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8037ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8037b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8037b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037b8:	74 06                	je     8037c0 <merging+0x1c6>
  8037ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037be:	75 17                	jne    8037d7 <merging+0x1dd>
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	68 40 51 80 00       	push   $0x805140
  8037c8:	68 8d 01 00 00       	push   $0x18d
  8037cd:	68 85 50 80 00       	push   $0x805085
  8037d2:	e8 ba d4 ff ff       	call   800c91 <_panic>
  8037d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037da:	8b 50 04             	mov    0x4(%eax),%edx
  8037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ee:	8b 40 04             	mov    0x4(%eax),%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	74 0d                	je     803802 <merging+0x208>
  8037f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f8:	8b 40 04             	mov    0x4(%eax),%eax
  8037fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037fe:	89 10                	mov    %edx,(%eax)
  803800:	eb 08                	jmp    80380a <merging+0x210>
  803802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803805:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80380a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803810:	89 50 04             	mov    %edx,0x4(%eax)
  803813:	a1 38 60 80 00       	mov    0x806038,%eax
  803818:	40                   	inc    %eax
  803819:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  80381e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803822:	75 17                	jne    80383b <merging+0x241>
  803824:	83 ec 04             	sub    $0x4,%esp
  803827:	68 67 50 80 00       	push   $0x805067
  80382c:	68 8e 01 00 00       	push   $0x18e
  803831:	68 85 50 80 00       	push   $0x805085
  803836:	e8 56 d4 ff ff       	call   800c91 <_panic>
  80383b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383e:	8b 00                	mov    (%eax),%eax
  803840:	85 c0                	test   %eax,%eax
  803842:	74 10                	je     803854 <merging+0x25a>
  803844:	8b 45 0c             	mov    0xc(%ebp),%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80384c:	8b 52 04             	mov    0x4(%edx),%edx
  80384f:	89 50 04             	mov    %edx,0x4(%eax)
  803852:	eb 0b                	jmp    80385f <merging+0x265>
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	8b 40 04             	mov    0x4(%eax),%eax
  80385a:	a3 30 60 80 00       	mov    %eax,0x806030
  80385f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803862:	8b 40 04             	mov    0x4(%eax),%eax
  803865:	85 c0                	test   %eax,%eax
  803867:	74 0f                	je     803878 <merging+0x27e>
  803869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386c:	8b 40 04             	mov    0x4(%eax),%eax
  80386f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803872:	8b 12                	mov    (%edx),%edx
  803874:	89 10                	mov    %edx,(%eax)
  803876:	eb 0a                	jmp    803882 <merging+0x288>
  803878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387b:	8b 00                	mov    (%eax),%eax
  80387d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803882:	8b 45 0c             	mov    0xc(%ebp),%eax
  803885:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80388b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803895:	a1 38 60 80 00       	mov    0x806038,%eax
  80389a:	48                   	dec    %eax
  80389b:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038a0:	e9 72 01 00 00       	jmp    803a17 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8038a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8038a8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8038ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038af:	74 79                	je     80392a <merging+0x330>
  8038b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038b5:	74 73                	je     80392a <merging+0x330>
  8038b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038bb:	74 06                	je     8038c3 <merging+0x2c9>
  8038bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038c1:	75 17                	jne    8038da <merging+0x2e0>
  8038c3:	83 ec 04             	sub    $0x4,%esp
  8038c6:	68 f8 50 80 00       	push   $0x8050f8
  8038cb:	68 94 01 00 00       	push   $0x194
  8038d0:	68 85 50 80 00       	push   $0x805085
  8038d5:	e8 b7 d3 ff ff       	call   800c91 <_panic>
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	8b 10                	mov    (%eax),%edx
  8038df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e2:	89 10                	mov    %edx,(%eax)
  8038e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e7:	8b 00                	mov    (%eax),%eax
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	74 0b                	je     8038f8 <merging+0x2fe>
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038f5:	89 50 04             	mov    %edx,0x4(%eax)
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038fe:	89 10                	mov    %edx,(%eax)
  803900:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803903:	8b 55 08             	mov    0x8(%ebp),%edx
  803906:	89 50 04             	mov    %edx,0x4(%eax)
  803909:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	85 c0                	test   %eax,%eax
  803910:	75 08                	jne    80391a <merging+0x320>
  803912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803915:	a3 30 60 80 00       	mov    %eax,0x806030
  80391a:	a1 38 60 80 00       	mov    0x806038,%eax
  80391f:	40                   	inc    %eax
  803920:	a3 38 60 80 00       	mov    %eax,0x806038
  803925:	e9 ce 00 00 00       	jmp    8039f8 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80392a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392e:	74 65                	je     803995 <merging+0x39b>
  803930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803934:	75 17                	jne    80394d <merging+0x353>
  803936:	83 ec 04             	sub    $0x4,%esp
  803939:	68 d4 50 80 00       	push   $0x8050d4
  80393e:	68 95 01 00 00       	push   $0x195
  803943:	68 85 50 80 00       	push   $0x805085
  803948:	e8 44 d3 ff ff       	call   800c91 <_panic>
  80394d:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803953:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803956:	89 50 04             	mov    %edx,0x4(%eax)
  803959:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395c:	8b 40 04             	mov    0x4(%eax),%eax
  80395f:	85 c0                	test   %eax,%eax
  803961:	74 0c                	je     80396f <merging+0x375>
  803963:	a1 30 60 80 00       	mov    0x806030,%eax
  803968:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80396b:	89 10                	mov    %edx,(%eax)
  80396d:	eb 08                	jmp    803977 <merging+0x37d>
  80396f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803972:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803977:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397a:	a3 30 60 80 00       	mov    %eax,0x806030
  80397f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803988:	a1 38 60 80 00       	mov    0x806038,%eax
  80398d:	40                   	inc    %eax
  80398e:	a3 38 60 80 00       	mov    %eax,0x806038
  803993:	eb 63                	jmp    8039f8 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803995:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803999:	75 17                	jne    8039b2 <merging+0x3b8>
  80399b:	83 ec 04             	sub    $0x4,%esp
  80399e:	68 a0 50 80 00       	push   $0x8050a0
  8039a3:	68 98 01 00 00       	push   $0x198
  8039a8:	68 85 50 80 00       	push   $0x805085
  8039ad:	e8 df d2 ff ff       	call   800c91 <_panic>
  8039b2:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8039b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bb:	89 10                	mov    %edx,(%eax)
  8039bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c0:	8b 00                	mov    (%eax),%eax
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	74 0d                	je     8039d3 <merging+0x3d9>
  8039c6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039ce:	89 50 04             	mov    %edx,0x4(%eax)
  8039d1:	eb 08                	jmp    8039db <merging+0x3e1>
  8039d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d6:	a3 30 60 80 00       	mov    %eax,0x806030
  8039db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039de:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ed:	a1 38 60 80 00       	mov    0x806038,%eax
  8039f2:	40                   	inc    %eax
  8039f3:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  8039f8:	83 ec 0c             	sub    $0xc,%esp
  8039fb:	ff 75 10             	pushl  0x10(%ebp)
  8039fe:	e8 d6 ed ff ff       	call   8027d9 <get_block_size>
  803a03:	83 c4 10             	add    $0x10,%esp
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	6a 00                	push   $0x0
  803a0b:	50                   	push   %eax
  803a0c:	ff 75 10             	pushl  0x10(%ebp)
  803a0f:	e8 16 f1 ff ff       	call   802b2a <set_block_data>
  803a14:	83 c4 10             	add    $0x10,%esp
	}
}
  803a17:	90                   	nop
  803a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a1b:	c9                   	leave  
  803a1c:	c3                   	ret    

00803a1d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a1d:	55                   	push   %ebp
  803a1e:	89 e5                	mov    %esp,%ebp
  803a20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a23:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a28:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a2b:	a1 30 60 80 00       	mov    0x806030,%eax
  803a30:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a33:	73 1b                	jae    803a50 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a35:	a1 30 60 80 00       	mov    0x806030,%eax
  803a3a:	83 ec 04             	sub    $0x4,%esp
  803a3d:	ff 75 08             	pushl  0x8(%ebp)
  803a40:	6a 00                	push   $0x0
  803a42:	50                   	push   %eax
  803a43:	e8 b2 fb ff ff       	call   8035fa <merging>
  803a48:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a4b:	e9 8b 00 00 00       	jmp    803adb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a50:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a55:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a58:	76 18                	jbe    803a72 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a5a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a5f:	83 ec 04             	sub    $0x4,%esp
  803a62:	ff 75 08             	pushl  0x8(%ebp)
  803a65:	50                   	push   %eax
  803a66:	6a 00                	push   $0x0
  803a68:	e8 8d fb ff ff       	call   8035fa <merging>
  803a6d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a70:	eb 69                	jmp    803adb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a72:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a7a:	eb 39                	jmp    803ab5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a82:	73 29                	jae    803aad <free_block+0x90>
  803a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a8c:	76 1f                	jbe    803aad <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a91:	8b 00                	mov    (%eax),%eax
  803a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a96:	83 ec 04             	sub    $0x4,%esp
  803a99:	ff 75 08             	pushl  0x8(%ebp)
  803a9c:	ff 75 f0             	pushl  -0x10(%ebp)
  803a9f:	ff 75 f4             	pushl  -0xc(%ebp)
  803aa2:	e8 53 fb ff ff       	call   8035fa <merging>
  803aa7:	83 c4 10             	add    $0x10,%esp
			break;
  803aaa:	90                   	nop
		}
	}
}
  803aab:	eb 2e                	jmp    803adb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803aad:	a1 34 60 80 00       	mov    0x806034,%eax
  803ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ab5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab9:	74 07                	je     803ac2 <free_block+0xa5>
  803abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	eb 05                	jmp    803ac7 <free_block+0xaa>
  803ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac7:	a3 34 60 80 00       	mov    %eax,0x806034
  803acc:	a1 34 60 80 00       	mov    0x806034,%eax
  803ad1:	85 c0                	test   %eax,%eax
  803ad3:	75 a7                	jne    803a7c <free_block+0x5f>
  803ad5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad9:	75 a1                	jne    803a7c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803adb:	90                   	nop
  803adc:	c9                   	leave  
  803add:	c3                   	ret    

00803ade <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803ade:	55                   	push   %ebp
  803adf:	89 e5                	mov    %esp,%ebp
  803ae1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803ae4:	ff 75 08             	pushl  0x8(%ebp)
  803ae7:	e8 ed ec ff ff       	call   8027d9 <get_block_size>
  803aec:	83 c4 04             	add    $0x4,%esp
  803aef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803af2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803af9:	eb 17                	jmp    803b12 <copy_data+0x34>
  803afb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b01:	01 c2                	add    %eax,%edx
  803b03:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	01 c8                	add    %ecx,%eax
  803b0b:	8a 00                	mov    (%eax),%al
  803b0d:	88 02                	mov    %al,(%edx)
  803b0f:	ff 45 fc             	incl   -0x4(%ebp)
  803b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b18:	72 e1                	jb     803afb <copy_data+0x1d>
}
  803b1a:	90                   	nop
  803b1b:	c9                   	leave  
  803b1c:	c3                   	ret    

00803b1d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b1d:	55                   	push   %ebp
  803b1e:	89 e5                	mov    %esp,%ebp
  803b20:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b27:	75 23                	jne    803b4c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b2d:	74 13                	je     803b42 <realloc_block_FF+0x25>
  803b2f:	83 ec 0c             	sub    $0xc,%esp
  803b32:	ff 75 0c             	pushl  0xc(%ebp)
  803b35:	e8 1f f0 ff ff       	call   802b59 <alloc_block_FF>
  803b3a:	83 c4 10             	add    $0x10,%esp
  803b3d:	e9 f4 06 00 00       	jmp    804236 <realloc_block_FF+0x719>
		return NULL;
  803b42:	b8 00 00 00 00       	mov    $0x0,%eax
  803b47:	e9 ea 06 00 00       	jmp    804236 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b50:	75 18                	jne    803b6a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b52:	83 ec 0c             	sub    $0xc,%esp
  803b55:	ff 75 08             	pushl  0x8(%ebp)
  803b58:	e8 c0 fe ff ff       	call   803a1d <free_block>
  803b5d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b60:	b8 00 00 00 00       	mov    $0x0,%eax
  803b65:	e9 cc 06 00 00       	jmp    804236 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b6a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b6e:	77 07                	ja     803b77 <realloc_block_FF+0x5a>
  803b70:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7a:	83 e0 01             	and    $0x1,%eax
  803b7d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b83:	83 c0 08             	add    $0x8,%eax
  803b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b89:	83 ec 0c             	sub    $0xc,%esp
  803b8c:	ff 75 08             	pushl  0x8(%ebp)
  803b8f:	e8 45 ec ff ff       	call   8027d9 <get_block_size>
  803b94:	83 c4 10             	add    $0x10,%esp
  803b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9d:	83 e8 08             	sub    $0x8,%eax
  803ba0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	83 e8 04             	sub    $0x4,%eax
  803ba9:	8b 00                	mov    (%eax),%eax
  803bab:	83 e0 fe             	and    $0xfffffffe,%eax
  803bae:	89 c2                	mov    %eax,%edx
  803bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb3:	01 d0                	add    %edx,%eax
  803bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803bb8:	83 ec 0c             	sub    $0xc,%esp
  803bbb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bbe:	e8 16 ec ff ff       	call   8027d9 <get_block_size>
  803bc3:	83 c4 10             	add    $0x10,%esp
  803bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bcc:	83 e8 08             	sub    $0x8,%eax
  803bcf:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bd8:	75 08                	jne    803be2 <realloc_block_FF+0xc5>
	{
		 return va;
  803bda:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdd:	e9 54 06 00 00       	jmp    804236 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803be8:	0f 83 e5 03 00 00    	jae    803fd3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf1:	2b 45 0c             	sub    0xc(%ebp),%eax
  803bf4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803bf7:	83 ec 0c             	sub    $0xc,%esp
  803bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bfd:	e8 f0 eb ff ff       	call   8027f2 <is_free_block>
  803c02:	83 c4 10             	add    $0x10,%esp
  803c05:	84 c0                	test   %al,%al
  803c07:	0f 84 3b 01 00 00    	je     803d48 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c13:	01 d0                	add    %edx,%eax
  803c15:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	6a 01                	push   $0x1
  803c1d:	ff 75 f0             	pushl  -0x10(%ebp)
  803c20:	ff 75 08             	pushl  0x8(%ebp)
  803c23:	e8 02 ef ff ff       	call   802b2a <set_block_data>
  803c28:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2e:	83 e8 04             	sub    $0x4,%eax
  803c31:	8b 00                	mov    (%eax),%eax
  803c33:	83 e0 fe             	and    $0xfffffffe,%eax
  803c36:	89 c2                	mov    %eax,%edx
  803c38:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3b:	01 d0                	add    %edx,%eax
  803c3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c40:	83 ec 04             	sub    $0x4,%esp
  803c43:	6a 00                	push   $0x0
  803c45:	ff 75 cc             	pushl  -0x34(%ebp)
  803c48:	ff 75 c8             	pushl  -0x38(%ebp)
  803c4b:	e8 da ee ff ff       	call   802b2a <set_block_data>
  803c50:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c57:	74 06                	je     803c5f <realloc_block_FF+0x142>
  803c59:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c5d:	75 17                	jne    803c76 <realloc_block_FF+0x159>
  803c5f:	83 ec 04             	sub    $0x4,%esp
  803c62:	68 f8 50 80 00       	push   $0x8050f8
  803c67:	68 f6 01 00 00       	push   $0x1f6
  803c6c:	68 85 50 80 00       	push   $0x805085
  803c71:	e8 1b d0 ff ff       	call   800c91 <_panic>
  803c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c79:	8b 10                	mov    (%eax),%edx
  803c7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c7e:	89 10                	mov    %edx,(%eax)
  803c80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c83:	8b 00                	mov    (%eax),%eax
  803c85:	85 c0                	test   %eax,%eax
  803c87:	74 0b                	je     803c94 <realloc_block_FF+0x177>
  803c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c91:	89 50 04             	mov    %edx,0x4(%eax)
  803c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c97:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c9a:	89 10                	mov    %edx,(%eax)
  803c9c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ca2:	89 50 04             	mov    %edx,0x4(%eax)
  803ca5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	85 c0                	test   %eax,%eax
  803cac:	75 08                	jne    803cb6 <realloc_block_FF+0x199>
  803cae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cb1:	a3 30 60 80 00       	mov    %eax,0x806030
  803cb6:	a1 38 60 80 00       	mov    0x806038,%eax
  803cbb:	40                   	inc    %eax
  803cbc:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cc5:	75 17                	jne    803cde <realloc_block_FF+0x1c1>
  803cc7:	83 ec 04             	sub    $0x4,%esp
  803cca:	68 67 50 80 00       	push   $0x805067
  803ccf:	68 f7 01 00 00       	push   $0x1f7
  803cd4:	68 85 50 80 00       	push   $0x805085
  803cd9:	e8 b3 cf ff ff       	call   800c91 <_panic>
  803cde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce1:	8b 00                	mov    (%eax),%eax
  803ce3:	85 c0                	test   %eax,%eax
  803ce5:	74 10                	je     803cf7 <realloc_block_FF+0x1da>
  803ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cea:	8b 00                	mov    (%eax),%eax
  803cec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cef:	8b 52 04             	mov    0x4(%edx),%edx
  803cf2:	89 50 04             	mov    %edx,0x4(%eax)
  803cf5:	eb 0b                	jmp    803d02 <realloc_block_FF+0x1e5>
  803cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfa:	8b 40 04             	mov    0x4(%eax),%eax
  803cfd:	a3 30 60 80 00       	mov    %eax,0x806030
  803d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d05:	8b 40 04             	mov    0x4(%eax),%eax
  803d08:	85 c0                	test   %eax,%eax
  803d0a:	74 0f                	je     803d1b <realloc_block_FF+0x1fe>
  803d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0f:	8b 40 04             	mov    0x4(%eax),%eax
  803d12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d15:	8b 12                	mov    (%edx),%edx
  803d17:	89 10                	mov    %edx,(%eax)
  803d19:	eb 0a                	jmp    803d25 <realloc_block_FF+0x208>
  803d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1e:	8b 00                	mov    (%eax),%eax
  803d20:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d38:	a1 38 60 80 00       	mov    0x806038,%eax
  803d3d:	48                   	dec    %eax
  803d3e:	a3 38 60 80 00       	mov    %eax,0x806038
  803d43:	e9 83 02 00 00       	jmp    803fcb <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803d48:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d4c:	0f 86 69 02 00 00    	jbe    803fbb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d52:	83 ec 04             	sub    $0x4,%esp
  803d55:	6a 01                	push   $0x1
  803d57:	ff 75 f0             	pushl  -0x10(%ebp)
  803d5a:	ff 75 08             	pushl  0x8(%ebp)
  803d5d:	e8 c8 ed ff ff       	call   802b2a <set_block_data>
  803d62:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d65:	8b 45 08             	mov    0x8(%ebp),%eax
  803d68:	83 e8 04             	sub    $0x4,%eax
  803d6b:	8b 00                	mov    (%eax),%eax
  803d6d:	83 e0 fe             	and    $0xfffffffe,%eax
  803d70:	89 c2                	mov    %eax,%edx
  803d72:	8b 45 08             	mov    0x8(%ebp),%eax
  803d75:	01 d0                	add    %edx,%eax
  803d77:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d7a:	a1 38 60 80 00       	mov    0x806038,%eax
  803d7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d82:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d86:	75 68                	jne    803df0 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d8c:	75 17                	jne    803da5 <realloc_block_FF+0x288>
  803d8e:	83 ec 04             	sub    $0x4,%esp
  803d91:	68 a0 50 80 00       	push   $0x8050a0
  803d96:	68 06 02 00 00       	push   $0x206
  803d9b:	68 85 50 80 00       	push   $0x805085
  803da0:	e8 ec ce ff ff       	call   800c91 <_panic>
  803da5:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803dab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dae:	89 10                	mov    %edx,(%eax)
  803db0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db3:	8b 00                	mov    (%eax),%eax
  803db5:	85 c0                	test   %eax,%eax
  803db7:	74 0d                	je     803dc6 <realloc_block_FF+0x2a9>
  803db9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc1:	89 50 04             	mov    %edx,0x4(%eax)
  803dc4:	eb 08                	jmp    803dce <realloc_block_FF+0x2b1>
  803dc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc9:	a3 30 60 80 00       	mov    %eax,0x806030
  803dce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de0:	a1 38 60 80 00       	mov    0x806038,%eax
  803de5:	40                   	inc    %eax
  803de6:	a3 38 60 80 00       	mov    %eax,0x806038
  803deb:	e9 b0 01 00 00       	jmp    803fa0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803df0:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803df5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803df8:	76 68                	jbe    803e62 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dfa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dfe:	75 17                	jne    803e17 <realloc_block_FF+0x2fa>
  803e00:	83 ec 04             	sub    $0x4,%esp
  803e03:	68 a0 50 80 00       	push   $0x8050a0
  803e08:	68 0b 02 00 00       	push   $0x20b
  803e0d:	68 85 50 80 00       	push   $0x805085
  803e12:	e8 7a ce ff ff       	call   800c91 <_panic>
  803e17:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e20:	89 10                	mov    %edx,(%eax)
  803e22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e25:	8b 00                	mov    (%eax),%eax
  803e27:	85 c0                	test   %eax,%eax
  803e29:	74 0d                	je     803e38 <realloc_block_FF+0x31b>
  803e2b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e33:	89 50 04             	mov    %edx,0x4(%eax)
  803e36:	eb 08                	jmp    803e40 <realloc_block_FF+0x323>
  803e38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e3b:	a3 30 60 80 00       	mov    %eax,0x806030
  803e40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e43:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e52:	a1 38 60 80 00       	mov    0x806038,%eax
  803e57:	40                   	inc    %eax
  803e58:	a3 38 60 80 00       	mov    %eax,0x806038
  803e5d:	e9 3e 01 00 00       	jmp    803fa0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e62:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e67:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e6a:	73 68                	jae    803ed4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e6c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e70:	75 17                	jne    803e89 <realloc_block_FF+0x36c>
  803e72:	83 ec 04             	sub    $0x4,%esp
  803e75:	68 d4 50 80 00       	push   $0x8050d4
  803e7a:	68 10 02 00 00       	push   $0x210
  803e7f:	68 85 50 80 00       	push   $0x805085
  803e84:	e8 08 ce ff ff       	call   800c91 <_panic>
  803e89:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e92:	89 50 04             	mov    %edx,0x4(%eax)
  803e95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e98:	8b 40 04             	mov    0x4(%eax),%eax
  803e9b:	85 c0                	test   %eax,%eax
  803e9d:	74 0c                	je     803eab <realloc_block_FF+0x38e>
  803e9f:	a1 30 60 80 00       	mov    0x806030,%eax
  803ea4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ea7:	89 10                	mov    %edx,(%eax)
  803ea9:	eb 08                	jmp    803eb3 <realloc_block_FF+0x396>
  803eab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eae:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803eb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb6:	a3 30 60 80 00       	mov    %eax,0x806030
  803ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec4:	a1 38 60 80 00       	mov    0x806038,%eax
  803ec9:	40                   	inc    %eax
  803eca:	a3 38 60 80 00       	mov    %eax,0x806038
  803ecf:	e9 cc 00 00 00       	jmp    803fa0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803edb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ee3:	e9 8a 00 00 00       	jmp    803f72 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eeb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803eee:	73 7a                	jae    803f6a <realloc_block_FF+0x44d>
  803ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef3:	8b 00                	mov    (%eax),%eax
  803ef5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ef8:	73 70                	jae    803f6a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803efe:	74 06                	je     803f06 <realloc_block_FF+0x3e9>
  803f00:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f04:	75 17                	jne    803f1d <realloc_block_FF+0x400>
  803f06:	83 ec 04             	sub    $0x4,%esp
  803f09:	68 f8 50 80 00       	push   $0x8050f8
  803f0e:	68 1a 02 00 00       	push   $0x21a
  803f13:	68 85 50 80 00       	push   $0x805085
  803f18:	e8 74 cd ff ff       	call   800c91 <_panic>
  803f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f20:	8b 10                	mov    (%eax),%edx
  803f22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f25:	89 10                	mov    %edx,(%eax)
  803f27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2a:	8b 00                	mov    (%eax),%eax
  803f2c:	85 c0                	test   %eax,%eax
  803f2e:	74 0b                	je     803f3b <realloc_block_FF+0x41e>
  803f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f38:	89 50 04             	mov    %edx,0x4(%eax)
  803f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f41:	89 10                	mov    %edx,(%eax)
  803f43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f49:	89 50 04             	mov    %edx,0x4(%eax)
  803f4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f4f:	8b 00                	mov    (%eax),%eax
  803f51:	85 c0                	test   %eax,%eax
  803f53:	75 08                	jne    803f5d <realloc_block_FF+0x440>
  803f55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f58:	a3 30 60 80 00       	mov    %eax,0x806030
  803f5d:	a1 38 60 80 00       	mov    0x806038,%eax
  803f62:	40                   	inc    %eax
  803f63:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803f68:	eb 36                	jmp    803fa0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f6a:	a1 34 60 80 00       	mov    0x806034,%eax
  803f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f76:	74 07                	je     803f7f <realloc_block_FF+0x462>
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	8b 00                	mov    (%eax),%eax
  803f7d:	eb 05                	jmp    803f84 <realloc_block_FF+0x467>
  803f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f84:	a3 34 60 80 00       	mov    %eax,0x806034
  803f89:	a1 34 60 80 00       	mov    0x806034,%eax
  803f8e:	85 c0                	test   %eax,%eax
  803f90:	0f 85 52 ff ff ff    	jne    803ee8 <realloc_block_FF+0x3cb>
  803f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f9a:	0f 85 48 ff ff ff    	jne    803ee8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803fa0:	83 ec 04             	sub    $0x4,%esp
  803fa3:	6a 00                	push   $0x0
  803fa5:	ff 75 d8             	pushl  -0x28(%ebp)
  803fa8:	ff 75 d4             	pushl  -0x2c(%ebp)
  803fab:	e8 7a eb ff ff       	call   802b2a <set_block_data>
  803fb0:	83 c4 10             	add    $0x10,%esp
				return va;
  803fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb6:	e9 7b 02 00 00       	jmp    804236 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803fbb:	83 ec 0c             	sub    $0xc,%esp
  803fbe:	68 75 51 80 00       	push   $0x805175
  803fc3:	e8 86 cf ff ff       	call   800f4e <cprintf>
  803fc8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fce:	e9 63 02 00 00       	jmp    804236 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fd9:	0f 86 4d 02 00 00    	jbe    80422c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803fdf:	83 ec 0c             	sub    $0xc,%esp
  803fe2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fe5:	e8 08 e8 ff ff       	call   8027f2 <is_free_block>
  803fea:	83 c4 10             	add    $0x10,%esp
  803fed:	84 c0                	test   %al,%al
  803fef:	0f 84 37 02 00 00    	je     80422c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ffb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803ffe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804001:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804004:	76 38                	jbe    80403e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804006:	83 ec 0c             	sub    $0xc,%esp
  804009:	ff 75 08             	pushl  0x8(%ebp)
  80400c:	e8 0c fa ff ff       	call   803a1d <free_block>
  804011:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804014:	83 ec 0c             	sub    $0xc,%esp
  804017:	ff 75 0c             	pushl  0xc(%ebp)
  80401a:	e8 3a eb ff ff       	call   802b59 <alloc_block_FF>
  80401f:	83 c4 10             	add    $0x10,%esp
  804022:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804025:	83 ec 08             	sub    $0x8,%esp
  804028:	ff 75 c0             	pushl  -0x40(%ebp)
  80402b:	ff 75 08             	pushl  0x8(%ebp)
  80402e:	e8 ab fa ff ff       	call   803ade <copy_data>
  804033:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804036:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804039:	e9 f8 01 00 00       	jmp    804236 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80403e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804041:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804044:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804047:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80404b:	0f 87 a0 00 00 00    	ja     8040f1 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804051:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804055:	75 17                	jne    80406e <realloc_block_FF+0x551>
  804057:	83 ec 04             	sub    $0x4,%esp
  80405a:	68 67 50 80 00       	push   $0x805067
  80405f:	68 38 02 00 00       	push   $0x238
  804064:	68 85 50 80 00       	push   $0x805085
  804069:	e8 23 cc ff ff       	call   800c91 <_panic>
  80406e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804071:	8b 00                	mov    (%eax),%eax
  804073:	85 c0                	test   %eax,%eax
  804075:	74 10                	je     804087 <realloc_block_FF+0x56a>
  804077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407a:	8b 00                	mov    (%eax),%eax
  80407c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80407f:	8b 52 04             	mov    0x4(%edx),%edx
  804082:	89 50 04             	mov    %edx,0x4(%eax)
  804085:	eb 0b                	jmp    804092 <realloc_block_FF+0x575>
  804087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408a:	8b 40 04             	mov    0x4(%eax),%eax
  80408d:	a3 30 60 80 00       	mov    %eax,0x806030
  804092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804095:	8b 40 04             	mov    0x4(%eax),%eax
  804098:	85 c0                	test   %eax,%eax
  80409a:	74 0f                	je     8040ab <realloc_block_FF+0x58e>
  80409c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409f:	8b 40 04             	mov    0x4(%eax),%eax
  8040a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040a5:	8b 12                	mov    (%edx),%edx
  8040a7:	89 10                	mov    %edx,(%eax)
  8040a9:	eb 0a                	jmp    8040b5 <realloc_block_FF+0x598>
  8040ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040c8:	a1 38 60 80 00       	mov    0x806038,%eax
  8040cd:	48                   	dec    %eax
  8040ce:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8040d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040d9:	01 d0                	add    %edx,%eax
  8040db:	83 ec 04             	sub    $0x4,%esp
  8040de:	6a 01                	push   $0x1
  8040e0:	50                   	push   %eax
  8040e1:	ff 75 08             	pushl  0x8(%ebp)
  8040e4:	e8 41 ea ff ff       	call   802b2a <set_block_data>
  8040e9:	83 c4 10             	add    $0x10,%esp
  8040ec:	e9 36 01 00 00       	jmp    804227 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8040f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040f7:	01 d0                	add    %edx,%eax
  8040f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8040fc:	83 ec 04             	sub    $0x4,%esp
  8040ff:	6a 01                	push   $0x1
  804101:	ff 75 f0             	pushl  -0x10(%ebp)
  804104:	ff 75 08             	pushl  0x8(%ebp)
  804107:	e8 1e ea ff ff       	call   802b2a <set_block_data>
  80410c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80410f:	8b 45 08             	mov    0x8(%ebp),%eax
  804112:	83 e8 04             	sub    $0x4,%eax
  804115:	8b 00                	mov    (%eax),%eax
  804117:	83 e0 fe             	and    $0xfffffffe,%eax
  80411a:	89 c2                	mov    %eax,%edx
  80411c:	8b 45 08             	mov    0x8(%ebp),%eax
  80411f:	01 d0                	add    %edx,%eax
  804121:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804124:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804128:	74 06                	je     804130 <realloc_block_FF+0x613>
  80412a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80412e:	75 17                	jne    804147 <realloc_block_FF+0x62a>
  804130:	83 ec 04             	sub    $0x4,%esp
  804133:	68 f8 50 80 00       	push   $0x8050f8
  804138:	68 44 02 00 00       	push   $0x244
  80413d:	68 85 50 80 00       	push   $0x805085
  804142:	e8 4a cb ff ff       	call   800c91 <_panic>
  804147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414a:	8b 10                	mov    (%eax),%edx
  80414c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80414f:	89 10                	mov    %edx,(%eax)
  804151:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804154:	8b 00                	mov    (%eax),%eax
  804156:	85 c0                	test   %eax,%eax
  804158:	74 0b                	je     804165 <realloc_block_FF+0x648>
  80415a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415d:	8b 00                	mov    (%eax),%eax
  80415f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804162:	89 50 04             	mov    %edx,0x4(%eax)
  804165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804168:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80416b:	89 10                	mov    %edx,(%eax)
  80416d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804170:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804173:	89 50 04             	mov    %edx,0x4(%eax)
  804176:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804179:	8b 00                	mov    (%eax),%eax
  80417b:	85 c0                	test   %eax,%eax
  80417d:	75 08                	jne    804187 <realloc_block_FF+0x66a>
  80417f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804182:	a3 30 60 80 00       	mov    %eax,0x806030
  804187:	a1 38 60 80 00       	mov    0x806038,%eax
  80418c:	40                   	inc    %eax
  80418d:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804192:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804196:	75 17                	jne    8041af <realloc_block_FF+0x692>
  804198:	83 ec 04             	sub    $0x4,%esp
  80419b:	68 67 50 80 00       	push   $0x805067
  8041a0:	68 45 02 00 00       	push   $0x245
  8041a5:	68 85 50 80 00       	push   $0x805085
  8041aa:	e8 e2 ca ff ff       	call   800c91 <_panic>
  8041af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b2:	8b 00                	mov    (%eax),%eax
  8041b4:	85 c0                	test   %eax,%eax
  8041b6:	74 10                	je     8041c8 <realloc_block_FF+0x6ab>
  8041b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041bb:	8b 00                	mov    (%eax),%eax
  8041bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041c0:	8b 52 04             	mov    0x4(%edx),%edx
  8041c3:	89 50 04             	mov    %edx,0x4(%eax)
  8041c6:	eb 0b                	jmp    8041d3 <realloc_block_FF+0x6b6>
  8041c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041cb:	8b 40 04             	mov    0x4(%eax),%eax
  8041ce:	a3 30 60 80 00       	mov    %eax,0x806030
  8041d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d6:	8b 40 04             	mov    0x4(%eax),%eax
  8041d9:	85 c0                	test   %eax,%eax
  8041db:	74 0f                	je     8041ec <realloc_block_FF+0x6cf>
  8041dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e0:	8b 40 04             	mov    0x4(%eax),%eax
  8041e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041e6:	8b 12                	mov    (%edx),%edx
  8041e8:	89 10                	mov    %edx,(%eax)
  8041ea:	eb 0a                	jmp    8041f6 <realloc_block_FF+0x6d9>
  8041ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ef:	8b 00                	mov    (%eax),%eax
  8041f1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804202:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804209:	a1 38 60 80 00       	mov    0x806038,%eax
  80420e:	48                   	dec    %eax
  80420f:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804214:	83 ec 04             	sub    $0x4,%esp
  804217:	6a 00                	push   $0x0
  804219:	ff 75 bc             	pushl  -0x44(%ebp)
  80421c:	ff 75 b8             	pushl  -0x48(%ebp)
  80421f:	e8 06 e9 ff ff       	call   802b2a <set_block_data>
  804224:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804227:	8b 45 08             	mov    0x8(%ebp),%eax
  80422a:	eb 0a                	jmp    804236 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80422c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804233:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804236:	c9                   	leave  
  804237:	c3                   	ret    

00804238 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804238:	55                   	push   %ebp
  804239:	89 e5                	mov    %esp,%ebp
  80423b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80423e:	83 ec 04             	sub    $0x4,%esp
  804241:	68 7c 51 80 00       	push   $0x80517c
  804246:	68 58 02 00 00       	push   $0x258
  80424b:	68 85 50 80 00       	push   $0x805085
  804250:	e8 3c ca ff ff       	call   800c91 <_panic>

00804255 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804255:	55                   	push   %ebp
  804256:	89 e5                	mov    %esp,%ebp
  804258:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80425b:	83 ec 04             	sub    $0x4,%esp
  80425e:	68 a4 51 80 00       	push   $0x8051a4
  804263:	68 61 02 00 00       	push   $0x261
  804268:	68 85 50 80 00       	push   $0x805085
  80426d:	e8 1f ca ff ff       	call   800c91 <_panic>

00804272 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804272:	55                   	push   %ebp
  804273:	89 e5                	mov    %esp,%ebp
  804275:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  804278:	83 ec 04             	sub    $0x4,%esp
  80427b:	68 cc 51 80 00       	push   $0x8051cc
  804280:	6a 09                	push   $0x9
  804282:	68 f4 51 80 00       	push   $0x8051f4
  804287:	e8 05 ca ff ff       	call   800c91 <_panic>

0080428c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80428c:	55                   	push   %ebp
  80428d:	89 e5                	mov    %esp,%ebp
  80428f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  804292:	83 ec 04             	sub    $0x4,%esp
  804295:	68 04 52 80 00       	push   $0x805204
  80429a:	6a 10                	push   $0x10
  80429c:	68 f4 51 80 00       	push   $0x8051f4
  8042a1:	e8 eb c9 ff ff       	call   800c91 <_panic>

008042a6 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8042a6:	55                   	push   %ebp
  8042a7:	89 e5                	mov    %esp,%ebp
  8042a9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8042ac:	83 ec 04             	sub    $0x4,%esp
  8042af:	68 2c 52 80 00       	push   $0x80522c
  8042b4:	6a 18                	push   $0x18
  8042b6:	68 f4 51 80 00       	push   $0x8051f4
  8042bb:	e8 d1 c9 ff ff       	call   800c91 <_panic>

008042c0 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8042c0:	55                   	push   %ebp
  8042c1:	89 e5                	mov    %esp,%ebp
  8042c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8042c6:	83 ec 04             	sub    $0x4,%esp
  8042c9:	68 54 52 80 00       	push   $0x805254
  8042ce:	6a 20                	push   $0x20
  8042d0:	68 f4 51 80 00       	push   $0x8051f4
  8042d5:	e8 b7 c9 ff ff       	call   800c91 <_panic>

008042da <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8042da:	55                   	push   %ebp
  8042db:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8042dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e0:	8b 40 10             	mov    0x10(%eax),%eax
}
  8042e3:	5d                   	pop    %ebp
  8042e4:	c3                   	ret    

008042e5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8042e5:	55                   	push   %ebp
  8042e6:	89 e5                	mov    %esp,%ebp
  8042e8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8042eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8042ee:	89 d0                	mov    %edx,%eax
  8042f0:	c1 e0 02             	shl    $0x2,%eax
  8042f3:	01 d0                	add    %edx,%eax
  8042f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8042fc:	01 d0                	add    %edx,%eax
  8042fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804305:	01 d0                	add    %edx,%eax
  804307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80430e:	01 d0                	add    %edx,%eax
  804310:	c1 e0 04             	shl    $0x4,%eax
  804313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80431d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804320:	83 ec 0c             	sub    $0xc,%esp
  804323:	50                   	push   %eax
  804324:	e8 bc e1 ff ff       	call   8024e5 <sys_get_virtual_time>
  804329:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80432c:	eb 41                	jmp    80436f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80432e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804331:	83 ec 0c             	sub    $0xc,%esp
  804334:	50                   	push   %eax
  804335:	e8 ab e1 ff ff       	call   8024e5 <sys_get_virtual_time>
  80433a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80433d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804343:	29 c2                	sub    %eax,%edx
  804345:	89 d0                	mov    %edx,%eax
  804347:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80434a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80434d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804350:	89 d1                	mov    %edx,%ecx
  804352:	29 c1                	sub    %eax,%ecx
  804354:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80435a:	39 c2                	cmp    %eax,%edx
  80435c:	0f 97 c0             	seta   %al
  80435f:	0f b6 c0             	movzbl %al,%eax
  804362:	29 c1                	sub    %eax,%ecx
  804364:	89 c8                	mov    %ecx,%eax
  804366:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804369:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80436c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80436f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804372:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804375:	72 b7                	jb     80432e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804377:	90                   	nop
  804378:	c9                   	leave  
  804379:	c3                   	ret    

0080437a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80437a:	55                   	push   %ebp
  80437b:	89 e5                	mov    %esp,%ebp
  80437d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804387:	eb 03                	jmp    80438c <busy_wait+0x12>
  804389:	ff 45 fc             	incl   -0x4(%ebp)
  80438c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80438f:	3b 45 08             	cmp    0x8(%ebp),%eax
  804392:	72 f5                	jb     804389 <busy_wait+0xf>
	return i;
  804394:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804397:	c9                   	leave  
  804398:	c3                   	ret    
  804399:	66 90                	xchg   %ax,%ax
  80439b:	90                   	nop

0080439c <__udivdi3>:
  80439c:	55                   	push   %ebp
  80439d:	57                   	push   %edi
  80439e:	56                   	push   %esi
  80439f:	53                   	push   %ebx
  8043a0:	83 ec 1c             	sub    $0x1c,%esp
  8043a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043b3:	89 ca                	mov    %ecx,%edx
  8043b5:	89 f8                	mov    %edi,%eax
  8043b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043bb:	85 f6                	test   %esi,%esi
  8043bd:	75 2d                	jne    8043ec <__udivdi3+0x50>
  8043bf:	39 cf                	cmp    %ecx,%edi
  8043c1:	77 65                	ja     804428 <__udivdi3+0x8c>
  8043c3:	89 fd                	mov    %edi,%ebp
  8043c5:	85 ff                	test   %edi,%edi
  8043c7:	75 0b                	jne    8043d4 <__udivdi3+0x38>
  8043c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ce:	31 d2                	xor    %edx,%edx
  8043d0:	f7 f7                	div    %edi
  8043d2:	89 c5                	mov    %eax,%ebp
  8043d4:	31 d2                	xor    %edx,%edx
  8043d6:	89 c8                	mov    %ecx,%eax
  8043d8:	f7 f5                	div    %ebp
  8043da:	89 c1                	mov    %eax,%ecx
  8043dc:	89 d8                	mov    %ebx,%eax
  8043de:	f7 f5                	div    %ebp
  8043e0:	89 cf                	mov    %ecx,%edi
  8043e2:	89 fa                	mov    %edi,%edx
  8043e4:	83 c4 1c             	add    $0x1c,%esp
  8043e7:	5b                   	pop    %ebx
  8043e8:	5e                   	pop    %esi
  8043e9:	5f                   	pop    %edi
  8043ea:	5d                   	pop    %ebp
  8043eb:	c3                   	ret    
  8043ec:	39 ce                	cmp    %ecx,%esi
  8043ee:	77 28                	ja     804418 <__udivdi3+0x7c>
  8043f0:	0f bd fe             	bsr    %esi,%edi
  8043f3:	83 f7 1f             	xor    $0x1f,%edi
  8043f6:	75 40                	jne    804438 <__udivdi3+0x9c>
  8043f8:	39 ce                	cmp    %ecx,%esi
  8043fa:	72 0a                	jb     804406 <__udivdi3+0x6a>
  8043fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804400:	0f 87 9e 00 00 00    	ja     8044a4 <__udivdi3+0x108>
  804406:	b8 01 00 00 00       	mov    $0x1,%eax
  80440b:	89 fa                	mov    %edi,%edx
  80440d:	83 c4 1c             	add    $0x1c,%esp
  804410:	5b                   	pop    %ebx
  804411:	5e                   	pop    %esi
  804412:	5f                   	pop    %edi
  804413:	5d                   	pop    %ebp
  804414:	c3                   	ret    
  804415:	8d 76 00             	lea    0x0(%esi),%esi
  804418:	31 ff                	xor    %edi,%edi
  80441a:	31 c0                	xor    %eax,%eax
  80441c:	89 fa                	mov    %edi,%edx
  80441e:	83 c4 1c             	add    $0x1c,%esp
  804421:	5b                   	pop    %ebx
  804422:	5e                   	pop    %esi
  804423:	5f                   	pop    %edi
  804424:	5d                   	pop    %ebp
  804425:	c3                   	ret    
  804426:	66 90                	xchg   %ax,%ax
  804428:	89 d8                	mov    %ebx,%eax
  80442a:	f7 f7                	div    %edi
  80442c:	31 ff                	xor    %edi,%edi
  80442e:	89 fa                	mov    %edi,%edx
  804430:	83 c4 1c             	add    $0x1c,%esp
  804433:	5b                   	pop    %ebx
  804434:	5e                   	pop    %esi
  804435:	5f                   	pop    %edi
  804436:	5d                   	pop    %ebp
  804437:	c3                   	ret    
  804438:	bd 20 00 00 00       	mov    $0x20,%ebp
  80443d:	89 eb                	mov    %ebp,%ebx
  80443f:	29 fb                	sub    %edi,%ebx
  804441:	89 f9                	mov    %edi,%ecx
  804443:	d3 e6                	shl    %cl,%esi
  804445:	89 c5                	mov    %eax,%ebp
  804447:	88 d9                	mov    %bl,%cl
  804449:	d3 ed                	shr    %cl,%ebp
  80444b:	89 e9                	mov    %ebp,%ecx
  80444d:	09 f1                	or     %esi,%ecx
  80444f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804453:	89 f9                	mov    %edi,%ecx
  804455:	d3 e0                	shl    %cl,%eax
  804457:	89 c5                	mov    %eax,%ebp
  804459:	89 d6                	mov    %edx,%esi
  80445b:	88 d9                	mov    %bl,%cl
  80445d:	d3 ee                	shr    %cl,%esi
  80445f:	89 f9                	mov    %edi,%ecx
  804461:	d3 e2                	shl    %cl,%edx
  804463:	8b 44 24 08          	mov    0x8(%esp),%eax
  804467:	88 d9                	mov    %bl,%cl
  804469:	d3 e8                	shr    %cl,%eax
  80446b:	09 c2                	or     %eax,%edx
  80446d:	89 d0                	mov    %edx,%eax
  80446f:	89 f2                	mov    %esi,%edx
  804471:	f7 74 24 0c          	divl   0xc(%esp)
  804475:	89 d6                	mov    %edx,%esi
  804477:	89 c3                	mov    %eax,%ebx
  804479:	f7 e5                	mul    %ebp
  80447b:	39 d6                	cmp    %edx,%esi
  80447d:	72 19                	jb     804498 <__udivdi3+0xfc>
  80447f:	74 0b                	je     80448c <__udivdi3+0xf0>
  804481:	89 d8                	mov    %ebx,%eax
  804483:	31 ff                	xor    %edi,%edi
  804485:	e9 58 ff ff ff       	jmp    8043e2 <__udivdi3+0x46>
  80448a:	66 90                	xchg   %ax,%ax
  80448c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804490:	89 f9                	mov    %edi,%ecx
  804492:	d3 e2                	shl    %cl,%edx
  804494:	39 c2                	cmp    %eax,%edx
  804496:	73 e9                	jae    804481 <__udivdi3+0xe5>
  804498:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80449b:	31 ff                	xor    %edi,%edi
  80449d:	e9 40 ff ff ff       	jmp    8043e2 <__udivdi3+0x46>
  8044a2:	66 90                	xchg   %ax,%ax
  8044a4:	31 c0                	xor    %eax,%eax
  8044a6:	e9 37 ff ff ff       	jmp    8043e2 <__udivdi3+0x46>
  8044ab:	90                   	nop

008044ac <__umoddi3>:
  8044ac:	55                   	push   %ebp
  8044ad:	57                   	push   %edi
  8044ae:	56                   	push   %esi
  8044af:	53                   	push   %ebx
  8044b0:	83 ec 1c             	sub    $0x1c,%esp
  8044b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044cb:	89 f3                	mov    %esi,%ebx
  8044cd:	89 fa                	mov    %edi,%edx
  8044cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044d3:	89 34 24             	mov    %esi,(%esp)
  8044d6:	85 c0                	test   %eax,%eax
  8044d8:	75 1a                	jne    8044f4 <__umoddi3+0x48>
  8044da:	39 f7                	cmp    %esi,%edi
  8044dc:	0f 86 a2 00 00 00    	jbe    804584 <__umoddi3+0xd8>
  8044e2:	89 c8                	mov    %ecx,%eax
  8044e4:	89 f2                	mov    %esi,%edx
  8044e6:	f7 f7                	div    %edi
  8044e8:	89 d0                	mov    %edx,%eax
  8044ea:	31 d2                	xor    %edx,%edx
  8044ec:	83 c4 1c             	add    $0x1c,%esp
  8044ef:	5b                   	pop    %ebx
  8044f0:	5e                   	pop    %esi
  8044f1:	5f                   	pop    %edi
  8044f2:	5d                   	pop    %ebp
  8044f3:	c3                   	ret    
  8044f4:	39 f0                	cmp    %esi,%eax
  8044f6:	0f 87 ac 00 00 00    	ja     8045a8 <__umoddi3+0xfc>
  8044fc:	0f bd e8             	bsr    %eax,%ebp
  8044ff:	83 f5 1f             	xor    $0x1f,%ebp
  804502:	0f 84 ac 00 00 00    	je     8045b4 <__umoddi3+0x108>
  804508:	bf 20 00 00 00       	mov    $0x20,%edi
  80450d:	29 ef                	sub    %ebp,%edi
  80450f:	89 fe                	mov    %edi,%esi
  804511:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804515:	89 e9                	mov    %ebp,%ecx
  804517:	d3 e0                	shl    %cl,%eax
  804519:	89 d7                	mov    %edx,%edi
  80451b:	89 f1                	mov    %esi,%ecx
  80451d:	d3 ef                	shr    %cl,%edi
  80451f:	09 c7                	or     %eax,%edi
  804521:	89 e9                	mov    %ebp,%ecx
  804523:	d3 e2                	shl    %cl,%edx
  804525:	89 14 24             	mov    %edx,(%esp)
  804528:	89 d8                	mov    %ebx,%eax
  80452a:	d3 e0                	shl    %cl,%eax
  80452c:	89 c2                	mov    %eax,%edx
  80452e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804532:	d3 e0                	shl    %cl,%eax
  804534:	89 44 24 04          	mov    %eax,0x4(%esp)
  804538:	8b 44 24 08          	mov    0x8(%esp),%eax
  80453c:	89 f1                	mov    %esi,%ecx
  80453e:	d3 e8                	shr    %cl,%eax
  804540:	09 d0                	or     %edx,%eax
  804542:	d3 eb                	shr    %cl,%ebx
  804544:	89 da                	mov    %ebx,%edx
  804546:	f7 f7                	div    %edi
  804548:	89 d3                	mov    %edx,%ebx
  80454a:	f7 24 24             	mull   (%esp)
  80454d:	89 c6                	mov    %eax,%esi
  80454f:	89 d1                	mov    %edx,%ecx
  804551:	39 d3                	cmp    %edx,%ebx
  804553:	0f 82 87 00 00 00    	jb     8045e0 <__umoddi3+0x134>
  804559:	0f 84 91 00 00 00    	je     8045f0 <__umoddi3+0x144>
  80455f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804563:	29 f2                	sub    %esi,%edx
  804565:	19 cb                	sbb    %ecx,%ebx
  804567:	89 d8                	mov    %ebx,%eax
  804569:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80456d:	d3 e0                	shl    %cl,%eax
  80456f:	89 e9                	mov    %ebp,%ecx
  804571:	d3 ea                	shr    %cl,%edx
  804573:	09 d0                	or     %edx,%eax
  804575:	89 e9                	mov    %ebp,%ecx
  804577:	d3 eb                	shr    %cl,%ebx
  804579:	89 da                	mov    %ebx,%edx
  80457b:	83 c4 1c             	add    $0x1c,%esp
  80457e:	5b                   	pop    %ebx
  80457f:	5e                   	pop    %esi
  804580:	5f                   	pop    %edi
  804581:	5d                   	pop    %ebp
  804582:	c3                   	ret    
  804583:	90                   	nop
  804584:	89 fd                	mov    %edi,%ebp
  804586:	85 ff                	test   %edi,%edi
  804588:	75 0b                	jne    804595 <__umoddi3+0xe9>
  80458a:	b8 01 00 00 00       	mov    $0x1,%eax
  80458f:	31 d2                	xor    %edx,%edx
  804591:	f7 f7                	div    %edi
  804593:	89 c5                	mov    %eax,%ebp
  804595:	89 f0                	mov    %esi,%eax
  804597:	31 d2                	xor    %edx,%edx
  804599:	f7 f5                	div    %ebp
  80459b:	89 c8                	mov    %ecx,%eax
  80459d:	f7 f5                	div    %ebp
  80459f:	89 d0                	mov    %edx,%eax
  8045a1:	e9 44 ff ff ff       	jmp    8044ea <__umoddi3+0x3e>
  8045a6:	66 90                	xchg   %ax,%ax
  8045a8:	89 c8                	mov    %ecx,%eax
  8045aa:	89 f2                	mov    %esi,%edx
  8045ac:	83 c4 1c             	add    $0x1c,%esp
  8045af:	5b                   	pop    %ebx
  8045b0:	5e                   	pop    %esi
  8045b1:	5f                   	pop    %edi
  8045b2:	5d                   	pop    %ebp
  8045b3:	c3                   	ret    
  8045b4:	3b 04 24             	cmp    (%esp),%eax
  8045b7:	72 06                	jb     8045bf <__umoddi3+0x113>
  8045b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045bd:	77 0f                	ja     8045ce <__umoddi3+0x122>
  8045bf:	89 f2                	mov    %esi,%edx
  8045c1:	29 f9                	sub    %edi,%ecx
  8045c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045c7:	89 14 24             	mov    %edx,(%esp)
  8045ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045d2:	8b 14 24             	mov    (%esp),%edx
  8045d5:	83 c4 1c             	add    $0x1c,%esp
  8045d8:	5b                   	pop    %ebx
  8045d9:	5e                   	pop    %esi
  8045da:	5f                   	pop    %edi
  8045db:	5d                   	pop    %ebp
  8045dc:	c3                   	ret    
  8045dd:	8d 76 00             	lea    0x0(%esi),%esi
  8045e0:	2b 04 24             	sub    (%esp),%eax
  8045e3:	19 fa                	sbb    %edi,%edx
  8045e5:	89 d1                	mov    %edx,%ecx
  8045e7:	89 c6                	mov    %eax,%esi
  8045e9:	e9 71 ff ff ff       	jmp    80455f <__umoddi3+0xb3>
  8045ee:	66 90                	xchg   %ax,%ax
  8045f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045f4:	72 ea                	jb     8045e0 <__umoddi3+0x134>
  8045f6:	89 d9                	mov    %ebx,%ecx
  8045f8:	e9 62 ff ff ff       	jmp    80455f <__umoddi3+0xb3>

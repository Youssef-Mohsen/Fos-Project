
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
  800044:	e8 47 24 00 00       	call   802490 <sys_getenvid>
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
  80007c:	bb 92 48 80 00       	mov    $0x804892,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb 9c 48 80 00       	mov    $0x80489c,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb a8 48 80 00       	mov    $0x8048a8,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb b7 48 80 00       	mov    $0x8048b7,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb c6 48 80 00       	mov    $0x8048c6,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb db 48 80 00       	mov    $0x8048db,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb f0 48 80 00       	mov    $0x8048f0,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 01 49 80 00       	mov    $0x804901,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 12 49 80 00       	mov    $0x804912,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 23 49 80 00       	mov    $0x804923,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 2c 49 80 00       	mov    $0x80492c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 36 49 80 00       	mov    $0x804936,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb 41 49 80 00       	mov    $0x804941,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb 4d 49 80 00       	mov    $0x80494d,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb 57 49 80 00       	mov    $0x804957,%ebx
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
  8001f7:	bb 61 49 80 00       	mov    $0x804961,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb 6f 49 80 00       	mov    $0x80496f,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb 7e 49 80 00       	mov    $0x80497e,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb 85 49 80 00       	mov    $0x804985,%ebx
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
  800499:	e8 e4 3d 00 00       	call   804282 <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 c9 3d 00 00       	call   804282 <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 ae 3d 00 00       	call   804282 <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 93 3d 00 00       	call   804282 <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 78 3d 00 00       	call   804282 <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 5d 3d 00 00       	call   804282 <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 42 3d 00 00       	call   804282 <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 20 46 80 00       	push   $0x804620
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
  80057b:	bb 8c 49 80 00       	mov    $0x80498c,%ebx
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
  8005fc:	e8 81 3c 00 00       	call   804282 <create_semaphore>
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
  800648:	e8 ee 1d 00 00       	call   80243b <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 f4 1d 00 00       	call   802459 <sys_run_env>
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
  800695:	e8 a1 1d 00 00       	call   80243b <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 a7 1d 00 00       	call   802459 <sys_run_env>
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
  8006e2:	e8 54 1d 00 00       	call   80243b <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 5a 1d 00 00       	call   802459 <sys_run_env>
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
  800738:	e8 fe 1c 00 00       	call   80243b <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 34 46 80 00       	push   $0x804634
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 7a 46 80 00       	push   $0x80467a
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 e4 1c 00 00       	call   802459 <sys_run_env>
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
  800795:	e8 1c 3b 00 00       	call   8042b6 <wait_semaphore>
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
  8007b0:	e8 40 3b 00 00       	call   8042f5 <env_sleep>
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
  8007f6:	68 8c 46 80 00       	push   $0x80468c
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
  80084e:	68 bc 46 80 00       	push   $0x8046bc
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
  80088d:	68 ec 46 80 00       	push   $0x8046ec
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 7a 46 80 00       	push   $0x80467a
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
  8008d0:	68 ec 46 80 00       	push   $0x8046ec
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 7a 46 80 00       	push   $0x80467a
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
  800931:	68 ec 46 80 00       	push   $0x8046ec
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 7a 46 80 00       	push   $0x80467a
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
  80095e:	e8 87 39 00 00       	call   8042ea <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 10 47 80 00       	push   $0x804710
  800970:	68 30 47 80 00       	push   $0x804730
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 7a 46 80 00       	push   $0x80467a
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 58 39 00 00       	call   8042ea <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 48 47 80 00       	push   $0x804748
  80099f:	68 30 47 80 00       	push   $0x804730
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 7a 46 80 00       	push   $0x80467a
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 29 39 00 00       	call   8042ea <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 68 47 80 00       	push   $0x804768
  8009ce:	68 30 47 80 00       	push   $0x804730
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 7a 46 80 00       	push   $0x80467a
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 fa 38 00 00       	call   8042ea <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 8c 47 80 00       	push   $0x80478c
  8009fd:	68 30 47 80 00       	push   $0x804730
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 7a 46 80 00       	push   $0x80467a
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 cb 38 00 00       	call   8042ea <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 ae 47 80 00       	push   $0x8047ae
  800a2c:	68 30 47 80 00       	push   $0x804730
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 7a 46 80 00       	push   $0x80467a
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 9c 38 00 00       	call   8042ea <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 cc 47 80 00       	push   $0x8047cc
  800a5b:	68 30 47 80 00       	push   $0x804730
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 7a 46 80 00       	push   $0x80467a
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 6d 38 00 00       	call   8042ea <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 f0 47 80 00       	push   $0x8047f0
  800a89:	68 30 47 80 00       	push   $0x804730
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 7a 46 80 00       	push   $0x80467a
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
  800ac4:	e8 21 38 00 00       	call   8042ea <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 18 48 80 00       	push   $0x804818
  800ad5:	68 30 47 80 00       	push   $0x804730
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 7a 46 80 00       	push   $0x80467a
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
  800af7:	68 40 48 80 00       	push   $0x804840
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
  800b58:	e8 4c 19 00 00       	call   8024a9 <sys_getenvindex>
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
  800bc6:	e8 62 16 00 00       	call   80222d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 c4 49 80 00       	push   $0x8049c4
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
  800bf6:	68 ec 49 80 00       	push   $0x8049ec
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
  800c27:	68 14 4a 80 00       	push   $0x804a14
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 6c 4a 80 00       	push   $0x804a6c
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 c4 49 80 00       	push   $0x8049c4
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 e2 15 00 00       	call   802247 <sys_unlock_cons>
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
  800c78:	e8 f8 17 00 00       	call   802475 <sys_destroy_env>
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
  800c89:	e8 4d 18 00 00       	call   8024db <sys_exit_env>
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
  800cb2:	68 80 4a 80 00       	push   $0x804a80
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 85 4a 80 00       	push   $0x804a85
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
  800cef:	68 a1 4a 80 00       	push   $0x804aa1
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
  800d1e:	68 a4 4a 80 00       	push   $0x804aa4
  800d23:	6a 26                	push   $0x26
  800d25:	68 f0 4a 80 00       	push   $0x804af0
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
  800df3:	68 fc 4a 80 00       	push   $0x804afc
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 f0 4a 80 00       	push   $0x804af0
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
  800e66:	68 50 4b 80 00       	push   $0x804b50
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 f0 4a 80 00       	push   $0x804af0
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
  800ec0:	e8 26 13 00 00       	call   8021eb <sys_cputs>
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
  800f37:	e8 af 12 00 00       	call   8021eb <sys_cputs>
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
  800f81:	e8 a7 12 00 00       	call   80222d <sys_lock_cons>
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
  800fa1:	e8 a1 12 00 00       	call   802247 <sys_unlock_cons>
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
  800feb:	e8 bc 33 00 00       	call   8043ac <__udivdi3>
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
  80103b:	e8 7c 34 00 00       	call   8044bc <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 b4 4d 80 00       	add    $0x804db4,%eax
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
  801196:	8b 04 85 d8 4d 80 00 	mov    0x804dd8(,%eax,4),%eax
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
  801277:	8b 34 9d 20 4c 80 00 	mov    0x804c20(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 c5 4d 80 00       	push   $0x804dc5
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
  80129c:	68 ce 4d 80 00       	push   $0x804dce
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
  8012c9:	be d1 4d 80 00       	mov    $0x804dd1,%esi
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
  801cd4:	68 48 4f 80 00       	push   $0x804f48
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 6a 4f 80 00       	push   $0x804f6a
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
  801cf4:	e8 9d 0a 00 00       	call   802796 <sys_sbrk>
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
  801d6f:	e8 a6 08 00 00       	call   80261a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 e6 0d 00 00       	call   802b69 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 b8 08 00 00       	call   80264b <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 7f 12 00 00       	call   803025 <alloc_block_BF>
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
  801f07:	e8 c1 08 00 00       	call   8027cd <sys_allocate_user_mem>
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
  801f4f:	e8 95 08 00 00       	call   8027e9 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 c8 1a 00 00       	call   803a2d <free_block>
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
  801ff7:	e8 b5 07 00 00       	call   8027b1 <sys_free_user_mem>
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
  802005:	68 78 4f 80 00       	push   $0x804f78
  80200a:	68 84 00 00 00       	push   $0x84
  80200f:	68 a2 4f 80 00       	push   $0x804fa2
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
  802032:	eb 74                	jmp    8020a8 <smalloc+0x8d>
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
  802067:	eb 3f                	jmp    8020a8 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802069:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80206d:	ff 75 ec             	pushl  -0x14(%ebp)
  802070:	50                   	push   %eax
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	e8 3c 03 00 00       	call   8023b8 <sys_createSharedObject>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802082:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802086:	74 06                	je     80208e <smalloc+0x73>
  802088:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80208c:	75 07                	jne    802095 <smalloc+0x7a>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 13                	jmp    8020a8 <smalloc+0x8d>
	 cprintf("153\n");
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	68 ae 4f 80 00       	push   $0x804fae
  80209d:	e8 ac ee ff ff       	call   800f4e <cprintf>
  8020a2:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020b0:	83 ec 08             	sub    $0x8,%esp
  8020b3:	ff 75 0c             	pushl  0xc(%ebp)
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	e8 24 03 00 00       	call   8023e2 <sys_getSizeOfSharedObject>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020c4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020c8:	75 07                	jne    8020d1 <sget+0x27>
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	eb 5c                	jmp    80212d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e4:	39 d0                	cmp    %edx,%eax
  8020e6:	7d 02                	jge    8020ea <sget+0x40>
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	83 ec 0c             	sub    $0xc,%esp
  8020ed:	50                   	push   %eax
  8020ee:	e8 0b fc ff ff       	call   801cfe <malloc>
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8020f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020fd:	75 07                	jne    802106 <sget+0x5c>
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	eb 27                	jmp    80212d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	ff 75 e8             	pushl  -0x18(%ebp)
  80210c:	ff 75 0c             	pushl  0xc(%ebp)
  80210f:	ff 75 08             	pushl  0x8(%ebp)
  802112:	e8 e8 02 00 00       	call   8023ff <sys_getSharedObject>
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80211d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802121:	75 07                	jne    80212a <sget+0x80>
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	eb 03                	jmp    80212d <sget+0x83>
	return ptr;
  80212a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 b4 4f 80 00       	push   $0x804fb4
  80213d:	68 c2 00 00 00       	push   $0xc2
  802142:	68 a2 4f 80 00       	push   $0x804fa2
  802147:	e8 45 eb ff ff       	call   800c91 <_panic>

0080214c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	68 d8 4f 80 00       	push   $0x804fd8
  80215a:	68 d9 00 00 00       	push   $0xd9
  80215f:	68 a2 4f 80 00       	push   $0x804fa2
  802164:	e8 28 eb ff ff       	call   800c91 <_panic>

00802169 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 fe 4f 80 00       	push   $0x804ffe
  802177:	68 e5 00 00 00       	push   $0xe5
  80217c:	68 a2 4f 80 00       	push   $0x804fa2
  802181:	e8 0b eb ff ff       	call   800c91 <_panic>

00802186 <shrink>:

}
void shrink(uint32 newSize)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	68 fe 4f 80 00       	push   $0x804ffe
  802194:	68 ea 00 00 00       	push   $0xea
  802199:	68 a2 4f 80 00       	push   $0x804fa2
  80219e:	e8 ee ea ff ff       	call   800c91 <_panic>

008021a3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	68 fe 4f 80 00       	push   $0x804ffe
  8021b1:	68 ef 00 00 00       	push   $0xef
  8021b6:	68 a2 4f 80 00       	push   $0x804fa2
  8021bb:	e8 d1 ea ff ff       	call   800c91 <_panic>

008021c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	57                   	push   %edi
  8021c4:	56                   	push   %esi
  8021c5:	53                   	push   %ebx
  8021c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021db:	cd 30                	int    $0x30
  8021dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5f                   	pop    %edi
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	52                   	push   %edx
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	50                   	push   %eax
  802207:	6a 00                	push   $0x0
  802209:	e8 b2 ff ff ff       	call   8021c0 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_cgetc>:

int
sys_cgetc(void)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 02                	push   $0x2
  802223:	e8 98 ff ff ff       	call   8021c0 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 03                	push   $0x3
  80223c:	e8 7f ff ff ff       	call   8021c0 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	90                   	nop
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 04                	push   $0x4
  802256:	e8 65 ff ff ff       	call   8021c0 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	90                   	nop
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 08                	push   $0x8
  802274:	e8 47 ff ff ff       	call   8021c0 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802283:	8b 75 18             	mov    0x18(%ebp),%esi
  802286:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802289:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80228c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	51                   	push   %ecx
  802295:	52                   	push   %edx
  802296:	50                   	push   %eax
  802297:	6a 09                	push   $0x9
  802299:	e8 22 ff ff ff       	call   8021c0 <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
}
  8022a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    

008022a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	52                   	push   %edx
  8022b8:	50                   	push   %eax
  8022b9:	6a 0a                	push   $0xa
  8022bb:	e8 00 ff ff ff       	call   8021c0 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	ff 75 0c             	pushl  0xc(%ebp)
  8022d1:	ff 75 08             	pushl  0x8(%ebp)
  8022d4:	6a 0b                	push   $0xb
  8022d6:	e8 e5 fe ff ff       	call   8021c0 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 0c                	push   $0xc
  8022ef:	e8 cc fe ff ff       	call   8021c0 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 0d                	push   $0xd
  802308:	e8 b3 fe ff ff       	call   8021c0 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 0e                	push   $0xe
  802321:	e8 9a fe ff ff       	call   8021c0 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 0f                	push   $0xf
  80233a:	e8 81 fe ff ff       	call   8021c0 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	6a 10                	push   $0x10
  802354:	e8 67 fe ff ff       	call   8021c0 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 11                	push   $0x11
  80236d:	e8 4e fe ff ff       	call   8021c0 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	90                   	nop
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_cputc>:

void
sys_cputc(const char c)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802384:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	50                   	push   %eax
  802391:	6a 01                	push   $0x1
  802393:	e8 28 fe ff ff       	call   8021c0 <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
}
  80239b:	90                   	nop
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 14                	push   $0x14
  8023ad:	e8 0e fe ff ff       	call   8021c0 <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	90                   	nop
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	6a 00                	push   $0x0
  8023d0:	51                   	push   %ecx
  8023d1:	52                   	push   %edx
  8023d2:	ff 75 0c             	pushl  0xc(%ebp)
  8023d5:	50                   	push   %eax
  8023d6:	6a 15                	push   $0x15
  8023d8:	e8 e3 fd ff ff       	call   8021c0 <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 16                	push   $0x16
  8023f5:	e8 c6 fd ff ff       	call   8021c0 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802402:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802405:	8b 55 0c             	mov    0xc(%ebp),%edx
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	51                   	push   %ecx
  802410:	52                   	push   %edx
  802411:	50                   	push   %eax
  802412:	6a 17                	push   $0x17
  802414:	e8 a7 fd ff ff       	call   8021c0 <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802421:	8b 55 0c             	mov    0xc(%ebp),%edx
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	52                   	push   %edx
  80242e:	50                   	push   %eax
  80242f:	6a 18                	push   $0x18
  802431:	e8 8a fd ff ff       	call   8021c0 <syscall>
  802436:	83 c4 18             	add    $0x18,%esp
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	6a 00                	push   $0x0
  802443:	ff 75 14             	pushl  0x14(%ebp)
  802446:	ff 75 10             	pushl  0x10(%ebp)
  802449:	ff 75 0c             	pushl  0xc(%ebp)
  80244c:	50                   	push   %eax
  80244d:	6a 19                	push   $0x19
  80244f:	e8 6c fd ff ff       	call   8021c0 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	50                   	push   %eax
  802468:	6a 1a                	push   $0x1a
  80246a:	e8 51 fd ff ff       	call   8021c0 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	50                   	push   %eax
  802484:	6a 1b                	push   $0x1b
  802486:	e8 35 fd ff ff       	call   8021c0 <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 05                	push   $0x5
  80249f:	e8 1c fd ff ff       	call   8021c0 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 06                	push   $0x6
  8024b8:	e8 03 fd ff ff       	call   8021c0 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 07                	push   $0x7
  8024d1:	e8 ea fc ff ff       	call   8021c0 <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_exit_env>:


void sys_exit_env(void)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 1c                	push   $0x1c
  8024ea:	e8 d1 fc ff ff       	call   8021c0 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	90                   	nop
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024fe:	8d 50 04             	lea    0x4(%eax),%edx
  802501:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	52                   	push   %edx
  80250b:	50                   	push   %eax
  80250c:	6a 1d                	push   $0x1d
  80250e:	e8 ad fc ff ff       	call   8021c0 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
	return result;
  802516:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80251c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251f:	89 01                	mov    %eax,(%ecx)
  802521:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	c9                   	leave  
  802528:	c2 04 00             	ret    $0x4

0080252b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	ff 75 10             	pushl  0x10(%ebp)
  802535:	ff 75 0c             	pushl  0xc(%ebp)
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	6a 13                	push   $0x13
  80253d:	e8 7e fc ff ff       	call   8021c0 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return ;
  802545:	90                   	nop
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_rcr2>:
uint32 sys_rcr2()
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 1e                	push   $0x1e
  802557:	e8 64 fc ff ff       	call   8021c0 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80256d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	50                   	push   %eax
  80257a:	6a 1f                	push   $0x1f
  80257c:	e8 3f fc ff ff       	call   8021c0 <syscall>
  802581:	83 c4 18             	add    $0x18,%esp
	return ;
  802584:	90                   	nop
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <rsttst>:
void rsttst()
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 21                	push   $0x21
  802596:	e8 25 fc ff ff       	call   8021c0 <syscall>
  80259b:	83 c4 18             	add    $0x18,%esp
	return ;
  80259e:	90                   	nop
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 04             	sub    $0x4,%esp
  8025a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8025aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025ad:	8b 55 18             	mov    0x18(%ebp),%edx
  8025b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025b4:	52                   	push   %edx
  8025b5:	50                   	push   %eax
  8025b6:	ff 75 10             	pushl  0x10(%ebp)
  8025b9:	ff 75 0c             	pushl  0xc(%ebp)
  8025bc:	ff 75 08             	pushl  0x8(%ebp)
  8025bf:	6a 20                	push   $0x20
  8025c1:	e8 fa fb ff ff       	call   8021c0 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c9:	90                   	nop
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <chktst>:
void chktst(uint32 n)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	ff 75 08             	pushl  0x8(%ebp)
  8025da:	6a 22                	push   $0x22
  8025dc:	e8 df fb ff ff       	call   8021c0 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e4:	90                   	nop
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <inctst>:

void inctst()
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 23                	push   $0x23
  8025f6:	e8 c5 fb ff ff       	call   8021c0 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fe:	90                   	nop
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <gettst>:
uint32 gettst()
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 24                	push   $0x24
  802610:	e8 ab fb ff ff       	call   8021c0 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 25                	push   $0x25
  80262c:	e8 8f fb ff ff       	call   8021c0 <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
  802634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802637:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80263b:	75 07                	jne    802644 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80263d:	b8 01 00 00 00       	mov    $0x1,%eax
  802642:	eb 05                	jmp    802649 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 25                	push   $0x25
  80265d:	e8 5e fb ff ff       	call   8021c0 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
  802665:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802668:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80266c:	75 07                	jne    802675 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	eb 05                	jmp    80267a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 25                	push   $0x25
  80268e:	e8 2d fb ff ff       	call   8021c0 <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
  802696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802699:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80269d:	75 07                	jne    8026a6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80269f:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a4:	eb 05                	jmp    8026ab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 25                	push   $0x25
  8026bf:	e8 fc fa ff ff       	call   8021c0 <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
  8026c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026ce:	75 07                	jne    8026d7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d5:	eb 05                	jmp    8026dc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	6a 26                	push   $0x26
  8026ee:	e8 cd fa ff ff       	call   8021c0 <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f6:	90                   	nop
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802700:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802703:	8b 55 0c             	mov    0xc(%ebp),%edx
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	6a 00                	push   $0x0
  80270b:	53                   	push   %ebx
  80270c:	51                   	push   %ecx
  80270d:	52                   	push   %edx
  80270e:	50                   	push   %eax
  80270f:	6a 27                	push   $0x27
  802711:	e8 aa fa ff ff       	call   8021c0 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
}
  802719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802721:	8b 55 0c             	mov    0xc(%ebp),%edx
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	52                   	push   %edx
  80272e:	50                   	push   %eax
  80272f:	6a 28                	push   $0x28
  802731:	e8 8a fa ff ff       	call   8021c0 <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
}
  802739:	c9                   	leave  
  80273a:	c3                   	ret    

0080273b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80273e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802741:	8b 55 0c             	mov    0xc(%ebp),%edx
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	6a 00                	push   $0x0
  802749:	51                   	push   %ecx
  80274a:	ff 75 10             	pushl  0x10(%ebp)
  80274d:	52                   	push   %edx
  80274e:	50                   	push   %eax
  80274f:	6a 29                	push   $0x29
  802751:	e8 6a fa ff ff       	call   8021c0 <syscall>
  802756:	83 c4 18             	add    $0x18,%esp
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	ff 75 10             	pushl  0x10(%ebp)
  802765:	ff 75 0c             	pushl  0xc(%ebp)
  802768:	ff 75 08             	pushl  0x8(%ebp)
  80276b:	6a 12                	push   $0x12
  80276d:	e8 4e fa ff ff       	call   8021c0 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
	return ;
  802775:	90                   	nop
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80277b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	52                   	push   %edx
  802788:	50                   	push   %eax
  802789:	6a 2a                	push   $0x2a
  80278b:	e8 30 fa ff ff       	call   8021c0 <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
	return;
  802793:	90                   	nop
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	50                   	push   %eax
  8027a5:	6a 2b                	push   $0x2b
  8027a7:	e8 14 fa ff ff       	call   8021c0 <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	ff 75 0c             	pushl  0xc(%ebp)
  8027bd:	ff 75 08             	pushl  0x8(%ebp)
  8027c0:	6a 2c                	push   $0x2c
  8027c2:	e8 f9 f9 ff ff       	call   8021c0 <syscall>
  8027c7:	83 c4 18             	add    $0x18,%esp
	return;
  8027ca:	90                   	nop
}
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	ff 75 0c             	pushl  0xc(%ebp)
  8027d9:	ff 75 08             	pushl  0x8(%ebp)
  8027dc:	6a 2d                	push   $0x2d
  8027de:	e8 dd f9 ff ff       	call   8021c0 <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
	return;
  8027e6:	90                   	nop
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	83 e8 04             	sub    $0x4,%eax
  8027f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8027f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 e8 04             	sub    $0x4,%eax
  80280e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	83 e0 01             	and    $0x1,%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	0f 94 c0             	sete   %al
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802826:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80282d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802830:	83 f8 02             	cmp    $0x2,%eax
  802833:	74 2b                	je     802860 <alloc_block+0x40>
  802835:	83 f8 02             	cmp    $0x2,%eax
  802838:	7f 07                	jg     802841 <alloc_block+0x21>
  80283a:	83 f8 01             	cmp    $0x1,%eax
  80283d:	74 0e                	je     80284d <alloc_block+0x2d>
  80283f:	eb 58                	jmp    802899 <alloc_block+0x79>
  802841:	83 f8 03             	cmp    $0x3,%eax
  802844:	74 2d                	je     802873 <alloc_block+0x53>
  802846:	83 f8 04             	cmp    $0x4,%eax
  802849:	74 3b                	je     802886 <alloc_block+0x66>
  80284b:	eb 4c                	jmp    802899 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80284d:	83 ec 0c             	sub    $0xc,%esp
  802850:	ff 75 08             	pushl  0x8(%ebp)
  802853:	e8 11 03 00 00       	call   802b69 <alloc_block_FF>
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80285e:	eb 4a                	jmp    8028aa <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802860:	83 ec 0c             	sub    $0xc,%esp
  802863:	ff 75 08             	pushl  0x8(%ebp)
  802866:	e8 fa 19 00 00       	call   804265 <alloc_block_NF>
  80286b:	83 c4 10             	add    $0x10,%esp
  80286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802871:	eb 37                	jmp    8028aa <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802873:	83 ec 0c             	sub    $0xc,%esp
  802876:	ff 75 08             	pushl  0x8(%ebp)
  802879:	e8 a7 07 00 00       	call   803025 <alloc_block_BF>
  80287e:	83 c4 10             	add    $0x10,%esp
  802881:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802884:	eb 24                	jmp    8028aa <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	ff 75 08             	pushl  0x8(%ebp)
  80288c:	e8 b7 19 00 00       	call   804248 <alloc_block_WF>
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802897:	eb 11                	jmp    8028aa <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	68 10 50 80 00       	push   $0x805010
  8028a1:	e8 a8 e6 ff ff       	call   800f4e <cprintf>
  8028a6:	83 c4 10             	add    $0x10,%esp
		break;
  8028a9:	90                   	nop
	}
	return va;
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    

008028af <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	53                   	push   %ebx
  8028b3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8028b6:	83 ec 0c             	sub    $0xc,%esp
  8028b9:	68 30 50 80 00       	push   $0x805030
  8028be:	e8 8b e6 ff ff       	call   800f4e <cprintf>
  8028c3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8028c6:	83 ec 0c             	sub    $0xc,%esp
  8028c9:	68 5b 50 80 00       	push   $0x80505b
  8028ce:	e8 7b e6 ff ff       	call   800f4e <cprintf>
  8028d3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028dc:	eb 37                	jmp    802915 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8028e4:	e8 19 ff ff ff       	call   802802 <is_free_block>
  8028e9:	83 c4 10             	add    $0x10,%esp
  8028ec:	0f be d8             	movsbl %al,%ebx
  8028ef:	83 ec 0c             	sub    $0xc,%esp
  8028f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f5:	e8 ef fe ff ff       	call   8027e9 <get_block_size>
  8028fa:	83 c4 10             	add    $0x10,%esp
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	53                   	push   %ebx
  802901:	50                   	push   %eax
  802902:	68 73 50 80 00       	push   $0x805073
  802907:	e8 42 e6 ff ff       	call   800f4e <cprintf>
  80290c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80290f:	8b 45 10             	mov    0x10(%ebp),%eax
  802912:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802919:	74 07                	je     802922 <print_blocks_list+0x73>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	eb 05                	jmp    802927 <print_blocks_list+0x78>
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	89 45 10             	mov    %eax,0x10(%ebp)
  80292a:	8b 45 10             	mov    0x10(%ebp),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	75 ad                	jne    8028de <print_blocks_list+0x2f>
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	75 a7                	jne    8028de <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	68 30 50 80 00       	push   $0x805030
  80293f:	e8 0a e6 ff ff       	call   800f4e <cprintf>
  802944:	83 c4 10             	add    $0x10,%esp

}
  802947:	90                   	nop
  802948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802953:	8b 45 0c             	mov    0xc(%ebp),%eax
  802956:	83 e0 01             	and    $0x1,%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 03                	je     802960 <initialize_dynamic_allocator+0x13>
  80295d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802960:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802964:	0f 84 c7 01 00 00    	je     802b31 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80296a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802971:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802974:	8b 55 08             	mov    0x8(%ebp),%edx
  802977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297a:	01 d0                	add    %edx,%eax
  80297c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802981:	0f 87 ad 01 00 00    	ja     802b34 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	0f 89 a5 01 00 00    	jns    802b37 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	8b 45 0c             	mov    0xc(%ebp),%eax
  802998:	01 d0                	add    %edx,%eax
  80299a:	83 e8 04             	sub    $0x4,%eax
  80299d:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8029a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8029a9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b1:	e9 87 00 00 00       	jmp    802a3d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8029b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ba:	75 14                	jne    8029d0 <initialize_dynamic_allocator+0x83>
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 8b 50 80 00       	push   $0x80508b
  8029c4:	6a 79                	push   $0x79
  8029c6:	68 a9 50 80 00       	push   $0x8050a9
  8029cb:	e8 c1 e2 ff ff       	call   800c91 <_panic>
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 10                	je     8029e9 <initialize_dynamic_allocator+0x9c>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e1:	8b 52 04             	mov    0x4(%edx),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	eb 0b                	jmp    8029f4 <initialize_dynamic_allocator+0xa7>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	a3 30 60 80 00       	mov    %eax,0x806030
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0f                	je     802a0d <initialize_dynamic_allocator+0xc0>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 12                	mov    (%edx),%edx
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	eb 0a                	jmp    802a17 <initialize_dynamic_allocator+0xca>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 38 60 80 00       	mov    0x806038,%eax
  802a2f:	48                   	dec    %eax
  802a30:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a35:	a1 34 60 80 00       	mov    0x806034,%eax
  802a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a41:	74 07                	je     802a4a <initialize_dynamic_allocator+0xfd>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	eb 05                	jmp    802a4f <initialize_dynamic_allocator+0x102>
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	a3 34 60 80 00       	mov    %eax,0x806034
  802a54:	a1 34 60 80 00       	mov    0x806034,%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	0f 85 55 ff ff ff    	jne    8029b6 <initialize_dynamic_allocator+0x69>
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	0f 85 4b ff ff ff    	jne    8029b6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a7a:	a1 44 60 80 00       	mov    0x806044,%eax
  802a7f:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802a84:	a1 40 60 80 00       	mov    0x806040,%eax
  802a89:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	83 c0 08             	add    $0x8,%eax
  802a95:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	83 c0 04             	add    $0x4,%eax
  802a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa1:	83 ea 08             	sub    $0x8,%edx
  802aa4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	83 e8 08             	sub    $0x8,%eax
  802ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab4:	83 ea 08             	sub    $0x8,%edx
  802ab7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802acc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ad0:	75 17                	jne    802ae9 <initialize_dynamic_allocator+0x19c>
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	68 c4 50 80 00       	push   $0x8050c4
  802ada:	68 90 00 00 00       	push   $0x90
  802adf:	68 a9 50 80 00       	push   $0x8050a9
  802ae4:	e8 a8 e1 ff ff       	call   800c91 <_panic>
  802ae9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0d                	je     802b0a <initialize_dynamic_allocator+0x1bd>
  802afd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b05:	89 50 04             	mov    %edx,0x4(%eax)
  802b08:	eb 08                	jmp    802b12 <initialize_dynamic_allocator+0x1c5>
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	a3 30 60 80 00       	mov    %eax,0x806030
  802b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b15:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b24:	a1 38 60 80 00       	mov    0x806038,%eax
  802b29:	40                   	inc    %eax
  802b2a:	a3 38 60 80 00       	mov    %eax,0x806038
  802b2f:	eb 07                	jmp    802b38 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b31:	90                   	nop
  802b32:	eb 04                	jmp    802b38 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b34:	90                   	nop
  802b35:	eb 01                	jmp    802b38 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b37:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b38:	c9                   	leave  
  802b39:	c3                   	ret    

00802b3a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  802b40:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	83 e8 04             	sub    $0x4,%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	83 e0 fe             	and    $0xfffffffe,%eax
  802b59:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	01 c2                	add    %eax,%edx
  802b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b64:	89 02                	mov    %eax,(%edx)
}
  802b66:	90                   	nop
  802b67:	5d                   	pop    %ebp
  802b68:	c3                   	ret    

00802b69 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
  802b6c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	83 e0 01             	and    $0x1,%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 03                	je     802b7c <alloc_block_FF+0x13>
  802b79:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b7c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b80:	77 07                	ja     802b89 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b82:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b89:	a1 24 60 80 00       	mov    0x806024,%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	75 73                	jne    802c05 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	83 c0 10             	add    $0x10,%eax
  802b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b9b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ba2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	01 d0                	add    %edx,%eax
  802baa:	48                   	dec    %eax
  802bab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb6:	f7 75 ec             	divl   -0x14(%ebp)
  802bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbc:	29 d0                	sub    %edx,%eax
  802bbe:	c1 e8 0c             	shr    $0xc,%eax
  802bc1:	83 ec 0c             	sub    $0xc,%esp
  802bc4:	50                   	push   %eax
  802bc5:	e8 1e f1 ff ff       	call   801ce8 <sbrk>
  802bca:	83 c4 10             	add    $0x10,%esp
  802bcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	6a 00                	push   $0x0
  802bd5:	e8 0e f1 ff ff       	call   801ce8 <sbrk>
  802bda:	83 c4 10             	add    $0x10,%esp
  802bdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802be6:	83 ec 08             	sub    $0x8,%esp
  802be9:	50                   	push   %eax
  802bea:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bed:	e8 5b fd ff ff       	call   80294d <initialize_dynamic_allocator>
  802bf2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802bf5:	83 ec 0c             	sub    $0xc,%esp
  802bf8:	68 e7 50 80 00       	push   $0x8050e7
  802bfd:	e8 4c e3 ff ff       	call   800f4e <cprintf>
  802c02:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c09:	75 0a                	jne    802c15 <alloc_block_FF+0xac>
	        return NULL;
  802c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c10:	e9 0e 04 00 00       	jmp    803023 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c1c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c24:	e9 f3 02 00 00       	jmp    802f1c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c2f:	83 ec 0c             	sub    $0xc,%esp
  802c32:	ff 75 bc             	pushl  -0x44(%ebp)
  802c35:	e8 af fb ff ff       	call   8027e9 <get_block_size>
  802c3a:	83 c4 10             	add    $0x10,%esp
  802c3d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	83 c0 08             	add    $0x8,%eax
  802c46:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c49:	0f 87 c5 02 00 00    	ja     802f14 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	83 c0 18             	add    $0x18,%eax
  802c55:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c58:	0f 87 19 02 00 00    	ja     802e77 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c5e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c61:	2b 45 08             	sub    0x8(%ebp),%eax
  802c64:	83 e8 08             	sub    $0x8,%eax
  802c67:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8d 50 08             	lea    0x8(%eax),%edx
  802c70:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c73:	01 d0                	add    %edx,%eax
  802c75:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	83 c0 08             	add    $0x8,%eax
  802c7e:	83 ec 04             	sub    $0x4,%esp
  802c81:	6a 01                	push   $0x1
  802c83:	50                   	push   %eax
  802c84:	ff 75 bc             	pushl  -0x44(%ebp)
  802c87:	e8 ae fe ff ff       	call   802b3a <set_block_data>
  802c8c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	75 68                	jne    802d01 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c99:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_FF+0x14d>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 c4 50 80 00       	push   $0x8050c4
  802ca7:	68 d7 00 00 00       	push   $0xd7
  802cac:	68 a9 50 80 00       	push   $0x8050a9
  802cb1:	e8 db df ff ff       	call   800c91 <_panic>
  802cb6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802cbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0d                	je     802cd7 <alloc_block_FF+0x16e>
  802cca:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ccf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	eb 08                	jmp    802cdf <alloc_block_FF+0x176>
  802cd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cda:	a3 30 60 80 00       	mov    %eax,0x806030
  802cdf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ce7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 38 60 80 00       	mov    0x806038,%eax
  802cf6:	40                   	inc    %eax
  802cf7:	a3 38 60 80 00       	mov    %eax,0x806038
  802cfc:	e9 dc 00 00 00       	jmp    802ddd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	75 65                	jne    802d6f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d0a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d0e:	75 17                	jne    802d27 <alloc_block_FF+0x1be>
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	68 f8 50 80 00       	push   $0x8050f8
  802d18:	68 db 00 00 00       	push   $0xdb
  802d1d:	68 a9 50 80 00       	push   $0x8050a9
  802d22:	e8 6a df ff ff       	call   800c91 <_panic>
  802d27:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d2d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d30:	89 50 04             	mov    %edx,0x4(%eax)
  802d33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	74 0c                	je     802d49 <alloc_block_FF+0x1e0>
  802d3d:	a1 30 60 80 00       	mov    0x806030,%eax
  802d42:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	eb 08                	jmp    802d51 <alloc_block_FF+0x1e8>
  802d49:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d54:	a3 30 60 80 00       	mov    %eax,0x806030
  802d59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d62:	a1 38 60 80 00       	mov    0x806038,%eax
  802d67:	40                   	inc    %eax
  802d68:	a3 38 60 80 00       	mov    %eax,0x806038
  802d6d:	eb 6e                	jmp    802ddd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d73:	74 06                	je     802d7b <alloc_block_FF+0x212>
  802d75:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d79:	75 17                	jne    802d92 <alloc_block_FF+0x229>
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	68 1c 51 80 00       	push   $0x80511c
  802d83:	68 df 00 00 00       	push   $0xdf
  802d88:	68 a9 50 80 00       	push   $0x8050a9
  802d8d:	e8 ff de ff ff       	call   800c91 <_panic>
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 10                	mov    (%eax),%edx
  802d97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0b                	je     802db0 <alloc_block_FF+0x247>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802dad:	89 50 04             	mov    %edx,0x4(%eax)
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	75 08                	jne    802dd2 <alloc_block_FF+0x269>
  802dca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dcd:	a3 30 60 80 00       	mov    %eax,0x806030
  802dd2:	a1 38 60 80 00       	mov    0x806038,%eax
  802dd7:	40                   	inc    %eax
  802dd8:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de1:	75 17                	jne    802dfa <alloc_block_FF+0x291>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 8b 50 80 00       	push   $0x80508b
  802deb:	68 e1 00 00 00       	push   $0xe1
  802df0:	68 a9 50 80 00       	push   $0x8050a9
  802df5:	e8 97 de ff ff       	call   800c91 <_panic>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 10                	je     802e13 <alloc_block_FF+0x2aa>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0b:	8b 52 04             	mov    0x4(%edx),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	eb 0b                	jmp    802e1e <alloc_block_FF+0x2b5>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	a3 30 60 80 00       	mov    %eax,0x806030
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0f                	je     802e37 <alloc_block_FF+0x2ce>
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e31:	8b 12                	mov    (%edx),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	eb 0a                	jmp    802e41 <alloc_block_FF+0x2d8>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e54:	a1 38 60 80 00       	mov    0x806038,%eax
  802e59:	48                   	dec    %eax
  802e5a:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802e5f:	83 ec 04             	sub    $0x4,%esp
  802e62:	6a 00                	push   $0x0
  802e64:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e67:	ff 75 b0             	pushl  -0x50(%ebp)
  802e6a:	e8 cb fc ff ff       	call   802b3a <set_block_data>
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	e9 95 00 00 00       	jmp    802f0c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	6a 01                	push   $0x1
  802e7c:	ff 75 b8             	pushl  -0x48(%ebp)
  802e7f:	ff 75 bc             	pushl  -0x44(%ebp)
  802e82:	e8 b3 fc ff ff       	call   802b3a <set_block_data>
  802e87:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8e:	75 17                	jne    802ea7 <alloc_block_FF+0x33e>
  802e90:	83 ec 04             	sub    $0x4,%esp
  802e93:	68 8b 50 80 00       	push   $0x80508b
  802e98:	68 e8 00 00 00       	push   $0xe8
  802e9d:	68 a9 50 80 00       	push   $0x8050a9
  802ea2:	e8 ea dd ff ff       	call   800c91 <_panic>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 10                	je     802ec0 <alloc_block_FF+0x357>
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb8:	8b 52 04             	mov    0x4(%edx),%edx
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	eb 0b                	jmp    802ecb <alloc_block_FF+0x362>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	a3 30 60 80 00       	mov    %eax,0x806030
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0f                	je     802ee4 <alloc_block_FF+0x37b>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ede:	8b 12                	mov    (%edx),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	eb 0a                	jmp    802eee <alloc_block_FF+0x385>
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f01:	a1 38 60 80 00       	mov    0x806038,%eax
  802f06:	48                   	dec    %eax
  802f07:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802f0c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f0f:	e9 0f 01 00 00       	jmp    803023 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f14:	a1 34 60 80 00       	mov    0x806034,%eax
  802f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f20:	74 07                	je     802f29 <alloc_block_FF+0x3c0>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	eb 05                	jmp    802f2e <alloc_block_FF+0x3c5>
  802f29:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2e:	a3 34 60 80 00       	mov    %eax,0x806034
  802f33:	a1 34 60 80 00       	mov    0x806034,%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	0f 85 e9 fc ff ff    	jne    802c29 <alloc_block_FF+0xc0>
  802f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f44:	0f 85 df fc ff ff    	jne    802c29 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	83 c0 08             	add    $0x8,%eax
  802f50:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f53:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f60:	01 d0                	add    %edx,%eax
  802f62:	48                   	dec    %eax
  802f63:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f69:	ba 00 00 00 00       	mov    $0x0,%edx
  802f6e:	f7 75 d8             	divl   -0x28(%ebp)
  802f71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f74:	29 d0                	sub    %edx,%eax
  802f76:	c1 e8 0c             	shr    $0xc,%eax
  802f79:	83 ec 0c             	sub    $0xc,%esp
  802f7c:	50                   	push   %eax
  802f7d:	e8 66 ed ff ff       	call   801ce8 <sbrk>
  802f82:	83 c4 10             	add    $0x10,%esp
  802f85:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f88:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f8c:	75 0a                	jne    802f98 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f93:	e9 8b 00 00 00       	jmp    803023 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f98:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fa2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa5:	01 d0                	add    %edx,%eax
  802fa7:	48                   	dec    %eax
  802fa8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802fab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fae:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb3:	f7 75 cc             	divl   -0x34(%ebp)
  802fb6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fb9:	29 d0                	sub    %edx,%eax
  802fbb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fc1:	01 d0                	add    %edx,%eax
  802fc3:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  802fc8:	a1 40 60 80 00       	mov    0x806040,%eax
  802fcd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fd3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fdd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fe0:	01 d0                	add    %edx,%eax
  802fe2:	48                   	dec    %eax
  802fe3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fe6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fe9:	ba 00 00 00 00       	mov    $0x0,%edx
  802fee:	f7 75 c4             	divl   -0x3c(%ebp)
  802ff1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ff4:	29 d0                	sub    %edx,%eax
  802ff6:	83 ec 04             	sub    $0x4,%esp
  802ff9:	6a 01                	push   $0x1
  802ffb:	50                   	push   %eax
  802ffc:	ff 75 d0             	pushl  -0x30(%ebp)
  802fff:	e8 36 fb ff ff       	call   802b3a <set_block_data>
  803004:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	ff 75 d0             	pushl  -0x30(%ebp)
  80300d:	e8 1b 0a 00 00       	call   803a2d <free_block>
  803012:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803015:	83 ec 0c             	sub    $0xc,%esp
  803018:	ff 75 08             	pushl  0x8(%ebp)
  80301b:	e8 49 fb ff ff       	call   802b69 <alloc_block_FF>
  803020:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803023:	c9                   	leave  
  803024:	c3                   	ret    

00803025 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
  803028:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	83 e0 01             	and    $0x1,%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	74 03                	je     803038 <alloc_block_BF+0x13>
  803035:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803038:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80303c:	77 07                	ja     803045 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80303e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803045:	a1 24 60 80 00       	mov    0x806024,%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	75 73                	jne    8030c1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	83 c0 10             	add    $0x10,%eax
  803054:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803057:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80305e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	01 d0                	add    %edx,%eax
  803066:	48                   	dec    %eax
  803067:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80306a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306d:	ba 00 00 00 00       	mov    $0x0,%edx
  803072:	f7 75 e0             	divl   -0x20(%ebp)
  803075:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803078:	29 d0                	sub    %edx,%eax
  80307a:	c1 e8 0c             	shr    $0xc,%eax
  80307d:	83 ec 0c             	sub    $0xc,%esp
  803080:	50                   	push   %eax
  803081:	e8 62 ec ff ff       	call   801ce8 <sbrk>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80308c:	83 ec 0c             	sub    $0xc,%esp
  80308f:	6a 00                	push   $0x0
  803091:	e8 52 ec ff ff       	call   801ce8 <sbrk>
  803096:	83 c4 10             	add    $0x10,%esp
  803099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80309c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80309f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8030a2:	83 ec 08             	sub    $0x8,%esp
  8030a5:	50                   	push   %eax
  8030a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8030a9:	e8 9f f8 ff ff       	call   80294d <initialize_dynamic_allocator>
  8030ae:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030b1:	83 ec 0c             	sub    $0xc,%esp
  8030b4:	68 e7 50 80 00       	push   $0x8050e7
  8030b9:	e8 90 de ff ff       	call   800f4e <cprintf>
  8030be:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8030c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8030c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030cf:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8030dd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e5:	e9 1d 01 00 00       	jmp    803207 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8030f0:	83 ec 0c             	sub    $0xc,%esp
  8030f3:	ff 75 a8             	pushl  -0x58(%ebp)
  8030f6:	e8 ee f6 ff ff       	call   8027e9 <get_block_size>
  8030fb:	83 c4 10             	add    $0x10,%esp
  8030fe:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	83 c0 08             	add    $0x8,%eax
  803107:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80310a:	0f 87 ef 00 00 00    	ja     8031ff <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	83 c0 18             	add    $0x18,%eax
  803116:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803119:	77 1d                	ja     803138 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80311b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803121:	0f 86 d8 00 00 00    	jbe    8031ff <alloc_block_BF+0x1da>
				{
					best_va = va;
  803127:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80312a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80312d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803130:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803133:	e9 c7 00 00 00       	jmp    8031ff <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	83 c0 08             	add    $0x8,%eax
  80313e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803141:	0f 85 9d 00 00 00    	jne    8031e4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	6a 01                	push   $0x1
  80314c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80314f:	ff 75 a8             	pushl  -0x58(%ebp)
  803152:	e8 e3 f9 ff ff       	call   802b3a <set_block_data>
  803157:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80315a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315e:	75 17                	jne    803177 <alloc_block_BF+0x152>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 8b 50 80 00       	push   $0x80508b
  803168:	68 2c 01 00 00       	push   $0x12c
  80316d:	68 a9 50 80 00       	push   $0x8050a9
  803172:	e8 1a db ff ff       	call   800c91 <_panic>
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 10                	je     803190 <alloc_block_BF+0x16b>
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803188:	8b 52 04             	mov    0x4(%edx),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	eb 0b                	jmp    80319b <alloc_block_BF+0x176>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 40 04             	mov    0x4(%eax),%eax
  803196:	a3 30 60 80 00       	mov    %eax,0x806030
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 04             	mov    0x4(%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0f                	je     8031b4 <alloc_block_BF+0x18f>
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 40 04             	mov    0x4(%eax),%eax
  8031ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ae:	8b 12                	mov    (%edx),%edx
  8031b0:	89 10                	mov    %edx,(%eax)
  8031b2:	eb 0a                	jmp    8031be <alloc_block_BF+0x199>
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d1:	a1 38 60 80 00       	mov    0x806038,%eax
  8031d6:	48                   	dec    %eax
  8031d7:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  8031dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031df:	e9 24 04 00 00       	jmp    803608 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8031e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031ea:	76 13                	jbe    8031ff <alloc_block_BF+0x1da>
					{
						internal = 1;
  8031ec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8031f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8031f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8031ff:	a1 34 60 80 00       	mov    0x806034,%eax
  803204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320b:	74 07                	je     803214 <alloc_block_BF+0x1ef>
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	eb 05                	jmp    803219 <alloc_block_BF+0x1f4>
  803214:	b8 00 00 00 00       	mov    $0x0,%eax
  803219:	a3 34 60 80 00       	mov    %eax,0x806034
  80321e:	a1 34 60 80 00       	mov    0x806034,%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	0f 85 bf fe ff ff    	jne    8030ea <alloc_block_BF+0xc5>
  80322b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322f:	0f 85 b5 fe ff ff    	jne    8030ea <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803239:	0f 84 26 02 00 00    	je     803465 <alloc_block_BF+0x440>
  80323f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803243:	0f 85 1c 02 00 00    	jne    803465 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324c:	2b 45 08             	sub    0x8(%ebp),%eax
  80324f:	83 e8 08             	sub    $0x8,%eax
  803252:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8d 50 08             	lea    0x8(%eax),%edx
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	01 d0                	add    %edx,%eax
  803260:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	83 c0 08             	add    $0x8,%eax
  803269:	83 ec 04             	sub    $0x4,%esp
  80326c:	6a 01                	push   $0x1
  80326e:	50                   	push   %eax
  80326f:	ff 75 f0             	pushl  -0x10(%ebp)
  803272:	e8 c3 f8 ff ff       	call   802b3a <set_block_data>
  803277:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	75 68                	jne    8032ec <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803284:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803288:	75 17                	jne    8032a1 <alloc_block_BF+0x27c>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 c4 50 80 00       	push   $0x8050c4
  803292:	68 45 01 00 00       	push   $0x145
  803297:	68 a9 50 80 00       	push   $0x8050a9
  80329c:	e8 f0 d9 ff ff       	call   800c91 <_panic>
  8032a1:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8032a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032aa:	89 10                	mov    %edx,(%eax)
  8032ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 0d                	je     8032c2 <alloc_block_BF+0x29d>
  8032b5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8032ba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	eb 08                	jmp    8032ca <alloc_block_BF+0x2a5>
  8032c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c5:	a3 30 60 80 00       	mov    %eax,0x806030
  8032ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032cd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dc:	a1 38 60 80 00       	mov    0x806038,%eax
  8032e1:	40                   	inc    %eax
  8032e2:	a3 38 60 80 00       	mov    %eax,0x806038
  8032e7:	e9 dc 00 00 00       	jmp    8033c8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	75 65                	jne    80335a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032f9:	75 17                	jne    803312 <alloc_block_BF+0x2ed>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 f8 50 80 00       	push   $0x8050f8
  803303:	68 4a 01 00 00       	push   $0x14a
  803308:	68 a9 50 80 00       	push   $0x8050a9
  80330d:	e8 7f d9 ff ff       	call   800c91 <_panic>
  803312:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803318:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	74 0c                	je     803334 <alloc_block_BF+0x30f>
  803328:	a1 30 60 80 00       	mov    0x806030,%eax
  80332d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803330:	89 10                	mov    %edx,(%eax)
  803332:	eb 08                	jmp    80333c <alloc_block_BF+0x317>
  803334:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803337:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80333c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333f:	a3 30 60 80 00       	mov    %eax,0x806030
  803344:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803347:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334d:	a1 38 60 80 00       	mov    0x806038,%eax
  803352:	40                   	inc    %eax
  803353:	a3 38 60 80 00       	mov    %eax,0x806038
  803358:	eb 6e                	jmp    8033c8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80335a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80335e:	74 06                	je     803366 <alloc_block_BF+0x341>
  803360:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803364:	75 17                	jne    80337d <alloc_block_BF+0x358>
  803366:	83 ec 04             	sub    $0x4,%esp
  803369:	68 1c 51 80 00       	push   $0x80511c
  80336e:	68 4f 01 00 00       	push   $0x14f
  803373:	68 a9 50 80 00       	push   $0x8050a9
  803378:	e8 14 d9 ff ff       	call   800c91 <_panic>
  80337d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803380:	8b 10                	mov    (%eax),%edx
  803382:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803385:	89 10                	mov    %edx,(%eax)
  803387:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	74 0b                	je     80339b <alloc_block_BF+0x376>
  803390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803393:	8b 00                	mov    (%eax),%eax
  803395:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803398:	89 50 04             	mov    %edx,0x4(%eax)
  80339b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	75 08                	jne    8033bd <alloc_block_BF+0x398>
  8033b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033b8:	a3 30 60 80 00       	mov    %eax,0x806030
  8033bd:	a1 38 60 80 00       	mov    0x806038,%eax
  8033c2:	40                   	inc    %eax
  8033c3:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8033c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033cc:	75 17                	jne    8033e5 <alloc_block_BF+0x3c0>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 8b 50 80 00       	push   $0x80508b
  8033d6:	68 51 01 00 00       	push   $0x151
  8033db:	68 a9 50 80 00       	push   $0x8050a9
  8033e0:	e8 ac d8 ff ff       	call   800c91 <_panic>
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 10                	je     8033fe <alloc_block_BF+0x3d9>
  8033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f6:	8b 52 04             	mov    0x4(%edx),%edx
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	eb 0b                	jmp    803409 <alloc_block_BF+0x3e4>
  8033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	a3 30 60 80 00       	mov    %eax,0x806030
  803409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	74 0f                	je     803422 <alloc_block_BF+0x3fd>
  803413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341c:	8b 12                	mov    (%edx),%edx
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	eb 0a                	jmp    80342c <alloc_block_BF+0x407>
  803422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343f:	a1 38 60 80 00       	mov    0x806038,%eax
  803444:	48                   	dec    %eax
  803445:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	6a 00                	push   $0x0
  80344f:	ff 75 d0             	pushl  -0x30(%ebp)
  803452:	ff 75 cc             	pushl  -0x34(%ebp)
  803455:	e8 e0 f6 ff ff       	call   802b3a <set_block_data>
  80345a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80345d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803460:	e9 a3 01 00 00       	jmp    803608 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803465:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803469:	0f 85 9d 00 00 00    	jne    80350c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80346f:	83 ec 04             	sub    $0x4,%esp
  803472:	6a 01                	push   $0x1
  803474:	ff 75 ec             	pushl  -0x14(%ebp)
  803477:	ff 75 f0             	pushl  -0x10(%ebp)
  80347a:	e8 bb f6 ff ff       	call   802b3a <set_block_data>
  80347f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803482:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803486:	75 17                	jne    80349f <alloc_block_BF+0x47a>
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	68 8b 50 80 00       	push   $0x80508b
  803490:	68 58 01 00 00       	push   $0x158
  803495:	68 a9 50 80 00       	push   $0x8050a9
  80349a:	e8 f2 d7 ff ff       	call   800c91 <_panic>
  80349f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	85 c0                	test   %eax,%eax
  8034a6:	74 10                	je     8034b8 <alloc_block_BF+0x493>
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b0:	8b 52 04             	mov    0x4(%edx),%edx
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	eb 0b                	jmp    8034c3 <alloc_block_BF+0x49e>
  8034b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bb:	8b 40 04             	mov    0x4(%eax),%eax
  8034be:	a3 30 60 80 00       	mov    %eax,0x806030
  8034c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c6:	8b 40 04             	mov    0x4(%eax),%eax
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	74 0f                	je     8034dc <alloc_block_BF+0x4b7>
  8034cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d0:	8b 40 04             	mov    0x4(%eax),%eax
  8034d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d6:	8b 12                	mov    (%edx),%edx
  8034d8:	89 10                	mov    %edx,(%eax)
  8034da:	eb 0a                	jmp    8034e6 <alloc_block_BF+0x4c1>
  8034dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f9:	a1 38 60 80 00       	mov    0x806038,%eax
  8034fe:	48                   	dec    %eax
  8034ff:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803507:	e9 fc 00 00 00       	jmp    803608 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	83 c0 08             	add    $0x8,%eax
  803512:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803515:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80351c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80351f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803522:	01 d0                	add    %edx,%eax
  803524:	48                   	dec    %eax
  803525:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803528:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80352b:	ba 00 00 00 00       	mov    $0x0,%edx
  803530:	f7 75 c4             	divl   -0x3c(%ebp)
  803533:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803536:	29 d0                	sub    %edx,%eax
  803538:	c1 e8 0c             	shr    $0xc,%eax
  80353b:	83 ec 0c             	sub    $0xc,%esp
  80353e:	50                   	push   %eax
  80353f:	e8 a4 e7 ff ff       	call   801ce8 <sbrk>
  803544:	83 c4 10             	add    $0x10,%esp
  803547:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80354a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80354e:	75 0a                	jne    80355a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803550:	b8 00 00 00 00       	mov    $0x0,%eax
  803555:	e9 ae 00 00 00       	jmp    803608 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80355a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803561:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803564:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803567:	01 d0                	add    %edx,%eax
  803569:	48                   	dec    %eax
  80356a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80356d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803570:	ba 00 00 00 00       	mov    $0x0,%edx
  803575:	f7 75 b8             	divl   -0x48(%ebp)
  803578:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80357b:	29 d0                	sub    %edx,%eax
  80357d:	8d 50 fc             	lea    -0x4(%eax),%edx
  803580:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803583:	01 d0                	add    %edx,%eax
  803585:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  80358a:	a1 40 60 80 00       	mov    0x806040,%eax
  80358f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803595:	83 ec 0c             	sub    $0xc,%esp
  803598:	68 50 51 80 00       	push   $0x805150
  80359d:	e8 ac d9 ff ff       	call   800f4e <cprintf>
  8035a2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8035a5:	83 ec 08             	sub    $0x8,%esp
  8035a8:	ff 75 bc             	pushl  -0x44(%ebp)
  8035ab:	68 55 51 80 00       	push   $0x805155
  8035b0:	e8 99 d9 ff ff       	call   800f4e <cprintf>
  8035b5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8035b8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8035bf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035c5:	01 d0                	add    %edx,%eax
  8035c7:	48                   	dec    %eax
  8035c8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8035cb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8035d3:	f7 75 b0             	divl   -0x50(%ebp)
  8035d6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035d9:	29 d0                	sub    %edx,%eax
  8035db:	83 ec 04             	sub    $0x4,%esp
  8035de:	6a 01                	push   $0x1
  8035e0:	50                   	push   %eax
  8035e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8035e4:	e8 51 f5 ff ff       	call   802b3a <set_block_data>
  8035e9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8035ec:	83 ec 0c             	sub    $0xc,%esp
  8035ef:	ff 75 bc             	pushl  -0x44(%ebp)
  8035f2:	e8 36 04 00 00       	call   803a2d <free_block>
  8035f7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8035fa:	83 ec 0c             	sub    $0xc,%esp
  8035fd:	ff 75 08             	pushl  0x8(%ebp)
  803600:	e8 20 fa ff ff       	call   803025 <alloc_block_BF>
  803605:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803608:	c9                   	leave  
  803609:	c3                   	ret    

0080360a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80360a:	55                   	push   %ebp
  80360b:	89 e5                	mov    %esp,%ebp
  80360d:	53                   	push   %ebx
  80360e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803611:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80361f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803623:	74 1e                	je     803643 <merging+0x39>
  803625:	ff 75 08             	pushl  0x8(%ebp)
  803628:	e8 bc f1 ff ff       	call   8027e9 <get_block_size>
  80362d:	83 c4 04             	add    $0x4,%esp
  803630:	89 c2                	mov    %eax,%edx
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	01 d0                	add    %edx,%eax
  803637:	3b 45 10             	cmp    0x10(%ebp),%eax
  80363a:	75 07                	jne    803643 <merging+0x39>
		prev_is_free = 1;
  80363c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803647:	74 1e                	je     803667 <merging+0x5d>
  803649:	ff 75 10             	pushl  0x10(%ebp)
  80364c:	e8 98 f1 ff ff       	call   8027e9 <get_block_size>
  803651:	83 c4 04             	add    $0x4,%esp
  803654:	89 c2                	mov    %eax,%edx
  803656:	8b 45 10             	mov    0x10(%ebp),%eax
  803659:	01 d0                	add    %edx,%eax
  80365b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80365e:	75 07                	jne    803667 <merging+0x5d>
		next_is_free = 1;
  803660:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803667:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366b:	0f 84 cc 00 00 00    	je     80373d <merging+0x133>
  803671:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803675:	0f 84 c2 00 00 00    	je     80373d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80367b:	ff 75 08             	pushl  0x8(%ebp)
  80367e:	e8 66 f1 ff ff       	call   8027e9 <get_block_size>
  803683:	83 c4 04             	add    $0x4,%esp
  803686:	89 c3                	mov    %eax,%ebx
  803688:	ff 75 10             	pushl  0x10(%ebp)
  80368b:	e8 59 f1 ff ff       	call   8027e9 <get_block_size>
  803690:	83 c4 04             	add    $0x4,%esp
  803693:	01 c3                	add    %eax,%ebx
  803695:	ff 75 0c             	pushl  0xc(%ebp)
  803698:	e8 4c f1 ff ff       	call   8027e9 <get_block_size>
  80369d:	83 c4 04             	add    $0x4,%esp
  8036a0:	01 d8                	add    %ebx,%eax
  8036a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036a5:	6a 00                	push   $0x0
  8036a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8036aa:	ff 75 08             	pushl  0x8(%ebp)
  8036ad:	e8 88 f4 ff ff       	call   802b3a <set_block_data>
  8036b2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8036b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036b9:	75 17                	jne    8036d2 <merging+0xc8>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 8b 50 80 00       	push   $0x80508b
  8036c3:	68 7d 01 00 00       	push   $0x17d
  8036c8:	68 a9 50 80 00       	push   $0x8050a9
  8036cd:	e8 bf d5 ff ff       	call   800c91 <_panic>
  8036d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	85 c0                	test   %eax,%eax
  8036d9:	74 10                	je     8036eb <merging+0xe1>
  8036db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036e3:	8b 52 04             	mov    0x4(%edx),%edx
  8036e6:	89 50 04             	mov    %edx,0x4(%eax)
  8036e9:	eb 0b                	jmp    8036f6 <merging+0xec>
  8036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ee:	8b 40 04             	mov    0x4(%eax),%eax
  8036f1:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f9:	8b 40 04             	mov    0x4(%eax),%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	74 0f                	je     80370f <merging+0x105>
  803700:	8b 45 0c             	mov    0xc(%ebp),%eax
  803703:	8b 40 04             	mov    0x4(%eax),%eax
  803706:	8b 55 0c             	mov    0xc(%ebp),%edx
  803709:	8b 12                	mov    (%edx),%edx
  80370b:	89 10                	mov    %edx,(%eax)
  80370d:	eb 0a                	jmp    803719 <merging+0x10f>
  80370f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803712:	8b 00                	mov    (%eax),%eax
  803714:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803722:	8b 45 0c             	mov    0xc(%ebp),%eax
  803725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372c:	a1 38 60 80 00       	mov    0x806038,%eax
  803731:	48                   	dec    %eax
  803732:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803737:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803738:	e9 ea 02 00 00       	jmp    803a27 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803741:	74 3b                	je     80377e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803743:	83 ec 0c             	sub    $0xc,%esp
  803746:	ff 75 08             	pushl  0x8(%ebp)
  803749:	e8 9b f0 ff ff       	call   8027e9 <get_block_size>
  80374e:	83 c4 10             	add    $0x10,%esp
  803751:	89 c3                	mov    %eax,%ebx
  803753:	83 ec 0c             	sub    $0xc,%esp
  803756:	ff 75 10             	pushl  0x10(%ebp)
  803759:	e8 8b f0 ff ff       	call   8027e9 <get_block_size>
  80375e:	83 c4 10             	add    $0x10,%esp
  803761:	01 d8                	add    %ebx,%eax
  803763:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	6a 00                	push   $0x0
  80376b:	ff 75 e8             	pushl  -0x18(%ebp)
  80376e:	ff 75 08             	pushl  0x8(%ebp)
  803771:	e8 c4 f3 ff ff       	call   802b3a <set_block_data>
  803776:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803779:	e9 a9 02 00 00       	jmp    803a27 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80377e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803782:	0f 84 2d 01 00 00    	je     8038b5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803788:	83 ec 0c             	sub    $0xc,%esp
  80378b:	ff 75 10             	pushl  0x10(%ebp)
  80378e:	e8 56 f0 ff ff       	call   8027e9 <get_block_size>
  803793:	83 c4 10             	add    $0x10,%esp
  803796:	89 c3                	mov    %eax,%ebx
  803798:	83 ec 0c             	sub    $0xc,%esp
  80379b:	ff 75 0c             	pushl  0xc(%ebp)
  80379e:	e8 46 f0 ff ff       	call   8027e9 <get_block_size>
  8037a3:	83 c4 10             	add    $0x10,%esp
  8037a6:	01 d8                	add    %ebx,%eax
  8037a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8037ab:	83 ec 04             	sub    $0x4,%esp
  8037ae:	6a 00                	push   $0x0
  8037b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037b3:	ff 75 10             	pushl  0x10(%ebp)
  8037b6:	e8 7f f3 ff ff       	call   802b3a <set_block_data>
  8037bb:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8037be:	8b 45 10             	mov    0x10(%ebp),%eax
  8037c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8037c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037c8:	74 06                	je     8037d0 <merging+0x1c6>
  8037ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037ce:	75 17                	jne    8037e7 <merging+0x1dd>
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	68 64 51 80 00       	push   $0x805164
  8037d8:	68 8d 01 00 00       	push   $0x18d
  8037dd:	68 a9 50 80 00       	push   $0x8050a9
  8037e2:	e8 aa d4 ff ff       	call   800c91 <_panic>
  8037e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ea:	8b 50 04             	mov    0x4(%eax),%edx
  8037ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f0:	89 50 04             	mov    %edx,0x4(%eax)
  8037f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	85 c0                	test   %eax,%eax
  803803:	74 0d                	je     803812 <merging+0x208>
  803805:	8b 45 0c             	mov    0xc(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	eb 08                	jmp    80381a <merging+0x210>
  803812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803815:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80381a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803820:	89 50 04             	mov    %edx,0x4(%eax)
  803823:	a1 38 60 80 00       	mov    0x806038,%eax
  803828:	40                   	inc    %eax
  803829:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  80382e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803832:	75 17                	jne    80384b <merging+0x241>
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	68 8b 50 80 00       	push   $0x80508b
  80383c:	68 8e 01 00 00       	push   $0x18e
  803841:	68 a9 50 80 00       	push   $0x8050a9
  803846:	e8 46 d4 ff ff       	call   800c91 <_panic>
  80384b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	85 c0                	test   %eax,%eax
  803852:	74 10                	je     803864 <merging+0x25a>
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80385c:	8b 52 04             	mov    0x4(%edx),%edx
  80385f:	89 50 04             	mov    %edx,0x4(%eax)
  803862:	eb 0b                	jmp    80386f <merging+0x265>
  803864:	8b 45 0c             	mov    0xc(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	a3 30 60 80 00       	mov    %eax,0x806030
  80386f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803872:	8b 40 04             	mov    0x4(%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 0f                	je     803888 <merging+0x27e>
  803879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387c:	8b 40 04             	mov    0x4(%eax),%eax
  80387f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803882:	8b 12                	mov    (%edx),%edx
  803884:	89 10                	mov    %edx,(%eax)
  803886:	eb 0a                	jmp    803892 <merging+0x288>
  803888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803892:	8b 45 0c             	mov    0xc(%ebp),%eax
  803895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a5:	a1 38 60 80 00       	mov    0x806038,%eax
  8038aa:	48                   	dec    %eax
  8038ab:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8038b0:	e9 72 01 00 00       	jmp    803a27 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8038b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8038b8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8038bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038bf:	74 79                	je     80393a <merging+0x330>
  8038c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038c5:	74 73                	je     80393a <merging+0x330>
  8038c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038cb:	74 06                	je     8038d3 <merging+0x2c9>
  8038cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038d1:	75 17                	jne    8038ea <merging+0x2e0>
  8038d3:	83 ec 04             	sub    $0x4,%esp
  8038d6:	68 1c 51 80 00       	push   $0x80511c
  8038db:	68 94 01 00 00       	push   $0x194
  8038e0:	68 a9 50 80 00       	push   $0x8050a9
  8038e5:	e8 a7 d3 ff ff       	call   800c91 <_panic>
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	8b 10                	mov    (%eax),%edx
  8038ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f2:	89 10                	mov    %edx,(%eax)
  8038f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	74 0b                	je     803908 <merging+0x2fe>
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803905:	89 50 04             	mov    %edx,0x4(%eax)
  803908:	8b 45 08             	mov    0x8(%ebp),%eax
  80390b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80390e:	89 10                	mov    %edx,(%eax)
  803910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803913:	8b 55 08             	mov    0x8(%ebp),%edx
  803916:	89 50 04             	mov    %edx,0x4(%eax)
  803919:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	85 c0                	test   %eax,%eax
  803920:	75 08                	jne    80392a <merging+0x320>
  803922:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803925:	a3 30 60 80 00       	mov    %eax,0x806030
  80392a:	a1 38 60 80 00       	mov    0x806038,%eax
  80392f:	40                   	inc    %eax
  803930:	a3 38 60 80 00       	mov    %eax,0x806038
  803935:	e9 ce 00 00 00       	jmp    803a08 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80393a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80393e:	74 65                	je     8039a5 <merging+0x39b>
  803940:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803944:	75 17                	jne    80395d <merging+0x353>
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 f8 50 80 00       	push   $0x8050f8
  80394e:	68 95 01 00 00       	push   $0x195
  803953:	68 a9 50 80 00       	push   $0x8050a9
  803958:	e8 34 d3 ff ff       	call   800c91 <_panic>
  80395d:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803963:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803966:	89 50 04             	mov    %edx,0x4(%eax)
  803969:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396c:	8b 40 04             	mov    0x4(%eax),%eax
  80396f:	85 c0                	test   %eax,%eax
  803971:	74 0c                	je     80397f <merging+0x375>
  803973:	a1 30 60 80 00       	mov    0x806030,%eax
  803978:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397b:	89 10                	mov    %edx,(%eax)
  80397d:	eb 08                	jmp    803987 <merging+0x37d>
  80397f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803982:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803987:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398a:	a3 30 60 80 00       	mov    %eax,0x806030
  80398f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803998:	a1 38 60 80 00       	mov    0x806038,%eax
  80399d:	40                   	inc    %eax
  80399e:	a3 38 60 80 00       	mov    %eax,0x806038
  8039a3:	eb 63                	jmp    803a08 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8039a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039a9:	75 17                	jne    8039c2 <merging+0x3b8>
  8039ab:	83 ec 04             	sub    $0x4,%esp
  8039ae:	68 c4 50 80 00       	push   $0x8050c4
  8039b3:	68 98 01 00 00       	push   $0x198
  8039b8:	68 a9 50 80 00       	push   $0x8050a9
  8039bd:	e8 cf d2 ff ff       	call   800c91 <_panic>
  8039c2:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8039c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cb:	89 10                	mov    %edx,(%eax)
  8039cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	85 c0                	test   %eax,%eax
  8039d4:	74 0d                	je     8039e3 <merging+0x3d9>
  8039d6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039de:	89 50 04             	mov    %edx,0x4(%eax)
  8039e1:	eb 08                	jmp    8039eb <merging+0x3e1>
  8039e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039e6:	a3 30 60 80 00       	mov    %eax,0x806030
  8039eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ee:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fd:	a1 38 60 80 00       	mov    0x806038,%eax
  803a02:	40                   	inc    %eax
  803a03:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803a08:	83 ec 0c             	sub    $0xc,%esp
  803a0b:	ff 75 10             	pushl  0x10(%ebp)
  803a0e:	e8 d6 ed ff ff       	call   8027e9 <get_block_size>
  803a13:	83 c4 10             	add    $0x10,%esp
  803a16:	83 ec 04             	sub    $0x4,%esp
  803a19:	6a 00                	push   $0x0
  803a1b:	50                   	push   %eax
  803a1c:	ff 75 10             	pushl  0x10(%ebp)
  803a1f:	e8 16 f1 ff ff       	call   802b3a <set_block_data>
  803a24:	83 c4 10             	add    $0x10,%esp
	}
}
  803a27:	90                   	nop
  803a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a2b:	c9                   	leave  
  803a2c:	c3                   	ret    

00803a2d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a2d:	55                   	push   %ebp
  803a2e:	89 e5                	mov    %esp,%ebp
  803a30:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a33:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a38:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a3b:	a1 30 60 80 00       	mov    0x806030,%eax
  803a40:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a43:	73 1b                	jae    803a60 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a45:	a1 30 60 80 00       	mov    0x806030,%eax
  803a4a:	83 ec 04             	sub    $0x4,%esp
  803a4d:	ff 75 08             	pushl  0x8(%ebp)
  803a50:	6a 00                	push   $0x0
  803a52:	50                   	push   %eax
  803a53:	e8 b2 fb ff ff       	call   80360a <merging>
  803a58:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a5b:	e9 8b 00 00 00       	jmp    803aeb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a60:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a65:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a68:	76 18                	jbe    803a82 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a6a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a6f:	83 ec 04             	sub    $0x4,%esp
  803a72:	ff 75 08             	pushl  0x8(%ebp)
  803a75:	50                   	push   %eax
  803a76:	6a 00                	push   $0x0
  803a78:	e8 8d fb ff ff       	call   80360a <merging>
  803a7d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a80:	eb 69                	jmp    803aeb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a82:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a8a:	eb 39                	jmp    803ac5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a92:	73 29                	jae    803abd <free_block+0x90>
  803a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a9c:	76 1f                	jbe    803abd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803aa6:	83 ec 04             	sub    $0x4,%esp
  803aa9:	ff 75 08             	pushl  0x8(%ebp)
  803aac:	ff 75 f0             	pushl  -0x10(%ebp)
  803aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  803ab2:	e8 53 fb ff ff       	call   80360a <merging>
  803ab7:	83 c4 10             	add    $0x10,%esp
			break;
  803aba:	90                   	nop
		}
	}
}
  803abb:	eb 2e                	jmp    803aeb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803abd:	a1 34 60 80 00       	mov    0x806034,%eax
  803ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac9:	74 07                	je     803ad2 <free_block+0xa5>
  803acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	eb 05                	jmp    803ad7 <free_block+0xaa>
  803ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad7:	a3 34 60 80 00       	mov    %eax,0x806034
  803adc:	a1 34 60 80 00       	mov    0x806034,%eax
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	75 a7                	jne    803a8c <free_block+0x5f>
  803ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae9:	75 a1                	jne    803a8c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aeb:	90                   	nop
  803aec:	c9                   	leave  
  803aed:	c3                   	ret    

00803aee <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803aee:	55                   	push   %ebp
  803aef:	89 e5                	mov    %esp,%ebp
  803af1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803af4:	ff 75 08             	pushl  0x8(%ebp)
  803af7:	e8 ed ec ff ff       	call   8027e9 <get_block_size>
  803afc:	83 c4 04             	add    $0x4,%esp
  803aff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b09:	eb 17                	jmp    803b22 <copy_data+0x34>
  803b0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b11:	01 c2                	add    %eax,%edx
  803b13:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	01 c8                	add    %ecx,%eax
  803b1b:	8a 00                	mov    (%eax),%al
  803b1d:	88 02                	mov    %al,(%edx)
  803b1f:	ff 45 fc             	incl   -0x4(%ebp)
  803b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b28:	72 e1                	jb     803b0b <copy_data+0x1d>
}
  803b2a:	90                   	nop
  803b2b:	c9                   	leave  
  803b2c:	c3                   	ret    

00803b2d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b2d:	55                   	push   %ebp
  803b2e:	89 e5                	mov    %esp,%ebp
  803b30:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b37:	75 23                	jne    803b5c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b3d:	74 13                	je     803b52 <realloc_block_FF+0x25>
  803b3f:	83 ec 0c             	sub    $0xc,%esp
  803b42:	ff 75 0c             	pushl  0xc(%ebp)
  803b45:	e8 1f f0 ff ff       	call   802b69 <alloc_block_FF>
  803b4a:	83 c4 10             	add    $0x10,%esp
  803b4d:	e9 f4 06 00 00       	jmp    804246 <realloc_block_FF+0x719>
		return NULL;
  803b52:	b8 00 00 00 00       	mov    $0x0,%eax
  803b57:	e9 ea 06 00 00       	jmp    804246 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b60:	75 18                	jne    803b7a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b62:	83 ec 0c             	sub    $0xc,%esp
  803b65:	ff 75 08             	pushl  0x8(%ebp)
  803b68:	e8 c0 fe ff ff       	call   803a2d <free_block>
  803b6d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b70:	b8 00 00 00 00       	mov    $0x0,%eax
  803b75:	e9 cc 06 00 00       	jmp    804246 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b7a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b7e:	77 07                	ja     803b87 <realloc_block_FF+0x5a>
  803b80:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b8a:	83 e0 01             	and    $0x1,%eax
  803b8d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b93:	83 c0 08             	add    $0x8,%eax
  803b96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b99:	83 ec 0c             	sub    $0xc,%esp
  803b9c:	ff 75 08             	pushl  0x8(%ebp)
  803b9f:	e8 45 ec ff ff       	call   8027e9 <get_block_size>
  803ba4:	83 c4 10             	add    $0x10,%esp
  803ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bad:	83 e8 08             	sub    $0x8,%eax
  803bb0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb6:	83 e8 04             	sub    $0x4,%eax
  803bb9:	8b 00                	mov    (%eax),%eax
  803bbb:	83 e0 fe             	and    $0xfffffffe,%eax
  803bbe:	89 c2                	mov    %eax,%edx
  803bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc3:	01 d0                	add    %edx,%eax
  803bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803bc8:	83 ec 0c             	sub    $0xc,%esp
  803bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bce:	e8 16 ec ff ff       	call   8027e9 <get_block_size>
  803bd3:	83 c4 10             	add    $0x10,%esp
  803bd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bdc:	83 e8 08             	sub    $0x8,%eax
  803bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803be8:	75 08                	jne    803bf2 <realloc_block_FF+0xc5>
	{
		 return va;
  803bea:	8b 45 08             	mov    0x8(%ebp),%eax
  803bed:	e9 54 06 00 00       	jmp    804246 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bf8:	0f 83 e5 03 00 00    	jae    803fe3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c01:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c04:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c07:	83 ec 0c             	sub    $0xc,%esp
  803c0a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c0d:	e8 f0 eb ff ff       	call   802802 <is_free_block>
  803c12:	83 c4 10             	add    $0x10,%esp
  803c15:	84 c0                	test   %al,%al
  803c17:	0f 84 3b 01 00 00    	je     803d58 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c23:	01 d0                	add    %edx,%eax
  803c25:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c28:	83 ec 04             	sub    $0x4,%esp
  803c2b:	6a 01                	push   $0x1
  803c2d:	ff 75 f0             	pushl  -0x10(%ebp)
  803c30:	ff 75 08             	pushl  0x8(%ebp)
  803c33:	e8 02 ef ff ff       	call   802b3a <set_block_data>
  803c38:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	83 e8 04             	sub    $0x4,%eax
  803c41:	8b 00                	mov    (%eax),%eax
  803c43:	83 e0 fe             	and    $0xfffffffe,%eax
  803c46:	89 c2                	mov    %eax,%edx
  803c48:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4b:	01 d0                	add    %edx,%eax
  803c4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c50:	83 ec 04             	sub    $0x4,%esp
  803c53:	6a 00                	push   $0x0
  803c55:	ff 75 cc             	pushl  -0x34(%ebp)
  803c58:	ff 75 c8             	pushl  -0x38(%ebp)
  803c5b:	e8 da ee ff ff       	call   802b3a <set_block_data>
  803c60:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c67:	74 06                	je     803c6f <realloc_block_FF+0x142>
  803c69:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c6d:	75 17                	jne    803c86 <realloc_block_FF+0x159>
  803c6f:	83 ec 04             	sub    $0x4,%esp
  803c72:	68 1c 51 80 00       	push   $0x80511c
  803c77:	68 f6 01 00 00       	push   $0x1f6
  803c7c:	68 a9 50 80 00       	push   $0x8050a9
  803c81:	e8 0b d0 ff ff       	call   800c91 <_panic>
  803c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c89:	8b 10                	mov    (%eax),%edx
  803c8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c8e:	89 10                	mov    %edx,(%eax)
  803c90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c93:	8b 00                	mov    (%eax),%eax
  803c95:	85 c0                	test   %eax,%eax
  803c97:	74 0b                	je     803ca4 <realloc_block_FF+0x177>
  803c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9c:	8b 00                	mov    (%eax),%eax
  803c9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ca1:	89 50 04             	mov    %edx,0x4(%eax)
  803ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803caa:	89 10                	mov    %edx,(%eax)
  803cac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803caf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cb2:	89 50 04             	mov    %edx,0x4(%eax)
  803cb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cb8:	8b 00                	mov    (%eax),%eax
  803cba:	85 c0                	test   %eax,%eax
  803cbc:	75 08                	jne    803cc6 <realloc_block_FF+0x199>
  803cbe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cc1:	a3 30 60 80 00       	mov    %eax,0x806030
  803cc6:	a1 38 60 80 00       	mov    0x806038,%eax
  803ccb:	40                   	inc    %eax
  803ccc:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd5:	75 17                	jne    803cee <realloc_block_FF+0x1c1>
  803cd7:	83 ec 04             	sub    $0x4,%esp
  803cda:	68 8b 50 80 00       	push   $0x80508b
  803cdf:	68 f7 01 00 00       	push   $0x1f7
  803ce4:	68 a9 50 80 00       	push   $0x8050a9
  803ce9:	e8 a3 cf ff ff       	call   800c91 <_panic>
  803cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf1:	8b 00                	mov    (%eax),%eax
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	74 10                	je     803d07 <realloc_block_FF+0x1da>
  803cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfa:	8b 00                	mov    (%eax),%eax
  803cfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cff:	8b 52 04             	mov    0x4(%edx),%edx
  803d02:	89 50 04             	mov    %edx,0x4(%eax)
  803d05:	eb 0b                	jmp    803d12 <realloc_block_FF+0x1e5>
  803d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0a:	8b 40 04             	mov    0x4(%eax),%eax
  803d0d:	a3 30 60 80 00       	mov    %eax,0x806030
  803d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d15:	8b 40 04             	mov    0x4(%eax),%eax
  803d18:	85 c0                	test   %eax,%eax
  803d1a:	74 0f                	je     803d2b <realloc_block_FF+0x1fe>
  803d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1f:	8b 40 04             	mov    0x4(%eax),%eax
  803d22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d25:	8b 12                	mov    (%edx),%edx
  803d27:	89 10                	mov    %edx,(%eax)
  803d29:	eb 0a                	jmp    803d35 <realloc_block_FF+0x208>
  803d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2e:	8b 00                	mov    (%eax),%eax
  803d30:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d48:	a1 38 60 80 00       	mov    0x806038,%eax
  803d4d:	48                   	dec    %eax
  803d4e:	a3 38 60 80 00       	mov    %eax,0x806038
  803d53:	e9 83 02 00 00       	jmp    803fdb <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803d58:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d5c:	0f 86 69 02 00 00    	jbe    803fcb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d62:	83 ec 04             	sub    $0x4,%esp
  803d65:	6a 01                	push   $0x1
  803d67:	ff 75 f0             	pushl  -0x10(%ebp)
  803d6a:	ff 75 08             	pushl  0x8(%ebp)
  803d6d:	e8 c8 ed ff ff       	call   802b3a <set_block_data>
  803d72:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d75:	8b 45 08             	mov    0x8(%ebp),%eax
  803d78:	83 e8 04             	sub    $0x4,%eax
  803d7b:	8b 00                	mov    (%eax),%eax
  803d7d:	83 e0 fe             	and    $0xfffffffe,%eax
  803d80:	89 c2                	mov    %eax,%edx
  803d82:	8b 45 08             	mov    0x8(%ebp),%eax
  803d85:	01 d0                	add    %edx,%eax
  803d87:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d8a:	a1 38 60 80 00       	mov    0x806038,%eax
  803d8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d92:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d96:	75 68                	jne    803e00 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d9c:	75 17                	jne    803db5 <realloc_block_FF+0x288>
  803d9e:	83 ec 04             	sub    $0x4,%esp
  803da1:	68 c4 50 80 00       	push   $0x8050c4
  803da6:	68 06 02 00 00       	push   $0x206
  803dab:	68 a9 50 80 00       	push   $0x8050a9
  803db0:	e8 dc ce ff ff       	call   800c91 <_panic>
  803db5:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803dbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dbe:	89 10                	mov    %edx,(%eax)
  803dc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc3:	8b 00                	mov    (%eax),%eax
  803dc5:	85 c0                	test   %eax,%eax
  803dc7:	74 0d                	je     803dd6 <realloc_block_FF+0x2a9>
  803dc9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dd1:	89 50 04             	mov    %edx,0x4(%eax)
  803dd4:	eb 08                	jmp    803dde <realloc_block_FF+0x2b1>
  803dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd9:	a3 30 60 80 00       	mov    %eax,0x806030
  803dde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803de6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803df0:	a1 38 60 80 00       	mov    0x806038,%eax
  803df5:	40                   	inc    %eax
  803df6:	a3 38 60 80 00       	mov    %eax,0x806038
  803dfb:	e9 b0 01 00 00       	jmp    803fb0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e00:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e05:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e08:	76 68                	jbe    803e72 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e0e:	75 17                	jne    803e27 <realloc_block_FF+0x2fa>
  803e10:	83 ec 04             	sub    $0x4,%esp
  803e13:	68 c4 50 80 00       	push   $0x8050c4
  803e18:	68 0b 02 00 00       	push   $0x20b
  803e1d:	68 a9 50 80 00       	push   $0x8050a9
  803e22:	e8 6a ce ff ff       	call   800c91 <_panic>
  803e27:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e30:	89 10                	mov    %edx,(%eax)
  803e32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e35:	8b 00                	mov    (%eax),%eax
  803e37:	85 c0                	test   %eax,%eax
  803e39:	74 0d                	je     803e48 <realloc_block_FF+0x31b>
  803e3b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e40:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e43:	89 50 04             	mov    %edx,0x4(%eax)
  803e46:	eb 08                	jmp    803e50 <realloc_block_FF+0x323>
  803e48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4b:	a3 30 60 80 00       	mov    %eax,0x806030
  803e50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e53:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e62:	a1 38 60 80 00       	mov    0x806038,%eax
  803e67:	40                   	inc    %eax
  803e68:	a3 38 60 80 00       	mov    %eax,0x806038
  803e6d:	e9 3e 01 00 00       	jmp    803fb0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e72:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e77:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e7a:	73 68                	jae    803ee4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e7c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e80:	75 17                	jne    803e99 <realloc_block_FF+0x36c>
  803e82:	83 ec 04             	sub    $0x4,%esp
  803e85:	68 f8 50 80 00       	push   $0x8050f8
  803e8a:	68 10 02 00 00       	push   $0x210
  803e8f:	68 a9 50 80 00       	push   $0x8050a9
  803e94:	e8 f8 cd ff ff       	call   800c91 <_panic>
  803e99:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea2:	89 50 04             	mov    %edx,0x4(%eax)
  803ea5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea8:	8b 40 04             	mov    0x4(%eax),%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	74 0c                	je     803ebb <realloc_block_FF+0x38e>
  803eaf:	a1 30 60 80 00       	mov    0x806030,%eax
  803eb4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eb7:	89 10                	mov    %edx,(%eax)
  803eb9:	eb 08                	jmp    803ec3 <realloc_block_FF+0x396>
  803ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebe:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ec3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec6:	a3 30 60 80 00       	mov    %eax,0x806030
  803ecb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed4:	a1 38 60 80 00       	mov    0x806038,%eax
  803ed9:	40                   	inc    %eax
  803eda:	a3 38 60 80 00       	mov    %eax,0x806038
  803edf:	e9 cc 00 00 00       	jmp    803fb0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803eeb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ef3:	e9 8a 00 00 00       	jmp    803f82 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803efe:	73 7a                	jae    803f7a <realloc_block_FF+0x44d>
  803f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f03:	8b 00                	mov    (%eax),%eax
  803f05:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f08:	73 70                	jae    803f7a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f0e:	74 06                	je     803f16 <realloc_block_FF+0x3e9>
  803f10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f14:	75 17                	jne    803f2d <realloc_block_FF+0x400>
  803f16:	83 ec 04             	sub    $0x4,%esp
  803f19:	68 1c 51 80 00       	push   $0x80511c
  803f1e:	68 1a 02 00 00       	push   $0x21a
  803f23:	68 a9 50 80 00       	push   $0x8050a9
  803f28:	e8 64 cd ff ff       	call   800c91 <_panic>
  803f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f30:	8b 10                	mov    (%eax),%edx
  803f32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f35:	89 10                	mov    %edx,(%eax)
  803f37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	85 c0                	test   %eax,%eax
  803f3e:	74 0b                	je     803f4b <realloc_block_FF+0x41e>
  803f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f43:	8b 00                	mov    (%eax),%eax
  803f45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f48:	89 50 04             	mov    %edx,0x4(%eax)
  803f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f51:	89 10                	mov    %edx,(%eax)
  803f53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f59:	89 50 04             	mov    %edx,0x4(%eax)
  803f5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f5f:	8b 00                	mov    (%eax),%eax
  803f61:	85 c0                	test   %eax,%eax
  803f63:	75 08                	jne    803f6d <realloc_block_FF+0x440>
  803f65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f68:	a3 30 60 80 00       	mov    %eax,0x806030
  803f6d:	a1 38 60 80 00       	mov    0x806038,%eax
  803f72:	40                   	inc    %eax
  803f73:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803f78:	eb 36                	jmp    803fb0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f7a:	a1 34 60 80 00       	mov    0x806034,%eax
  803f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f86:	74 07                	je     803f8f <realloc_block_FF+0x462>
  803f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8b:	8b 00                	mov    (%eax),%eax
  803f8d:	eb 05                	jmp    803f94 <realloc_block_FF+0x467>
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f94:	a3 34 60 80 00       	mov    %eax,0x806034
  803f99:	a1 34 60 80 00       	mov    0x806034,%eax
  803f9e:	85 c0                	test   %eax,%eax
  803fa0:	0f 85 52 ff ff ff    	jne    803ef8 <realloc_block_FF+0x3cb>
  803fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803faa:	0f 85 48 ff ff ff    	jne    803ef8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803fb0:	83 ec 04             	sub    $0x4,%esp
  803fb3:	6a 00                	push   $0x0
  803fb5:	ff 75 d8             	pushl  -0x28(%ebp)
  803fb8:	ff 75 d4             	pushl  -0x2c(%ebp)
  803fbb:	e8 7a eb ff ff       	call   802b3a <set_block_data>
  803fc0:	83 c4 10             	add    $0x10,%esp
				return va;
  803fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc6:	e9 7b 02 00 00       	jmp    804246 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803fcb:	83 ec 0c             	sub    $0xc,%esp
  803fce:	68 99 51 80 00       	push   $0x805199
  803fd3:	e8 76 cf ff ff       	call   800f4e <cprintf>
  803fd8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fde:	e9 63 02 00 00       	jmp    804246 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fe9:	0f 86 4d 02 00 00    	jbe    80423c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803fef:	83 ec 0c             	sub    $0xc,%esp
  803ff2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ff5:	e8 08 e8 ff ff       	call   802802 <is_free_block>
  803ffa:	83 c4 10             	add    $0x10,%esp
  803ffd:	84 c0                	test   %al,%al
  803fff:	0f 84 37 02 00 00    	je     80423c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804005:	8b 45 0c             	mov    0xc(%ebp),%eax
  804008:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80400b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80400e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804011:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804014:	76 38                	jbe    80404e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804016:	83 ec 0c             	sub    $0xc,%esp
  804019:	ff 75 08             	pushl  0x8(%ebp)
  80401c:	e8 0c fa ff ff       	call   803a2d <free_block>
  804021:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804024:	83 ec 0c             	sub    $0xc,%esp
  804027:	ff 75 0c             	pushl  0xc(%ebp)
  80402a:	e8 3a eb ff ff       	call   802b69 <alloc_block_FF>
  80402f:	83 c4 10             	add    $0x10,%esp
  804032:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804035:	83 ec 08             	sub    $0x8,%esp
  804038:	ff 75 c0             	pushl  -0x40(%ebp)
  80403b:	ff 75 08             	pushl  0x8(%ebp)
  80403e:	e8 ab fa ff ff       	call   803aee <copy_data>
  804043:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804046:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804049:	e9 f8 01 00 00       	jmp    804246 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80404e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804051:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804054:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804057:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80405b:	0f 87 a0 00 00 00    	ja     804101 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804061:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804065:	75 17                	jne    80407e <realloc_block_FF+0x551>
  804067:	83 ec 04             	sub    $0x4,%esp
  80406a:	68 8b 50 80 00       	push   $0x80508b
  80406f:	68 38 02 00 00       	push   $0x238
  804074:	68 a9 50 80 00       	push   $0x8050a9
  804079:	e8 13 cc ff ff       	call   800c91 <_panic>
  80407e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804081:	8b 00                	mov    (%eax),%eax
  804083:	85 c0                	test   %eax,%eax
  804085:	74 10                	je     804097 <realloc_block_FF+0x56a>
  804087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408a:	8b 00                	mov    (%eax),%eax
  80408c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80408f:	8b 52 04             	mov    0x4(%edx),%edx
  804092:	89 50 04             	mov    %edx,0x4(%eax)
  804095:	eb 0b                	jmp    8040a2 <realloc_block_FF+0x575>
  804097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409a:	8b 40 04             	mov    0x4(%eax),%eax
  80409d:	a3 30 60 80 00       	mov    %eax,0x806030
  8040a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a5:	8b 40 04             	mov    0x4(%eax),%eax
  8040a8:	85 c0                	test   %eax,%eax
  8040aa:	74 0f                	je     8040bb <realloc_block_FF+0x58e>
  8040ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040af:	8b 40 04             	mov    0x4(%eax),%eax
  8040b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040b5:	8b 12                	mov    (%edx),%edx
  8040b7:	89 10                	mov    %edx,(%eax)
  8040b9:	eb 0a                	jmp    8040c5 <realloc_block_FF+0x598>
  8040bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040be:	8b 00                	mov    (%eax),%eax
  8040c0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040d8:	a1 38 60 80 00       	mov    0x806038,%eax
  8040dd:	48                   	dec    %eax
  8040de:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8040e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040e9:	01 d0                	add    %edx,%eax
  8040eb:	83 ec 04             	sub    $0x4,%esp
  8040ee:	6a 01                	push   $0x1
  8040f0:	50                   	push   %eax
  8040f1:	ff 75 08             	pushl  0x8(%ebp)
  8040f4:	e8 41 ea ff ff       	call   802b3a <set_block_data>
  8040f9:	83 c4 10             	add    $0x10,%esp
  8040fc:	e9 36 01 00 00       	jmp    804237 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804101:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804104:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804107:	01 d0                	add    %edx,%eax
  804109:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80410c:	83 ec 04             	sub    $0x4,%esp
  80410f:	6a 01                	push   $0x1
  804111:	ff 75 f0             	pushl  -0x10(%ebp)
  804114:	ff 75 08             	pushl  0x8(%ebp)
  804117:	e8 1e ea ff ff       	call   802b3a <set_block_data>
  80411c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80411f:	8b 45 08             	mov    0x8(%ebp),%eax
  804122:	83 e8 04             	sub    $0x4,%eax
  804125:	8b 00                	mov    (%eax),%eax
  804127:	83 e0 fe             	and    $0xfffffffe,%eax
  80412a:	89 c2                	mov    %eax,%edx
  80412c:	8b 45 08             	mov    0x8(%ebp),%eax
  80412f:	01 d0                	add    %edx,%eax
  804131:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804134:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804138:	74 06                	je     804140 <realloc_block_FF+0x613>
  80413a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80413e:	75 17                	jne    804157 <realloc_block_FF+0x62a>
  804140:	83 ec 04             	sub    $0x4,%esp
  804143:	68 1c 51 80 00       	push   $0x80511c
  804148:	68 44 02 00 00       	push   $0x244
  80414d:	68 a9 50 80 00       	push   $0x8050a9
  804152:	e8 3a cb ff ff       	call   800c91 <_panic>
  804157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415a:	8b 10                	mov    (%eax),%edx
  80415c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80415f:	89 10                	mov    %edx,(%eax)
  804161:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804164:	8b 00                	mov    (%eax),%eax
  804166:	85 c0                	test   %eax,%eax
  804168:	74 0b                	je     804175 <realloc_block_FF+0x648>
  80416a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80416d:	8b 00                	mov    (%eax),%eax
  80416f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804172:	89 50 04             	mov    %edx,0x4(%eax)
  804175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804178:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80417b:	89 10                	mov    %edx,(%eax)
  80417d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804183:	89 50 04             	mov    %edx,0x4(%eax)
  804186:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804189:	8b 00                	mov    (%eax),%eax
  80418b:	85 c0                	test   %eax,%eax
  80418d:	75 08                	jne    804197 <realloc_block_FF+0x66a>
  80418f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804192:	a3 30 60 80 00       	mov    %eax,0x806030
  804197:	a1 38 60 80 00       	mov    0x806038,%eax
  80419c:	40                   	inc    %eax
  80419d:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041a6:	75 17                	jne    8041bf <realloc_block_FF+0x692>
  8041a8:	83 ec 04             	sub    $0x4,%esp
  8041ab:	68 8b 50 80 00       	push   $0x80508b
  8041b0:	68 45 02 00 00       	push   $0x245
  8041b5:	68 a9 50 80 00       	push   $0x8050a9
  8041ba:	e8 d2 ca ff ff       	call   800c91 <_panic>
  8041bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c2:	8b 00                	mov    (%eax),%eax
  8041c4:	85 c0                	test   %eax,%eax
  8041c6:	74 10                	je     8041d8 <realloc_block_FF+0x6ab>
  8041c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041cb:	8b 00                	mov    (%eax),%eax
  8041cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041d0:	8b 52 04             	mov    0x4(%edx),%edx
  8041d3:	89 50 04             	mov    %edx,0x4(%eax)
  8041d6:	eb 0b                	jmp    8041e3 <realloc_block_FF+0x6b6>
  8041d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041db:	8b 40 04             	mov    0x4(%eax),%eax
  8041de:	a3 30 60 80 00       	mov    %eax,0x806030
  8041e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e6:	8b 40 04             	mov    0x4(%eax),%eax
  8041e9:	85 c0                	test   %eax,%eax
  8041eb:	74 0f                	je     8041fc <realloc_block_FF+0x6cf>
  8041ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f0:	8b 40 04             	mov    0x4(%eax),%eax
  8041f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041f6:	8b 12                	mov    (%edx),%edx
  8041f8:	89 10                	mov    %edx,(%eax)
  8041fa:	eb 0a                	jmp    804206 <realloc_block_FF+0x6d9>
  8041fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ff:	8b 00                	mov    (%eax),%eax
  804201:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80420f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804212:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804219:	a1 38 60 80 00       	mov    0x806038,%eax
  80421e:	48                   	dec    %eax
  80421f:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804224:	83 ec 04             	sub    $0x4,%esp
  804227:	6a 00                	push   $0x0
  804229:	ff 75 bc             	pushl  -0x44(%ebp)
  80422c:	ff 75 b8             	pushl  -0x48(%ebp)
  80422f:	e8 06 e9 ff ff       	call   802b3a <set_block_data>
  804234:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804237:	8b 45 08             	mov    0x8(%ebp),%eax
  80423a:	eb 0a                	jmp    804246 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80423c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804243:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804246:	c9                   	leave  
  804247:	c3                   	ret    

00804248 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804248:	55                   	push   %ebp
  804249:	89 e5                	mov    %esp,%ebp
  80424b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80424e:	83 ec 04             	sub    $0x4,%esp
  804251:	68 a0 51 80 00       	push   $0x8051a0
  804256:	68 58 02 00 00       	push   $0x258
  80425b:	68 a9 50 80 00       	push   $0x8050a9
  804260:	e8 2c ca ff ff       	call   800c91 <_panic>

00804265 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804265:	55                   	push   %ebp
  804266:	89 e5                	mov    %esp,%ebp
  804268:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80426b:	83 ec 04             	sub    $0x4,%esp
  80426e:	68 c8 51 80 00       	push   $0x8051c8
  804273:	68 61 02 00 00       	push   $0x261
  804278:	68 a9 50 80 00       	push   $0x8050a9
  80427d:	e8 0f ca ff ff       	call   800c91 <_panic>

00804282 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804282:	55                   	push   %ebp
  804283:	89 e5                	mov    %esp,%ebp
  804285:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  804288:	83 ec 04             	sub    $0x4,%esp
  80428b:	68 f0 51 80 00       	push   $0x8051f0
  804290:	6a 09                	push   $0x9
  804292:	68 18 52 80 00       	push   $0x805218
  804297:	e8 f5 c9 ff ff       	call   800c91 <_panic>

0080429c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80429c:	55                   	push   %ebp
  80429d:	89 e5                	mov    %esp,%ebp
  80429f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8042a2:	83 ec 04             	sub    $0x4,%esp
  8042a5:	68 28 52 80 00       	push   $0x805228
  8042aa:	6a 10                	push   $0x10
  8042ac:	68 18 52 80 00       	push   $0x805218
  8042b1:	e8 db c9 ff ff       	call   800c91 <_panic>

008042b6 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8042b6:	55                   	push   %ebp
  8042b7:	89 e5                	mov    %esp,%ebp
  8042b9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8042bc:	83 ec 04             	sub    $0x4,%esp
  8042bf:	68 50 52 80 00       	push   $0x805250
  8042c4:	6a 18                	push   $0x18
  8042c6:	68 18 52 80 00       	push   $0x805218
  8042cb:	e8 c1 c9 ff ff       	call   800c91 <_panic>

008042d0 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8042d0:	55                   	push   %ebp
  8042d1:	89 e5                	mov    %esp,%ebp
  8042d3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8042d6:	83 ec 04             	sub    $0x4,%esp
  8042d9:	68 78 52 80 00       	push   $0x805278
  8042de:	6a 20                	push   $0x20
  8042e0:	68 18 52 80 00       	push   $0x805218
  8042e5:	e8 a7 c9 ff ff       	call   800c91 <_panic>

008042ea <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8042ea:	55                   	push   %ebp
  8042eb:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8042ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f0:	8b 40 10             	mov    0x10(%eax),%eax
}
  8042f3:	5d                   	pop    %ebp
  8042f4:	c3                   	ret    

008042f5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8042f5:	55                   	push   %ebp
  8042f6:	89 e5                	mov    %esp,%ebp
  8042f8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8042fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8042fe:	89 d0                	mov    %edx,%eax
  804300:	c1 e0 02             	shl    $0x2,%eax
  804303:	01 d0                	add    %edx,%eax
  804305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80430c:	01 d0                	add    %edx,%eax
  80430e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804315:	01 d0                	add    %edx,%eax
  804317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80431e:	01 d0                	add    %edx,%eax
  804320:	c1 e0 04             	shl    $0x4,%eax
  804323:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80432d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804330:	83 ec 0c             	sub    $0xc,%esp
  804333:	50                   	push   %eax
  804334:	e8 bc e1 ff ff       	call   8024f5 <sys_get_virtual_time>
  804339:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80433c:	eb 41                	jmp    80437f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80433e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804341:	83 ec 0c             	sub    $0xc,%esp
  804344:	50                   	push   %eax
  804345:	e8 ab e1 ff ff       	call   8024f5 <sys_get_virtual_time>
  80434a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80434d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804353:	29 c2                	sub    %eax,%edx
  804355:	89 d0                	mov    %edx,%eax
  804357:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80435a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80435d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804360:	89 d1                	mov    %edx,%ecx
  804362:	29 c1                	sub    %eax,%ecx
  804364:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80436a:	39 c2                	cmp    %eax,%edx
  80436c:	0f 97 c0             	seta   %al
  80436f:	0f b6 c0             	movzbl %al,%eax
  804372:	29 c1                	sub    %eax,%ecx
  804374:	89 c8                	mov    %ecx,%eax
  804376:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804379:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80437c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80437f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804382:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  804385:	72 b7                	jb     80433e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804387:	90                   	nop
  804388:	c9                   	leave  
  804389:	c3                   	ret    

0080438a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80438a:	55                   	push   %ebp
  80438b:	89 e5                	mov    %esp,%ebp
  80438d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804397:	eb 03                	jmp    80439c <busy_wait+0x12>
  804399:	ff 45 fc             	incl   -0x4(%ebp)
  80439c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80439f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043a2:	72 f5                	jb     804399 <busy_wait+0xf>
	return i;
  8043a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8043a7:	c9                   	leave  
  8043a8:	c3                   	ret    
  8043a9:	66 90                	xchg   %ax,%ax
  8043ab:	90                   	nop

008043ac <__udivdi3>:
  8043ac:	55                   	push   %ebp
  8043ad:	57                   	push   %edi
  8043ae:	56                   	push   %esi
  8043af:	53                   	push   %ebx
  8043b0:	83 ec 1c             	sub    $0x1c,%esp
  8043b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043c3:	89 ca                	mov    %ecx,%edx
  8043c5:	89 f8                	mov    %edi,%eax
  8043c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043cb:	85 f6                	test   %esi,%esi
  8043cd:	75 2d                	jne    8043fc <__udivdi3+0x50>
  8043cf:	39 cf                	cmp    %ecx,%edi
  8043d1:	77 65                	ja     804438 <__udivdi3+0x8c>
  8043d3:	89 fd                	mov    %edi,%ebp
  8043d5:	85 ff                	test   %edi,%edi
  8043d7:	75 0b                	jne    8043e4 <__udivdi3+0x38>
  8043d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8043de:	31 d2                	xor    %edx,%edx
  8043e0:	f7 f7                	div    %edi
  8043e2:	89 c5                	mov    %eax,%ebp
  8043e4:	31 d2                	xor    %edx,%edx
  8043e6:	89 c8                	mov    %ecx,%eax
  8043e8:	f7 f5                	div    %ebp
  8043ea:	89 c1                	mov    %eax,%ecx
  8043ec:	89 d8                	mov    %ebx,%eax
  8043ee:	f7 f5                	div    %ebp
  8043f0:	89 cf                	mov    %ecx,%edi
  8043f2:	89 fa                	mov    %edi,%edx
  8043f4:	83 c4 1c             	add    $0x1c,%esp
  8043f7:	5b                   	pop    %ebx
  8043f8:	5e                   	pop    %esi
  8043f9:	5f                   	pop    %edi
  8043fa:	5d                   	pop    %ebp
  8043fb:	c3                   	ret    
  8043fc:	39 ce                	cmp    %ecx,%esi
  8043fe:	77 28                	ja     804428 <__udivdi3+0x7c>
  804400:	0f bd fe             	bsr    %esi,%edi
  804403:	83 f7 1f             	xor    $0x1f,%edi
  804406:	75 40                	jne    804448 <__udivdi3+0x9c>
  804408:	39 ce                	cmp    %ecx,%esi
  80440a:	72 0a                	jb     804416 <__udivdi3+0x6a>
  80440c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804410:	0f 87 9e 00 00 00    	ja     8044b4 <__udivdi3+0x108>
  804416:	b8 01 00 00 00       	mov    $0x1,%eax
  80441b:	89 fa                	mov    %edi,%edx
  80441d:	83 c4 1c             	add    $0x1c,%esp
  804420:	5b                   	pop    %ebx
  804421:	5e                   	pop    %esi
  804422:	5f                   	pop    %edi
  804423:	5d                   	pop    %ebp
  804424:	c3                   	ret    
  804425:	8d 76 00             	lea    0x0(%esi),%esi
  804428:	31 ff                	xor    %edi,%edi
  80442a:	31 c0                	xor    %eax,%eax
  80442c:	89 fa                	mov    %edi,%edx
  80442e:	83 c4 1c             	add    $0x1c,%esp
  804431:	5b                   	pop    %ebx
  804432:	5e                   	pop    %esi
  804433:	5f                   	pop    %edi
  804434:	5d                   	pop    %ebp
  804435:	c3                   	ret    
  804436:	66 90                	xchg   %ax,%ax
  804438:	89 d8                	mov    %ebx,%eax
  80443a:	f7 f7                	div    %edi
  80443c:	31 ff                	xor    %edi,%edi
  80443e:	89 fa                	mov    %edi,%edx
  804440:	83 c4 1c             	add    $0x1c,%esp
  804443:	5b                   	pop    %ebx
  804444:	5e                   	pop    %esi
  804445:	5f                   	pop    %edi
  804446:	5d                   	pop    %ebp
  804447:	c3                   	ret    
  804448:	bd 20 00 00 00       	mov    $0x20,%ebp
  80444d:	89 eb                	mov    %ebp,%ebx
  80444f:	29 fb                	sub    %edi,%ebx
  804451:	89 f9                	mov    %edi,%ecx
  804453:	d3 e6                	shl    %cl,%esi
  804455:	89 c5                	mov    %eax,%ebp
  804457:	88 d9                	mov    %bl,%cl
  804459:	d3 ed                	shr    %cl,%ebp
  80445b:	89 e9                	mov    %ebp,%ecx
  80445d:	09 f1                	or     %esi,%ecx
  80445f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804463:	89 f9                	mov    %edi,%ecx
  804465:	d3 e0                	shl    %cl,%eax
  804467:	89 c5                	mov    %eax,%ebp
  804469:	89 d6                	mov    %edx,%esi
  80446b:	88 d9                	mov    %bl,%cl
  80446d:	d3 ee                	shr    %cl,%esi
  80446f:	89 f9                	mov    %edi,%ecx
  804471:	d3 e2                	shl    %cl,%edx
  804473:	8b 44 24 08          	mov    0x8(%esp),%eax
  804477:	88 d9                	mov    %bl,%cl
  804479:	d3 e8                	shr    %cl,%eax
  80447b:	09 c2                	or     %eax,%edx
  80447d:	89 d0                	mov    %edx,%eax
  80447f:	89 f2                	mov    %esi,%edx
  804481:	f7 74 24 0c          	divl   0xc(%esp)
  804485:	89 d6                	mov    %edx,%esi
  804487:	89 c3                	mov    %eax,%ebx
  804489:	f7 e5                	mul    %ebp
  80448b:	39 d6                	cmp    %edx,%esi
  80448d:	72 19                	jb     8044a8 <__udivdi3+0xfc>
  80448f:	74 0b                	je     80449c <__udivdi3+0xf0>
  804491:	89 d8                	mov    %ebx,%eax
  804493:	31 ff                	xor    %edi,%edi
  804495:	e9 58 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  80449a:	66 90                	xchg   %ax,%ax
  80449c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044a0:	89 f9                	mov    %edi,%ecx
  8044a2:	d3 e2                	shl    %cl,%edx
  8044a4:	39 c2                	cmp    %eax,%edx
  8044a6:	73 e9                	jae    804491 <__udivdi3+0xe5>
  8044a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044ab:	31 ff                	xor    %edi,%edi
  8044ad:	e9 40 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  8044b2:	66 90                	xchg   %ax,%ax
  8044b4:	31 c0                	xor    %eax,%eax
  8044b6:	e9 37 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  8044bb:	90                   	nop

008044bc <__umoddi3>:
  8044bc:	55                   	push   %ebp
  8044bd:	57                   	push   %edi
  8044be:	56                   	push   %esi
  8044bf:	53                   	push   %ebx
  8044c0:	83 ec 1c             	sub    $0x1c,%esp
  8044c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044db:	89 f3                	mov    %esi,%ebx
  8044dd:	89 fa                	mov    %edi,%edx
  8044df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044e3:	89 34 24             	mov    %esi,(%esp)
  8044e6:	85 c0                	test   %eax,%eax
  8044e8:	75 1a                	jne    804504 <__umoddi3+0x48>
  8044ea:	39 f7                	cmp    %esi,%edi
  8044ec:	0f 86 a2 00 00 00    	jbe    804594 <__umoddi3+0xd8>
  8044f2:	89 c8                	mov    %ecx,%eax
  8044f4:	89 f2                	mov    %esi,%edx
  8044f6:	f7 f7                	div    %edi
  8044f8:	89 d0                	mov    %edx,%eax
  8044fa:	31 d2                	xor    %edx,%edx
  8044fc:	83 c4 1c             	add    $0x1c,%esp
  8044ff:	5b                   	pop    %ebx
  804500:	5e                   	pop    %esi
  804501:	5f                   	pop    %edi
  804502:	5d                   	pop    %ebp
  804503:	c3                   	ret    
  804504:	39 f0                	cmp    %esi,%eax
  804506:	0f 87 ac 00 00 00    	ja     8045b8 <__umoddi3+0xfc>
  80450c:	0f bd e8             	bsr    %eax,%ebp
  80450f:	83 f5 1f             	xor    $0x1f,%ebp
  804512:	0f 84 ac 00 00 00    	je     8045c4 <__umoddi3+0x108>
  804518:	bf 20 00 00 00       	mov    $0x20,%edi
  80451d:	29 ef                	sub    %ebp,%edi
  80451f:	89 fe                	mov    %edi,%esi
  804521:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804525:	89 e9                	mov    %ebp,%ecx
  804527:	d3 e0                	shl    %cl,%eax
  804529:	89 d7                	mov    %edx,%edi
  80452b:	89 f1                	mov    %esi,%ecx
  80452d:	d3 ef                	shr    %cl,%edi
  80452f:	09 c7                	or     %eax,%edi
  804531:	89 e9                	mov    %ebp,%ecx
  804533:	d3 e2                	shl    %cl,%edx
  804535:	89 14 24             	mov    %edx,(%esp)
  804538:	89 d8                	mov    %ebx,%eax
  80453a:	d3 e0                	shl    %cl,%eax
  80453c:	89 c2                	mov    %eax,%edx
  80453e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804542:	d3 e0                	shl    %cl,%eax
  804544:	89 44 24 04          	mov    %eax,0x4(%esp)
  804548:	8b 44 24 08          	mov    0x8(%esp),%eax
  80454c:	89 f1                	mov    %esi,%ecx
  80454e:	d3 e8                	shr    %cl,%eax
  804550:	09 d0                	or     %edx,%eax
  804552:	d3 eb                	shr    %cl,%ebx
  804554:	89 da                	mov    %ebx,%edx
  804556:	f7 f7                	div    %edi
  804558:	89 d3                	mov    %edx,%ebx
  80455a:	f7 24 24             	mull   (%esp)
  80455d:	89 c6                	mov    %eax,%esi
  80455f:	89 d1                	mov    %edx,%ecx
  804561:	39 d3                	cmp    %edx,%ebx
  804563:	0f 82 87 00 00 00    	jb     8045f0 <__umoddi3+0x134>
  804569:	0f 84 91 00 00 00    	je     804600 <__umoddi3+0x144>
  80456f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804573:	29 f2                	sub    %esi,%edx
  804575:	19 cb                	sbb    %ecx,%ebx
  804577:	89 d8                	mov    %ebx,%eax
  804579:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80457d:	d3 e0                	shl    %cl,%eax
  80457f:	89 e9                	mov    %ebp,%ecx
  804581:	d3 ea                	shr    %cl,%edx
  804583:	09 d0                	or     %edx,%eax
  804585:	89 e9                	mov    %ebp,%ecx
  804587:	d3 eb                	shr    %cl,%ebx
  804589:	89 da                	mov    %ebx,%edx
  80458b:	83 c4 1c             	add    $0x1c,%esp
  80458e:	5b                   	pop    %ebx
  80458f:	5e                   	pop    %esi
  804590:	5f                   	pop    %edi
  804591:	5d                   	pop    %ebp
  804592:	c3                   	ret    
  804593:	90                   	nop
  804594:	89 fd                	mov    %edi,%ebp
  804596:	85 ff                	test   %edi,%edi
  804598:	75 0b                	jne    8045a5 <__umoddi3+0xe9>
  80459a:	b8 01 00 00 00       	mov    $0x1,%eax
  80459f:	31 d2                	xor    %edx,%edx
  8045a1:	f7 f7                	div    %edi
  8045a3:	89 c5                	mov    %eax,%ebp
  8045a5:	89 f0                	mov    %esi,%eax
  8045a7:	31 d2                	xor    %edx,%edx
  8045a9:	f7 f5                	div    %ebp
  8045ab:	89 c8                	mov    %ecx,%eax
  8045ad:	f7 f5                	div    %ebp
  8045af:	89 d0                	mov    %edx,%eax
  8045b1:	e9 44 ff ff ff       	jmp    8044fa <__umoddi3+0x3e>
  8045b6:	66 90                	xchg   %ax,%ax
  8045b8:	89 c8                	mov    %ecx,%eax
  8045ba:	89 f2                	mov    %esi,%edx
  8045bc:	83 c4 1c             	add    $0x1c,%esp
  8045bf:	5b                   	pop    %ebx
  8045c0:	5e                   	pop    %esi
  8045c1:	5f                   	pop    %edi
  8045c2:	5d                   	pop    %ebp
  8045c3:	c3                   	ret    
  8045c4:	3b 04 24             	cmp    (%esp),%eax
  8045c7:	72 06                	jb     8045cf <__umoddi3+0x113>
  8045c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045cd:	77 0f                	ja     8045de <__umoddi3+0x122>
  8045cf:	89 f2                	mov    %esi,%edx
  8045d1:	29 f9                	sub    %edi,%ecx
  8045d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045d7:	89 14 24             	mov    %edx,(%esp)
  8045da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045e2:	8b 14 24             	mov    (%esp),%edx
  8045e5:	83 c4 1c             	add    $0x1c,%esp
  8045e8:	5b                   	pop    %ebx
  8045e9:	5e                   	pop    %esi
  8045ea:	5f                   	pop    %edi
  8045eb:	5d                   	pop    %ebp
  8045ec:	c3                   	ret    
  8045ed:	8d 76 00             	lea    0x0(%esi),%esi
  8045f0:	2b 04 24             	sub    (%esp),%eax
  8045f3:	19 fa                	sbb    %edi,%edx
  8045f5:	89 d1                	mov    %edx,%ecx
  8045f7:	89 c6                	mov    %eax,%esi
  8045f9:	e9 71 ff ff ff       	jmp    80456f <__umoddi3+0xb3>
  8045fe:	66 90                	xchg   %ax,%ax
  804600:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804604:	72 ea                	jb     8045f0 <__umoddi3+0x134>
  804606:	89 d9                	mov    %ebx,%ecx
  804608:	e9 62 ff ff ff       	jmp    80456f <__umoddi3+0xb3>

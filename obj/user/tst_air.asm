
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
  800044:	e8 b4 24 00 00       	call   8024fd <sys_getenvid>
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
  80007c:	bb f2 48 80 00       	mov    $0x8048f2,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  800094:	bb fc 48 80 00       	mov    $0x8048fc,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4b ff ff ff    	lea    -0xb5(%ebp),%eax
  8000ac:	bb 08 49 80 00       	mov    $0x804908,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000c4:	bb 17 49 80 00       	mov    $0x804917,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8000dc:	bb 26 49 80 00       	mov    $0x804926,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 12 ff ff ff    	lea    -0xee(%ebp),%eax
  8000f4:	bb 3b 49 80 00       	mov    $0x80493b,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 01 ff ff ff    	lea    -0xff(%ebp),%eax
  80010c:	bb 50 49 80 00       	mov    $0x804950,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	bb 61 49 80 00       	mov    $0x804961,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 df fe ff ff    	lea    -0x121(%ebp),%eax
  80013c:	bb 72 49 80 00       	mov    $0x804972,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 d6 fe ff ff    	lea    -0x12a(%ebp),%eax
  800154:	bb 83 49 80 00       	mov    $0x804983,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  80016c:	bb 8c 49 80 00       	mov    $0x80498c,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c1 fe ff ff    	lea    -0x13f(%ebp),%eax
  800184:	bb 96 49 80 00       	mov    $0x804996,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b5 fe ff ff    	lea    -0x14b(%ebp),%eax
  80019c:	bb a1 49 80 00       	mov    $0x8049a1,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 ab fe ff ff    	lea    -0x155(%ebp),%eax
  8001b4:	bb ad 49 80 00       	mov    $0x8049ad,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a1 fe ff ff    	lea    -0x15f(%ebp),%eax
  8001cc:	bb b7 49 80 00       	mov    $0x8049b7,%ebx
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
  8001f7:	bb c1 49 80 00       	mov    $0x8049c1,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 7e fe ff ff    	lea    -0x182(%ebp),%eax
  80020f:	bb cf 49 80 00       	mov    $0x8049cf,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800227:	bb de 49 80 00       	mov    $0x8049de,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 70 fe ff ff    	lea    -0x190(%ebp),%eax
  80023f:	bb e5 49 80 00       	mov    $0x8049e5,%ebx
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
  800499:	e8 51 3e 00 00       	call   8042ef <create_semaphore>
  80049e:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  8004a1:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	6a 01                	push   $0x1
  8004ac:	8d 95 a1 fe ff ff    	lea    -0x15f(%ebp),%edx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	e8 36 3e 00 00       	call   8042ef <create_semaphore>
  8004b9:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  8004bc:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  8004c2:	83 ec 04             	sub    $0x4,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 95 8d fe ff ff    	lea    -0x173(%ebp),%edx
  8004cd:	52                   	push   %edx
  8004ce:	50                   	push   %eax
  8004cf:	e8 1b 3e 00 00       	call   8042ef <create_semaphore>
  8004d4:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  8004d7:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	6a 01                	push   $0x1
  8004e2:	8d 95 b5 fe ff ff    	lea    -0x14b(%ebp),%edx
  8004e8:	52                   	push   %edx
  8004e9:	50                   	push   %eax
  8004ea:	e8 00 3e 00 00       	call   8042ef <create_semaphore>
  8004ef:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  8004f2:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  8004f8:	83 ec 04             	sub    $0x4,%esp
  8004fb:	6a 03                	push   $0x3
  8004fd:	8d 95 9b fe ff ff    	lea    -0x165(%ebp),%edx
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	e8 e5 3d 00 00       	call   8042ef <create_semaphore>
  80050a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  80050d:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800513:	83 ec 04             	sub    $0x4,%esp
  800516:	6a 00                	push   $0x0
  800518:	8d 95 c1 fe ff ff    	lea    -0x13f(%ebp),%edx
  80051e:	52                   	push   %edx
  80051f:	50                   	push   %eax
  800520:	e8 ca 3d 00 00       	call   8042ef <create_semaphore>
  800525:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  800528:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	6a 00                	push   $0x0
  800533:	8d 95 7e fe ff ff    	lea    -0x182(%ebp),%edx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 af 3d 00 00       	call   8042ef <create_semaphore>
  800540:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  800543:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800546:	c1 e0 02             	shl    $0x2,%eax
  800549:	83 ec 04             	sub    $0x4,%esp
  80054c:	6a 01                	push   $0x1
  80054e:	50                   	push   %eax
  80054f:	68 80 46 80 00       	push   $0x804680
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
  80057b:	bb ec 49 80 00       	mov    $0x8049ec,%ebx
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
  8005fc:	e8 ee 3c 00 00       	call   8042ef <create_semaphore>
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
  800648:	e8 5b 1e 00 00       	call   8024a8 <sys_create_env>
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  800656:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 61 1e 00 00       	call   8024c6 <sys_run_env>
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
  800695:	e8 0e 1e 00 00       	call   8024a8 <sys_create_env>
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006a3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	50                   	push   %eax
  8006ad:	e8 14 1e 00 00       	call   8024c6 <sys_run_env>
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
  8006e2:	e8 c1 1d 00 00       	call   8024a8 <sys_create_env>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	sys_run_env(envId);
  8006f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	50                   	push   %eax
  8006fa:	e8 c7 1d 00 00       	call   8024c6 <sys_run_env>
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
  800738:	e8 6b 1d 00 00       	call   8024a8 <sys_create_env>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800746:	83 bd 70 ff ff ff ef 	cmpl   $0xffffffef,-0x90(%ebp)
  80074d:	75 17                	jne    800766 <_main+0x72e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	68 94 46 80 00       	push   $0x804694
  800757:	68 98 00 00 00       	push   $0x98
  80075c:	68 da 46 80 00       	push   $0x8046da
  800761:	e8 2b 05 00 00       	call   800c91 <_panic>

		sys_run_env(envId);
  800766:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	50                   	push   %eax
  800770:	e8 51 1d 00 00       	call   8024c6 <sys_run_env>
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
  800795:	e8 89 3b 00 00       	call   804323 <wait_semaphore>
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
  8007b0:	e8 ad 3b 00 00       	call   804362 <env_sleep>
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
  8007f6:	68 ec 46 80 00       	push   $0x8046ec
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
  80084e:	68 1c 47 80 00       	push   $0x80471c
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
  80088d:	68 4c 47 80 00       	push   $0x80474c
  800892:	68 b8 00 00 00       	push   $0xb8
  800897:	68 da 46 80 00       	push   $0x8046da
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
  8008d0:	68 4c 47 80 00       	push   $0x80474c
  8008d5:	68 c1 00 00 00       	push   $0xc1
  8008da:	68 da 46 80 00       	push   $0x8046da
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
  800931:	68 4c 47 80 00       	push   $0x80474c
  800936:	68 ca 00 00 00       	push   $0xca
  80093b:	68 da 46 80 00       	push   $0x8046da
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
  80095e:	e8 f4 39 00 00       	call   804357 <semaphore_count>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	83 f8 01             	cmp    $0x1,%eax
  800969:	74 19                	je     800984 <_main+0x94c>
  80096b:	68 70 47 80 00       	push   $0x804770
  800970:	68 90 47 80 00       	push   $0x804790
  800975:	68 ce 00 00 00       	push   $0xce
  80097a:	68 da 46 80 00       	push   $0x8046da
  80097f:	e8 0d 03 00 00       	call   800c91 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80098d:	e8 c5 39 00 00       	call   804357 <semaphore_count>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	83 f8 01             	cmp    $0x1,%eax
  800998:	74 19                	je     8009b3 <_main+0x97b>
  80099a:	68 a8 47 80 00       	push   $0x8047a8
  80099f:	68 90 47 80 00       	push   $0x804790
  8009a4:	68 cf 00 00 00       	push   $0xcf
  8009a9:	68 da 46 80 00       	push   $0x8046da
  8009ae:	e8 de 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8009bc:	e8 96 39 00 00       	call   804357 <semaphore_count>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	83 f8 01             	cmp    $0x1,%eax
  8009c7:	74 19                	je     8009e2 <_main+0x9aa>
  8009c9:	68 c8 47 80 00       	push   $0x8047c8
  8009ce:	68 90 47 80 00       	push   $0x804790
  8009d3:	68 d1 00 00 00       	push   $0xd1
  8009d8:	68 da 46 80 00       	push   $0x8046da
  8009dd:	e8 af 02 00 00       	call   800c91 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8009eb:	e8 67 39 00 00       	call   804357 <semaphore_count>
  8009f0:	83 c4 10             	add    $0x10,%esp
  8009f3:	83 f8 01             	cmp    $0x1,%eax
  8009f6:	74 19                	je     800a11 <_main+0x9d9>
  8009f8:	68 ec 47 80 00       	push   $0x8047ec
  8009fd:	68 90 47 80 00       	push   $0x804790
  800a02:	68 d2 00 00 00       	push   $0xd2
  800a07:	68 da 46 80 00       	push   $0x8046da
  800a0c:	e8 80 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800a11:	83 ec 0c             	sub    $0xc,%esp
  800a14:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800a1a:	e8 38 39 00 00       	call   804357 <semaphore_count>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	83 f8 03             	cmp    $0x3,%eax
  800a25:	74 19                	je     800a40 <_main+0xa08>
  800a27:	68 0e 48 80 00       	push   $0x80480e
  800a2c:	68 90 47 80 00       	push   $0x804790
  800a31:	68 d4 00 00 00       	push   $0xd4
  800a36:	68 da 46 80 00       	push   $0x8046da
  800a3b:	e8 51 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800a40:	83 ec 0c             	sub    $0xc,%esp
  800a43:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800a49:	e8 09 39 00 00       	call   804357 <semaphore_count>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800a54:	74 19                	je     800a6f <_main+0xa37>
  800a56:	68 2c 48 80 00       	push   $0x80482c
  800a5b:	68 90 47 80 00       	push   $0x804790
  800a60:	68 d6 00 00 00       	push   $0xd6
  800a65:	68 da 46 80 00       	push   $0x8046da
  800a6a:	e8 22 02 00 00       	call   800c91 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  800a78:	e8 da 38 00 00       	call   804357 <semaphore_count>
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	85 c0                	test   %eax,%eax
  800a82:	74 19                	je     800a9d <_main+0xa65>
  800a84:	68 50 48 80 00       	push   $0x804850
  800a89:	68 90 47 80 00       	push   $0x804790
  800a8e:	68 d8 00 00 00       	push   $0xd8
  800a93:	68 da 46 80 00       	push   $0x8046da
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
  800ac4:	e8 8e 38 00 00       	call   804357 <semaphore_count>
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	85 c0                	test   %eax,%eax
  800ace:	74 19                	je     800ae9 <_main+0xab1>
  800ad0:	68 78 48 80 00       	push   $0x804878
  800ad5:	68 90 47 80 00       	push   $0x804790
  800ada:	68 e2 00 00 00       	push   $0xe2
  800adf:	68 da 46 80 00       	push   $0x8046da
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
  800af7:	68 a0 48 80 00       	push   $0x8048a0
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
  800b58:	e8 b9 19 00 00       	call   802516 <sys_getenvindex>
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
  800bc6:	e8 cf 16 00 00       	call   80229a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	68 24 4a 80 00       	push   $0x804a24
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
  800bf6:	68 4c 4a 80 00       	push   $0x804a4c
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
  800c27:	68 74 4a 80 00       	push   $0x804a74
  800c2c:	e8 1d 03 00 00       	call   800f4e <cprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c34:	a1 20 60 80 00       	mov    0x806020,%eax
  800c39:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	50                   	push   %eax
  800c43:	68 cc 4a 80 00       	push   $0x804acc
  800c48:	e8 01 03 00 00       	call   800f4e <cprintf>
  800c4d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	68 24 4a 80 00       	push   $0x804a24
  800c58:	e8 f1 02 00 00       	call   800f4e <cprintf>
  800c5d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800c60:	e8 4f 16 00 00       	call   8022b4 <sys_unlock_cons>
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
  800c78:	e8 65 18 00 00       	call   8024e2 <sys_destroy_env>
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
  800c89:	e8 ba 18 00 00       	call   802548 <sys_exit_env>
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
  800cb2:	68 e0 4a 80 00       	push   $0x804ae0
  800cb7:	e8 92 02 00 00       	call   800f4e <cprintf>
  800cbc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cbf:	a1 00 60 80 00       	mov    0x806000,%eax
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	ff 75 08             	pushl  0x8(%ebp)
  800cca:	50                   	push   %eax
  800ccb:	68 e5 4a 80 00       	push   $0x804ae5
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
  800cef:	68 01 4b 80 00       	push   $0x804b01
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
  800d1e:	68 04 4b 80 00       	push   $0x804b04
  800d23:	6a 26                	push   $0x26
  800d25:	68 50 4b 80 00       	push   $0x804b50
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
  800df3:	68 5c 4b 80 00       	push   $0x804b5c
  800df8:	6a 3a                	push   $0x3a
  800dfa:	68 50 4b 80 00       	push   $0x804b50
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
  800e66:	68 b0 4b 80 00       	push   $0x804bb0
  800e6b:	6a 44                	push   $0x44
  800e6d:	68 50 4b 80 00       	push   $0x804b50
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
  800ec0:	e8 93 13 00 00       	call   802258 <sys_cputs>
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
  800f37:	e8 1c 13 00 00       	call   802258 <sys_cputs>
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
  800f81:	e8 14 13 00 00       	call   80229a <sys_lock_cons>
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
  800fa1:	e8 0e 13 00 00       	call   8022b4 <sys_unlock_cons>
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
  800feb:	e8 28 34 00 00       	call   804418 <__udivdi3>
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
  80103b:	e8 e8 34 00 00       	call   804528 <__umoddi3>
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	05 14 4e 80 00       	add    $0x804e14,%eax
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
  801196:	8b 04 85 38 4e 80 00 	mov    0x804e38(,%eax,4),%eax
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
  801277:	8b 34 9d 80 4c 80 00 	mov    0x804c80(,%ebx,4),%esi
  80127e:	85 f6                	test   %esi,%esi
  801280:	75 19                	jne    80129b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801282:	53                   	push   %ebx
  801283:	68 25 4e 80 00       	push   $0x804e25
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
  80129c:	68 2e 4e 80 00       	push   $0x804e2e
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
  8012c9:	be 31 4e 80 00       	mov    $0x804e31,%esi
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
  801cd4:	68 a8 4f 80 00       	push   $0x804fa8
  801cd9:	68 3f 01 00 00       	push   $0x13f
  801cde:	68 ca 4f 80 00       	push   $0x804fca
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
  801cf4:	e8 0a 0b 00 00       	call   802803 <sys_sbrk>
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
  801d6f:	e8 13 09 00 00       	call   802687 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	74 16                	je     801d8e <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 53 0e 00 00       	call   802bd6 <alloc_block_FF>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d89:	e9 8a 01 00 00       	jmp    801f18 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d8e:	e8 25 09 00 00       	call   8026b8 <sys_isUHeapPlacementStrategyBESTFIT>
  801d93:	85 c0                	test   %eax,%eax
  801d95:	0f 84 7d 01 00 00    	je     801f18 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 ec 12 00 00       	call   803092 <alloc_block_BF>
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
  801f07:	e8 2e 09 00 00       	call   80283a <sys_allocate_user_mem>
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
  801f4f:	e8 02 09 00 00       	call   802856 <get_block_size>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	ff 75 08             	pushl  0x8(%ebp)
  801f60:	e8 35 1b 00 00       	call   803a9a <free_block>
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
  801ff7:	e8 22 08 00 00       	call   80281e <sys_free_user_mem>
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
  802005:	68 d8 4f 80 00       	push   $0x804fd8
  80200a:	68 85 00 00 00       	push   $0x85
  80200f:	68 02 50 80 00       	push   $0x805002
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
  80207a:	e8 a6 03 00 00       	call   802425 <sys_createSharedObject>
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
  80209e:	68 0e 50 80 00       	push   $0x80500e
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
  8020e2:	e8 68 03 00 00       	call   80244f <sys_getSizeOfSharedObject>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020f1:	75 07                	jne    8020fa <sget+0x27>
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	eb 7f                	jmp    802179 <sget+0xa6>
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
  80212d:	eb 4a                	jmp    802179 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	ff 75 e8             	pushl  -0x18(%ebp)
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	ff 75 08             	pushl  0x8(%ebp)
  80213b:	e8 2c 03 00 00       	call   80246c <sys_getSharedObject>
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802146:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802149:	a1 20 60 80 00       	mov    0x806020,%eax
  80214e:	8b 40 78             	mov    0x78(%eax),%eax
  802151:	29 c2                	sub    %eax,%edx
  802153:	89 d0                	mov    %edx,%eax
  802155:	2d 00 10 00 00       	sub    $0x1000,%eax
  80215a:	c1 e8 0c             	shr    $0xc,%eax
  80215d:	89 c2                	mov    %eax,%edx
  80215f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802162:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802169:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80216d:	75 07                	jne    802176 <sget+0xa3>
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	eb 03                	jmp    802179 <sget+0xa6>
	return ptr;
  802176:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802181:	8b 55 08             	mov    0x8(%ebp),%edx
  802184:	a1 20 60 80 00       	mov    0x806020,%eax
  802189:	8b 40 78             	mov    0x78(%eax),%eax
  80218c:	29 c2                	sub    %eax,%edx
  80218e:	89 d0                	mov    %edx,%eax
  802190:	2d 00 10 00 00       	sub    $0x1000,%eax
  802195:	c1 e8 0c             	shr    $0xc,%eax
  802198:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80219f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8021a2:	83 ec 08             	sub    $0x8,%esp
  8021a5:	ff 75 08             	pushl  0x8(%ebp)
  8021a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ab:	e8 db 02 00 00       	call   80248b <sys_freeSharedObject>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8021b6:	90                   	nop
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 20 50 80 00       	push   $0x805020
  8021c7:	68 de 00 00 00       	push   $0xde
  8021cc:	68 02 50 80 00       	push   $0x805002
  8021d1:	e8 bb ea ff ff       	call   800c91 <_panic>

008021d6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 46 50 80 00       	push   $0x805046
  8021e4:	68 ea 00 00 00       	push   $0xea
  8021e9:	68 02 50 80 00       	push   $0x805002
  8021ee:	e8 9e ea ff ff       	call   800c91 <_panic>

008021f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 46 50 80 00       	push   $0x805046
  802201:	68 ef 00 00 00       	push   $0xef
  802206:	68 02 50 80 00       	push   $0x805002
  80220b:	e8 81 ea ff ff       	call   800c91 <_panic>

00802210 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 46 50 80 00       	push   $0x805046
  80221e:	68 f4 00 00 00       	push   $0xf4
  802223:	68 02 50 80 00       	push   $0x805002
  802228:	e8 64 ea ff ff       	call   800c91 <_panic>

0080222d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	57                   	push   %edi
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802242:	8b 7d 18             	mov    0x18(%ebp),%edi
  802245:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802248:	cd 30                	int    $0x30
  80224a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5f                   	pop    %edi
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 04             	sub    $0x4,%esp
  80225e:	8b 45 10             	mov    0x10(%ebp),%eax
  802261:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802264:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	52                   	push   %edx
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	6a 00                	push   $0x0
  802276:	e8 b2 ff ff ff       	call   80222d <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	90                   	nop
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_cgetc>:

int
sys_cgetc(void)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 02                	push   $0x2
  802290:	e8 98 ff ff ff       	call   80222d <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 03                	push   $0x3
  8022a9:	e8 7f ff ff ff       	call   80222d <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	90                   	nop
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 04                	push   $0x4
  8022c3:	e8 65 ff ff ff       	call   80222d <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
}
  8022cb:	90                   	nop
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	52                   	push   %edx
  8022de:	50                   	push   %eax
  8022df:	6a 08                	push   $0x8
  8022e1:	e8 47 ff ff ff       	call   80222d <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	56                   	push   %esi
  8022ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8022f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	56                   	push   %esi
  802300:	53                   	push   %ebx
  802301:	51                   	push   %ecx
  802302:	52                   	push   %edx
  802303:	50                   	push   %eax
  802304:	6a 09                	push   $0x9
  802306:	e8 22 ff ff ff       	call   80222d <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    

00802315 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	6a 0a                	push   $0xa
  802328:	e8 00 ff ff ff       	call   80222d <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	ff 75 08             	pushl  0x8(%ebp)
  802341:	6a 0b                	push   $0xb
  802343:	e8 e5 fe ff ff       	call   80222d <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 0c                	push   $0xc
  80235c:	e8 cc fe ff ff       	call   80222d <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 0d                	push   $0xd
  802375:	e8 b3 fe ff ff       	call   80222d <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 0e                	push   $0xe
  80238e:	e8 9a fe ff ff       	call   80222d <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 0f                	push   $0xf
  8023a7:	e8 81 fe ff ff       	call   80222d <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	ff 75 08             	pushl  0x8(%ebp)
  8023bf:	6a 10                	push   $0x10
  8023c1:	e8 67 fe ff ff       	call   80222d <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 11                	push   $0x11
  8023da:	e8 4e fe ff ff       	call   80222d <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
}
  8023e2:	90                   	nop
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 04             	sub    $0x4,%esp
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	50                   	push   %eax
  8023fe:	6a 01                	push   $0x1
  802400:	e8 28 fe ff ff       	call   80222d <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	90                   	nop
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 14                	push   $0x14
  80241a:	e8 0e fe ff ff       	call   80222d <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	90                   	nop
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	8b 45 10             	mov    0x10(%ebp),%eax
  80242e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802431:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802434:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	6a 00                	push   $0x0
  80243d:	51                   	push   %ecx
  80243e:	52                   	push   %edx
  80243f:	ff 75 0c             	pushl  0xc(%ebp)
  802442:	50                   	push   %eax
  802443:	6a 15                	push   $0x15
  802445:	e8 e3 fd ff ff       	call   80222d <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802452:	8b 55 0c             	mov    0xc(%ebp),%edx
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	52                   	push   %edx
  80245f:	50                   	push   %eax
  802460:	6a 16                	push   $0x16
  802462:	e8 c6 fd ff ff       	call   80222d <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80246f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	51                   	push   %ecx
  80247d:	52                   	push   %edx
  80247e:	50                   	push   %eax
  80247f:	6a 17                	push   $0x17
  802481:	e8 a7 fd ff ff       	call   80222d <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80248e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	52                   	push   %edx
  80249b:	50                   	push   %eax
  80249c:	6a 18                	push   $0x18
  80249e:	e8 8a fd ff ff       	call   80222d <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	ff 75 14             	pushl  0x14(%ebp)
  8024b3:	ff 75 10             	pushl  0x10(%ebp)
  8024b6:	ff 75 0c             	pushl  0xc(%ebp)
  8024b9:	50                   	push   %eax
  8024ba:	6a 19                	push   $0x19
  8024bc:	e8 6c fd ff ff       	call   80222d <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	50                   	push   %eax
  8024d5:	6a 1a                	push   $0x1a
  8024d7:	e8 51 fd ff ff       	call   80222d <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	90                   	nop
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	50                   	push   %eax
  8024f1:	6a 1b                	push   $0x1b
  8024f3:	e8 35 fd ff ff       	call   80222d <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 05                	push   $0x5
  80250c:	e8 1c fd ff ff       	call   80222d <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 06                	push   $0x6
  802525:	e8 03 fd ff ff       	call   80222d <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 07                	push   $0x7
  80253e:	e8 ea fc ff ff       	call   80222d <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_exit_env>:


void sys_exit_env(void)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 1c                	push   $0x1c
  802557:	e8 d1 fc ff ff       	call   80222d <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	90                   	nop
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802568:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80256b:	8d 50 04             	lea    0x4(%eax),%edx
  80256e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	52                   	push   %edx
  802578:	50                   	push   %eax
  802579:	6a 1d                	push   $0x1d
  80257b:	e8 ad fc ff ff       	call   80222d <syscall>
  802580:	83 c4 18             	add    $0x18,%esp
	return result;
  802583:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802586:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802589:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80258c:	89 01                	mov    %eax,(%ecx)
  80258e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	c9                   	leave  
  802595:	c2 04 00             	ret    $0x4

00802598 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	ff 75 10             	pushl  0x10(%ebp)
  8025a2:	ff 75 0c             	pushl  0xc(%ebp)
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	6a 13                	push   $0x13
  8025aa:	e8 7e fc ff ff       	call   80222d <syscall>
  8025af:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b2:	90                   	nop
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 1e                	push   $0x1e
  8025c4:	e8 64 fc ff ff       	call   80222d <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	50                   	push   %eax
  8025e7:	6a 1f                	push   $0x1f
  8025e9:	e8 3f fc ff ff       	call   80222d <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f1:	90                   	nop
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <rsttst>:
void rsttst()
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 21                	push   $0x21
  802603:	e8 25 fc ff ff       	call   80222d <syscall>
  802608:	83 c4 18             	add    $0x18,%esp
	return ;
  80260b:	90                   	nop
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	8b 45 14             	mov    0x14(%ebp),%eax
  802617:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80261a:	8b 55 18             	mov    0x18(%ebp),%edx
  80261d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802621:	52                   	push   %edx
  802622:	50                   	push   %eax
  802623:	ff 75 10             	pushl  0x10(%ebp)
  802626:	ff 75 0c             	pushl  0xc(%ebp)
  802629:	ff 75 08             	pushl  0x8(%ebp)
  80262c:	6a 20                	push   $0x20
  80262e:	e8 fa fb ff ff       	call   80222d <syscall>
  802633:	83 c4 18             	add    $0x18,%esp
	return ;
  802636:	90                   	nop
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <chktst>:
void chktst(uint32 n)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	ff 75 08             	pushl  0x8(%ebp)
  802647:	6a 22                	push   $0x22
  802649:	e8 df fb ff ff       	call   80222d <syscall>
  80264e:	83 c4 18             	add    $0x18,%esp
	return ;
  802651:	90                   	nop
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <inctst>:

void inctst()
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 23                	push   $0x23
  802663:	e8 c5 fb ff ff       	call   80222d <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
	return ;
  80266b:	90                   	nop
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <gettst>:
uint32 gettst()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 24                	push   $0x24
  80267d:	e8 ab fb ff ff       	call   80222d <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 25                	push   $0x25
  802699:	e8 8f fb ff ff       	call   80222d <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
  8026a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026a8:	75 07                	jne    8026b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8026af:	eb 05                	jmp    8026b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 25                	push   $0x25
  8026ca:	e8 5e fb ff ff       	call   80222d <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
  8026d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026d9:	75 07                	jne    8026e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026db:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e0:	eb 05                	jmp    8026e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 25                	push   $0x25
  8026fb:	e8 2d fb ff ff       	call   80222d <syscall>
  802700:	83 c4 18             	add    $0x18,%esp
  802703:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802706:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80270a:	75 07                	jne    802713 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80270c:	b8 01 00 00 00       	mov    $0x1,%eax
  802711:	eb 05                	jmp    802718 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 25                	push   $0x25
  80272c:	e8 fc fa ff ff       	call   80222d <syscall>
  802731:	83 c4 18             	add    $0x18,%esp
  802734:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802737:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80273b:	75 07                	jne    802744 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80273d:	b8 01 00 00 00       	mov    $0x1,%eax
  802742:	eb 05                	jmp    802749 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	ff 75 08             	pushl  0x8(%ebp)
  802759:	6a 26                	push   $0x26
  80275b:	e8 cd fa ff ff       	call   80222d <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
	return ;
  802763:	90                   	nop
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80276a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80276d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802770:	8b 55 0c             	mov    0xc(%ebp),%edx
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	6a 00                	push   $0x0
  802778:	53                   	push   %ebx
  802779:	51                   	push   %ecx
  80277a:	52                   	push   %edx
  80277b:	50                   	push   %eax
  80277c:	6a 27                	push   $0x27
  80277e:	e8 aa fa ff ff       	call   80222d <syscall>
  802783:	83 c4 18             	add    $0x18,%esp
}
  802786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80278e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802791:	8b 45 08             	mov    0x8(%ebp),%eax
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	52                   	push   %edx
  80279b:	50                   	push   %eax
  80279c:	6a 28                	push   $0x28
  80279e:	e8 8a fa ff ff       	call   80222d <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
}
  8027a6:	c9                   	leave  
  8027a7:	c3                   	ret    

008027a8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8027ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8027ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	6a 00                	push   $0x0
  8027b6:	51                   	push   %ecx
  8027b7:	ff 75 10             	pushl  0x10(%ebp)
  8027ba:	52                   	push   %edx
  8027bb:	50                   	push   %eax
  8027bc:	6a 29                	push   $0x29
  8027be:	e8 6a fa ff ff       	call   80222d <syscall>
  8027c3:	83 c4 18             	add    $0x18,%esp
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	ff 75 10             	pushl  0x10(%ebp)
  8027d2:	ff 75 0c             	pushl  0xc(%ebp)
  8027d5:	ff 75 08             	pushl  0x8(%ebp)
  8027d8:	6a 12                	push   $0x12
  8027da:	e8 4e fa ff ff       	call   80222d <syscall>
  8027df:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e2:	90                   	nop
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8027e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	52                   	push   %edx
  8027f5:	50                   	push   %eax
  8027f6:	6a 2a                	push   $0x2a
  8027f8:	e8 30 fa ff ff       	call   80222d <syscall>
  8027fd:	83 c4 18             	add    $0x18,%esp
	return;
  802800:	90                   	nop
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	50                   	push   %eax
  802812:	6a 2b                	push   $0x2b
  802814:	e8 14 fa ff ff       	call   80222d <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
}
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	ff 75 0c             	pushl  0xc(%ebp)
  80282a:	ff 75 08             	pushl  0x8(%ebp)
  80282d:	6a 2c                	push   $0x2c
  80282f:	e8 f9 f9 ff ff       	call   80222d <syscall>
  802834:	83 c4 18             	add    $0x18,%esp
	return;
  802837:	90                   	nop
}
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	ff 75 0c             	pushl  0xc(%ebp)
  802846:	ff 75 08             	pushl  0x8(%ebp)
  802849:	6a 2d                	push   $0x2d
  80284b:	e8 dd f9 ff ff       	call   80222d <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
	return;
  802853:	90                   	nop
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	83 e8 04             	sub    $0x4,%eax
  802862:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802865:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 e8 04             	sub    $0x4,%eax
  80287b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80287e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	83 e0 01             	and    $0x1,%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	0f 94 c0             	sete   %al
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80289a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289d:	83 f8 02             	cmp    $0x2,%eax
  8028a0:	74 2b                	je     8028cd <alloc_block+0x40>
  8028a2:	83 f8 02             	cmp    $0x2,%eax
  8028a5:	7f 07                	jg     8028ae <alloc_block+0x21>
  8028a7:	83 f8 01             	cmp    $0x1,%eax
  8028aa:	74 0e                	je     8028ba <alloc_block+0x2d>
  8028ac:	eb 58                	jmp    802906 <alloc_block+0x79>
  8028ae:	83 f8 03             	cmp    $0x3,%eax
  8028b1:	74 2d                	je     8028e0 <alloc_block+0x53>
  8028b3:	83 f8 04             	cmp    $0x4,%eax
  8028b6:	74 3b                	je     8028f3 <alloc_block+0x66>
  8028b8:	eb 4c                	jmp    802906 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8028ba:	83 ec 0c             	sub    $0xc,%esp
  8028bd:	ff 75 08             	pushl  0x8(%ebp)
  8028c0:	e8 11 03 00 00       	call   802bd6 <alloc_block_FF>
  8028c5:	83 c4 10             	add    $0x10,%esp
  8028c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028cb:	eb 4a                	jmp    802917 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028cd:	83 ec 0c             	sub    $0xc,%esp
  8028d0:	ff 75 08             	pushl  0x8(%ebp)
  8028d3:	e8 fa 19 00 00       	call   8042d2 <alloc_block_NF>
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028de:	eb 37                	jmp    802917 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	ff 75 08             	pushl  0x8(%ebp)
  8028e6:	e8 a7 07 00 00       	call   803092 <alloc_block_BF>
  8028eb:	83 c4 10             	add    $0x10,%esp
  8028ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028f1:	eb 24                	jmp    802917 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	ff 75 08             	pushl  0x8(%ebp)
  8028f9:	e8 b7 19 00 00       	call   8042b5 <alloc_block_WF>
  8028fe:	83 c4 10             	add    $0x10,%esp
  802901:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802904:	eb 11                	jmp    802917 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802906:	83 ec 0c             	sub    $0xc,%esp
  802909:	68 58 50 80 00       	push   $0x805058
  80290e:	e8 3b e6 ff ff       	call   800f4e <cprintf>
  802913:	83 c4 10             	add    $0x10,%esp
		break;
  802916:	90                   	nop
	}
	return va;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	53                   	push   %ebx
  802920:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	68 78 50 80 00       	push   $0x805078
  80292b:	e8 1e e6 ff ff       	call   800f4e <cprintf>
  802930:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	68 a3 50 80 00       	push   $0x8050a3
  80293b:	e8 0e e6 ff ff       	call   800f4e <cprintf>
  802940:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802949:	eb 37                	jmp    802982 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80294b:	83 ec 0c             	sub    $0xc,%esp
  80294e:	ff 75 f4             	pushl  -0xc(%ebp)
  802951:	e8 19 ff ff ff       	call   80286f <is_free_block>
  802956:	83 c4 10             	add    $0x10,%esp
  802959:	0f be d8             	movsbl %al,%ebx
  80295c:	83 ec 0c             	sub    $0xc,%esp
  80295f:	ff 75 f4             	pushl  -0xc(%ebp)
  802962:	e8 ef fe ff ff       	call   802856 <get_block_size>
  802967:	83 c4 10             	add    $0x10,%esp
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	53                   	push   %ebx
  80296e:	50                   	push   %eax
  80296f:	68 bb 50 80 00       	push   $0x8050bb
  802974:	e8 d5 e5 ff ff       	call   800f4e <cprintf>
  802979:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80297c:	8b 45 10             	mov    0x10(%ebp),%eax
  80297f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802986:	74 07                	je     80298f <print_blocks_list+0x73>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	eb 05                	jmp    802994 <print_blocks_list+0x78>
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	89 45 10             	mov    %eax,0x10(%ebp)
  802997:	8b 45 10             	mov    0x10(%ebp),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	75 ad                	jne    80294b <print_blocks_list+0x2f>
  80299e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a2:	75 a7                	jne    80294b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8029a4:	83 ec 0c             	sub    $0xc,%esp
  8029a7:	68 78 50 80 00       	push   $0x805078
  8029ac:	e8 9d e5 ff ff       	call   800f4e <cprintf>
  8029b1:	83 c4 10             	add    $0x10,%esp

}
  8029b4:	90                   	nop
  8029b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8029c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c3:	83 e0 01             	and    $0x1,%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 03                	je     8029cd <initialize_dynamic_allocator+0x13>
  8029ca:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8029cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029d1:	0f 84 c7 01 00 00    	je     802b9e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8029d7:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8029de:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8029e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e7:	01 d0                	add    %edx,%eax
  8029e9:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8029ee:	0f 87 ad 01 00 00    	ja     802ba1 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	0f 89 a5 01 00 00    	jns    802ba4 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8029ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a05:	01 d0                	add    %edx,%eax
  802a07:	83 e8 04             	sub    $0x4,%eax
  802a0a:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802a0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802a16:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1e:	e9 87 00 00 00       	jmp    802aaa <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a27:	75 14                	jne    802a3d <initialize_dynamic_allocator+0x83>
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	68 d3 50 80 00       	push   $0x8050d3
  802a31:	6a 79                	push   $0x79
  802a33:	68 f1 50 80 00       	push   $0x8050f1
  802a38:	e8 54 e2 ff ff       	call   800c91 <_panic>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 10                	je     802a56 <initialize_dynamic_allocator+0x9c>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4e:	8b 52 04             	mov    0x4(%edx),%edx
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	eb 0b                	jmp    802a61 <initialize_dynamic_allocator+0xa7>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	a3 30 60 80 00       	mov    %eax,0x806030
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0f                	je     802a7a <initialize_dynamic_allocator+0xc0>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	8b 12                	mov    (%edx),%edx
  802a76:	89 10                	mov    %edx,(%eax)
  802a78:	eb 0a                	jmp    802a84 <initialize_dynamic_allocator+0xca>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a97:	a1 38 60 80 00       	mov    0x806038,%eax
  802a9c:	48                   	dec    %eax
  802a9d:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802aa2:	a1 34 60 80 00       	mov    0x806034,%eax
  802aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aae:	74 07                	je     802ab7 <initialize_dynamic_allocator+0xfd>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	eb 05                	jmp    802abc <initialize_dynamic_allocator+0x102>
  802ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  802abc:	a3 34 60 80 00       	mov    %eax,0x806034
  802ac1:	a1 34 60 80 00       	mov    0x806034,%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	0f 85 55 ff ff ff    	jne    802a23 <initialize_dynamic_allocator+0x69>
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad2:	0f 85 4b ff ff ff    	jne    802a23 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802ae7:	a1 44 60 80 00       	mov    0x806044,%eax
  802aec:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802af1:	a1 40 60 80 00       	mov    0x806040,%eax
  802af6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	83 c0 08             	add    $0x8,%eax
  802b02:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	83 c0 04             	add    $0x4,%eax
  802b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0e:	83 ea 08             	sub    $0x8,%edx
  802b11:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	83 e8 08             	sub    $0x8,%eax
  802b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b21:	83 ea 08             	sub    $0x8,%edx
  802b24:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802b39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b3d:	75 17                	jne    802b56 <initialize_dynamic_allocator+0x19c>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 0c 51 80 00       	push   $0x80510c
  802b47:	68 90 00 00 00       	push   $0x90
  802b4c:	68 f1 50 80 00       	push   $0x8050f1
  802b51:	e8 3b e1 ff ff       	call   800c91 <_panic>
  802b56:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5f:	89 10                	mov    %edx,(%eax)
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0d                	je     802b77 <initialize_dynamic_allocator+0x1bd>
  802b6a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 08                	jmp    802b7f <initialize_dynamic_allocator+0x1c5>
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	a3 30 60 80 00       	mov    %eax,0x806030
  802b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b82:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 38 60 80 00       	mov    0x806038,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 38 60 80 00       	mov    %eax,0x806038
  802b9c:	eb 07                	jmp    802ba5 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b9e:	90                   	nop
  802b9f:	eb 04                	jmp    802ba5 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802ba1:	90                   	nop
  802ba2:	eb 01                	jmp    802ba5 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802ba4:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802ba5:	c9                   	leave  
  802ba6:	c3                   	ret    

00802ba7 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802baa:	8b 45 10             	mov    0x10(%ebp),%eax
  802bad:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb9:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	83 e8 04             	sub    $0x4,%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	83 e0 fe             	and    $0xfffffffe,%eax
  802bc6:	8d 50 f8             	lea    -0x8(%eax),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	01 c2                	add    %eax,%edx
  802bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd1:	89 02                	mov    %eax,(%edx)
}
  802bd3:	90                   	nop
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    

00802bd6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	83 e0 01             	and    $0x1,%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 03                	je     802be9 <alloc_block_FF+0x13>
  802be6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802be9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802bed:	77 07                	ja     802bf6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802bef:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802bf6:	a1 24 60 80 00       	mov    0x806024,%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	75 73                	jne    802c72 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	83 c0 10             	add    $0x10,%eax
  802c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c08:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	48                   	dec    %eax
  802c18:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c23:	f7 75 ec             	divl   -0x14(%ebp)
  802c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c29:	29 d0                	sub    %edx,%eax
  802c2b:	c1 e8 0c             	shr    $0xc,%eax
  802c2e:	83 ec 0c             	sub    $0xc,%esp
  802c31:	50                   	push   %eax
  802c32:	e8 b1 f0 ff ff       	call   801ce8 <sbrk>
  802c37:	83 c4 10             	add    $0x10,%esp
  802c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	6a 00                	push   $0x0
  802c42:	e8 a1 f0 ff ff       	call   801ce8 <sbrk>
  802c47:	83 c4 10             	add    $0x10,%esp
  802c4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c50:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c53:	83 ec 08             	sub    $0x8,%esp
  802c56:	50                   	push   %eax
  802c57:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c5a:	e8 5b fd ff ff       	call   8029ba <initialize_dynamic_allocator>
  802c5f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c62:	83 ec 0c             	sub    $0xc,%esp
  802c65:	68 2f 51 80 00       	push   $0x80512f
  802c6a:	e8 df e2 ff ff       	call   800f4e <cprintf>
  802c6f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c76:	75 0a                	jne    802c82 <alloc_block_FF+0xac>
	        return NULL;
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	e9 0e 04 00 00       	jmp    803090 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c89:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	e9 f3 02 00 00       	jmp    802f89 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c9c:	83 ec 0c             	sub    $0xc,%esp
  802c9f:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca2:	e8 af fb ff ff       	call   802856 <get_block_size>
  802ca7:	83 c4 10             	add    $0x10,%esp
  802caa:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	83 c0 08             	add    $0x8,%eax
  802cb3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802cb6:	0f 87 c5 02 00 00    	ja     802f81 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	83 c0 18             	add    $0x18,%eax
  802cc2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802cc5:	0f 87 19 02 00 00    	ja     802ee4 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ccb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cce:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd1:	83 e8 08             	sub    $0x8,%eax
  802cd4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8d 50 08             	lea    0x8(%eax),%edx
  802cdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce0:	01 d0                	add    %edx,%eax
  802ce2:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	83 c0 08             	add    $0x8,%eax
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	6a 01                	push   $0x1
  802cf0:	50                   	push   %eax
  802cf1:	ff 75 bc             	pushl  -0x44(%ebp)
  802cf4:	e8 ae fe ff ff       	call   802ba7 <set_block_data>
  802cf9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	75 68                	jne    802d6e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d06:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d0a:	75 17                	jne    802d23 <alloc_block_FF+0x14d>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 0c 51 80 00       	push   $0x80510c
  802d14:	68 d7 00 00 00       	push   $0xd7
  802d19:	68 f1 50 80 00       	push   $0x8050f1
  802d1e:	e8 6e df ff ff       	call   800c91 <_panic>
  802d23:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802d29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <alloc_block_FF+0x16e>
  802d37:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802d3c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <alloc_block_FF+0x176>
  802d44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d47:	a3 30 60 80 00       	mov    %eax,0x806030
  802d4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d54:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 38 60 80 00       	mov    0x806038,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 38 60 80 00       	mov    %eax,0x806038
  802d69:	e9 dc 00 00 00       	jmp    802e4a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	75 65                	jne    802ddc <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d77:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d7b:	75 17                	jne    802d94 <alloc_block_FF+0x1be>
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 40 51 80 00       	push   $0x805140
  802d85:	68 db 00 00 00       	push   $0xdb
  802d8a:	68 f1 50 80 00       	push   $0x8050f1
  802d8f:	e8 fd de ff ff       	call   800c91 <_panic>
  802d94:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d9a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 0c                	je     802db6 <alloc_block_FF+0x1e0>
  802daa:	a1 30 60 80 00       	mov    0x806030,%eax
  802daf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802db2:	89 10                	mov    %edx,(%eax)
  802db4:	eb 08                	jmp    802dbe <alloc_block_FF+0x1e8>
  802db6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802dbe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc1:	a3 30 60 80 00       	mov    %eax,0x806030
  802dc6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcf:	a1 38 60 80 00       	mov    0x806038,%eax
  802dd4:	40                   	inc    %eax
  802dd5:	a3 38 60 80 00       	mov    %eax,0x806038
  802dda:	eb 6e                	jmp    802e4a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	74 06                	je     802de8 <alloc_block_FF+0x212>
  802de2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802de6:	75 17                	jne    802dff <alloc_block_FF+0x229>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 64 51 80 00       	push   $0x805164
  802df0:	68 df 00 00 00       	push   $0xdf
  802df5:	68 f1 50 80 00       	push   $0x8050f1
  802dfa:	e8 92 de ff ff       	call   800c91 <_panic>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 10                	mov    (%eax),%edx
  802e04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0b                	je     802e1d <alloc_block_FF+0x247>
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%eax)
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	75 08                	jne    802e3f <alloc_block_FF+0x269>
  802e37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e3a:	a3 30 60 80 00       	mov    %eax,0x806030
  802e3f:	a1 38 60 80 00       	mov    0x806038,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	75 17                	jne    802e67 <alloc_block_FF+0x291>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 d3 50 80 00       	push   $0x8050d3
  802e58:	68 e1 00 00 00       	push   $0xe1
  802e5d:	68 f1 50 80 00       	push   $0x8050f1
  802e62:	e8 2a de ff ff       	call   800c91 <_panic>
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 10                	je     802e80 <alloc_block_FF+0x2aa>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e78:	8b 52 04             	mov    0x4(%edx),%edx
  802e7b:	89 50 04             	mov    %edx,0x4(%eax)
  802e7e:	eb 0b                	jmp    802e8b <alloc_block_FF+0x2b5>
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	a3 30 60 80 00       	mov    %eax,0x806030
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0f                	je     802ea4 <alloc_block_FF+0x2ce>
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9e:	8b 12                	mov    (%edx),%edx
  802ea0:	89 10                	mov    %edx,(%eax)
  802ea2:	eb 0a                	jmp    802eae <alloc_block_FF+0x2d8>
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec1:	a1 38 60 80 00       	mov    0x806038,%eax
  802ec6:	48                   	dec    %eax
  802ec7:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	6a 00                	push   $0x0
  802ed1:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ed4:	ff 75 b0             	pushl  -0x50(%ebp)
  802ed7:	e8 cb fc ff ff       	call   802ba7 <set_block_data>
  802edc:	83 c4 10             	add    $0x10,%esp
  802edf:	e9 95 00 00 00       	jmp    802f79 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	6a 01                	push   $0x1
  802ee9:	ff 75 b8             	pushl  -0x48(%ebp)
  802eec:	ff 75 bc             	pushl  -0x44(%ebp)
  802eef:	e8 b3 fc ff ff       	call   802ba7 <set_block_data>
  802ef4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efb:	75 17                	jne    802f14 <alloc_block_FF+0x33e>
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	68 d3 50 80 00       	push   $0x8050d3
  802f05:	68 e8 00 00 00       	push   $0xe8
  802f0a:	68 f1 50 80 00       	push   $0x8050f1
  802f0f:	e8 7d dd ff ff       	call   800c91 <_panic>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	74 10                	je     802f2d <alloc_block_FF+0x357>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f25:	8b 52 04             	mov    0x4(%edx),%edx
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	eb 0b                	jmp    802f38 <alloc_block_FF+0x362>
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	a3 30 60 80 00       	mov    %eax,0x806030
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 0f                	je     802f51 <alloc_block_FF+0x37b>
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 40 04             	mov    0x4(%eax),%eax
  802f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4b:	8b 12                	mov    (%edx),%edx
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	eb 0a                	jmp    802f5b <alloc_block_FF+0x385>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6e:	a1 38 60 80 00       	mov    0x806038,%eax
  802f73:	48                   	dec    %eax
  802f74:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802f79:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f7c:	e9 0f 01 00 00       	jmp    803090 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f81:	a1 34 60 80 00       	mov    0x806034,%eax
  802f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8d:	74 07                	je     802f96 <alloc_block_FF+0x3c0>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	eb 05                	jmp    802f9b <alloc_block_FF+0x3c5>
  802f96:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9b:	a3 34 60 80 00       	mov    %eax,0x806034
  802fa0:	a1 34 60 80 00       	mov    0x806034,%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	0f 85 e9 fc ff ff    	jne    802c96 <alloc_block_FF+0xc0>
  802fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb1:	0f 85 df fc ff ff    	jne    802c96 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	83 c0 08             	add    $0x8,%eax
  802fbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802fc0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fcd:	01 d0                	add    %edx,%eax
  802fcf:	48                   	dec    %eax
  802fd0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802fd3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  802fdb:	f7 75 d8             	divl   -0x28(%ebp)
  802fde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fe1:	29 d0                	sub    %edx,%eax
  802fe3:	c1 e8 0c             	shr    $0xc,%eax
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	50                   	push   %eax
  802fea:	e8 f9 ec ff ff       	call   801ce8 <sbrk>
  802fef:	83 c4 10             	add    $0x10,%esp
  802ff2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ff5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ff9:	75 0a                	jne    803005 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  803000:	e9 8b 00 00 00       	jmp    803090 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803005:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80300c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80300f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803012:	01 d0                	add    %edx,%eax
  803014:	48                   	dec    %eax
  803015:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803018:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80301b:	ba 00 00 00 00       	mov    $0x0,%edx
  803020:	f7 75 cc             	divl   -0x34(%ebp)
  803023:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803026:	29 d0                	sub    %edx,%eax
  803028:	8d 50 fc             	lea    -0x4(%eax),%edx
  80302b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80302e:	01 d0                	add    %edx,%eax
  803030:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803035:	a1 40 60 80 00       	mov    0x806040,%eax
  80303a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803040:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803047:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80304a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80304d:	01 d0                	add    %edx,%eax
  80304f:	48                   	dec    %eax
  803050:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803053:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803056:	ba 00 00 00 00       	mov    $0x0,%edx
  80305b:	f7 75 c4             	divl   -0x3c(%ebp)
  80305e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803061:	29 d0                	sub    %edx,%eax
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	6a 01                	push   $0x1
  803068:	50                   	push   %eax
  803069:	ff 75 d0             	pushl  -0x30(%ebp)
  80306c:	e8 36 fb ff ff       	call   802ba7 <set_block_data>
  803071:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803074:	83 ec 0c             	sub    $0xc,%esp
  803077:	ff 75 d0             	pushl  -0x30(%ebp)
  80307a:	e8 1b 0a 00 00       	call   803a9a <free_block>
  80307f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803082:	83 ec 0c             	sub    $0xc,%esp
  803085:	ff 75 08             	pushl  0x8(%ebp)
  803088:	e8 49 fb ff ff       	call   802bd6 <alloc_block_FF>
  80308d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	83 e0 01             	and    $0x1,%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 03                	je     8030a5 <alloc_block_BF+0x13>
  8030a2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030a5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030a9:	77 07                	ja     8030b2 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030ab:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030b2:	a1 24 60 80 00       	mov    0x806024,%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	75 73                	jne    80312e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	83 c0 10             	add    $0x10,%eax
  8030c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030c4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8030cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d1:	01 d0                	add    %edx,%eax
  8030d3:	48                   	dec    %eax
  8030d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	ba 00 00 00 00       	mov    $0x0,%edx
  8030df:	f7 75 e0             	divl   -0x20(%ebp)
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	29 d0                	sub    %edx,%eax
  8030e7:	c1 e8 0c             	shr    $0xc,%eax
  8030ea:	83 ec 0c             	sub    $0xc,%esp
  8030ed:	50                   	push   %eax
  8030ee:	e8 f5 eb ff ff       	call   801ce8 <sbrk>
  8030f3:	83 c4 10             	add    $0x10,%esp
  8030f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8030f9:	83 ec 0c             	sub    $0xc,%esp
  8030fc:	6a 00                	push   $0x0
  8030fe:	e8 e5 eb ff ff       	call   801ce8 <sbrk>
  803103:	83 c4 10             	add    $0x10,%esp
  803106:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803109:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80310c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80310f:	83 ec 08             	sub    $0x8,%esp
  803112:	50                   	push   %eax
  803113:	ff 75 d8             	pushl  -0x28(%ebp)
  803116:	e8 9f f8 ff ff       	call   8029ba <initialize_dynamic_allocator>
  80311b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80311e:	83 ec 0c             	sub    $0xc,%esp
  803121:	68 2f 51 80 00       	push   $0x80512f
  803126:	e8 23 de ff ff       	call   800f4e <cprintf>
  80312b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80312e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803135:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80313c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803143:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80314a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80314f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803152:	e9 1d 01 00 00       	jmp    803274 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80315d:	83 ec 0c             	sub    $0xc,%esp
  803160:	ff 75 a8             	pushl  -0x58(%ebp)
  803163:	e8 ee f6 ff ff       	call   802856 <get_block_size>
  803168:	83 c4 10             	add    $0x10,%esp
  80316b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	83 c0 08             	add    $0x8,%eax
  803174:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803177:	0f 87 ef 00 00 00    	ja     80326c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	83 c0 18             	add    $0x18,%eax
  803183:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803186:	77 1d                	ja     8031a5 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80318e:	0f 86 d8 00 00 00    	jbe    80326c <alloc_block_BF+0x1da>
				{
					best_va = va;
  803194:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803197:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80319a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80319d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8031a0:	e9 c7 00 00 00       	jmp    80326c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	83 c0 08             	add    $0x8,%eax
  8031ab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031ae:	0f 85 9d 00 00 00    	jne    803251 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	6a 01                	push   $0x1
  8031b9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8031bc:	ff 75 a8             	pushl  -0x58(%ebp)
  8031bf:	e8 e3 f9 ff ff       	call   802ba7 <set_block_data>
  8031c4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	75 17                	jne    8031e4 <alloc_block_BF+0x152>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 d3 50 80 00       	push   $0x8050d3
  8031d5:	68 2c 01 00 00       	push   $0x12c
  8031da:	68 f1 50 80 00       	push   $0x8050f1
  8031df:	e8 ad da ff ff       	call   800c91 <_panic>
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 10                	je     8031fd <alloc_block_BF+0x16b>
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	8b 52 04             	mov    0x4(%edx),%edx
  8031f8:	89 50 04             	mov    %edx,0x4(%eax)
  8031fb:	eb 0b                	jmp    803208 <alloc_block_BF+0x176>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	a3 30 60 80 00       	mov    %eax,0x806030
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0f                	je     803221 <alloc_block_BF+0x18f>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	8b 12                	mov    (%edx),%edx
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	eb 0a                	jmp    80322b <alloc_block_BF+0x199>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 38 60 80 00       	mov    0x806038,%eax
  803243:	48                   	dec    %eax
  803244:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803249:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80324c:	e9 24 04 00 00       	jmp    803675 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803257:	76 13                	jbe    80326c <alloc_block_BF+0x1da>
					{
						internal = 1;
  803259:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803260:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803263:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803266:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803269:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80326c:	a1 34 60 80 00       	mov    0x806034,%eax
  803271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803274:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803278:	74 07                	je     803281 <alloc_block_BF+0x1ef>
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	eb 05                	jmp    803286 <alloc_block_BF+0x1f4>
  803281:	b8 00 00 00 00       	mov    $0x0,%eax
  803286:	a3 34 60 80 00       	mov    %eax,0x806034
  80328b:	a1 34 60 80 00       	mov    0x806034,%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	0f 85 bf fe ff ff    	jne    803157 <alloc_block_BF+0xc5>
  803298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329c:	0f 85 b5 fe ff ff    	jne    803157 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8032a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a6:	0f 84 26 02 00 00    	je     8034d2 <alloc_block_BF+0x440>
  8032ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b0:	0f 85 1c 02 00 00    	jne    8034d2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8032b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8032bc:	83 e8 08             	sub    $0x8,%eax
  8032bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	8d 50 08             	lea    0x8(%eax),%edx
  8032c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cb:	01 d0                	add    %edx,%eax
  8032cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	83 c0 08             	add    $0x8,%eax
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	6a 01                	push   $0x1
  8032db:	50                   	push   %eax
  8032dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8032df:	e8 c3 f8 ff ff       	call   802ba7 <set_block_data>
  8032e4:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	8b 40 04             	mov    0x4(%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	75 68                	jne    803359 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032f5:	75 17                	jne    80330e <alloc_block_BF+0x27c>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 0c 51 80 00       	push   $0x80510c
  8032ff:	68 45 01 00 00       	push   $0x145
  803304:	68 f1 50 80 00       	push   $0x8050f1
  803309:	e8 83 d9 ff ff       	call   800c91 <_panic>
  80330e:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803314:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803317:	89 10                	mov    %edx,(%eax)
  803319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 0d                	je     80332f <alloc_block_BF+0x29d>
  803322:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803327:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 08                	jmp    803337 <alloc_block_BF+0x2a5>
  80332f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803332:	a3 30 60 80 00       	mov    %eax,0x806030
  803337:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80333f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803349:	a1 38 60 80 00       	mov    0x806038,%eax
  80334e:	40                   	inc    %eax
  80334f:	a3 38 60 80 00       	mov    %eax,0x806038
  803354:	e9 dc 00 00 00       	jmp    803435 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	75 65                	jne    8033c7 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803362:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803366:	75 17                	jne    80337f <alloc_block_BF+0x2ed>
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	68 40 51 80 00       	push   $0x805140
  803370:	68 4a 01 00 00       	push   $0x14a
  803375:	68 f1 50 80 00       	push   $0x8050f1
  80337a:	e8 12 d9 ff ff       	call   800c91 <_panic>
  80337f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803385:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803388:	89 50 04             	mov    %edx,0x4(%eax)
  80338b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80338e:	8b 40 04             	mov    0x4(%eax),%eax
  803391:	85 c0                	test   %eax,%eax
  803393:	74 0c                	je     8033a1 <alloc_block_BF+0x30f>
  803395:	a1 30 60 80 00       	mov    0x806030,%eax
  80339a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	eb 08                	jmp    8033a9 <alloc_block_BF+0x317>
  8033a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8033a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ac:	a3 30 60 80 00       	mov    %eax,0x806030
  8033b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ba:	a1 38 60 80 00       	mov    0x806038,%eax
  8033bf:	40                   	inc    %eax
  8033c0:	a3 38 60 80 00       	mov    %eax,0x806038
  8033c5:	eb 6e                	jmp    803435 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8033c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033cb:	74 06                	je     8033d3 <alloc_block_BF+0x341>
  8033cd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033d1:	75 17                	jne    8033ea <alloc_block_BF+0x358>
  8033d3:	83 ec 04             	sub    $0x4,%esp
  8033d6:	68 64 51 80 00       	push   $0x805164
  8033db:	68 4f 01 00 00       	push   $0x14f
  8033e0:	68 f1 50 80 00       	push   $0x8050f1
  8033e5:	e8 a7 d8 ff ff       	call   800c91 <_panic>
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	8b 10                	mov    (%eax),%edx
  8033ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f2:	89 10                	mov    %edx,(%eax)
  8033f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0b                	je     803408 <alloc_block_BF+0x376>
  8033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803405:	89 50 04             	mov    %edx,0x4(%eax)
  803408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80340e:	89 10                	mov    %edx,(%eax)
  803410:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803416:	89 50 04             	mov    %edx,0x4(%eax)
  803419:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	75 08                	jne    80342a <alloc_block_BF+0x398>
  803422:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803425:	a3 30 60 80 00       	mov    %eax,0x806030
  80342a:	a1 38 60 80 00       	mov    0x806038,%eax
  80342f:	40                   	inc    %eax
  803430:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803435:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803439:	75 17                	jne    803452 <alloc_block_BF+0x3c0>
  80343b:	83 ec 04             	sub    $0x4,%esp
  80343e:	68 d3 50 80 00       	push   $0x8050d3
  803443:	68 51 01 00 00       	push   $0x151
  803448:	68 f1 50 80 00       	push   $0x8050f1
  80344d:	e8 3f d8 ff ff       	call   800c91 <_panic>
  803452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803455:	8b 00                	mov    (%eax),%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 10                	je     80346b <alloc_block_BF+0x3d9>
  80345b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803463:	8b 52 04             	mov    0x4(%edx),%edx
  803466:	89 50 04             	mov    %edx,0x4(%eax)
  803469:	eb 0b                	jmp    803476 <alloc_block_BF+0x3e4>
  80346b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	a3 30 60 80 00       	mov    %eax,0x806030
  803476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803479:	8b 40 04             	mov    0x4(%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	74 0f                	je     80348f <alloc_block_BF+0x3fd>
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	8b 40 04             	mov    0x4(%eax),%eax
  803486:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803489:	8b 12                	mov    (%edx),%edx
  80348b:	89 10                	mov    %edx,(%eax)
  80348d:	eb 0a                	jmp    803499 <alloc_block_BF+0x407>
  80348f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ac:	a1 38 60 80 00       	mov    0x806038,%eax
  8034b1:	48                   	dec    %eax
  8034b2:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	6a 00                	push   $0x0
  8034bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8034bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8034c2:	e8 e0 f6 ff ff       	call   802ba7 <set_block_data>
  8034c7:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cd:	e9 a3 01 00 00       	jmp    803675 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8034d2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8034d6:	0f 85 9d 00 00 00    	jne    803579 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	6a 01                	push   $0x1
  8034e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8034e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8034e7:	e8 bb f6 ff ff       	call   802ba7 <set_block_data>
  8034ec:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8034ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f3:	75 17                	jne    80350c <alloc_block_BF+0x47a>
  8034f5:	83 ec 04             	sub    $0x4,%esp
  8034f8:	68 d3 50 80 00       	push   $0x8050d3
  8034fd:	68 58 01 00 00       	push   $0x158
  803502:	68 f1 50 80 00       	push   $0x8050f1
  803507:	e8 85 d7 ff ff       	call   800c91 <_panic>
  80350c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	74 10                	je     803525 <alloc_block_BF+0x493>
  803515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351d:	8b 52 04             	mov    0x4(%edx),%edx
  803520:	89 50 04             	mov    %edx,0x4(%eax)
  803523:	eb 0b                	jmp    803530 <alloc_block_BF+0x49e>
  803525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803528:	8b 40 04             	mov    0x4(%eax),%eax
  80352b:	a3 30 60 80 00       	mov    %eax,0x806030
  803530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803533:	8b 40 04             	mov    0x4(%eax),%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	74 0f                	je     803549 <alloc_block_BF+0x4b7>
  80353a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353d:	8b 40 04             	mov    0x4(%eax),%eax
  803540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803543:	8b 12                	mov    (%edx),%edx
  803545:	89 10                	mov    %edx,(%eax)
  803547:	eb 0a                	jmp    803553 <alloc_block_BF+0x4c1>
  803549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803566:	a1 38 60 80 00       	mov    0x806038,%eax
  80356b:	48                   	dec    %eax
  80356c:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803574:	e9 fc 00 00 00       	jmp    803675 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	83 c0 08             	add    $0x8,%eax
  80357f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803582:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803589:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80358c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80358f:	01 d0                	add    %edx,%eax
  803591:	48                   	dec    %eax
  803592:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803595:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803598:	ba 00 00 00 00       	mov    $0x0,%edx
  80359d:	f7 75 c4             	divl   -0x3c(%ebp)
  8035a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035a3:	29 d0                	sub    %edx,%eax
  8035a5:	c1 e8 0c             	shr    $0xc,%eax
  8035a8:	83 ec 0c             	sub    $0xc,%esp
  8035ab:	50                   	push   %eax
  8035ac:	e8 37 e7 ff ff       	call   801ce8 <sbrk>
  8035b1:	83 c4 10             	add    $0x10,%esp
  8035b4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8035b7:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8035bb:	75 0a                	jne    8035c7 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8035bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c2:	e9 ae 00 00 00       	jmp    803675 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035c7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8035ce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	48                   	dec    %eax
  8035d7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8035da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8035e2:	f7 75 b8             	divl   -0x48(%ebp)
  8035e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035e8:	29 d0                	sub    %edx,%eax
  8035ea:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8035f7:	a1 40 60 80 00       	mov    0x806040,%eax
  8035fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803602:	83 ec 0c             	sub    $0xc,%esp
  803605:	68 98 51 80 00       	push   $0x805198
  80360a:	e8 3f d9 ff ff       	call   800f4e <cprintf>
  80360f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803612:	83 ec 08             	sub    $0x8,%esp
  803615:	ff 75 bc             	pushl  -0x44(%ebp)
  803618:	68 9d 51 80 00       	push   $0x80519d
  80361d:	e8 2c d9 ff ff       	call   800f4e <cprintf>
  803622:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803625:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80362c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80362f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	48                   	dec    %eax
  803635:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803638:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80363b:	ba 00 00 00 00       	mov    $0x0,%edx
  803640:	f7 75 b0             	divl   -0x50(%ebp)
  803643:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803646:	29 d0                	sub    %edx,%eax
  803648:	83 ec 04             	sub    $0x4,%esp
  80364b:	6a 01                	push   $0x1
  80364d:	50                   	push   %eax
  80364e:	ff 75 bc             	pushl  -0x44(%ebp)
  803651:	e8 51 f5 ff ff       	call   802ba7 <set_block_data>
  803656:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803659:	83 ec 0c             	sub    $0xc,%esp
  80365c:	ff 75 bc             	pushl  -0x44(%ebp)
  80365f:	e8 36 04 00 00       	call   803a9a <free_block>
  803664:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803667:	83 ec 0c             	sub    $0xc,%esp
  80366a:	ff 75 08             	pushl  0x8(%ebp)
  80366d:	e8 20 fa ff ff       	call   803092 <alloc_block_BF>
  803672:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803675:	c9                   	leave  
  803676:	c3                   	ret    

00803677 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	53                   	push   %ebx
  80367b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80367e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80368c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803690:	74 1e                	je     8036b0 <merging+0x39>
  803692:	ff 75 08             	pushl  0x8(%ebp)
  803695:	e8 bc f1 ff ff       	call   802856 <get_block_size>
  80369a:	83 c4 04             	add    $0x4,%esp
  80369d:	89 c2                	mov    %eax,%edx
  80369f:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a2:	01 d0                	add    %edx,%eax
  8036a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8036a7:	75 07                	jne    8036b0 <merging+0x39>
		prev_is_free = 1;
  8036a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8036b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036b4:	74 1e                	je     8036d4 <merging+0x5d>
  8036b6:	ff 75 10             	pushl  0x10(%ebp)
  8036b9:	e8 98 f1 ff ff       	call   802856 <get_block_size>
  8036be:	83 c4 04             	add    $0x4,%esp
  8036c1:	89 c2                	mov    %eax,%edx
  8036c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c6:	01 d0                	add    %edx,%eax
  8036c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036cb:	75 07                	jne    8036d4 <merging+0x5d>
		next_is_free = 1;
  8036cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8036d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d8:	0f 84 cc 00 00 00    	je     8037aa <merging+0x133>
  8036de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e2:	0f 84 c2 00 00 00    	je     8037aa <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8036e8:	ff 75 08             	pushl  0x8(%ebp)
  8036eb:	e8 66 f1 ff ff       	call   802856 <get_block_size>
  8036f0:	83 c4 04             	add    $0x4,%esp
  8036f3:	89 c3                	mov    %eax,%ebx
  8036f5:	ff 75 10             	pushl  0x10(%ebp)
  8036f8:	e8 59 f1 ff ff       	call   802856 <get_block_size>
  8036fd:	83 c4 04             	add    $0x4,%esp
  803700:	01 c3                	add    %eax,%ebx
  803702:	ff 75 0c             	pushl  0xc(%ebp)
  803705:	e8 4c f1 ff ff       	call   802856 <get_block_size>
  80370a:	83 c4 04             	add    $0x4,%esp
  80370d:	01 d8                	add    %ebx,%eax
  80370f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803712:	6a 00                	push   $0x0
  803714:	ff 75 ec             	pushl  -0x14(%ebp)
  803717:	ff 75 08             	pushl  0x8(%ebp)
  80371a:	e8 88 f4 ff ff       	call   802ba7 <set_block_data>
  80371f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803726:	75 17                	jne    80373f <merging+0xc8>
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 d3 50 80 00       	push   $0x8050d3
  803730:	68 7d 01 00 00       	push   $0x17d
  803735:	68 f1 50 80 00       	push   $0x8050f1
  80373a:	e8 52 d5 ff ff       	call   800c91 <_panic>
  80373f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	74 10                	je     803758 <merging+0xe1>
  803748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803750:	8b 52 04             	mov    0x4(%edx),%edx
  803753:	89 50 04             	mov    %edx,0x4(%eax)
  803756:	eb 0b                	jmp    803763 <merging+0xec>
  803758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375b:	8b 40 04             	mov    0x4(%eax),%eax
  80375e:	a3 30 60 80 00       	mov    %eax,0x806030
  803763:	8b 45 0c             	mov    0xc(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	74 0f                	je     80377c <merging+0x105>
  80376d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	8b 55 0c             	mov    0xc(%ebp),%edx
  803776:	8b 12                	mov    (%edx),%edx
  803778:	89 10                	mov    %edx,(%eax)
  80377a:	eb 0a                	jmp    803786 <merging+0x10f>
  80377c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377f:	8b 00                	mov    (%eax),%eax
  803781:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803786:	8b 45 0c             	mov    0xc(%ebp),%eax
  803789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803792:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803799:	a1 38 60 80 00       	mov    0x806038,%eax
  80379e:	48                   	dec    %eax
  80379f:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8037a4:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037a5:	e9 ea 02 00 00       	jmp    803a94 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8037aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ae:	74 3b                	je     8037eb <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	e8 9b f0 ff ff       	call   802856 <get_block_size>
  8037bb:	83 c4 10             	add    $0x10,%esp
  8037be:	89 c3                	mov    %eax,%ebx
  8037c0:	83 ec 0c             	sub    $0xc,%esp
  8037c3:	ff 75 10             	pushl  0x10(%ebp)
  8037c6:	e8 8b f0 ff ff       	call   802856 <get_block_size>
  8037cb:	83 c4 10             	add    $0x10,%esp
  8037ce:	01 d8                	add    %ebx,%eax
  8037d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8037d3:	83 ec 04             	sub    $0x4,%esp
  8037d6:	6a 00                	push   $0x0
  8037d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8037db:	ff 75 08             	pushl  0x8(%ebp)
  8037de:	e8 c4 f3 ff ff       	call   802ba7 <set_block_data>
  8037e3:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037e6:	e9 a9 02 00 00       	jmp    803a94 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8037eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037ef:	0f 84 2d 01 00 00    	je     803922 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8037f5:	83 ec 0c             	sub    $0xc,%esp
  8037f8:	ff 75 10             	pushl  0x10(%ebp)
  8037fb:	e8 56 f0 ff ff       	call   802856 <get_block_size>
  803800:	83 c4 10             	add    $0x10,%esp
  803803:	89 c3                	mov    %eax,%ebx
  803805:	83 ec 0c             	sub    $0xc,%esp
  803808:	ff 75 0c             	pushl  0xc(%ebp)
  80380b:	e8 46 f0 ff ff       	call   802856 <get_block_size>
  803810:	83 c4 10             	add    $0x10,%esp
  803813:	01 d8                	add    %ebx,%eax
  803815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803818:	83 ec 04             	sub    $0x4,%esp
  80381b:	6a 00                	push   $0x0
  80381d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803820:	ff 75 10             	pushl  0x10(%ebp)
  803823:	e8 7f f3 ff ff       	call   802ba7 <set_block_data>
  803828:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80382b:	8b 45 10             	mov    0x10(%ebp),%eax
  80382e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803831:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803835:	74 06                	je     80383d <merging+0x1c6>
  803837:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80383b:	75 17                	jne    803854 <merging+0x1dd>
  80383d:	83 ec 04             	sub    $0x4,%esp
  803840:	68 ac 51 80 00       	push   $0x8051ac
  803845:	68 8d 01 00 00       	push   $0x18d
  80384a:	68 f1 50 80 00       	push   $0x8050f1
  80384f:	e8 3d d4 ff ff       	call   800c91 <_panic>
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	8b 50 04             	mov    0x4(%eax),%edx
  80385a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385d:	89 50 04             	mov    %edx,0x4(%eax)
  803860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803863:	8b 55 0c             	mov    0xc(%ebp),%edx
  803866:	89 10                	mov    %edx,(%eax)
  803868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386b:	8b 40 04             	mov    0x4(%eax),%eax
  80386e:	85 c0                	test   %eax,%eax
  803870:	74 0d                	je     80387f <merging+0x208>
  803872:	8b 45 0c             	mov    0xc(%ebp),%eax
  803875:	8b 40 04             	mov    0x4(%eax),%eax
  803878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	eb 08                	jmp    803887 <merging+0x210>
  80387f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803882:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80388d:	89 50 04             	mov    %edx,0x4(%eax)
  803890:	a1 38 60 80 00       	mov    0x806038,%eax
  803895:	40                   	inc    %eax
  803896:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  80389b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80389f:	75 17                	jne    8038b8 <merging+0x241>
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 d3 50 80 00       	push   $0x8050d3
  8038a9:	68 8e 01 00 00       	push   $0x18e
  8038ae:	68 f1 50 80 00       	push   $0x8050f1
  8038b3:	e8 d9 d3 ff ff       	call   800c91 <_panic>
  8038b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 10                	je     8038d1 <merging+0x25a>
  8038c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c4:	8b 00                	mov    (%eax),%eax
  8038c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c9:	8b 52 04             	mov    0x4(%edx),%edx
  8038cc:	89 50 04             	mov    %edx,0x4(%eax)
  8038cf:	eb 0b                	jmp    8038dc <merging+0x265>
  8038d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d4:	8b 40 04             	mov    0x4(%eax),%eax
  8038d7:	a3 30 60 80 00       	mov    %eax,0x806030
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	8b 40 04             	mov    0x4(%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 0f                	je     8038f5 <merging+0x27e>
  8038e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ef:	8b 12                	mov    (%edx),%edx
  8038f1:	89 10                	mov    %edx,(%eax)
  8038f3:	eb 0a                	jmp    8038ff <merging+0x288>
  8038f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803912:	a1 38 60 80 00       	mov    0x806038,%eax
  803917:	48                   	dec    %eax
  803918:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80391d:	e9 72 01 00 00       	jmp    803a94 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803922:	8b 45 10             	mov    0x10(%ebp),%eax
  803925:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392c:	74 79                	je     8039a7 <merging+0x330>
  80392e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803932:	74 73                	je     8039a7 <merging+0x330>
  803934:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803938:	74 06                	je     803940 <merging+0x2c9>
  80393a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80393e:	75 17                	jne    803957 <merging+0x2e0>
  803940:	83 ec 04             	sub    $0x4,%esp
  803943:	68 64 51 80 00       	push   $0x805164
  803948:	68 94 01 00 00       	push   $0x194
  80394d:	68 f1 50 80 00       	push   $0x8050f1
  803952:	e8 3a d3 ff ff       	call   800c91 <_panic>
  803957:	8b 45 08             	mov    0x8(%ebp),%eax
  80395a:	8b 10                	mov    (%eax),%edx
  80395c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395f:	89 10                	mov    %edx,(%eax)
  803961:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	74 0b                	je     803975 <merging+0x2fe>
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	8b 00                	mov    (%eax),%eax
  80396f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397b:	89 10                	mov    %edx,(%eax)
  80397d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803980:	8b 55 08             	mov    0x8(%ebp),%edx
  803983:	89 50 04             	mov    %edx,0x4(%eax)
  803986:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	75 08                	jne    803997 <merging+0x320>
  80398f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803992:	a3 30 60 80 00       	mov    %eax,0x806030
  803997:	a1 38 60 80 00       	mov    0x806038,%eax
  80399c:	40                   	inc    %eax
  80399d:	a3 38 60 80 00       	mov    %eax,0x806038
  8039a2:	e9 ce 00 00 00       	jmp    803a75 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8039a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ab:	74 65                	je     803a12 <merging+0x39b>
  8039ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039b1:	75 17                	jne    8039ca <merging+0x353>
  8039b3:	83 ec 04             	sub    $0x4,%esp
  8039b6:	68 40 51 80 00       	push   $0x805140
  8039bb:	68 95 01 00 00       	push   $0x195
  8039c0:	68 f1 50 80 00       	push   $0x8050f1
  8039c5:	e8 c7 d2 ff ff       	call   800c91 <_panic>
  8039ca:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8039d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d3:	89 50 04             	mov    %edx,0x4(%eax)
  8039d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d9:	8b 40 04             	mov    0x4(%eax),%eax
  8039dc:	85 c0                	test   %eax,%eax
  8039de:	74 0c                	je     8039ec <merging+0x375>
  8039e0:	a1 30 60 80 00       	mov    0x806030,%eax
  8039e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e8:	89 10                	mov    %edx,(%eax)
  8039ea:	eb 08                	jmp    8039f4 <merging+0x37d>
  8039ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ef:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8039fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a05:	a1 38 60 80 00       	mov    0x806038,%eax
  803a0a:	40                   	inc    %eax
  803a0b:	a3 38 60 80 00       	mov    %eax,0x806038
  803a10:	eb 63                	jmp    803a75 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803a12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a16:	75 17                	jne    803a2f <merging+0x3b8>
  803a18:	83 ec 04             	sub    $0x4,%esp
  803a1b:	68 0c 51 80 00       	push   $0x80510c
  803a20:	68 98 01 00 00       	push   $0x198
  803a25:	68 f1 50 80 00       	push   $0x8050f1
  803a2a:	e8 62 d2 ff ff       	call   800c91 <_panic>
  803a2f:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803a35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a38:	89 10                	mov    %edx,(%eax)
  803a3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	74 0d                	je     803a50 <merging+0x3d9>
  803a43:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a4b:	89 50 04             	mov    %edx,0x4(%eax)
  803a4e:	eb 08                	jmp    803a58 <merging+0x3e1>
  803a50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a53:	a3 30 60 80 00       	mov    %eax,0x806030
  803a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6a:	a1 38 60 80 00       	mov    0x806038,%eax
  803a6f:	40                   	inc    %eax
  803a70:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803a75:	83 ec 0c             	sub    $0xc,%esp
  803a78:	ff 75 10             	pushl  0x10(%ebp)
  803a7b:	e8 d6 ed ff ff       	call   802856 <get_block_size>
  803a80:	83 c4 10             	add    $0x10,%esp
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	6a 00                	push   $0x0
  803a88:	50                   	push   %eax
  803a89:	ff 75 10             	pushl  0x10(%ebp)
  803a8c:	e8 16 f1 ff ff       	call   802ba7 <set_block_data>
  803a91:	83 c4 10             	add    $0x10,%esp
	}
}
  803a94:	90                   	nop
  803a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a98:	c9                   	leave  
  803a99:	c3                   	ret    

00803a9a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a9a:	55                   	push   %ebp
  803a9b:	89 e5                	mov    %esp,%ebp
  803a9d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803aa0:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803aa8:	a1 30 60 80 00       	mov    0x806030,%eax
  803aad:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab0:	73 1b                	jae    803acd <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803ab2:	a1 30 60 80 00       	mov    0x806030,%eax
  803ab7:	83 ec 04             	sub    $0x4,%esp
  803aba:	ff 75 08             	pushl  0x8(%ebp)
  803abd:	6a 00                	push   $0x0
  803abf:	50                   	push   %eax
  803ac0:	e8 b2 fb ff ff       	call   803677 <merging>
  803ac5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ac8:	e9 8b 00 00 00       	jmp    803b58 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803acd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ad2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ad5:	76 18                	jbe    803aef <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ad7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	ff 75 08             	pushl  0x8(%ebp)
  803ae2:	50                   	push   %eax
  803ae3:	6a 00                	push   $0x0
  803ae5:	e8 8d fb ff ff       	call   803677 <merging>
  803aea:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aed:	eb 69                	jmp    803b58 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803aef:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af7:	eb 39                	jmp    803b32 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aff:	73 29                	jae    803b2a <free_block+0x90>
  803b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b09:	76 1f                	jbe    803b2a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	8b 00                	mov    (%eax),%eax
  803b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803b13:	83 ec 04             	sub    $0x4,%esp
  803b16:	ff 75 08             	pushl  0x8(%ebp)
  803b19:	ff 75 f0             	pushl  -0x10(%ebp)
  803b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  803b1f:	e8 53 fb ff ff       	call   803677 <merging>
  803b24:	83 c4 10             	add    $0x10,%esp
			break;
  803b27:	90                   	nop
		}
	}
}
  803b28:	eb 2e                	jmp    803b58 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803b2a:	a1 34 60 80 00       	mov    0x806034,%eax
  803b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b36:	74 07                	je     803b3f <free_block+0xa5>
  803b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3b:	8b 00                	mov    (%eax),%eax
  803b3d:	eb 05                	jmp    803b44 <free_block+0xaa>
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	a3 34 60 80 00       	mov    %eax,0x806034
  803b49:	a1 34 60 80 00       	mov    0x806034,%eax
  803b4e:	85 c0                	test   %eax,%eax
  803b50:	75 a7                	jne    803af9 <free_block+0x5f>
  803b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b56:	75 a1                	jne    803af9 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b58:	90                   	nop
  803b59:	c9                   	leave  
  803b5a:	c3                   	ret    

00803b5b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803b5b:	55                   	push   %ebp
  803b5c:	89 e5                	mov    %esp,%ebp
  803b5e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803b61:	ff 75 08             	pushl  0x8(%ebp)
  803b64:	e8 ed ec ff ff       	call   802856 <get_block_size>
  803b69:	83 c4 04             	add    $0x4,%esp
  803b6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b76:	eb 17                	jmp    803b8f <copy_data+0x34>
  803b78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7e:	01 c2                	add    %eax,%edx
  803b80:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b83:	8b 45 08             	mov    0x8(%ebp),%eax
  803b86:	01 c8                	add    %ecx,%eax
  803b88:	8a 00                	mov    (%eax),%al
  803b8a:	88 02                	mov    %al,(%edx)
  803b8c:	ff 45 fc             	incl   -0x4(%ebp)
  803b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b95:	72 e1                	jb     803b78 <copy_data+0x1d>
}
  803b97:	90                   	nop
  803b98:	c9                   	leave  
  803b99:	c3                   	ret    

00803b9a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b9a:	55                   	push   %ebp
  803b9b:	89 e5                	mov    %esp,%ebp
  803b9d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803ba0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba4:	75 23                	jne    803bc9 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ba6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803baa:	74 13                	je     803bbf <realloc_block_FF+0x25>
  803bac:	83 ec 0c             	sub    $0xc,%esp
  803baf:	ff 75 0c             	pushl  0xc(%ebp)
  803bb2:	e8 1f f0 ff ff       	call   802bd6 <alloc_block_FF>
  803bb7:	83 c4 10             	add    $0x10,%esp
  803bba:	e9 f4 06 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
		return NULL;
  803bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc4:	e9 ea 06 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803bc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bcd:	75 18                	jne    803be7 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803bcf:	83 ec 0c             	sub    $0xc,%esp
  803bd2:	ff 75 08             	pushl  0x8(%ebp)
  803bd5:	e8 c0 fe ff ff       	call   803a9a <free_block>
  803bda:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803be2:	e9 cc 06 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803be7:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803beb:	77 07                	ja     803bf4 <realloc_block_FF+0x5a>
  803bed:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf7:	83 e0 01             	and    $0x1,%eax
  803bfa:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c00:	83 c0 08             	add    $0x8,%eax
  803c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803c06:	83 ec 0c             	sub    $0xc,%esp
  803c09:	ff 75 08             	pushl  0x8(%ebp)
  803c0c:	e8 45 ec ff ff       	call   802856 <get_block_size>
  803c11:	83 c4 10             	add    $0x10,%esp
  803c14:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c1a:	83 e8 08             	sub    $0x8,%eax
  803c1d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803c20:	8b 45 08             	mov    0x8(%ebp),%eax
  803c23:	83 e8 04             	sub    $0x4,%eax
  803c26:	8b 00                	mov    (%eax),%eax
  803c28:	83 e0 fe             	and    $0xfffffffe,%eax
  803c2b:	89 c2                	mov    %eax,%edx
  803c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c30:	01 d0                	add    %edx,%eax
  803c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803c35:	83 ec 0c             	sub    $0xc,%esp
  803c38:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c3b:	e8 16 ec ff ff       	call   802856 <get_block_size>
  803c40:	83 c4 10             	add    $0x10,%esp
  803c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c49:	83 e8 08             	sub    $0x8,%eax
  803c4c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c52:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c55:	75 08                	jne    803c5f <realloc_block_FF+0xc5>
	{
		 return va;
  803c57:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5a:	e9 54 06 00 00       	jmp    8042b3 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c62:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c65:	0f 83 e5 03 00 00    	jae    804050 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c71:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c74:	83 ec 0c             	sub    $0xc,%esp
  803c77:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c7a:	e8 f0 eb ff ff       	call   80286f <is_free_block>
  803c7f:	83 c4 10             	add    $0x10,%esp
  803c82:	84 c0                	test   %al,%al
  803c84:	0f 84 3b 01 00 00    	je     803dc5 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c90:	01 d0                	add    %edx,%eax
  803c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c95:	83 ec 04             	sub    $0x4,%esp
  803c98:	6a 01                	push   $0x1
  803c9a:	ff 75 f0             	pushl  -0x10(%ebp)
  803c9d:	ff 75 08             	pushl  0x8(%ebp)
  803ca0:	e8 02 ef ff ff       	call   802ba7 <set_block_data>
  803ca5:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cab:	83 e8 04             	sub    $0x4,%eax
  803cae:	8b 00                	mov    (%eax),%eax
  803cb0:	83 e0 fe             	and    $0xfffffffe,%eax
  803cb3:	89 c2                	mov    %eax,%edx
  803cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb8:	01 d0                	add    %edx,%eax
  803cba:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803cbd:	83 ec 04             	sub    $0x4,%esp
  803cc0:	6a 00                	push   $0x0
  803cc2:	ff 75 cc             	pushl  -0x34(%ebp)
  803cc5:	ff 75 c8             	pushl  -0x38(%ebp)
  803cc8:	e8 da ee ff ff       	call   802ba7 <set_block_data>
  803ccd:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803cd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd4:	74 06                	je     803cdc <realloc_block_FF+0x142>
  803cd6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803cda:	75 17                	jne    803cf3 <realloc_block_FF+0x159>
  803cdc:	83 ec 04             	sub    $0x4,%esp
  803cdf:	68 64 51 80 00       	push   $0x805164
  803ce4:	68 f6 01 00 00       	push   $0x1f6
  803ce9:	68 f1 50 80 00       	push   $0x8050f1
  803cee:	e8 9e cf ff ff       	call   800c91 <_panic>
  803cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf6:	8b 10                	mov    (%eax),%edx
  803cf8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cfb:	89 10                	mov    %edx,(%eax)
  803cfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d00:	8b 00                	mov    (%eax),%eax
  803d02:	85 c0                	test   %eax,%eax
  803d04:	74 0b                	je     803d11 <realloc_block_FF+0x177>
  803d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d09:	8b 00                	mov    (%eax),%eax
  803d0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d0e:	89 50 04             	mov    %edx,0x4(%eax)
  803d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d17:	89 10                	mov    %edx,(%eax)
  803d19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d1f:	89 50 04             	mov    %edx,0x4(%eax)
  803d22:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d25:	8b 00                	mov    (%eax),%eax
  803d27:	85 c0                	test   %eax,%eax
  803d29:	75 08                	jne    803d33 <realloc_block_FF+0x199>
  803d2b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d2e:	a3 30 60 80 00       	mov    %eax,0x806030
  803d33:	a1 38 60 80 00       	mov    0x806038,%eax
  803d38:	40                   	inc    %eax
  803d39:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d42:	75 17                	jne    803d5b <realloc_block_FF+0x1c1>
  803d44:	83 ec 04             	sub    $0x4,%esp
  803d47:	68 d3 50 80 00       	push   $0x8050d3
  803d4c:	68 f7 01 00 00       	push   $0x1f7
  803d51:	68 f1 50 80 00       	push   $0x8050f1
  803d56:	e8 36 cf ff ff       	call   800c91 <_panic>
  803d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5e:	8b 00                	mov    (%eax),%eax
  803d60:	85 c0                	test   %eax,%eax
  803d62:	74 10                	je     803d74 <realloc_block_FF+0x1da>
  803d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d67:	8b 00                	mov    (%eax),%eax
  803d69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d6c:	8b 52 04             	mov    0x4(%edx),%edx
  803d6f:	89 50 04             	mov    %edx,0x4(%eax)
  803d72:	eb 0b                	jmp    803d7f <realloc_block_FF+0x1e5>
  803d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d77:	8b 40 04             	mov    0x4(%eax),%eax
  803d7a:	a3 30 60 80 00       	mov    %eax,0x806030
  803d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d82:	8b 40 04             	mov    0x4(%eax),%eax
  803d85:	85 c0                	test   %eax,%eax
  803d87:	74 0f                	je     803d98 <realloc_block_FF+0x1fe>
  803d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8c:	8b 40 04             	mov    0x4(%eax),%eax
  803d8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d92:	8b 12                	mov    (%edx),%edx
  803d94:	89 10                	mov    %edx,(%eax)
  803d96:	eb 0a                	jmp    803da2 <realloc_block_FF+0x208>
  803d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9b:	8b 00                	mov    (%eax),%eax
  803d9d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803db5:	a1 38 60 80 00       	mov    0x806038,%eax
  803dba:	48                   	dec    %eax
  803dbb:	a3 38 60 80 00       	mov    %eax,0x806038
  803dc0:	e9 83 02 00 00       	jmp    804048 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803dc5:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803dc9:	0f 86 69 02 00 00    	jbe    804038 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803dcf:	83 ec 04             	sub    $0x4,%esp
  803dd2:	6a 01                	push   $0x1
  803dd4:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd7:	ff 75 08             	pushl  0x8(%ebp)
  803dda:	e8 c8 ed ff ff       	call   802ba7 <set_block_data>
  803ddf:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803de2:	8b 45 08             	mov    0x8(%ebp),%eax
  803de5:	83 e8 04             	sub    $0x4,%eax
  803de8:	8b 00                	mov    (%eax),%eax
  803dea:	83 e0 fe             	and    $0xfffffffe,%eax
  803ded:	89 c2                	mov    %eax,%edx
  803def:	8b 45 08             	mov    0x8(%ebp),%eax
  803df2:	01 d0                	add    %edx,%eax
  803df4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803df7:	a1 38 60 80 00       	mov    0x806038,%eax
  803dfc:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803dff:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803e03:	75 68                	jne    803e6d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e05:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e09:	75 17                	jne    803e22 <realloc_block_FF+0x288>
  803e0b:	83 ec 04             	sub    $0x4,%esp
  803e0e:	68 0c 51 80 00       	push   $0x80510c
  803e13:	68 06 02 00 00       	push   $0x206
  803e18:	68 f1 50 80 00       	push   $0x8050f1
  803e1d:	e8 6f ce ff ff       	call   800c91 <_panic>
  803e22:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2b:	89 10                	mov    %edx,(%eax)
  803e2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e30:	8b 00                	mov    (%eax),%eax
  803e32:	85 c0                	test   %eax,%eax
  803e34:	74 0d                	je     803e43 <realloc_block_FF+0x2a9>
  803e36:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e3e:	89 50 04             	mov    %edx,0x4(%eax)
  803e41:	eb 08                	jmp    803e4b <realloc_block_FF+0x2b1>
  803e43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e46:	a3 30 60 80 00       	mov    %eax,0x806030
  803e4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5d:	a1 38 60 80 00       	mov    0x806038,%eax
  803e62:	40                   	inc    %eax
  803e63:	a3 38 60 80 00       	mov    %eax,0x806038
  803e68:	e9 b0 01 00 00       	jmp    80401d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e6d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e72:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e75:	76 68                	jbe    803edf <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e7b:	75 17                	jne    803e94 <realloc_block_FF+0x2fa>
  803e7d:	83 ec 04             	sub    $0x4,%esp
  803e80:	68 0c 51 80 00       	push   $0x80510c
  803e85:	68 0b 02 00 00       	push   $0x20b
  803e8a:	68 f1 50 80 00       	push   $0x8050f1
  803e8f:	e8 fd cd ff ff       	call   800c91 <_panic>
  803e94:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9d:	89 10                	mov    %edx,(%eax)
  803e9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	74 0d                	je     803eb5 <realloc_block_FF+0x31b>
  803ea8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ead:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eb0:	89 50 04             	mov    %edx,0x4(%eax)
  803eb3:	eb 08                	jmp    803ebd <realloc_block_FF+0x323>
  803eb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb8:	a3 30 60 80 00       	mov    %eax,0x806030
  803ebd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ec5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecf:	a1 38 60 80 00       	mov    0x806038,%eax
  803ed4:	40                   	inc    %eax
  803ed5:	a3 38 60 80 00       	mov    %eax,0x806038
  803eda:	e9 3e 01 00 00       	jmp    80401d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803edf:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ee4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ee7:	73 68                	jae    803f51 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ee9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eed:	75 17                	jne    803f06 <realloc_block_FF+0x36c>
  803eef:	83 ec 04             	sub    $0x4,%esp
  803ef2:	68 40 51 80 00       	push   $0x805140
  803ef7:	68 10 02 00 00       	push   $0x210
  803efc:	68 f1 50 80 00       	push   $0x8050f1
  803f01:	e8 8b cd ff ff       	call   800c91 <_panic>
  803f06:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f0f:	89 50 04             	mov    %edx,0x4(%eax)
  803f12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f15:	8b 40 04             	mov    0x4(%eax),%eax
  803f18:	85 c0                	test   %eax,%eax
  803f1a:	74 0c                	je     803f28 <realloc_block_FF+0x38e>
  803f1c:	a1 30 60 80 00       	mov    0x806030,%eax
  803f21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f24:	89 10                	mov    %edx,(%eax)
  803f26:	eb 08                	jmp    803f30 <realloc_block_FF+0x396>
  803f28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f33:	a3 30 60 80 00       	mov    %eax,0x806030
  803f38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f41:	a1 38 60 80 00       	mov    0x806038,%eax
  803f46:	40                   	inc    %eax
  803f47:	a3 38 60 80 00       	mov    %eax,0x806038
  803f4c:	e9 cc 00 00 00       	jmp    80401d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803f58:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f60:	e9 8a 00 00 00       	jmp    803fef <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f6b:	73 7a                	jae    803fe7 <realloc_block_FF+0x44d>
  803f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f75:	73 70                	jae    803fe7 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f7b:	74 06                	je     803f83 <realloc_block_FF+0x3e9>
  803f7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f81:	75 17                	jne    803f9a <realloc_block_FF+0x400>
  803f83:	83 ec 04             	sub    $0x4,%esp
  803f86:	68 64 51 80 00       	push   $0x805164
  803f8b:	68 1a 02 00 00       	push   $0x21a
  803f90:	68 f1 50 80 00       	push   $0x8050f1
  803f95:	e8 f7 cc ff ff       	call   800c91 <_panic>
  803f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9d:	8b 10                	mov    (%eax),%edx
  803f9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa2:	89 10                	mov    %edx,(%eax)
  803fa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa7:	8b 00                	mov    (%eax),%eax
  803fa9:	85 c0                	test   %eax,%eax
  803fab:	74 0b                	je     803fb8 <realloc_block_FF+0x41e>
  803fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb0:	8b 00                	mov    (%eax),%eax
  803fb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fb5:	89 50 04             	mov    %edx,0x4(%eax)
  803fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fbe:	89 10                	mov    %edx,(%eax)
  803fc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fc6:	89 50 04             	mov    %edx,0x4(%eax)
  803fc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fcc:	8b 00                	mov    (%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	75 08                	jne    803fda <realloc_block_FF+0x440>
  803fd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fd5:	a3 30 60 80 00       	mov    %eax,0x806030
  803fda:	a1 38 60 80 00       	mov    0x806038,%eax
  803fdf:	40                   	inc    %eax
  803fe0:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803fe5:	eb 36                	jmp    80401d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803fe7:	a1 34 60 80 00       	mov    0x806034,%eax
  803fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff3:	74 07                	je     803ffc <realloc_block_FF+0x462>
  803ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff8:	8b 00                	mov    (%eax),%eax
  803ffa:	eb 05                	jmp    804001 <realloc_block_FF+0x467>
  803ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  804001:	a3 34 60 80 00       	mov    %eax,0x806034
  804006:	a1 34 60 80 00       	mov    0x806034,%eax
  80400b:	85 c0                	test   %eax,%eax
  80400d:	0f 85 52 ff ff ff    	jne    803f65 <realloc_block_FF+0x3cb>
  804013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804017:	0f 85 48 ff ff ff    	jne    803f65 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80401d:	83 ec 04             	sub    $0x4,%esp
  804020:	6a 00                	push   $0x0
  804022:	ff 75 d8             	pushl  -0x28(%ebp)
  804025:	ff 75 d4             	pushl  -0x2c(%ebp)
  804028:	e8 7a eb ff ff       	call   802ba7 <set_block_data>
  80402d:	83 c4 10             	add    $0x10,%esp
				return va;
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	e9 7b 02 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804038:	83 ec 0c             	sub    $0xc,%esp
  80403b:	68 e1 51 80 00       	push   $0x8051e1
  804040:	e8 09 cf ff ff       	call   800f4e <cprintf>
  804045:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804048:	8b 45 08             	mov    0x8(%ebp),%eax
  80404b:	e9 63 02 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804050:	8b 45 0c             	mov    0xc(%ebp),%eax
  804053:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804056:	0f 86 4d 02 00 00    	jbe    8042a9 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80405c:	83 ec 0c             	sub    $0xc,%esp
  80405f:	ff 75 e4             	pushl  -0x1c(%ebp)
  804062:	e8 08 e8 ff ff       	call   80286f <is_free_block>
  804067:	83 c4 10             	add    $0x10,%esp
  80406a:	84 c0                	test   %al,%al
  80406c:	0f 84 37 02 00 00    	je     8042a9 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804072:	8b 45 0c             	mov    0xc(%ebp),%eax
  804075:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804078:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80407b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80407e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804081:	76 38                	jbe    8040bb <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804083:	83 ec 0c             	sub    $0xc,%esp
  804086:	ff 75 08             	pushl  0x8(%ebp)
  804089:	e8 0c fa ff ff       	call   803a9a <free_block>
  80408e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804091:	83 ec 0c             	sub    $0xc,%esp
  804094:	ff 75 0c             	pushl  0xc(%ebp)
  804097:	e8 3a eb ff ff       	call   802bd6 <alloc_block_FF>
  80409c:	83 c4 10             	add    $0x10,%esp
  80409f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8040a2:	83 ec 08             	sub    $0x8,%esp
  8040a5:	ff 75 c0             	pushl  -0x40(%ebp)
  8040a8:	ff 75 08             	pushl  0x8(%ebp)
  8040ab:	e8 ab fa ff ff       	call   803b5b <copy_data>
  8040b0:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8040b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8040b6:	e9 f8 01 00 00       	jmp    8042b3 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8040bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040be:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8040c1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8040c4:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8040c8:	0f 87 a0 00 00 00    	ja     80416e <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8040ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040d2:	75 17                	jne    8040eb <realloc_block_FF+0x551>
  8040d4:	83 ec 04             	sub    $0x4,%esp
  8040d7:	68 d3 50 80 00       	push   $0x8050d3
  8040dc:	68 38 02 00 00       	push   $0x238
  8040e1:	68 f1 50 80 00       	push   $0x8050f1
  8040e6:	e8 a6 cb ff ff       	call   800c91 <_panic>
  8040eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ee:	8b 00                	mov    (%eax),%eax
  8040f0:	85 c0                	test   %eax,%eax
  8040f2:	74 10                	je     804104 <realloc_block_FF+0x56a>
  8040f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f7:	8b 00                	mov    (%eax),%eax
  8040f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040fc:	8b 52 04             	mov    0x4(%edx),%edx
  8040ff:	89 50 04             	mov    %edx,0x4(%eax)
  804102:	eb 0b                	jmp    80410f <realloc_block_FF+0x575>
  804104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804107:	8b 40 04             	mov    0x4(%eax),%eax
  80410a:	a3 30 60 80 00       	mov    %eax,0x806030
  80410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804112:	8b 40 04             	mov    0x4(%eax),%eax
  804115:	85 c0                	test   %eax,%eax
  804117:	74 0f                	je     804128 <realloc_block_FF+0x58e>
  804119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411c:	8b 40 04             	mov    0x4(%eax),%eax
  80411f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804122:	8b 12                	mov    (%edx),%edx
  804124:	89 10                	mov    %edx,(%eax)
  804126:	eb 0a                	jmp    804132 <realloc_block_FF+0x598>
  804128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412b:	8b 00                	mov    (%eax),%eax
  80412d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80413b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804145:	a1 38 60 80 00       	mov    0x806038,%eax
  80414a:	48                   	dec    %eax
  80414b:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804150:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804156:	01 d0                	add    %edx,%eax
  804158:	83 ec 04             	sub    $0x4,%esp
  80415b:	6a 01                	push   $0x1
  80415d:	50                   	push   %eax
  80415e:	ff 75 08             	pushl  0x8(%ebp)
  804161:	e8 41 ea ff ff       	call   802ba7 <set_block_data>
  804166:	83 c4 10             	add    $0x10,%esp
  804169:	e9 36 01 00 00       	jmp    8042a4 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80416e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804171:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804174:	01 d0                	add    %edx,%eax
  804176:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804179:	83 ec 04             	sub    $0x4,%esp
  80417c:	6a 01                	push   $0x1
  80417e:	ff 75 f0             	pushl  -0x10(%ebp)
  804181:	ff 75 08             	pushl  0x8(%ebp)
  804184:	e8 1e ea ff ff       	call   802ba7 <set_block_data>
  804189:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80418c:	8b 45 08             	mov    0x8(%ebp),%eax
  80418f:	83 e8 04             	sub    $0x4,%eax
  804192:	8b 00                	mov    (%eax),%eax
  804194:	83 e0 fe             	and    $0xfffffffe,%eax
  804197:	89 c2                	mov    %eax,%edx
  804199:	8b 45 08             	mov    0x8(%ebp),%eax
  80419c:	01 d0                	add    %edx,%eax
  80419e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8041a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041a5:	74 06                	je     8041ad <realloc_block_FF+0x613>
  8041a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8041ab:	75 17                	jne    8041c4 <realloc_block_FF+0x62a>
  8041ad:	83 ec 04             	sub    $0x4,%esp
  8041b0:	68 64 51 80 00       	push   $0x805164
  8041b5:	68 44 02 00 00       	push   $0x244
  8041ba:	68 f1 50 80 00       	push   $0x8050f1
  8041bf:	e8 cd ca ff ff       	call   800c91 <_panic>
  8041c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c7:	8b 10                	mov    (%eax),%edx
  8041c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041cc:	89 10                	mov    %edx,(%eax)
  8041ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041d1:	8b 00                	mov    (%eax),%eax
  8041d3:	85 c0                	test   %eax,%eax
  8041d5:	74 0b                	je     8041e2 <realloc_block_FF+0x648>
  8041d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041da:	8b 00                	mov    (%eax),%eax
  8041dc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041df:	89 50 04             	mov    %edx,0x4(%eax)
  8041e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041e8:	89 10                	mov    %edx,(%eax)
  8041ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041f0:	89 50 04             	mov    %edx,0x4(%eax)
  8041f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041f6:	8b 00                	mov    (%eax),%eax
  8041f8:	85 c0                	test   %eax,%eax
  8041fa:	75 08                	jne    804204 <realloc_block_FF+0x66a>
  8041fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ff:	a3 30 60 80 00       	mov    %eax,0x806030
  804204:	a1 38 60 80 00       	mov    0x806038,%eax
  804209:	40                   	inc    %eax
  80420a:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80420f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804213:	75 17                	jne    80422c <realloc_block_FF+0x692>
  804215:	83 ec 04             	sub    $0x4,%esp
  804218:	68 d3 50 80 00       	push   $0x8050d3
  80421d:	68 45 02 00 00       	push   $0x245
  804222:	68 f1 50 80 00       	push   $0x8050f1
  804227:	e8 65 ca ff ff       	call   800c91 <_panic>
  80422c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80422f:	8b 00                	mov    (%eax),%eax
  804231:	85 c0                	test   %eax,%eax
  804233:	74 10                	je     804245 <realloc_block_FF+0x6ab>
  804235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804238:	8b 00                	mov    (%eax),%eax
  80423a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80423d:	8b 52 04             	mov    0x4(%edx),%edx
  804240:	89 50 04             	mov    %edx,0x4(%eax)
  804243:	eb 0b                	jmp    804250 <realloc_block_FF+0x6b6>
  804245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804248:	8b 40 04             	mov    0x4(%eax),%eax
  80424b:	a3 30 60 80 00       	mov    %eax,0x806030
  804250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804253:	8b 40 04             	mov    0x4(%eax),%eax
  804256:	85 c0                	test   %eax,%eax
  804258:	74 0f                	je     804269 <realloc_block_FF+0x6cf>
  80425a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425d:	8b 40 04             	mov    0x4(%eax),%eax
  804260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804263:	8b 12                	mov    (%edx),%edx
  804265:	89 10                	mov    %edx,(%eax)
  804267:	eb 0a                	jmp    804273 <realloc_block_FF+0x6d9>
  804269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80426c:	8b 00                	mov    (%eax),%eax
  80426e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80427c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80427f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804286:	a1 38 60 80 00       	mov    0x806038,%eax
  80428b:	48                   	dec    %eax
  80428c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804291:	83 ec 04             	sub    $0x4,%esp
  804294:	6a 00                	push   $0x0
  804296:	ff 75 bc             	pushl  -0x44(%ebp)
  804299:	ff 75 b8             	pushl  -0x48(%ebp)
  80429c:	e8 06 e9 ff ff       	call   802ba7 <set_block_data>
  8042a1:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8042a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8042a7:	eb 0a                	jmp    8042b3 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8042a9:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8042b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8042b3:	c9                   	leave  
  8042b4:	c3                   	ret    

008042b5 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8042b5:	55                   	push   %ebp
  8042b6:	89 e5                	mov    %esp,%ebp
  8042b8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8042bb:	83 ec 04             	sub    $0x4,%esp
  8042be:	68 e8 51 80 00       	push   $0x8051e8
  8042c3:	68 58 02 00 00       	push   $0x258
  8042c8:	68 f1 50 80 00       	push   $0x8050f1
  8042cd:	e8 bf c9 ff ff       	call   800c91 <_panic>

008042d2 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8042d2:	55                   	push   %ebp
  8042d3:	89 e5                	mov    %esp,%ebp
  8042d5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8042d8:	83 ec 04             	sub    $0x4,%esp
  8042db:	68 10 52 80 00       	push   $0x805210
  8042e0:	68 61 02 00 00       	push   $0x261
  8042e5:	68 f1 50 80 00       	push   $0x8050f1
  8042ea:	e8 a2 c9 ff ff       	call   800c91 <_panic>

008042ef <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8042ef:	55                   	push   %ebp
  8042f0:	89 e5                	mov    %esp,%ebp
  8042f2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8042f5:	83 ec 04             	sub    $0x4,%esp
  8042f8:	68 38 52 80 00       	push   $0x805238
  8042fd:	6a 09                	push   $0x9
  8042ff:	68 60 52 80 00       	push   $0x805260
  804304:	e8 88 c9 ff ff       	call   800c91 <_panic>

00804309 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804309:	55                   	push   %ebp
  80430a:	89 e5                	mov    %esp,%ebp
  80430c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80430f:	83 ec 04             	sub    $0x4,%esp
  804312:	68 70 52 80 00       	push   $0x805270
  804317:	6a 10                	push   $0x10
  804319:	68 60 52 80 00       	push   $0x805260
  80431e:	e8 6e c9 ff ff       	call   800c91 <_panic>

00804323 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804323:	55                   	push   %ebp
  804324:	89 e5                	mov    %esp,%ebp
  804326:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  804329:	83 ec 04             	sub    $0x4,%esp
  80432c:	68 98 52 80 00       	push   $0x805298
  804331:	6a 18                	push   $0x18
  804333:	68 60 52 80 00       	push   $0x805260
  804338:	e8 54 c9 ff ff       	call   800c91 <_panic>

0080433d <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80433d:	55                   	push   %ebp
  80433e:	89 e5                	mov    %esp,%ebp
  804340:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804343:	83 ec 04             	sub    $0x4,%esp
  804346:	68 c0 52 80 00       	push   $0x8052c0
  80434b:	6a 20                	push   $0x20
  80434d:	68 60 52 80 00       	push   $0x805260
  804352:	e8 3a c9 ff ff       	call   800c91 <_panic>

00804357 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804357:	55                   	push   %ebp
  804358:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80435a:	8b 45 08             	mov    0x8(%ebp),%eax
  80435d:	8b 40 10             	mov    0x10(%eax),%eax
}
  804360:	5d                   	pop    %ebp
  804361:	c3                   	ret    

00804362 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804362:	55                   	push   %ebp
  804363:	89 e5                	mov    %esp,%ebp
  804365:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804368:	8b 55 08             	mov    0x8(%ebp),%edx
  80436b:	89 d0                	mov    %edx,%eax
  80436d:	c1 e0 02             	shl    $0x2,%eax
  804370:	01 d0                	add    %edx,%eax
  804372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804379:	01 d0                	add    %edx,%eax
  80437b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804382:	01 d0                	add    %edx,%eax
  804384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80438b:	01 d0                	add    %edx,%eax
  80438d:	c1 e0 04             	shl    $0x4,%eax
  804390:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80439a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80439d:	83 ec 0c             	sub    $0xc,%esp
  8043a0:	50                   	push   %eax
  8043a1:	e8 bc e1 ff ff       	call   802562 <sys_get_virtual_time>
  8043a6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8043a9:	eb 41                	jmp    8043ec <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8043ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8043ae:	83 ec 0c             	sub    $0xc,%esp
  8043b1:	50                   	push   %eax
  8043b2:	e8 ab e1 ff ff       	call   802562 <sys_get_virtual_time>
  8043b7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8043ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8043bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043c0:	29 c2                	sub    %eax,%edx
  8043c2:	89 d0                	mov    %edx,%eax
  8043c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8043c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043cd:	89 d1                	mov    %edx,%ecx
  8043cf:	29 c1                	sub    %eax,%ecx
  8043d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8043d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043d7:	39 c2                	cmp    %eax,%edx
  8043d9:	0f 97 c0             	seta   %al
  8043dc:	0f b6 c0             	movzbl %al,%eax
  8043df:	29 c1                	sub    %eax,%ecx
  8043e1:	89 c8                	mov    %ecx,%eax
  8043e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8043e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8043e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8043ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8043f2:	72 b7                	jb     8043ab <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8043f4:	90                   	nop
  8043f5:	c9                   	leave  
  8043f6:	c3                   	ret    

008043f7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8043f7:	55                   	push   %ebp
  8043f8:	89 e5                	mov    %esp,%ebp
  8043fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8043fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804404:	eb 03                	jmp    804409 <busy_wait+0x12>
  804406:	ff 45 fc             	incl   -0x4(%ebp)
  804409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80440c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80440f:	72 f5                	jb     804406 <busy_wait+0xf>
	return i;
  804411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804414:	c9                   	leave  
  804415:	c3                   	ret    
  804416:	66 90                	xchg   %ax,%ax

00804418 <__udivdi3>:
  804418:	55                   	push   %ebp
  804419:	57                   	push   %edi
  80441a:	56                   	push   %esi
  80441b:	53                   	push   %ebx
  80441c:	83 ec 1c             	sub    $0x1c,%esp
  80441f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804423:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80442b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80442f:	89 ca                	mov    %ecx,%edx
  804431:	89 f8                	mov    %edi,%eax
  804433:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804437:	85 f6                	test   %esi,%esi
  804439:	75 2d                	jne    804468 <__udivdi3+0x50>
  80443b:	39 cf                	cmp    %ecx,%edi
  80443d:	77 65                	ja     8044a4 <__udivdi3+0x8c>
  80443f:	89 fd                	mov    %edi,%ebp
  804441:	85 ff                	test   %edi,%edi
  804443:	75 0b                	jne    804450 <__udivdi3+0x38>
  804445:	b8 01 00 00 00       	mov    $0x1,%eax
  80444a:	31 d2                	xor    %edx,%edx
  80444c:	f7 f7                	div    %edi
  80444e:	89 c5                	mov    %eax,%ebp
  804450:	31 d2                	xor    %edx,%edx
  804452:	89 c8                	mov    %ecx,%eax
  804454:	f7 f5                	div    %ebp
  804456:	89 c1                	mov    %eax,%ecx
  804458:	89 d8                	mov    %ebx,%eax
  80445a:	f7 f5                	div    %ebp
  80445c:	89 cf                	mov    %ecx,%edi
  80445e:	89 fa                	mov    %edi,%edx
  804460:	83 c4 1c             	add    $0x1c,%esp
  804463:	5b                   	pop    %ebx
  804464:	5e                   	pop    %esi
  804465:	5f                   	pop    %edi
  804466:	5d                   	pop    %ebp
  804467:	c3                   	ret    
  804468:	39 ce                	cmp    %ecx,%esi
  80446a:	77 28                	ja     804494 <__udivdi3+0x7c>
  80446c:	0f bd fe             	bsr    %esi,%edi
  80446f:	83 f7 1f             	xor    $0x1f,%edi
  804472:	75 40                	jne    8044b4 <__udivdi3+0x9c>
  804474:	39 ce                	cmp    %ecx,%esi
  804476:	72 0a                	jb     804482 <__udivdi3+0x6a>
  804478:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80447c:	0f 87 9e 00 00 00    	ja     804520 <__udivdi3+0x108>
  804482:	b8 01 00 00 00       	mov    $0x1,%eax
  804487:	89 fa                	mov    %edi,%edx
  804489:	83 c4 1c             	add    $0x1c,%esp
  80448c:	5b                   	pop    %ebx
  80448d:	5e                   	pop    %esi
  80448e:	5f                   	pop    %edi
  80448f:	5d                   	pop    %ebp
  804490:	c3                   	ret    
  804491:	8d 76 00             	lea    0x0(%esi),%esi
  804494:	31 ff                	xor    %edi,%edi
  804496:	31 c0                	xor    %eax,%eax
  804498:	89 fa                	mov    %edi,%edx
  80449a:	83 c4 1c             	add    $0x1c,%esp
  80449d:	5b                   	pop    %ebx
  80449e:	5e                   	pop    %esi
  80449f:	5f                   	pop    %edi
  8044a0:	5d                   	pop    %ebp
  8044a1:	c3                   	ret    
  8044a2:	66 90                	xchg   %ax,%ax
  8044a4:	89 d8                	mov    %ebx,%eax
  8044a6:	f7 f7                	div    %edi
  8044a8:	31 ff                	xor    %edi,%edi
  8044aa:	89 fa                	mov    %edi,%edx
  8044ac:	83 c4 1c             	add    $0x1c,%esp
  8044af:	5b                   	pop    %ebx
  8044b0:	5e                   	pop    %esi
  8044b1:	5f                   	pop    %edi
  8044b2:	5d                   	pop    %ebp
  8044b3:	c3                   	ret    
  8044b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044b9:	89 eb                	mov    %ebp,%ebx
  8044bb:	29 fb                	sub    %edi,%ebx
  8044bd:	89 f9                	mov    %edi,%ecx
  8044bf:	d3 e6                	shl    %cl,%esi
  8044c1:	89 c5                	mov    %eax,%ebp
  8044c3:	88 d9                	mov    %bl,%cl
  8044c5:	d3 ed                	shr    %cl,%ebp
  8044c7:	89 e9                	mov    %ebp,%ecx
  8044c9:	09 f1                	or     %esi,%ecx
  8044cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044cf:	89 f9                	mov    %edi,%ecx
  8044d1:	d3 e0                	shl    %cl,%eax
  8044d3:	89 c5                	mov    %eax,%ebp
  8044d5:	89 d6                	mov    %edx,%esi
  8044d7:	88 d9                	mov    %bl,%cl
  8044d9:	d3 ee                	shr    %cl,%esi
  8044db:	89 f9                	mov    %edi,%ecx
  8044dd:	d3 e2                	shl    %cl,%edx
  8044df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044e3:	88 d9                	mov    %bl,%cl
  8044e5:	d3 e8                	shr    %cl,%eax
  8044e7:	09 c2                	or     %eax,%edx
  8044e9:	89 d0                	mov    %edx,%eax
  8044eb:	89 f2                	mov    %esi,%edx
  8044ed:	f7 74 24 0c          	divl   0xc(%esp)
  8044f1:	89 d6                	mov    %edx,%esi
  8044f3:	89 c3                	mov    %eax,%ebx
  8044f5:	f7 e5                	mul    %ebp
  8044f7:	39 d6                	cmp    %edx,%esi
  8044f9:	72 19                	jb     804514 <__udivdi3+0xfc>
  8044fb:	74 0b                	je     804508 <__udivdi3+0xf0>
  8044fd:	89 d8                	mov    %ebx,%eax
  8044ff:	31 ff                	xor    %edi,%edi
  804501:	e9 58 ff ff ff       	jmp    80445e <__udivdi3+0x46>
  804506:	66 90                	xchg   %ax,%ax
  804508:	8b 54 24 08          	mov    0x8(%esp),%edx
  80450c:	89 f9                	mov    %edi,%ecx
  80450e:	d3 e2                	shl    %cl,%edx
  804510:	39 c2                	cmp    %eax,%edx
  804512:	73 e9                	jae    8044fd <__udivdi3+0xe5>
  804514:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804517:	31 ff                	xor    %edi,%edi
  804519:	e9 40 ff ff ff       	jmp    80445e <__udivdi3+0x46>
  80451e:	66 90                	xchg   %ax,%ax
  804520:	31 c0                	xor    %eax,%eax
  804522:	e9 37 ff ff ff       	jmp    80445e <__udivdi3+0x46>
  804527:	90                   	nop

00804528 <__umoddi3>:
  804528:	55                   	push   %ebp
  804529:	57                   	push   %edi
  80452a:	56                   	push   %esi
  80452b:	53                   	push   %ebx
  80452c:	83 ec 1c             	sub    $0x1c,%esp
  80452f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804533:	8b 74 24 34          	mov    0x34(%esp),%esi
  804537:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80453b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80453f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804547:	89 f3                	mov    %esi,%ebx
  804549:	89 fa                	mov    %edi,%edx
  80454b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80454f:	89 34 24             	mov    %esi,(%esp)
  804552:	85 c0                	test   %eax,%eax
  804554:	75 1a                	jne    804570 <__umoddi3+0x48>
  804556:	39 f7                	cmp    %esi,%edi
  804558:	0f 86 a2 00 00 00    	jbe    804600 <__umoddi3+0xd8>
  80455e:	89 c8                	mov    %ecx,%eax
  804560:	89 f2                	mov    %esi,%edx
  804562:	f7 f7                	div    %edi
  804564:	89 d0                	mov    %edx,%eax
  804566:	31 d2                	xor    %edx,%edx
  804568:	83 c4 1c             	add    $0x1c,%esp
  80456b:	5b                   	pop    %ebx
  80456c:	5e                   	pop    %esi
  80456d:	5f                   	pop    %edi
  80456e:	5d                   	pop    %ebp
  80456f:	c3                   	ret    
  804570:	39 f0                	cmp    %esi,%eax
  804572:	0f 87 ac 00 00 00    	ja     804624 <__umoddi3+0xfc>
  804578:	0f bd e8             	bsr    %eax,%ebp
  80457b:	83 f5 1f             	xor    $0x1f,%ebp
  80457e:	0f 84 ac 00 00 00    	je     804630 <__umoddi3+0x108>
  804584:	bf 20 00 00 00       	mov    $0x20,%edi
  804589:	29 ef                	sub    %ebp,%edi
  80458b:	89 fe                	mov    %edi,%esi
  80458d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804591:	89 e9                	mov    %ebp,%ecx
  804593:	d3 e0                	shl    %cl,%eax
  804595:	89 d7                	mov    %edx,%edi
  804597:	89 f1                	mov    %esi,%ecx
  804599:	d3 ef                	shr    %cl,%edi
  80459b:	09 c7                	or     %eax,%edi
  80459d:	89 e9                	mov    %ebp,%ecx
  80459f:	d3 e2                	shl    %cl,%edx
  8045a1:	89 14 24             	mov    %edx,(%esp)
  8045a4:	89 d8                	mov    %ebx,%eax
  8045a6:	d3 e0                	shl    %cl,%eax
  8045a8:	89 c2                	mov    %eax,%edx
  8045aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045ae:	d3 e0                	shl    %cl,%eax
  8045b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045b8:	89 f1                	mov    %esi,%ecx
  8045ba:	d3 e8                	shr    %cl,%eax
  8045bc:	09 d0                	or     %edx,%eax
  8045be:	d3 eb                	shr    %cl,%ebx
  8045c0:	89 da                	mov    %ebx,%edx
  8045c2:	f7 f7                	div    %edi
  8045c4:	89 d3                	mov    %edx,%ebx
  8045c6:	f7 24 24             	mull   (%esp)
  8045c9:	89 c6                	mov    %eax,%esi
  8045cb:	89 d1                	mov    %edx,%ecx
  8045cd:	39 d3                	cmp    %edx,%ebx
  8045cf:	0f 82 87 00 00 00    	jb     80465c <__umoddi3+0x134>
  8045d5:	0f 84 91 00 00 00    	je     80466c <__umoddi3+0x144>
  8045db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045df:	29 f2                	sub    %esi,%edx
  8045e1:	19 cb                	sbb    %ecx,%ebx
  8045e3:	89 d8                	mov    %ebx,%eax
  8045e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045e9:	d3 e0                	shl    %cl,%eax
  8045eb:	89 e9                	mov    %ebp,%ecx
  8045ed:	d3 ea                	shr    %cl,%edx
  8045ef:	09 d0                	or     %edx,%eax
  8045f1:	89 e9                	mov    %ebp,%ecx
  8045f3:	d3 eb                	shr    %cl,%ebx
  8045f5:	89 da                	mov    %ebx,%edx
  8045f7:	83 c4 1c             	add    $0x1c,%esp
  8045fa:	5b                   	pop    %ebx
  8045fb:	5e                   	pop    %esi
  8045fc:	5f                   	pop    %edi
  8045fd:	5d                   	pop    %ebp
  8045fe:	c3                   	ret    
  8045ff:	90                   	nop
  804600:	89 fd                	mov    %edi,%ebp
  804602:	85 ff                	test   %edi,%edi
  804604:	75 0b                	jne    804611 <__umoddi3+0xe9>
  804606:	b8 01 00 00 00       	mov    $0x1,%eax
  80460b:	31 d2                	xor    %edx,%edx
  80460d:	f7 f7                	div    %edi
  80460f:	89 c5                	mov    %eax,%ebp
  804611:	89 f0                	mov    %esi,%eax
  804613:	31 d2                	xor    %edx,%edx
  804615:	f7 f5                	div    %ebp
  804617:	89 c8                	mov    %ecx,%eax
  804619:	f7 f5                	div    %ebp
  80461b:	89 d0                	mov    %edx,%eax
  80461d:	e9 44 ff ff ff       	jmp    804566 <__umoddi3+0x3e>
  804622:	66 90                	xchg   %ax,%ax
  804624:	89 c8                	mov    %ecx,%eax
  804626:	89 f2                	mov    %esi,%edx
  804628:	83 c4 1c             	add    $0x1c,%esp
  80462b:	5b                   	pop    %ebx
  80462c:	5e                   	pop    %esi
  80462d:	5f                   	pop    %edi
  80462e:	5d                   	pop    %ebp
  80462f:	c3                   	ret    
  804630:	3b 04 24             	cmp    (%esp),%eax
  804633:	72 06                	jb     80463b <__umoddi3+0x113>
  804635:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804639:	77 0f                	ja     80464a <__umoddi3+0x122>
  80463b:	89 f2                	mov    %esi,%edx
  80463d:	29 f9                	sub    %edi,%ecx
  80463f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804643:	89 14 24             	mov    %edx,(%esp)
  804646:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80464a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80464e:	8b 14 24             	mov    (%esp),%edx
  804651:	83 c4 1c             	add    $0x1c,%esp
  804654:	5b                   	pop    %ebx
  804655:	5e                   	pop    %esi
  804656:	5f                   	pop    %edi
  804657:	5d                   	pop    %ebp
  804658:	c3                   	ret    
  804659:	8d 76 00             	lea    0x0(%esi),%esi
  80465c:	2b 04 24             	sub    (%esp),%eax
  80465f:	19 fa                	sbb    %edi,%edx
  804661:	89 d1                	mov    %edx,%ecx
  804663:	89 c6                	mov    %eax,%esi
  804665:	e9 71 ff ff ff       	jmp    8045db <__umoddi3+0xb3>
  80466a:	66 90                	xchg   %ax,%ax
  80466c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804670:	72 ea                	jb     80465c <__umoddi3+0x134>
  804672:	89 d9                	mov    %ebx,%ecx
  804674:	e9 62 ff ff ff       	jmp    8045db <__umoddi3+0xb3>
